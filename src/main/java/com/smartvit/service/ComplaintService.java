package com.smartvit.service;

import com.smartvit.dao.*;
import com.smartvit.exception.ComplaintNotFoundException;
import com.smartvit.exception.InvalidStatusTransitionException;
import com.smartvit.exception.SmartVitException;
import com.smartvit.model.*;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.*;

/**
 * Service Implementation for Complaint Management in Smart VIT.
 * Demonstrates Interfaces (implements IComplaintService), Custom Exceptions,
 * and Collection Framework (List, Set, Map).
 */
public class ComplaintService implements IComplaintService {
    private final ComplaintDAO complaintDAO = new ComplaintDAO();
    private final MappingDAO mappingDAO = new MappingDAO();
    private final DepartmentDAO departmentDAO = new DepartmentDAO();
    private final DepartmentStaffDAO staffDAO = new DepartmentStaffDAO();
    private final ComplaintAssignmentDAO assignmentDAO = new ComplaintAssignmentDAO();
    private final ComplaintUpdateDAO updateDAO = new ComplaintUpdateDAO();
    private final SlaDAO slaDAO = new SlaDAO();
    private final NotificationService notificationService = new NotificationService();
    private final AuditLogDAO auditDAO = new AuditLogDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    public Complaint submitComplaint(Complaint complaint, String ipAddress) throws SmartVitException {
        if (complaint == null) {
            throw new SmartVitException("INVALID_INPUT", "Complaint payload cannot be null.");
        }

        // 1. Generate code
        String code = complaintDAO.generateComplaintCode();
        complaint.setComplaintCode(code);

        // 2. Automatic Department Allocation via DB mapping
        int departmentId = mappingDAO.findDepartmentForCategory(complaint.getCategoryId(), complaint.getSubcategoryId());
        complaint.setDepartmentId(departmentId);

        // 3. Find available technician / staff
        DepartmentStaff assignedStaff = staffDAO.findFirstAvailableByDepartment(departmentId);
        if (assignedStaff != null) {
            complaint.setAssignedStaffId(assignedStaff.getStaffId());
            complaint.setStatus("ASSIGNED");
        } else {
            complaint.setStatus("SUBMITTED");
        }

        // 4. Calculate SLA Due Date
        String priority = complaint.getPriority() != null ? complaint.getPriority().toUpperCase() : "MEDIUM";
        complaint.setPriority(priority);
        SlaRule sla = slaDAO.findByPriority(priority);
        int hours = (sla != null) ? sla.getMaxResolutionHours() : 48;
        LocalDateTime due = LocalDateTime.now().plusHours(hours);
        complaint.setDueDate(Timestamp.valueOf(due));
        complaint.setOverdue(false);

        // 5. Persist complaint
        boolean created = complaintDAO.create(complaint);
        if (!created) {
            throw new SmartVitException("DB_ERR", "Failed to persist complaint in database.");
        }

        Department dept = departmentDAO.findById(departmentId);
        String deptName = (dept != null) ? dept.getName() : "Maintenance";

        // 6. Record assignment
        ComplaintAssignment assignment = new ComplaintAssignment();
        assignment.setComplaintId(complaint.getComplaintId());
        assignment.setDepartmentId(departmentId);
        if (assignedStaff != null) {
            assignment.setStaffId(assignedStaff.getStaffId());
        }
        assignment.setAssignedBy(complaint.getComplainantId());
        assignment.setNotes("Automatically allocated to " + deptName + (assignedStaff != null ? " and technician " + assignedStaff.getStaffName() : ""));
        assignmentDAO.create(assignment);

        // 7. Initial Timeline History
        ComplaintUpdate initialUpdate = new ComplaintUpdate();
        initialUpdate.setComplaintId(complaint.getComplaintId());
        initialUpdate.setUpdatedBy(complaint.getComplainantId());
        initialUpdate.setOldStatus("NONE");
        initialUpdate.setNewStatus(complaint.getStatus());
        initialUpdate.setComment("Complaint submitted. Automatically allocated to " + deptName + ".");
        updateDAO.create(initialUpdate);

        // 8. Notifications
        notificationService.sendNotification(
            complaint.getComplainantId(),
            complaint.getComplaintId(),
            "Complaint Registered: " + code,
            "Your complaint '" + complaint.getTitle() + "' has been submitted and assigned to " + deptName + "."
        );

        List<DepartmentStaff> deptStaffList = staffDAO.findByDepartmentId(departmentId);
        for (DepartmentStaff ds : deptStaffList) {
            notificationService.sendNotification(
                ds.getUserId(),
                complaint.getComplaintId(),
                "New Complaint Assigned: " + code,
                "New complaint '" + complaint.getTitle() + "' (Priority: " + priority + ") has been assigned to your department."
            );
        }

        // 9. Audit Log
        auditDAO.log(complaint.getComplainantId(), "COMPLAINT_CREATED", "COMPLAINT", complaint.getComplaintId(), ipAddress, "Created complaint " + code);

        return complaint;
    }

    @Override
    public boolean updateStatus(int complaintId, String newStatus, String comment, Integer updatedByUserId, String ipAddress)
            throws ComplaintNotFoundException, InvalidStatusTransitionException, SmartVitException {
        return updateStatus(complaintId, updatedByUserId != null ? updatedByUserId : 0, newStatus, comment, null, ipAddress);
    }

    public boolean updateStatus(int complaintId, int staffUserId, String newStatus, String comment, String resolutionText, String ipAddress)
            throws ComplaintNotFoundException, InvalidStatusTransitionException, SmartVitException {
        Complaint c = complaintDAO.findById(complaintId);
        if (c == null) {
            throw new ComplaintNotFoundException(complaintId);
        }

        String oldStatus = c.getStatus();

        // Validate Status Workflow
        if ("CLOSED".equalsIgnoreCase(oldStatus) && !"REOPENED".equalsIgnoreCase(newStatus)) {
            throw new InvalidStatusTransitionException(oldStatus, newStatus);
        }

        boolean success = complaintDAO.updateStatus(complaintId, newStatus, resolutionText, staffUserId);
        if (success) {
            ComplaintUpdate u = new ComplaintUpdate();
            u.setComplaintId(complaintId);
            u.setUpdatedBy(staffUserId);
            u.setOldStatus(oldStatus);
            u.setNewStatus(newStatus);
            u.setComment(comment != null && !comment.trim().isEmpty() ? comment : "Status updated to " + newStatus);
            updateDAO.create(u);

            String title = "Complaint Update: " + c.getComplaintCode();
            String msg = "Your complaint status has changed to " + newStatus + ".";
            if ("RESOLVED".equalsIgnoreCase(newStatus)) {
                title = "Complaint Resolved: " + c.getComplaintCode();
                msg = "Your complaint has been resolved. Resolution: " + (resolutionText != null ? resolutionText : "Completed.") + " Please confirm resolution or reopen if needed.";
            }
            notificationService.sendNotification(c.getComplainantId(), complaintId, title, msg);

            auditDAO.log(staffUserId, "STATUS_CHANGED_" + newStatus, "COMPLAINT", complaintId, ipAddress, "Status changed from " + oldStatus + " to " + newStatus);
        }
        return success;
    }

    @Override
    public Complaint getComplaintDetails(int complaintId) throws ComplaintNotFoundException, SmartVitException {
        Complaint complaint = complaintDAO.findById(complaintId);
        if (complaint == null) {
            throw new ComplaintNotFoundException(complaintId);
        }
        return complaint;
    }

    @Override
    public List<Complaint> getComplaintsByStudent(int studentId) throws SmartVitException {
        return complaintDAO.findByComplainantId(studentId);
    }

    @Override
    public List<Complaint> getComplaintsByDepartment(int departmentId) throws SmartVitException {
        return complaintDAO.findByDepartmentId(departmentId);
    }

    @Override
    public List<Complaint> getOverdueComplaints() throws SmartVitException {
        return complaintDAO.findOverdueComplaints();
    }

    @Override
    public Map<String, Integer> getComplaintStatusMetrics() throws SmartVitException {
        // Demonstrates Map collection usage in Java framework
        Map<String, Integer> metricsMap = new HashMap<>();
        metricsMap.put("SUBMITTED", complaintDAO.countComplaints("SUBMITTED", null));
        metricsMap.put("ASSIGNED", complaintDAO.countComplaints("ASSIGNED", null));
        metricsMap.put("IN_PROGRESS", complaintDAO.countComplaints("IN_PROGRESS", null));
        metricsMap.put("RESOLVED", complaintDAO.countComplaints("RESOLVED", null));
        metricsMap.put("CLOSED", complaintDAO.countComplaints("CLOSED", null));
        metricsMap.put("REOPENED", complaintDAO.countComplaints("REOPENED", null));
        metricsMap.put("OVERDUE", complaintDAO.findOverdueComplaints().size());
        return metricsMap;
    }

    @Override
    public Set<String> getUniqueComplaintPriorities() throws SmartVitException {
        // Demonstrates Set collection usage for unique element filtering
        Set<String> prioritySet = new HashSet<>();
        List<Complaint> allComplaints = complaintDAO.findAll(100, 0, null, null);
        for (Complaint c : allComplaints) {
            if (c.getPriority() != null) {
                prioritySet.add(c.getPriority().toUpperCase());
            }
        }
        return prioritySet;
    }

    public boolean confirmResolution(int complaintId, int studentUserId, String comment, String ipAddress) throws SmartVitException {
        Complaint c = complaintDAO.findById(complaintId);
        if (c == null) throw new ComplaintNotFoundException(complaintId);
        if (c.getComplainantId() != studentUserId) {
            throw new SmartVitException("UNAUTHORIZED", "User not authorized to confirm resolution of this complaint.");
        }

        String oldStatus = c.getStatus();
        boolean success = complaintDAO.updateStatus(complaintId, "CLOSED", null, null);
        if (success) {
            ComplaintUpdate u = new ComplaintUpdate();
            u.setComplaintId(complaintId);
            u.setUpdatedBy(studentUserId);
            u.setOldStatus(oldStatus);
            u.setNewStatus("CLOSED");
            u.setComment(comment != null && !comment.trim().isEmpty() ? comment : "Student confirmed resolution. Complaint closed.");
            updateDAO.create(u);

            notifyDepartment(c, "Complaint Closed: " + c.getComplaintCode(), "The complainant confirmed resolution for complaint " + c.getComplaintCode() + ".");
            auditDAO.log(studentUserId, "COMPLAINT_CLOSED", "COMPLAINT", complaintId, ipAddress, "Student confirmed resolution");
        }
        return success;
    }

    public boolean reopenComplaint(int complaintId, int studentUserId, String reason, String ipAddress) throws SmartVitException {
        Complaint c = complaintDAO.findById(complaintId);
        if (c == null) throw new ComplaintNotFoundException(complaintId);
        if (c.getComplainantId() != studentUserId) {
            throw new SmartVitException("UNAUTHORIZED", "User not authorized to reopen this complaint.");
        }

        String oldStatus = c.getStatus();
        boolean success = complaintDAO.updateStatus(complaintId, "REOPENED", null, null);
        if (success) {
            ComplaintUpdate u = new ComplaintUpdate();
            u.setComplaintId(complaintId);
            u.setUpdatedBy(studentUserId);
            u.setOldStatus(oldStatus);
            u.setNewStatus("REOPENED");
            u.setComment("Reopened by complainant: " + (reason != null && !reason.trim().isEmpty() ? reason : "Issue persists."));
            updateDAO.create(u);

            notifyDepartment(c, "ALERT: Complaint Reopened: " + c.getComplaintCode(), 
                "Complaint #" + c.getComplaintCode() + " has been REOPENED by the student. Reason: " + reason);

            // Notify System Administrators
            List<User> admins = userDAO.findByRole("ADMIN");
            for (User admin : admins) {
                notificationService.sendNotification(admin.getUserId(), complaintId,
                    "ALERT: Complaint Reopened: " + c.getComplaintCode(),
                    "Complaint #" + c.getComplaintCode() + " has been REOPENED. Reason: " + reason);
            }

            auditDAO.log(studentUserId, "COMPLAINT_REOPENED", "COMPLAINT", complaintId, ipAddress, "Student reopened complaint: " + reason);
        }
        return success;
    }


    public boolean reassign(int complaintId, int newDeptId, Integer newStaffId, int adminUserId, String reason, String ipAddress) throws SmartVitException {
        Complaint c = complaintDAO.findById(complaintId);
        if (c == null) throw new ComplaintNotFoundException(complaintId);

        boolean success = complaintDAO.reassignDepartment(complaintId, newDeptId, newStaffId);
        if (success) {
            Department dept = departmentDAO.findById(newDeptId);
            String deptName = (dept != null) ? dept.getName() : "New Department";

            ComplaintAssignment a = new ComplaintAssignment();
            a.setComplaintId(complaintId);
            a.setDepartmentId(newDeptId);
            a.setStaffId(newStaffId);
            a.setAssignedBy(adminUserId);
            a.setNotes("Reassigned by Admin: " + reason);
            assignmentDAO.create(a);

            ComplaintUpdate u = new ComplaintUpdate();
            u.setComplaintId(complaintId);
            u.setUpdatedBy(adminUserId);
            u.setOldStatus(c.getStatus());
            u.setNewStatus("ASSIGNED");
            u.setComment("Reassigned to " + deptName + ". Notes: " + reason);
            updateDAO.create(u);

            notificationService.sendNotification(c.getComplainantId(), complaintId, "Complaint Reassigned: " + c.getComplaintCode(), "Your complaint has been reassigned to " + deptName + ".");
            notifyDepartment(c, "Complaint Reassigned to your department: " + c.getComplaintCode(), "Complaint " + c.getComplaintCode() + " has been reassigned to your department.");

            auditDAO.log(adminUserId, "COMPLAINT_REASSIGNED", "COMPLAINT", complaintId, ipAddress, "Reassigned to department " + newDeptId);
        }
        return success;
    }

    private void notifyDepartment(Complaint c, String title, String msg) {
        List<DepartmentStaff> deptStaffList = staffDAO.findByDepartmentId(c.getDepartmentId());
        for (DepartmentStaff ds : deptStaffList) {
            notificationService.sendNotification(ds.getUserId(), c.getComplaintId(), title, msg);
        }
    }
}

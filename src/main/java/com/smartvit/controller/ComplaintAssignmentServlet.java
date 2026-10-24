
package com.smartvit.controller;

import com.smartvit.dao.*;
import com.smartvit.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(urlPatterns = {
        "/department/assign-technician",
        "/admin/assign-complaint"
})
public class ComplaintAssignmentServlet extends HttpServlet {

    private final ComplaintDAO complaintDAO = new ComplaintDAO();
    private final ComplaintAssignmentDAO assignmentDAO = new ComplaintAssignmentDAO();
    private final ComplaintUpdateDAO updateDAO = new ComplaintUpdateDAO();
    private final DepartmentStaffDAO staffDAO = new DepartmentStaffDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User currentUser = session == null
                ? null : (User) session.getAttribute("currentUser");

        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        boolean adminRoute = req.getServletPath().startsWith("/admin/");

        // Admin route must be used by admins; department route by department staff.
        if (adminRoute && !currentUser.isAdmin()) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        if (!adminRoute && currentUser.isAdmin()) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String complaintIdStr = req.getParameter("complaintId");
        String staffIdStr = req.getParameter("staffId");

        if (staffIdStr == null || staffIdStr.trim().isEmpty()) {
            staffIdStr = req.getParameter("technicianId");
        }

        String notes = req.getParameter("notes");
        if (notes == null || notes.trim().isEmpty()) {
            notes = req.getParameter("assignmentNotes");
        }

        try {
            int complaintId = Integer.parseInt(complaintIdStr);
            int staffId = Integer.parseInt(staffIdStr);

            Complaint complaint = complaintDAO.findById(complaintId);
            DepartmentStaff staff = staffDAO.findById(staffId);

            if (complaint == null || staff == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND,
                        "Complaint or staff member not found.");
                return;
            }

            // Do not assign staff from a different department.
            if (staff.getDepartmentId() != complaint.getDepartmentId()) {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST,
                        "The selected staff member does not belong to the complaint department.");
                return;
            }

            // Department users may only assign complaints in their own department.
            if (!currentUser.isAdmin()) {
                 resp.sendError(HttpServletResponse.SC_FORBIDDEN,
            "Department ownership verification is not configured.");
                return;
            }
               

            /*
             * Keep this workflow from silently continuing when the core
             * technician assignment fails.
             */
            complaintDAO.assignTechnician(complaintId, staffId);

            ComplaintAssignment assignment = new ComplaintAssignment();
            assignment.setComplaintId(complaintId);
            assignment.setDepartmentId(complaint.getDepartmentId());
            assignment.setStaffId(staffId);
            assignment.setAssignedBy(currentUser.getUserId());
            assignment.setNotes(
                    notes == null || notes.trim().isEmpty()
                            ? "Assigned to technician " + staff.getStaffName()
                            : notes.trim()
            );
            assignmentDAO.create(assignment);

            ComplaintUpdate update = new ComplaintUpdate();
            update.setComplaintId(complaintId);
            update.setUpdatedBy(currentUser.getUserId());
            update.setOldStatus(complaint.getStatus());
            update.setNewStatus("ASSIGNED");
            update.setComment(
                    "Assigned to technician: " + staff.getStaffName()
                            + " (" + staff.getDesignation() + "). Notes: "
                            + (notes == null || notes.trim().isEmpty()
                                    ? "None" : notes.trim())
            );
            updateDAO.create(update);

            if (currentUser.isAdmin()) {
                resp.sendRedirect(req.getContextPath()
                        + "/admin/complaints?assigned=true");
            } else {
                resp.sendRedirect(req.getContextPath()
                        + "/department/complaint-details?id="
                        + complaintId + "&assigned=true");
            }

        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid complaint or staff ID.");
        }
    }
}

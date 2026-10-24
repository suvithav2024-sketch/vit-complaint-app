package com.smartvit.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class ComplaintAssignment implements Serializable {
    private static final long serialVersionUID = 1L;

    private int assignmentId;
    private int complaintId;
    private int departmentId;
    private String departmentName;
    private Integer staffId;
    private String staffName;
    private int assignedBy;
    private String assignedByName;
    private String notes;
    private Timestamp assignedAt;

    public ComplaintAssignment() {}

    public int getAssignmentId() { return assignmentId; }
    public void setAssignmentId(int assignmentId) { this.assignmentId = assignmentId; }

    public int getComplaintId() { return complaintId; }
    public void setComplaintId(int complaintId) { this.complaintId = complaintId; }

    public int getDepartmentId() { return departmentId; }
    public void setDepartmentId(int departmentId) { this.departmentId = departmentId; }

    public String getDepartmentName() { return departmentName; }
    public void setDepartmentName(String departmentName) { this.departmentName = departmentName; }

    public Integer getStaffId() { return staffId; }
    public void setStaffId(Integer staffId) { this.staffId = staffId; }

    public String getStaffName() { return staffName; }
    public void setStaffName(String staffName) { this.staffName = staffName; }

    public int getAssignedBy() { return assignedBy; }
    public void setAssignedBy(int assignedBy) { this.assignedBy = assignedBy; }

    public String getAssignedByName() { return assignedByName; }
    public void setAssignedByName(String assignedByName) { this.assignedByName = assignedByName; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public Timestamp getAssignedAt() { return assignedAt; }
    public void setAssignedAt(Timestamp assignedAt) { this.assignedAt = assignedAt; }

    // Alias getters for JSP EL compatibility
    public Integer getTechnicianId() { return staffId; }
    public String getTechnicianName() { return staffName != null ? staffName : "Unassigned Technician"; }
    public String getTechnicianDesignation() { return "Department Technician"; }
    public String getFormattedAssignedAt() {
        return assignedAt != null ? assignedAt.toString().substring(0, Math.min(19, assignedAt.toString().length())) : "";
    }
}


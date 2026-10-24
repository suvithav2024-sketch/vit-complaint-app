package com.smartvit.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Complaint implements Serializable {
    private static final long serialVersionUID = 1L;

    private int complaintId;
    private String complaintCode;
    private int complainantId;
    private String complainantName;
    private String complainantEmail;
    private String complainantRegNo;
    private String complainantPhone;

    private int categoryId;
    private String categoryName;
    private int subcategoryId;
    private String subcategoryName;

    private int locationId;
    private String locationDisplayName;
    private String buildingName;
    private String buildingCode;
    private String roomNumber;
    private int floor;
    private String block;

    private int departmentId;
    private String departmentName;
    private String departmentEmail;
    private String departmentPhone;

    private Integer assignedStaffId;
    private String assignedStaffName;
    private String assignedStaffPhone;
    private String assignedStaffEmail;

    private String title;
    private String description;
    private String priority; // LOW, MEDIUM, HIGH, URGENT
    private String status;   // SUBMITTED, ASSIGNED, ACKNOWLEDGED, IN_PROGRESS, RESOLVED, CLOSED, REOPENED
    private String resolutionText;
    private Integer resolvedBy;
    private String resolvedByName;
    private Timestamp resolvedAt;
    private Timestamp closedAt;
    private Timestamp reopenedAt;
    private Timestamp dueDate;
    private boolean overdue;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public Complaint() {}

    // Getters and Setters
    public int getComplaintId() { return complaintId; }
    public void setComplaintId(int complaintId) { this.complaintId = complaintId; }

    public String getComplaintCode() { return complaintCode; }
    public void setComplaintCode(String complaintCode) { this.complaintCode = complaintCode; }

    public int getComplainantId() { return complainantId; }
    public void setComplainantId(int complainantId) { this.complainantId = complainantId; }

    public String getComplainantName() { return complainantName; }
    public void setComplainantName(String complainantName) { this.complainantName = complainantName; }

    public String getComplainantEmail() { return complainantEmail; }
    public void setComplainantEmail(String complainantEmail) { this.complainantEmail = complainantEmail; }

    public String getComplainantRegNo() { return complainantRegNo; }
    public void setComplainantRegNo(String complainantRegNo) { this.complainantRegNo = complainantRegNo; }

    public String getComplainantPhone() { return complainantPhone; }
    public void setComplainantPhone(String complainantPhone) { this.complainantPhone = complainantPhone; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public int getSubcategoryId() { return subcategoryId; }
    public void setSubcategoryId(int subcategoryId) { this.subcategoryId = subcategoryId; }

    public String getSubcategoryName() { return subcategoryName; }
    public void setSubcategoryName(String subcategoryName) { this.subcategoryName = subcategoryName; }

    public int getLocationId() { return locationId; }
    public void setLocationId(int locationId) { this.locationId = locationId; }

    public String getLocationDisplayName() { return locationDisplayName; }
    public void setLocationDisplayName(String locationDisplayName) { this.locationDisplayName = locationDisplayName; }

    public String getLocationName() {
        if (locationDisplayName != null && !locationDisplayName.isEmpty()) return locationDisplayName;
        if (roomNumber != null && !roomNumber.isEmpty()) return roomNumber;
        return "N/A";
    }

    public String getBuildingName() { return buildingName; }
    public void setBuildingName(String buildingName) { this.buildingName = buildingName; }

    public String getBuildingCode() { return buildingCode; }
    public void setBuildingCode(String buildingCode) { this.buildingCode = buildingCode; }

    public String getRoomNumber() { return roomNumber; }
    public void setRoomNumber(String roomNumber) { this.roomNumber = roomNumber; }

    public int getFloor() { return floor; }
    public void setFloor(int floor) { this.floor = floor; }

    public String getBlock() { return block; }
    public void setBlock(String block) { this.block = block; }

    public int getDepartmentId() { return departmentId; }
    public void setDepartmentId(int departmentId) { this.departmentId = departmentId; }

    public String getDepartmentName() { return departmentName; }
    public void setDepartmentName(String departmentName) { this.departmentName = departmentName; }

    public String getDepartmentEmail() { return departmentEmail; }
    public void setDepartmentEmail(String departmentEmail) { this.departmentEmail = departmentEmail; }

    public String getDepartmentPhone() { return departmentPhone; }
    public void setDepartmentPhone(String departmentPhone) { this.departmentPhone = departmentPhone; }

    public Integer getAssignedStaffId() { return assignedStaffId; }
    public void setAssignedStaffId(Integer assignedStaffId) { this.assignedStaffId = assignedStaffId; }

    public String getAssignedStaffName() { return assignedStaffName; }
    public void setAssignedStaffName(String assignedStaffName) { this.assignedStaffName = assignedStaffName; }

    public String getAssignedStaffPhone() { return assignedStaffPhone; }
    public void setAssignedStaffPhone(String assignedStaffPhone) { this.assignedStaffPhone = assignedStaffPhone; }

    public String getAssignedStaffEmail() { return assignedStaffEmail; }
    public void setAssignedStaffEmail(String assignedStaffEmail) { this.assignedStaffEmail = assignedStaffEmail; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getPriority() { return priority; }
    public void setPriority(String priority) { this.priority = priority; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getResolutionText() { return resolutionText; }
    public void setResolutionText(String resolutionText) { this.resolutionText = resolutionText; }

    public Integer getResolvedBy() { return resolvedBy; }
    public void setResolvedBy(Integer resolvedBy) { this.resolvedBy = resolvedBy; }

    public String getResolvedByName() { return resolvedByName; }
    public void setResolvedByName(String resolvedByName) { this.resolvedByName = resolvedByName; }

    public Timestamp getResolvedAt() { return resolvedAt; }
    public void setResolvedAt(Timestamp resolvedAt) { this.resolvedAt = resolvedAt; }

    public Timestamp getClosedAt() { return closedAt; }
    public void setClosedAt(Timestamp closedAt) { this.closedAt = closedAt; }

    public Timestamp getReopenedAt() { return reopenedAt; }
    public void setReopenedAt(Timestamp reopenedAt) { this.reopenedAt = reopenedAt; }

    public Timestamp getDueDate() { return dueDate; }
    public void setDueDate(Timestamp dueDate) { this.dueDate = dueDate; }

    public boolean isOverdue() { return overdue; }
    public void setOverdue(boolean overdue) { this.overdue = overdue; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    // Alias getters for JSP EL compatibility
    public int getId() { return complaintId; }
    public String getFilerName() { return complainantName != null ? complainantName : "Anonymous"; }
    public String getFilerEmail() { return complainantEmail != null ? complainantEmail : ""; }
    public String getFilerRegNo() { return complainantRegNo != null ? complainantRegNo : ""; }
    public String getSubCategoryName() { return subcategoryName; }
    public String getAssignedToName() { return assignedStaffName; }
    public String getFormattedCreatedAt() {
        return createdAt != null ? createdAt.toString().substring(0, Math.min(19, createdAt.toString().length())) : "";
    }

    // Helpers for UI badges
    public String getStatusBadgeClass() {
        if (status == null) return "bg-secondary";
        switch (status.toUpperCase()) {
            case "SUBMITTED": return "bg-primary";
            case "ASSIGNED": return "bg-info text-dark";
            case "ACKNOWLEDGED": return "bg-primary-subtle text-primary border border-primary";
            case "IN_PROGRESS": return "bg-warning text-dark";
            case "RESOLVED": return "bg-success";
            case "CLOSED": return "bg-dark";
            case "REOPENED": return "bg-danger";
            default: return "bg-secondary";
        }
    }

    public String getPriorityBadgeClass() {
        if (priority == null) return "bg-secondary";
        switch (priority.toUpperCase()) {
            case "URGENT": return "bg-danger";
            case "HIGH": return "bg-warning text-dark";
            case "MEDIUM": return "bg-info text-dark";
            case "LOW": return "bg-secondary";
            default: return "bg-secondary";
        }
    }
}


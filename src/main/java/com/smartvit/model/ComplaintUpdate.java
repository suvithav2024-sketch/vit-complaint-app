package com.smartvit.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class ComplaintUpdate implements Serializable {
    private static final long serialVersionUID = 1L;

    private int updateId;
    private int complaintId;
    private int updatedBy;
    private String updatedByName;
    private String oldStatus;
    private String newStatus;
    private String comment;
    private Timestamp createdAt;

    public ComplaintUpdate() {}

    public int getUpdateId() { return updateId; }
    public void setUpdateId(int updateId) { this.updateId = updateId; }

    public int getComplaintId() { return complaintId; }
    public void setComplaintId(int complaintId) { this.complaintId = complaintId; }

    public int getUpdatedBy() { return updatedBy; }
    public void setUpdatedBy(int updatedBy) { this.updatedBy = updatedBy; }

    public String getUpdatedByName() { return updatedByName; }
    public void setUpdatedByName(String updatedByName) { this.updatedByName = updatedByName; }

    public String getOldStatus() { return oldStatus; }
    public void setOldStatus(String oldStatus) { this.oldStatus = oldStatus; }

    public String getNewStatus() { return newStatus; }
    public void setNewStatus(String newStatus) { this.newStatus = newStatus; }

    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }

    // Alias getters for JSP EL compatibility
    public String getRemarks() { return comment != null ? comment : ""; }
    public String getFormattedUpdatedAt() {
        return createdAt != null ? createdAt.toString().substring(0, Math.min(19, createdAt.toString().length())) : "";
    }
    public String getNewStatusBadgeClass() {
        if (newStatus == null) return "bg-secondary";
        switch (newStatus.toUpperCase()) {
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

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}


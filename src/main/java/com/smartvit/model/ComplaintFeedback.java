package com.smartvit.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class ComplaintFeedback implements Serializable {
    private static final long serialVersionUID = 1L;

    private int feedbackId;
    private int complaintId;
    private String complaintCode;
    private int userId;
    private String userName;
    private boolean problemSolved;
    private int rating; // 1 to 5
    private String comment;
    private Timestamp createdAt;

    public ComplaintFeedback() {}

    public int getFeedbackId() { return feedbackId; }
    public void setFeedbackId(int feedbackId) { this.feedbackId = feedbackId; }

    public int getComplaintId() { return complaintId; }
    public void setComplaintId(int complaintId) { this.complaintId = complaintId; }

    public String getComplaintCode() { return complaintCode; }
    public void setComplaintCode(String complaintCode) { this.complaintCode = complaintCode; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public boolean isProblemSolved() { return problemSolved; }
    public void setProblemSolved(boolean problemSolved) { this.problemSolved = problemSolved; }

    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }

    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}

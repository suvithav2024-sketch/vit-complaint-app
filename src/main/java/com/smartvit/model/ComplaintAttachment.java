package com.smartvit.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class ComplaintAttachment implements Serializable {
    private static final long serialVersionUID = 1L;

    private int attachmentId;
    private int complaintId;
    private String fileName;
    private String filePath;
    private String fileType;
    private long fileSize;
    private String attachmentType; // INITIAL, RESOLUTION_PROOF
    private int uploadedBy;
    private String uploadedByName;
    private Timestamp createdAt;

    public ComplaintAttachment() {}

    public int getAttachmentId() { return attachmentId; }
    public void setAttachmentId(int attachmentId) { this.attachmentId = attachmentId; }

    public int getComplaintId() { return complaintId; }
    public void setComplaintId(int complaintId) { this.complaintId = complaintId; }

    public String getFileName() { return fileName; }
    public void setFileName(String fileName) { this.fileName = fileName; }

    public String getFilePath() { return filePath; }
    public void setFilePath(String filePath) { this.filePath = filePath; }

    public String getFileType() { return fileType; }
    public void setFileType(String fileType) { this.fileType = fileType; }

    public long getFileSize() { return fileSize; }
    public void setFileSize(long fileSize) { this.fileSize = fileSize; }

    public String getAttachmentType() { return attachmentType; }
    public void setAttachmentType(String attachmentType) { this.attachmentType = attachmentType; }

    public int getUploadedBy() { return uploadedBy; }
    public void setUploadedBy(int uploadedBy) { this.uploadedBy = uploadedBy; }

    public String getUploadedByName() { return uploadedByName; }
    public void setUploadedByName(String uploadedByName) { this.uploadedByName = uploadedByName; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    // Alias getter
    public String getOriginalName() { return fileName != null ? fileName : "attachment"; }
}


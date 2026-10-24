package com.smartvit.exception;

/**
 * Custom exception thrown when a requested complaint cannot be found.
 */
public class ComplaintNotFoundException extends SmartVitException {

    public ComplaintNotFoundException(int complaintId) {
        super("COMPLAINT_NOT_FOUND", "Complaint with ID " + complaintId + " was not found in Smart VIT.");
    }

    public ComplaintNotFoundException(String complaintCode) {
        super("COMPLAINT_NOT_FOUND", "Complaint with code " + complaintCode + " was not found in Smart VIT.");
    }
}

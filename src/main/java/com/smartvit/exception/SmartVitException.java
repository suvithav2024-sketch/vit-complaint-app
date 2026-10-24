package com.smartvit.exception;

/**
 * Base custom exception class for the Smart VIT Complaint Management System.
 * Demonstrates user-defined exception handling hierarchy.
 */
public class SmartVitException extends Exception {
    private final String errorCode;

    public SmartVitException(String message) {
        super(message);
        this.errorCode = "SMART_VIT_ERR";
    }

    public SmartVitException(String message, Throwable cause) {
        super(message, cause);
        this.errorCode = "SMART_VIT_ERR";
    }

    public SmartVitException(String errorCode, String message) {
        super(message);
        this.errorCode = errorCode;
    }

    public SmartVitException(String errorCode, String message, Throwable cause) {
        super(message, cause);
        this.errorCode = errorCode;
    }

    public String getErrorCode() {
        return errorCode;
    }
}

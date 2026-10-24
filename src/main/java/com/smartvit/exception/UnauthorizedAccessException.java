package com.smartvit.exception;

/**
 * Custom exception thrown when a user attempts an unauthorized operation.
 */
public class UnauthorizedAccessException extends SmartVitException {

    public UnauthorizedAccessException(String message) {
        super("UNAUTHORIZED_ACCESS", message);
    }
}

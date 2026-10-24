package com.smartvit.exception;

/**
 * Custom exception thrown when an invalid complaint status transition is attempted.
 */
public class InvalidStatusTransitionException extends SmartVitException {

    public InvalidStatusTransitionException(String currentStatus, String targetStatus) {
        super("INVALID_STATUS_TRANSITION", 
              "Cannot transition complaint status from '" + currentStatus + "' to '" + targetStatus + "'.");
    }
}

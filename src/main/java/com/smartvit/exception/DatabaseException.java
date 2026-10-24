package com.smartvit.exception;

/**
 * Custom exception thrown when JDBC operations encounter failures in Smart VIT.
 */
public class DatabaseException extends SmartVitException {

    public DatabaseException(String message) {
        super("DB_ERR", message);
    }

    public DatabaseException(String message, Throwable cause) {
        super("DB_ERR", message, cause);
    }
}

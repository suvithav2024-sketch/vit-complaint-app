package com.smartvit.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Robust Database Connection Manager for SMART VIT.
 * Supports configurable connection parameters via:
 * 1. Environment variables (DB_URL, DB_HOST, DB_PORT, DB_NAME, DB_USER, DB_PASSWORD)
 * 2. System properties
 * 3. Classpath db.properties file
 * 4. Production fallback defaults
 */
public class DBConnection {
    private static final Logger LOGGER = Logger.getLogger(DBConnection.class.getName());

    private static String jdbcUrl;
    private static String dbUser;
    private static String dbPassword;
    private static String dbDriver = "com.mysql.cj.jdbc.Driver";

    static {
        loadConfiguration();
    }

    private static synchronized void loadConfiguration() {
        try {
            // Check for explicit full DB_URL first
            String envUrl = System.getenv("DB_URL");
            if (envUrl == null || envUrl.trim().isEmpty()) {
                envUrl = System.getProperty("db.url");
            }

            // Defaults
            String host = "localhost";
            String port = "3306";
            String dbName = "smart_vit_complaints";
            String user = "root";
            String password = "";

            // Attempt to load db.properties
            Properties props = new Properties();
            try (InputStream in = DBConnection.class.getClassLoader().getResourceAsStream("db.properties")) {
                if (in != null) {
                    props.load(in);
                    if (props.getProperty("db.driver") != null) dbDriver = props.getProperty("db.driver");
                    if (props.getProperty("db.host") != null) host = props.getProperty("db.host");
                    if (props.getProperty("db.port") != null) port = props.getProperty("db.port");
                    if (props.getProperty("db.name") != null) dbName = props.getProperty("db.name");
                    if (props.getProperty("db.user") != null) user = props.getProperty("db.user");
                    if (props.getProperty("db.password") != null) password = props.getProperty("db.password");
                }
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Failed to read db.properties, using defaults", e);
            }

            // Allow environment variables to override
            if (System.getenv("DB_HOST") != null) host = System.getenv("DB_HOST");
            if (System.getenv("DB_PORT") != null) port = System.getenv("DB_PORT");
            if (System.getenv("DB_NAME") != null) dbName = System.getenv("DB_NAME");
            if (System.getenv("DB_USER") != null) user = System.getenv("DB_USER");
            if (System.getenv("DB_PASSWORD") != null) password = System.getenv("DB_PASSWORD");

            // Allow system properties to override
            if (System.getProperty("db.host") != null) host = System.getProperty("db.host");
            if (System.getProperty("db.port") != null) port = System.getProperty("db.port");
            if (System.getProperty("db.name") != null) dbName = System.getProperty("db.name");
            if (System.getProperty("db.user") != null) user = System.getProperty("db.user");
            if (System.getProperty("db.password") != null) password = System.getProperty("db.password");

            dbUser = user;
            dbPassword = password;

            if (envUrl != null && !envUrl.trim().isEmpty()) {
                jdbcUrl = envUrl;
            } else {
                jdbcUrl = "jdbc:mysql://" + host + ":" + port + "/" + dbName +
                          "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=Asia/Kolkata&characterEncoding=UTF-8";
            }

            Class.forName(dbDriver);
            LOGGER.info("DBConnection initialized successfully for: " + jdbcUrl);
        } catch (ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "MySQL JDBC Driver not found: " + dbDriver, e);
            throw new RuntimeException("MySQL JDBC Driver missing", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        if (jdbcUrl == null) {
            loadConfiguration();
        }
        return DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
    }

    public static void close(AutoCloseable... closeables) {
        for (AutoCloseable c : closeables) {
            if (c != null) {
                try {
                    c.close();
                } catch (Exception ignored) {}
            }
        }
    }
}

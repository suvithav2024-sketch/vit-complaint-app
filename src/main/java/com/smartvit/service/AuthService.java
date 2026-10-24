package com.smartvit.service;

import com.smartvit.dao.AuditLogDAO;
import com.smartvit.dao.UserDAO;
import com.smartvit.model.User;
import com.smartvit.util.PasswordUtil;

public class AuthService {
    private final UserDAO userDAO = new UserDAO();
    private final AuditLogDAO auditDAO = new AuditLogDAO();

    public User authenticate(String identifier, String password, String ipAddress) {
        if (identifier == null || password == null) return null;
        identifier = identifier.trim();

        User user = null;
        if (identifier.contains("@")) {
            user = userDAO.findByEmail(identifier);
        } else {
            user = userDAO.findByRegEmpNo(identifier);
        }

        if (user != null && user.isActive()) {
            if (PasswordUtil.checkPassword(password, user.getPasswordHash())) {
                auditDAO.log(user.getUserId(), "LOGIN_SUCCESS", "USER", user.getUserId(), ipAddress, "User logged in: " + user.getEmail());
                return user;
            } else {
                auditDAO.log(user.getUserId(), "LOGIN_FAILED", "USER", user.getUserId(), ipAddress, "Invalid password attempt for: " + identifier);
            }
        } else if (user != null && !user.isActive()) {
            auditDAO.log(user.getUserId(), "LOGIN_BLOCKED", "USER", user.getUserId(), ipAddress, "Inactive user tried to log in: " + identifier);
        } else {
            auditDAO.log(null, "LOGIN_UNKNOWN", "USER", null, ipAddress, "Non-existent user attempted: " + identifier);
        }
        return null;
    }

    public String register(User user, String plainPassword, String ipAddress) {
        // Validation
        if (user.getFullName() == null || user.getFullName().trim().isEmpty()) {
            return "Full Name is required.";
        }
        if (user.getEmail() == null || !user.getEmail().contains("@")) {
            return "Valid Email address is required.";
        }
        if (user.getRegEmpNo() == null || user.getRegEmpNo().trim().isEmpty()) {
            return "Register Number / Employee ID is required.";
        }
        if (plainPassword == null || plainPassword.length() < 6) {
            return "Password must be at least 6 characters.";
        }

        // Unique checks
        if (userDAO.findByEmail(user.getEmail()) != null) {
            return "Email is already registered. Please login instead.";
        }
        if (userDAO.findByRegEmpNo(user.getRegEmpNo()) != null) {
            return "Register Number / Employee ID is already registered.";
        }

        user.setPasswordHash(PasswordUtil.hashPassword(plainPassword));
        user.setActive(true);

        boolean success = userDAO.create(user);
        if (success) {
            auditDAO.log(user.getUserId(), "REGISTER_SUCCESS", "USER", user.getUserId(), ipAddress, "New registration for: " + user.getEmail());
            return null; // Null means success
        } else {
            return "Database error during registration. Please try again.";
        }
    }
}

package com.smartvit.controller;

import com.smartvit.model.User;
import com.smartvit.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String regEmpNo = req.getParameter("regEmpNo");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String phone = req.getParameter("phone");
        String roleType = req.getParameter("roleType"); // STUDENT or STAFF
        String schoolDept = req.getParameter("schoolDept");
        String hostelBlock = req.getParameter("hostelBlock");
        String roomNo = req.getParameter("roomNo");

        // Validate basic fields
        if (password == null || !password.equals(confirmPassword)) {
            req.setAttribute("errorMessage", "Passwords do not match.");
            forwardWithInput(req, resp);
            return;
        }

        int roleId = 2; // Default STUDENT
        if ("STAFF".equalsIgnoreCase(roleType)) {
            roleId = 3;
        }

        User user = new User();
        user.setFullName(fullName != null ? fullName.trim() : "");
        user.setEmail(email != null ? email.trim().toLowerCase() : "");
        user.setRegEmpNo(regEmpNo != null ? regEmpNo.trim().toUpperCase() : "");
        user.setPhone(phone != null ? phone.trim() : "");
        user.setRoleId(roleId);
        user.setSchoolDept(schoolDept != null ? schoolDept.trim() : "");
        user.setHostelBlock(hostelBlock != null ? hostelBlock.trim() : "");
        user.setRoomNo(roomNo != null ? roomNo.trim() : "");

        String error = authService.register(user, password, req.getRemoteAddr());
        if (error != null) {
            req.setAttribute("errorMessage", error);
            forwardWithInput(req, resp);
        } else {
            req.setAttribute("successMessage", "Registration successful! You can now log in with your credentials.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }

    private void forwardWithInput(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("fullName", req.getParameter("fullName"));
        req.setAttribute("email", req.getParameter("email"));
        req.setAttribute("regEmpNo", req.getParameter("regEmpNo"));
        req.setAttribute("phone", req.getParameter("phone"));
        req.setAttribute("roleType", req.getParameter("roleType"));
        req.setAttribute("schoolDept", req.getParameter("schoolDept"));
        req.setAttribute("hostelBlock", req.getParameter("hostelBlock"));
        req.setAttribute("roomNo", req.getParameter("roomNo"));
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }
}

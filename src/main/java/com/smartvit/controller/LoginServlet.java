package com.smartvit.controller;

import com.smartvit.model.User;
import com.smartvit.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("currentUser") != null) {
            User user = (User) session.getAttribute("currentUser");
            redirectToDashboard(user, req, resp);
            return;
        }

        String returnUrl = req.getParameter("returnUrl");
        if (returnUrl != null && !returnUrl.trim().isEmpty()) {
            req.setAttribute("returnUrl", returnUrl);
        }

        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String identifier = req.getParameter("identifier");
        String password = req.getParameter("password");
        String returnUrl = req.getParameter("returnUrl");
        String clientIp = req.getRemoteAddr();

        if (identifier == null || identifier.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            req.setAttribute("errorMessage", "VIT Email / Register Number and Password are required.");
            req.setAttribute("returnUrl", returnUrl);
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        User user = authService.authenticate(identifier, password, clientIp);
        if (user != null) {
            // Create HttpSession
            HttpSession session = req.getSession(true);
            session.setAttribute("currentUser", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("name", user.getFullName());
            session.setAttribute("email", user.getEmail());
            session.setAttribute("role", user.getRoleName());
            session.setAttribute("regEmpNo", user.getRegEmpNo());
            session.setMaxInactiveInterval(30 * 60); // 30 minutes session timeout

            // If QR code or returnUrl was passed, redirect there
            if (returnUrl != null && !returnUrl.trim().isEmpty() && !returnUrl.contains("login") && !returnUrl.contains("logout")) {
                try {
                    String decodedUrl = URLDecoder.decode(returnUrl, StandardCharsets.UTF_8);
                    if (decodedUrl.startsWith("/")) {
                        resp.sendRedirect(req.getContextPath() + decodedUrl);
                        return;
                    }
                } catch (Exception ignored) {}
            }

            redirectToDashboard(user, req, resp);
        } else {
            req.setAttribute("errorMessage", "Invalid VIT Email/Register Number or Password.");
            req.setAttribute("identifier", identifier);
            req.setAttribute("returnUrl", returnUrl);
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }

    private void redirectToDashboard(User user, HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String cp = req.getContextPath();
        String role = user.getRoleName();
        if ("STUDENT".equalsIgnoreCase(role)) {
            resp.sendRedirect(cp + "/student/dashboard");
        } else if ("STAFF".equalsIgnoreCase(role)) {
            resp.sendRedirect(cp + "/staff/dashboard");
        } else if ("DEPARTMENT_STAFF".equalsIgnoreCase(role)) {
            resp.sendRedirect(cp + "/department/dashboard");
        } else if ("ADMIN".equalsIgnoreCase(role)) {
            resp.sendRedirect(cp + "/admin/dashboard");
        } else {
            resp.sendRedirect(cp + "/login");
        }
    }
}

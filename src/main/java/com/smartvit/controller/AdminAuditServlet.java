package com.smartvit.controller;

import com.smartvit.dao.AuditLogDAO;
import com.smartvit.model.AuditLog;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/audit-logs")
public class AdminAuditServlet extends HttpServlet {
    private final AuditLogDAO auditDAO = new AuditLogDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int limit = 50;
        List<AuditLog> logs = auditDAO.findRecent(limit);
        req.setAttribute("logs", logs);
        req.getRequestDispatcher("/admin/auditLogs.jsp").forward(req, resp);
    }
}

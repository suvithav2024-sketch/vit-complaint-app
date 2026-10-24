package com.smartvit.controller;

import com.smartvit.model.User;
import com.smartvit.service.ComplaintService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/student/reopen-complaint")
public class ComplaintReopenServlet extends HttpServlet {
    private final ComplaintService complaintService = new ComplaintService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("currentUser");

        String complaintIdStr = req.getParameter("complaintId");
        String reason = req.getParameter("reason");

        if (complaintIdStr != null && !complaintIdStr.isEmpty()) {
            try {
                int complaintId = Integer.parseInt(complaintIdStr);
                boolean success = complaintService.reopenComplaint(complaintId, user.getUserId(), reason, req.getRemoteAddr());
                if (success) {
                    resp.sendRedirect(req.getContextPath() + "/student/complaint-details?id=" + complaintId + "&reopened=true");
                    return;
                }
            } catch (Exception ignored) {}
        }

        resp.sendRedirect(req.getContextPath() + "/student/my-complaints");
    }
}

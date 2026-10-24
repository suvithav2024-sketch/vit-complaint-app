package com.smartvit.controller;

import com.smartvit.dao.ComplaintDAO;
import com.smartvit.dao.NotificationDAO;
import com.smartvit.model.Complaint;
import com.smartvit.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/student/dashboard")
public class StudentDashboardServlet extends HttpServlet {
    private final ComplaintDAO complaintDAO = new ComplaintDAO();
    private final NotificationDAO notificationDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("currentUser");

        int userId = user.getUserId();

        // Metric cards
        int total = complaintDAO.countByComplainant(userId, null, null, null);
        int pending = complaintDAO.countByStatus(userId, null, "SUBMITTED") + complaintDAO.countByStatus(userId, null, "ASSIGNED");
        int inProgress = complaintDAO.countByStatus(userId, null, "IN_PROGRESS") + complaintDAO.countByStatus(userId, null, "ACKNOWLEDGED");
        int resolved = complaintDAO.countByStatus(userId, null, "RESOLVED");
        int closed = complaintDAO.countByStatus(userId, null, "CLOSED");
        int reopened = complaintDAO.countByStatus(userId, null, "REOPENED");

        // Recent complaints (last 5)
        List<Complaint> recentComplaints = complaintDAO.findByComplainant(userId, null, null, null, 5, 0);

        // Unread notifications
        int unreadNotifs = notificationDAO.countUnread(userId);

        req.setAttribute("totalComplaints", total);
        req.setAttribute("pendingComplaints", pending);
        req.setAttribute("inProgressComplaints", inProgress);
        req.setAttribute("resolvedComplaints", resolved);
        req.setAttribute("closedComplaints", closed);
        req.setAttribute("reopenedComplaints", reopened);
        req.setAttribute("recentComplaints", recentComplaints);
        req.setAttribute("unreadCount", unreadNotifs);

        req.getRequestDispatcher("/student/dashboard.jsp").forward(req, resp);
    }
}

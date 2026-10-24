package com.smartvit.controller;

import com.smartvit.dao.ComplaintDAO;
import com.smartvit.dao.NotificationDAO;
import com.smartvit.model.Complaint;
import com.smartvit.model.User;
import com.smartvit.service.ReportService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private final ReportService reportService = new ReportService();
    private final ComplaintDAO complaintDAO = new ComplaintDAO();
    private final NotificationDAO notificationDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        // Refresh overdue flags in database
        complaintDAO.updateOverdueFlags();

        Map<String, Object> stats = reportService.getDashboardStats();
        List<Complaint> recentComplaints = complaintDAO.findAll(null, null, null, null, null, 10, 0);
        List<Complaint> overdueComplaints = complaintDAO.findOverdueComplaints(5);
        int unreadNotifs = notificationDAO.countUnread(currentUser.getUserId());

        req.setAttribute("stats", stats);
        req.setAttribute("recentComplaints", recentComplaints);
        req.setAttribute("overdueComplaints", overdueComplaints);
        req.setAttribute("unreadCount", unreadNotifs);

        req.getRequestDispatcher("/admin/dashboard.jsp").forward(req, resp);
    }
}

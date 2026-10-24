package com.smartvit.controller;

import com.smartvit.dao.ComplaintDAO;
import com.smartvit.dao.DepartmentStaffDAO;
import com.smartvit.dao.NotificationDAO;
import com.smartvit.model.Complaint;
import com.smartvit.model.DepartmentStaff;
import com.smartvit.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/department/dashboard")
public class DepartmentDashboardServlet extends HttpServlet {
    private final ComplaintDAO complaintDAO = new ComplaintDAO();
    private final DepartmentStaffDAO staffDAO = new DepartmentStaffDAO();
    private final NotificationDAO notificationDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        DepartmentStaff staff = staffDAO.findByUserId(currentUser.getUserId());
        if (staff == null) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "No department profile linked to this user.");
            return;
        }

        int deptId = staff.getDepartmentId();

        // Status counts for this department
        int total = complaintDAO.countByDepartment(deptId, null, null, null);
        int assigned = complaintDAO.countByStatus(null, deptId, "ASSIGNED") + complaintDAO.countByStatus(null, deptId, "SUBMITTED");
        int inProgress = complaintDAO.countByStatus(null, deptId, "IN_PROGRESS") + complaintDAO.countByStatus(null, deptId, "ACKNOWLEDGED");
        int resolved = complaintDAO.countByStatus(null, deptId, "RESOLVED");
        int closed = complaintDAO.countByStatus(null, deptId, "CLOSED");
        int reopened = complaintDAO.countByStatus(null, deptId, "REOPENED");
        int overdue = complaintDAO.countOverdue(null, deptId);

        // Recent complaints queue
        List<Complaint> recentComplaints = complaintDAO.findByDepartment(deptId, null, null, null, 8, 0);
        int unreadNotifs = notificationDAO.countUnread(currentUser.getUserId());

        req.setAttribute("staff", staff);
        req.setAttribute("totalComplaints", total);
        req.setAttribute("assignedCount", assigned);
        req.setAttribute("inProgressCount", inProgress);
        req.setAttribute("resolvedCount", resolved);
        req.setAttribute("closedCount", closed);
        req.setAttribute("reopenedCount", reopened);
        req.setAttribute("overdueCount", overdue);
        req.setAttribute("recentComplaints", recentComplaints);
        req.setAttribute("unreadCount", unreadNotifs);

        req.getRequestDispatcher("/department/dashboard.jsp").forward(req, resp);
    }
}

package com.smartvit.controller;

import com.smartvit.dao.ComplaintDAO;
import com.smartvit.dao.DepartmentStaffDAO;
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

@WebServlet("/department/complaints")
public class DepartmentComplaintsServlet extends HttpServlet {
    private final ComplaintDAO complaintDAO = new ComplaintDAO();
    private final DepartmentStaffDAO staffDAO = new DepartmentStaffDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        DepartmentStaff staff = staffDAO.findByUserId(currentUser.getUserId());
        if (staff == null) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Not authorized.");
            return;
        }

        int deptId = staff.getDepartmentId();
        String statusFilter = req.getParameter("status");
        String priorityFilter = req.getParameter("priority");
        String search = req.getParameter("search");

        int page = 1;
        int limit = 15;
        String pageStr = req.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Math.max(1, Integer.parseInt(pageStr));
            } catch (NumberFormatException ignored) {}
        }
        int offset = (page - 1) * limit;

        List<Complaint> complaints = complaintDAO.findByDepartment(deptId, statusFilter, priorityFilter, search, limit, offset);
        int totalCount = complaintDAO.countByDepartment(deptId, statusFilter, priorityFilter, search);
        int totalPages = (int) Math.ceil((double) totalCount / limit);

        req.setAttribute("staff", staff);
        req.setAttribute("complaints", complaints);
        req.setAttribute("totalCount", totalCount);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("statusFilter", statusFilter);
        req.setAttribute("priorityFilter", priorityFilter);
        req.setAttribute("search", search);

        req.getRequestDispatcher("/department/complaints.jsp").forward(req, resp);
    }
}

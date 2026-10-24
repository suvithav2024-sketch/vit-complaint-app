package com.smartvit.controller;

import com.smartvit.dao.CategoryDAO;
import com.smartvit.dao.ComplaintDAO;
import com.smartvit.dao.DepartmentDAO;
import com.smartvit.dao.DepartmentStaffDAO;
import com.smartvit.model.Category;
import com.smartvit.model.Complaint;
import com.smartvit.model.Department;
import com.smartvit.model.DepartmentStaff;
import com.smartvit.model.User;
import com.smartvit.service.ComplaintService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/complaints")
public class AdminComplaintsServlet extends HttpServlet {
    private final ComplaintDAO complaintDAO = new ComplaintDAO();
    private final DepartmentDAO departmentDAO = new DepartmentDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final DepartmentStaffDAO staffDAO = new DepartmentStaffDAO();
    private final ComplaintService complaintService = new ComplaintService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String deptFilter = req.getParameter("department");
        String catFilter = req.getParameter("category");
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

        List<Complaint> complaints = complaintDAO.findAll(deptFilter, statusFilter, priorityFilter, catFilter, search, limit, offset);
        int totalCount = complaintDAO.countAll(deptFilter, statusFilter, priorityFilter, catFilter, search);
        int totalPages = (int) Math.ceil((double) totalCount / limit);

        List<Department> departments = departmentDAO.findAllActive();
        List<Category> categories = categoryDAO.findAllActive();
        List<DepartmentStaff> staffList = staffDAO.findAll();

        req.setAttribute("complaints", complaints);
        req.setAttribute("departments", departments);
        req.setAttribute("categories", categories);
        req.setAttribute("staffList", staffList);
        req.setAttribute("totalCount", totalCount);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("deptFilter", deptFilter);
        req.setAttribute("catFilter", catFilter);
        req.setAttribute("statusFilter", statusFilter);
        req.setAttribute("priorityFilter", priorityFilter);
        req.setAttribute("search", search);

        req.getRequestDispatcher("/admin/complaints.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User adminUser = (User) session.getAttribute("currentUser");

        String action = req.getParameter("action");
        if ("reassign".equals(action)) {
            int complaintId = Integer.parseInt(req.getParameter("complaintId"));
            int deptId = Integer.parseInt(req.getParameter("departmentId"));
            String staffIdStr = req.getParameter("staffId");
            Integer staffId = (staffIdStr != null && !staffIdStr.isEmpty()) ? Integer.parseInt(staffIdStr) : null;
            String reason = req.getParameter("reason");

            try {
                complaintService.reassign(complaintId, deptId, staffId, adminUser.getUserId(), reason, req.getRemoteAddr());
                resp.sendRedirect(req.getContextPath() + "/admin/complaints?reassigned=true");
            } catch (Exception e) {
                resp.sendRedirect(req.getContextPath() + "/admin/complaints?error=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
            }
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/admin/complaints");
    }
}

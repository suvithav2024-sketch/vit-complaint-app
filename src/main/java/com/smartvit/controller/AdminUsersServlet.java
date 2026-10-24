package com.smartvit.controller;

import com.smartvit.dao.AuditLogDAO;
import com.smartvit.dao.UserDAO;
import com.smartvit.model.User;
import com.smartvit.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/users")
public class AdminUsersServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private final AuditLogDAO auditDAO = new AuditLogDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String search = req.getParameter("search");
        String roleFilter = req.getParameter("role");

        int page = 1;
        int limit = 15;
        String pageStr = req.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Math.max(1, Integer.parseInt(pageStr));
            } catch (NumberFormatException ignored) {}
        }
        int offset = (page - 1) * limit;

        List<User> users = userDAO.findAll(limit, offset, search, roleFilter);
        int totalCount = userDAO.countAll(search, roleFilter);
        int totalPages = (int) Math.ceil((double) totalCount / limit);

        req.setAttribute("users", users);
        req.setAttribute("totalCount", totalCount);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("search", search);
        req.setAttribute("roleFilter", roleFilter);

        req.getRequestDispatcher("/admin/users.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User adminUser = (User) session.getAttribute("currentUser");

        String action = req.getParameter("action");
        if ("toggleStatus".equals(action)) {
            int userId = Integer.parseInt(req.getParameter("userId"));
            boolean active = Boolean.parseBoolean(req.getParameter("active"));
            userDAO.toggleStatus(userId, active);
            auditDAO.log(adminUser.getUserId(), "USER_STATUS_TOGGLE", "USER", userId, req.getRemoteAddr(), "Set active=" + active);
            resp.sendRedirect(req.getContextPath() + "/admin/users?statusChanged=true");
            return;
        } else if ("create".equals(action)) {
            String fullName = req.getParameter("fullName");
            String email = req.getParameter("email");
            String regEmpNo = req.getParameter("regEmpNo");
            String password = req.getParameter("password");
            String phone = req.getParameter("phone");
            int roleId = Integer.parseInt(req.getParameter("roleId"));
            String schoolDept = req.getParameter("schoolDept");

            User u = new User();
            u.setFullName(fullName);
            u.setEmail(email);
            u.setRegEmpNo(regEmpNo);
            u.setPasswordHash(PasswordUtil.hashPassword(password));
            u.setPhone(phone);
            u.setRoleId(roleId);
            u.setSchoolDept(schoolDept);
            u.setActive(true);

            userDAO.create(u);
            auditDAO.log(adminUser.getUserId(), "USER_CREATED_BY_ADMIN", "USER", u.getUserId(), req.getRemoteAddr(), "Created user: " + email);
            resp.sendRedirect(req.getContextPath() + "/admin/users?created=true");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }
}

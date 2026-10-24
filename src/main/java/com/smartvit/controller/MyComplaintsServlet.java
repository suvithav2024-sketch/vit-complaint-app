package com.smartvit.controller;

import com.smartvit.dao.CategoryDAO;
import com.smartvit.dao.ComplaintDAO;
import com.smartvit.model.Category;
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

@WebServlet(urlPatterns = {"/student/my-complaints", "/staff/my-complaints"})
public class MyComplaintsServlet extends HttpServlet {
    private final ComplaintDAO complaintDAO = new ComplaintDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        String statusFilter = req.getParameter("status");
        String priorityFilter = req.getParameter("priority");
        String search = req.getParameter("search");

        int page = 1;
        int limit = 10;
        String pageStr = req.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Math.max(1, Integer.parseInt(pageStr));
            } catch (NumberFormatException ignored) {}
        }
        int offset = (page - 1) * limit;

        List<Complaint> complaints = complaintDAO.findByComplainant(currentUser.getUserId(), statusFilter, priorityFilter, search, limit, offset);
        int totalCount = complaintDAO.countByComplainant(currentUser.getUserId(), statusFilter, priorityFilter, search);
        int totalPages = (int) Math.ceil((double) totalCount / limit);

        List<Category> categories = categoryDAO.findAllActive();

        req.setAttribute("complaints", complaints);
        req.setAttribute("totalCount", totalCount);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("statusFilter", statusFilter);
        req.setAttribute("priorityFilter", priorityFilter);
        req.setAttribute("search", search);
        req.setAttribute("categories", categories);

        String jspPath = currentUser.isStaff() ? "/staff/myComplaints.jsp" : "/student/myComplaints.jsp";
        req.getRequestDispatcher(jspPath).forward(req, resp);
    }
}

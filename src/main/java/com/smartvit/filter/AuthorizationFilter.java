package com.smartvit.filter;

import com.smartvit.dao.ComplaintDAO;
import com.smartvit.dao.DepartmentStaffDAO;
import com.smartvit.model.Complaint;
import com.smartvit.model.DepartmentStaff;
import com.smartvit.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(urlPatterns = {
    "/student/*",
    "/staff/*",
    "/department/*",
    "/admin/*",
    "/complaint/*"
})
public class AuthorizationFilter implements Filter {

    private final ComplaintDAO complaintDAO = new ComplaintDAO();
    private final DepartmentStaffDAO staffDAO = new DepartmentStaffDAO();

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (user == null) {
            // Unauthenticated requests are handled by AuthenticationFilter
            chain.doFilter(request, response);
            return;
        }

        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();
        String path = uri.substring(contextPath.length());
        String role = user.getRoleName();

        // 1. Role URL prefixes
        if (path.startsWith("/student/") && !"STUDENT".equalsIgnoreCase(role)) {
            renderAccessDenied(req, res, "Students only. Your role: " + role);
            return;
        }

        if (path.startsWith("/staff/") && !"STAFF".equalsIgnoreCase(role)) {
            renderAccessDenied(req, res, "Staff only. Your role: " + role);
            return;
        }

        if (path.startsWith("/department/") && !"DEPARTMENT_STAFF".equalsIgnoreCase(role)) {
            renderAccessDenied(req, res, "Department Staff only. Your role: " + role);
            return;
        }

        if (path.startsWith("/admin/") && !"ADMIN".equalsIgnoreCase(role)) {
            renderAccessDenied(req, res, "Administrator privileges required. Your role: " + role);
            return;
        }

        // 2. Department-specific complaint access control (department staff can ONLY access complaints of their department)
        if ("DEPARTMENT_STAFF".equalsIgnoreCase(role)) {
            String complaintIdStr = req.getParameter("id");
            if (complaintIdStr != null && !complaintIdStr.isEmpty()) {
                try {
                    int complaintId = Integer.parseInt(complaintIdStr);
                    Complaint c = complaintDAO.findById(complaintId);
                    if (c != null) {
                        DepartmentStaff staff = staffDAO.findByUserId(user.getUserId());
                        if (staff != null && staff.getDepartmentId() != c.getDepartmentId()) {
                            renderAccessDenied(req, res, "You are only authorized to view complaints assigned to your department (" + staff.getDepartmentName() + ").");
                            return;
                        }
                    }
                } catch (NumberFormatException ignored) {}
            }
        }

        // 3. Student/Staff personal complaint isolation
        if ("STUDENT".equalsIgnoreCase(role) || "STAFF".equalsIgnoreCase(role)) {
            String complaintIdStr = req.getParameter("id");
            if (path.contains("complaint") && complaintIdStr != null && !complaintIdStr.isEmpty()) {
                try {
                    int complaintId = Integer.parseInt(complaintIdStr);
                    Complaint c = complaintDAO.findById(complaintId);
                    if (c != null && c.getComplainantId() != user.getUserId()) {
                        renderAccessDenied(req, res, "You are not authorized to view complaints filed by other users.");
                        return;
                    }
                } catch (NumberFormatException ignored) {}
            }
        }

        chain.doFilter(request, response);
    }

    private void renderAccessDenied(HttpServletRequest req, HttpServletResponse res, String message) throws ServletException, IOException {
        res.setStatus(HttpServletResponse.SC_FORBIDDEN);
        req.setAttribute("errorMessage", message);
        req.getRequestDispatcher("/error/403.jsp").forward(req, res);
    }
}

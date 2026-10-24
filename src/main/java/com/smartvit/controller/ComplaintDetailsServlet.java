package com.smartvit.controller;

import com.smartvit.dao.*;
import com.smartvit.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/student/complaint-details", "/staff/complaint-details", "/complaint/details"})
public class ComplaintDetailsServlet extends HttpServlet {
    private final ComplaintDAO complaintDAO = new ComplaintDAO();
    private final ComplaintUpdateDAO updateDAO = new ComplaintUpdateDAO();
    private final ComplaintAssignmentDAO assignmentDAO = new ComplaintAssignmentDAO();
    private final ComplaintAttachmentDAO attachmentDAO = new ComplaintAttachmentDAO();
    private final FeedbackDAO feedbackDAO = new FeedbackDAO();
    private final NotificationDAO notificationDAO = new NotificationDAO();
    private final DepartmentStaffDAO staffDAO = new DepartmentStaffDAO();
    private final DepartmentDAO departmentDAO = new DepartmentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        jakarta.servlet.http.HttpSession session = req.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            String q = req.getQueryString() != null ? "?" + req.getQueryString() : "";
            resp.sendRedirect(req.getContextPath() + "/login?returnUrl=" + java.net.URLEncoder.encode(req.getRequestURI() + q, "UTF-8"));
            return;
        }

        String idStr = req.getParameter("id");
        String codeStr = req.getParameter("code");

        Complaint complaint = null;
        if (idStr != null && !idStr.isEmpty()) {
            try {
                complaint = complaintDAO.findById(Integer.parseInt(idStr));
            } catch (NumberFormatException ignored) {}
        } else if (codeStr != null && !codeStr.isEmpty()) {
            complaint = complaintDAO.findByCode(codeStr);
        }

        if (complaint == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Complaint not found");
            return;
        }

        // Strict Ownership & Permission Validation
        if (currentUser.isStudent()) {
            if (complaint.getComplainantId() != currentUser.getUserId()) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: You cannot view complaints belonging to another student.");
                return;
            }
        } else if (currentUser.isDepartmentStaff()) {
            DepartmentStaff staff = staffDAO.findByUserId(currentUser.getUserId());
            if (staff == null || staff.getDepartmentId() != complaint.getDepartmentId()) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: This complaint is not assigned to your department.");
                return;
            }
            notificationDAO.markAsReadByComplaint(complaint.getComplaintId(), currentUser.getUserId());
            resp.sendRedirect(req.getContextPath() + "/department/complaint-details?id=" + complaint.getComplaintId());
            return;
        } else if (currentUser.isStaff() && !currentUser.isAdmin()) {
            if (complaint.getComplainantId() != currentUser.getUserId()) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: You can only view complaints submitted by you.");
                return;
            }
        }

        // Auto-mark notifications for this complaint as read
        notificationDAO.markAsReadByComplaint(complaint.getComplaintId(), currentUser.getUserId());

        List<ComplaintUpdate> updates = updateDAO.findByComplaintId(complaint.getComplaintId());
        List<ComplaintAssignment> assignments = assignmentDAO.findByComplaintId(complaint.getComplaintId());
        List<ComplaintAttachment> attachments = attachmentDAO.findByComplaintId(complaint.getComplaintId());
        ComplaintFeedback feedback = feedbackDAO.findByComplaintId(complaint.getComplaintId());

        req.setAttribute("complaint", complaint);
        req.setAttribute("updates", updates);
        req.setAttribute("assignments", assignments);
        req.setAttribute("attachments", attachments);
        req.setAttribute("feedback", feedback);

        if (currentUser.isAdmin()) {
            req.setAttribute("departments", departmentDAO.findAllActive());
            req.setAttribute("staffList", staffDAO.findAll());
        }

        req.getRequestDispatcher("/student/complaintDetails.jsp").forward(req, resp);
    }
}


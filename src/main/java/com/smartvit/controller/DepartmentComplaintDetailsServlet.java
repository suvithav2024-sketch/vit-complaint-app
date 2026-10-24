package com.smartvit.controller;

import com.smartvit.dao.*;
import com.smartvit.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/department/complaint-details")
public class DepartmentComplaintDetailsServlet extends HttpServlet {
    private final ComplaintDAO complaintDAO = new ComplaintDAO();
    private final ComplaintUpdateDAO updateDAO = new ComplaintUpdateDAO();
    private final ComplaintAssignmentDAO assignmentDAO = new ComplaintAssignmentDAO();
    private final ComplaintAttachmentDAO attachmentDAO = new ComplaintAttachmentDAO();
    private final DepartmentStaffDAO staffDAO = new DepartmentStaffDAO();
    private final FeedbackDAO feedbackDAO = new FeedbackDAO();
    private final NotificationDAO notificationDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        DepartmentStaff currentStaff = staffDAO.findByUserId(currentUser.getUserId());
        if (currentStaff == null && !currentUser.isAdmin()) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Not authorized: No department profile linked.");
            return;
        }

        String idStr = req.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/department/complaints");
            return;
        }

        try {
            int complaintId = Integer.parseInt(idStr);
            Complaint complaint = complaintDAO.findById(complaintId);

            if (complaint == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Complaint not found");
                return;
            }

            if (!currentUser.isAdmin() && currentStaff != null && complaint.getDepartmentId() != currentStaff.getDepartmentId()) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "You do not have access to this complaint.");
                return;
            }

            // Auto-mark notifications as read
            notificationDAO.markAsReadByComplaint(complaintId, currentUser.getUserId());

            List<ComplaintUpdate> updates = updateDAO.findByComplaintId(complaintId);
            List<ComplaintAssignment> assignments = assignmentDAO.findByComplaintId(complaintId);
            List<ComplaintAttachment> attachments = attachmentDAO.findByComplaintId(complaintId);
            int targetDeptId = (currentStaff != null) ? currentStaff.getDepartmentId() : complaint.getDepartmentId();
            List<DepartmentStaff> deptTechnicians = staffDAO.findByDepartmentId(targetDeptId);
            ComplaintFeedback feedback = feedbackDAO.findByComplaintId(complaintId);

            req.setAttribute("complaint", complaint);
            req.setAttribute("updates", updates);
            req.setAttribute("assignments", assignments);
            req.setAttribute("assignment", assignments.isEmpty() ? null : assignments.get(assignments.size() - 1));
            req.setAttribute("attachments", attachments);
            req.setAttribute("deptTechnicians", deptTechnicians);
            req.setAttribute("technicians", deptTechnicians);
            req.setAttribute("currentStaff", currentStaff);
            req.setAttribute("feedback", feedback);

            req.getRequestDispatcher("/department/complaintDetails.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/department/complaints");
        }
    }
}

package com.smartvit.controller;

import com.smartvit.dao.ComplaintDAO;
import com.smartvit.dao.FeedbackDAO;
import com.smartvit.model.Complaint;
import com.smartvit.model.ComplaintFeedback;
import com.smartvit.model.User;
import com.smartvit.service.ComplaintService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/student/feedback")
public class FeedbackServlet extends HttpServlet {
    private final FeedbackDAO feedbackDAO = new FeedbackDAO();
    private final ComplaintDAO complaintDAO = new ComplaintDAO();
    private final ComplaintService complaintService = new ComplaintService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String complaintIdStr = req.getParameter("complaintId");
        String problemSolvedStr = req.getParameter("problemSolved");
        String ratingStr = req.getParameter("rating");
        String comment = req.getParameter("comment");

        if (complaintIdStr == null || ratingStr == null) {
            resp.sendRedirect(req.getContextPath() + "/student/my-complaints");
            return;
        }

        try {
            int complaintId = Integer.parseInt(complaintIdStr);
            Complaint complaint = complaintDAO.findById(complaintId);
            if (complaint == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Complaint not found");
                return;
            }

            // Only original complaint owner can submit feedback
            if (complaint.getComplainantId() != user.getUserId()) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Only the student who raised this complaint can submit feedback.");
                return;
            }

            // Prevent duplicate feedback
            if (feedbackDAO.findByComplaintId(complaintId) != null) {
                resp.sendRedirect(req.getContextPath() + "/student/complaint-details?id=" + complaintId + "&error=feedback_already_exists");
                return;
            }

            // Feedback eligible only for RESOLVED or CLOSED complaints
            if (!"RESOLVED".equalsIgnoreCase(complaint.getStatus()) && !"CLOSED".equalsIgnoreCase(complaint.getStatus())) {
                resp.sendRedirect(req.getContextPath() + "/student/complaint-details?id=" + complaintId + "&error=not_resolved");
                return;
            }

            int rating = Integer.parseInt(ratingStr);
            rating = Math.max(1, Math.min(5, rating));
            boolean problemSolved = "true".equalsIgnoreCase(problemSolvedStr) || "1".equals(problemSolvedStr) || "yes".equalsIgnoreCase(problemSolvedStr);

            ComplaintFeedback fb = new ComplaintFeedback();
            fb.setComplaintId(complaintId);
            fb.setUserId(user.getUserId());
            fb.setProblemSolved(problemSolved);
            fb.setRating(rating);
            fb.setComment(comment != null ? comment.trim() : "");
            feedbackDAO.create(fb);

            if (problemSolved) {
                // If student confirmed problem solved and status was RESOLVED, formally close the complaint
                if ("RESOLVED".equalsIgnoreCase(complaint.getStatus())) {
                    complaintService.confirmResolution(complaintId, user.getUserId(),
                        "Problem resolved satisfactorily. Rating: " + rating + "/5 stars. " + (comment != null ? comment : ""),
                        req.getRemoteAddr());
                }
                resp.sendRedirect(req.getContextPath() + "/student/complaint-details?id=" + complaintId + "&feedback=submitted&confirmed=true");
            } else {
                // If student reported problem NOT solved, save feedback and trigger reopening workflow
                String reopenNote = "Problem not solved (Student Rating: " + rating + "/5). " + (comment != null && !comment.trim().isEmpty() ? comment : "Issue persists.");
                complaintService.reopenComplaint(complaintId, user.getUserId(), reopenNote, req.getRemoteAddr());
                resp.sendRedirect(req.getContextPath() + "/student/complaint-details?id=" + complaintId + "&feedback=submitted&reopened=true");
            }
            return;
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/student/my-complaints?error=feedback_failed");
        }
    }
}

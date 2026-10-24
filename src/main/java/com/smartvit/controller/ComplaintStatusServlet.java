package com.smartvit.controller;

import com.smartvit.dao.ComplaintAttachmentDAO;
import com.smartvit.dao.ComplaintDAO;
import com.smartvit.model.Complaint;
import com.smartvit.model.ComplaintAttachment;
import com.smartvit.model.User;
import com.smartvit.service.ComplaintService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

@WebServlet("/department/update-status")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 25
)
public class ComplaintStatusServlet extends HttpServlet {
    private final ComplaintService complaintService = new ComplaintService();
    private final ComplaintAttachmentDAO attachmentDAO = new ComplaintAttachmentDAO();
    private final ComplaintDAO complaintDAO = new ComplaintDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String complaintIdStr = req.getParameter("complaintId");
        String newStatus = req.getParameter("newStatus");
        String action = req.getParameter("action");
        String comment = req.getParameter("comment");
        if (comment == null || comment.trim().isEmpty()) {
            comment = req.getParameter("remarks");
        }
        String resolutionText = req.getParameter("resolutionText");

        // Handle explicit acknowledge action
        if ("acknowledge".equalsIgnoreCase(action)) {
            newStatus = "ACKNOWLEDGED";
            if (comment == null || comment.trim().isEmpty()) {
                comment = "Complaint assignment acknowledged by " + currentUser.getFullName();
            }
        }

        if (complaintIdStr == null || newStatus == null || newStatus.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/department/complaints");
            return;
        }

        try {
            int complaintId = Integer.parseInt(complaintIdStr);
            Complaint complaint = complaintDAO.findById(complaintId);
            if (complaint == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Complaint not found");
                return;
            }

            if ("RESOLVED".equalsIgnoreCase(newStatus)) {
                if (resolutionText == null || resolutionText.trim().isEmpty()) {
                    resolutionText = comment;
                }
                if (resolutionText == null || resolutionText.trim().isEmpty()) {
                    resp.sendRedirect(req.getContextPath() + "/department/complaint-details?id=" + complaintId + "&error=missing_resolution");
                    return;
                }

                // Process optional resolution proof file
                Part filePart = null;
                String contentType = req.getContentType();
                if (contentType != null && contentType.toLowerCase().startsWith("multipart/")) {
                    try {
                        filePart = req.getPart("resolutionProof");
                        if (filePart == null || filePart.getSize() == 0) {
                            filePart = req.getPart("proofFile");
                        }
                    } catch (Exception ignored) {}
                }

                if (filePart != null && filePart.getSize() > 0) {
                    String submittedFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                    String ext = "";
                    int dotIdx = submittedFileName.lastIndexOf('.');
                    if (dotIdx > 0) ext = submittedFileName.substring(dotIdx).toLowerCase();

                    if (ext.matches("\\.(jpg|jpeg|png|webp|gif|pdf)")) {
                        String newFileName = "proof_" + complaintId + "_" + System.currentTimeMillis() + ext;
                        String uploadPath = req.getServletContext().getRealPath("/uploads/complaints");
                        File uploadDir = new File(uploadPath);
                        if (!uploadDir.exists()) uploadDir.mkdirs();

                        File targetFile = new File(uploadDir, newFileName);
                        try (InputStream input = filePart.getInputStream()) {
                            Files.copy(input, targetFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
                        }

                        ComplaintAttachment att = new ComplaintAttachment();
                        att.setComplaintId(complaintId);
                        att.setFileName(submittedFileName);
                        att.setFilePath("uploads/complaints/" + newFileName);
                        att.setFileType(filePart.getContentType());
                        att.setFileSize(filePart.getSize());
                        att.setAttachmentType("RESOLUTION_PROOF");
                        att.setUploadedBy(currentUser.getUserId());
                        attachmentDAO.create(att);
                    }
                }
            }

            boolean success = complaintService.updateStatus(complaintId, currentUser.getUserId(), newStatus, comment, resolutionText, req.getRemoteAddr());

            String targetUrl = currentUser.isAdmin() ?
                req.getContextPath() + "/complaint/details?id=" + complaintId :
                req.getContextPath() + "/department/complaint-details?id=" + complaintId;

            if (success) {
                resp.sendRedirect(targetUrl + "&updated=true");
            } else {
                resp.sendRedirect(targetUrl + "&error=update_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/department/complaints?error=system_error");
        }
    }
}

package com.smartvit.controller;

import com.smartvit.dao.*;
import com.smartvit.model.*;
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
import java.util.List;

@WebServlet(urlPatterns = {"/student/raise-complaint", "/staff/raise-complaint"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 25     // 25MB
)
public class RaiseComplaintServlet extends HttpServlet {
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final SubCategoryDAO subCategoryDAO = new SubCategoryDAO();
    private final BuildingDAO buildingDAO = new BuildingDAO();
    private final LocationDAO locationDAO = new LocationDAO();
    private final ComplaintService complaintService = new ComplaintService();
    private final ComplaintAttachmentDAO attachmentDAO = new ComplaintAttachmentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Category> categories = categoryDAO.findAllActive();
        List<Building> buildings = buildingDAO.findAll();
        List<Location> locations = locationDAO.findAll();

        req.setAttribute("categories", categories);
        req.setAttribute("buildings", buildings);
        req.setAttribute("locations", locations);

        // Check if location was passed via QR code scan (?locationId=...)
        String locationIdParam = req.getParameter("locationId");
        if (locationIdParam != null && !locationIdParam.trim().isEmpty()) {
            try {
                int locId = Integer.parseInt(locationIdParam.trim());
                Location loc = locationDAO.findById(locId);
                if (loc != null) {
                    req.setAttribute("selectedLocation", loc);
                    req.setAttribute("selectedLocationId", loc.getLocationId());
                    req.setAttribute("selectedBuildingId", loc.getBuildingId());
                    req.setAttribute("fromQRCode", true);
                }
            } catch (NumberFormatException ignored) {}
        }

        req.getRequestDispatcher("/student/raiseComplaint.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        String title = req.getParameter("title");
        String categoryIdStr = req.getParameter("categoryId");
        String subcategoryIdStr = req.getParameter("subcategoryId");
        String locationIdStr = req.getParameter("locationId");
        String priority = req.getParameter("priority");
        String description = req.getParameter("description");

        if (title == null || title.trim().isEmpty() ||
            categoryIdStr == null || categoryIdStr.isEmpty() ||
            subcategoryIdStr == null || subcategoryIdStr.isEmpty() ||
            locationIdStr == null || locationIdStr.isEmpty() ||
            description == null || description.trim().isEmpty()) {

            req.setAttribute("errorMessage", "All required fields must be filled out.");
            doGet(req, resp);
            return;
        }

        try {
            int categoryId = Integer.parseInt(categoryIdStr);
            int subcategoryId = Integer.parseInt(subcategoryIdStr);
            int locationId = Integer.parseInt(locationIdStr);

            Complaint c = new Complaint();
            c.setComplainantId(currentUser.getUserId());
            c.setTitle(title.trim());
            c.setCategoryId(categoryId);
            c.setSubcategoryId(subcategoryId);
            c.setLocationId(locationId);
            c.setPriority(priority != null ? priority.trim().toUpperCase() : "MEDIUM");
            c.setDescription(description.trim());

            Complaint saved = null;
            try {
                saved = complaintService.submitComplaint(c, req.getRemoteAddr());
            } catch (Exception e) {
                e.printStackTrace();
            }
            if (saved != null) {
                // Process optional file attachment
                Part filePart = req.getPart("attachment");
                if (filePart != null && filePart.getSize() > 0) {
                    String submittedFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                    // Validate extension
                    String ext = "";
                    int dotIdx = submittedFileName.lastIndexOf('.');
                    if (dotIdx > 0) ext = submittedFileName.substring(dotIdx).toLowerCase();

                    if (ext.matches("\\.(jpg|jpeg|png|webp|gif|pdf)")) {
                        String newFileName = "cmp_" + saved.getComplaintId() + "_" + System.currentTimeMillis() + ext;
                        String uploadPath = req.getServletContext().getRealPath("/uploads/complaints");
                        File uploadDir = new File(uploadPath);
                        if (!uploadDir.exists()) uploadDir.mkdirs();

                        File targetFile = new File(uploadDir, newFileName);
                        try (InputStream input = filePart.getInputStream()) {
                            Files.copy(input, targetFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
                        }

                        ComplaintAttachment att = new ComplaintAttachment();
                        att.setComplaintId(saved.getComplaintId());
                        att.setFileName(submittedFileName);
                        att.setFilePath("uploads/complaints/" + newFileName);
                        att.setFileType(filePart.getContentType());
                        att.setFileSize(filePart.getSize());
                        att.setAttachmentType("INITIAL");
                        att.setUploadedBy(currentUser.getUserId());
                        attachmentDAO.create(att);
                    }
                }

                String redirectBase = currentUser.isStaff() ? "/staff" : "/student";
                resp.sendRedirect(req.getContextPath() + redirectBase + "/complaint-details?id=" + saved.getComplaintId() + "&created=true");
            } else {
                req.setAttribute("errorMessage", "Could not save complaint. Please check your inputs.");
                doGet(req, resp);
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Error submitting complaint: " + e.getMessage());
            doGet(req, resp);
        }
    }
}

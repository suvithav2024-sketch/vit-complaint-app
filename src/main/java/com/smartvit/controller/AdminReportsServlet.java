package com.smartvit.controller;

import com.google.gson.Gson;
import com.smartvit.dao.ComplaintDAO;
import com.smartvit.dao.FeedbackDAO;
import com.smartvit.model.Complaint;
import com.smartvit.model.ComplaintFeedback;
import com.smartvit.service.ReportService;
import com.smartvit.util.CsvReportExporter;
import com.smartvit.util.ReportGenerator;
import com.smartvit.util.TxtReportExporter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.List;
import java.util.Map;

/**
 * Admin Reports Servlet.
 * Supports web dashboard viewing and file report generation (CSV / TXT)
 * demonstrating File Handling, Interfaces, and Polymorphism.
 */
@WebServlet("/admin/reports")
public class AdminReportsServlet extends HttpServlet {
    private final ReportService reportService = new ReportService();
    private final FeedbackDAO feedbackDAO = new FeedbackDAO();
    private final ComplaintDAO complaintDAO = new ComplaintDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String exportType = req.getParameter("export");

        // If export requested, demonstrate Polymorphic File Exporter
        if (exportType != null && !exportType.trim().isEmpty()) {
            handleReportExport(exportType, req, resp);
            return;
        }

        Map<String, Object> stats = reportService.getDashboardStats();
        List<Map<String, Object>> byCategory = reportService.getComplaintsByCategory();
        List<Map<String, Object>> byDepartment = reportService.getComplaintsByDepartment();
        List<Map<String, Object>> byBuilding = reportService.getComplaintsByBuilding();
        List<Map<String, Object>> byStatus = reportService.getComplaintsByStatus();
        List<Map<String, Object>> deptPerformance = reportService.getDepartmentPerformance();
        List<ComplaintFeedback> recentFeedback = feedbackDAO.findAll(20);

        req.setAttribute("stats", stats);
        req.setAttribute("byCategory", byCategory);
        req.setAttribute("byDepartment", byDepartment);
        req.setAttribute("byBuilding", byBuilding);
        req.setAttribute("byStatus", byStatus);
        req.setAttribute("deptPerformance", deptPerformance);
        req.setAttribute("recentFeedback", recentFeedback);

        // JSON for Chart.js rendering
        req.setAttribute("categoryChartJson", gson.toJson(byCategory));
        req.setAttribute("departmentChartJson", gson.toJson(byDepartment));
        req.setAttribute("statusChartJson", gson.toJson(byStatus));
        req.setAttribute("buildingChartJson", gson.toJson(byBuilding));

        req.getRequestDispatcher("/admin/reports.jsp").forward(req, resp);
    }

    private void handleReportExport(String type, HttpServletRequest req, HttpServletResponse resp) throws IOException {
        ReportGenerator generator;
        if ("csv".equalsIgnoreCase(type)) {
            generator = new CsvReportExporter();
        } else {
            generator = new TxtReportExporter();
        }

        List<Complaint> complaints = complaintDAO.findAll(500, 0, null, null);
        File tempDir = new File(System.getProperty("java.io.tmpdir"), "smartvit_reports");

        try {
            File reportFile = generator.generateReport(complaints, tempDir);

            resp.setContentType(generator.getContentType());
            resp.setHeader("Content-Disposition", "attachment; filename=\"" + reportFile.getName() + "\"");
            resp.setContentLengthLong(reportFile.length());

            try (FileInputStream in = new FileInputStream(reportFile);
                 OutputStream out = resp.getOutputStream()) {
                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = in.read(buffer)) != -1) {
                    out.write(buffer, 0, bytesRead);
                }
                out.flush();
            }
        } catch (Exception e) {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Report generation failed: " + e.getMessage());
        }
    }
}

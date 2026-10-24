package com.smartvit.service;

import com.smartvit.dao.*;
import com.smartvit.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

public class ReportService {
    private final ComplaintDAO complaintDAO = new ComplaintDAO();
    private final UserDAO userDAO = new UserDAO();
    private final FeedbackDAO feedbackDAO = new FeedbackDAO();
    private final DepartmentDAO departmentDAO = new DepartmentDAO();
    private final LocationDAO locationDAO = new LocationDAO();
    private final QRCodeDAO qrCodeDAO = new QRCodeDAO();

    public Map<String, Object> getDashboardStats() {
        Map<String, Object> stats = new HashMap<>();

        // User stats
        stats.put("totalUsers", userDAO.countAll(null, null));
        stats.put("totalStudents", userDAO.countByRole("STUDENT"));
        stats.put("totalStaff", userDAO.countByRole("STAFF"));
        stats.put("totalDeptStaff", userDAO.countByRole("DEPARTMENT_STAFF"));

        // Complaint stats
        int totalComplaints = complaintDAO.countAll(null, null, null, null, null);
        int submitted = complaintDAO.countByStatus(null, null, "SUBMITTED");
        int assigned = complaintDAO.countByStatus(null, null, "ASSIGNED");
        int inProgress = complaintDAO.countByStatus(null, null, "IN_PROGRESS");
        int resolved = complaintDAO.countByStatus(null, null, "RESOLVED");
        int closed = complaintDAO.countByStatus(null, null, "CLOSED");
        int reopened = complaintDAO.countByStatus(null, null, "REOPENED");
        int overdue = complaintDAO.countOverdue(null, null);

        stats.put("totalComplaints", totalComplaints);
        stats.put("submittedComplaints", submitted);
        stats.put("assignedComplaints", assigned);
        stats.put("pendingComplaints", submitted + assigned);
        stats.put("inProgressComplaints", inProgress);
        stats.put("resolvedComplaints", resolved);
        stats.put("closedComplaints", closed);
        stats.put("reopenedComplaints", reopened);
        stats.put("overdueComplaints", overdue);

        // System entity counts for admin dashboard
        stats.put("totalDepartments", departmentDAO.findAll().size());
        stats.put("totalLocations", locationDAO.findAll().size());
        stats.put("totalQRCodes", qrCodeDAO.findAll().size());

        // Rating
        double avgRating = feedbackDAO.getGlobalAverageRating();
        stats.put("averageRating", avgRating);
        stats.put("satisfactionRating", String.format(Locale.US, "%.1f", avgRating > 0 ? avgRating : 5.0));

        return stats;
    }

    public List<Map<String, Object>> getComplaintsByCategory() {
        List<Map<String, Object>> result = new ArrayList<>();
        String sql = "SELECT cat.name as category_name, COUNT(c.complaint_id) as complaint_count " +
                     "FROM categories cat " +
                     "LEFT JOIN complaints c ON cat.category_id = c.category_id " +
                     "GROUP BY cat.category_id, cat.name " +
                     "ORDER BY complaint_count DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("name", rs.getString("category_name"));
                row.put("count", rs.getInt("complaint_count"));
                result.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    public List<Map<String, Object>> getComplaintsByDepartment() {
        List<Map<String, Object>> result = new ArrayList<>();
        String sql = "SELECT d.name as department_name, COUNT(c.complaint_id) as complaint_count " +
                     "FROM departments d " +
                     "LEFT JOIN complaints c ON d.department_id = c.department_id " +
                     "GROUP BY d.department_id, d.name " +
                     "ORDER BY complaint_count DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("name", rs.getString("department_name"));
                row.put("count", rs.getInt("complaint_count"));
                result.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    public List<Map<String, Object>> getComplaintsByBuilding() {
        List<Map<String, Object>> result = new ArrayList<>();
        String sql = "SELECT b.name as building_name, COUNT(c.complaint_id) as complaint_count " +
                     "FROM buildings b " +
                     "JOIN locations loc ON b.building_id = loc.building_id " +
                     "JOIN complaints c ON loc.location_id = c.location_id " +
                     "GROUP BY b.building_id, b.name " +
                     "ORDER BY complaint_count DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("name", rs.getString("building_name"));
                row.put("count", rs.getInt("complaint_count"));
                result.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    public List<Map<String, Object>> getComplaintsByStatus() {
        List<Map<String, Object>> result = new ArrayList<>();
        String sql = "SELECT status, COUNT(*) as count FROM complaints GROUP BY status";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("status", rs.getString("status"));
                row.put("count", rs.getInt("count"));
                result.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    public List<Map<String, Object>> getDepartmentPerformance() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT d.department_id, d.name as department_name, " +
                     "COUNT(c.complaint_id) as total_assigned, " +
                     "SUM(CASE WHEN c.status = 'RESOLVED' OR c.status = 'CLOSED' THEN 1 ELSE 0 END) as total_resolved, " +
                     "SUM(CASE WHEN (c.is_overdue = TRUE OR (c.due_date IS NOT NULL AND c.due_date < NOW())) AND c.status NOT IN ('RESOLVED', 'CLOSED') THEN 1 ELSE 0 END) as overdue_count, " +
                     "AVG(CASE WHEN c.resolved_at IS NOT NULL THEN TIMESTAMPDIFF(HOUR, c.created_at, c.resolved_at) ELSE NULL END) as avg_resolution_hours, " +
                     "AVG(fb.rating) as avg_rating " +
                     "FROM departments d " +
                     "LEFT JOIN complaints c ON d.department_id = c.department_id " +
                     "LEFT JOIN complaint_feedback fb ON c.complaint_id = fb.complaint_id " +
                     "GROUP BY d.department_id, d.name " +
                     "ORDER BY d.name ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("departmentId", rs.getInt("department_id"));
                row.put("departmentName", rs.getString("department_name"));
                row.put("totalAssigned", rs.getInt("total_assigned"));
                row.put("totalResolved", rs.getInt("total_resolved"));
                row.put("overdueCount", rs.getInt("overdue_count"));
                double avgHours = rs.getDouble("avg_resolution_hours");
                row.put("avgResolutionHours", rs.wasNull() ? 0 : Math.round(avgHours * 10.0) / 10.0);
                double avgRating = rs.getDouble("avg_rating");
                row.put("avgRating", rs.wasNull() ? 0.0 : Math.round(avgRating * 10.0) / 10.0);
                list.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}

package com.smartvit.dao;

import com.smartvit.model.ComplaintFeedback;
import com.smartvit.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {

    public boolean create(ComplaintFeedback f) {
        String sql = "INSERT INTO complaint_feedback (complaint_id, user_id, problem_solved, rating, comment) " +
                     "VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, f.getComplaintId());
            stmt.setInt(2, f.getUserId());
            stmt.setBoolean(3, f.isProblemSolved());
            stmt.setInt(4, f.getRating());
            stmt.setString(5, f.getComment());

            int affected = stmt.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) f.setFeedbackId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public ComplaintFeedback findByComplaintId(int complaintId) {
        String sql = "SELECT f.*, u.full_name as user_name, c.complaint_code " +
                     "FROM complaint_feedback f " +
                     "JOIN users u ON f.user_id = u.user_id " +
                     "JOIN complaints c ON f.complaint_id = c.complaint_id " +
                     "WHERE f.complaint_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, complaintId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return mapFeedback(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<ComplaintFeedback> findAll(int limit) {
        List<ComplaintFeedback> list = new ArrayList<>();
        String sql = "SELECT f.*, u.full_name as user_name, c.complaint_code " +
                     "FROM complaint_feedback f " +
                     "JOIN users u ON f.user_id = u.user_id " +
                     "JOIN complaints c ON f.complaint_id = c.complaint_id " +
                     "ORDER BY f.created_at DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapFeedback(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public double getAverageRatingByDepartment(int departmentId) {
        String sql = "SELECT AVG(f.rating) FROM complaint_feedback f " +
                     "JOIN complaints c ON f.complaint_id = c.complaint_id " +
                     "WHERE c.department_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, departmentId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    public double getGlobalAverageRating() {
        String sql = "SELECT AVG(rating) FROM complaint_feedback";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    private ComplaintFeedback mapFeedback(ResultSet rs) throws SQLException {
        ComplaintFeedback f = new ComplaintFeedback();
        f.setFeedbackId(rs.getInt("feedback_id"));
        f.setComplaintId(rs.getInt("complaint_id"));
        f.setComplaintCode(rs.getString("complaint_code"));
        f.setUserId(rs.getInt("user_id"));
        f.setUserName(rs.getString("user_name"));
        f.setProblemSolved(rs.getBoolean("problem_solved"));
        f.setRating(rs.getInt("rating"));
        f.setComment(rs.getString("comment"));
        f.setCreatedAt(rs.getTimestamp("created_at"));
        return f;
    }
}

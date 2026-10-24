package com.smartvit.dao;

import com.smartvit.model.ComplaintUpdate;
import com.smartvit.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ComplaintUpdateDAO {

    public boolean create(ComplaintUpdate u) {
        String sql = "INSERT INTO complaint_updates (complaint_id, updated_by, old_status, new_status, comment) " +
                     "VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, u.getComplaintId());
            stmt.setInt(2, u.getUpdatedBy());
            stmt.setString(3, u.getOldStatus());
            stmt.setString(4, u.getNewStatus());
            stmt.setString(5, u.getComment());

            int affected = stmt.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) u.setUpdateId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<ComplaintUpdate> findByComplaintId(int complaintId) {
        List<ComplaintUpdate> list = new ArrayList<>();
        String sql = "SELECT cu.*, u.full_name as updated_by_name " +
                     "FROM complaint_updates cu " +
                     "JOIN users u ON cu.updated_by = u.user_id " +
                     "WHERE cu.complaint_id = ? ORDER BY cu.created_at ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, complaintId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ComplaintUpdate u = new ComplaintUpdate();
                    u.setUpdateId(rs.getInt("update_id"));
                    u.setComplaintId(rs.getInt("complaint_id"));
                    u.setUpdatedBy(rs.getInt("updated_by"));
                    u.setUpdatedByName(rs.getString("updated_by_name"));
                    u.setOldStatus(rs.getString("old_status"));
                    u.setNewStatus(rs.getString("new_status"));
                    u.setComment(rs.getString("comment"));
                    u.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(u);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}

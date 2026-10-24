package com.smartvit.dao;

import com.smartvit.model.AuditLog;
import com.smartvit.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AuditLogDAO {

    public void log(Integer userId, String action, String entityType, Integer entityId, String ipAddress, String details) {
        String sql = "INSERT INTO audit_logs (user_id, action, entity_type, entity_id, ip_address, details) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            if (userId != null && userId > 0) {
                stmt.setInt(1, userId);
            } else {
                stmt.setNull(1, Types.INTEGER);
            }
            stmt.setString(2, action);
            stmt.setString(3, entityType);
            if (entityId != null && entityId > 0) {
                stmt.setInt(4, entityId);
            } else {
                stmt.setNull(4, Types.INTEGER);
            }
            stmt.setString(5, ipAddress);
            stmt.setString(6, details);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<AuditLog> findRecent(int limit) {
        List<AuditLog> list = new ArrayList<>();
        String sql = "SELECT a.*, u.full_name as user_name, u.email as user_email " +
                     "FROM audit_logs a " +
                     "LEFT JOIN users u ON a.user_id = u.user_id " +
                     "ORDER BY a.created_at DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    AuditLog a = new AuditLog();
                    a.setLogId(rs.getInt("log_id"));
                    int uId = rs.getInt("user_id");
                    if (!rs.wasNull()) {
                        a.setUserId(uId);
                        a.setUserName(rs.getString("user_name"));
                        a.setUserEmail(rs.getString("user_email"));
                    }
                    a.setAction(rs.getString("action"));
                    a.setEntityType(rs.getString("entity_type"));
                    int eId = rs.getInt("entity_id");
                    if (!rs.wasNull()) a.setEntityId(eId);
                    a.setIpAddress(rs.getString("ip_address"));
                    a.setDetails(rs.getString("details"));
                    a.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(a);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}

package com.smartvit.dao;

import com.smartvit.model.SlaRule;
import com.smartvit.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SlaDAO {

    public List<SlaRule> findAll() {
        List<SlaRule> list = new ArrayList<>();
        String sql = "SELECT * FROM sla_rules ORDER BY max_resolution_hours ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(mapSlaRule(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public SlaRule findByPriority(String priority) {
        String sql = "SELECT * FROM sla_rules WHERE UPPER(priority) = UPPER(?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, priority);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return mapSlaRule(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean update(SlaRule rule) {
        String sql = "UPDATE sla_rules SET max_resolution_hours = ?, escalation_hours = ?, description = ? WHERE sla_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, rule.getMaxResolutionHours());
            stmt.setInt(2, rule.getEscalationHours());
            stmt.setString(3, rule.getDescription());
            stmt.setInt(4, rule.getSlaId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private SlaRule mapSlaRule(ResultSet rs) throws SQLException {
        SlaRule r = new SlaRule();
        r.setSlaId(rs.getInt("sla_id"));
        r.setPriority(rs.getString("priority"));
        r.setMaxResolutionHours(rs.getInt("max_resolution_hours"));
        r.setEscalationHours(rs.getInt("escalation_hours"));
        r.setDescription(rs.getString("description"));
        return r;
    }
}

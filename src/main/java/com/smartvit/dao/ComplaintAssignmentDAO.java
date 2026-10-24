package com.smartvit.dao;

import com.smartvit.model.ComplaintAssignment;
import com.smartvit.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ComplaintAssignmentDAO {

    public boolean create(ComplaintAssignment a) {
        String sql = "INSERT INTO complaint_assignments (complaint_id, department_id, staff_id, assigned_by, notes) " +
                     "VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, a.getComplaintId());
            stmt.setInt(2, a.getDepartmentId());
            if (a.getStaffId() != null && a.getStaffId() > 0) {
                stmt.setInt(3, a.getStaffId());
            } else {
                stmt.setNull(3, Types.INTEGER);
            }
            stmt.setInt(4, a.getAssignedBy());
            stmt.setString(5, a.getNotes());

            int affected = stmt.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) a.setAssignmentId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<ComplaintAssignment> findByComplaintId(int complaintId) {
        List<ComplaintAssignment> list = new ArrayList<>();
        String sql = "SELECT ca.*, d.name as department_name, u.full_name as assigned_by_name, su.full_name as staff_name " +
                     "FROM complaint_assignments ca " +
                     "JOIN departments d ON ca.department_id = d.department_id " +
                     "JOIN users u ON ca.assigned_by = u.user_id " +
                     "LEFT JOIN department_staff ds ON ca.staff_id = ds.staff_id " +
                     "LEFT JOIN users su ON ds.user_id = su.user_id " +
                     "WHERE ca.complaint_id = ? ORDER BY ca.assigned_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, complaintId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ComplaintAssignment a = new ComplaintAssignment();
                    a.setAssignmentId(rs.getInt("assignment_id"));
                    a.setComplaintId(rs.getInt("complaint_id"));
                    a.setDepartmentId(rs.getInt("department_id"));
                    a.setDepartmentName(rs.getString("department_name"));
                    int sId = rs.getInt("staff_id");
                    if (!rs.wasNull()) {
                        a.setStaffId(sId);
                        a.setStaffName(rs.getString("staff_name"));
                    }
                    a.setAssignedBy(rs.getInt("assigned_by"));
                    a.setAssignedByName(rs.getString("assigned_by_name"));
                    a.setNotes(rs.getString("notes"));
                    a.setAssignedAt(rs.getTimestamp("assigned_at"));
                    list.add(a);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}

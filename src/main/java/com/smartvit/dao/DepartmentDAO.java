package com.smartvit.dao;

import com.smartvit.model.Department;
import com.smartvit.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DepartmentDAO {

    public List<Department> findAll() {
        List<Department> list = new ArrayList<>();
        String sql = "SELECT * FROM departments ORDER BY name ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(mapDepartment(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Department> findAllActive() {
        List<Department> list = new ArrayList<>();
        String sql = "SELECT * FROM departments WHERE is_active = TRUE ORDER BY name ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(mapDepartment(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Department findById(int id) {
        String sql = "SELECT * FROM departments WHERE department_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return mapDepartment(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Department findByCode(String code) {
        String sql = "SELECT * FROM departments WHERE code = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, code);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return mapDepartment(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean create(Department dept) {
        String sql = "INSERT INTO departments (name, code, description, contact_email, contact_phone, office_location, is_active) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, dept.getName());
            stmt.setString(2, dept.getCode());
            stmt.setString(3, dept.getDescription());
            stmt.setString(4, dept.getContactEmail());
            stmt.setString(5, dept.getContactPhone());
            stmt.setString(6, dept.getOfficeLocation());
            stmt.setBoolean(7, dept.isActive());
            int affected = stmt.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) dept.setDepartmentId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(Department dept) {
        String sql = "UPDATE departments SET name = ?, code = ?, description = ?, contact_email = ?, contact_phone = ?, office_location = ?, is_active = ? WHERE department_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, dept.getName());
            stmt.setString(2, dept.getCode());
            stmt.setString(3, dept.getDescription());
            stmt.setString(4, dept.getContactEmail());
            stmt.setString(5, dept.getContactPhone());
            stmt.setString(6, dept.getOfficeLocation());
            stmt.setBoolean(7, dept.isActive());
            stmt.setInt(8, dept.getDepartmentId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Department mapDepartment(ResultSet rs) throws SQLException {
        Department d = new Department();
        d.setDepartmentId(rs.getInt("department_id"));
        d.setName(rs.getString("name"));
        d.setCode(rs.getString("code"));
        d.setDescription(rs.getString("description"));
        d.setContactEmail(rs.getString("contact_email"));
        d.setContactPhone(rs.getString("contact_phone"));
        d.setOfficeLocation(rs.getString("office_location"));
        d.setActive(rs.getBoolean("is_active"));
        d.setCreatedAt(rs.getTimestamp("created_at"));
        return d;
    }
}

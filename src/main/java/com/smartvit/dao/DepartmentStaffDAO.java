package com.smartvit.dao;

import com.smartvit.model.DepartmentStaff;
import com.smartvit.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DepartmentStaffDAO {

    public List<DepartmentStaff> findByDepartmentId(int deptId) {
        List<DepartmentStaff> list = new ArrayList<>();
        String sql = "SELECT s.*, u.full_name as staff_name, d.name as department_name " +
                     "FROM department_staff s " +
                     "JOIN users u ON s.user_id = u.user_id " +
                     "JOIN departments d ON s.department_id = d.department_id " +
                     "WHERE s.department_id = ? " +
                     "ORDER BY s.staff_id ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, deptId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapStaff(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<DepartmentStaff> findAll() {
        List<DepartmentStaff> list = new ArrayList<>();
        String sql = "SELECT s.*, u.full_name as staff_name, d.name as department_name " +
                     "FROM department_staff s " +
                     "JOIN users u ON s.user_id = u.user_id " +
                     "JOIN departments d ON s.department_id = d.department_id " +
                     "ORDER BY d.name ASC, s.staff_id ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(mapStaff(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public DepartmentStaff findByUserId(int userId) {
        String sql = "SELECT s.*, u.full_name as staff_name, d.name as department_name " +
                     "FROM department_staff s " +
                     "JOIN users u ON s.user_id = u.user_id " +
                     "JOIN departments d ON s.department_id = d.department_id " +
                     "WHERE s.user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return mapStaff(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public DepartmentStaff findById(int staffId) {
        String sql = "SELECT s.*, u.full_name as staff_name, d.name as department_name " +
                     "FROM department_staff s " +
                     "JOIN users u ON s.user_id = u.user_id " +
                     "JOIN departments d ON s.department_id = d.department_id " +
                     "WHERE s.staff_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, staffId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return mapStaff(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public DepartmentStaff findFirstAvailableByDepartment(int departmentId) {
        String sql = "SELECT s.*, u.full_name as staff_name, d.name as department_name " +
                     "FROM department_staff s " +
                     "JOIN users u ON s.user_id = u.user_id " +
                     "JOIN departments d ON s.department_id = d.department_id " +
                     "WHERE s.department_id = ? AND s.availability_status = 'AVAILABLE' " +
                     "ORDER BY s.staff_id ASC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, departmentId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return mapStaff(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        // If none strictly marked AVAILABLE, fallback to any staff in department
        return findAnyByDepartment(departmentId);
    }

    private DepartmentStaff findAnyByDepartment(int departmentId) {
        String sql = "SELECT s.*, u.full_name as staff_name, d.name as department_name " +
                     "FROM department_staff s " +
                     "JOIN users u ON s.user_id = u.user_id " +
                     "JOIN departments d ON s.department_id = d.department_id " +
                     "WHERE s.department_id = ? " +
                     "ORDER BY s.staff_id ASC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, departmentId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return mapStaff(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean create(DepartmentStaff staff) {
        String sql = "INSERT INTO department_staff (user_id, department_id, designation, specialization, phone, email, office_location, availability_status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, staff.getUserId());
            stmt.setInt(2, staff.getDepartmentId());
            stmt.setString(3, staff.getDesignation());
            stmt.setString(4, staff.getSpecialization());
            stmt.setString(5, staff.getPhone());
            stmt.setString(6, staff.getEmail());
            stmt.setString(7, staff.getOfficeLocation());
            stmt.setString(8, staff.getAvailabilityStatus() != null ? staff.getAvailabilityStatus() : "AVAILABLE");
            int affected = stmt.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) staff.setStaffId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(DepartmentStaff staff) {
        String sql = "UPDATE department_staff SET designation = ?, specialization = ?, phone = ?, email = ?, office_location = ?, availability_status = ? " +
                     "WHERE staff_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, staff.getDesignation());
            stmt.setString(2, staff.getSpecialization());
            stmt.setString(3, staff.getPhone());
            stmt.setString(4, staff.getEmail());
            stmt.setString(5, staff.getOfficeLocation());
            stmt.setString(6, staff.getAvailabilityStatus());
            stmt.setInt(7, staff.getStaffId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private DepartmentStaff mapStaff(ResultSet rs) throws SQLException {
        DepartmentStaff s = new DepartmentStaff();
        s.setStaffId(rs.getInt("staff_id"));
        s.setUserId(rs.getInt("user_id"));
        s.setDepartmentId(rs.getInt("department_id"));
        s.setStaffName(rs.getString("staff_name"));
        s.setDepartmentName(rs.getString("department_name"));
        s.setDesignation(rs.getString("designation"));
        s.setSpecialization(rs.getString("specialization"));
        s.setPhone(rs.getString("phone"));
        s.setEmail(rs.getString("email"));
        s.setOfficeLocation(rs.getString("office_location"));
        s.setAvailabilityStatus(rs.getString("availability_status"));
        s.setCreatedAt(rs.getTimestamp("created_at"));
        return s;
    }
}

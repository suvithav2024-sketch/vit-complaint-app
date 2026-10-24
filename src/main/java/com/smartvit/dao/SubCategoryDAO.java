package com.smartvit.dao;

import com.smartvit.model.SubCategory;
import com.smartvit.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SubCategoryDAO {

    public List<SubCategory> findByCategoryId(int categoryId) {
        List<SubCategory> list = new ArrayList<>();
        String sql = "SELECT s.*, c.name as category_name " +
                     "FROM subcategories s " +
                     "JOIN categories c ON s.category_id = c.category_id " +
                     "WHERE s.category_id = ? AND s.is_active = TRUE " +
                     "ORDER BY s.name ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, categoryId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapSubCategory(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<SubCategory> findAll() {
        List<SubCategory> list = new ArrayList<>();
        String sql = "SELECT s.*, c.name as category_name " +
                     "FROM subcategories s " +
                     "JOIN categories c ON s.category_id = c.category_id " +
                     "ORDER BY c.name ASC, s.name ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(mapSubCategory(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public SubCategory findById(int id) {
        String sql = "SELECT s.*, c.name as category_name " +
                     "FROM subcategories s " +
                     "JOIN categories c ON s.category_id = c.category_id " +
                     "WHERE s.subcategory_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return mapSubCategory(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean create(SubCategory s) {
        String sql = "INSERT INTO subcategories (category_id, name, description, default_priority, is_active) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, s.getCategoryId());
            stmt.setString(2, s.getName());
            stmt.setString(3, s.getDescription());
            stmt.setString(4, s.getDefaultPriority());
            stmt.setBoolean(5, s.isActive());
            int affected = stmt.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) s.setSubcategoryId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(SubCategory s) {
        String sql = "UPDATE subcategories SET category_id = ?, name = ?, description = ?, default_priority = ?, is_active = ? WHERE subcategory_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, s.getCategoryId());
            stmt.setString(2, s.getName());
            stmt.setString(3, s.getDescription());
            stmt.setString(4, s.getDefaultPriority());
            stmt.setBoolean(5, s.isActive());
            stmt.setInt(6, s.getSubcategoryId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private SubCategory mapSubCategory(ResultSet rs) throws SQLException {
        SubCategory s = new SubCategory();
        s.setSubcategoryId(rs.getInt("subcategory_id"));
        s.setCategoryId(rs.getInt("category_id"));
        s.setCategoryName(rs.getString("category_name"));
        s.setName(rs.getString("name"));
        s.setDescription(rs.getString("description"));
        s.setDefaultPriority(rs.getString("default_priority"));
        s.setActive(rs.getBoolean("is_active"));
        s.setCreatedAt(rs.getTimestamp("created_at"));
        return s;
    }
}

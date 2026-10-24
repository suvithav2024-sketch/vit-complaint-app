package com.smartvit.dao;

import com.smartvit.model.CategoryDepartmentMapping;
import com.smartvit.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MappingDAO {

    /**
     * Resolves the allocated department for a given category and subcategory from the database.
     */
    public int findDepartmentForCategory(int categoryId, Integer subcategoryId) {
        // 1. Try exact match on category + subcategory
        if (subcategoryId != null && subcategoryId > 0) {
            String sqlExact = "SELECT department_id FROM category_department_mapping " +
                              "WHERE category_id = ? AND subcategory_id = ? AND is_active = TRUE LIMIT 1";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sqlExact)) {
                stmt.setInt(1, categoryId);
                stmt.setInt(2, subcategoryId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt("department_id");
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        // 2. Fallback to category-wide mapping (where subcategory_id IS NULL)
        String sqlFallback = "SELECT department_id FROM category_department_mapping " +
                             "WHERE category_id = ? AND subcategory_id IS NULL AND is_active = TRUE LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sqlFallback)) {
            stmt.setInt(1, categoryId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("department_id");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // 3. Ultimate safety fallback: return first active department
        String sqlDefault = "SELECT department_id FROM departments WHERE is_active = TRUE ORDER BY department_id ASC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sqlDefault);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("department_id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 1; // Default ID
    }

    public List<CategoryDepartmentMapping> findAll() {
        List<CategoryDepartmentMapping> list = new ArrayList<>();
        String sql = "SELECT m.*, c.name as category_name, s.name as subcategory_name, d.name as department_name " +
                     "FROM category_department_mapping m " +
                     "JOIN categories c ON m.category_id = c.category_id " +
                     "LEFT JOIN subcategories s ON m.subcategory_id = s.subcategory_id " +
                     "JOIN departments d ON m.department_id = d.department_id " +
                     "ORDER BY c.name ASC, s.name ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(mapMapping(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean create(CategoryDepartmentMapping m) {
        String sql = "INSERT INTO category_department_mapping (category_id, subcategory_id, department_id, is_active) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, m.getCategoryId());
            if (m.getSubcategoryId() != null && m.getSubcategoryId() > 0) {
                stmt.setInt(2, m.getSubcategoryId());
            } else {
                stmt.setNull(2, Types.INTEGER);
            }
            stmt.setInt(3, m.getDepartmentId());
            stmt.setBoolean(4, m.isActive());
            int affected = stmt.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) m.setMappingId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(CategoryDepartmentMapping m) {
        String sql = "UPDATE category_department_mapping SET category_id = ?, subcategory_id = ?, department_id = ?, is_active = ? WHERE mapping_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, m.getCategoryId());
            if (m.getSubcategoryId() != null && m.getSubcategoryId() > 0) {
                stmt.setInt(2, m.getSubcategoryId());
            } else {
                stmt.setNull(2, Types.INTEGER);
            }
            stmt.setInt(3, m.getDepartmentId());
            stmt.setBoolean(4, m.isActive());
            stmt.setInt(5, m.getMappingId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int mappingId) {
        String sql = "DELETE FROM category_department_mapping WHERE mapping_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, mappingId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private CategoryDepartmentMapping mapMapping(ResultSet rs) throws SQLException {
        CategoryDepartmentMapping m = new CategoryDepartmentMapping();
        m.setMappingId(rs.getInt("mapping_id"));
        m.setCategoryId(rs.getInt("category_id"));
        m.setCategoryName(rs.getString("category_name"));
        int subId = rs.getInt("subcategory_id");
        if (!rs.wasNull()) {
            m.setSubcategoryId(subId);
        }
        m.setSubcategoryName(rs.getString("subcategory_name"));
        m.setDepartmentId(rs.getInt("department_id"));
        m.setDepartmentName(rs.getString("department_name"));
        m.setActive(rs.getBoolean("is_active"));
        return m;
    }
}

package com.smartvit.dao;

import com.smartvit.model.Building;
import com.smartvit.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BuildingDAO {

    public List<Building> findAll() {
        List<Building> list = new ArrayList<>();
        String sql = "SELECT b.*, c.name as campus_name FROM buildings b JOIN campuses c ON b.campus_id = c.campus_id ORDER BY b.name ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(mapBuilding(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Building findById(int id) {
        String sql = "SELECT b.*, c.name as campus_name FROM buildings b JOIN campuses c ON b.campus_id = c.campus_id WHERE b.building_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return mapBuilding(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean create(Building b) {
        String sql = "INSERT INTO buildings (campus_id, name, code, type, total_floors, is_active) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, b.getCampusId());
            stmt.setString(2, b.getName());
            stmt.setString(3, b.getCode());
            stmt.setString(4, b.getType());
            stmt.setInt(5, b.getTotalFloors());
            stmt.setBoolean(6, b.isActive());
            int affected = stmt.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) b.setBuildingId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(Building b) {
        String sql = "UPDATE buildings SET name = ?, code = ?, type = ?, total_floors = ?, is_active = ? WHERE building_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, b.getName());
            stmt.setString(2, b.getCode());
            stmt.setString(3, b.getType());
            stmt.setInt(4, b.getTotalFloors());
            stmt.setBoolean(5, b.isActive());
            stmt.setInt(6, b.getBuildingId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Building mapBuilding(ResultSet rs) throws SQLException {
        Building b = new Building();
        b.setBuildingId(rs.getInt("building_id"));
        b.setCampusId(rs.getInt("campus_id"));
        b.setCampusName(rs.getString("campus_name"));
        b.setName(rs.getString("name"));
        b.setCode(rs.getString("code"));
        b.setType(rs.getString("type"));
        b.setTotalFloors(rs.getInt("total_floors"));
        b.setActive(rs.getBoolean("is_active"));
        return b;
    }
}

package com.smartvit.dao;

import com.smartvit.model.Location;
import com.smartvit.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LocationDAO {

    public List<Location> findAll() {
        List<Location> list = new ArrayList<>();
        String sql = "SELECT l.*, b.name as building_name, b.code as building_code " +
                     "FROM locations l " +
                     "JOIN buildings b ON l.building_id = b.building_id " +
                     "ORDER BY b.name ASC, l.floor ASC, l.room_number ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(mapLocation(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Location> findByBuildingId(int buildingId) {
        List<Location> list = new ArrayList<>();
        String sql = "SELECT l.*, b.name as building_name, b.code as building_code " +
                     "FROM locations l " +
                     "JOIN buildings b ON l.building_id = b.building_id " +
                     "WHERE l.building_id = ? AND l.is_active = TRUE " +
                     "ORDER BY l.floor ASC, l.room_number ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, buildingId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapLocation(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Location findById(int locationId) {
        String sql = "SELECT l.*, b.name as building_name, b.code as building_code " +
                     "FROM locations l " +
                     "JOIN buildings b ON l.building_id = b.building_id " +
                     "WHERE l.location_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, locationId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return mapLocation(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean create(Location l) {
        String sql = "INSERT INTO locations (building_id, block, floor, room_number, location_name, description, is_active) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, l.getBuildingId());
            stmt.setString(2, l.getBlock());
            stmt.setInt(3, l.getFloor());
            stmt.setString(4, l.getRoomNumber());
            stmt.setString(5, l.getLocationName());
            stmt.setString(6, l.getDescription());
            stmt.setBoolean(7, l.isActive());
            int affected = stmt.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) l.setLocationId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(Location l) {
        String sql = "UPDATE locations SET building_id = ?, block = ?, floor = ?, room_number = ?, location_name = ?, description = ?, is_active = ? " +
                     "WHERE location_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, l.getBuildingId());
            stmt.setString(2, l.getBlock());
            stmt.setInt(3, l.getFloor());
            stmt.setString(4, l.getRoomNumber());
            stmt.setString(5, l.getLocationName());
            stmt.setString(6, l.getDescription());
            stmt.setBoolean(7, l.isActive());
            stmt.setInt(8, l.getLocationId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Location mapLocation(ResultSet rs) throws SQLException {
        Location l = new Location();
        l.setLocationId(rs.getInt("location_id"));
        l.setBuildingId(rs.getInt("building_id"));
        l.setBuildingName(rs.getString("building_name"));
        l.setBuildingCode(rs.getString("building_code"));
        l.setBlock(rs.getString("block"));
        l.setFloor(rs.getInt("floor"));
        l.setRoomNumber(rs.getString("room_number"));
        l.setLocationName(rs.getString("location_name"));
        l.setDescription(rs.getString("description"));
        l.setActive(rs.getBoolean("is_active"));
        l.setCreatedAt(rs.getTimestamp("created_at"));
        return l;
    }
}

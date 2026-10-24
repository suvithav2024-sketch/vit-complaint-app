package com.smartvit.dao;

import com.smartvit.model.QRCode;
import com.smartvit.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QRCodeDAO {

    public List<QRCode> findAll() {
        List<QRCode> list = new ArrayList<>();
        String sql = "SELECT q.*, l.room_number, l.floor, l.location_name, b.name as building_name, b.code as building_code " +
                     "FROM qr_codes q " +
                     "JOIN locations l ON q.location_id = l.location_id " +
                     "JOIN buildings b ON l.building_id = b.building_id " +
                     "ORDER BY b.name ASC, l.room_number ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(mapQRCode(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public QRCode findById(int qrId) {
        String sql = "SELECT q.*, l.room_number, l.floor, l.location_name, b.name as building_name, b.code as building_code " +
                     "FROM qr_codes q " +
                     "JOIN locations l ON q.location_id = l.location_id " +
                     "JOIN buildings b ON l.building_id = b.building_id " +
                     "WHERE q.qr_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, qrId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return mapQRCode(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public QRCode findByLocationId(int locationId) {
        String sql = "SELECT q.*, l.room_number, l.floor, l.location_name, b.name as building_name, b.code as building_code " +
                     "FROM qr_codes q " +
                     "JOIN locations l ON q.location_id = l.location_id " +
                     "JOIN buildings b ON l.building_id = b.building_id " +
                     "WHERE q.location_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, locationId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return mapQRCode(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public QRCode findByIdentifier(String identifier) {
        String sql = "SELECT q.*, l.room_number, l.floor, l.location_name, b.name as building_name, b.code as building_code " +
                     "FROM qr_codes q " +
                     "JOIN locations l ON q.location_id = l.location_id " +
                     "JOIN buildings b ON l.building_id = b.building_id " +
                     "WHERE q.qr_code_identifier = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, identifier);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return mapQRCode(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean create(QRCode qr) {
        String sql = "INSERT INTO qr_codes (location_id, qr_code_identifier, qr_image_path, target_url, is_active) " +
                     "VALUES (?, ?, ?, ?, ?) " +
                     "ON DUPLICATE KEY UPDATE qr_image_path = VALUES(qr_image_path), target_url = VALUES(target_url), is_active = VALUES(is_active)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, qr.getLocationId());
            stmt.setString(2, qr.getQrCodeIdentifier());
            stmt.setString(3, qr.getQrImagePath());
            stmt.setString(4, qr.getTargetUrl());
            stmt.setBoolean(5, qr.isActive());
            int affected = stmt.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) qr.setQrId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(QRCode qr) {
        String sql = "UPDATE qr_codes SET qr_image_path = ?, target_url = ?, is_active = ? WHERE qr_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, qr.getQrImagePath());
            stmt.setString(2, qr.getTargetUrl());
            stmt.setBoolean(3, qr.isActive());
            stmt.setInt(4, qr.getQrId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean toggleActive(int qrId, boolean active) {
        String sql = "UPDATE qr_codes SET is_active = ? WHERE qr_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setBoolean(1, active);
            stmt.setInt(2, qrId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int qrId) {
        String sql = "DELETE FROM qr_codes WHERE qr_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, qrId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private QRCode mapQRCode(ResultSet rs) throws SQLException {
        QRCode q = new QRCode();
        q.setQrId(rs.getInt("qr_id"));
        q.setLocationId(rs.getInt("location_id"));
        q.setQrCodeIdentifier(rs.getString("qr_code_identifier"));
        q.setQrImagePath(rs.getString("qr_image_path"));
        q.setTargetUrl(rs.getString("target_url"));
        q.setActive(rs.getBoolean("is_active"));
        q.setCreatedAt(rs.getTimestamp("created_at"));
        q.setUpdatedAt(rs.getTimestamp("updated_at"));

        q.setRoomNumber(rs.getString("room_number"));
        q.setFloor(rs.getInt("floor"));
        q.setLocationName(rs.getString("location_name"));
        q.setBuildingName(rs.getString("building_name"));
        q.setBuildingCode(rs.getString("building_code"));
        return q;
    }
}

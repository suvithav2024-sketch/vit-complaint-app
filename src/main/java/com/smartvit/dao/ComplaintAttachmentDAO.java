package com.smartvit.dao;

import com.smartvit.model.ComplaintAttachment;
import com.smartvit.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ComplaintAttachmentDAO {

    public boolean create(ComplaintAttachment a) {
        String sql = "INSERT INTO complaint_attachments (complaint_id, file_name, file_path, file_type, file_size, attachment_type, uploaded_by) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, a.getComplaintId());
            stmt.setString(2, a.getFileName());
            stmt.setString(3, a.getFilePath());
            stmt.setString(4, a.getFileType());
            stmt.setLong(5, a.getFileSize());
            stmt.setString(6, a.getAttachmentType() != null ? a.getAttachmentType() : "INITIAL");
            stmt.setInt(7, a.getUploadedBy());

            int affected = stmt.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) a.setAttachmentId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<ComplaintAttachment> findByComplaintId(int complaintId) {
        List<ComplaintAttachment> list = new ArrayList<>();
        String sql = "SELECT ca.*, u.full_name as uploaded_by_name " +
                     "FROM complaint_attachments ca " +
                     "JOIN users u ON ca.uploaded_by = u.user_id " +
                     "WHERE ca.complaint_id = ? ORDER BY ca.created_at ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, complaintId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ComplaintAttachment a = new ComplaintAttachment();
                    a.setAttachmentId(rs.getInt("attachment_id"));
                    a.setComplaintId(rs.getInt("complaint_id"));
                    a.setFileName(rs.getString("file_name"));
                    a.setFilePath(rs.getString("file_path"));
                    a.setFileType(rs.getString("file_type"));
                    a.setFileSize(rs.getLong("file_size"));
                    a.setAttachmentType(rs.getString("attachment_type"));
                    a.setUploadedBy(rs.getInt("uploaded_by"));
                    a.setUploadedByName(rs.getString("uploaded_by_name"));
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

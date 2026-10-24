package com.smartvit.dao;

import com.smartvit.model.Complaint;
import com.smartvit.util.DBConnection;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class ComplaintDAO {

    /**
     * Generates sequential complaint code: CMP-YYYY-XXXXX
     */
    public synchronized String generateComplaintCode() {
        int year = LocalDateTime.now().getYear();
        String prefix = "CMP-" + year + "-";
        String sql = "SELECT complaint_code FROM complaints WHERE complaint_code LIKE ? ORDER BY complaint_id DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, prefix + "%");
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String lastCode = rs.getString("complaint_code");
                    String[] parts = lastCode.split("-");
                    if (parts.length == 3) {
                        int lastNum = Integer.parseInt(parts[2]);
                        return String.format("%s%05d", prefix, lastNum + 1);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return prefix + "00001";
    }

    public boolean create(Complaint c) {
        String sql = "INSERT INTO complaints (complaint_code, complainant_id, category_id, subcategory_id, location_id, " +
                     "department_id, assigned_staff_id, title, description, priority, status, due_date, is_overdue) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, c.getComplaintCode());
            stmt.setInt(2, c.getComplainantId());
            stmt.setInt(3, c.getCategoryId());
            stmt.setInt(4, c.getSubcategoryId());
            stmt.setInt(5, c.getLocationId());
            stmt.setInt(6, c.getDepartmentId());
            if (c.getAssignedStaffId() != null && c.getAssignedStaffId() > 0) {
                stmt.setInt(7, c.getAssignedStaffId());
            } else {
                stmt.setNull(7, Types.INTEGER);
            }
            stmt.setString(8, c.getTitle());
            stmt.setString(9, c.getDescription());
            stmt.setString(10, c.getPriority());
            stmt.setString(11, c.getStatus() != null ? c.getStatus() : "SUBMITTED");
            stmt.setTimestamp(12, c.getDueDate());
            stmt.setBoolean(13, c.isOverdue());

            int affected = stmt.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) c.setComplaintId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Complaint findById(int complaintId) {
        String sql = getBaseSelect() + " WHERE c.complaint_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, complaintId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return mapComplaint(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Complaint findByCode(String code) {
        String sql = getBaseSelect() + " WHERE UPPER(c.complaint_code) = UPPER(?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, code.trim());
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return mapComplaint(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Complaint> findByComplainant(int userId, String statusFilter, String priorityFilter, String search, int limit, int offset) {
        List<Complaint> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(getBaseSelect()).append(" WHERE c.complainant_id = ? ");
        List<Object> params = new ArrayList<>();
        params.add(userId);

        applyFilters(sql, params, statusFilter, priorityFilter, null, search);
        sql.append(" ORDER BY c.complaint_id DESC LIMIT ? OFFSET ?");
        params.add(limit);
        params.add(offset);

        return executeComplaintQuery(sql.toString(), params);
    }

    public int countByComplainant(int userId, String statusFilter, String priorityFilter, String search) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM complaints c " +
                "JOIN users u ON c.complainant_id = u.user_id " +
                "JOIN categories cat ON c.category_id = cat.category_id " +
                "JOIN subcategories sub ON c.subcategory_id = sub.subcategory_id " +
                "JOIN locations loc ON c.location_id = loc.location_id " +
                "JOIN buildings b ON loc.building_id = b.building_id " +
                "WHERE c.complainant_id = ? ");
        List<Object> params = new ArrayList<>();
        params.add(userId);

        applyFilters(sql, params, statusFilter, priorityFilter, null, search);
        return executeCountQuery(sql.toString(), params);
    }

    public List<Complaint> findByDepartment(int departmentId, String statusFilter, String priorityFilter, String search, int limit, int offset) {
        StringBuilder sql = new StringBuilder(getBaseSelect()).append(" WHERE c.department_id = ? ");
        List<Object> params = new ArrayList<>();
        params.add(departmentId);

        applyFilters(sql, params, statusFilter, priorityFilter, null, search);
        sql.append(" ORDER BY CASE WHEN c.priority = 'URGENT' THEN 1 WHEN c.priority = 'HIGH' THEN 2 WHEN c.priority = 'MEDIUM' THEN 3 ELSE 4 END, c.complaint_id DESC LIMIT ? OFFSET ?");
        params.add(limit);
        params.add(offset);

        return executeComplaintQuery(sql.toString(), params);
    }

    public int countByDepartment(int departmentId, String statusFilter, String priorityFilter, String search) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM complaints c " +
                "JOIN users u ON c.complainant_id = u.user_id " +
                "JOIN categories cat ON c.category_id = cat.category_id " +
                "JOIN subcategories sub ON c.subcategory_id = sub.subcategory_id " +
                "JOIN locations loc ON c.location_id = loc.location_id " +
                "JOIN buildings b ON loc.building_id = b.building_id " +
                "WHERE c.department_id = ? ");
        List<Object> params = new ArrayList<>();
        params.add(departmentId);

        applyFilters(sql, params, statusFilter, priorityFilter, null, search);
        return executeCountQuery(sql.toString(), params);
    }

    public List<Complaint> findAll(String deptFilter, String statusFilter, String priorityFilter, String categoryFilter, String search, int limit, int offset) {
        StringBuilder sql = new StringBuilder(getBaseSelect()).append(" WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (deptFilter != null && !deptFilter.isEmpty() && !"ALL".equalsIgnoreCase(deptFilter)) {
            sql.append("AND c.department_id = ? ");
            params.add(Integer.parseInt(deptFilter));
        }
        if (categoryFilter != null && !categoryFilter.isEmpty() && !"ALL".equalsIgnoreCase(categoryFilter)) {
            sql.append("AND c.category_id = ? ");
            params.add(Integer.parseInt(categoryFilter));
        }

        applyFilters(sql, params, statusFilter, priorityFilter, null, search);
        sql.append(" ORDER BY c.complaint_id DESC LIMIT ? OFFSET ?");
        params.add(limit);
        params.add(offset);

        return executeComplaintQuery(sql.toString(), params);
    }

    public int countAll(String deptFilter, String statusFilter, String priorityFilter, String categoryFilter, String search) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM complaints c " +
                "JOIN users u ON c.complainant_id = u.user_id " +
                "JOIN categories cat ON c.category_id = cat.category_id " +
                "JOIN subcategories sub ON c.subcategory_id = sub.subcategory_id " +
                "JOIN locations loc ON c.location_id = loc.location_id " +
                "JOIN buildings b ON loc.building_id = b.building_id " +
                "WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (deptFilter != null && !deptFilter.isEmpty() && !"ALL".equalsIgnoreCase(deptFilter)) {
            sql.append("AND c.department_id = ? ");
            params.add(Integer.parseInt(deptFilter));
        }
        if (categoryFilter != null && !categoryFilter.isEmpty() && !"ALL".equalsIgnoreCase(categoryFilter)) {
            sql.append("AND c.category_id = ? ");
            params.add(Integer.parseInt(categoryFilter));
        }

        applyFilters(sql, params, statusFilter, priorityFilter, null, search);
        return executeCountQuery(sql.toString(), params);
    }

    public boolean updateStatus(int complaintId, String newStatus, String resolutionText, Integer resolvedBy) {
        StringBuilder sql = new StringBuilder("UPDATE complaints SET status = ? ");
        List<Object> params = new ArrayList<>();
        params.add(newStatus);

        if ("RESOLVED".equalsIgnoreCase(newStatus)) {
            sql.append(", resolution_text = ?, resolved_by = ?, resolved_at = CURRENT_TIMESTAMP ");
            params.add(resolutionText);
            params.add(resolvedBy);
        } else if ("CLOSED".equalsIgnoreCase(newStatus)) {
            sql.append(", closed_at = CURRENT_TIMESTAMP ");
        } else if ("REOPENED".equalsIgnoreCase(newStatus)) {
            sql.append(", reopened_at = CURRENT_TIMESTAMP ");
        }

        sql.append("WHERE complaint_id = ?");
        params.add(complaintId);

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean assignTechnician(int complaintId, int staffId) {
        String sql = "UPDATE complaints SET assigned_staff_id = ?, status = CASE WHEN status = 'SUBMITTED' THEN 'ASSIGNED' ELSE status END WHERE complaint_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, staffId);
            stmt.setInt(2, complaintId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean reassignDepartment(int complaintId, int departmentId, Integer staffId) {
        String sql = "UPDATE complaints SET department_id = ?, assigned_staff_id = ?, status = 'ASSIGNED' WHERE complaint_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, departmentId);
            if (staffId != null && staffId > 0) {
                stmt.setInt(2, staffId);
            } else {
                stmt.setNull(2, Types.INTEGER);
            }
            stmt.setInt(3, complaintId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int countByStatus(Integer userId, Integer departmentId, String status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM complaints WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (userId != null) {
            sql.append("AND complainant_id = ? ");
            params.add(userId);
        }
        if (departmentId != null) {
            sql.append("AND department_id = ? ");
            params.add(departmentId);
        }
        if (status != null && !status.isEmpty() && !"ALL".equalsIgnoreCase(status)) {
            sql.append("AND status = ? ");
            params.add(status);
        }

        return executeCountQuery(sql.toString(), params);
    }

    public int countOverdue(Integer userId, Integer departmentId) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM complaints WHERE (is_overdue = TRUE OR (due_date IS NOT NULL AND due_date < NOW())) AND status NOT IN ('RESOLVED', 'CLOSED') ");
        List<Object> params = new ArrayList<>();

        if (userId != null) {
            sql.append("AND complainant_id = ? ");
            params.add(userId);
        }
        if (departmentId != null) {
            sql.append("AND department_id = ? ");
            params.add(departmentId);
        }

        return executeCountQuery(sql.toString(), params);
    }

    public List<Complaint> findOverdueComplaints() {
        return findOverdueComplaints(100);
    }

    public List<Complaint> findOverdueComplaints(int limit) {
        String sql = getBaseSelect() + " WHERE (c.is_overdue = TRUE OR (c.due_date IS NOT NULL AND c.due_date < NOW())) AND c.status NOT IN ('RESOLVED', 'CLOSED') ORDER BY c.due_date ASC LIMIT ?";
        List<Object> params = new ArrayList<>();
        params.add(limit);
        return executeComplaintQuery(sql, params);
    }

    public int markOverdueComplaints() {
        String sql = "UPDATE complaints SET is_overdue = TRUE WHERE due_date IS NOT NULL AND due_date < NOW() AND status NOT IN ('RESOLVED', 'CLOSED') AND is_overdue = FALSE";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            return stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public void updateOverdueFlags() {
        markOverdueComplaints();
    }

    public List<Complaint> findByComplainantId(int userId) {
        return findByComplainant(userId, null, null, null, 100, 0);
    }

    public List<Complaint> findByDepartmentId(int departmentId) {
        return findByDepartment(departmentId, null, null, null, 100, 0);
    }

    public int countComplaints(String status, Integer departmentId) {
        return countByStatus(null, departmentId, status);
    }

    public List<Complaint> findAll(int limit, int offset, String search, String status) {
        return findAll(null, status, null, null, search, limit, offset);
    }

    private void applyFilters(StringBuilder sql, List<Object> params, String statusFilter, String priorityFilter, String buildingFilter, String search) {
        if (statusFilter != null && !statusFilter.isEmpty() && !"ALL".equalsIgnoreCase(statusFilter)) {
            sql.append("AND c.status = ? ");
            params.add(statusFilter.toUpperCase());
        }
        if (priorityFilter != null && !priorityFilter.isEmpty() && !"ALL".equalsIgnoreCase(priorityFilter)) {
            sql.append("AND c.priority = ? ");
            params.add(priorityFilter.toUpperCase());
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (LOWER(c.complaint_code) LIKE ? OR LOWER(c.title) LIKE ? OR LOWER(u.full_name) LIKE ? OR LOWER(u.reg_emp_no) LIKE ? OR LOWER(b.name) LIKE ? OR LOWER(loc.room_number) LIKE ?) ");
            String s = "%" + search.trim().toLowerCase() + "%";
            for (int i = 0; i < 6; i++) {
                params.add(s);
            }
        }
    }

    private List<Complaint> executeComplaintQuery(String sql, List<Object> params) {
        List<Complaint> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapComplaint(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private int executeCountQuery(String sql, List<Object> params) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private String getBaseSelect() {
        return "SELECT c.*, " +
               "u.full_name as complainant_name, u.email as complainant_email, u.reg_emp_no as complainant_reg_no, u.phone as complainant_phone, " +
               "cat.name as category_name, sub.name as subcategory_name, " +
               "loc.room_number, loc.floor, loc.block, loc.location_name, " +
               "b.name as building_name, b.code as building_code, " +
               "d.name as department_name, d.contact_email as department_email, d.contact_phone as department_phone, " +
               "su.full_name as assigned_staff_name, ds.phone as assigned_staff_phone, ds.email as assigned_staff_email, " +
               "ru.full_name as resolved_by_name " +
               "FROM complaints c " +
               "JOIN users u ON c.complainant_id = u.user_id " +
               "JOIN categories cat ON c.category_id = cat.category_id " +
               "JOIN subcategories sub ON c.subcategory_id = sub.subcategory_id " +
               "JOIN locations loc ON c.location_id = loc.location_id " +
               "JOIN buildings b ON loc.building_id = b.building_id " +
               "JOIN departments d ON c.department_id = d.department_id " +
               "LEFT JOIN department_staff ds ON c.assigned_staff_id = ds.staff_id " +
               "LEFT JOIN users su ON ds.user_id = su.user_id " +
               "LEFT JOIN users ru ON c.resolved_by = ru.user_id ";
    }

    private Complaint mapComplaint(ResultSet rs) throws SQLException {
        Complaint c = new Complaint();
        c.setComplaintId(rs.getInt("complaint_id"));
        c.setComplaintCode(rs.getString("complaint_code"));
        c.setComplainantId(rs.getInt("complainant_id"));
        c.setComplainantName(rs.getString("complainant_name"));
        c.setComplainantEmail(rs.getString("complainant_email"));
        c.setComplainantRegNo(rs.getString("complainant_reg_no"));
        c.setComplainantPhone(rs.getString("complainant_phone"));

        c.setCategoryId(rs.getInt("category_id"));
        c.setCategoryName(rs.getString("category_name"));
        c.setSubcategoryId(rs.getInt("subcategory_id"));
        c.setSubcategoryName(rs.getString("subcategory_name"));

        c.setLocationId(rs.getInt("location_id"));
        c.setBuildingName(rs.getString("building_name"));
        c.setBuildingCode(rs.getString("building_code"));
        c.setRoomNumber(rs.getString("room_number"));
        c.setFloor(rs.getInt("floor"));
        c.setBlock(rs.getString("block"));
        c.setLocationDisplayName(c.getBuildingName() + " - Room " + c.getRoomNumber());

        c.setDepartmentId(rs.getInt("department_id"));
        c.setDepartmentName(rs.getString("department_name"));
        c.setDepartmentEmail(rs.getString("department_email"));
        c.setDepartmentPhone(rs.getString("department_phone"));

        int staffId = rs.getInt("assigned_staff_id");
        if (!rs.wasNull()) {
            c.setAssignedStaffId(staffId);
            c.setAssignedStaffName(rs.getString("assigned_staff_name"));
            c.setAssignedStaffPhone(rs.getString("assigned_staff_phone"));
            c.setAssignedStaffEmail(rs.getString("assigned_staff_email"));
        }

        c.setTitle(rs.getString("title"));
        c.setDescription(rs.getString("description"));
        c.setPriority(rs.getString("priority"));
        c.setStatus(rs.getString("status"));
        c.setResolutionText(rs.getString("resolution_text"));

        int resBy = rs.getInt("resolved_by");
        if (!rs.wasNull()) {
            c.setResolvedBy(resBy);
            c.setResolvedByName(rs.getString("resolved_by_name"));
        }

        c.setResolvedAt(rs.getTimestamp("resolved_at"));
        c.setClosedAt(rs.getTimestamp("closed_at"));
        c.setReopenedAt(rs.getTimestamp("reopened_at"));
        c.setDueDate(rs.getTimestamp("due_date"));
        c.setOverdue(rs.getBoolean("is_overdue") || (c.getDueDate() != null && c.getDueDate().before(new java.util.Date()) && !"RESOLVED".equals(c.getStatus()) && !"CLOSED".equals(c.getStatus())));
        c.setCreatedAt(rs.getTimestamp("created_at"));
        c.setUpdatedAt(rs.getTimestamp("updated_at"));

        return c;
    }
}

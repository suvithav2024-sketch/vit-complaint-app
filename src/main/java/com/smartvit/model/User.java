package com.smartvit.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class User implements Serializable {
    private static final long serialVersionUID = 1L;

    private int userId;
    private String fullName;
    private String email;
    private String regEmpNo;
    private String passwordHash;
    private String phone;
    private int roleId;
    private String roleName;
    private String schoolDept;
    private String hostelBlock;
    private String roomNo;
    private boolean active;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public User() {}

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getRegEmpNo() { return regEmpNo; }
    public void setRegEmpNo(String regEmpNo) { this.regEmpNo = regEmpNo; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public int getRoleId() { return roleId; }
    public void setRoleId(int roleId) { this.roleId = roleId; }

    public String getRoleName() { return roleName; }
    public void setRoleName(String roleName) { this.roleName = roleName; }

    public String getSchoolDept() { return schoolDept; }
    public void setSchoolDept(String schoolDept) { this.schoolDept = schoolDept; }

    public String getHostelBlock() { return hostelBlock; }
    public void setHostelBlock(String hostelBlock) { this.hostelBlock = hostelBlock; }

    public String getRoomNo() { return roomNo; }
    public void setRoomNo(String roomNo) { this.roomNo = roomNo; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public boolean isStudent() { return "STUDENT".equalsIgnoreCase(roleName); }
    public boolean isStaff() { return "STAFF".equalsIgnoreCase(roleName); }
    public boolean isDepartmentStaff() { return "DEPARTMENT_STAFF".equalsIgnoreCase(roleName); }
    public boolean isAdmin() { return "ADMIN".equalsIgnoreCase(roleName); }
}

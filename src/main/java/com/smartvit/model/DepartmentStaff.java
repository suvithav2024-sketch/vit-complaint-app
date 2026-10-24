package com.smartvit.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class DepartmentStaff implements Serializable {
    private static final long serialVersionUID = 1L;

    private int staffId;
    private int userId;
    private int departmentId;
    private String staffName;
    private String departmentName;
    private String designation;
    private String specialization;
    private String phone;
    private String email;
    private String officeLocation;
    private String availabilityStatus; // AVAILABLE, ON_LEAVE, BUSY
    private Timestamp createdAt;

    public DepartmentStaff() {}

    public int getStaffId() { return staffId; }
    public void setStaffId(int staffId) { this.staffId = staffId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getDepartmentId() { return departmentId; }
    public void setDepartmentId(int departmentId) { this.departmentId = departmentId; }

    public String getStaffName() { return staffName; }
    public void setStaffName(String staffName) { this.staffName = staffName; }

    public String getDepartmentName() { return departmentName; }
    public void setDepartmentName(String departmentName) { this.departmentName = departmentName; }

    public String getDesignation() { return designation; }
    public void setDesignation(String designation) { this.designation = designation; }

    public String getSpecialization() { return specialization; }
    public void setSpecialization(String specialization) { this.specialization = specialization; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getOfficeLocation() { return officeLocation; }
    public void setOfficeLocation(String officeLocation) { this.officeLocation = officeLocation; }

    public String getAvailabilityStatus() { return availabilityStatus; }
    public void setAvailabilityStatus(String availabilityStatus) { this.availabilityStatus = availabilityStatus; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    // Alias getters for JSP EL compatibility
    public int getId() { return staffId; }
    public String getName() { return staffName != null ? staffName : ""; }
    public boolean isActive() { return "AVAILABLE".equalsIgnoreCase(availabilityStatus); }
}


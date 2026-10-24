package com.smartvit.model;

import java.io.Serializable;

public class Building implements Serializable {
    private static final long serialVersionUID = 1L;

    private int buildingId;
    private int campusId;
    private String campusName;
    private String name;
    private String code;
    private String type; // ACADEMIC, HOSTEL, FACILITY, MESS, OTHER
    private int totalFloors;
    private boolean active;

    public Building() {}

    public int getBuildingId() { return buildingId; }
    public void setBuildingId(int buildingId) { this.buildingId = buildingId; }

    public int getCampusId() { return campusId; }
    public void setCampusId(int campusId) { this.campusId = campusId; }

    public String getCampusName() { return campusName; }
    public void setCampusName(String campusName) { this.campusName = campusName; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public int getTotalFloors() { return totalFloors; }
    public void setTotalFloors(int totalFloors) { this.totalFloors = totalFloors; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }
}

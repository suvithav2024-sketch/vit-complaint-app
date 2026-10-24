package com.smartvit.model;

import java.io.Serializable;

public class Campus implements Serializable {
    private static final long serialVersionUID = 1L;

    private int campusId;
    private String name;
    private String code;
    private String location;

    public Campus() {}

    public Campus(int campusId, String name, String code, String location) {
        this.campusId = campusId;
        this.name = name;
        this.code = code;
        this.location = location;
    }

    public int getCampusId() { return campusId; }
    public void setCampusId(int campusId) { this.campusId = campusId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
}

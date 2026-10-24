package com.smartvit.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Location implements Serializable {
    private static final long serialVersionUID = 1L;

    private int locationId;
    private int buildingId;
    private String buildingName;
    private String buildingCode;
    private String block;
    private int floor;
    private String roomNumber;
    private String locationName;
    private String description;
    private boolean active;
    private Timestamp createdAt;

    public Location() {}

    public int getLocationId() { return locationId; }
    public void setLocationId(int locationId) { this.locationId = locationId; }

    public int getBuildingId() { return buildingId; }
    public void setBuildingId(int buildingId) { this.buildingId = buildingId; }

    public String getBuildingName() { return buildingName; }
    public void setBuildingName(String buildingName) { this.buildingName = buildingName; }

    public String getBuildingCode() { return buildingCode; }
    public void setBuildingCode(String buildingCode) { this.buildingCode = buildingCode; }

    public String getBlock() { return block; }
    public void setBlock(String block) { this.block = block; }

    public int getFloor() { return floor; }
    public void setFloor(int floor) { this.floor = floor; }

    public String getRoomNumber() { return roomNumber; }
    public void setRoomNumber(String roomNumber) { this.roomNumber = roomNumber; }

    public String getLocationName() { return locationName; }
    public void setLocationName(String locationName) { this.locationName = locationName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getDisplayName() {
        return (buildingName != null ? buildingName : "Building") + 
               (roomNumber != null && !roomNumber.isEmpty() ? " - Room " + roomNumber : "") +
               (locationName != null && !locationName.isEmpty() ? " (" + locationName + ")" : "");
    }
}

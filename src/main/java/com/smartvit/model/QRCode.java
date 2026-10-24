package com.smartvit.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class QRCode implements Serializable {
    private static final long serialVersionUID = 1L;

    private int qrId;
    private int locationId;
    private String qrCodeIdentifier;
    private String qrImagePath;
    private String targetUrl;
    private boolean active;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Joined location details
    private String buildingName;
    private String buildingCode;
    private String roomNumber;
    private int floor;
    private String locationName;

    public QRCode() {}

    public int getQrId() { return qrId; }
    public void setQrId(int qrId) { this.qrId = qrId; }

    public int getLocationId() { return locationId; }
    public void setLocationId(int locationId) { this.locationId = locationId; }

    public String getQrCodeIdentifier() { return qrCodeIdentifier; }
    public void setQrCodeIdentifier(String qrCodeIdentifier) { this.qrCodeIdentifier = qrCodeIdentifier; }

    public String getQrImagePath() { return qrImagePath; }
    public void setQrImagePath(String qrImagePath) { this.qrImagePath = qrImagePath; }

    public String getTargetUrl() { return targetUrl; }
    public void setTargetUrl(String targetUrl) { this.targetUrl = targetUrl; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public String getBuildingName() { return buildingName; }
    public void setBuildingName(String buildingName) { this.buildingName = buildingName; }

    public String getBuildingCode() { return buildingCode; }
    public void setBuildingCode(String buildingCode) { this.buildingCode = buildingCode; }

    public String getRoomNumber() { return roomNumber; }
    public void setRoomNumber(String roomNumber) { this.roomNumber = roomNumber; }

    public int getFloor() { return floor; }
    public void setFloor(int floor) { this.floor = floor; }

    public String getLocationName() { return locationName; }
    public void setLocationName(String locationName) { this.locationName = locationName; }

    public String getLocationSummary() {
        return (buildingName != null ? buildingName : "") + 
               (roomNumber != null ? " - Room " + roomNumber : "") +
               (locationName != null ? " (" + locationName + ")" : "");
    }
}

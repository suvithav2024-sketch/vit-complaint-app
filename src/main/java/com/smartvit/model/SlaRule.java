package com.smartvit.model;

import java.io.Serializable;

public class SlaRule implements Serializable {
    private static final long serialVersionUID = 1L;

    private int slaId;
    private String priority; // LOW, MEDIUM, HIGH, URGENT
    private int maxResolutionHours;
    private int escalationHours;
    private String description;

    public SlaRule() {}

    public SlaRule(int slaId, String priority, int maxResolutionHours, int escalationHours, String description) {
        this.slaId = slaId;
        this.priority = priority;
        this.maxResolutionHours = maxResolutionHours;
        this.escalationHours = escalationHours;
        this.description = description;
    }

    public int getSlaId() { return slaId; }
    public void setSlaId(int slaId) { this.slaId = slaId; }

    public String getPriority() { return priority; }
    public void setPriority(String priority) { this.priority = priority; }

    public int getMaxResolutionHours() { return maxResolutionHours; }
    public void setMaxResolutionHours(int maxResolutionHours) { this.maxResolutionHours = maxResolutionHours; }

    public int getEscalationHours() { return escalationHours; }
    public void setEscalationHours(int escalationHours) { this.escalationHours = escalationHours; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}

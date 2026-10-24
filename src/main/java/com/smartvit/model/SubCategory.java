package com.smartvit.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class SubCategory implements Serializable {
    private static final long serialVersionUID = 1L;

    private int subcategoryId;
    private int categoryId;
    private String categoryName;
    private String name;
    private String description;
    private String defaultPriority; // LOW, MEDIUM, HIGH, URGENT
    private boolean active;
    private Timestamp createdAt;

    public SubCategory() {}

    public int getSubcategoryId() { return subcategoryId; }
    public void setSubcategoryId(int subcategoryId) { this.subcategoryId = subcategoryId; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getDefaultPriority() { return defaultPriority; }
    public void setDefaultPriority(String defaultPriority) { this.defaultPriority = defaultPriority; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}

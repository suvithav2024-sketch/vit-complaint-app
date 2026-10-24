package com.smartvit.model;

import java.io.Serializable;

public class CategoryDepartmentMapping implements Serializable {
    private static final long serialVersionUID = 1L;

    private int mappingId;
    private int categoryId;
    private String categoryName;
    private Integer subcategoryId;
    private String subcategoryName;
    private int departmentId;
    private String departmentName;
    private boolean active;

    public CategoryDepartmentMapping() {}

    public int getMappingId() { return mappingId; }
    public void setMappingId(int mappingId) { this.mappingId = mappingId; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public Integer getSubcategoryId() { return subcategoryId; }
    public void setSubcategoryId(Integer subcategoryId) { this.subcategoryId = subcategoryId; }

    public String getSubcategoryName() { return subcategoryName; }
    public void setSubcategoryName(String subcategoryName) { this.subcategoryName = subcategoryName; }

    public int getDepartmentId() { return departmentId; }
    public void setDepartmentId(int departmentId) { this.departmentId = departmentId; }

    public String getDepartmentName() { return departmentName; }
    public void setDepartmentName(String departmentName) { this.departmentName = departmentName; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }
}

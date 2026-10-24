package com.smartvit.controller;

import com.smartvit.dao.CategoryDAO;
import com.smartvit.dao.DepartmentDAO;
import com.smartvit.dao.MappingDAO;
import com.smartvit.dao.SubCategoryDAO;
import com.smartvit.model.Category;
import com.smartvit.model.CategoryDepartmentMapping;
import com.smartvit.model.Department;
import com.smartvit.model.SubCategory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/categories")
public class AdminCategoriesServlet extends HttpServlet {
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final SubCategoryDAO subCategoryDAO = new SubCategoryDAO();
    private final DepartmentDAO departmentDAO = new DepartmentDAO();
    private final MappingDAO mappingDAO = new MappingDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Category> categories = categoryDAO.findAll();
        List<SubCategory> subcategories = subCategoryDAO.findAll();
        List<Department> departments = departmentDAO.findAllActive();
        List<CategoryDepartmentMapping> mappings = mappingDAO.findAll();

        req.setAttribute("categories", categories);
        req.setAttribute("subcategories", subcategories);
        req.setAttribute("departments", departments);
        req.setAttribute("mappings", mappings);

        req.getRequestDispatcher("/admin/categories.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("createCategory".equals(action)) {
            String name = req.getParameter("name");
            String code = req.getParameter("code");
            String icon = req.getParameter("icon");
            String description = req.getParameter("description");

            Category c = new Category();
            c.setName(name);
            c.setCode(code.toUpperCase());
            c.setIcon(icon != null && !icon.isEmpty() ? icon : "bi-folder");
            c.setDescription(description);
            c.setActive(true);

            categoryDAO.create(c);
            resp.sendRedirect(req.getContextPath() + "/admin/categories?categoryCreated=true");
            return;
        } else if ("createSubCategory".equals(action)) {
            int categoryId = Integer.parseInt(req.getParameter("categoryId"));
            String name = req.getParameter("name");
            String description = req.getParameter("description");
            String priority = req.getParameter("defaultPriority");

            SubCategory s = new SubCategory();
            s.setCategoryId(categoryId);
            s.setName(name);
            s.setDescription(description);
            s.setDefaultPriority(priority != null ? priority : "MEDIUM");
            s.setActive(true);

            subCategoryDAO.create(s);
            resp.sendRedirect(req.getContextPath() + "/admin/categories?subCategoryCreated=true");
            return;
        } else if ("createMapping".equals(action)) {
            int categoryId = Integer.parseInt(req.getParameter("categoryId"));
            String subcategoryStr = req.getParameter("subcategoryId");
            int departmentId = Integer.parseInt(req.getParameter("departmentId"));

            CategoryDepartmentMapping m = new CategoryDepartmentMapping();
            m.setCategoryId(categoryId);
            if (subcategoryStr != null && !subcategoryStr.isEmpty() && !"ALL".equalsIgnoreCase(subcategoryStr)) {
                m.setSubcategoryId(Integer.parseInt(subcategoryStr));
            }
            m.setDepartmentId(departmentId);
            m.setActive(true);

            mappingDAO.create(m);
            resp.sendRedirect(req.getContextPath() + "/admin/categories?mappingCreated=true");
            return;
        } else if ("deleteMapping".equals(action)) {
            int mappingId = Integer.parseInt(req.getParameter("mappingId"));
            mappingDAO.delete(mappingId);
            resp.sendRedirect(req.getContextPath() + "/admin/categories?mappingDeleted=true");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/admin/categories");
    }
}

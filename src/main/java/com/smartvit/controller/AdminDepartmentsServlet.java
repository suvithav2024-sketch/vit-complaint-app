package com.smartvit.controller;

import com.smartvit.dao.DepartmentDAO;
import com.smartvit.dao.DepartmentStaffDAO;
import com.smartvit.dao.UserDAO;
import com.smartvit.model.Department;
import com.smartvit.model.DepartmentStaff;
import com.smartvit.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/departments")
public class AdminDepartmentsServlet extends HttpServlet {
    private final DepartmentDAO departmentDAO = new DepartmentDAO();
    private final DepartmentStaffDAO staffDAO = new DepartmentStaffDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Department> departments = departmentDAO.findAll();
        List<DepartmentStaff> staffList = staffDAO.findAll();
        List<User> potentialStaffUsers = userDAO.findAll(100, 0, null, "DEPARTMENT_STAFF");

        req.setAttribute("departments", departments);
        req.setAttribute("staffList", staffList);
        req.setAttribute("potentialUsers", potentialStaffUsers);

        req.getRequestDispatcher("/admin/departments.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("createDepartment".equals(action)) {
            String name = req.getParameter("name");
            String code = req.getParameter("code");
            String description = req.getParameter("description");
            String email = req.getParameter("contactEmail");
            String phone = req.getParameter("contactPhone");
            String office = req.getParameter("officeLocation");

            Department d = new Department();
            d.setName(name);
            d.setCode(code.toUpperCase());
            d.setDescription(description);
            d.setContactEmail(email);
            d.setContactPhone(phone);
            d.setOfficeLocation(office);
            d.setActive(true);

            departmentDAO.create(d);
            resp.sendRedirect(req.getContextPath() + "/admin/departments?deptCreated=true");
            return;
        } else if ("createStaff".equals(action)) {
            int userId = Integer.parseInt(req.getParameter("userId"));
            int deptId = Integer.parseInt(req.getParameter("departmentId"));
            String designation = req.getParameter("designation");
            String specialization = req.getParameter("specialization");
            String phone = req.getParameter("phone");
            String email = req.getParameter("email");
            String office = req.getParameter("officeLocation");

            DepartmentStaff s = new DepartmentStaff();
            s.setUserId(userId);
            s.setDepartmentId(deptId);
            s.setDesignation(designation);
            s.setSpecialization(specialization);
            s.setPhone(phone);
            s.setEmail(email);
            s.setOfficeLocation(office);
            s.setAvailabilityStatus("AVAILABLE");

            staffDAO.create(s);
            resp.sendRedirect(req.getContextPath() + "/admin/departments?staffCreated=true");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/admin/departments");
    }
}

package com.smartvit.controller;

import com.google.gson.Gson;
import com.smartvit.dao.ComplaintDAO;
import com.smartvit.dao.LocationDAO;
import com.smartvit.dao.SubCategoryDAO;
import com.smartvit.model.Complaint;
import com.smartvit.model.Location;
import com.smartvit.model.SubCategory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = {"/api/subcategories", "/api/locations", "/api/track-public"})
public class AjaxDataServlet extends HttpServlet {
    private final SubCategoryDAO subCategoryDAO = new SubCategoryDAO();
    private final LocationDAO locationDAO = new LocationDAO();
    private final ComplaintDAO complaintDAO = new ComplaintDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        resp.setContentType("application/json;charset=UTF-8");

        if ("/api/subcategories".equals(path)) {
            String catIdStr = req.getParameter("categoryId");
            if (catIdStr != null && !catIdStr.isEmpty()) {
                try {
                    int catId = Integer.parseInt(catIdStr);
                    List<SubCategory> subList = subCategoryDAO.findByCategoryId(catId);
                    resp.getWriter().write(gson.toJson(subList));
                    return;
                } catch (NumberFormatException ignored) {}
            }
            resp.getWriter().write("[]");
        } else if ("/api/locations".equals(path)) {
            String bldgIdStr = req.getParameter("buildingId");
            if (bldgIdStr != null && !bldgIdStr.isEmpty()) {
                try {
                    int bldgId = Integer.parseInt(bldgIdStr);
                    List<Location> locList = locationDAO.findByBuildingId(bldgId);
                    resp.getWriter().write(gson.toJson(locList));
                    return;
                } catch (NumberFormatException ignored) {}
            }
            resp.getWriter().write("[]");
        } else if ("/api/track-public".equals(path)) {
            String code = req.getParameter("code");
            if (code != null && !code.trim().isEmpty()) {
                Complaint c = complaintDAO.findByCode(code.trim());
                if (c != null) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("found", true);
                    map.put("code", c.getComplaintCode());
                    map.put("title", c.getTitle());
                    map.put("category", c.getCategoryName());
                    map.put("department", c.getDepartmentName());
                    map.put("status", c.getStatus());
                    map.put("priority", c.getPriority());
                    map.put("date", c.getCreatedAt() != null ? c.getCreatedAt().toString() : "");
                    map.put("resolution", c.getResolutionText());
                    resp.getWriter().write(gson.toJson(map));
                    return;
                }
            }
            resp.getWriter().write("{\"found\":false}");
        }
    }
}

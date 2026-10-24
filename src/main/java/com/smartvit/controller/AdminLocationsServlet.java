package com.smartvit.controller;

import com.smartvit.dao.BuildingDAO;
import com.smartvit.dao.LocationDAO;
import com.smartvit.model.Building;
import com.smartvit.model.Location;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/locations")
public class AdminLocationsServlet extends HttpServlet {
    private final BuildingDAO buildingDAO = new BuildingDAO();
    private final LocationDAO locationDAO = new LocationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Building> buildings = buildingDAO.findAll();
        List<Location> locations = locationDAO.findAll();

        req.setAttribute("buildings", buildings);
        req.setAttribute("locations", locations);

        req.getRequestDispatcher("/admin/locations.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("createBuilding".equals(action)) {
            String name = req.getParameter("name");
            String code = req.getParameter("code");
            String type = req.getParameter("type");
            int totalFloors = Integer.parseInt(req.getParameter("totalFloors"));

            Building b = new Building();
            b.setCampusId(1);
            b.setName(name);
            b.setCode(code.toUpperCase());
            b.setType(type);
            b.setTotalFloors(totalFloors);
            b.setActive(true);

            buildingDAO.create(b);
            resp.sendRedirect(req.getContextPath() + "/admin/locations?buildingCreated=true");
            return;
        } else if ("createLocation".equals(action)) {
            int buildingId = Integer.parseInt(req.getParameter("buildingId"));
            String block = req.getParameter("block");
            int floor = Integer.parseInt(req.getParameter("floor"));
            String roomNumber = req.getParameter("roomNumber");
            String locationName = req.getParameter("locationName");
            String description = req.getParameter("description");

            Location loc = new Location();
            loc.setBuildingId(buildingId);
            loc.setBlock(block);
            loc.setFloor(floor);
            loc.setRoomNumber(roomNumber);
            loc.setLocationName(locationName);
            loc.setDescription(description);
            loc.setActive(true);

            locationDAO.create(loc);
            resp.sendRedirect(req.getContextPath() + "/admin/locations?locationCreated=true");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/admin/locations");
    }
}

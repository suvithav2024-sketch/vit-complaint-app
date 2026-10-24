package com.smartvit.controller;

import com.smartvit.dao.LocationDAO;
import com.smartvit.dao.QRCodeDAO;
import com.smartvit.model.Location;
import com.smartvit.model.QRCode;
import com.smartvit.service.QRCodeService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/qr-codes")
public class AdminQRCodesServlet extends HttpServlet {
    private final QRCodeDAO qrDAO = new QRCodeDAO();
    private final LocationDAO locationDAO = new LocationDAO();
    private final QRCodeService qrService = new QRCodeService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<QRCode> qrCodes = qrDAO.findAll();
        List<Location> locations = locationDAO.findAll();

        req.setAttribute("qrCodes", qrCodes);
        req.setAttribute("locations", locations);

        req.getRequestDispatcher("/admin/qrCodes.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String baseUrl = req.getScheme() + "://" + req.getServerName() + ":" + req.getServerPort() + req.getContextPath();
        String uploadsDir = req.getServletContext().getRealPath("");

        if ("generate".equals(action)) {
            int locationId = Integer.parseInt(req.getParameter("locationId"));
            qrService.generateQRCodeForLocation(locationId, baseUrl, uploadsDir);
            resp.sendRedirect(req.getContextPath() + "/admin/qr-codes?generated=true");
            return;
        } else if ("regenerate".equals(action)) {
            int qrId = Integer.parseInt(req.getParameter("qrId"));
            QRCode qr = qrDAO.findById(qrId);
            if (qr != null) {
                qrService.generateQRCodeForLocation(qr.getLocationId(), baseUrl, uploadsDir);
            }
            resp.sendRedirect(req.getContextPath() + "/admin/qr-codes?regenerated=true");
            return;
        } else if ("toggleActive".equals(action)) {
            int qrId = Integer.parseInt(req.getParameter("qrId"));
            boolean active = Boolean.parseBoolean(req.getParameter("active"));
            qrDAO.toggleActive(qrId, active);
            resp.sendRedirect(req.getContextPath() + "/admin/qr-codes?statusChanged=true");
            return;
        } else if ("delete".equals(action)) {
            int qrId = Integer.parseInt(req.getParameter("qrId"));
            qrDAO.delete(qrId);
            resp.sendRedirect(req.getContextPath() + "/admin/qr-codes?deleted=true");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/admin/qr-codes");
    }
}

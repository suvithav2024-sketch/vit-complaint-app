package com.smartvit.controller;

import com.smartvit.dao.QRCodeDAO;
import com.smartvit.model.QRCode;
import com.smartvit.util.QRCodeUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

@WebServlet("/qr/view")
public class QRCodeViewServlet extends HttpServlet {
    private final QRCodeDAO qrDAO = new QRCodeDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        String download = req.getParameter("download");

        if (idStr == null || idStr.isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing QR ID");
            return;
        }

        try {
            int qrId = Integer.parseInt(idStr);
            QRCode qr = qrDAO.findById(qrId);
            if (qr == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "QR Code not found");
                return;
            }

            resp.setContentType("image/png");
            if ("true".equalsIgnoreCase(download)) {
                resp.setHeader("Content-Disposition", "attachment; filename=\"" + qr.getQrCodeIdentifier() + ".png\"");
            }

            // Check if file exists on disk
            String realPath = req.getServletContext().getRealPath("/" + qr.getQrImagePath());
            File file = (realPath != null) ? new File(realPath) : null;

            if (file != null && file.exists()) {
                try (FileInputStream fis = new FileInputStream(file);
                     OutputStream out = resp.getOutputStream()) {
                    byte[] buffer = new byte[4096];
                    int bytesRead;
                    while ((bytesRead = fis.read(buffer)) != -1) {
                        out.write(buffer, 0, bytesRead);
                    }
                }
            } else {
                // Generate dynamically on-the-fly using ZXing!
                String baseUrl = req.getScheme() + "://" + req.getServerName() + ":" + req.getServerPort() + req.getContextPath();
                String targetUrl = baseUrl + qr.getTargetUrl();
                byte[] qrBytes = QRCodeUtil.generateQRCodeBytes(targetUrl, 300, 300);
                resp.setContentLength(qrBytes.length);
                try (OutputStream out = resp.getOutputStream()) {
                    out.write(qrBytes);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error rendering QR code: " + e.getMessage());
        }
    }
}

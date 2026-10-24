package com.smartvit.service;

import com.smartvit.dao.LocationDAO;
import com.smartvit.dao.QRCodeDAO;
import com.smartvit.model.Location;
import com.smartvit.model.QRCode;
import com.smartvit.util.QRCodeUtil;

import java.io.File;

public class QRCodeService {
    private final QRCodeDAO qrDAO = new QRCodeDAO();
    private final LocationDAO locationDAO = new LocationDAO();

    /**
     * Generates or regenerates a QR code for a campus location.
     */
    public QRCode generateQRCodeForLocation(int locationId, String appBaseUrl, String uploadsDir) {
        Location loc = locationDAO.findById(locationId);
        if (loc == null) return null;

        String identifier = "QR-LOC-" + String.format("%04d", locationId) + "-" + 
                            (loc.getBuildingCode() != null ? loc.getBuildingCode() : "BLD") + "-" + 
                            loc.getRoomNumber().replaceAll("[^a-zA-Z0-9]", "");

        String targetUrl = "/student/raise-complaint?locationId=" + locationId;
        String fullUrl = appBaseUrl + targetUrl;

        String relativePath = "uploads/qr/qr_loc_" + locationId + ".png";
        String absolutePath = uploadsDir + File.separator + "uploads" + File.separator + "qr" + File.separator + "qr_loc_" + locationId + ".png";

        try {
            QRCodeUtil.generateQRCodeFile(fullUrl, 350, 350, absolutePath);
        } catch (Exception e) {
            e.printStackTrace();
        }

        QRCode qr = qrDAO.findByLocationId(locationId);
        if (qr == null) {
            qr = new QRCode();
            qr.setLocationId(locationId);
            qr.setQrCodeIdentifier(identifier);
            qr.setQrImagePath(relativePath);
            qr.setTargetUrl(targetUrl);
            qr.setActive(true);
            qrDAO.create(qr);
        } else {
            qr.setQrCodeIdentifier(identifier);
            qr.setQrImagePath(relativePath);
            qr.setTargetUrl(targetUrl);
            qr.setActive(true);
            qrDAO.update(qr);
        }

        return qr;
    }
}

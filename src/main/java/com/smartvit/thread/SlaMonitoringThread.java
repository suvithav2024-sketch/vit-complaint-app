package com.smartvit.thread;

import com.smartvit.dao.ComplaintDAO;
import com.smartvit.dao.NotificationDAO;
import com.smartvit.model.Complaint;
import com.smartvit.model.Notification;

import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Background Daemon Worker Thread for SLA Monitoring in Smart VIT.
 * Demonstrates Multithreading (Runnable interface, thread loops, sleep, synchronization).
 * Regularly scans open complaints to check for SLA breaches and send escalation notifications.
 */
public class SlaMonitoringThread implements Runnable {
    private static final Logger LOGGER = Logger.getLogger(SlaMonitoringThread.class.getName());

    private final ComplaintDAO complaintDAO = new ComplaintDAO();
    private final NotificationDAO notificationDAO = new NotificationDAO();

    private volatile boolean running = true;
    private final long checkIntervalMs;

    public SlaMonitoringThread(long checkIntervalMs) {
        this.checkIntervalMs = checkIntervalMs;
    }

    @Override
    public void run() {
        LOGGER.info("[SLA Monitoring Thread] SLA Monitor Worker Started. Checking every " + (checkIntervalMs / 1000) + " seconds.");

        while (running) {
            try {
                performSlaCheck();
                Thread.sleep(checkIntervalMs);
            } catch (InterruptedException e) {
                LOGGER.info("[SLA Monitoring Thread] SLA Monitor thread interrupted, stopping worker loop.");
                Thread.currentThread().interrupt();
                break;
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "[SLA Monitoring Thread] Error during SLA monitoring cycle", e);
            }
        }

        LOGGER.info("[SLA Monitoring Thread] SLA Monitor Worker stopped cleanly.");
    }

    /**
     * Executes the actual SLA check against database complaints.
     */
    public void performSlaCheck() {
        LOGGER.info("[SLA Monitoring Thread] Running background SLA audit...");

        // 1. Mark overdue complaints in DB
        int markedCount = complaintDAO.markOverdueComplaints();
        if (markedCount > 0) {
            LOGGER.warning("[SLA Monitoring Thread] SLA Breach Warning: " + markedCount + " complaints marked OVERDUE.");
        }

        // 2. Fetch overdue complaints and generate escalation notifications
        List<Complaint> overdueList = complaintDAO.findOverdueComplaints();
        for (Complaint c : overdueList) {
            if (c.getAssignedStaffId() != null) {
                Notification notif = new Notification();
                notif.setUserId(c.getAssignedStaffId());
                notif.setComplaintId(c.getComplaintId());
                notif.setTitle("SLA BREACH ALERT: Ticket #" + c.getComplaintCode());
                notif.setMessage("Complaint '" + c.getTitle() + "' has exceeded its resolution SLA target deadline!");
                notif.setType("CRITICAL");
                notificationDAO.create(notif);
            }
        }

        LOGGER.info("[SLA Monitoring Thread] SLA Audit completed. Checked " + overdueList.size() + " overdue complaints.");
    }

    public void stopWorker() {
        this.running = false;
    }
}

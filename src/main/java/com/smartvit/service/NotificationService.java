package com.smartvit.service;

import com.smartvit.dao.NotificationDAO;
import com.smartvit.exception.SmartVitException;
import com.smartvit.model.Notification;
import com.smartvit.thread.NotificationProcessorTask;

import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * Implementation of INotificationService in Smart VIT.
 * Supports synchronous and asynchronous background thread dispatching.
 */
public class NotificationService implements INotificationService {
    private final NotificationDAO notificationDAO = new NotificationDAO();
    private final ExecutorService asyncExecutor = Executors.newFixedThreadPool(4);

    public void sendNotification(int userId, Integer complaintId, String title, String message) {
        try {
            sendNotification(userId, complaintId, title, message, "INFO");
        } catch (SmartVitException e) {
            // Log fallback
            Notification n = new Notification();
            n.setUserId(userId);
            n.setComplaintId(complaintId);
            n.setTitle(title);
            n.setMessage(message);
            n.setRead(false);
            notificationDAO.create(n);
        }
    }

    @Override
    public boolean sendNotification(int userId, Integer complaintId, String title, String message, String type) throws SmartVitException {
        Notification n = new Notification();
        n.setUserId(userId);
        n.setComplaintId(complaintId);
        n.setTitle(title);
        n.setMessage(message);
        n.setType(type != null ? type : "INFO");
        n.setRead(false);

        // Async thread execution
        asyncExecutor.submit(new NotificationProcessorTask(n, notificationDAO));
        triggerOptionalEmail(userId, title, message);
        return true;
    }

    @Override
    public int sendBatchNotifications(List<Integer> userIds, Integer complaintId, String title, String message, String type) throws SmartVitException {
        if (userIds == null || userIds.isEmpty()) return 0;
        int count = 0;
        for (Integer uid : userIds) {
            if (uid != null) {
                sendNotification(uid, complaintId, title, message, type);
                count++;
            }
        }
        return count;
    }

    @Override
    public List<Notification> getNotificationsForUser(int userId) throws SmartVitException {
        return notificationDAO.findByUserId(userId, false);
    }

    @Override
    public boolean markAsRead(int notificationId, int userId) throws SmartVitException {
        return notificationDAO.markAsRead(notificationId, userId);
    }

    private void triggerOptionalEmail(int userId, String title, String message) {
        String smtpHost = System.getenv("SMTP_HOST");
        if (smtpHost != null && !smtpHost.trim().isEmpty()) {
            // Optional SMTP hook
        }
    }
}

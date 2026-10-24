package com.smartvit.thread;

import com.smartvit.dao.NotificationDAO;
import com.smartvit.model.Notification;

import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Asynchronous task worker for non-blocking notification dispatch.
 * Demonstrates Multithreading (Runnable task execution).
 */
public class NotificationProcessorTask implements Runnable {
    private static final Logger LOGGER = Logger.getLogger(NotificationProcessorTask.class.getName());

    private final Notification notification;
    private final NotificationDAO notificationDAO;

    public NotificationProcessorTask(Notification notification, NotificationDAO notificationDAO) {
        this.notification = notification;
        this.notificationDAO = notificationDAO;
    }

    @Override
    public void run() {
        try {
            LOGGER.info("[Async Notification Thread] Processing notification for User ID " + notification.getUserId());
            notificationDAO.create(notification);
            // Simulate minor network dispatch delay
            Thread.sleep(100);
            LOGGER.info("[Async Notification Thread] Notification successfully delivered to User ID " + notification.getUserId());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "[Async Notification Thread] Error delivering notification", e);
        }
    }
}

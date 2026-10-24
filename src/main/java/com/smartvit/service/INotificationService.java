package com.smartvit.service;

import com.smartvit.exception.SmartVitException;
import com.smartvit.model.Notification;

import java.util.List;

/**
 * Service Interface for Notification dispatches.
 */
public interface INotificationService {

    boolean sendNotification(int userId, Integer complaintId, String title, String message, String type) throws SmartVitException;

    int sendBatchNotifications(List<Integer> userIds, Integer complaintId, String title, String message, String type) throws SmartVitException;

    List<Notification> getNotificationsForUser(int userId) throws SmartVitException;

    boolean markAsRead(int notificationId, int userId) throws SmartVitException;
}

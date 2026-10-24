package com.smartvit.controller;

import com.smartvit.dao.NotificationDAO;
import com.smartvit.model.Notification;
import com.smartvit.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/notifications", "/notifications/read", "/notifications/read-all"})
public class NotificationServlet extends HttpServlet {
    private final NotificationDAO notificationDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("currentUser");

        List<Notification> list = notificationDAO.findByUserId(user.getUserId(), 50);
        req.setAttribute("notifications", list);

        req.getRequestDispatcher("/student/notifications.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("currentUser");

        String path = req.getServletPath();
        if ("/notifications/read-all".equals(path)) {
            notificationDAO.markAllAsRead(user.getUserId());
            resp.sendRedirect(req.getContextPath() + "/notifications");
            return;
        } else if ("/notifications/read".equals(path)) {
            String idStr = req.getParameter("id");
            if (idStr != null) {
                try {
                    int nId = Integer.parseInt(idStr);
                    notificationDAO.markAsRead(nId, user.getUserId());
                } catch (NumberFormatException ignored) {}
            }
            resp.setContentType("application/json");
            resp.getWriter().write("{\"success\":true}");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/notifications");
    }
}

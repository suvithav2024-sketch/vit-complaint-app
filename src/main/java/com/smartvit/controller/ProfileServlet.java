package com.smartvit.controller;

import com.smartvit.dao.UserDAO;
import com.smartvit.model.User;
import com.smartvit.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(urlPatterns = {"/student/profile", "/staff/profile"})
public class ProfileServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        User freshUser = userDAO.findById(currentUser.getUserId());
        req.setAttribute("user", freshUser != null ? freshUser : currentUser);
        req.getRequestDispatcher("/student/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        String action = req.getParameter("action");
        if ("updatePassword".equals(action)) {
            String oldPass = req.getParameter("oldPassword");
            String newPass = req.getParameter("newPassword");
            String confirmPass = req.getParameter("confirmPassword");

            User u = userDAO.findById(currentUser.getUserId());
            if (u != null && PasswordUtil.checkPassword(oldPass, u.getPasswordHash())) {
                if (newPass != null && newPass.length() >= 6 && newPass.equals(confirmPass)) {
                    userDAO.updatePassword(u.getUserId(), PasswordUtil.hashPassword(newPass));
                    req.setAttribute("successMessage", "Password updated successfully.");
                } else {
                    req.setAttribute("errorMessage", "New passwords must match and be at least 6 characters.");
                }
            } else {
                req.setAttribute("errorMessage", "Current password does not match.");
            }
        } else {
            String fullName = req.getParameter("fullName");
            String phone = req.getParameter("phone");
            String schoolDept = req.getParameter("schoolDept");
            String hostelBlock = req.getParameter("hostelBlock");
            String roomNo = req.getParameter("roomNo");

            User u = userDAO.findById(currentUser.getUserId());
            if (u != null) {
                u.setFullName(fullName);
                u.setPhone(phone);
                u.setSchoolDept(schoolDept);
                u.setHostelBlock(hostelBlock);
                u.setRoomNo(roomNo);
                userDAO.update(u);
                session.setAttribute("currentUser", u);
                session.setAttribute("name", u.getFullName());
                req.setAttribute("successMessage", "Profile information updated.");
            }
        }

        doGet(req, resp);
    }
}

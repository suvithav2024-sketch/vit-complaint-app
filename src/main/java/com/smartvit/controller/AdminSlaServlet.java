package com.smartvit.controller;

import com.smartvit.dao.SlaDAO;
import com.smartvit.model.SlaRule;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/sla")
public class AdminSlaServlet extends HttpServlet {
    private final SlaDAO slaDAO = new SlaDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<SlaRule> rules = slaDAO.findAll();
        req.setAttribute("rules", rules);
        req.getRequestDispatcher("/admin/sla.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int slaId = Integer.parseInt(req.getParameter("slaId"));
        int maxHours = Integer.parseInt(req.getParameter("maxResolutionHours"));
        int escHours = Integer.parseInt(req.getParameter("escalationHours"));
        String description = req.getParameter("description");

        SlaRule rule = new SlaRule();
        rule.setSlaId(slaId);
        rule.setMaxResolutionHours(maxHours);
        rule.setEscalationHours(escHours);
        rule.setDescription(description);

        slaDAO.update(rule);
        resp.sendRedirect(req.getContextPath() + "/admin/sla?updated=true");
    }
}

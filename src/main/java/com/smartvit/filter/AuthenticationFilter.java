package com.smartvit.filter;

import com.smartvit.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebFilter(urlPatterns = {
    "/student/*",
    "/staff/*",
    "/department/*",
    "/admin/*",
    "/complaint/*",
    "/notifications/*"
})
public class AuthenticationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser != null && currentUser.isActive()) {
            chain.doFilter(request, response);
        } else {
            // Preserve target URL and query parameters for deep linking (e.g. from QR scan)
            String targetUri = req.getRequestURI();
            String query = req.getQueryString();
            String fullTarget = targetUri + (query != null && !query.isEmpty() ? "?" + query : "");

            // Remove context path if present
            String contextPath = req.getContextPath();
            if (fullTarget.startsWith(contextPath)) {
                fullTarget = fullTarget.substring(contextPath.length());
            }

            String encoded = URLEncoder.encode(fullTarget, StandardCharsets.UTF_8);
            res.sendRedirect(contextPath + "/login?returnUrl=" + encoded);
        }
    }
}

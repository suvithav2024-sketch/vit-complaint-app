<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="404 - Page Not Found" />
<%@ include file="/WEB-INF/includes/header.jsp" %>
<%@ include file="/WEB-INF/includes/navbar.jsp" %>

<main class="main-content d-flex align-items-center">
    <div class="container text-center py-5">
        <div class="display-1 fw-bold text-navy mb-2">404</div>
        <h3 class="fw-bold mb-3">Resource or Page Not Found</h3>
        <p class="text-muted col-md-6 mx-auto mb-4">
            The requested page or complaint record could not be located on the SMART VIT server. Please check the URL or return to the main portal.
        </p>
        <a href="${pageContext.request.contextPath}/" class="btn btn-vit-primary px-4 py-2">
            <i class="bi bi-house-door me-2"></i> Return to Home
        </a>
    </div>
</main>

<%@ include file="/WEB-INF/includes/footer.jsp" %>

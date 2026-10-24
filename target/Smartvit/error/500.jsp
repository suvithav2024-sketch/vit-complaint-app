<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="500 - Server Error" />
<%@ include file="/WEB-INF/includes/header.jsp" %>
<%@ include file="/WEB-INF/includes/navbar.jsp" %>

<main class="main-content d-flex align-items-center">
    <div class="container text-center py-5">
        <div class="display-1 fw-bold text-danger mb-2"><i class="bi bi-exclamation-octagon"></i> 500</div>
        <h3 class="fw-bold mb-3">Internal Application Error</h3>
        <p class="text-muted col-md-6 mx-auto mb-4">
            An unexpected error occurred while processing your request. Please try again later or contact the campus IT Helpdesk.
        </p>
        <a href="${pageContext.request.contextPath}/" class="btn btn-vit-primary px-4 py-2">
            <i class="bi bi-house-door me-2"></i> Return to Home
        </a>
    </div>
</main>

<%@ include file="/WEB-INF/includes/footer.jsp" %>

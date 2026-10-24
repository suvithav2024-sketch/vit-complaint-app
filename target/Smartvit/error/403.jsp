<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="403 - Access Denied" />
<%@ include file="/WEB-INF/includes/header.jsp" %>
<%@ include file="/WEB-INF/includes/navbar.jsp" %>

<main class="main-content d-flex align-items-center">
    <div class="container text-center py-5">
        <div class="display-1 fw-bold text-danger mb-2"><i class="bi bi-shield-x"></i> 403</div>
        <h3 class="fw-bold mb-3">Access Denied / Forbidden</h3>
        <p class="text-muted col-md-6 mx-auto mb-4">
            ${not empty errorMessage ? errorMessage : 'You do not have the required permissions to view this resource. Please ensure you are logged into an authorized account.'}
        </p>
        <div class="d-flex justify-content-center gap-3">
            <a href="${pageContext.request.contextPath}/" class="btn btn-vit-primary px-4 py-2">
                <i class="bi bi-house-door me-2"></i> Return to Home
            </a>
            <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-secondary px-4 py-2">
                <i class="bi bi-box-arrow-in-right me-2"></i> Switch Account
            </a>
        </div>
    </div>
</main>

<%@ include file="/WEB-INF/includes/footer.jsp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:if test="${not empty errorMessage || not empty param.error}">
    <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
        <i class="bi bi-exclamation-triangle-fill me-2"></i>
        <span>${not empty errorMessage ? errorMessage : param.error}</span>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
</c:if>

<c:if test="${not empty successMessage || not empty param.success || param.created == 'true' || param.updated == 'true' || param.confirmed == 'true' || param.reopened == 'true' || param.assigned == 'true'}">
    <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
        <i class="bi bi-check-circle-fill me-2"></i>
        <span>
            <c:choose>
                <c:when test="${not empty successMessage}">${successMessage}</c:when>
                <c:when test="${param.created == 'true'}">Complaint created and assigned successfully!</c:when>
                <c:when test="${param.updated == 'true'}">Complaint updated successfully.</c:when>
                <c:when test="${param.confirmed == 'true'}">Resolution confirmed. Complaint has been closed.</c:when>
                <c:when test="${param.reopened == 'true'}">Complaint has been reopened and returned to In Progress.</c:when>
                <c:when test="${param.assigned == 'true'}">Technician assigned successfully.</c:when>
                <c:otherwise>Operation completed successfully.</c:otherwise>
            </c:choose>
        </span>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
</c:if>

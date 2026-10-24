<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Security Audit Logs - SMART VIT" />
<%@ include file="/WEB-INF/includes/header.jsp" %>
<%@ include file="/WEB-INF/includes/navbar.jsp" %>

<main class="main-content">
    <div class="container py-4">
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 pb-2 border-bottom">
            <div>
                <h2 class="fw-bold mb-0"><i class="bi bi-shield-lock me-2 text-primary"></i>System Audit Trail Logs</h2>
                <p class="text-muted small mb-0">Security event logging, status modifications, administrative actions, and IP tracking.</p>
            </div>
            <div class="mt-3 mt-md-0">
                <a href="${pageContext.request.contextPath}/admin/audit-logs" class="btn btn-outline-primary shadow-sm"><i class="bi bi-arrow-clockwise me-1"></i> Refresh Logs</a>
            </div>
        </div>

        <%@ include file="/WEB-INF/includes/alerts.jsp" %>

        <!-- Audit Table -->
        <div class="vit-card">
            <div class="vit-card-header d-flex justify-content-between align-items-center">
                <span><i class="bi bi-journal-text me-2"></i>Recent Security Audit Events (${logs.size()})</span>
            </div>
            <div class="vit-card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Log ID</th>
                                <th>Timestamp</th>
                                <th>User</th>
                                <th>Action Type</th>
                                <th>Target Entity</th>
                                <th>IP Address</th>
                                <th>Details</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty logs}">
                                    <tr>
                                        <td colspan="7" class="text-center py-5 text-muted">
                                            <i class="bi bi-journal-x fs-1 d-block mb-2"></i>
                                            No audit logs recorded.
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="l" items="${logs}">
                                        <tr>
                                            <td><span class="badge bg-secondary">#${l.logId}</span></td>
                                            <td><small class="text-nowrap">${l.createdAt}</small></td>
                                            <td>
                                                <div class="fw-semibold small">${l.userName != null ? l.userName : 'SYSTEM'}</div>
                                            </td>
                                            <td><span class="badge bg-dark-subtle text-dark fw-bold text-uppercase">${l.action}</span></td>
                                            <td><small class="text-muted">${l.entityType} <c:if test="${not empty l.entityId}">#${l.entityId}</c:if></small></td>
                                            <td><code class="small">${l.ipAddress}</code></td>
                                            <td><small class="text-dark">${l.details}</small></td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</main>

<%@ include file="/WEB-INF/includes/footer.jsp" %>

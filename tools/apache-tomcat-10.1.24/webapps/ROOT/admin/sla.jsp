<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="SLA Rules Management - SMART VIT" />
<%@ include file="/WEB-INF/includes/header.jsp" %>
<%@ include file="/WEB-INF/includes/navbar.jsp" %>

<main class="main-content">
    <div class="container py-4">
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 pb-2 border-bottom">
            <div>
                <h2 class="fw-bold mb-0"><i class="bi bi-hourglass-split me-2 text-primary"></i>Service Level Agreement (SLA) Rules</h2>
                <p class="text-muted small mb-0">Configure max resolution hours and escalation thresholds for Low, Medium, High, and Urgent priority complaints.</p>
            </div>
        </div>

        <%@ include file="/WEB-INF/includes/alerts.jsp" %>

        <!-- SLA Rules Table -->
        <div class="vit-card">
            <div class="vit-card-header d-flex justify-content-between align-items-center">
                <span><i class="bi bi-clock-history me-2"></i>Active Priority SLA Thresholds</span>
            </div>
            <div class="vit-card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Priority</th>
                                <th>Max Resolution Window</th>
                                <th>Escalation Alert Threshold</th>
                                <th>Description</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="rule" items="${rules}">
                                <tr>
                                    <td>
                                        <c:choose>
                                            <c:when test="${rule.priority == 'URGENT'}"><span class="badge bg-danger fs-6">URGENT</span></c:when>
                                            <c:when test="${rule.priority == 'HIGH'}"><span class="badge bg-warning text-dark fs-6">HIGH</span></c:when>
                                            <c:when test="${rule.priority == 'MEDIUM'}"><span class="badge bg-info text-dark fs-6">MEDIUM</span></c:when>
                                            <c:otherwise><span class="badge bg-secondary fs-6">LOW</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><span class="fw-bold text-dark fs-5">${rule.maxResolutionHours}</span> <span class="text-muted">hours</span></td>
                                    <td><span class="fw-bold text-danger fs-5">${rule.escalationHours}</span> <span class="text-muted">hours</span></td>
                                    <td><small class="text-muted">${rule.description}</small></td>
                                    <td>
                                        <button type="button" class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#editSlaModal${rule.slaId}">
                                            <i class="bi bi-pencil-square me-1"></i> Edit Rule
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Edit SLA Modals -->
<c:forEach var="rule" items="${rules}">
    <div class="modal fade" id="editSlaModal${rule.slaId}" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <form method="post" action="${pageContext.request.contextPath}/admin/sla">
                    <input type="hidden" name="slaId" value="${rule.slaId}">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title"><i class="bi bi-pencil-square me-2"></i>Edit ${rule.priority} Priority SLA</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Max Resolution Window (Hours) *</label>
                            <input type="number" name="maxResolutionHours" class="form-control" required min="1" value="${rule.maxResolutionHours}">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Escalation Alert Threshold (Hours) *</label>
                            <input type="number" name="escalationHours" class="form-control" required min="1" value="${rule.escalationHours}">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Description</label>
                            <input type="text" name="description" class="form-control" value="${rule.description}">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-vit-primary">Update SLA</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</c:forEach>

<%@ include file="/WEB-INF/includes/footer.jsp" %>

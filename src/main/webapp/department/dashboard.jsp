<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Department Dashboard - SMART VIT" />
<%@ include file="/WEB-INF/includes/header.jsp" %>
<%@ include file="/WEB-INF/includes/navbar.jsp" %>

<main class="main-content">
    <div class="container py-4">
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 pb-2 border-bottom">
            <div>
                <span class="badge bg-info-subtle text-info fw-bold text-uppercase small">Department Staff</span>
                <h2 class="fw-bold mb-0">${department.name}</h2>
                <p class="text-muted small mb-0"><i class="bi bi-building me-1"></i> Department Dashboard | Logged in as: <strong>${sessionScope.name}</strong></p>
            </div>
            <a href="${pageContext.request.contextPath}/department/complaints" class="btn btn-vit-primary mt-2 mt-md-0">
                <i class="bi bi-inbox me-1"></i> View All Complaints
            </a>
        </div>

        <%@ include file="/WEB-INF/includes/alerts.jsp" %>

        <!-- Stat Cards -->
        <div class="row g-3 mb-4">
            <div class="col-6 col-lg-2">
                <div class="vit-card stat-card stat-primary">
                    <div class="stat-number">${totalAssigned}</div>
                    <div class="stat-label">Total Assigned</div>
                </div>
            </div>
            <div class="col-6 col-lg-2">
                <div class="vit-card stat-card stat-warning">
                    <div class="stat-number">${pendingCount}</div>
                    <div class="stat-label">Pending</div>
                </div>
            </div>
            <div class="col-6 col-lg-2">
                <div class="vit-card stat-card" style="border-top-color:#0dcaf0;">
                    <div class="stat-number">${inProgressCount}</div>
                    <div class="stat-label">In Progress</div>
                </div>
            </div>
            <div class="col-6 col-lg-2">
                <div class="vit-card stat-card stat-success">
                    <div class="stat-number">${resolvedCount}</div>
                    <div class="stat-label">Resolved</div>
                </div>
            </div>
            <div class="col-6 col-lg-2">
                <div class="vit-card stat-card stat-danger">
                    <div class="stat-number">${overdueCount}</div>
                    <div class="stat-label">Overdue</div>
                </div>
            </div>
            <div class="col-6 col-lg-2">
                <div class="vit-card stat-card" style="border-top-color:#6c757d;">
                    <div class="stat-number">${closedCount}</div>
                    <div class="stat-label">Closed</div>
                </div>
            </div>
        </div>

        <div class="row g-4">
            <!-- Recent / Urgent Queue -->
            <div class="col-lg-8">
                <div class="vit-card mb-4">
                    <div class="vit-card-header d-flex justify-content-between align-items-center">
                        <span><i class="bi bi-exclamation-triangle-fill text-warning me-2"></i>Urgent & Overdue</span>
                        <a href="${pageContext.request.contextPath}/department/complaints?priority=CRITICAL" class="btn btn-sm btn-outline-danger">View All Critical</a>
                    </div>
                    <div class="vit-card-body p-0">
                        <c:choose>
                            <c:when test="${empty urgentComplaints}">
                                <div class="text-center py-4 text-muted">
                                    <i class="bi bi-check-circle fs-2 text-success d-block mb-2"></i> No urgent complaints right now!
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle mb-0">
                                        <thead class="table-light">
                                            <tr><th>ID</th><th>Category</th><th>Location</th><th>Priority</th><th>Status</th><th>SLA</th><th></th></tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="c" items="${urgentComplaints}">
                                            <tr class="${c.overdue ? 'table-danger' : ''}">
                                                <td><span class="fw-semibold text-primary">${c.complaintId}</span></td>
                                                <td>${c.categoryName}</td>
                                                <td><small>${c.locationName}</small></td>
                                                <td><span class="badge ${c.priorityBadgeClass}">${c.priority}</span></td>
                                                <td><span class="badge ${c.statusBadgeClass}">${c.status}</span></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${c.overdue}"><span class="badge bg-danger">OVERDUE</span></c:when>
                                                        <c:otherwise><small class="text-muted">On track</small></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td><a href="${pageContext.request.contextPath}/department/complaint-details?id=${c.complaintId}" class="btn btn-sm btn-outline-primary">Work</a></td>
                                            </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Recent Complaints Table -->
                <div class="vit-card">
                    <div class="vit-card-header d-flex justify-content-between align-items-center">
                        <span><i class="bi bi-clock-history me-2"></i>Recent Complaints</span>
                        <a href="${pageContext.request.contextPath}/department/complaints" class="btn btn-sm btn-outline-primary">View All</a>
                    </div>
                    <div class="vit-card-body p-0">
                        <c:choose>
                            <c:when test="${empty recentComplaints}">
                                <div class="text-center py-4 text-muted"><i class="bi bi-inbox fs-2 d-block mb-2"></i> No complaints assigned yet.</div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle mb-0">
                                        <thead class="table-light">
                                            <tr><th>ID</th><th>Category</th><th>Assigned To</th><th>Status</th><th>Date</th><th></th></tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="c" items="${recentComplaints}">
                                            <tr>
                                                <td><span class="fw-semibold text-primary">${c.complaintId}</span></td>
                                                <td>${c.categoryName}</td>
                                                <td><small>${empty c.assignedToName ? 'Unassigned' : c.assignedToName}</small></td>
                                                <td><span class="badge ${c.statusBadgeClass}">${c.status}</span></td>
                                                <td><small>${c.formattedCreatedAt}</small></td>
                                                <td><a href="${pageContext.request.contextPath}/department/complaint-details?id=${c.complaintId}" class="btn btn-sm btn-outline-secondary">View</a></td>
                                            </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <!-- Side Panel -->
            <div class="col-lg-4">
                <div class="vit-card mb-3">
                    <div class="vit-card-header"><i class="bi bi-lightning-charge me-2"></i>Quick Links</div>
                    <div class="list-group list-group-flush">
                        <a href="${pageContext.request.contextPath}/department/complaints?status=PENDING" class="list-group-item list-group-item-action d-flex align-items-center gap-2">
                            <i class="bi bi-hourglass-split text-warning"></i> Pending Queue
                            <c:if test="${pendingCount > 0}"><span class="badge bg-warning ms-auto">${pendingCount}</span></c:if>
                        </a>
                        <a href="${pageContext.request.contextPath}/department/complaints?status=IN_PROGRESS" class="list-group-item list-group-item-action d-flex align-items-center gap-2">
                            <i class="bi bi-arrow-repeat text-info"></i> In Progress
                        </a>
                        <a href="${pageContext.request.contextPath}/department/complaints?status=RESOLVED" class="list-group-item list-group-item-action d-flex align-items-center gap-2">
                            <i class="bi bi-check-circle text-success"></i> Awaiting Confirmation
                        </a>
                        <a href="${pageContext.request.contextPath}/notifications" class="list-group-item list-group-item-action d-flex align-items-center gap-2">
                            <i class="bi bi-bell-fill text-danger"></i> Notifications
                            <c:if test="${unreadCount > 0}"><span class="badge bg-danger ms-auto">${unreadCount}</span></c:if>
                        </a>
                    </div>
                </div>

                <!-- Department Technicians -->
                <div class="vit-card">
                    <div class="vit-card-header"><i class="bi bi-people-fill me-2"></i>Technicians / Staff</div>
                    <div class="vit-card-body p-0">
                        <c:choose>
                            <c:when test="${empty technicians}">
                                <p class="text-muted small p-3 mb-0">No technicians registered for this department.</p>
                            </c:when>
                            <c:otherwise>
                                <ul class="list-group list-group-flush">
                                    <c:forEach var="tech" items="${technicians}">
                                    <li class="list-group-item d-flex align-items-center gap-2 py-2">
                                        <i class="bi bi-person-fill text-muted"></i>
                                        <div>
                                            <div class="fw-semibold small">${tech.name}</div>
                                            <div class="text-muted" style="font-size:0.75rem;">${tech.designation}</div>
                                        </div>
                                        <c:if test="${tech.active}">
                                            <span class="badge bg-success-subtle text-success ms-auto">Active</span>
                                        </c:if>
                                    </li>
                                    </c:forEach>
                                </ul>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<%@ include file="/WEB-INF/includes/footer.jsp" %>

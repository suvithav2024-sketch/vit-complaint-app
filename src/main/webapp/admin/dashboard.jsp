<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Admin Overview - SMART VIT" />
<%@ include file="/WEB-INF/includes/header.jsp" %>
<%@ include file="/WEB-INF/includes/navbar.jsp" %>

<main class="main-content">
    <div class="container py-4">
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 pb-2 border-bottom">
            <div>
                <span class="badge bg-danger-subtle text-danger fw-bold text-uppercase small">System Administrator</span>
                <h2 class="fw-bold mb-0">Admin Control Center</h2>
                <p class="text-muted small mb-0"><i class="bi bi-shield-check me-1"></i> Logged in as <strong>${sessionScope.name}</strong> (${sessionScope.email})</p>
            </div>
            <div class="mt-3 mt-md-0 d-flex gap-2">
                <a href="${pageContext.request.contextPath}/admin/reports" class="btn btn-outline-primary shadow-sm">
                    <i class="bi bi-bar-chart-line me-1"></i> Analytics & Reports
                </a>
                <a href="${pageContext.request.contextPath}/admin/qr-codes" class="btn btn-vit-primary shadow-sm">
                    <i class="bi bi-qr-code-scan me-1"></i> Manage QR Codes
                </a>
            </div>
        </div>

        <%@ include file="/WEB-INF/includes/alerts.jsp" %>

        <!-- Overdue Alert Box if any -->
        <c:if test="${not empty overdueComplaints}">
            <div class="alert alert-danger shadow-sm border-danger d-flex align-items-center mb-4" role="alert">
                <i class="bi bi-exclamation-triangle-fill fs-3 me-3 text-danger"></i>
                <div class="flex-grow-1">
                    <h6 class="alert-heading fw-bold mb-1">Attention: Overdue Complaints Detected (${overdueComplaints.size()})</h6>
                    <p class="small mb-0">Certain high-priority complaints have breached their SLA resolution windows and require immediate intervention.</p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/complaints?status=OVERDUE" class="btn btn-sm btn-danger px-3 ms-3 text-nowrap">View Overdue</a>
            </div>
        </c:if>

        <!-- KPI Metrics Grid -->
        <div class="row g-3 mb-4">
            <div class="col-6 col-md-4 col-lg-2">
                <div class="vit-card stat-card stat-primary text-center">
                    <div class="stat-number">${stats.totalComplaints}</div>
                    <div class="stat-label">Total Complaints</div>
                </div>
            </div>
            <div class="col-6 col-md-4 col-lg-2">
                <div class="vit-card stat-card stat-warning text-center">
                    <div class="stat-number">${stats.pendingComplaints}</div>
                    <div class="stat-label">Pending</div>
                </div>
            </div>
            <div class="col-6 col-md-4 col-lg-2">
                <div class="vit-card stat-card stat-primary text-center">
                    <div class="stat-number">${stats.inProgressComplaints}</div>
                    <div class="stat-label">In Progress</div>
                </div>
            </div>
            <div class="col-6 col-md-4 col-lg-2">
                <div class="vit-card stat-card stat-success text-center">
                    <div class="stat-number">${stats.resolvedComplaints}</div>
                    <div class="stat-label">Resolved</div>
                </div>
            </div>
            <div class="col-6 col-md-4 col-lg-2">
                <div class="vit-card stat-card stat-danger text-center">
                    <div class="stat-number">${stats.overdueComplaints}</div>
                    <div class="stat-label">SLA Overdue</div>
                </div>
            </div>
            <div class="col-6 col-md-4 col-lg-2">
                <div class="vit-card stat-card text-center" style="border-top-color:#8e44ad;">
                    <div class="stat-number">${stats.totalUsers}</div>
                    <div class="stat-label">Total Users</div>
                </div>
            </div>
        </div>

        <div class="row g-4">
            <!-- Recent Activity / Complaints -->
            <div class="col-lg-8">
                <div class="vit-card">
                    <div class="vit-card-header d-flex justify-content-between align-items-center">
                        <span><i class="bi bi-clock-history me-2"></i>Recent Complaints Across Campus</span>
                        <a href="${pageContext.request.contextPath}/admin/complaints" class="btn btn-sm btn-outline-primary">View All Complaints</a>
                    </div>
                    <div class="vit-card-body p-0">
                        <c:choose>
                            <c:when test="${empty recentComplaints}">
                                <div class="text-center py-5 text-muted">
                                    <i class="bi bi-inbox fs-1 d-block mb-2"></i>
                                    No complaints recorded in the system.
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle mb-0">
                                        <thead class="table-light">
                                            <tr>
                                                <th>Code</th>
                                                <th>Complainant</th>
                                                <th>Category / Location</th>
                                                <th>Department</th>
                                                <th>Status</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="c" items="${recentComplaints}">
                                                <tr>
                                                    <td><span class="text-monospace fw-bold text-primary">${c.complaintCode}</span></td>
                                                    <td>
                                                        <div class="fw-semibold small">${c.complainantName}</div>
                                                        <small class="text-muted">${c.complainantRegNo}</small>
                                                    </td>
                                                    <td>
                                                        <div class="small fw-semibold">${c.categoryName}</div>
                                                        <small class="text-muted"><i class="bi bi-geo-alt me-1"></i>${c.locationName}</small>
                                                    </td>
                                                    <td>
                                                        <span class="badge bg-secondary-subtle text-dark small">${c.departmentName != null ? c.departmentName : 'Unassigned'}</span>
                                                    </td>
                                                    <td>
                                                        <span class="badge ${c.statusBadgeClass}">${c.status}</span>
                                                        <c:if test="${c.overdue}">
                                                            <span class="badge bg-danger ms-1">OVERDUE</span>
                                                        </c:if>
                                                    </td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/complaint/details?id=${c.complaintId}" class="btn btn-sm btn-outline-secondary">View</a>
                                                    </td>
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

            <!-- Quick Management Shortcuts -->
            <div class="col-lg-4">
                <div class="vit-card mb-4">
                    <div class="vit-card-header"><i class="bi bi-gear-wide-connected me-2"></i>Administrative Controls</div>
                    <div class="list-group list-group-flush">
                        <a href="${pageContext.request.contextPath}/admin/complaints" class="list-group-item list-group-item-action d-flex align-items-center justify-content-between">
                            <span><i class="bi bi-list-ul me-2 text-primary"></i>All Complaints</span>
                            <span class="badge bg-primary rounded-pill">${stats.totalComplaints}</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/departments" class="list-group-item list-group-item-action d-flex align-items-center justify-content-between">
                            <span><i class="bi bi-building me-2 text-info"></i>Departments & Staff</span>
                            <span class="badge bg-info text-dark rounded-pill">${stats.totalDepartments}</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/categories" class="list-group-item list-group-item-action d-flex align-items-center justify-content-between">
                            <span><i class="bi bi-tags me-2 text-warning"></i>Categories & Mapping</span>
                            <i class="bi bi-chevron-right text-muted small"></i>
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/locations" class="list-group-item list-group-item-action d-flex align-items-center justify-content-between">
                            <span><i class="bi bi-geo-alt me-2 text-success"></i>Buildings & Locations</span>
                            <span class="badge bg-success rounded-pill">${stats.totalLocations}</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/qr-codes" class="list-group-item list-group-item-action d-flex align-items-center justify-content-between">
                            <span><i class="bi bi-qr-code-scan me-2 text-dark"></i>Smart QR Codes</span>
                            <span class="badge bg-dark rounded-pill">${stats.totalQRCodes}</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/users" class="list-group-item list-group-item-action d-flex align-items-center justify-content-between">
                            <span><i class="bi bi-people me-2 text-secondary"></i>User Management</span>
                            <span class="badge bg-secondary rounded-pill">${stats.totalUsers}</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/sla" class="list-group-item list-group-item-action d-flex align-items-center justify-content-between">
                            <span><i class="bi bi-hourglass-split me-2 text-danger"></i>SLA Rules</span>
                            <i class="bi bi-chevron-right text-muted small"></i>
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/audit-logs" class="list-group-item list-group-item-action d-flex align-items-center justify-content-between">
                            <span><i class="bi bi-shield-lock me-2 text-dark"></i>System Audit Trail</span>
                            <i class="bi bi-chevron-right text-muted small"></i>
                        </a>
                    </div>
                </div>

                <div class="vit-card bg-light border">
                    <div class="vit-card-body">
                        <h6 class="fw-bold text-dark"><i class="bi bi-star-fill text-warning me-1"></i> Average Satisfaction</h6>
                        <h3 class="fw-bold text-primary mb-1">${stats.satisfactionRating} / 5.0</h3>
                        <p class="small text-muted mb-0">Based on resolved student & staff complaint feedback ratings.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<%@ include file="/WEB-INF/includes/footer.jsp" %>

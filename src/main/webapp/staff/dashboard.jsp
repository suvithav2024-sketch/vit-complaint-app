<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Staff Dashboard - SMART VIT" />
<%@ include file="/WEB-INF/includes/header.jsp" %>
<%@ include file="/WEB-INF/includes/navbar.jsp" %>

<main class="main-content">
    <div class="container py-4">
        <!-- Top Welcome Banner -->
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 pb-2 border-bottom">
            <div>
                <span class="badge bg-success-subtle text-success fw-bold text-uppercase small">Staff Portal</span>
                <h2 class="fw-bold mb-0">Welcome, ${sessionScope.name}</h2>
                <p class="text-muted small mb-0"><i class="bi bi-person-badge me-1"></i> Emp No: <strong>${sessionScope.regEmpNo}</strong> | ${sessionScope.email}</p>
            </div>
            <div class="mt-3 mt-md-0 d-flex gap-2">
                <a href="${pageContext.request.contextPath}/staff/raise-complaint" class="btn btn-vit-primary shadow-sm">
                    <i class="bi bi-plus-circle me-1"></i> Raise Complaint
                </a>
                <button type="button" class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#qrScanModal">
                    <i class="bi bi-qr-code-scan me-1"></i> Scan Room QR
                </button>
            </div>
        </div>

        <%@ include file="/WEB-INF/includes/alerts.jsp" %>

        <!-- Statistics Counter Cards -->
        <div class="row g-3 mb-4">
            <div class="col-6 col-lg-2">
                <div class="vit-card stat-card stat-primary">
                    <div class="stat-number">${totalComplaints}</div>
                    <div class="stat-label">Total Filed</div>
                </div>
            </div>
            <div class="col-6 col-lg-2">
                <div class="vit-card stat-card stat-warning">
                    <div class="stat-number">${pendingComplaints}</div>
                    <div class="stat-label">Pending</div>
                </div>
            </div>
            <div class="col-6 col-lg-2">
                <div class="vit-card stat-card stat-primary">
                    <div class="stat-number">${inProgressComplaints}</div>
                    <div class="stat-label">In Progress</div>
                </div>
            </div>
            <div class="col-6 col-lg-2">
                <div class="vit-card stat-card stat-success">
                    <div class="stat-number">${resolvedComplaints}</div>
                    <div class="stat-label">Resolved</div>
                </div>
            </div>
            <div class="col-6 col-lg-2">
                <div class="vit-card stat-card stat-danger">
                    <div class="stat-number">${overdueComplaints}</div>
                    <div class="stat-label">Overdue</div>
                </div>
            </div>
            <div class="col-6 col-lg-2">
                <div class="vit-card stat-card" style="border-top-color:#6c757d;">
                    <div class="stat-number">${closedComplaints}</div>
                    <div class="stat-label">Closed</div>
                </div>
            </div>
        </div>

        <div class="row g-4">
            <!-- Recent Complaints -->
            <div class="col-lg-8">
                <div class="vit-card">
                    <div class="vit-card-header d-flex justify-content-between align-items-center">
                        <span><i class="bi bi-clock-history me-2"></i>Recent Complaints</span>
                        <a href="${pageContext.request.contextPath}/staff/my-complaints" class="btn btn-sm btn-outline-primary">View All</a>
                    </div>
                    <div class="vit-card-body p-0">
                        <c:choose>
                            <c:when test="${empty recentComplaints}">
                                <div class="text-center py-5 text-muted">
                                    <i class="bi bi-inbox fs-1 d-block mb-2"></i>
                                    No complaints filed yet.
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle mb-0">
                                        <thead class="table-light">
                                            <tr>
                                                <th>Complaint ID</th>
                                                <th>Category</th>
                                                <th>Location</th>
                                                <th>Status</th>
                                                <th>Date</th>
                                                <th></th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="c" items="${recentComplaints}">
                                            <tr>
                                                <td><span class="text-monospace fw-semibold">${c.complaintId}</span></td>
                                                <td>${c.categoryName}<c:if test="${not empty c.subCategoryName}"><br><small class="text-muted">${c.subCategoryName}</small></c:if></td>
                                                <td>${c.locationName}</td>
                                                <td><span class="badge ${c.statusBadgeClass}">${c.status}</span></td>
                                                <td><small>${c.formattedCreatedAt}</small></td>
                                                <td><a href="${pageContext.request.contextPath}/complaint-details?id=${c.id}" class="btn btn-sm btn-outline-secondary">View</a></td>
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

            <!-- Quick Links & SLA Info -->
            <div class="col-lg-4">
                <div class="vit-card mb-3">
                    <div class="vit-card-header"><i class="bi bi-lightning-charge me-2"></i>Quick Actions</div>
                    <div class="list-group list-group-flush">
                        <a href="${pageContext.request.contextPath}/staff/raise-complaint" class="list-group-item list-group-item-action d-flex align-items-center gap-2">
                            <i class="bi bi-plus-circle-fill text-primary"></i> Raise New Complaint
                        </a>
                        <a href="${pageContext.request.contextPath}/staff/my-complaints?status=PENDING" class="list-group-item list-group-item-action d-flex align-items-center gap-2">
                            <i class="bi bi-hourglass-split text-warning"></i> View Pending
                        </a>
                        <a href="${pageContext.request.contextPath}/staff/my-complaints?status=IN_PROGRESS" class="list-group-item list-group-item-action d-flex align-items-center gap-2">
                            <i class="bi bi-arrow-repeat text-info"></i> In Progress
                        </a>
                        <a href="${pageContext.request.contextPath}/notifications" class="list-group-item list-group-item-action d-flex align-items-center gap-2">
                            <i class="bi bi-bell-fill text-danger"></i> Notifications
                            <c:if test="${unreadCount > 0}"><span class="badge bg-danger ms-auto">${unreadCount}</span></c:if>
                        </a>
                        <a href="${pageContext.request.contextPath}/staff/profile" class="list-group-item list-group-item-action d-flex align-items-center gap-2">
                            <i class="bi bi-person-gear text-secondary"></i> My Profile
                        </a>
                    </div>
                </div>

                <div class="vit-card bg-primary-subtle border-0">
                    <div class="vit-card-body">
                        <h6 class="fw-bold text-primary"><i class="bi bi-info-circle me-1"></i> SLA Reminder</h6>
                        <p class="small text-muted mb-0">Complaints are resolved based on priority SLAs. Overdue complaints escalate automatically. Ensure you confirm or reopen resolved complaints within 48 hours.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- QR Scan Modal -->
<div class="modal fade" id="qrScanModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title"><i class="bi bi-qr-code-scan me-2"></i>Scan or Enter QR Location</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body text-center">
                <p class="text-muted">Find the QR code sticker on the wall of your office/room and scan it to pre-fill the complaint location.</p>
                <div class="alert alert-info small">
                    <i class="bi bi-camera me-1"></i> Use your phone camera to scan the QR code on the location.
                    The link will auto-open this portal with the location pre-filled.
                </div>
                <hr>
                <p class="fw-semibold">Or enter a Location ID manually:</p>
                <div class="input-group mb-3 mx-auto" style="max-width:280px;">
                    <input type="number" id="manualLocId" class="form-control" placeholder="Location ID">
                    <button class="btn btn-primary" onclick="goToLocation()">Go</button>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
function goToLocation(){
    const id = document.getElementById('manualLocId').value;
    if(id) window.location.href='${pageContext.request.contextPath}/staff/raise-complaint?locationId='+id;
}
</script>

<%@ include file="/WEB-INF/includes/footer.jsp" %>

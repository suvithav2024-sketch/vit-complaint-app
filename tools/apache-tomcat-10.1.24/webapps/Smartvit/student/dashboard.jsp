<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Student Dashboard - SMART VIT" />
<%@ include file="/WEB-INF/includes/header.jsp" %>
<%@ include file="/WEB-INF/includes/navbar.jsp" %>

<main class="main-content">
    <div class="container py-4">
        <!-- Top Welcome Banner -->
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 pb-2 border-bottom">
            <div>
                <span class="badge bg-primary-subtle text-primary fw-bold text-uppercase small">Student Portal</span>
                <h2 class="fw-bold mb-0">Welcome, ${sessionScope.name}</h2>
                <p class="text-muted small mb-0"><i class="bi bi-person-badge me-1"></i> Reg No: <strong>${sessionScope.regEmpNo}</strong> | ${sessionScope.email}</p>
            </div>
            <div class="mt-3 mt-md-0 d-flex gap-2">
                <a href="${pageContext.request.contextPath}/student/raise-complaint" class="btn btn-vit-primary shadow-sm">
                    <i class="bi bi-plus-circle me-1"></i> Raise New Complaint
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
                <div class="vit-card stat-card">
                    <div class="stat-number">${closedComplaints}</div>
                    <div class="stat-label">Closed</div>
                </div>
            </div>
            <div class="col-6 col-lg-2">
                <div class="vit-card stat-card stat-danger">
                    <div class="stat-number">${reopenedComplaints}</div>
                    <div class="stat-label">Reopened</div>
                </div>
            </div>
        </div>

        <div class="row g-4">
            <!-- Recent Complaints Table -->
            <div class="col-lg-8">
                <div class="vit-card">
                    <div class="vit-card-header">
                        <span class="fw-bold"><i class="bi bi-clock-history me-2 text-primary"></i> Recent Complaints</span>
                        <a href="${pageContext.request.contextPath}/student/my-complaints" class="small text-decoration-none">View All (${totalComplaints}) <i class="bi bi-arrow-right"></i></a>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-hover table-vit mb-0 align-middle">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Title & Category</th>
                                    <th>Location</th>
                                    <th>Department</th>
                                    <th>Priority</th>
                                    <th>Status</th>
                                    <th class="text-end">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty recentComplaints}">
                                        <tr>
                                            <td colspan="7" class="text-center py-5 text-muted">
                                                <i class="bi bi-inbox fs-1 d-block text-secondary mb-2"></i>
                                                You haven't filed any complaints yet.
                                                <div class="mt-2">
                                                    <a href="${pageContext.request.contextPath}/student/raise-complaint" class="btn btn-sm btn-primary">Raise a Complaint</a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="c" items="${recentComplaints}">
                                            <tr>
                                                <td><span class="fw-bold font-monospace small">${c.complaintCode}</span></td>
                                                <td>
                                                    <div class="fw-semibold text-truncate" style="max-width: 180px;">${c.title}</div>
                                                    <small class="text-muted">${c.categoryName} &bull; ${c.subcategoryName}</small>
                                                </td>
                                                <td><small class="text-secondary">${c.locationDisplayName}</small></td>
                                                <td><span class="badge bg-light text-dark border">${c.departmentName}</span></td>
                                                <td><span class="badge ${c.priorityBadgeClass}">${c.priority}</span></td>
                                                <td><span class="badge ${c.statusBadgeClass}">${c.status}</span></td>
                                                <td class="text-end">
                                                    <a href="${pageContext.request.contextPath}/student/complaint-details?id=${c.complaintId}" class="btn btn-outline-primary btn-sm">
                                                        View Details
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Quick Actions & Location Guidance -->
            <div class="col-lg-4">
                <div class="vit-card p-4 mb-4">
                    <h5 class="fw-bold mb-3"><i class="bi bi-qr-code text-warning me-2"></i> Instant Room QR Scan</h5>
                    <p class="small text-muted mb-3">
                        Scanning the QR code affixed to classroom doors or hostel rooms automatically detects your exact building, floor, and room.
                    </p>
                    <button type="button" class="btn btn-warning w-100 fw-bold py-2 shadow-sm" data-bs-toggle="modal" data-bs-target="#qrScanModal">
                        <i class="bi bi-camera me-1"></i> Scan Room QR Code
                    </button>
                </div>

                <div class="vit-card p-4">
                    <h5 class="fw-bold mb-3"><i class="bi bi-info-circle text-primary me-2"></i> Resolution Guarantee (SLA)</h5>
                    <ul class="list-unstyled small mb-0">
                        <li class="mb-2 d-flex justify-content-between align-items-center">
                            <span><span class="badge bg-danger me-2">URGENT</span> Critical Hazards:</span>
                            <strong>4 Hours</strong>
                        </li>
                        <li class="mb-2 d-flex justify-content-between align-items-center">
                            <span><span class="badge bg-warning text-dark me-2">HIGH</span> Major Failures:</span>
                            <strong>24 Hours</strong>
                        </li>
                        <li class="mb-2 d-flex justify-content-between align-items-center">
                            <span><span class="badge bg-info text-dark me-2">MEDIUM</span> Room Fixtures:</span>
                            <strong>48 Hours</strong>
                        </li>
                        <li class="d-flex justify-content-between align-items-center">
                            <span><span class="badge bg-secondary me-2">LOW</span> General Maintenance:</span>
                            <strong>72 Hours</strong>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- QR Code Quick Scanner Simulation Modal -->
<div class="modal fade" id="qrScanModal" tabindex="-1" aria-labelledby="qrModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-navy text-white" style="background-color: var(--vit-navy);">
                <h5 class="modal-title text-white" id="qrModalLabel"><i class="bi bi-qr-code-scan text-warning me-2"></i> Scan Campus Location QR</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4 text-center">
                <p class="text-muted small mb-3">
                    Simulate scanning a physical campus QR sticker:
                </p>
                <div class="list-group text-start mb-3">
                    <a href="${pageContext.request.contextPath}/student/raise-complaint?locationId=3" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                        <div>
                            <div class="fw-bold"><i class="bi bi-building me-2 text-primary"></i> Hostel Block A - Room A-204</div>
                            <small class="text-muted">Hostel Room QR (Floor 2)</small>
                        </div>
                        <span class="badge bg-primary rounded-pill">Open <i class="bi bi-arrow-right"></i></span>
                    </a>
                    <a href="${pageContext.request.contextPath}/student/raise-complaint?locationId=1" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                        <div>
                            <div class="fw-bold"><i class="bi bi-easel me-2 text-success"></i> Academic Block 1 (AB1) - Room 204</div>
                            <small class="text-muted">Smart Classroom QR (Floor 2)</small>
                        </div>
                        <span class="badge bg-primary rounded-pill">Open <i class="bi bi-arrow-right"></i></span>
                    </a>
                    <a href="${pageContext.request.contextPath}/student/raise-complaint?locationId=5" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                        <div>
                            <div class="fw-bold"><i class="bi bi-cpu me-2 text-info"></i> Academic Block 2 (AB2) - Room 301</div>
                            <small class="text-muted">Computing Lab QR (Floor 3)</small>
                        </div>
                        <span class="badge bg-primary rounded-pill">Open <i class="bi bi-arrow-right"></i></span>
                    </a>
                    <a href="${pageContext.request.contextPath}/student/raise-complaint?locationId=8" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                        <div>
                            <div class="fw-bold"><i class="bi bi-cup-hot me-2 text-danger"></i> Food Park Mess - Main Dining Hall</div>
                            <small class="text-muted">Mess Complex QR</small>
                        </div>
                        <span class="badge bg-primary rounded-pill">Open <i class="bi bi-arrow-right"></i></span>
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/includes/footer.jsp" %>

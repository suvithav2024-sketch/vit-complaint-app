<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Manage Complaint - SMART VIT" />
<%@ include file="/WEB-INF/includes/header.jsp" %>
<%@ include file="/WEB-INF/includes/navbar.jsp" %>

<main class="main-content">
    <div class="container py-4">
        <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
            <div>
                <a href="${pageContext.request.contextPath}/department/complaints" class="text-decoration-none text-muted small">
                    <i class="bi bi-arrow-left me-1"></i> Back to Complaints
                </a>
                <h2 class="fw-bold mb-0 mt-1"><i class="bi bi-clipboard-check me-2"></i>${complaint.complaintId}</h2>
                <p class="text-muted small mb-0">${complaint.categoryName} &mdash; ${complaint.locationName}</p>
            </div>
            <div class="d-flex gap-2">
                <span class="badge ${complaint.priorityBadgeClass} fs-6 px-3 py-2">${complaint.priority}</span>
                <span class="badge ${complaint.statusBadgeClass} fs-6 px-3 py-2">${complaint.status}</span>
                <c:if test="${complaint.overdue}">
                    <span class="badge bg-danger fs-6 px-3 py-2">OVERDUE</span>
                </c:if>
            </div>
        </div>

        <%@ include file="/WEB-INF/includes/alerts.jsp" %>

        <div class="row g-4">
            <!-- Left: Complaint Details + Timeline -->
            <div class="col-lg-7">
                <!-- Complaint Info Card -->
                <div class="vit-card mb-4">
                    <div class="vit-card-header"><i class="bi bi-info-circle me-2"></i>Complaint Details</div>
                    <div class="vit-card-body">
                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <div class="small text-muted fw-semibold">FILED BY</div>
                                <div class="fw-bold">${complaint.filerName}</div>
                                <div class="small text-muted">${complaint.filerEmail} | ${complaint.filerRegNo}</div>
                            </div>
                            <div class="col-md-6">
                                <div class="small text-muted fw-semibold">LOCATION</div>
                                <div class="fw-bold">${complaint.locationName}</div>
                                <div class="small text-muted">${complaint.buildingName}</div>
                            </div>
                            <div class="col-md-6">
                                <div class="small text-muted fw-semibold">CATEGORY</div>
                                <div class="fw-bold">${complaint.categoryName}</div>
                                <c:if test="${not empty complaint.subCategoryName}">
                                    <div class="small text-muted">${complaint.subCategoryName}</div>
                                </c:if>
                            </div>
                            <div class="col-md-6">
                                <div class="small text-muted fw-semibold">FILED ON</div>
                                <div class="fw-bold">${complaint.formattedCreatedAt}</div>
                            </div>
                        </div>
                        <div class="mb-0">
                            <div class="small text-muted fw-semibold mb-1">DESCRIPTION</div>
                            <div class="bg-light rounded p-3">${complaint.description}</div>
                        </div>
                        <c:if test="${not empty attachments}">
                        <div class="mt-3">
                            <div class="small text-muted fw-semibold mb-2">ATTACHMENTS</div>
                            <div class="d-flex flex-wrap gap-2">
                                <c:forEach var="att" items="${attachments}">
                                    <a href="${pageContext.request.contextPath}/uploads/${att.fileName}" target="_blank" class="btn btn-sm btn-outline-secondary">
                                        <i class="bi bi-paperclip me-1"></i>${att.originalName}
                                    </a>
                                </c:forEach>
                            </div>
                        </div>
                        </c:if>
                    </div>
                </div>

                <!-- Timeline -->
                <div class="vit-card">
                    <div class="vit-card-header"><i class="bi bi-clock-history me-2"></i>Activity Timeline</div>
                    <div class="vit-card-body">
                        <div class="timeline">
                            <div class="timeline-item">
                                <div class="timeline-icon bg-primary"><i class="bi bi-flag-fill"></i></div>
                                <div class="timeline-content">
                                    <div class="fw-semibold">Complaint Filed</div>
                                    <div class="small text-muted">${complaint.formattedCreatedAt} by ${complaint.filerName}</div>
                                </div>
                            </div>
                            <c:forEach var="upd" items="${updates}">
                            <div class="timeline-item">
                                <div class="timeline-icon bg-info"><i class="bi bi-arrow-right-circle-fill"></i></div>
                                <div class="timeline-content">
                                    <div class="fw-semibold">Status → <span class="badge ${upd.newStatusBadgeClass}">${upd.newStatus}</span></div>
                                    <div class="text-muted small">${upd.remarks}</div>
                                    <div class="text-muted" style="font-size:0.75rem;">${upd.formattedUpdatedAt} by ${upd.updatedByName}</div>
                                    <c:if test="${not empty upd.proofFileName}">
                                        <a href="${pageContext.request.contextPath}/uploads/${upd.proofFileName}" target="_blank" class="btn btn-sm btn-outline-success mt-1">
                                            <i class="bi bi-image me-1"></i>View Proof
                                        </a>
                                    </c:if>
                                </div>
                            </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right: Action Panel -->
            <div class="col-lg-5">
                <!-- Update Status Form -->
                <div class="vit-card mb-4">
                    <div class="vit-card-header bg-primary text-white"><i class="bi bi-pencil-square me-2"></i>Update Complaint Status</div>
                    <div class="vit-card-body">
                        <c:if test="${complaint.status == 'PENDING' || complaint.status == 'ASSIGNED'}">
                            <form action="${pageContext.request.contextPath}/department/update-status" method="post" class="mb-3 pb-3 border-bottom">
                                <input type="hidden" name="complaintId" value="${complaint.complaintId}">
                                <input type="hidden" name="action" value="acknowledge">
                                <input type="hidden" name="newStatus" value="ACKNOWLEDGED">
                                <div class="d-grid">
                                    <button type="submit" class="btn btn-outline-info fw-semibold">
                                        <i class="bi bi-hand-thumbs-up me-1"></i> Acknowledge Assignment
                                    </button>
                                </div>
                            </form>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/department/update-status" method="post" enctype="multipart/form-data">
                            <input type="hidden" name="complaintId" value="${complaint.complaintId}">
                            <div class="mb-3">
                                <label class="form-label fw-semibold">New Status <span class="text-danger">*</span></label>
                                <select name="newStatus" class="form-select" required>
                                    <option value="">-- Select Status --</option>
                                    <c:if test="${complaint.status == 'PENDING' || complaint.status == 'ASSIGNED'}">
                                        <option value="ACKNOWLEDGED">Mark as Acknowledged</option>
                                    </c:if>
                                    <c:if test="${complaint.status == 'PENDING' || complaint.status == 'ASSIGNED' || complaint.status == 'ACKNOWLEDGED' || complaint.status == 'REOPENED' || complaint.status == 'IN_PROGRESS'}">
                                        <option value="IN_PROGRESS" ${complaint.status == 'IN_PROGRESS' ? 'selected' : ''}>Mark / Keep In Progress</option>
                                    </c:if>
                                    <c:if test="${complaint.status == 'IN_PROGRESS' || complaint.status == 'ACKNOWLEDGED' || complaint.status == 'REOPENED' || complaint.status == 'ASSIGNED' || complaint.status == 'PENDING'}">
                                        <option value="RESOLVED">Mark as Resolved</option>
                                    </c:if>
                                    <c:if test="${complaint.status == 'RESOLVED' || complaint.status == 'IN_PROGRESS'}">
                                        <option value="CLOSED">Close Complaint</option>
                                    </c:if>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Remarks / Notes <span class="text-danger">*</span></label>
                                <textarea name="remarks" class="form-control" rows="3" required placeholder="Describe what was done or action taken..."></textarea>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Resolution Proof (Optional)</label>
                                <input type="file" name="proofFile" class="form-control" accept="image/*,.pdf">
                                <div class="form-text">Upload a photo or PDF as proof of resolution.</div>
                            </div>
                            <button type="submit" class="btn btn-vit-primary w-100">
                                <i class="bi bi-check2-square me-1"></i> Update Status
                            </button>
                        </form>
                    </div>
                </div>

                <!-- Assign Technician -->
                <div class="vit-card mb-4">
                    <div class="vit-card-header"><i class="bi bi-person-gear me-2"></i>Assign Technician</div>
                    <div class="vit-card-body">
                        <form action="${pageContext.request.contextPath}/department/assign-technician" method="post">
                            <input type="hidden" name="complaintId" value="${complaint.complaintId}">
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Technician</label>
                                <select name="staffId" class="form-select">
                                    <option value="">-- Unassigned --</option>
                                    <c:forEach var="tech" items="${technicians}">
                                        <option value="${tech.id}" ${assignment != null && assignment.technicianId == tech.id ? 'selected' : ''}>${tech.name} (${tech.designation})</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Notes</label>
                                <input type="text" name="notes" class="form-control" placeholder="Optional instructions for technician" value="${assignment.notes}">
                            </div>
                            <button type="submit" class="btn btn-outline-primary w-100">
                                <i class="bi bi-person-check me-1"></i> Save Assignment
                            </button>
                        </form>
                    </div>
                </div>

                <!-- Current Assignment Info -->
                <c:if test="${assignment != null}">
                <div class="vit-card mb-4 border-primary">
                    <div class="vit-card-header"><i class="bi bi-person-badge me-2"></i>Currently Assigned</div>
                    <div class="vit-card-body">
                        <div class="fw-bold">${assignment.technicianName}</div>
                        <div class="small text-muted">${assignment.technicianDesignation}</div>
                        <c:if test="${not empty assignment.notes}">
                            <div class="mt-2 p-2 bg-light rounded small">${assignment.notes}</div>
                        </c:if>
                        <div class="text-muted small mt-2">Assigned: ${assignment.formattedAssignedAt}</div>
                    </div>
                </div>
                </c:if>

                <!-- Feedback Info -->
                <c:if test="${feedback != null}">
                <div class="vit-card border-success">
                    <div class="vit-card-header text-success"><i class="bi bi-star-fill me-2"></i>Student Feedback</div>
                    <div class="vit-card-body">
                        <div class="mb-1">
                            <c:forEach begin="1" end="5" var="i">
                                <i class="bi ${i <= feedback.rating ? 'bi-star-fill text-warning' : 'bi-star text-muted'}"></i>
                            </c:forEach>
                            <span class="fw-bold ms-2">${feedback.rating}/5</span>
                        </div>
                        <c:if test="${not empty feedback.comment}">
                            <p class="small text-muted mb-0">"${feedback.comment}"</p>
                        </c:if>
                    </div>
                </div>
                </c:if>
            </div>
        </div>
    </div>
</main>

<%@ include file="/WEB-INF/includes/footer.jsp" %>

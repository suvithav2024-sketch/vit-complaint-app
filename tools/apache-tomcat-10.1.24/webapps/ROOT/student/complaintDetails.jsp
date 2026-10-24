<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Complaint ${complaint.complaintCode} - SMART VIT" />
<%@ include file="/WEB-INF/includes/header.jsp" %>
<%@ include file="/WEB-INF/includes/navbar.jsp" %>

<main class="main-content">
    <div class="container py-4">
        <!-- Header -->
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 pb-2 border-bottom">
            <div>
                <a href="${pageContext.request.contextPath}/${sessionScope.currentUser.student ? 'student/my-complaints' : (sessionScope.currentUser.admin ? 'admin/complaints' : 'staff/my-complaints')}" class="text-decoration-none small text-muted">
                    <i class="bi bi-arrow-left"></i> Back to Complaints
                </a>
                <h2 class="fw-bold mb-0 mt-1 d-flex align-items-center gap-2">
                    ${complaint.complaintCode}
                    <span class="badge ${complaint.statusBadgeClass} fs-6">${complaint.status}</span>
                    <c:if test="${complaint.overdue}">
                        <span class="badge bg-danger fs-6"><i class="bi bi-exclamation-triangle-fill"></i> Overdue SLA</span>
                    </c:if>
                </h2>
                <div class="text-muted small">Filed on ${complaint.createdAt} &bull; Expected resolution by: <strong>${complaint.dueDate != null ? complaint.dueDate : 'Standard SLA'}</strong></div>
            </div>
            <div class="mt-3 mt-md-0 d-flex gap-2">
                <c:if test="${complaint.status == 'RESOLVED'}">
                    <button type="button" class="btn btn-warning text-dark fw-semibold shadow-sm" data-bs-toggle="modal" data-bs-target="#feedbackModal">
                        <i class="bi bi-star-fill me-1"></i> Submit Feedback
                    </button>
                    <button type="button" class="btn btn-outline-danger fw-semibold" data-bs-toggle="modal" data-bs-target="#reopenModal">
                        <i class="bi bi-arrow-counterclockwise me-1"></i> Reopen Complaint
                    </button>
                </c:if>
                <c:if test="${complaint.status == 'CLOSED' && empty feedback}">
                    <button type="button" class="btn btn-warning text-dark fw-semibold shadow-sm" data-bs-toggle="modal" data-bs-target="#feedbackModal">
                        <i class="bi bi-star-fill me-1"></i> Rate Resolution
                    </button>
                </c:if>
            </div>
        </div>

        <%@ include file="/WEB-INF/includes/alerts.jsp" %>

        <div class="row g-4">
            <!-- Left Column: Details & Resolution -->
            <div class="col-lg-8">
                <!-- Resolution Notice Banner -->
                <c:if test="${complaint.status == 'RESOLVED' || complaint.status == 'CLOSED'}">
                    <div class="card border-success bg-success bg-opacity-10 mb-4 shadow-sm">
                        <div class="card-body p-4">
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <h5 class="fw-bold text-success mb-0"><i class="bi bi-check-circle-fill me-2"></i> Resolution Details</h5>
                                <span class="badge ${complaint.status == 'RESOLVED' ? 'bg-warning text-dark' : 'bg-success'}">
                                    ${complaint.status == 'RESOLVED' ? 'Awaiting Student Feedback / Confirmation' : 'Resolution Confirmed'}
                                </span>
                            </div>
                            <p class="mb-2"><strong>Resolution Remarks:</strong> ${empty complaint.resolutionText ? 'Work completed as reported.' : complaint.resolutionText}</p>
                            <div class="small text-muted mb-3">
                                Resolved By: <strong>${not empty complaint.resolvedByName ? complaint.resolvedByName : 'Department Technician'}</strong> &bull; Date: ${not empty complaint.resolvedAt ? complaint.resolvedAt : 'Recently'}
                            </div>

                            <!-- Resolution Proof Attachment if any -->
                            <c:forEach var="att" items="${attachments}">
                                <c:if test="${att.attachmentType == 'RESOLUTION_PROOF'}">
                                    <div class="mb-3 p-2 bg-white rounded border d-inline-block">
                                        <div class="small fw-semibold text-muted mb-1"><i class="bi bi-image me-1"></i> Resolution Evidence / Proof:</div>
                                        <a href="${pageContext.request.contextPath}/${att.filePath}" target="_blank" class="btn btn-sm btn-outline-success">
                                            <i class="bi bi-eye me-1"></i> View ${att.fileName}
                                        </a>
                                    </div>
                                </c:if>
                            </c:forEach>

                            <c:if test="${complaint.status == 'RESOLVED'}">
                                <div class="d-flex gap-2 mt-2">
                                    <button type="button" class="btn btn-warning btn-sm px-3 fw-bold text-dark" data-bs-toggle="modal" data-bs-target="#feedbackModal">
                                        <i class="bi bi-star-fill me-1"></i> Submit Feedback
                                    </button>
                                    <button type="button" class="btn btn-outline-danger btn-sm px-3" data-bs-toggle="modal" data-bs-target="#reopenModal">
                                        <i class="bi bi-arrow-counterclockwise me-1"></i> Reopen Complaint
                                    </button>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </c:if>

                <!-- Post-Resolution Feedback Form directly on page if RESOLVED or CLOSED and feedback not yet given -->
                <c:if test="${(complaint.status == 'RESOLVED' || complaint.status == 'CLOSED') && empty feedback}">
                    <div class="vit-card mb-4 border-warning shadow-sm">
                        <div class="vit-card-header bg-warning text-dark fw-bold">
                            <i class="bi bi-star-fill me-2"></i> Rate Resolution Experience
                        </div>
                        <div class="vit-card-body p-4">
                            <form action="${pageContext.request.contextPath}/student/feedback" method="post">
                                <input type="hidden" name="complaintId" value="${complaint.complaintId}">

                                <div class="mb-3">
                                    <label class="form-label fw-bold">Was your problem solved satisfactorily?</label>
                                    <div class="btn-group w-100" role="group">
                                        <input type="radio" class="btn-check" name="problemSolved" id="pageSolvedYes" value="true" checked>
                                        <label class="btn btn-outline-success py-2 fw-semibold" for="pageSolvedYes">
                                            <i class="bi bi-hand-thumbs-up me-1"></i> YES &mdash; Solved Completely
                                        </label>

                                        <input type="radio" class="btn-check" name="problemSolved" id="pageSolvedNo" value="false">
                                        <label class="btn btn-outline-danger py-2 fw-semibold" for="pageSolvedNo">
                                            <i class="bi bi-hand-thumbs-down me-1"></i> NO &mdash; Problem Persists (Reopen)
                                        </label>
                                    </div>
                                    <div class="form-text mt-1 text-muted">
                                        Selecting <strong>NO</strong> will record your feedback and immediately trigger a reopening request for the department.
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label fw-bold">Overall Service Rating (1 to 5 Stars):</label>
                                    <div class="star-rating mb-2" style="justify-content: flex-start; flex-direction: row-reverse; display: inline-flex;">
                                        <input type="radio" id="inlineStar5" name="rating" value="5" checked><label for="inlineStar5">★</label>
                                        <input type="radio" id="inlineStar4" name="rating" value="4"><label for="inlineStar4">★</label>
                                        <input type="radio" id="inlineStar3" name="rating" value="3"><label for="inlineStar3">★</label>
                                        <input type="radio" id="inlineStar2" name="rating" value="2"><label for="inlineStar2">★</label>
                                        <input type="radio" id="inlineStar1" name="rating" value="1"><label for="inlineStar1">★</label>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label fw-semibold">Feedback / Comments:</label>
                                    <textarea name="comment" class="form-control" rows="2" placeholder="Tell us about the service quality, responsiveness, or resolution..."></textarea>
                                </div>

                                <div class="d-flex gap-2">
                                    <button type="submit" class="btn btn-warning text-dark fw-bold px-4">
                                        <i class="bi bi-send-check me-1"></i> Submit Feedback
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </c:if>

                <!-- Feedback Display if already submitted -->
                <c:if test="${not empty feedback}">
                    <div class="card border-info bg-info bg-opacity-10 mb-4 shadow-sm">
                        <div class="card-body p-3">
                            <h6 class="fw-bold text-navy mb-1"><i class="bi bi-star-fill text-warning me-1"></i> Student Resolution Feedback</h6>
                            <div class="d-flex align-items-center gap-2 mb-1">
                                <span class="text-warning fs-5">
                                    <c:forEach begin="1" end="${feedback.rating}">★</c:forEach><c:forEach begin="${feedback.rating + 1}" end="5">☆</c:forEach>
                                </span>
                                <span class="badge ${feedback.problemSolved ? 'bg-success' : 'bg-danger'}">
                                    ${feedback.problemSolved ? 'Problem Solved: YES' : 'Problem Solved: NO (Reopened)'}
                                </span>
                            </div>
                            <c:if test="${not empty feedback.comment}">
                                <div class="small text-muted fst-italic">"${feedback.comment}"</div>
                            </c:if>
                        </div>
                    </div>
                </c:if>

                <!-- Core Complaint Information -->
                <div class="vit-card p-4 mb-4">
                    <h5 class="fw-bold text-navy border-bottom pb-2 mb-3">Complaint Details</h5>
                    <h4 class="fw-bold text-primary mb-3">${complaint.title}</h4>
                    <p class="text-secondary mb-4" style="white-space: pre-line;">${complaint.description}</p>

                    <div class="row g-3 small bg-light p-3 rounded-3 border">
                        <div class="col-md-6">
                            <strong>Category:</strong> ${complaint.categoryName} &bull; ${complaint.subcategoryName}
                        </div>
                        <div class="col-md-6">
                            <strong>Priority:</strong> <span class="badge ${complaint.priorityBadgeClass}">${complaint.priority}</span>
                        </div>
                        <div class="col-md-6">
                            <strong>Campus Building:</strong> ${complaint.buildingName} (${complaint.buildingCode})
                        </div>
                        <div class="col-md-6">
                            <strong>Room / Floor:</strong> Room ${complaint.roomNumber} (Floor ${complaint.floor}${complaint.block ? ', ' + complaint.block : ''})
                        </div>
                        <div class="col-md-6">
                            <strong>Assigned Department:</strong> ${complaint.departmentName}
                        </div>
                        <div class="col-md-6">
                            <strong>Current Status:</strong> <span class="badge ${complaint.statusBadgeClass}">${complaint.status}</span>
                        </div>
                    </div>

                    <!-- Attachments -->
                    <c:if test="${not empty attachments}">
                        <div class="mt-4 border-top pt-3">
                            <h6 class="fw-bold text-navy mb-2"><i class="bi bi-paperclip me-1"></i> Attachments (${attachments.size()})</h6>
                            <div class="d-flex flex-wrap gap-2">
                                <c:forEach var="att" items="${attachments}">
                                    <a href="${pageContext.request.contextPath}/${att.filePath}" target="_blank" class="btn btn-sm btn-outline-secondary d-flex align-items-center gap-2">
                                        <i class="bi bi-image"></i>
                                        <span>${att.fileName}</span>
                                        <span class="badge bg-secondary">${att.attachmentType}</span>
                                    </a>
                                </c:forEach>
                            </div>
                        </div>
                    </c:if>
                </div>

                <!-- Timeline Updates History -->
                <div class="vit-card p-4">
                    <h5 class="fw-bold text-navy border-bottom pb-2 mb-3"><i class="bi bi-clock-history me-2 text-primary"></i> Progress Timeline & Audit Trail</h5>
                    
                    <div class="timeline-container">
                        <c:forEach var="u" items="${updates}" varStatus="loop">
                            <div class="timeline-item ${loop.last ? 'active' : 'completed'}">
                                <div class="timeline-point">
                                    <c:choose>
                                        <c:when test="${u.newStatus == 'RESOLVED' || u.newStatus == 'CLOSED'}">
                                            <i class="bi bi-check-lg small"></i>
                                        </c:when>
                                        <c:otherwise>
                                            <i class="bi bi-circle-fill small" style="font-size: 8px;"></i>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="timeline-content shadow-sm">
                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                        <span class="badge bg-navy text-white fw-semibold" style="background-color: var(--vit-navy);">${u.newStatus}</span>
                                        <small class="text-muted"><i class="bi bi-clock me-1"></i>${u.createdAt}</small>
                                    </div>
                                    <div class="small fw-semibold text-dark">${u.comment}</div>
                                    <small class="text-muted d-block mt-1">Updated by: <strong>${u.updatedByName}</strong></small>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <!-- Right Column: Department & Staff Contact Card -->
            <div class="col-lg-4">
                <!-- Responsible Staff / Technician Card -->
                <div class="vit-card p-4 mb-4">
                    <h5 class="fw-bold text-navy mb-3"><i class="bi bi-person-gear text-primary me-2"></i> Responsible Technician</h5>
                    <c:choose>
                        <c:when test="${not empty complaint.assignedStaffName}">
                            <div class="d-flex align-items-center gap-3 mb-3">
                                <div class="rounded-circle bg-primary bg-opacity-10 text-primary p-3 fs-3">
                                    <i class="bi bi-person-fill"></i>
                                </div>
                                <div>
                                    <h6 class="fw-bold mb-0">${complaint.assignedStaffName}</h6>
                                    <small class="text-muted">Assigned Department Field Staff</small>
                                </div>
                            </div>
                            <ul class="list-unstyled small mb-0">
                                <li class="mb-2"><i class="bi bi-telephone text-primary me-2"></i> <strong>Contact:</strong> ${complaint.assignedStaffPhone != null ? complaint.assignedStaffPhone : 'Campus Ext.'}</li>
                                <li class="mb-2"><i class="bi bi-envelope text-primary me-2"></i> <strong>Email:</strong> ${complaint.assignedStaffEmail}</li>
                                <li><i class="bi bi-building text-primary me-2"></i> <strong>Dept:</strong> ${complaint.departmentName}</li>
                            </ul>
                        </c:when>
                        <c:otherwise>
                            <p class="small text-muted mb-0">
                                <i class="bi bi-hourglass-split me-1 text-warning"></i> Assigned to <strong>${complaint.departmentName}</strong> pool. Technician will be allocated upon acknowledgment.
                            </p>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Department Helpdesk Card -->
                <div class="vit-card p-4">
                    <h5 class="fw-bold text-navy mb-3"><i class="bi bi-telephone-inbound text-warning me-2"></i> Department Contact</h5>
                    <div class="fw-bold mb-1">${complaint.departmentName}</div>
                    <p class="small text-muted mb-3">Operating hours: Mon - Sat (8:30 AM - 6:00 PM)</p>
                    <ul class="list-unstyled small mb-0">
                        <li class="mb-2"><i class="bi bi-envelope me-2 text-primary"></i> ${complaint.departmentEmail}</li>
                        <li class="mb-2"><i class="bi bi-telephone me-2 text-primary"></i> ${complaint.departmentPhone}</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Confirm Resolution Modal -->
<div class="modal fade" id="confirmModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/student/confirm-resolution" method="post">
                <input type="hidden" name="complaintId" value="${complaint.complaintId}">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title"><i class="bi bi-check2-circle me-2"></i> Confirm Problem Resolved</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <p>Are you satisfied that the issue has been completely fixed by the maintenance department?</p>
                    <div class="mb-3">
                        <label for="confirmComment" class="form-label small fw-semibold">Confirmation Note (Optional):</label>
                        <textarea class="form-control" id="confirmComment" name="comment" rows="2" placeholder="e.g. Verified fan is running smoothly. Thank you."></textarea>
                    </div>
                    <div class="small text-muted">This will officially mark the complaint as <strong>CLOSED</strong>.</div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-success px-4 fw-bold">Confirm & Close Complaint</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Reopen Complaint Modal -->
<div class="modal fade" id="reopenModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/student/reopen-complaint" method="post">
                <input type="hidden" name="complaintId" value="${complaint.complaintId}">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title"><i class="bi bi-arrow-counterclockwise me-2"></i> Reopen Complaint</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <p class="text-danger fw-semibold">Why is the issue still unresolved?</p>
                    <div class="mb-3">
                        <label for="reopenReason" class="form-label small fw-semibold">Explanation for Reopening *:</label>
                        <textarea class="form-control" id="reopenReason" name="reason" rows="3" placeholder="Please specify why the resolution was unsatisfactory (e.g. Light was replaced but switch still sparks)..." required></textarea>
                    </div>
                    <div class="small text-muted">The assigned department will be notified immediately to restart corrective action.</div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-danger px-4 fw-bold">Reopen Complaint</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Feedback & Rating Modal -->
<div class="modal fade" id="feedbackModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/student/feedback" method="post">
                <input type="hidden" name="complaintId" value="${complaint.complaintId}">
                <div class="modal-header bg-warning text-dark">
                    <h5 class="modal-title fw-bold"><i class="bi bi-star-fill me-2"></i> Rate Service Experience</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4 text-center">
                    <h6 class="fw-bold mb-3">Was your problem solved satisfactorily?</h6>
                    <div class="btn-group w-100 mb-4" role="group">
                        <input type="radio" class="btn-check" name="problemSolved" id="solvedYes" value="true" checked>
                        <label class="btn btn-outline-success py-2 fw-semibold" for="solvedYes"><i class="bi bi-hand-thumbs-up me-1"></i> YES</label>

                        <input type="radio" class="btn-check" name="problemSolved" id="solvedNo" value="false">
                        <label class="btn btn-outline-danger py-2 fw-semibold" for="solvedNo"><i class="bi bi-hand-thumbs-down me-1"></i> NO</label>
                    </div>

                    <h6 class="fw-bold mb-2">Overall Service Rating</h6>
                    <div class="star-rating mb-3 justify-content-center">
                        <input type="radio" id="star5" name="rating" value="5" checked><label for="star5">★</label>
                        <input type="radio" id="star4" name="rating" value="4"><label for="star4">★</label>
                        <input type="radio" id="star3" name="rating" value="3"><label for="star3">★</label>
                        <input type="radio" id="star2" name="rating" value="2"><label for="star2">★</label>
                        <input type="radio" id="star1" name="rating" value="1"><label for="star1">★</label>
                    </div>

                    <div class="text-start mb-2">
                        <label for="fbComment" class="form-label small fw-semibold">Optional Feedback / Comments:</label>
                        <textarea class="form-control" id="fbComment" name="comment" rows="2" placeholder="Tell us how we can improve..."></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Skip</button>
                    <button type="submit" class="btn btn-warning px-4 fw-bold">Submit Feedback</button>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/includes/footer.jsp" %>

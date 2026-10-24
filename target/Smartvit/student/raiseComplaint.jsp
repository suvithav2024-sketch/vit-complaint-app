<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Raise Complaint - SMART VIT" />
<%@ include file="/WEB-INF/includes/header.jsp" %>
<%@ include file="/WEB-INF/includes/navbar.jsp" %>

<main class="main-content">
    <div class="container py-4">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="vit-card p-4 p-md-5">
                    <div class="d-flex justify-content-between align-items-center border-bottom pb-3 mb-4">
                        <div>
                            <span class="badge bg-warning text-dark fw-bold text-uppercase small">Lodge Grievance</span>
                            <h2 class="fw-bold mb-0">Raise Campus Complaint</h2>
                        </div>
                        <a href="${pageContext.request.contextPath}/${sessionScope.currentUser.student ? 'student/dashboard' : 'staff/dashboard'}" class="btn btn-outline-secondary btn-sm">
                            <i class="bi bi-arrow-left me-1"></i> Back
                        </a>
                    </div>

                    <%@ include file="/WEB-INF/includes/alerts.jsp" %>

                    <c:if test="${fromQRCode}">
                        <div class="alert alert-info d-flex align-items-center gap-3 py-3 mb-4 shadow-sm">
                            <i class="bi bi-qr-code-scan fs-1 text-primary"></i>
                            <div>
                                <h6 class="fw-bold mb-1">Smart QR Location Detected!</h6>
                                <p class="small mb-0">
                                    Location automatically set to <strong>${selectedLocation.buildingName} - Room ${selectedLocation.roomNumber}</strong> (Floor ${selectedLocation.floor}${selectedLocation.block ? ', ' + selectedLocation.block : ''}). You only need to choose the issue and describe it.
                                </p>
                            </div>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/student/raise-complaint" method="post" enctype="multipart/form-data">
                        <!-- Location Section -->
                        <h5 class="fw-bold text-navy mb-3"><i class="bi bi-geo-alt text-warning me-2"></i>1. Campus Location</h5>
                        
                        <c:choose>
                            <c:when test="${fromQRCode}">
                                <input type="hidden" name="locationId" value="${selectedLocationId}">
                                <div class="row g-3 mb-4">
                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold small text-uppercase">Building (Locked by QR)</label>
                                        <input type="text" class="form-control bg-light" value="${selectedLocation.buildingName}" readonly>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-semibold small text-uppercase">Room / Area (Locked by QR)</label>
                                        <input type="text" class="form-control bg-light" value="Room ${selectedLocation.roomNumber} (Floor ${selectedLocation.floor})" readonly>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="row g-3 mb-4">
                                    <div class="col-md-6">
                                        <label for="buildingSelect" class="form-label fw-semibold small text-uppercase">Campus Building *</label>
                                        <select class="form-select" id="buildingSelect" required>
                                            <option value="">-- Select Building --</option>
                                            <c:forEach var="b" items="${buildings}">
                                                <option value="${b.buildingId}">${b.name} (${b.code})</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="locationSelect" class="form-label fw-semibold small text-uppercase">Room / Specific Location *</label>
                                        <select class="form-select" id="locationSelect" name="locationId" required disabled>
                                            <option value="">-- Select Building First --</option>
                                        </select>
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <!-- Category Section -->
                        <h5 class="fw-bold text-navy mb-3"><i class="bi bi-tags text-warning me-2"></i>2. Issue Classification</h5>
                        <div class="row g-3 mb-4">
                            <div class="col-md-4">
                                <label for="categorySelect" class="form-label fw-semibold small text-uppercase">Category *</label>
                                <select class="form-select" id="categorySelect" name="categoryId" required>
                                    <option value="">-- Select Category --</option>
                                    <c:forEach var="cat" items="${categories}">
                                        <option value="${cat.categoryId}">${cat.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label for="subcategorySelect" class="form-label fw-semibold small text-uppercase">Subcategory *</label>
                                <select class="form-select" id="subcategorySelect" name="subcategoryId" required disabled>
                                    <option value="">-- Select Category First --</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label for="prioritySelect" class="form-label fw-semibold small text-uppercase">Urgency Priority *</label>
                                <select class="form-select" id="prioritySelect" name="priority" required>
                                    <option value="LOW">LOW (Up to 72 Hours)</option>
                                    <option value="MEDIUM" selected>MEDIUM (Standard 48 Hours)</option>
                                    <option value="HIGH">HIGH (Urgent 24 Hours)</option>
                                    <option value="URGENT">URGENT (Critical 4 Hours)</option>
                                </select>
                            </div>
                        </div>

                        <!-- Details Section -->
                        <h5 class="fw-bold text-navy mb-3"><i class="bi bi-card-text text-warning me-2"></i>3. Complaint Information</h5>
                        <div class="mb-3">
                            <label for="title" class="form-label fw-semibold small text-uppercase">Complaint Title *</label>
                            <input type="text" class="form-control" id="title" name="title" placeholder="Brief summary (e.g. Fan regulator broken and not rotating)" required>
                        </div>

                        <div class="mb-3">
                            <label for="description" class="form-label fw-semibold small text-uppercase">Detailed Description *</label>
                            <textarea class="form-control" id="description" name="description" rows="4" placeholder="Please provide specific details about the issue to assist the maintenance team..." required></textarea>
                        </div>

                        <div class="mb-4">
                            <label for="attachment" class="form-label fw-semibold small text-uppercase">Optional Photo Attachment (Proof / Damage)</label>
                            <input type="file" class="form-control" id="attachment" name="attachment" accept="image/*,.pdf">
                            <div class="form-text small text-muted">Supported formats: JPG, PNG, WEBP, PDF (Max 10MB). Helpful for physical damage or leakage.</div>
                        </div>

                        <div class="border-top pt-4 text-end">
                            <a href="${pageContext.request.contextPath}/${sessionScope.currentUser.student ? 'student/dashboard' : 'staff/dashboard'}" class="btn btn-outline-secondary px-4 me-2">Cancel</a>
                            <button type="submit" class="btn btn-vit-primary px-5 fw-semibold shadow-sm">
                                <i class="bi bi-send-fill me-2"></i> Submit Complaint
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</main>

<%@ include file="/WEB-INF/includes/footer.jsp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Smart QR Code Generator - SMART VIT" />
<%@ include file="/WEB-INF/includes/header.jsp" %>
<%@ include file="/WEB-INF/includes/navbar.jsp" %>

<main class="main-content">
    <div class="container py-4">
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 pb-2 border-bottom">
            <div>
                <h2 class="fw-bold mb-0"><i class="bi bi-qr-code-scan me-2 text-primary"></i>Smart Location QR Codes</h2>
                <p class="text-muted small mb-0">Generate and print ZXing QR codes linking directly to pre-filled complaint pages for campus classrooms, hostel rooms, labs, and messes.</p>
            </div>
            <div class="mt-3 mt-md-0">
                <button type="button" class="btn btn-vit-primary shadow-sm" data-bs-toggle="modal" data-bs-target="#generateQRModal">
                    <i class="bi bi-qr-code me-1"></i> Generate New QR Code
                </button>
            </div>
        </div>

        <%@ include file="/WEB-INF/includes/alerts.jsp" %>

        <!-- QR Codes Grid -->
        <div class="row g-4">
            <c:choose>
                <c:when test="${empty qrCodes}">
                    <div class="col-12 text-center py-5 text-muted">
                        <i class="bi bi-qr-code fs-1 d-block mb-2"></i>
                        No QR codes generated yet. Click "Generate New QR Code" to create one.
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="qr" items="${qrCodes}">
                        <div class="col-sm-6 col-md-4 col-lg-3">
                            <div class="vit-card text-center h-100">
                                <div class="vit-card-header bg-light d-flex justify-content-between align-items-center py-2 px-3">
                                    <span class="badge bg-primary">#${qr.qrId}</span>
                                    <c:choose>
                                        <c:when test="${qr.active}"><span class="badge bg-success">Active</span></c:when>
                                        <c:otherwise><span class="badge bg-secondary">Inactive</span></c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="vit-card-body p-3">
                                    <div class="p-2 border rounded bg-white mb-2 shadow-sm d-inline-block">
                                        <img src="${pageContext.request.contextPath}/${qr.qrImagePath}" alt="QR Code" class="img-fluid" style="width:160px; height:160px;" onerror="this.src='https://api.qrserver.com/v1/create-qr-code/?size=160x160&data=${qr.targetUrl}';">
                                    </div>
                                    <h6 class="fw-bold text-dark mb-1">${qr.locationName}</h6>
                                    <p class="small text-muted mb-2"><i class="bi bi-building me-1"></i>${qr.buildingName} (${qr.roomNumber})</p>
                                    <p class="small text-truncate text-muted mb-3" style="max-width:220px;" title="${qr.targetUrl}">
                                        <i class="bi bi-link-45deg me-1"></i><a href="${qr.targetUrl}" target="_blank">${qr.targetUrl}</a>
                                    </p>
                                    <div class="d-flex justify-content-center gap-1">
                                        <a href="${pageContext.request.contextPath}/${qr.qrImagePath}" download="${qr.qrCodeIdentifier}.png" class="btn btn-sm btn-outline-primary" title="Download Image">
                                            <i class="bi bi-download"></i>
                                        </a>
                                        <form method="post" action="${pageContext.request.contextPath}/admin/qr-codes" class="d-inline">
                                            <input type="hidden" name="action" value="regenerate">
                                            <input type="hidden" name="qrId" value="${qr.qrId}">
                                            <button type="submit" class="btn btn-sm btn-outline-secondary" title="Regenerate QR Image">
                                                <i class="bi bi-arrow-repeat"></i>
                                            </button>
                                        </form>
                                        <form method="post" action="${pageContext.request.contextPath}/admin/qr-codes" class="d-inline">
                                            <input type="hidden" name="action" value="toggleActive">
                                            <input type="hidden" name="qrId" value="${qr.qrId}">
                                            <input type="hidden" name="active" value="${!qr.active}">
                                            <button type="submit" class="btn btn-sm ${qr.active ? 'btn-outline-warning' : 'btn-outline-success'}" title="${qr.active ? 'Deactivate' : 'Activate'}">
                                                <i class="bi ${qr.active ? 'bi-pause-fill' : 'bi-play-fill'}"></i>
                                            </button>
                                        </form>
                                        <form method="post" action="${pageContext.request.contextPath}/admin/qr-codes" class="d-inline">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="qrId" value="${qr.qrId}">
                                            <button type="submit" class="btn btn-sm btn-outline-danger" title="Delete QR Code" onclick="return confirm('Delete this QR code entry?')">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

<!-- Generate QR Code Modal -->
<div class="modal fade" id="generateQRModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form method="post" action="${pageContext.request.contextPath}/admin/qr-codes">
                <input type="hidden" name="action" value="generate">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title"><i class="bi bi-qr-code me-2"></i>Generate ZXing Location QR Code</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p class="text-muted small">Select a location to generate a unique smart QR code sticker for mounting on walls or doors.</p>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Target Campus Location *</label>
                        <select name="locationId" class="form-select" required>
                            <option value="">-- Choose Location --</option>
                            <c:forEach var="loc" items="${locations}">
                                <option value="${loc.locationId}">${loc.buildingName} - ${loc.roomNumber} (${loc.locationName})</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-vit-primary">Generate QR Code</button>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/includes/footer.jsp" %>

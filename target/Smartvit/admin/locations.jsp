<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Buildings & Locations - SMART VIT" />
<%@ include file="/WEB-INF/includes/header.jsp" %>
<%@ include file="/WEB-INF/includes/navbar.jsp" %>

<main class="main-content">
    <div class="container py-4">
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 pb-2 border-bottom">
            <div>
                <h2 class="fw-bold mb-0"><i class="bi bi-geo-alt me-2 text-primary"></i>Buildings & Campus Locations</h2>
                <p class="text-muted small mb-0">Manage academic blocks, hostel buildings, mess halls, and specific room locations across campus.</p>
            </div>
            <div class="mt-3 mt-md-0 d-flex gap-2">
                <button type="button" class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#addBuildingModal">
                    <i class="bi bi-building-add me-1"></i> Add Building
                </button>
                <button type="button" class="btn btn-vit-primary shadow-sm" data-bs-toggle="modal" data-bs-target="#addLocationModal">
                    <i class="bi bi-geo-fill me-1"></i> Add Specific Location
                </button>
            </div>
        </div>

        <%@ include file="/WEB-INF/includes/alerts.jsp" %>

        <div class="row g-4">
            <!-- Buildings Grid -->
            <div class="col-lg-5">
                <div class="vit-card">
                    <div class="vit-card-header d-flex justify-content-between align-items-center">
                        <span><i class="bi bi-building me-2"></i>Campus Buildings (${buildings.size()})</span>
                    </div>
                    <div class="vit-card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Code</th>
                                        <th>Building Name</th>
                                        <th>Type</th>
                                        <th>Floors</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="b" items="${buildings}">
                                        <tr>
                                            <td><span class="badge bg-primary text-monospace">${b.code}</span></td>
                                            <td><span class="fw-bold text-dark">${b.name}</span></td>
                                            <td><span class="badge bg-secondary-subtle text-dark">${b.type}</span></td>
                                            <td>${b.totalFloors}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Locations List -->
            <div class="col-lg-7">
                <div class="vit-card">
                    <div class="vit-card-header d-flex justify-content-between align-items-center">
                        <span><i class="bi bi-geo-alt-fill me-2"></i>Mapped Campus Locations (${locations.size()})</span>
                    </div>
                    <div class="vit-card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>ID</th>
                                        <th>Building</th>
                                        <th>Room / Location Name</th>
                                        <th>Block / Floor</th>
                                        <th>Description</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty locations}">
                                            <tr>
                                                <td colspan="5" class="text-center py-4 text-muted">No locations created yet.</td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="loc" items="${locations}">
                                                <tr>
                                                    <td><span class="badge bg-secondary">#${loc.locationId}</span></td>
                                                    <td><span class="badge bg-info-subtle text-info-emphasis">${loc.buildingName}</span></td>
                                                    <td>
                                                        <div class="fw-bold text-dark">${loc.roomNumber} - ${loc.locationName}</div>
                                                    </td>
                                                    <td><small class="text-muted">Block ${loc.block != null ? loc.block : 'Main'} | Floor ${loc.floor}</small></td>
                                                    <td><small class="text-muted">${loc.description}</small></td>
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
        </div>
    </div>
</main>

<!-- Add Building Modal -->
<div class="modal fade" id="addBuildingModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form method="post" action="${pageContext.request.contextPath}/admin/locations">
                <input type="hidden" name="action" value="createBuilding">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title"><i class="bi bi-building-add me-2"></i>Create Campus Building</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Building Name *</label>
                        <input type="text" name="name" class="form-control" required placeholder="e.g. Technology Tower">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Building Code *</label>
                        <input type="text" name="code" class="form-control text-uppercase" required placeholder="e.g. TT">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Building Type *</label>
                        <select name="type" class="form-select" required>
                            <option value="ACADEMIC">ACADEMIC</option>
                            <option value="HOSTEL">HOSTEL</option>
                            <option value="MESS">MESS / FOOD PARK</option>
                            <option value="FACILITY">FACILITY / SPORTS</option>
                            <option value="OTHER">OTHER</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Total Floors *</label>
                        <input type="number" name="totalFloors" class="form-control" required min="1" value="5">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-vit-primary">Save Building</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Add Location Modal -->
<div class="modal fade" id="addLocationModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form method="post" action="${pageContext.request.contextPath}/admin/locations">
                <input type="hidden" name="action" value="createLocation">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title"><i class="bi bi-geo-fill me-2"></i>Create Specific Room / Location</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Building *</label>
                        <select name="buildingId" class="form-select" required>
                            <option value="">-- Select Building --</option>
                            <c:forEach var="b" items="${buildings}">
                                <option value="${b.buildingId}">${b.name} (${b.code})</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Block / Section</label>
                        <input type="text" name="block" class="form-control" placeholder="e.g. Block A or North Wing">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Floor Number *</label>
                        <input type="number" name="floor" class="form-control" required min="0" value="1">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Room / Spot Number *</label>
                        <input type="text" name="roomNumber" class="form-control" required placeholder="e.g. 204 or Lab-3">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Location Display Name</label>
                        <input type="text" name="locationName" class="form-control" placeholder="e.g. Computer Science Lab 2">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Description</label>
                        <textarea name="description" class="form-control" rows="2"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-vit-primary">Save Location</button>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/includes/footer.jsp" %>

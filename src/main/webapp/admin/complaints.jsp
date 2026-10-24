<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="All Complaints - SMART VIT" />
<%@ include file="/WEB-INF/includes/header.jsp" %>
<%@ include file="/WEB-INF/includes/navbar.jsp" %>

<main class="main-content">
    <div class="container py-4">
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 pb-2 border-bottom">
            <div>
                <h2 class="fw-bold mb-0"><i class="bi bi-list-ul me-2 text-primary"></i>All Campus Complaints</h2>
                <p class="text-muted small mb-0">Monitor, re-route, re-assign, and oversee resolution progress across all departments.</p>
            </div>
        </div>

        <%@ include file="/WEB-INF/includes/alerts.jsp" %>

        <!-- Comprehensive Filters -->
        <div class="vit-card mb-4">
            <div class="vit-card-body">
                <form method="get" action="${pageContext.request.contextPath}/admin/complaints" class="row g-3">
                    <div class="col-md-3">
                        <label class="form-label small fw-semibold">Search Keyword</label>
                        <input type="text" name="search" class="form-control" placeholder="Code, title, or complainant..." value="${search}">
                    </div>
                    <div class="col-md-2">
                        <label class="form-label small fw-semibold">Department</label>
                        <select name="department" class="form-select">
                            <option value="">All Departments</option>
                            <c:forEach var="d" items="${departments}">
                                <option value="${d.departmentId}" ${deptFilter == d.departmentId ? 'selected' : ''}>${d.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label small fw-semibold">Category</label>
                        <select name="category" class="form-select">
                            <option value="">All Categories</option>
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat.categoryId}" ${catFilter == cat.categoryId ? 'selected' : ''}>${cat.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label small fw-semibold">Status</label>
                        <select name="status" class="form-select">
                            <option value="">All Statuses</option>
                            <option value="SUBMITTED" ${statusFilter == 'SUBMITTED' ? 'selected' : ''}>SUBMITTED</option>
                            <option value="ASSIGNED" ${statusFilter == 'ASSIGNED' ? 'selected' : ''}>ASSIGNED</option>
                            <option value="ACKNOWLEDGED" ${statusFilter == 'ACKNOWLEDGED' ? 'selected' : ''}>ACKNOWLEDGED</option>
                            <option value="IN_PROGRESS" ${statusFilter == 'IN_PROGRESS' ? 'selected' : ''}>IN PROGRESS</option>
                            <option value="RESOLVED" ${statusFilter == 'RESOLVED' ? 'selected' : ''}>RESOLVED</option>
                            <option value="CLOSED" ${statusFilter == 'CLOSED' ? 'selected' : ''}>CLOSED</option>
                            <option value="REOPENED" ${statusFilter == 'REOPENED' ? 'selected' : ''}>REOPENED</option>
                            <option value="OVERDUE" ${statusFilter == 'OVERDUE' ? 'selected' : ''}>OVERDUE</option>
                        </select>
                    </div>
                    <div class="col-md-3 d-flex align-items-end gap-2">
                        <button type="submit" class="btn btn-primary flex-grow-1"><i class="bi bi-funnel me-1"></i> Filter</button>
                        <a href="${pageContext.request.contextPath}/admin/complaints" class="btn btn-outline-secondary"><i class="bi bi-arrow-counterclockwise"></i> Reset</a>
                    </div>
                </form>
            </div>
        </div>

        <!-- Complaints Table -->
        <div class="vit-card">
            <div class="vit-card-header d-flex justify-content-between align-items-center">
                <span><i class="bi bi-inbox-fill me-2"></i>Complaints Queue (${totalCount})</span>
                <span class="small text-muted">Page ${currentPage} of ${totalPages > 0 ? totalPages : 1}</span>
            </div>
            <div class="vit-card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Code</th>
                                <th>Title & Location</th>
                                <th>Complainant</th>
                                <th>Assigned Department</th>
                                <th>Priority</th>
                                <th>Status</th>
                                <th>Submitted Date</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty complaints}">
                                    <tr>
                                        <td colspan="8" class="text-center py-5 text-muted">
                                            <i class="bi bi-inbox fs-1 d-block mb-2"></i>
                                            No complaints found matching the criteria.
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="c" items="${complaints}">
                                        <tr>
                                            <td><span class="text-monospace fw-bold text-primary">${c.complaintCode}</span></td>
                                            <td>
                                                <div class="fw-semibold text-dark">${c.title}</div>
                                                <small class="text-muted"><i class="bi bi-geo-alt me-1"></i>${c.locationName} (${c.buildingName})</small>
                                            </td>
                                            <td>
                                                <div class="small fw-semibold">${c.complainantName}</div>
                                                <small class="text-muted">${c.complainantRegNo}</small>
                                            </td>
                                            <td>
                                                <span class="badge bg-secondary-subtle text-dark">${c.departmentName != null ? c.departmentName : 'Unassigned'}</span>
                                                <c:if test="${not empty c.assignedStaffName}">
                                                    <br><small class="text-muted"><i class="bi bi-person me-1"></i>${c.assignedStaffName}</small>
                                                </c:if>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${c.priority == 'URGENT'}"><span class="badge bg-danger">URGENT</span></c:when>
                                                    <c:when test="${c.priority == 'HIGH'}"><span class="badge bg-warning text-dark">HIGH</span></c:when>
                                                    <c:when test="${c.priority == 'MEDIUM'}"><span class="badge bg-info text-dark">MEDIUM</span></c:when>
                                                    <c:otherwise><span class="badge bg-secondary">LOW</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <span class="badge ${c.statusBadgeClass}">${c.status}</span>
                                                <c:if test="${c.overdue}">
                                                    <span class="badge bg-danger ms-1">OVERDUE</span>
                                                </c:if>
                                            </td>
                                            <td><small class="text-muted">${c.formattedCreatedAt}</small></td>
                                            <td>
                                                <div class="d-flex gap-1">
                                                    <a href="${pageContext.request.contextPath}/complaint/details?id=${c.complaintId}" class="btn btn-sm btn-outline-secondary">View</a>
                                                    <button type="button" class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#reassignModal${c.complaintId}">Reassign</button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
                <div class="vit-card-footer d-flex justify-content-center">
                    <nav>
                        <ul class="pagination mb-0">
                            <c:forEach var="p" begin="1" end="${totalPages}">
                                <li class="page-item ${p == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/complaints?page=${p}&search=${search}&department=${deptFilter}&category=${catFilter}&status=${statusFilter}">${p}</a>
                                </li>
                            </c:forEach>
                        </ul>
                    </nav>
                </div>
            </c:if>
        </div>
    </div>
</main>

<!-- Reassign Modals -->
<c:forEach var="c" items="${complaints}">
    <div class="modal fade" id="reassignModal${c.complaintId}" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <form method="post" action="${pageContext.request.contextPath}/admin/complaints">
                    <input type="hidden" name="action" value="reassign">
                    <input type="hidden" name="complaintId" value="${c.complaintId}">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title"><i class="bi bi-arrow-left-right me-2"></i>Reassign Complaint #${c.complaintCode}</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <p class="text-muted small">Re-route this complaint to another department or assign a specific technician.</p>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Target Department *</label>
                            <select name="departmentId" class="form-select" required>
                                <c:forEach var="d" items="${departments}">
                                    <option value="${d.departmentId}" ${c.departmentId == d.departmentId ? 'selected' : ''}>${d.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Assign Technician (Optional)</label>
                            <select name="staffId" class="form-select">
                                <option value="">-- Auto-Assign Available Staff --</option>
                                <c:forEach var="st" items="${staffList}">
                                    <option value="${st.staffId}">${st.staffName} (${st.departmentName} - ${st.designation})</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Reassignment Reason *</label>
                            <textarea name="reason" class="form-control" rows="2" required placeholder="State reason for manual reassignment..."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-vit-primary">Confirm Reassignment</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</c:forEach>

<%@ include file="/WEB-INF/includes/footer.jsp" %>


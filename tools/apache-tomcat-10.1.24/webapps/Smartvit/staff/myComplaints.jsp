<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="My Complaints - SMART VIT" />
<%@ include file="/WEB-INF/includes/header.jsp" %>
<%@ include file="/WEB-INF/includes/navbar.jsp" %>

<main class="main-content">
    <div class="container py-4">
        <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
            <div>
                <span class="badge bg-success-subtle text-success fw-bold text-uppercase small">Staff Portal</span>
                <h2 class="fw-bold mb-0">My Complaints</h2>
                <p class="text-muted small mb-0"><i class="bi bi-list-check me-1"></i> All complaints filed by you</p>
            </div>
            <a href="${pageContext.request.contextPath}/staff/raise-complaint" class="btn btn-vit-primary">
                <i class="bi bi-plus-circle me-1"></i> Raise New
            </a>
        </div>

        <%@ include file="/WEB-INF/includes/alerts.jsp" %>

        <!-- Filters -->
        <div class="vit-card mb-4">
            <div class="vit-card-body">
                <form method="get" class="row g-2 align-items-end">
                    <div class="col-md-3">
                        <label class="form-label fw-semibold small">Status</label>
                        <select name="status" class="form-select form-select-sm">
                            <option value="">All Statuses</option>
                            <option value="PENDING" ${param.status == 'PENDING' ? 'selected' : ''}>Pending</option>
                            <option value="IN_PROGRESS" ${param.status == 'IN_PROGRESS' ? 'selected' : ''}>In Progress</option>
                            <option value="RESOLVED" ${param.status == 'RESOLVED' ? 'selected' : ''}>Resolved</option>
                            <option value="CLOSED" ${param.status == 'CLOSED' ? 'selected' : ''}>Closed</option>
                            <option value="REOPENED" ${param.status == 'REOPENED' ? 'selected' : ''}>Reopened</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label fw-semibold small">Category</label>
                        <select name="categoryId" class="form-select form-select-sm">
                            <option value="">All Categories</option>
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat.id}" ${param.categoryId == cat.id ? 'selected' : ''}>${cat.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-semibold small">Search</label>
                        <input type="text" name="search" class="form-control form-control-sm" placeholder="Complaint ID or description..." value="${param.search}">
                    </div>
                    <div class="col-md-2 d-flex gap-2">
                        <button type="submit" class="btn btn-primary btn-sm w-100"><i class="bi bi-funnel me-1"></i>Filter</button>
                        <a href="${pageContext.request.contextPath}/staff/my-complaints" class="btn btn-outline-secondary btn-sm"><i class="bi bi-x"></i></a>
                    </div>
                </form>
            </div>
        </div>

        <!-- Complaints Table -->
        <div class="vit-card">
            <div class="vit-card-header d-flex justify-content-between align-items-center">
                <span><i class="bi bi-table me-2"></i>Complaints (${totalCount} found)</span>
            </div>
            <div class="vit-card-body p-0">
                <c:choose>
                    <c:when test="${empty complaints}">
                        <div class="text-center py-5 text-muted">
                            <i class="bi bi-inbox fs-1 d-block mb-3 opacity-50"></i>
                            <p class="fw-semibold">No complaints found.</p>
                            <a href="${pageContext.request.contextPath}/staff/raise-complaint" class="btn btn-vit-primary btn-sm">Raise Your First Complaint</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Complaint ID</th>
                                        <th>Category / Sub-category</th>
                                        <th>Location</th>
                                        <th>Priority</th>
                                        <th>Status</th>
                                        <th>Filed On</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="c" items="${complaints}">
                                    <tr>
                                        <td><span class="fw-semibold text-primary">${c.complaintId}</span></td>
                                        <td>
                                            <span class="fw-semibold">${c.categoryName}</span>
                                            <c:if test="${not empty c.subCategoryName}">
                                                <br><small class="text-muted">${c.subCategoryName}</small>
                                            </c:if>
                                        </td>
                                        <td><small>${c.locationName}</small></td>
                                        <td><span class="badge ${c.priorityBadgeClass}">${c.priority}</span></td>
                                        <td>
                                            <span class="badge ${c.statusBadgeClass}">${c.status}</span>
                                            <c:if test="${c.overdue}"><br><span class="badge bg-danger-subtle text-danger small">Overdue</span></c:if>
                                        </td>
                                        <td><small>${c.formattedCreatedAt}</small></td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/complaint-details?id=${c.id}" class="btn btn-sm btn-outline-primary">
                                                <i class="bi bi-eye me-1"></i>View
                                            </a>
                                        </td>
                                    </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination -->
                        <c:if test="${totalPages > 1}">
                        <nav class="p-3">
                            <ul class="pagination pagination-sm justify-content-center mb-0">
                                <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="?page=${currentPage-1}&status=${param.status}&categoryId=${param.categoryId}&search=${param.search}">Previous</a>
                                </li>
                                <c:forEach begin="1" end="${totalPages}" var="p">
                                <li class="page-item ${p == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="?page=${p}&status=${param.status}&categoryId=${param.categoryId}&search=${param.search}">${p}</a>
                                </li>
                                </c:forEach>
                                <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="?page=${currentPage+1}&status=${param.status}&categoryId=${param.categoryId}&search=${param.search}">Next</a>
                                </li>
                            </ul>
                        </nav>
                        </c:if>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</main>

<%@ include file="/WEB-INF/includes/footer.jsp" %>

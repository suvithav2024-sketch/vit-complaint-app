<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="My Complaints - SMART VIT" />
<%@ include file="/WEB-INF/includes/header.jsp" %>
<%@ include file="/WEB-INF/includes/navbar.jsp" %>

<main class="main-content">
    <div class="container py-4">
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 pb-2 border-bottom">
            <div>
                <span class="badge bg-primary-subtle text-primary fw-bold text-uppercase small">Tracking Center</span>
                <h2 class="fw-bold mb-0">My Lodged Complaints</h2>
            </div>
            <div class="mt-3 mt-md-0">
                <a href="${pageContext.request.contextPath}/student/raise-complaint" class="btn btn-vit-primary shadow-sm">
                    <i class="bi bi-plus-circle me-1"></i> Raise New Complaint
                </a>
            </div>
        </div>

        <%@ include file="/WEB-INF/includes/alerts.jsp" %>

        <!-- Filter Bar -->
        <div class="vit-card p-3 mb-4">
            <form action="${pageContext.request.contextPath}/student/my-complaints" method="get" class="row g-2 align-items-center">
                <div class="col-md-4">
                    <div class="input-group">
                        <span class="input-group-text bg-light"><i class="bi bi-search"></i></span>
                        <input type="text" name="search" class="form-control" placeholder="Search by ID, title, room..." value="${search}">
                    </div>
                </div>
                <div class="col-md-3">
                    <select name="status" class="form-select" onchange="this.form.submit()">
                        <option value="ALL">All Statuses</option>
                        <option value="SUBMITTED" ${statusFilter == 'SUBMITTED' ? 'selected' : ''}>Submitted</option>
                        <option value="ASSIGNED" ${statusFilter == 'ASSIGNED' ? 'selected' : ''}>Assigned</option>
                        <option value="IN_PROGRESS" ${statusFilter == 'IN_PROGRESS' ? 'selected' : ''}>In Progress</option>
                        <option value="RESOLVED" ${statusFilter == 'RESOLVED' ? 'selected' : ''}>Resolved</option>
                        <option value="CLOSED" ${statusFilter == 'CLOSED' ? 'selected' : ''}>Closed</option>
                        <option value="REOPENED" ${statusFilter == 'REOPENED' ? 'selected' : ''}>Reopened</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <select name="priority" class="form-select" onchange="this.form.submit()">
                        <option value="ALL">All Priorities</option>
                        <option value="URGENT" ${priorityFilter == 'URGENT' ? 'selected' : ''}>Urgent</option>
                        <option value="HIGH" ${priorityFilter == 'HIGH' ? 'selected' : ''}>High</option>
                        <option value="MEDIUM" ${priorityFilter == 'MEDIUM' ? 'selected' : ''}>Medium</option>
                        <option value="LOW" ${priorityFilter == 'LOW' ? 'selected' : ''}>Low</option>
                    </select>
                </div>
                <div class="col-md-2 d-flex gap-2">
                    <button type="submit" class="btn btn-outline-primary w-100">Filter</button>
                    <a href="${pageContext.request.contextPath}/student/my-complaints" class="btn btn-light" title="Reset Filters"><i class="bi bi-arrow-clockwise"></i></a>
                </div>
            </form>
        </div>

        <!-- Complaints Table -->
        <div class="vit-card">
            <div class="table-responsive">
                <table class="table table-hover table-vit mb-0 align-middle">
                    <thead>
                        <tr>
                            <th>Complaint ID</th>
                            <th>Issue & Category</th>
                            <th>Location</th>
                            <th>Assigned Department</th>
                            <th>Priority</th>
                            <th>Status</th>
                            <th>Filed On</th>
                            <th class="text-end">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty complaints}">
                                <tr>
                                    <td colspan="8" class="text-center py-5 text-muted">
                                        <i class="bi bi-inbox fs-1 d-block text-secondary mb-2"></i>
                                        No complaints found matching your filter criteria.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="c" items="${complaints}">
                                    <tr>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/student/complaint-details?id=${c.complaintId}" class="fw-bold font-monospace text-primary text-decoration-none">
                                                ${c.complaintCode}
                                            </a>
                                        </td>
                                        <td>
                                            <div class="fw-semibold text-truncate" style="max-width: 200px;">${c.title}</div>
                                            <small class="text-muted">${c.categoryName} &bull; ${c.subcategoryName}</small>
                                        </td>
                                        <td><small class="text-secondary">${c.locationDisplayName}</small></td>
                                        <td><span class="badge bg-light text-dark border">${c.departmentName}</span></td>
                                        <td><span class="badge ${c.priorityBadgeClass}">${c.priority}</span></td>
                                        <td>
                                            <span class="badge ${c.statusBadgeClass}">${c.status}</span>
                                            <c:if test="${c.overdue}">
                                                <span class="badge bg-danger ms-1" title="Overdue SLA"><i class="bi bi-exclamation-circle"></i> Overdue</span>
                                            </c:if>
                                        </td>
                                        <td><small class="text-muted">${c.createdAt.toString().substring(0, 16)}</small></td>
                                        <td class="text-end">
                                            <a href="${pageContext.request.contextPath}/student/complaint-details?id=${c.complaintId}" class="btn btn-outline-primary btn-sm">
                                                View <i class="bi bi-chevron-right"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
                <div class="p-3 border-top d-flex justify-content-between align-items-center">
                    <small class="text-muted">Showing page ${currentPage} of ${totalPages} (${totalCount} complaints)</small>
                    <nav>
                        <ul class="pagination pagination-sm mb-0">
                            <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage - 1}&status=${statusFilter}&priority=${priorityFilter}&search=${search}">Previous</a>
                            </li>
                            <c:forEach begin="1" end="${totalPages}" var="p">
                                <li class="page-item ${currentPage == p ? 'active' : ''}">
                                    <a class="page-link" href="?page=${p}&status=${statusFilter}&priority=${priorityFilter}&search=${search}">${p}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage + 1}&status=${statusFilter}&priority=${priorityFilter}&search=${search}">Next</a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </c:if>
        </div>
    </div>
</main>

<%@ include file="/WEB-INF/includes/footer.jsp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="User Management - SMART VIT" />
<%@ include file="/WEB-INF/includes/header.jsp" %>
<%@ include file="/WEB-INF/includes/navbar.jsp" %>

<main class="main-content">
    <div class="container py-4">
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 pb-2 border-bottom">
            <div>
                <h2 class="fw-bold mb-0"><i class="bi bi-people me-2 text-primary"></i>User Management</h2>
                <p class="text-muted small mb-0">Manage registered students, faculty staff, department technicians, and administrators.</p>
            </div>
            <div class="mt-3 mt-md-0">
                <button type="button" class="btn btn-vit-primary shadow-sm" data-bs-toggle="modal" data-bs-target="#addUserModal">
                    <i class="bi bi-person-plus me-1"></i> Add New User
                </button>
            </div>
        </div>

        <%@ include file="/WEB-INF/includes/alerts.jsp" %>

        <!-- Filter & Search Bar -->
        <div class="vit-card mb-4">
            <div class="vit-card-body">
                <form method="get" action="${pageContext.request.contextPath}/admin/users" class="row g-3">
                    <div class="col-md-5">
                        <div class="input-group">
                            <span class="input-group-text bg-light"><i class="bi bi-search"></i></span>
                            <input type="text" name="search" class="form-control" placeholder="Search by name, email, or Reg/Emp ID..." value="${search}">
                        </div>
                    </div>
                    <div class="col-md-4">
                        <select name="role" class="form-select">
                            <option value="">All User Roles</option>
                            <option value="STUDENT" ${roleFilter == 'STUDENT' ? 'selected' : ''}>Student</option>
                            <option value="FACULTY_STAFF" ${roleFilter == 'FACULTY_STAFF' ? 'selected' : ''}>Faculty / Staff</option>
                            <option value="DEPARTMENT_STAFF" ${roleFilter == 'DEPARTMENT_STAFF' ? 'selected' : ''}>Department Technician</option>
                            <option value="ADMIN" ${roleFilter == 'ADMIN' ? 'selected' : ''}>Administrator</option>
                        </select>
                    </div>
                    <div class="col-md-3 d-flex gap-2">
                        <button type="submit" class="btn btn-primary flex-grow-1"><i class="bi bi-funnel me-1"></i> Filter</button>
                        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-secondary"><i class="bi bi-arrow-counterclockwise"></i> Reset</a>
                    </div>
                </form>
            </div>
        </div>

        <!-- Users Table -->
        <div class="vit-card">
            <div class="vit-card-header d-flex justify-content-between align-items-center">
                <span><i class="bi bi-person-lines-fill me-2"></i>Users List (${totalCount})</span>
                <span class="small text-muted">Page ${currentPage} of ${totalPages > 0 ? totalPages : 1}</span>
            </div>
            <div class="vit-card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>User ID</th>
                                <th>Full Name</th>
                                <th>Reg / Emp No</th>
                                <th>Email</th>
                                <th>Role</th>
                                <th>School / Dept</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty users}">
                                    <tr>
                                        <td colspan="8" class="text-center py-5 text-muted">
                                            <i class="bi bi-person-x fs-1 d-block mb-2"></i>
                                            No matching users found.
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="u" items="${users}">
                                        <tr>
                                            <td>#${u.userId}</td>
                                            <td>
                                                <div class="fw-semibold">${u.fullName}</div>
                                                <c:if test="${not empty u.phone}"><small class="text-muted"><i class="bi bi-telephone me-1"></i>${u.phone}</small></c:if>
                                            </td>
                                            <td><span class="text-monospace fw-bold text-dark">${u.regEmpNo}</span></td>
                                            <td>${u.email}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${u.roleName == 'ADMIN'}"><span class="badge bg-danger">ADMIN</span></c:when>
                                                    <c:when test="${u.roleName == 'STUDENT'}"><span class="badge bg-primary">STUDENT</span></c:when>
                                                    <c:when test="${u.roleName == 'FACULTY_STAFF'}"><span class="badge bg-info text-dark">STAFF</span></c:when>
                                                    <c:otherwise><span class="badge bg-warning text-dark">DEPT STAFF</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td><small class="text-muted">${u.schoolDept != null ? u.schoolDept : 'N/A'}</small></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${u.active}"><span class="badge bg-success">Active</span></c:when>
                                                    <c:otherwise><span class="badge bg-secondary">Disabled</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <form method="post" action="${pageContext.request.contextPath}/admin/users" class="d-inline">
                                                    <input type="hidden" name="action" value="toggleStatus">
                                                    <input type="hidden" name="userId" value="${u.userId}">
                                                    <input type="hidden" name="active" value="${!u.active}">
                                                    <c:choose>
                                                        <c:when test="${u.active}">
                                                            <button type="submit" class="btn btn-sm btn-outline-danger" onclick="return confirm('Disable this user account?')">Disable</button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <button type="submit" class="btn btn-sm btn-outline-success">Enable</button>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </form>
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
                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/users?page=${p}&search=${search}&role=${roleFilter}">${p}</a>
                                </li>
                            </c:forEach>
                        </ul>
                    </nav>
                </div>
            </c:if>
        </div>
    </div>
</main>

<!-- Add User Modal -->
<div class="modal fade" id="addUserModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form method="post" action="${pageContext.request.contextPath}/admin/users">
                <input type="hidden" name="action" value="create">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title"><i class="bi bi-person-plus me-2"></i>Create New User Account</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Full Name *</label>
                            <input type="text" name="fullName" class="form-control" required placeholder="e.g. Dr. Ramesh Kumar">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">VIT Email *</label>
                            <input type="email" name="email" class="form-control" required placeholder="user@vit.ac.in">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Reg No / Employee ID *</label>
                            <input type="text" name="regEmpNo" class="form-control" required placeholder="e.g. 23BCE1001 or EMP2005">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Temporary Password *</label>
                            <input type="password" name="password" class="form-control" required minlength="6">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Role *</label>
                            <select name="roleId" class="form-select" required>
                                <option value="2">Student</option>
                                <option value="3">Faculty / Staff</option>
                                <option value="4">Department Staff / Technician</option>
                                <option value="1">Administrator</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Phone Number</label>
                            <input type="text" name="phone" class="form-control" placeholder="+91 9876543210">
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-semibold">School / Department</label>
                            <input type="text" name="schoolDept" class="form-control" placeholder="e.g. SCOPE, Electrical Maintenance, Hostel Office">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-vit-primary px-4">Create User</button>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/includes/footer.jsp" %>

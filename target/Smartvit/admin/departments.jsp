<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Departments & Staff - SMART VIT" />
<%@ include file="/WEB-INF/includes/header.jsp" %>
<%@ include file="/WEB-INF/includes/navbar.jsp" %>

<main class="main-content">
    <div class="container py-4">
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 pb-2 border-bottom">
            <div>
                <h2 class="fw-bold mb-0"><i class="bi bi-building me-2 text-primary"></i>Departments & Maintenance Staff</h2>
                <p class="text-muted small mb-0">Configure maintenance departments and assign technicians responsible for complaint resolution.</p>
            </div>
            <div class="mt-3 mt-md-0 d-flex gap-2">
                <button type="button" class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#addDeptModal">
                    <i class="bi bi-building-add me-1"></i> Add Department
                </button>
                <button type="button" class="btn btn-vit-primary shadow-sm" data-bs-toggle="modal" data-bs-target="#addStaffModal">
                    <i class="bi bi-person-badge me-1"></i> Assign Technician
                </button>
            </div>
        </div>

        <%@ include file="/WEB-INF/includes/alerts.jsp" %>

        <div class="row g-4">
            <!-- Departments List -->
            <div class="col-lg-6">
                <div class="vit-card">
                    <div class="vit-card-header d-flex justify-content-between align-items-center">
                        <span><i class="bi bi-building-gear me-2"></i>Campus Departments (${departments.size()})</span>
                    </div>
                    <div class="vit-card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Code</th>
                                        <th>Department Name</th>
                                        <th>Office Location</th>
                                        <th>Contact</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty departments}">
                                            <tr>
                                                <td colspan="4" class="text-center py-4 text-muted">No departments created yet.</td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="d" items="${departments}">
                                                <tr>
                                                    <td><span class="badge bg-primary text-monospace">${d.code}</span></td>
                                                    <td>
                                                        <div class="fw-bold text-dark">${d.name}</div>
                                                        <small class="text-muted">${d.description}</small>
                                                    </td>
                                                    <td><small>${d.officeLocation != null ? d.officeLocation : 'N/A'}</small></td>
                                                    <td>
                                                        <small class="d-block"><i class="bi bi-envelope me-1"></i>${d.contactEmail}</small>
                                                        <c:if test="${not empty d.contactPhone}">
                                                            <small class="text-muted"><i class="bi bi-telephone me-1"></i>${d.contactPhone}</small>
                                                        </c:if>
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
            </div>

            <!-- Technicians / Department Staff List -->
            <div class="col-lg-6">
                <div class="vit-card">
                    <div class="vit-card-header d-flex justify-content-between align-items-center">
                        <span><i class="bi bi-people-fill me-2"></i>Department Technicians & Staff (${staffList.size()})</span>
                    </div>
                    <div class="vit-card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Staff Name</th>
                                        <th>Department</th>
                                        <th>Designation</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty staffList}">
                                            <tr>
                                                <td colspan="4" class="text-center py-4 text-muted">No department staff assigned yet.</td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="s" items="${staffList}">
                                                <tr>
                                                    <td>
                                                        <div class="fw-bold text-dark">${s.staffName}</div>
                                                        <small class="text-muted"><i class="bi bi-envelope me-1"></i>${s.email}</small>
                                                    </td>
                                                    <td><span class="badge bg-info-subtle text-info-emphasis">${s.departmentName}</span></td>
                                                    <td>
                                                        <div class="small fw-semibold">${s.designation}</div>
                                                        <small class="text-muted">${s.specialization}</small>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${s.availabilityStatus == 'AVAILABLE'}"><span class="badge bg-success">Available</span></c:when>
                                                            <c:when test="${s.availabilityStatus == 'BUSY'}"><span class="badge bg-warning text-dark">Busy</span></c:when>
                                                            <c:otherwise><span class="badge bg-secondary">On Leave</span></c:otherwise>
                                                        </c:choose>
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
            </div>
        </div>
    </div>
</main>

<!-- Create Department Modal -->
<div class="modal fade" id="addDeptModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form method="post" action="${pageContext.request.contextPath}/admin/departments">
                <input type="hidden" name="action" value="createDepartment">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title"><i class="bi bi-building-add me-2"></i>Create New Department</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Department Name *</label>
                        <input type="text" name="name" class="form-control" required placeholder="e.g. Electrical Maintenance">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Department Code *</label>
                        <input type="text" name="code" class="form-control text-uppercase" required placeholder="e.g. ELEC">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Description</label>
                        <textarea name="description" class="form-control" rows="2" placeholder="Brief summary of department responsibilities"></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Contact Email *</label>
                        <input type="email" name="contactEmail" class="form-control" required placeholder="electrical@vit.ac.in">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Contact Phone</label>
                        <input type="text" name="contactPhone" class="form-control" placeholder="+91 9876543210">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Office Location</label>
                        <input type="text" name="officeLocation" class="form-control" placeholder="e.g. Main Building Ground Floor Block B">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-vit-primary">Save Department</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Assign Staff / Technician Modal -->
<div class="modal fade" id="addStaffModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form method="post" action="${pageContext.request.contextPath}/admin/departments">
                <input type="hidden" name="action" value="createStaff">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title"><i class="bi bi-person-badge me-2"></i>Assign User as Department Staff</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Select User Account *</label>
                        <select name="userId" class="form-select" required>
                            <option value="">-- Choose User --</option>
                            <c:forEach var="u" items="${potentialUsers}">
                                <option value="${u.userId}">${u.fullName} (${u.email})</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Department *</label>
                        <select name="departmentId" class="form-select" required>
                            <option value="">-- Choose Department --</option>
                            <c:forEach var="d" items="${departments}">
                                <option value="${d.departmentId}">${d.name} (${d.code})</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Designation *</label>
                        <input type="text" name="designation" class="form-control" required placeholder="e.g. Senior Electrician / Supervisor">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Specialization</label>
                        <input type="text" name="specialization" class="form-control" placeholder="e.g. High Voltage Wiring, AC Repair">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Official Phone</label>
                        <input type="text" name="phone" class="form-control" placeholder="+91 9876543210">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Official Email</label>
                        <input type="email" name="email" class="form-control" placeholder="staff@vit.ac.in">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Office Location</label>
                        <input type="text" name="officeLocation" class="form-control" placeholder="e.g. AB1 Room 102">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-vit-primary">Assign Staff</button>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/includes/footer.jsp" %>

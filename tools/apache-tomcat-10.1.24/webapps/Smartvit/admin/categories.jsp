<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Categories & Routing - SMART VIT" />
<%@ include file="/WEB-INF/includes/header.jsp" %>
<%@ include file="/WEB-INF/includes/navbar.jsp" %>

<main class="main-content">
    <div class="container py-4">
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 pb-2 border-bottom">
            <div>
                <h2 class="fw-bold mb-0"><i class="bi bi-tags me-2 text-primary"></i>Categories & Auto-Routing Rules</h2>
                <p class="text-muted small mb-0">Manage complaint categories, subcategories, and automatic department allocation rules.</p>
            </div>
            <div class="mt-3 mt-md-0 d-flex gap-2">
                <button type="button" class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#addCategoryModal">
                    <i class="bi bi-folder-plus me-1"></i> Add Category
                </button>
                <button type="button" class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="#addSubCategoryModal">
                    <i class="bi bi-tag-fill me-1"></i> Add Subcategory
                </button>
                <button type="button" class="btn btn-vit-primary shadow-sm" data-bs-toggle="modal" data-bs-target="#addMappingModal">
                    <i class="bi bi-signpost-split me-1"></i> Add Routing Rule
                </button>
            </div>
        </div>

        <%@ include file="/WEB-INF/includes/alerts.jsp" %>

        <!-- Auto-Routing Mappings Table -->
        <div class="vit-card mb-4">
            <div class="vit-card-header d-flex justify-content-between align-items-center">
                <span><i class="bi bi-diagram-3-fill me-2"></i>Active Auto-Routing Rules (${mappings.size()})</span>
            </div>
            <div class="vit-card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Category</th>
                                <th>Subcategory</th>
                                <th>Assigned Department</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty mappings}">
                                    <tr>
                                        <td colspan="4" class="text-center py-4 text-muted">No automatic routing rules configured yet.</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="m" items="${mappings}">
                                        <tr>
                                            <td><span class="fw-bold text-dark"><i class="bi bi-folder me-1 text-warning"></i>${m.categoryName}</span></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty m.subcategoryName}">
                                                        <span class="badge bg-secondary-subtle text-dark">${m.subcategoryName}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-info-subtle text-info-emphasis">ALL SUBCATEGORIES</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <span class="badge bg-primary fs-6 px-3 py-2"><i class="bi bi-building me-1"></i>${m.departmentName}</span>
                                            </td>
                                            <td>
                                                <form method="post" action="${pageContext.request.contextPath}/admin/categories" class="d-inline">
                                                    <input type="hidden" name="action" value="deleteMapping">
                                                    <input type="hidden" name="mappingId" value="${m.mappingId}">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger" onclick="return confirm('Remove this auto-routing rule?')">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
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
        </div>

        <div class="row g-4">
            <!-- Categories List -->
            <div class="col-lg-6">
                <div class="vit-card">
                    <div class="vit-card-header d-flex justify-content-between align-items-center">
                        <span><i class="bi bi-folder-fill me-2"></i>Complaint Categories (${categories.size()})</span>
                    </div>
                    <div class="vit-card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Code</th>
                                        <th>Icon</th>
                                        <th>Category Name</th>
                                        <th>Description</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="c" items="${categories}">
                                        <tr>
                                            <td><span class="badge bg-secondary text-monospace">${c.code}</span></td>
                                            <td><i class="bi ${c.icon} fs-5 text-primary"></i></td>
                                            <td><span class="fw-bold text-dark">${c.name}</span></td>
                                            <td><small class="text-muted">${c.description}</small></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Subcategories List -->
            <div class="col-lg-6">
                <div class="vit-card">
                    <div class="vit-card-header d-flex justify-content-between align-items-center">
                        <span><i class="bi bi-tags-fill me-2"></i>Subcategories (${subcategories.size()})</span>
                    </div>
                    <div class="vit-card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Category</th>
                                        <th>Subcategory Name</th>
                                        <th>Default Priority</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="sc" items="${subcategories}">
                                        <tr>
                                            <td><small class="fw-semibold text-muted">${sc.categoryName}</small></td>
                                            <td><span class="fw-bold text-dark">${sc.name}</span></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${sc.defaultPriority == 'URGENT'}"><span class="badge bg-danger">URGENT</span></c:when>
                                                    <c:when test="${sc.defaultPriority == 'HIGH'}"><span class="badge bg-warning text-dark">HIGH</span></c:when>
                                                    <c:when test="${sc.defaultPriority == 'MEDIUM'}"><span class="badge bg-info text-dark">MEDIUM</span></c:when>
                                                    <c:otherwise><span class="badge bg-secondary">LOW</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Create Category Modal -->
<div class="modal fade" id="addCategoryModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form method="post" action="${pageContext.request.contextPath}/admin/categories">
                <input type="hidden" name="action" value="createCategory">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title"><i class="bi bi-folder-plus me-2"></i>Create Category</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Category Name *</label>
                        <input type="text" name="name" class="form-control" required placeholder="e.g. Electrical">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Category Code *</label>
                        <input type="text" name="code" class="form-control text-uppercase" required placeholder="e.g. ELEC">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Bootstrap Icon Class</label>
                        <input type="text" name="icon" class="form-control" placeholder="e.g. bi-lightning-charge">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Description</label>
                        <textarea name="description" class="form-control" rows="2"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-vit-primary">Save Category</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Create Subcategory Modal -->
<div class="modal fade" id="addSubCategoryModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form method="post" action="${pageContext.request.contextPath}/admin/categories">
                <input type="hidden" name="action" value="createSubCategory">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title"><i class="bi bi-tag-fill me-2"></i>Create Subcategory</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Parent Category *</label>
                        <select name="categoryId" class="form-select" required>
                            <option value="">-- Choose Category --</option>
                            <c:forEach var="c" items="${categories}">
                                <option value="${c.categoryId}">${c.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Subcategory Name *</label>
                        <input type="text" name="name" class="form-control" required placeholder="e.g. Fan Not Working">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Default Priority *</label>
                        <select name="defaultPriority" class="form-select" required>
                            <option value="LOW">LOW (72 Hours)</option>
                            <option value="MEDIUM" selected>MEDIUM (48 Hours)</option>
                            <option value="HIGH">HIGH (24 Hours)</option>
                            <option value="URGENT">URGENT (4 Hours)</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Description</label>
                        <textarea name="description" class="form-control" rows="2"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-vit-primary">Save Subcategory</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Create Mapping Modal -->
<div class="modal fade" id="addMappingModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form method="post" action="${pageContext.request.contextPath}/admin/categories">
                <input type="hidden" name="action" value="createMapping">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title"><i class="bi bi-signpost-split me-2"></i>Add Auto-Routing Rule</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Category *</label>
                        <select name="categoryId" class="form-select" required>
                            <option value="">-- Choose Category --</option>
                            <c:forEach var="c" items="${categories}">
                                <option value="${c.categoryId}">${c.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Subcategory (Optional)</label>
                        <select name="subcategoryId" class="form-select">
                            <option value="ALL">-- Applies to All Subcategories --</option>
                            <c:forEach var="sc" items="${subcategories}">
                                <option value="${sc.subcategoryId}">${sc.categoryName} &gt; ${sc.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Target Department *</label>
                        <select name="departmentId" class="form-select" required>
                            <option value="">-- Route to Department --</option>
                            <c:forEach var="d" items="${departments}">
                                <option value="${d.departmentId}">${d.name} (${d.code})</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-vit-primary">Save Routing Rule</button>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/includes/footer.jsp" %>

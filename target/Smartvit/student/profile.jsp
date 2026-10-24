<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="My Profile - SMART VIT" />
<%@ include file="/WEB-INF/includes/header.jsp" %>
<%@ include file="/WEB-INF/includes/navbar.jsp" %>

<main class="main-content">
    <div class="container py-4">
        <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
            <div>
                <span class="badge bg-primary-subtle text-primary fw-bold text-uppercase small">My Account</span>
                <h2 class="fw-bold mb-0">Profile Settings</h2>
                <p class="text-muted small mb-0"><i class="bi bi-person-gear me-1"></i> Manage your personal information and password</p>
            </div>
        </div>

        <%@ include file="/WEB-INF/includes/alerts.jsp" %>

        <div class="row g-4">
            <!-- Profile Info Card -->
            <div class="col-lg-4">
                <div class="vit-card text-center p-4">
                    <div class="mb-3">
                        <i class="bi bi-person-circle text-primary" style="font-size:5rem;"></i>
                    </div>
                    <h5 class="fw-bold mb-1">${user.fullName}</h5>
                    <p class="text-muted small mb-2">${user.email}</p>
                    <span class="badge bg-primary-subtle text-primary px-3 py-2 fs-6">${user.role}</span>
                    <hr>
                    <div class="text-start small">
                        <div class="mb-2"><i class="bi bi-hash text-muted me-2"></i><strong>Reg/Emp No:</strong> ${user.registrationOrEmployeeNo}</div>
                        <div class="mb-2"><i class="bi bi-telephone text-muted me-2"></i><strong>Phone:</strong> ${empty user.phoneNumber ? 'Not set' : user.phoneNumber}</div>
                        <c:if test="${not empty user.hostelBlock}">
                        <div class="mb-2"><i class="bi bi-building text-muted me-2"></i><strong>Hostel Block:</strong> ${user.hostelBlock}</div>
                        </c:if>
                        <div class="mb-2"><i class="bi bi-calendar3 text-muted me-2"></i><strong>Member Since:</strong> ${user.formattedCreatedAt}</div>
                    </div>
                </div>
            </div>

            <!-- Forms -->
            <div class="col-lg-8">
                <!-- Update Profile -->
                <div class="vit-card mb-4">
                    <div class="vit-card-header">
                        <i class="bi bi-person-lines-fill me-2"></i> Update Profile Information
                    </div>
                    <div class="vit-card-body">
                        <form action="${pageContext.request.contextPath}/${sessionScope.currentUser.student ? 'student' : 'staff'}/profile" method="post">
                            <input type="hidden" name="action" value="updateProfile">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Full Name <span class="text-danger">*</span></label>
                                    <input type="text" name="fullName" class="form-control" value="${user.fullName}" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Email Address</label>
                                    <input type="email" class="form-control bg-light" value="${user.email}" readonly>
                                    <div class="form-text">Email cannot be changed.</div>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Phone Number</label>
                                    <input type="tel" name="phoneNumber" class="form-control" value="${user.phoneNumber}" placeholder="e.g. 9876543210">
                                </div>
                                <c:if test="${sessionScope.currentUser.student}">
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Hostel Block</label>
                                    <select name="hostelBlock" class="form-select">
                                        <option value="">-- Day Scholar / Off-Campus --</option>
                                        <c:forEach var="block" items="${hostelBlocks}">
                                            <option value="${block}" ${user.hostelBlock == block ? 'selected' : ''}>${block}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                </c:if>
                                <div class="col-12 text-end">
                                    <button type="submit" class="btn btn-vit-primary px-4">
                                        <i class="bi bi-save me-1"></i> Save Changes
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Change Password -->
                <div class="vit-card">
                    <div class="vit-card-header">
                        <i class="bi bi-shield-lock me-2"></i> Change Password
                    </div>
                    <div class="vit-card-body">
                        <form action="${pageContext.request.contextPath}/${sessionScope.currentUser.student ? 'student' : 'staff'}/profile" method="post" id="pwdForm">
                            <input type="hidden" name="action" value="changePassword">
                            <div class="row g-3">
                                <div class="col-md-12">
                                    <label class="form-label fw-semibold">Current Password <span class="text-danger">*</span></label>
                                    <input type="password" name="currentPassword" class="form-control" required autocomplete="current-password">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">New Password <span class="text-danger">*</span></label>
                                    <input type="password" name="newPassword" id="newPassword" class="form-control" required minlength="8" autocomplete="new-password">
                                    <div class="form-text">Minimum 8 characters.</div>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Confirm New Password <span class="text-danger">*</span></label>
                                    <input type="password" name="confirmPassword" id="confirmPassword" class="form-control" required autocomplete="new-password">
                                </div>
                                <div class="col-12 text-end">
                                    <button type="submit" class="btn btn-outline-danger px-4">
                                        <i class="bi bi-key me-1"></i> Update Password
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<script>
document.getElementById('pwdForm').addEventListener('submit', function(e) {
    const np = document.getElementById('newPassword').value;
    const cp = document.getElementById('confirmPassword').value;
    if (np !== cp) {
        e.preventDefault();
        alert('New passwords do not match!');
    }
});
</script>

<%@ include file="/WEB-INF/includes/footer.jsp" %>

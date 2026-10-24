<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Register Account - SMART VIT" />
<%@ include file="/WEB-INF/includes/header.jsp" %>
<%@ include file="/WEB-INF/includes/navbar.jsp" %>

<main class="main-content">
    <div class="container py-4">
        <div class="row justify-content-center">
            <div class="col-lg-7 col-md-9">
                <div class="vit-card shadow-sm p-4 p-md-5">
                    <div class="text-center mb-4">
                        <div class="rounded-circle bg-navy d-inline-flex p-3 text-warning mb-2" style="background-color: var(--vit-navy);">
                            <i class="bi bi-person-plus fs-2"></i>
                        </div>
                        <h3 class="fw-bold mb-1">Create Your Account</h3>
                        <p class="text-muted small">Register as an authorized VIT student or university staff member</p>
                    </div>

                    <%@ include file="/WEB-INF/includes/alerts.jsp" %>

                    <form action="${pageContext.request.contextPath}/register" method="post" id="regForm">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label for="fullName" class="form-label fw-semibold small text-uppercase">Full Name *</label>
                                <input type="text" class="form-control" id="fullName" name="fullName" value="${fullName}" placeholder="e.g. Rohit Sharma" required>
                            </div>

                            <div class="col-md-6">
                                <label for="roleType" class="form-label fw-semibold small text-uppercase">Account Type *</label>
                                <select class="form-select" id="roleType" name="roleType" required onchange="toggleHostelFields()">
                                    <option value="STUDENT" ${roleType == 'STUDENT' || empty roleType ? 'selected' : ''}>Student</option>
                                    <option value="STAFF" ${roleType == 'STAFF' ? 'selected' : ''}>Faculty / Staff</option>
                                </select>
                            </div>

                            <div class="col-md-6">
                                <label for="email" class="form-label fw-semibold small text-uppercase">VIT Email Address *</label>
                                <input type="email" class="form-control" id="email" name="email" value="${email}" placeholder="username@vit.ac.in" required>
                            </div>

                            <div class="col-md-6">
                                <label for="regEmpNo" class="form-label fw-semibold small text-uppercase" id="regEmpLabel">Register Number *</label>
                                <input type="text" class="form-control text-uppercase" id="regEmpNo" name="regEmpNo" value="${regEmpNo}" placeholder="e.g. 23BCE0000" required>
                            </div>

                            <div class="col-md-6">
                                <label for="phone" class="form-label fw-semibold small text-uppercase">Phone Number</label>
                                <input type="tel" class="form-control" id="phone" name="phone" value="${phone}" placeholder="10-digit mobile number">
                            </div>

                            <div class="col-md-6">
                                <label for="schoolDept" class="form-label fw-semibold small text-uppercase">School / Department</label>
                                <input type="text" class="form-control" id="schoolDept" name="schoolDept" value="${schoolDept}" placeholder="e.g. SCOPE / SENSE">
                            </div>

                            <div class="col-md-6 hostel-field">
                                <label for="hostelBlock" class="form-label fw-semibold small text-uppercase">Hostel Block</label>
                                <input type="text" class="form-control" id="hostelBlock" name="hostelBlock" value="${hostelBlock}" placeholder="e.g. Hostel Block A">
                            </div>

                            <div class="col-md-6 hostel-field">
                                <label for="roomNo" class="form-label fw-semibold small text-uppercase">Room Number</label>
                                <input type="text" class="form-control" id="roomNo" name="roomNo" value="${roomNo}" placeholder="e.g. A-204">
                            </div>

                            <div class="col-md-6">
                                <label for="password" class="form-label fw-semibold small text-uppercase">Password *</label>
                                <input type="password" class="form-control" id="password" name="password" placeholder="At least 6 characters" minlength="6" required>
                            </div>

                            <div class="col-md-6">
                                <label for="confirmPassword" class="form-label fw-semibold small text-uppercase">Confirm Password *</label>
                                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="Repeat password" minlength="6" required>
                            </div>
                        </div>

                        <div class="mt-4">
                            <button type="submit" class="btn btn-vit-primary w-100 py-2 fw-semibold">
                                <i class="bi bi-person-check me-1"></i> Register Account
                            </button>
                        </div>
                    </form>

                    <div class="text-center small text-muted mt-3">
                        Already have an account? <a href="${pageContext.request.contextPath}/login" class="fw-semibold text-primary">Login here</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<script>
function toggleHostelFields() {
    const role = document.getElementById('roleType').value;
    const label = document.getElementById('regEmpLabel');
    const hostelFields = document.querySelectorAll('.hostel-field');

    if (role === 'STAFF') {
        label.textContent = 'Employee ID *';
        document.getElementById('regEmpNo').placeholder = 'e.g. EMP1001';
        hostelFields.forEach(f => f.style.display = 'none');
    } else {
        label.textContent = 'Register Number *';
        document.getElementById('regEmpNo').placeholder = 'e.g. 23BCE0000';
        hostelFields.forEach(f => f.style.display = 'block');
    }
}
document.addEventListener('DOMContentLoaded', toggleHostelFields);
</script>

<%@ include file="/WEB-INF/includes/footer.jsp" %>

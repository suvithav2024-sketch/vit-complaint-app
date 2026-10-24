<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Portal Login - SMART VIT" />
<%@ include file="/WEB-INF/includes/header.jsp" %>
<%@ include file="/WEB-INF/includes/navbar.jsp" %>

<main class="main-content d-flex align-items-center">
    <div class="container py-4">
        <div class="row justify-content-center">
            <div class="col-lg-5 col-md-7">
                <div class="vit-card shadow-sm p-4 p-md-5">
                    <div class="text-center mb-4">
                        <div class="rounded-circle bg-navy d-inline-flex p-3 text-warning mb-2" style="background-color: var(--vit-navy);">
                            <i class="bi bi-person-badge fs-2"></i>
                        </div>
                        <h3 class="fw-bold mb-1">Campus Portal Login</h3>
                        <p class="text-muted small">Sign in with your VIT Email or Register/Employee ID</p>
                    </div>

                    <%@ include file="/WEB-INF/includes/alerts.jsp" %>

                    <c:if test="${param.logout == 'true'}">
                        <div class="alert alert-info py-2 small mb-3">
                            <i class="bi bi-info-circle me-1"></i> You have been safely logged out.
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/login" method="post">
                        <c:if test="${not empty returnUrl || not empty param.returnUrl}">
                            <input type="hidden" name="returnUrl" value="${not empty returnUrl ? returnUrl : param.returnUrl}">
                        </c:if>

                        <div class="mb-3">
                            <label for="identifier" class="form-label fw-semibold small text-uppercase">VIT Email or Register / Emp ID</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-envelope-at"></i></span>
                                <input type="text" class="form-control" id="identifier" name="identifier" value="${identifier}" placeholder="e.g. student@vit.ac.in or 23BCE0000" required autofocus>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="password" class="form-label fw-semibold small text-uppercase">Password</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-lock"></i></span>
                                <input type="password" class="form-control" id="password" name="password" placeholder="Enter your password" required>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-vit-primary w-100 py-2 fw-semibold mb-3">
                            <i class="bi bi-box-arrow-in-right me-1"></i> Sign In to Portal
                        </button>
                    </form>

                    <div class="text-center small text-muted mb-4">
                        Don't have an account yet? <a href="${pageContext.request.contextPath}/register" class="fw-semibold text-primary">Register Here</a>
                    </div>

                    <!-- Demo Credentials Helper Box -->
                    <div class="p-3 bg-light border rounded-3 small">
                        <div class="fw-bold text-navy mb-2 d-flex align-items-center gap-1">
                            <i class="bi bi-key-fill text-warning"></i> Demo Accounts (Pre-configured):
                        </div>
                        <div class="row g-2 text-muted">
                            <div class="col-12">
                                <strong>Student:</strong> <code>student@vit.ac.in</code> / <code>Student@123</code>
                                <button type="button" class="btn btn-link btn-sm p-0 ms-2" onclick="fillLogin('student@vit.ac.in', 'Student@123')">Autofill</button>
                            </div>
                            <div class="col-12">
                                <strong>Staff:</strong> <code>staff@vit.ac.in</code> / <code>Staff@123</code>
                                <button type="button" class="btn btn-link btn-sm p-0 ms-2" onclick="fillLogin('staff@vit.ac.in', 'Staff@123')">Autofill</button>
                            </div>
                            <div class="col-12">
                                <strong>Hostel Dept:</strong> <code>hostel@vit.ac.in</code> / <code>Dept@123</code>
                                <button type="button" class="btn btn-link btn-sm p-0 ms-2" onclick="fillLogin('hostel@vit.ac.in', 'Dept@123')">Autofill</button>
                            </div>
                            <div class="col-12">
                                <strong>Electrical Dept:</strong> <code>electrical@vit.ac.in</code> / <code>Dept@123</code>
                                <button type="button" class="btn btn-link btn-sm p-0 ms-2" onclick="fillLogin('electrical@vit.ac.in', 'Dept@123')">Autofill</button>
                            </div>
                            <div class="col-12">
                                <strong>Admin:</strong> <code>admin@vit.ac.in</code> / <code>Admin@123</code>
                                <button type="button" class="btn btn-link btn-sm p-0 ms-2" onclick="fillLogin('admin@vit.ac.in', 'Admin@123')">Autofill</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<script>
function fillLogin(ident, pass) {
    document.getElementById('identifier').value = ident;
    document.getElementById('password').value = pass;
}
</script>

<%@ include file="/WEB-INF/includes/footer.jsp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Privacy Policy - SMART VIT" />
<%@ include file="/WEB-INF/includes/header.jsp" %>
<%@ include file="/WEB-INF/includes/navbar.jsp" %>

<main class="main-content">
    <div class="container py-4">
        <div class="row justify-content-center">
            <div class="col-lg-9">
                <div class="vit-card p-4 p-md-5">
                    <div class="border-bottom pb-3 mb-4">
                        <span class="badge bg-warning text-dark px-3 py-1 fw-bold mb-2">Campus Data Protection</span>
                        <h2 class="fw-bold mb-1">SMART VIT Privacy Policy</h2>
                        <p class="text-muted small mb-0">Effective Date: September 2026 | Student Complaint Management System</p>
                    </div>

                    <div class="content">
                        <h5 class="fw-bold text-navy mb-3"><i class="bi bi-shield-check text-warning me-2"></i>1. Overview & Institutional Commitment</h5>
                        <p class="text-muted">
                            SMART VIT (Student Complaint Management System) is an internal university web application committed to protecting the privacy of students, faculty members, and maintenance staff. This policy outlines our standards regarding data collection, authorized usage, access limitation, and account safeguards.
                        </p>

                        <h5 class="fw-bold text-navy mb-3 mt-4"><i class="bi bi-file-earmark-lock text-warning me-2"></i>2. Information We Collect</h5>
                        <p class="text-muted">To facilitate maintenance workflows and complaint resolution, the portal stores:</p>
                        <ul class="text-muted small">
                            <li><strong>Identity Information:</strong> Full name, institutional VIT email address, university registration number or employee ID.</li>
                            <li><strong>Residential / Campus Context:</strong> Hostel block, room number, academic department, or school affiliation.</li>
                            <li><strong>Complaint Data:</strong> Issue category, subcategory, exact campus room/location, problem descriptions, and user-provided image attachments.</li>
                            <li><strong>System Telemetry & Audit:</strong> Timestamps of status changes, login events, and client IP addresses for security auditing.</li>
                        </ul>

                        <h5 class="fw-bold text-navy mb-3 mt-4"><i class="bi bi-eye-slash text-warning me-2"></i>3. Role-Based Access & Data Minimization</h5>
                        <p class="text-muted">
                            SMART VIT enforces strict Role-Based Access Control (RBAC):
                        </p>
                        <ul class="text-muted small">
                            <li><strong>Personal Privacy:</strong> Students and staff can only access complaints they have personally raised.</li>
                            <li><strong>Department Isolation:</strong> Maintenance staff only access complaints specifically allocated to their assigned department (e.g. Electrical staff cannot view Mess or Transport issues).</li>
                            <li><strong>Contact Protection:</strong> Personal phone numbers and email addresses are hidden from public views and only displayed where authorized for field technicians to contact complainants directly.</li>
                        </ul>

                        <h5 class="fw-bold text-navy mb-3 mt-4"><i class="bi bi-key text-warning me-2"></i>4. Passwords & Technical Security</h5>
                        <p class="text-muted small">
                            All user passwords are encrypted using one-way adaptive cryptographic hashing (BCrypt with salt factor 10). The database never stores plaintext passwords. Queries use parameterized SQL PreparedStatements to guard against injection attacks.
                        </p>

                        <h5 class="fw-bold text-navy mb-3 mt-4"><i class="bi bi-info-circle text-warning me-2"></i>5. Regulatory Clarification</h5>
                        <p class="text-muted small">
                            This application is designed with privacy-by-design principles for academic operational tracking. It does not claim formal third-party regulatory GDPR certification, as regulations require legal organizational audit, but adheres to data protection best practices.
                        </p>

                        <div class="mt-4 pt-3 border-top d-flex justify-content-between align-items-center">
                            <span class="small text-muted">Questions? Contact <a href="mailto:privacy@vit.ac.in">privacy@vit.ac.in</a></span>
                            <a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary btn-sm"><i class="bi bi-arrow-left me-1"></i> Return Home</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<%@ include file="/WEB-INF/includes/footer.jsp" %>

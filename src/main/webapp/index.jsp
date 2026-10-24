
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="SMART VIT - Student Complaint Management System" />
<%@ include file="/WEB-INF/includes/header.jsp" %>
<%@ include file="/WEB-INF/includes/navbar.jsp" %>

<!-- Hero Banner -->
<header class="vit-hero">
    <div class="container">
        <div class="row align-items-center gy-4">
            <div class="col-lg-7">
                <span class="badge bg-warning text-dark px-3 py-2 rounded-pill fw-bold mb-3">
                    <i class="bi bi-shield-check me-1"></i> Official Institutional Grievance Portal
                </span>

                <h1 class="display-4 fw-bold text-white mb-3">
                    SMART VIT <br>
                    <span class="text-warning">Complaint Management System</span>
                </h1>

                <p class="lead text-light-50 mb-4">
                    "Raise. Track. Resolve." An intelligent, transparent, and database-driven campus maintenance portal ensuring prompt resolution of academic, residential, and infrastructural concerns.
                </p>

                <div class="d-flex flex-wrap gap-3">
                    <c:choose>
                        <c:when test="${sessionScope.currentUser != null}">
                            <a href="${pageContext.request.contextPath}/${sessionScope.currentUser.student ? 'student/dashboard' : sessionScope.currentUser.staff ? 'staff/dashboard' : sessionScope.currentUser.departmentStaff ? 'department/dashboard' : 'admin/dashboard'}"
                               class="btn btn-warning btn-lg px-4 fw-bold shadow">
                                <i class="bi bi-speedometer2 me-2"></i> Go to Dashboard
                            </a>

                            <a href="${pageContext.request.contextPath}/student/raise-complaint"
                               class="btn btn-outline-light btn-lg px-4">
                                <i class="bi bi-plus-circle me-2"></i> Raise Complaint
                            </a>
                        </c:when>

                        <c:otherwise>
                            <!-- Student / Staff Login -->
                            <a href="${pageContext.request.contextPath}/login"
                               class="btn btn-warning btn-lg px-4 fw-bold shadow">
                                <i class="bi bi-box-arrow-in-right me-2"></i> Student / Staff Login
                            </a>

                            <!-- NEW: Admin Login -->
                            <a href="${pageContext.request.contextPath}/login?role=admin"
                               class="btn btn-outline-warning btn-lg px-4 fw-bold">
                                <i class="bi bi-shield-lock me-2"></i> Admin Login
                            </a>

                            <!-- Register -->
                            <a href="${pageContext.request.contextPath}/register"
                               class="btn btn-outline-light btn-lg px-4">
                                <i class="bi bi-person-plus me-2"></i> Register Account
                            </a>
                        </c:otherwise>
                    </c:choose>

                    <button type="button"
                            class="btn btn-info text-dark btn-lg px-4 fw-bold"
                            data-bs-toggle="modal"
                            data-bs-target="#qrScanModal">
                        <i class="bi bi-qr-code-scan me-2"></i> Scan Room QR Code
                    </button>
                </div>
            </div>

            <div class="col-lg-5">
                <!-- Quick Track Card -->
                <div class="card shadow-lg border-0 rounded-4 p-4 text-dark bg-white" id="track">
                    <div class="d-flex align-items-center gap-2 mb-3 text-primary">
                        <i class="bi bi-geo-alt-fill fs-3 text-warning"></i>
                        <h4 class="mb-0 fw-bold text-dark">Track Your Complaint</h4>
                    </div>

                    <p class="small text-muted mb-3">
                        Enter your unique Complaint Reference Number (e.g.
                        <code>CMP-2026-00001</code>) to track current progress in real time.
                    </p>

                    <div class="input-group mb-3">
                        <span class="input-group-text bg-light">
                            <i class="bi bi-search"></i>
                        </span>
                        <input type="text"
                               id="trackComplaintInput"
                               class="form-control form-control-lg text-uppercase"
                               placeholder="CMP-2026-XXXXX">
                        <button class="btn btn-vit-primary px-3"
                                type="button"
                                id="trackComplaintBtn">Track</button>
                    </div>

                    <div id="trackResultArea"></div>
                </div>
            </div>
        </div>
    </div>
</header>

<main class="main-content">
    <div class="container py-4">
        <%@ include file="/WEB-INF/includes/alerts.jsp" %>

        <!-- Core Process Workflow -->
        <section class="mb-5">
            <div class="text-center mb-5">
                <span class="text-warning fw-bold text-uppercase tracking-wide small">Fast & Efficient</span>
                <h2 class="fw-bold">How SMART VIT Works</h2>
                <p class="text-muted">
                    A seamless 4-step workflow connecting students directly with responsible departments.
                </p>
            </div>

            <div class="row g-4">
                <div class="col-md-3">
                    <div class="vit-card p-4 text-center h-100">
                        <div class="rounded-circle bg-primary bg-opacity-10 text-primary d-inline-flex p-3 mb-3 fs-3">
                            <i class="bi bi-qr-code-scan"></i>
                        </div>
                        <h5 class="fw-bold">1. Scan Room QR</h5>
                        <p class="small text-muted mb-0">
                            Scan the QR code pasted on classroom or hostel doors to automatically detect building, floor, and room number.
                        </p>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="vit-card p-4 text-center h-100">
                        <div class="rounded-circle bg-warning bg-opacity-10 text-warning d-inline-flex p-3 mb-3 fs-3">
                            <i class="bi bi-pencil-square"></i>
                        </div>
                        <h5 class="fw-bold">2. Submit Issue</h5>
                        <p class="small text-muted mb-0">
                            Select the issue category, set urgency priority, add an explanation, and attach an optional photo.
                        </p>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="vit-card p-4 text-center h-100">
                        <div class="rounded-circle bg-info bg-opacity-10 text-info d-inline-flex p-3 mb-3 fs-3">
                            <i class="bi bi-diagram-3-fill"></i>
                        </div>
                        <h5 class="fw-bold">3. Auto Allocation</h5>
                        <p class="small text-muted mb-0">
                            The database router automatically allocates the complaint to the right maintenance team and technician.
                        </p>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="vit-card p-4 text-center h-100">
                        <div class="rounded-circle bg-success bg-opacity-10 text-success d-inline-flex p-3 mb-3 fs-3">
                            <i class="bi bi-check2-circle"></i>
                        </div>
                        <h5 class="fw-bold">4. Resolve & Confirm</h5>
                        <p class="small text-muted mb-0">
                            Technicians resolve the issue with proof. The student confirms satisfaction or reopens if unresolved.
                        </p>
                    </div>
                </div>
            </div>
        </section>

        <!-- Complaint Categories Showcase -->
        <section class="mb-5">
            <div class="text-center mb-5">
                <span class="text-warning fw-bold text-uppercase tracking-wide small">Campus Wide Coverage</span>
                <h2 class="fw-bold">Categories Handled</h2>
                <p class="text-muted">
                    Comprehensive maintenance across academic, hostel, and campus infrastructure.
                </p>
            </div>

            <div class="row g-3">
                <div class="col-6 col-md-3">
                    <div class="vit-card p-3 d-flex align-items-center gap-3">
                        <div class="fs-2 text-primary"><i class="bi bi-easel"></i></div>
                        <div>
                            <h6 class="mb-0 fw-bold">Classroom</h6>
                            <small class="text-muted">Lights, AC, Projectors</small>
                        </div>
                    </div>
                </div>

                <div class="col-6 col-md-3">
                    <div class="vit-card p-3 d-flex align-items-center gap-3">
                        <div class="fs-2 text-warning"><i class="bi bi-building"></i></div>
                        <div>
                            <h6 class="mb-0 fw-bold">Hostel</h6>
                            <small class="text-muted">Fans, Rooms, Furniture</small>
                        </div>
                    </div>
                </div>

                <div class="col-6 col-md-3">
                    <div class="vit-card p-3 d-flex align-items-center gap-3">
                        <div class="fs-2 text-danger"><i class="bi bi-cup-hot"></i></div>
                        <div>
                            <h6 class="mb-0 fw-bold">Mess & Food</h6>
                            <small class="text-muted">Quality, Hygiene, Timing</small>
                        </div>
                    </div>
                </div>

                <div class="col-6 col-md-3">
                    <div class="vit-card p-3 d-flex align-items-center gap-3">
                        <div class="fs-2 text-warning"><i class="bi bi-lightning-charge"></i></div>
                        <div>
                            <h6 class="mb-0 fw-bold">Electrical</h6>
                            <small class="text-muted">Power, Wiring, Switches</small>
                        </div>
                    </div>
                </div>

                <div class="col-6 col-md-3">
                    <div class="vit-card p-3 d-flex align-items-center gap-3">
                        <div class="fs-2 text-info"><i class="bi bi-droplet"></i></div>
                        <div>
                            <h6 class="mb-0 fw-bold">Plumbing</h6>
                            <small class="text-muted">Leakage, Taps, Washrooms</small>
                        </div>
                    </div>
                </div>

                <div class="col-6 col-md-3">
                    <div class="vit-card p-3 d-flex align-items-center gap-3">
                        <div class="fs-2 text-success"><i class="bi bi-wifi"></i></div>
                        <div>
                            <h6 class="mb-0 fw-bold">Internet / Wi-Fi</h6>
                            <small class="text-muted">Wi-Fi, LAN, Speed</small>
                        </div>
                    </div>
                </div>

                <div class="col-6 col-md-3">
                    <div class="vit-card p-3 d-flex align-items-center gap-3">
                        <div class="fs-2 text-primary"><i class="bi bi-bus-front"></i></div>
                        <div>
                            <h6 class="mb-0 fw-bold">Transport</h6>
                            <small class="text-muted">Buses, Routes, Timings</small>
                        </div>
                    </div>
                </div>

                <div class="col-6 col-md-3">
                    <div class="vit-card p-3 d-flex align-items-center gap-3">
                        <div class="fs-2 text-secondary"><i class="bi bi-book"></i></div>
                        <div>
                            <h6 class="mb-0 fw-bold">Library</h6>
                            <small class="text-muted">Books, Kiosks, Facilities</small>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </div>
</main>

<!-- QR Code Quick Scanner / Location Simulation Modal -->
<div class="modal fade" id="qrScanModal" tabindex="-1" aria-labelledby="qrModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-navy text-white" style="background-color: var(--vit-navy);">
                <h5 class="modal-title text-white" id="qrModalLabel">
                    <i class="bi bi-qr-code-scan text-warning me-2"></i> Scan Campus Location QR
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <div class="modal-body p-4 text-center">
                <p class="text-muted small mb-3">
                    In a physical campus setup, students point their phone camera at any room's QR sticker. On this portal, you can simulate scanning any location below:
                </p>

                <div class="list-group text-start mb-3">
                    <a href="${pageContext.request.contextPath}/student/raise-complaint?locationId=3"
                       class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                        <div>
                            <div class="fw-bold"><i class="bi bi-building me-2 text-primary"></i> Hostel Block A - Room A-204</div>
                            <small class="text-muted">Hostel Room QR (Floor 2)</small>
                        </div>
                        <span class="badge bg-primary rounded-pill">Open <i class="bi bi-arrow-right"></i></span>
                    </a>

                    <a href="${pageContext.request.contextPath}/student/raise-complaint?locationId=1"
                       class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                        <div>
                            <div class="fw-bold"><i class="bi bi-easel me-2 text-success"></i> Academic Block 1 (AB1) - Room 204</div>
                            <small class="text-muted">Smart Classroom QR (Floor 2)</small>
                        </div>
                        <span class="badge bg-primary rounded-pill">Open <i class="bi bi-arrow-right"></i></span>
                    </a>

                    <a href="${pageContext.request.contextPath}/student/raise-complaint?locationId=5"
                       class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                        <div>
                            <div class="fw-bold"><i class="bi bi-cpu me-2 text-info"></i> Academic Block 2 (AB2) - Room 301</div>
                            <small class="text-muted">Computing Lab QR (Floor 3)</small>
                        </div>
                        <span class="badge bg-primary rounded-pill">Open <i class="bi bi-arrow-right"></i></span>
                    </a>

                    <a href="${pageContext.request.contextPath}/student/raise-complaint?locationId=8"
                       class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                        <div>
                            <div class="fw-bold"><i class="bi bi-cup-hot me-2 text-danger"></i> Food Park Mess - Main Dining Hall</div>
                            <small class="text-muted">Mess Complex QR</small>
                        </div>
                        <span class="badge bg-primary rounded-pill">Open <i class="bi bi-arrow-right"></i></span>
                    </a>

                    <a href="${pageContext.request.contextPath}/student/raise-complaint?locationId=7"
                       class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
                        <div>
                            <div class="fw-bold"><i class="bi bi-book me-2 text-secondary"></i> Central Library - Reading Hall 1</div>
                            <small class="text-muted">Library First Floor QR</small>
                        </div>
                        <span class="badge bg-primary rounded-pill">Open <i class="bi bi-arrow-right"></i></span>
                    </a>
                </div>

                <div class="small text-muted fst-italic">
                    <i class="bi bi-info-circle me-1"></i> If you are not logged in, the system will prompt you to login and immediately redirect you with the location pre-filled.
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/includes/footer.jsp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<nav class="navbar navbar-expand-lg navbar-dark vit-navbar sticky-top">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/">
            <i class="bi bi-mortarboard-fill text-warning"></i>
            <span>SMART VIT</span>
            <span class="badge-vit">CMS</span>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarMain">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarMain">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <c:choose>
                    <c:when test="${sessionScope.currentUser == null}">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/"><i class="bi bi-house-door me-1"></i> Home</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/#track"><i class="bi bi-search me-1"></i> Track Complaint</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/privacy.jsp"><i class="bi bi-shield-check me-1"></i> Privacy</a>
                        </li>
                    </c:when>

                    <c:when test="${sessionScope.currentUser.student}">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/student/dashboard"><i class="bi bi-speedometer2 me-1"></i> Dashboard</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/student/raise-complaint"><i class="bi bi-plus-circle me-1"></i> Raise Complaint</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/student/my-complaints"><i class="bi bi-list-check me-1"></i> My Complaints</a>
                        </li>
                    </c:when>

                    <c:when test="${sessionScope.currentUser.staff}">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/staff/dashboard"><i class="bi bi-speedometer2 me-1"></i> Dashboard</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/staff/raise-complaint"><i class="bi bi-plus-circle me-1"></i> Raise Complaint</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/staff/my-complaints"><i class="bi bi-list-check me-1"></i> My Complaints</a>
                        </li>
                    </c:when>

                    <c:when test="${sessionScope.currentUser.departmentStaff}">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/department/dashboard"><i class="bi bi-speedometer2 me-1"></i> Department Home</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/department/complaints"><i class="bi bi-inbox me-1"></i> Assigned Complaints</a>
                        </li>
                    </c:when>

                    <c:when test="${sessionScope.currentUser.admin}">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard"><i class="bi bi-speedometer2 me-1"></i> Overview</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/complaints"><i class="bi bi-list-ul me-1"></i> All Complaints</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/qr-codes"><i class="bi bi-qr-code-scan me-1"></i> QR Codes</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/departments"><i class="bi bi-building me-1"></i> Departments</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/categories"><i class="bi bi-tags me-1"></i> Categories</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/locations"><i class="bi bi-geo-alt me-1"></i> Locations</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/reports"><i class="bi bi-bar-chart-line me-1"></i> Reports</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/users"><i class="bi bi-people me-1"></i> Users</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/sla"><i class="bi bi-hourglass-split me-1"></i> SLA</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/audit-logs"><i class="bi bi-shield-lock me-1"></i> Audit Logs</a>
                        </li>
                    </c:when>
                </c:choose>
            </ul>

            <ul class="navbar-nav ms-auto align-items-center">
                <c:choose>
                    <c:when test="${sessionScope.currentUser != null}">
                        <!-- Notification Bell -->
                        <li class="nav-item me-3">
                            <a class="nav-link notif-bell-container" href="${pageContext.request.contextPath}/notifications" title="Notifications">
                                <i class="bi bi-bell-fill fs-5"></i>
                                <c:if test="${unreadCount != null && unreadCount > 0}">
                                    <span class="notif-badge">${unreadCount}</span>
                                </c:if>
                            </a>
                        </li>
                        <!-- User Dropdown -->
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle d-flex align-items-center gap-2" href="#" id="userMenu" role="button" data-bs-toggle="dropdown">
                                <i class="bi bi-person-circle fs-5 text-warning"></i>
                                <span class="d-none d-md-inline fw-semibold">${sessionScope.name}</span>
                                <span class="badge bg-light text-dark small">${sessionScope.role}</span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end shadow-sm">
                                <li><h6 class="dropdown-header">${sessionScope.email}</h6></li>
                                <c:if test="${sessionScope.currentUser.student || sessionScope.currentUser.staff}">
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/${sessionScope.currentUser.student ? 'student' : 'staff'}/profile"><i class="bi bi-person me-2"></i> My Profile</a></li>
                                </c:if>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right me-2"></i> Sign Out</a></li>
                            </ul>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item me-2">
                            <a class="btn btn-outline-light btn-sm px-3" href="${pageContext.request.contextPath}/login"><i class="bi bi-box-arrow-in-right me-1"></i> Login</a>
                        </li>
                        <li class="nav-item">
                            <a class="btn btn-vit-gold btn-sm px-3" href="${pageContext.request.contextPath}/register"><i class="bi bi-person-plus me-1"></i> Register</a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>

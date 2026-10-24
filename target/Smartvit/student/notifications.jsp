<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Notifications - SMART VIT" />
<%@ include file="/WEB-INF/includes/header.jsp" %>
<%@ include file="/WEB-INF/includes/navbar.jsp" %>

<main class="main-content">
    <div class="container py-4">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="vit-card p-4">
                    <div class="d-flex justify-content-between align-items-center border-bottom pb-3 mb-4">
                        <div>
                            <span class="badge bg-warning text-dark fw-bold text-uppercase small">Alert Center</span>
                            <h2 class="fw-bold mb-0">System Notifications</h2>
                        </div>
                        <form action="${pageContext.request.contextPath}/notifications/read-all" method="post">
                            <button type="submit" class="btn btn-outline-primary btn-sm">
                                <i class="bi bi-check2-all me-1"></i> Mark All as Read
                            </button>
                        </form>
                    </div>

                    <%@ include file="/WEB-INF/includes/alerts.jsp" %>

                    <c:choose>
                        <c:when test="${empty notifications}">
                            <div class="text-center py-5 text-muted">
                                <i class="bi bi-bell-slash fs-1 d-block text-secondary mb-2"></i>
                                You have no notifications at this time.
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="list-group list-group-flush">
                                <c:forEach var="n" items="${notifications}">
                                    <div id="notif-item-${n.notificationId}" class="list-group-item p-3 border rounded-3 mb-2 shadow-sm ${n.read ? 'bg-white' : 'bg-light border-primary'}">
                                        <div class="d-flex justify-content-between align-items-start mb-1">
                                            <h6 class="fw-bold text-navy mb-0">
                                                <c:if test="${!n.read}"><span class="badge bg-danger p-1 me-1 rounded-circle" style="width: 8px; height: 8px; display: inline-block;"></span></c:if>
                                                ${n.title}
                                            </h6>
                                            <small class="text-muted"><i class="bi bi-clock me-1"></i>${n.createdAt}</small>
                                        </div>
                                        <p class="small text-secondary mb-2">${n.message}</p>
                                        <div class="d-flex justify-content-between align-items-center">
                                            <c:if test="${n.complaintId != null}">
                                                <a href="${pageContext.request.contextPath}/complaint/details?id=${n.complaintId}" class="btn btn-link btn-sm p-0 text-decoration-none">
                                                    View Complaint ${n.complaintCode} <i class="bi bi-arrow-right"></i>
                                                </a>
                                            </c:if>
                                            <c:if test="${!n.read}">
                                                <button class="btn btn-sm btn-outline-secondary btn-mark-notif-read ms-auto" data-notif-id="${n.notificationId}">
                                                    Mark Read
                                                </button>
                                            </c:if>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</main>

<%@ include file="/WEB-INF/includes/footer.jsp" %>

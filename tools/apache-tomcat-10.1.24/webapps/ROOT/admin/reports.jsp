<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Analytics & Reports - SMART VIT" />
<%@ include file="/WEB-INF/includes/header.jsp" %>
<%@ include file="/WEB-INF/includes/navbar.jsp" %>

<main class="main-content">
    <div class="container py-4">
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 pb-2 border-bottom">
            <div>
                <h2 class="fw-bold mb-0"><i class="bi bi-bar-chart-line me-2 text-primary"></i>Analytics & Resolution Reports</h2>
                <p class="text-muted small mb-0">System performance metrics, category distribution, resolution timelines, and student feedback.</p>
            </div>
            <div class="mt-3 mt-md-0">
                <button onclick="window.print()" class="btn btn-outline-secondary shadow-sm"><i class="bi bi-printer me-1"></i> Print / Export Report</button>
            </div>
        </div>

        <%@ include file="/WEB-INF/includes/alerts.jsp" %>

        <!-- Charts Row 1 -->
        <div class="row g-4 mb-4">
            <div class="col-md-6 col-lg-3">
                <div class="vit-card text-center h-100">
                    <div class="vit-card-header"><i class="bi bi-pie-chart me-1"></i>By Status</div>
                    <div class="vit-card-body p-2">
                        <canvas id="statusChart" style="max-height:220px;"></canvas>
                    </div>
                </div>
            </div>
            <div class="col-md-6 col-lg-3">
                <div class="vit-card text-center h-100">
                    <div class="vit-card-header"><i class="bi bi-doughnut-charge me-1"></i>By Category</div>
                    <div class="vit-card-body p-2">
                        <canvas id="categoryChart" style="max-height:220px;"></canvas>
                    </div>
                </div>
            </div>
            <div class="col-md-6 col-lg-6">
                <div class="vit-card text-center h-100">
                    <div class="vit-card-header"><i class="bi bi-bar-chart-fill me-1"></i>Complaints Per Department</div>
                    <div class="vit-card-body p-2">
                        <canvas id="departmentChart" style="max-height:220px;"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <!-- Department Performance Metrics -->
        <div class="vit-card mb-4">
            <div class="vit-card-header d-flex justify-content-between align-items-center">
                <span><i class="bi bi-speedometer me-2"></i>Department Resolution Performance Breakdown</span>
            </div>
            <div class="vit-card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Department Name</th>
                                <th>Total Assigned</th>
                                <th>Resolved</th>
                                <th>Overdue</th>
                                <th>Resolution Rate</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty deptPerformance}">
                                    <tr><td colspan="5" class="text-center py-4 text-muted">No department performance data recorded yet.</td></tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="dp" items="${deptPerformance}">
                                        <tr>
                                            <td><span class="fw-bold text-dark">${dp.name}</span></td>
                                            <td><span class="badge bg-primary fs-6">${dp.total}</span></td>
                                            <td><span class="badge bg-success fs-6">${dp.resolved}</span></td>
                                            <td>
                                                <span class="badge ${dp.overdue > 0 ? 'bg-danger' : 'bg-secondary'} fs-6">${dp.overdue}</span>
                                            </td>
                                            <td>
                                                <c:set var="rate" value="${dp.total > 0 ? (dp.resolved * 100.0 / dp.total) : 0}" />
                                                <div class="d-flex align-items-center gap-2" style="max-width:180px;">
                                                    <div class="progress flex-grow-1" style="height: 10px;">
                                                        <div class="progress-bar ${rate >= 80 ? 'bg-success' : (rate >= 50 ? 'bg-warning' : 'bg-danger')}" style="width: ${rate}%;"></div>
                                                    </div>
                                                    <small class="fw-bold"><fmt:formatNumber value="${rate}" maxFractionDigits="0"/>%</small>
                                                </div>
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

        <!-- Recent Student Feedback & Ratings -->
        <div class="vit-card">
            <div class="vit-card-header d-flex justify-content-between align-items-center">
                <span><i class="bi bi-chat-left-heart me-2"></i>Recent Student & Staff Satisfaction Feedback</span>
                <span class="badge bg-warning text-dark"><i class="bi bi-star-fill me-1"></i>Avg Rating: ${stats.satisfactionRating} / 5</span>
            </div>
            <div class="vit-card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Complaint</th>
                                <th>Rating</th>
                                <th>Comments / Feedback</th>
                                <th>Student Name</th>
                                <th>Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty recentFeedback}">
                                    <tr><td colspan="5" class="text-center py-4 text-muted">No student feedback submitted yet.</td></tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="fb" items="${recentFeedback}">
                                        <tr>
                                            <td><span class="text-monospace fw-bold text-primary">${fb.complaintCode}</span></td>
                                            <td>
                                                <div class="text-warning">
                                                    <c:forEach begin="1" end="${fb.rating}"><i class="bi bi-star-fill"></i></c:forEach>
                                                    <c:forEach begin="${fb.rating + 1}" end="5"><i class="bi bi-star text-muted"></i></c:forEach>
                                                </div>
                                            </td>
                                            <td><small class="fst-italic text-dark">"${fb.comments}"</small></td>
                                            <td><small class="fw-semibold">${fb.studentName}</small></td>
                                            <td><small class="text-muted">${fb.createdAt}</small></td>
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
</main>

<script>
document.addEventListener("DOMContentLoaded", function() {
    // Status Chart
    const statusData = ${statusChartJson};
    if (statusData && statusData.length > 0) {
        new Chart(document.getElementById('statusChart'), {
            type: 'pie',
            data: {
                labels: statusData.map(d => d.status),
                datasets: [{
                    data: statusData.map(d => d.count),
                    backgroundColor: ['#ffc107', '#0d6efd', '#198754', '#dc3545', '#6c757d']
                }]
            },
            options: { responsive: true, plugins: { legend: { position: 'bottom' } } }
        });
    }

    // Category Chart
    const categoryData = ${categoryChartJson};
    if (categoryData && categoryData.length > 0) {
        new Chart(document.getElementById('categoryChart'), {
            type: 'doughnut',
            data: {
                labels: categoryData.map(d => d.name),
                datasets: [{
                    data: categoryData.map(d => d.count),
                    backgroundColor: ['#002147', '#0d6efd', '#0dcaf0', '#ffc107', '#fd7e14', '#20c997']
                }]
            },
            options: { responsive: true, plugins: { legend: { position: 'bottom' } } }
        });
    }

    // Department Chart
    const deptData = ${departmentChartJson};
    if (deptData && deptData.length > 0) {
        new Chart(document.getElementById('departmentChart'), {
            type: 'bar',
            data: {
                labels: deptData.map(d => d.name),
                datasets: [{
                    label: 'Total Complaints',
                    data: deptData.map(d => d.count),
                    backgroundColor: '#002147'
                }]
            },
            options: { responsive: true, scales: { y: { beginAtZero: true } } }
        });
    }
});
</script>

<%@ include file="/WEB-INF/includes/footer.jsp" %>

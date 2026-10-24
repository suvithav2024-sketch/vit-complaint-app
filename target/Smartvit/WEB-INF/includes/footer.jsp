<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<footer class="vit-footer mt-auto">
    <div class="container">
        <div class="row g-4 mb-4">
            <div class="col-lg-4 col-md-6">
                <h5 class="text-white mb-3 d-flex align-items-center gap-2">
                    <i class="bi bi-mortarboard-fill text-warning"></i> SMART VIT
                </h5>
                <p class="small text-light-50">
                    Student Complaint Management System (CMS). Empowering the campus community with transparent, rapid, and verifiable issue resolution.
                </p>
                <div class="small text-warning fw-semibold">
                    "Raise. Track. Resolve."
                </div>
            </div>
            <div class="col-lg-2 col-md-6">
                <h6 class="text-white mb-3">Quick Navigation</h6>
                <ul class="list-unstyled small mb-0">
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/">Home</a></li>
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/login">Portal Login</a></li>
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/register">Registration</a></li>
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/privacy.jsp">Privacy Policy</a></li>
                </ul>
            </div>
            <div class="col-lg-3 col-md-6">
                <h6 class="text-white mb-3">Campus Helplines</h6>
                <ul class="list-unstyled small mb-0 text-light-50">
                    <li class="mb-2"><i class="bi bi-telephone-fill me-2 text-warning"></i> Campus Support: 0416-2202000</li>
                    <li class="mb-2"><i class="bi bi-lightning-charge-fill me-2 text-warning"></i> Electrical: 0416-2202001</li>
                    <li class="mb-2"><i class="bi bi-shield-fill me-2 text-warning"></i> Security Office: 0416-2202010</li>
                    <li class="mb-2"><i class="bi bi-envelope-fill me-2 text-warning"></i> helpdesk@vit.ac.in</li>
                </ul>
            </div>
            <div class="col-lg-3 col-md-6">
                <h6 class="text-white mb-3">Academic Disclaimer</h6>
                <p class="small text-light-50 mb-0">
                    This software is an institutional project designed for academic maintenance, facilities tracking, and student welfare administration.
                </p>
            </div>
        </div>
        <div class="border-top border-secondary pt-3 text-center small text-light-50">
            &copy; 2026 SMART VIT - Student Complaint Management System. All rights reserved.
        </div>
    </div>
</footer>

<!-- Bootstrap 5.3 Bundle JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
<!-- Main App Script -->
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>

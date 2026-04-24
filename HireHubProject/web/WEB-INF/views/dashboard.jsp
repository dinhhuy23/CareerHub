<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - HireHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="app-page">
    <!-- Navigation -->
    <jsp:include page="/WEB-INF/views/header.jsp" />

    <!-- Main Content -->
    <main class="main-content">
        <div class="container">
            <!-- Welcome Section -->
            <div class="welcome-section animate-fadeInUp">
                <div class="welcome-text">
                    <h1>Xin chào, <span class="text-gradient">${sessionScope.userFullName}</span>! 👋</h1>
                    <p class="welcome-subtitle">
                        <c:choose>
                            <c:when test="${sessionScope.userRole == 'CANDIDATE'}">
                                Khám phá cơ hội nghề nghiệp phù hợp với bạn
                            </c:when>
                            <c:when test="${sessionScope.userRole == 'RECRUITER'}">
                                Tìm kiếm nhân tài cho tổ chức của bạn
                            </c:when>
                            <c:otherwise>
                                Quản lý hệ thống HireHub
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>
            </div>

            <!-- Stats Cards -->
            <div class="stats-grid animate-fadeInUp" style="animation-delay: 0.1s;">
                <div class="stat-card glass-card">
                    <div class="stat-icon" style="background: linear-gradient(135deg, #6366F1, #8B5CF6);">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                    </div>
                    <div class="stat-info">
                        <h3>Vai trò</h3>
                        <p class="stat-value">
                            <c:choose>
                                <c:when test="${sessionScope.userRole == 'CANDIDATE'}">Ứng viên</c:when>
                                <c:when test="${sessionScope.userRole == 'RECRUITER'}">Nhà tuyển dụng</c:when>
                                <c:when test="${sessionScope.userRole == 'ADMIN'}">Quản trị viên</c:when>
                                <c:otherwise>${sessionScope.userRole}</c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </div>

                <div class="stat-card glass-card">
                    <div class="stat-icon" style="background: linear-gradient(135deg, #10B981, #059669);">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                    </div>
                    <div class="stat-info">
                        <h3>Trạng thái</h3>
                        <p class="stat-value text-success">Đang hoạt động</p>
                    </div>
                </div>

                <div class="stat-card glass-card">
                    <div class="stat-icon" style="background: linear-gradient(135deg, #F59E0B, #D97706);">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2"><path d="M2.003 5.884L10 9.882l7.997-3.998A2 2 0 0016 4H4a2 2 0 00-1.997 1.884z"/><path d="M18 8.118l-8 4-8-4V14a2 2 0 002 2h12a2 2 0 002-2V8.118z"/></svg>
                    </div>
                    <div class="stat-info">
                        <h3>Email</h3>
                        <p class="stat-value stat-email">${sessionScope.userEmail}</p>
                    </div>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="section-header animate-fadeInUp" style="animation-delay: 0.2s;">
                <h2>Thao tác nhanh</h2>
            </div>
            <div class="actions-grid animate-fadeInUp" style="animation-delay: 0.25s;">
                <a href="${pageContext.request.contextPath}/user/profile" class="action-card glass-card">
                    <div class="action-icon">
                        <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                    </div>
                    <h3>Xem hồ sơ</h3>
                    <p>Xem thông tin cá nhân của bạn</p>
                </a>

                <a href="${pageContext.request.contextPath}/user/edit-profile" class="action-card glass-card">
                    <div class="action-icon">
                        <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                    </div>
                    <h3>Chỉnh sửa hồ sơ</h3>
                    <p>Cập nhật thông tin cá nhân</p>
                </a>

                <a href="${pageContext.request.contextPath}/user/change-password" class="action-card glass-card">
                    <div class="action-icon">
                        <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                    </div>
                    <h3>Đổi mật khẩu</h3>
                    <p>Thay đổi mật khẩu bảo mật</p>
                </a>
            </div>


        </div>
    </main>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>

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
    <nav class="navbar glass-nav">
        <div class="nav-container">
            <a href="${pageContext.request.contextPath}/user/dashboard" class="nav-logo">
                <svg width="36" height="36" viewBox="0 0 48 48" fill="none">
                    <rect width="48" height="48" rx="12" fill="url(#navLogo)"/>
                    <path d="M14 20h20M14 28h14M14 14h8v4h-8zM26 14h8v4h-8z" stroke="white" stroke-width="2.5" stroke-linecap="round"/>
                    <defs><linearGradient id="navLogo" x1="0" y1="0" x2="48" y2="48"><stop stop-color="#6366F1"/><stop offset="1" stop-color="#8B5CF6"/></linearGradient></defs>
                </svg>
                <span>HireHub</span>
            </a>
            <div class="nav-links">
                <a href="${pageContext.request.contextPath}/user/dashboard" class="nav-link active">Dashboard</a>
                <a href="${pageContext.request.contextPath}/user/profile" class="nav-link">Hồ sơ</a>
            </div>
            <div class="nav-user">
                <div class="user-dropdown">
                    <button class="user-btn" onclick="toggleDropdown()">
                        <div class="user-avatar">${sessionScope.userFullName.substring(0,1)}</div>
                        <span class="user-name">${sessionScope.userFullName}</span>
                        <svg width="16" height="16" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z"/></svg>
                    </button>
                    <div class="dropdown-menu" id="userDropdown">
                        <a href="${pageContext.request.contextPath}/user/profile" class="dropdown-item">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                            Thông tin cá nhân
                        </a>
                        <a href="${pageContext.request.contextPath}/user/edit-profile" class="dropdown-item">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                            Chỉnh sửa hồ sơ
                        </a>
                        <a href="${pageContext.request.contextPath}/user/change-password" class="dropdown-item">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                            Đổi mật khẩu
                        </a>
                        <hr class="dropdown-divider">
                        <a href="${pageContext.request.contextPath}/logout" class="dropdown-item text-danger">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
                            Đăng xuất
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </nav>

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

            <!-- JWT Token Info (for demonstration) -->
            <div class="section-header animate-fadeInUp" style="animation-delay: 0.3s;">
                <h2>Thông tin JWT Token</h2>
            </div>
            <div class="token-card glass-card animate-fadeInUp" style="animation-delay: 0.35s;">
                <div class="token-info">
                    <span class="token-label">Token:</span>
                    <code class="token-value">${sessionScope.jwtToken}</code>
                </div>
                <div class="token-badge">
                    <span class="badge badge-success">Valid</span>
                </div>
            </div>
        </div>
    </main>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>

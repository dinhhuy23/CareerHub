<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông tin cá nhân - HireHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="app-page">
    <!-- Navigation -->
    <nav class="navbar glass-nav">
        <div class="nav-container">
            <a href="${pageContext.request.contextPath}/user/dashboard" class="nav-logo">
                <svg width="36" height="36" viewBox="0 0 48 48" fill="none">
                    <rect width="48" height="48" rx="12" fill="url(#navLogo2)"/>
                    <path d="M14 20h20M14 28h14M14 14h8v4h-8zM26 14h8v4h-8z" stroke="white" stroke-width="2.5" stroke-linecap="round"/>
                    <defs><linearGradient id="navLogo2" x1="0" y1="0" x2="48" y2="48"><stop stop-color="#6366F1"/><stop offset="1" stop-color="#8B5CF6"/></linearGradient></defs>
                </svg>
                <span>HireHub</span>
            </a>
            <div class="nav-links">
                <a href="${pageContext.request.contextPath}/user/dashboard" class="nav-link">Dashboard</a>
                <a href="${pageContext.request.contextPath}/user/profile" class="nav-link active">Hồ sơ</a>
            </div>
            <div class="nav-user">
                <div class="user-dropdown">
                    <button class="user-btn" onclick="toggleDropdown()">
                        <div class="user-avatar">${sessionScope.userFullName.substring(0,1)}</div>
                        <span class="user-name">${sessionScope.userFullName}</span>
                        <svg width="16" height="16" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z"/></svg>
                    </button>
                    <div class="dropdown-menu" id="userDropdown">
                        <a href="${pageContext.request.contextPath}/user/profile" class="dropdown-item">Thông tin cá nhân</a>
                        <a href="${pageContext.request.contextPath}/user/edit-profile" class="dropdown-item">Chỉnh sửa hồ sơ</a>
                        <a href="${pageContext.request.contextPath}/user/change-password" class="dropdown-item">Đổi mật khẩu</a>
                        <c:if test="${sessionScope.userRole == 'ADMIN'}">
                            <a href="${pageContext.request.contextPath}/admin/users" class="dropdown-item">Quản lý người dùng</a>
                        </c:if>
                        <hr class="dropdown-divider">
                        <a href="${pageContext.request.contextPath}/logout" class="dropdown-item text-danger">Đăng xuất</a>
                    </div>
                </div>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <main class="main-content">
        <div class="container">
            <div class="page-header animate-fadeInUp">
                <h1>Thông tin cá nhân</h1>
                <a href="${pageContext.request.contextPath}/user/edit-profile" class="btn btn-primary">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                    Chỉnh sửa
                </a>
            </div>

            <!-- Success Message -->
            <c:if test="${param.success == 'updated'}">
                <div class="alert alert-success animate-slideDown">
                    <svg width="20" height="20" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"/></svg>
                    <span>Cập nhật thông tin thành công!</span>
                </div>
            </c:if>

            <!-- Profile Card -->
            <div class="profile-card glass-card animate-fadeInUp" style="animation-delay: 0.1s;">
                <!-- Profile Header -->
                <div class="profile-header">
                    <div class="profile-avatar-large">
                        <span>${user.fullName.substring(0,1)}</span>
                    </div>
                    <div class="profile-header-info">
                        <h2>${user.fullName}</h2>
                        <span class="role-badge role-${sessionScope.userRole.toLowerCase()}">
                            <c:choose>
                                <c:when test="${sessionScope.userRole == 'CANDIDATE'}">Ứng viên</c:when>
                                <c:when test="${sessionScope.userRole == 'RECRUITER'}">Nhà tuyển dụng</c:when>
                                <c:when test="${sessionScope.userRole == 'ADMIN'}">Quản trị viên</c:when>
                            </c:choose>
                        </span>
                    </div>
                </div>

                <!-- Profile Details -->
                <div class="profile-details">
                    <div class="detail-row">
                        <div class="detail-label">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M2.003 5.884L10 9.882l7.997-3.998A2 2 0 0016 4H4a2 2 0 00-1.997 1.884z"/><path d="M18 8.118l-8 4-8-4V14a2 2 0 002 2h12a2 2 0 002-2V8.118z"/></svg>
                            Email
                        </div>
                        <div class="detail-value">${user.email}</div>
                    </div>

                    <div class="detail-row">
                        <div class="detail-label">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                            Họ và tên
                        </div>
                        <div class="detail-value">${user.fullName}</div>
                    </div>

                    <div class="detail-row">
                        <div class="detail-label">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72"/></svg>
                            Số điện thoại
                        </div>
                        <div class="detail-value">${not empty user.phoneNumber ? user.phoneNumber : 'Chưa cập nhật'}</div>
                    </div>

                    <div class="detail-row">
                        <div class="detail-label">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 2a10 10 0 1 0 10 10A10 10 0 0 0 12 2z"/><path d="M12 6v6l4 2"/></svg>
                            Giới tính
                        </div>
                        <div class="detail-value">
                            <c:choose>
                                <c:when test="${user.gender == 'Nam'}">Nam</c:when>
                                <c:when test="${user.gender == 'Nu'}">Nữ</c:when>
                                <c:when test="${user.gender == 'Khac'}">Khác</c:when>
                                <c:otherwise>Chưa cập nhật</c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="detail-row">
                        <div class="detail-label">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
                            Ngày sinh
                        </div>
                        <div class="detail-value">
                            <c:choose>
                                <c:when test="${not empty user.dateOfBirth}">
                                    <fmt:formatDate value="${user.dateOfBirth}" pattern="dd/MM/yyyy"/>
                                </c:when>
                                <c:otherwise>Chưa cập nhật</c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="detail-row">
                        <div class="detail-label">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                            Trạng thái
                        </div>
                        <div class="detail-value">
                            <span class="status-badge status-${user.status.toLowerCase()}">${user.status}</span>
                        </div>
                    </div>

                    <div class="detail-row">
                        <div class="detail-label">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                            Ngày tạo
                        </div>
                        <div class="detail-value">
                            <c:if test="${not empty user.createdAt}">
                                <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>

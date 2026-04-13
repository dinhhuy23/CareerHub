<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh sửa hồ sơ - HireHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="app-page">
    <!-- Navigation -->
    <nav class="navbar glass-nav">
        <div class="nav-container">
            <a href="${pageContext.request.contextPath}/user/dashboard" class="nav-logo">
                <svg width="36" height="36" viewBox="0 0 48 48" fill="none">
                    <rect width="48" height="48" rx="12" fill="url(#navLogo3)"/>
                    <path d="M14 20h20M14 28h14M14 14h8v4h-8zM26 14h8v4h-8z" stroke="white" stroke-width="2.5" stroke-linecap="round"/>
                    <defs><linearGradient id="navLogo3" x1="0" y1="0" x2="48" y2="48"><stop stop-color="#6366F1"/><stop offset="1" stop-color="#8B5CF6"/></linearGradient></defs>
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
                    </button>
                    <div class="dropdown-menu" id="userDropdown">
                        <a href="${pageContext.request.contextPath}/user/profile" class="dropdown-item">Thông tin cá nhân</a>
                        <a href="${pageContext.request.contextPath}/user/edit-profile" class="dropdown-item">Chỉnh sửa hồ sơ</a>
                        <a href="${pageContext.request.contextPath}/user/change-password" class="dropdown-item">Đổi mật khẩu</a>
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
                <h1>Chỉnh sửa hồ sơ</h1>
                <a href="${pageContext.request.contextPath}/user/profile" class="btn btn-outline">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/></svg>
                    Quay lại
                </a>
            </div>

            <!-- Error Message -->
            <c:if test="${not empty error}">
                <div class="alert alert-error animate-slideDown">
                    <svg width="20" height="20" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z"/></svg>
                    <span>${error}</span>
                </div>
            </c:if>

            <!-- Edit Form -->
            <div class="form-card glass-card animate-fadeInUp" style="animation-delay: 0.1s;">
                <form action="${pageContext.request.contextPath}/user/edit-profile" method="POST" class="edit-form" id="editProfileForm">

                    <div class="form-row">
                        <div class="form-group">
                            <label for="fullName" class="form-label">Họ và tên <span class="required">*</span></label>
                            <div class="input-wrapper">
                                <svg class="input-icon" width="20" height="20" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z"/></svg>
                                <input type="text" id="fullName" name="fullName" class="form-input"
                                       value="${user.fullName}" required maxlength="150">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="email" class="form-label">Email <span class="required">*</span></label>
                            <div class="input-wrapper">
                                <svg class="input-icon" width="20" height="20" viewBox="0 0 20 20" fill="currentColor"><path d="M2.003 5.884L10 9.882l7.997-3.998A2 2 0 0016 4H4a2 2 0 00-1.997 1.884z"/><path d="M18 8.118l-8 4-8-4V14a2 2 0 002 2h12a2 2 0 002-2V8.118z"/></svg>
                                <input type="email" id="email" name="email" class="form-input"
                                       value="${user.email}" required>
                            </div>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="phoneNumber" class="form-label">Số điện thoại</label>
                            <div class="input-wrapper">
                                <svg class="input-icon" width="20" height="20" viewBox="0 0 20 20" fill="currentColor"><path d="M2 3a1 1 0 011-1h2.153a1 1 0 01.986.836l.74 4.435a1 1 0 01-.54 1.06l-1.548.773a11.037 11.037 0 006.105 6.105l.774-1.548a1 1 0 011.059-.54l4.435.74a1 1 0 01.836.986V17a1 1 0 01-1 1h-2C7.82 18 2 12.18 2 5V3z"/></svg>
                                <input type="tel" id="phoneNumber" name="phoneNumber" class="form-input"
                                       value="${user.phoneNumber}">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="gender" class="form-label">Giới tính</label>
                            <div class="input-wrapper">
                                <select id="gender" name="gender" class="form-input form-select">
                                    <option value="">-- Chọn --</option>
                                    <option value="Nam" ${user.gender == 'Nam' ? 'selected' : ''}>Nam</option>
                                    <option value="Nu" ${user.gender == 'Nu' ? 'selected' : ''}>Nữ</option>
                                    <option value="Khac" ${user.gender == 'Khac' ? 'selected' : ''}>Khác</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="dateOfBirth" class="form-label">Ngày sinh</label>
                        <div class="input-wrapper">
                            <svg class="input-icon" width="20" height="20" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M6 2a1 1 0 00-1 1v1H4a2 2 0 00-2 2v10a2 2 0 002 2h12a2 2 0 002-2V6a2 2 0 00-2-2h-1V3a1 1 0 10-2 0v1H7V3a1 1 0 00-1-1zm0 5a1 1 0 000 2h8a1 1 0 100-2H6z"/></svg>
                            <input type="date" id="dateOfBirth" name="dateOfBirth" class="form-input"
                                   value="<fmt:formatDate value='${user.dateOfBirth}' pattern='yyyy-MM-dd'/>">
                        </div>
                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/user/profile" class="btn btn-outline">Hủy</a>
                        <button type="submit" class="btn btn-primary">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"/><polyline points="17 21 17 13 7 13 7 21"/><polyline points="7 3 7 8 15 8"/></svg>
                            Lưu thay đổi
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </main>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>

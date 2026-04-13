<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đổi mật khẩu - HireHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="app-page">
    <!-- Navigation -->
    <nav class="navbar glass-nav">
        <div class="nav-container">
            <a href="${pageContext.request.contextPath}/user/dashboard" class="nav-logo">
                <svg width="36" height="36" viewBox="0 0 48 48" fill="none">
                    <rect width="48" height="48" rx="12" fill="url(#navLogo4)"/>
                    <path d="M14 20h20M14 28h14M14 14h8v4h-8zM26 14h8v4h-8z" stroke="white" stroke-width="2.5" stroke-linecap="round"/>
                    <defs><linearGradient id="navLogo4" x1="0" y1="0" x2="48" y2="48"><stop stop-color="#6366F1"/><stop offset="1" stop-color="#8B5CF6"/></linearGradient></defs>
                </svg>
                <span>HireHub</span>
            </a>
            <div class="nav-links">
                <a href="${pageContext.request.contextPath}/user/dashboard" class="nav-link">Dashboard</a>
                <a href="${pageContext.request.contextPath}/user/profile" class="nav-link">Hồ sơ</a>
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
                <h1>Đổi mật khẩu</h1>
                <a href="${pageContext.request.contextPath}/user/profile" class="btn btn-outline">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/></svg>
                    Quay lại
                </a>
            </div>

            <!-- Success Message -->
            <c:if test="${not empty success}">
                <div class="alert alert-success animate-slideDown">
                    <svg width="20" height="20" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"/></svg>
                    <span>${success}</span>
                </div>
            </c:if>

            <!-- Error Message -->
            <c:if test="${not empty error}">
                <div class="alert alert-error animate-slideDown">
                    <svg width="20" height="20" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z"/></svg>
                    <span>${error}</span>
                </div>
            </c:if>

            <!-- Change Password Form -->
            <div class="form-card glass-card animate-fadeInUp" style="animation-delay: 0.1s; max-width: 560px;">
                <div class="form-card-header">
                    <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" style="color: var(--primary);">
                        <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                        <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                        <circle cx="12" cy="16" r="1"/>
                    </svg>
                    <p class="form-card-desc">Để bảo mật tài khoản, vui lòng không chia sẻ mật khẩu với người khác.</p>
                </div>

                <form action="${pageContext.request.contextPath}/user/change-password" method="POST" class="edit-form" id="changePasswordForm">

                    <div class="form-group">
                        <label for="currentPassword" class="form-label">Mật khẩu hiện tại <span class="required">*</span></label>
                        <div class="input-wrapper">
                            <svg class="input-icon" width="20" height="20" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z"/></svg>
                            <input type="password" id="currentPassword" name="currentPassword" class="form-input"
                                   placeholder="Nhập mật khẩu hiện tại" required>
                            <button type="button" class="toggle-password" onclick="togglePassword('currentPassword')">
                                <svg width="20" height="20" viewBox="0 0 20 20" fill="currentColor" class="eye-icon"><path d="M10 12a2 2 0 100-4 2 2 0 000 4z"/><path fill-rule="evenodd" d="M.458 10C1.732 5.943 5.522 3 10 3s8.268 2.943 9.542 7c-1.274 4.057-5.064 7-9.542 7S1.732 14.057.458 10zM14 10a4 4 0 11-8 0 4 4 0 018 0z"/></svg>
                            </button>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="newPassword" class="form-label">Mật khẩu mới <span class="required">*</span></label>
                        <div class="input-wrapper">
                            <svg class="input-icon" width="20" height="20" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z"/></svg>
                            <input type="password" id="newPassword" name="newPassword" class="form-input"
                                   placeholder="Ít nhất 8 ký tự, chữ hoa, chữ thường, số" required minlength="8">
                            <button type="button" class="toggle-password" onclick="togglePassword('newPassword')">
                                <svg width="20" height="20" viewBox="0 0 20 20" fill="currentColor" class="eye-icon"><path d="M10 12a2 2 0 100-4 2 2 0 000 4z"/><path fill-rule="evenodd" d="M.458 10C1.732 5.943 5.522 3 10 3s8.268 2.943 9.542 7c-1.274 4.057-5.064 7-9.542 7S1.732 14.057.458 10zM14 10a4 4 0 11-8 0 4 4 0 018 0z"/></svg>
                            </button>
                        </div>
                        <div class="password-strength" id="passwordStrength">
                            <div class="strength-bar"><div class="strength-fill" id="strengthFill"></div></div>
                            <span class="strength-text" id="strengthText"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="confirmNewPassword" class="form-label">Xác nhận mật khẩu mới <span class="required">*</span></label>
                        <div class="input-wrapper">
                            <svg class="input-icon" width="20" height="20" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z"/></svg>
                            <input type="password" id="confirmNewPassword" name="confirmNewPassword" class="form-input"
                                   placeholder="Nhập lại mật khẩu mới" required>
                        </div>
                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/user/profile" class="btn btn-outline">Hủy</a>
                        <button type="submit" class="btn btn-primary">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                            Đổi mật khẩu
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </main>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>

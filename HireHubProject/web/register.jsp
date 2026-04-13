<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Ký - HireHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="auth-page">
    <div class="auth-container">
        <div class="auth-card glass-card register-card animate-fadeInUp">
            <!-- Logo -->
            <div class="auth-logo">
                <div class="logo-icon">
                    <svg width="48" height="48" viewBox="0 0 48 48" fill="none">
                        <rect width="48" height="48" rx="12" fill="url(#logoGradient2)"/>
                        <path d="M14 20h20M14 28h14M14 14h8v4h-8zM26 14h8v4h-8z" stroke="white" stroke-width="2.5" stroke-linecap="round"/>
                        <defs>
                            <linearGradient id="logoGradient2" x1="0" y1="0" x2="48" y2="48">
                                <stop stop-color="#6366F1"/>
                                <stop offset="1" stop-color="#8B5CF6"/>
                            </linearGradient>
                        </defs>
                    </svg>
                </div>
                <h1 class="logo-text">Tạo Tài Khoản</h1>
                <p class="logo-subtitle">Bắt đầu hành trình nghề nghiệp của bạn</p>
            </div>

            <!-- Error Message -->
            <c:if test="${not empty error}">
                <div class="alert alert-error animate-slideDown">
                    <svg width="20" height="20" viewBox="0 0 20 20" fill="currentColor">
                        <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z"/>
                    </svg>
                    <span>${error}</span>
                </div>
            </c:if>

            <!-- Register Form -->
            <form action="${pageContext.request.contextPath}/register" method="POST" class="auth-form" id="registerForm">

                <!-- Role Selection -->
                <div class="form-group">
                    <label class="form-label">Bạn là</label>
                    <div class="role-selector">
                        <label class="role-option ${selectedRole == 'CANDIDATE' ? 'active' : ''}">
                            <input type="radio" name="role" value="CANDIDATE" ${selectedRole == 'CANDIDATE' || empty selectedRole ? 'checked' : ''}>
                            <div class="role-card">
                                <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                                    <circle cx="12" cy="7" r="4"/>
                                </svg>
                                <span>Ứng viên</span>
                            </div>
                        </label>
                        <label class="role-option ${selectedRole == 'RECRUITER' ? 'active' : ''}">
                            <input type="radio" name="role" value="RECRUITER" ${selectedRole == 'RECRUITER' ? 'checked' : ''}>
                            <div class="role-card">
                                <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <rect x="2" y="3" width="20" height="14" rx="2" ry="2"/>
                                    <path d="M8 21h8M12 17v4"/>
                                </svg>
                                <span>Nhà tuyển dụng</span>
                            </div>
                        </label>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="fullName" class="form-label">Họ và tên <span class="required">*</span></label>
                        <div class="input-wrapper">
                            <svg class="input-icon" width="20" height="20" viewBox="0 0 20 20" fill="currentColor">
                                <path fill-rule="evenodd" d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z"/>
                            </svg>
                            <input type="text" id="fullName" name="fullName" class="form-input"
                                   placeholder="Nguyễn Văn A" value="${fullName}" required maxlength="150">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="regEmail" class="form-label">Email <span class="required">*</span></label>
                        <div class="input-wrapper">
                            <svg class="input-icon" width="20" height="20" viewBox="0 0 20 20" fill="currentColor">
                                <path d="M2.003 5.884L10 9.882l7.997-3.998A2 2 0 0016 4H4a2 2 0 00-1.997 1.884z"/>
                                <path d="M18 8.118l-8 4-8-4V14a2 2 0 002 2h12a2 2 0 002-2V8.118z"/>
                            </svg>
                            <input type="email" id="regEmail" name="email" class="form-input"
                                   placeholder="example@email.com" value="${email}" required>
                        </div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="phoneNumber" class="form-label">Số điện thoại</label>
                        <div class="input-wrapper">
                            <svg class="input-icon" width="20" height="20" viewBox="0 0 20 20" fill="currentColor">
                                <path d="M2 3a1 1 0 011-1h2.153a1 1 0 01.986.836l.74 4.435a1 1 0 01-.54 1.06l-1.548.773a11.037 11.037 0 006.105 6.105l.774-1.548a1 1 0 011.059-.54l4.435.74a1 1 0 01.836.986V17a1 1 0 01-1 1h-2C7.82 18 2 12.18 2 5V3z"/>
                            </svg>
                            <input type="tel" id="phoneNumber" name="phoneNumber" class="form-input"
                                   placeholder="0901234567" value="${phoneNumber}">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="gender" class="form-label">Giới tính</label>
                        <div class="input-wrapper">
                            <select id="gender" name="gender" class="form-input form-select">
                                <option value="">-- Chọn --</option>
                                <option value="Nam" ${gender == 'Nam' ? 'selected' : ''}>Nam</option>
                                <option value="Nu" ${gender == 'Nu' ? 'selected' : ''}>Nữ</option>
                                <option value="Khac" ${gender == 'Khac' ? 'selected' : ''}>Khác</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="regPassword" class="form-label">Mật khẩu <span class="required">*</span></label>
                    <div class="input-wrapper">
                        <svg class="input-icon" width="20" height="20" viewBox="0 0 20 20" fill="currentColor">
                            <path fill-rule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z"/>
                        </svg>
                        <input type="password" id="regPassword" name="password" class="form-input"
                               placeholder="Ít nhất 8 ký tự, chữ hoa, chữ thường, số" required minlength="8">
                        <button type="button" class="toggle-password" onclick="togglePassword('regPassword')">
                            <svg width="20" height="20" viewBox="0 0 20 20" fill="currentColor" class="eye-icon">
                                <path d="M10 12a2 2 0 100-4 2 2 0 000 4z"/>
                                <path fill-rule="evenodd" d="M.458 10C1.732 5.943 5.522 3 10 3s8.268 2.943 9.542 7c-1.274 4.057-5.064 7-9.542 7S1.732 14.057.458 10zM14 10a4 4 0 11-8 0 4 4 0 018 0z"/>
                            </svg>
                        </button>
                    </div>
                    <!-- Password strength indicator -->
                    <div class="password-strength" id="passwordStrength">
                        <div class="strength-bar"><div class="strength-fill" id="strengthFill"></div></div>
                        <span class="strength-text" id="strengthText"></span>
                    </div>
                </div>

                <div class="form-group">
                    <label for="confirmPassword" class="form-label">Xác nhận mật khẩu <span class="required">*</span></label>
                    <div class="input-wrapper">
                        <svg class="input-icon" width="20" height="20" viewBox="0 0 20 20" fill="currentColor">
                            <path fill-rule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z"/>
                        </svg>
                        <input type="password" id="confirmPassword" name="confirmPassword" class="form-input"
                               placeholder="Nhập lại mật khẩu" required>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary btn-full" id="registerBtn">
                    <span class="btn-text">Đăng Ký</span>
                    <span class="btn-loader" style="display:none;">
                        <svg class="spinner" width="20" height="20" viewBox="0 0 24 24">
                            <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="3" fill="none" stroke-dasharray="31.4 31.4" stroke-linecap="round">
                                <animateTransform attributeName="transform" type="rotate" values="0 12 12;360 12 12" dur="1s" repeatCount="indefinite"/>
                            </circle>
                        </svg>
                    </span>
                </button>
            </form>

            <div class="auth-footer">
                <p>Đã có tài khoản? <a href="${pageContext.request.contextPath}/login" class="auth-link">Đăng nhập</a></p>
            </div>
        </div>
    </div>

    <!-- Background decoration -->
    <div class="bg-decoration">
        <div class="bg-circle bg-circle-1"></div>
        <div class="bg-circle bg-circle-2"></div>
        <div class="bg-circle bg-circle-3"></div>
    </div>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>

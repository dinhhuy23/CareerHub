<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Đăng Nhập - HireHub</title>
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
                rel="stylesheet">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        </head>

        <body class="auth-page">
            <div class="auth-container">
                <div class="auth-card glass-card animate-fadeInUp">
                    <!-- Logo -->
                    <div class="auth-logo">
                        <div class="logo-icon">
                            <svg width="48" height="48" viewBox="0 0 48 48" fill="none">
                                <rect width="48" height="48" rx="12" fill="url(#logoGradient)" />
                                <path d="M14 20h20M14 28h14M14 14h8v4h-8zM26 14h8v4h-8z" stroke="white"
                                    stroke-width="2.5" stroke-linecap="round" />
                                <defs>
                                    <linearGradient id="logoGradient" x1="0" y1="0" x2="48" y2="48">
                                        <stop stop-color="#6366F1" />
                                        <stop offset="1" stop-color="#8B5CF6" />
                                    </linearGradient>
                                </defs>
                            </svg>
                        </div>
                        <h1 class="logo-text">HireHub</h1>
                        <p class="logo-subtitle">Nền tảng tuyển dụng hàng đầu</p>
                    </div>

                    <!-- Success Message -->
                    <c:if test="${not empty success}">
                        <div class="alert alert-success animate-slideDown">
                            <svg width="20" height="20" viewBox="0 0 20 20" fill="currentColor">
                                <path fill-rule="evenodd"
                                    d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" />
                            </svg>
                            <span>${success}</span>
                        </div>
                    </c:if>

                    <!-- Error Message -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-error animate-slideDown">
                            <svg width="20" height="20" viewBox="0 0 20 20" fill="currentColor">
                                <path fill-rule="evenodd"
                                    d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" />
                            </svg>
                            <span>${error}</span>
                        </div>
                    </c:if>

                    <!-- Login Form -->
                    <form action="${pageContext.request.contextPath}/login" method="POST" class="auth-form"
                        id="loginForm">
                        <div class="form-group">
                            <label for="email" class="form-label">Email</label>
                            <div class="input-wrapper">
                                <svg class="input-icon" width="20" height="20" viewBox="0 0 20 20" fill="currentColor">
                                    <path d="M2.003 5.884L10 9.882l7.997-3.998A2 2 0 0016 4H4a2 2 0 00-1.997 1.884z" />
                                    <path d="M18 8.118l-8 4-8-4V14a2 2 0 002 2h12a2 2 0 002-2V8.118z" />
                                </svg>
                                <input type="email" id="email" name="email" class="form-input"
                                    placeholder="Nhập email của bạn" value="${email}" required autocomplete="email">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="password" class="form-label">Mật khẩu</label>
                            <div class="input-wrapper">
                                <svg class="input-icon" width="20" height="20" viewBox="0 0 20 20" fill="currentColor">
                                    <path fill-rule="evenodd"
                                        d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z" />
                                </svg>
                                <input type="password" id="password" name="password" class="form-input"
                                    placeholder="Nhập mật khẩu" required autocomplete="current-password">
                                <button type="button" class="toggle-password" onclick="togglePassword('password')">
                                    <svg width="20" height="20" viewBox="0 0 20 20" fill="currentColor"
                                        class="eye-icon">
                                        <path d="M10 12a2 2 0 100-4 2 2 0 000 4z" />
                                        <path fill-rule="evenodd"
                                            d="M.458 10C1.732 5.943 5.522 3 10 3s8.268 2.943 9.542 7c-1.274 4.057-5.064 7-9.542 7S1.732 14.057.458 10zM14 10a4 4 0 11-8 0 4 4 0 018 0z" />
                                    </svg>
                                </button>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-primary btn-full" id="loginBtn">
                            <span class="btn-text">Đăng Nhập</span>
                            <span class="btn-loader" style="display:none;">
                                <svg class="spinner" width="20" height="20" viewBox="0 0 24 24">
                                    <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="3" fill="none"
                                        stroke-dasharray="31.4 31.4" stroke-linecap="round">
                                        <animateTransform attributeName="transform" type="rotate"
                                            values="0 12 12;360 12 12" dur="1s" repeatCount="indefinite" />
                                    </circle>
                                </svg>
                            </span>
                        </button>
                    </form>

                    <div class="auth-footer">
                        <p>Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register"
                                class="auth-link">Đăng ký ngay</a></p>
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

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng Nhập - HireHub</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    </head>
    <body class="auth-page">
        <div class="auth-container">
            <div class="auth-card glass-card animate-fadeInUp">
                <!-- Logo -->
                <div class="auth-logo">
                    <div class="logo-icon">
                        <svg width="48" height="48" viewBox="0 0 48 48" fill="none">
                        <rect width="48" height="48" rx="12" fill="url(#logoGradient)"/>
                        <path d="M14 20h20M14 28h14M14 14h8v4h-8zM26 14h8v4h-8z" stroke="white" stroke-width="2.5" stroke-linecap="round"/>
                        <defs>
                        <linearGradient id="logoGradient" x1="0" y1="0" x2="48" y2="48">
                        <stop stop-color="#6366F1"/>
                        <stop offset="1" stop-color="#8B5CF6"/>
                        </linearGradient>
                        </defs>
                        </svg>
                    </div>
                    <h1 class="logo-text">HireHub</h1>
                    <p class="logo-subtitle">Nền tảng tuyển dụng hàng đầu</p>
                </div>

                <!-- Success Message -->
                <c:if test="${not empty success}">
                    <div class="alert alert-success">
                        <span>${success}</span>
                    </div>
                </c:if>

                <!-- Error Message -->
                <c:if test="${not empty error}">
                    <div class="alert alert-error animate-slideDown">
                        <svg width="20" height="20" viewBox="0 0 20 20" fill="currentColor">
                        <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z"/>
                        </svg>
                        <span>${error}</span>
                    </div>
                </c:if>

                <!-- Login Form -->
                <form action="forgot-password" method="GET" class="auth-form" >
                    <div class="form-group">
                        <label for="email" class="form-label">Email</label>
                        <div class="input-wrapper">
                            <svg class="input-icon" width="20" height="20" viewBox="0 0 20 20" fill="currentColor">
                            <path d="M2.003 5.884L10 9.882l7.997-3.998A2 2 0 0016 4H4a2 2 0 00-1.997 1.884z"/>
                            <path d="M18 8.118l-8 4-8-4V14a2 2 0 002 2h12a2 2 0 002-2V8.118z"/>
                            </svg>
                            <input type="email" name="email" class="form-input"
                                   placeholder="Nhập email của bạn" required >
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary btn-full" id="loginBtn">
                        <span class="btn-text">Gửi link reset</span>
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
                <p>Quay lại Login <a href="${pageContext.request.contextPath}/login" class="auth-link">Back</a></p>
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


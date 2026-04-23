<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quyền Truy Cập Bị Hạn Chế | CareerHub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
</head>
<body class="app-page">
    <jsp:include page="header.jsp" />

    <div class="auth-page">
        <div class="bg-decoration">
            <div class="bg-circle bg-circle-1"></div>
            <div class="bg-circle bg-circle-2"></div>
        </div>

        <div class="auth-container" style="max-width: 600px;">
            <div class="glass-card auth-card" style="text-align: center;">
                <div class="logo-icon" style="font-size: 4rem; color: var(--warning); margin-bottom: var(--space-lg);">
                    <i class="fas fa-exclamation-triangle"></i>
                </div>
                
                <h1 class="logo-text" style="background: linear-gradient(135deg, var(--warning), var(--error)); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">
                    Quyền Truy Cập Bị Hạn Chế
                </h1>
                
                <div style="margin: var(--space-xl) 0; line-height: 1.8;">
                    <p style="color: var(--text-primary); font-size: 1.1rem; font-weight: 500;">
                        ${not empty errorMessage ? errorMessage : "Bạn không có quyền thực hiện thao tác này."}
                    </p>
                    <p style="color: var(--text-secondary); margin-top: var(--space-md);">
                        Để đăng tin tuyển dụng, tài khoản của bạn cần được Admin phê duyệt (Status: ACTIVE) và phải được liên kết với một công ty hợp lệ.
                    </p>
                </div>

                <div style="display: flex; gap: var(--space-md); justify-content: center; margin-top: var(--space-xl);">
                    <a href="${pageContext.request.contextPath}/employer/dashboard" class="btn btn-outline" style="min-width: 160px;">
                        <i class="fas fa-arrow-left"></i> Quay lại
                    </a>
                    <a href="${pageContext.request.contextPath}/user/profile" class="btn btn-primary" style="min-width: 160px;">
                        Cập nhật hồ sơ <i class="fas fa-user-edit"></i>
                    </a>
                </div>
                
                <div style="margin-top: var(--space-2xl); padding-top: var(--space-lg); border-top: 1px solid var(--border-color);">
                    <p style="font-size: 0.9rem; color: var(--text-muted);">
                        Nếu bạn tin rằng đây là một sự nhầm lẫn, vui lòng liên hệ bộ phận hỗ trợ qua email: 
                        <a href="mailto:support@careerhub.com" style="color: var(--primary-light);">support@careerhub.com</a>
                    </p>
                </div>
            </div>
        </div>
    </div>
</body>
</html>

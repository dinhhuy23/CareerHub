<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>403 - Truy cập bị từ chối</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="auth-page">
    <div class="auth-container">
        <div class="auth-card glass-card animate-fadeInUp" style="text-align: center;">
            <div style="font-size: 4rem; margin-bottom: 16px;">🚫</div>
            <h1 style="font-size: 2rem; font-weight: 800; margin-bottom: 8px; color: var(--error);">403</h1>
            <p style="color: var(--text-secondary); margin-bottom: 24px;">Bạn không có quyền truy cập trang này.</p>
            <a href="${pageContext.request.contextPath}/user/dashboard" class="btn btn-primary">Về trang chủ</a>
        </div>
    </div>
    <div class="bg-decoration">
        <div class="bg-circle bg-circle-1"></div>
        <div class="bg-circle bg-circle-2"></div>
    </div>
</body>
</html>

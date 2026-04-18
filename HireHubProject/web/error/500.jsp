<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 - Lỗi hệ thống</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="auth-page">
    <div class="auth-container">
        <div class="auth-card glass-card animate-fadeInUp" style="text-align: center;">
            <div style="font-size: 4rem; margin-bottom: 16px;">⚠️</div>
            <h1 style="font-size: 2rem; font-weight: 800; margin-bottom: 8px; color: var(--error);">500</h1>
            <p style="color: var(--text-secondary); margin-bottom: 24px;">Đã xảy ra lỗi hệ thống. Vui lòng thử lại sau.</p>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Về trang chủ</a>
            
            <!-- DEBUG TRACE -->
            <div style="margin-top: 30px; text-align: left; background: rgba(0,0,0,0.5); padding: 15px; border-radius: 8px; overflow-x: auto; max-height: 400px; font-family: monospace; font-size: 12px; color: #ff8b8b;">
                <strong>Chi tiết lỗi Servlet:</strong><br/>
                <%
                    Throwable throwable = (Throwable) request.getAttribute("javax.servlet.error.exception");
                    if (throwable != null) {
                        out.println("<p style='color: white; font-weight: bold;'>" + throwable.toString() + "</p>");
                        for(StackTraceElement e : throwable.getStackTrace()) {
                            out.println(e.toString() + "<br/>");
                        }
                    } else {
                        out.println("Không tìm thấy StackTrace trong Servlet Request. Hãy xem log của thư mục Tomcat.");
                        Exception ex = (Exception) request.getAttribute("javax.servlet.error.exception");
                        if (ex != null) { out.println("<br> Exception: " + ex.getMessage()); }
                    }
                %>
            </div>
            <!-- END DEBUG TRACE -->
        </div>
    </div>
    <div class="bg-decoration">
        <div class="bg-circle bg-circle-1"></div>
        <div class="bg-circle bg-circle-2"></div>
    </div>
</body>
</html>

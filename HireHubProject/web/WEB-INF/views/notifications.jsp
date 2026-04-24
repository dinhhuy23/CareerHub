<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thông báo - HireHub</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <style>
            .notif-item {
                display: flex;
                gap: 16px;
                align-items: flex-start;
                padding: 18px 24px;
                border-bottom: 1px solid var(--border-color);
                transition: background 0.2s;
            }
            .notif-item:last-child {
                border-bottom: none;
            }
            .notif-item.unread {
                background: rgba(99,102,241,0.05);
            }
            .notif-item:hover {
                background: var(--bg-tertiary);
            }
            .notif-dot {
                width: 10px;
                height: 10px;
                border-radius: 50%;
                background: var(--primary);
                flex-shrink: 0;
                margin-top: 6px;
            }
            .notif-dot.read {
                background: var(--border-color);
            }
            .notif-title {
                font-weight: 700;
                color: var(--text-primary);
                margin-bottom: 4px;
                font-size: 0.95rem;
            }
            .notif-msg {
                color: var(--text-secondary);
                font-size: 0.875rem;
                line-height: 1.5;
            }
            .notif-time {
                font-size: 0.78rem;
                color: var(--text-muted);
                margin-top: 6px;
            }
        </style>
    </head>
    <body class="app-page">
        <jsp:include page="/WEB-INF/views/header.jsp" />

        <main class="main-content">
            <div class="container animate-fadeInUp" style="max-width: 760px;">

                <div style="margin-bottom: 28px; display: flex; justify-content: space-between; align-items: center;">
                    <div>
                        <h1 style="font-size: 1.8rem; font-weight: 800; color: var(--text-primary); margin-bottom: 6px;">Thông báo</h1>
                        <p style="color: var(--text-secondary);">Cập nhật mới nhất về hồ sơ ứng tuyển của bạn.</p>
                    </div>
                </div>

                <div class="glass-card" style="padding: 0; overflow: hidden;">
                    <c:if test="${empty notifications}">
                        <div style="padding: 60px; text-align: center;">
                            <svg width="56" height="56" viewBox="0 0 24 24" fill="none" stroke="var(--text-muted)" stroke-width="1.5" style="margin-bottom: 16px;">
                            <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path>
                            <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
                            </svg>
                            <p style="color: var(--text-secondary); font-size: 1rem;">Bạn chưa có thông báo nào.</p>
                        </div>
                    </c:if>

                    <c:forEach var="n" items="${notifications}">
                        <div class="notif-item ${!n.read ? 'unread' : ''}">

                            <div class="notif-dot ${n.read ? 'read' : ''}"></div>

                            <div style="flex: 1;">
                                <div class="notif-title">${n.title}</div>
                                <div class="notif-msg">${n.message}</div>

                                <div class="notif-time">
                                    <fmt:formatDate value="${n.createdAt}" pattern="HH:mm - dd/MM/yyyy"/>
                                </div>

                                <!-- ✅ ADD NÚT MARK READ -->


                            </div>
                        </div>
                    </c:forEach>
                </div>

            </div>
        </main>
    </body>
</html>

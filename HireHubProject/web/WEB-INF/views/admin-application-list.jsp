<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý tất cả hồ sơ - HireHub Admin</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <style>
            .app-card {
                padding: 24px;
                border-radius: 16px;
                backdrop-filter: blur(10px);
            }
            .card-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
            }
            .app-table {
                width: 100%;
                border-collapse: collapse;
            }
            .app-table th {
                text-align: left;
                padding: 12px;
                opacity: 0.7;
                font-weight: 500;
            }
            .app-table td {
                padding: 14px 12px;
                border-top: 1px solid rgba(255,255,255,0.05);
            }
            .app-table tr:hover {
                background: rgba(255,255,255,0.03);
            }
            .user-info {
                display: flex;
                align-items: center;
                gap: 12px;
            }
            .user-avatar {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                background: var(--bg-tertiary);
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: 700;
                overflow: hidden;
            }
            .user-avatar img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }
            .job-title {
                font-weight: 600;
                display: block;
                color: var(--primary);
            }
            .company-name {
                font-size: 0.85rem;
                opacity: 0.7;
            }
            .badge {
                padding: 4px 10px;
                border-radius: 999px;
                font-size: 12px;
                font-weight: 500;
            }
            .badge.pending { background: rgba(234, 179, 8, 0.2); color: #eab308; }
            .badge.reviewing { background: rgba(59, 130, 246, 0.2); color: #3b82f6; }
            .badge.interviewing { background: rgba(168, 85, 247, 0.2); color: #a855f7; }
            .badge.offered { background: rgba(34, 197, 94, 0.2); color: #22c55e; }
            .badge.rejected { background: rgba(239, 68, 68, 0.2); color: #ef4444; }
            .btn-view {
                color: var(--primary);
                text-decoration: none;
                font-weight: 500;
                font-size: 0.9rem;
            }
        </style>
    </head>
    <body class="app-page">
        <jsp:include page="/WEB-INF/views/header.jsp" />

        <main class="main-content">
            <div class="container" style="margin-top: 30px;">
                <div class="glass-card app-card">
                    <div class="card-header">
                        <div>
                            <h2 style="margin: 0;">Quản lý Hồ sơ Ứng tuyển</h2>
                            <p style="opacity: 0.6; font-size: 0.9rem;">Xem tất cả hồ sơ từ mọi người dùng trong hệ thống</p>
                        </div>
                    </div>

                    <table class="app-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Ứng viên</th>
                                <th>Công việc</th>
                                <th>Ngày nộp</th>
                                <th>Trạng thái</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="app" items="${list}">
                                <tr>
                                    <td>#${app.applicationId}</td>
                                    <td>
                                        <div class="user-info">
                                            <div class="user-avatar">
                                                <c:choose>
                                                    <c:when test="${not empty app.candidateAvatar}">
                                                        <img src="${app.candidateAvatar}" alt="avatar">
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${app.candidateName.substring(0,1).toUpperCase()}
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div>
                                                <div style="font-weight: 600;">${app.candidateName}</div>
                                                <div style="font-size: 0.8rem; opacity: 0.6;">${app.candidateEmail}</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="job-title">${app.jobTitle}</span>
                                        <span class="company-name">${app.companyName}</span>
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${app.appliedAt}" pattern="dd/MM/yyyy HH:mm" />
                                    </td>
                                    <td>
                                        <span class="badge ${app.status.toLowerCase()}">${app.status}</span>
                                    </td>
                                    <td>
                                        <c:if test="${not empty app.cvUrl}">
                                            <a href="${app.cvUrl}" target="_blank" class="btn-view">Xem CV</a>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty list}">
                                <tr>
                                    <td colspan="6" style="text-align: center; padding: 40px; opacity: 0.5;">
                                        Chưa có hồ sơ nào được nộp.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>

        <script src="${pageContext.request.contextPath}/js/main.js"></script>
    </body>
</html>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - HireHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .dashboard-section { margin-top: 40px; }
        .dashboard-grid {
            display: grid;
            grid-template-columns: 1fr 350px;
            gap: 30px;
        }
        @media (max-width: 1024px) {
            .dashboard-grid { grid-template-columns: 1fr; }
        }
        
        .recent-app-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 16px;
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            margin-bottom: 12px;
            transition: all 0.2s;
        }
        .recent-app-item:hover { background: rgba(255, 255, 255, 0.05); border-color: var(--primary); }
        
        .status-badge {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 700;
        }
        
        .rec-item {
            padding: 16px;
            background: var(--bg-secondary);
            border-radius: 12px;
            border: 1px solid var(--border-color);
            margin-bottom: 12px;
            display: block;
            text-decoration: none;
            transition: all 0.2s;
        }
        .rec-item:hover { border-color: var(--primary); transform: translateX(5px); }
    </style>
</head>
<body class="app-page">
    <!-- Navigation -->
    <jsp:include page="/WEB-INF/views/header.jsp" />

    <!-- Main Content -->
    <main class="main-content">
        <div class="container">
            <!-- Welcome Section -->
            <div class="welcome-section animate-fadeInUp">
                <div class="welcome-text">
                    <h1>Xin chào, <span class="text-gradient">${sessionScope.userFullName}</span>! 👋</h1>
                    <p class="welcome-subtitle">
                        <c:choose>
                            <c:when test="${sessionScope.userRole == 'CANDIDATE'}">
                                Khám phá cơ hội nghề nghiệp phù hợp với bạn
                            </c:when>
                            <c:when test="${sessionScope.userRole == 'RECRUITER'}">
                                Tìm kiếm nhân tài cho tổ chức của bạn
                            </c:when>
                            <c:otherwise>
                                Quản lý hệ thống HireHub
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>
            </div>

            <!-- Stats Cards -->
            <div class="stats-grid animate-fadeInUp" style="animation-delay: 0.1s;">
                <div class="stat-card glass-card">
                    <div class="stat-icon" style="background: linear-gradient(135deg, #6366F1, #8B5CF6);">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2"><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"/></svg>
                    </div>
                    <div class="stat-info">
                        <h3>Đã ứng tuyển</h3>
                        <p class="stat-value">${countApplied != null ? countApplied : 0}</p>
                    </div>
                </div>

                <div class="stat-card glass-card">
                    <div class="stat-icon" style="background: linear-gradient(135deg, #F59E0B, #D97706);">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2"><path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"/></svg>
                    </div>
                    <div class="stat-info">
                        <h3>Việc làm đã lưu</h3>
                        <p class="stat-value">${countSaved != null ? countSaved : 0}</p>
                    </div>
                </div>

                <div class="stat-card glass-card">
                    <div class="stat-icon" style="background: linear-gradient(135deg, #10B981, #059669);">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
                    </div>
                    <div class="stat-info">
                        <h3>Lịch phỏng vấn</h3>
                        <p class="stat-value">${countInterviews != null ? countInterviews : 0}</p>
                    </div>
                </div>
            </div>

            <div class="dashboard-grid">
                <!-- Left Column: Activities -->
                <div class="dashboard-left animate-fadeInUp" style="animation-delay: 0.3s;">
                    <div class="section-header" style="margin-bottom: 20px;">
                        <h2>Đơn ứng tuyển gần đây</h2>
                        <a href="${pageContext.request.contextPath}/user/my-applications" class="auth-link">Xem tất cả</a>
                    </div>
                    
                    <c:choose>
                        <c:when test="${empty recentApplications}">
                            <div class="glass-card" style="padding: 40px; text-align: center;">
                                <p style="color: var(--text-muted);">Bạn chưa nộp đơn ứng tuyển nào.</p>
                                <a href="${pageContext.request.contextPath}/jobs" class="btn btn-primary" style="margin-top: 20px;">Tìm việc ngay</a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="app" items="${recentApplications}">
                                <div class="recent-app-item">
                                    <div>
                                        <div style="font-weight: 700; color: var(--text-primary);">${app.jobTitle}</div>
                                        <div style="font-size: 0.85rem; color: var(--primary);">${app.companyName}</div>
                                    </div>
                                    <div class="status-badge" style="background: rgba(99, 102, 241, 0.1); color: var(--primary);">
                                        ${app.status}
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>

                    <div class="section-header" style="margin-top: 40px; margin-bottom: 20px;">
                        <h2>Thao tác nhanh</h2>
                    </div>
                    <div class="actions-grid">
                        <a href="${pageContext.request.contextPath}/user/profile" class="action-card glass-card">
                            <div class="action-icon">
                                <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                            </div>
                            <h3>Xem hồ sơ</h3>
                            <p>Xem thông tin cá nhân của bạn</p>
                        </a>

                        <a href="${pageContext.request.contextPath}/user/edit-profile" class="action-card glass-card">
                            <div class="action-icon">
                                <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                            </div>
                            <h3>Chỉnh sửa hồ sơ</h3>
                            <p>Cập nhật thông tin cá nhân</p>
                        </a>

                        <a href="${pageContext.request.contextPath}/user/change-password" class="action-card glass-card">
                            <div class="action-icon">
                                <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                            </div>
                            <h3>Đổi mật khẩu</h3>
                            <p>Thay đổi mật khẩu bảo mật</p>
                        </a>
                    </div>
                </div>

                <!-- Right Column: Recommendations -->
                <div class="dashboard-right animate-fadeInUp" style="animation-delay: 0.4s;">
                    <div class="section-header" style="margin-bottom: 20px;">
                        <h2>Gợi ý cho bạn</h2>
                    </div>
                    
                    <c:choose>
                        <c:when test="${empty recommendations}">
                            <div class="glass-card" style="padding: 20px; text-align: center;">
                                <p style="font-size: 0.85rem; color: var(--text-muted);">Ứng tuyển thêm để nhận gợi ý chính xác hơn.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="job" items="${recommendations}">
                                <a href="${pageContext.request.contextPath}/job-detail?id=${job.jobId}" class="rec-item">
                                    <div style="font-weight: 700; color: var(--text-primary); margin-bottom: 4px;">${job.title}</div>
                                    <div style="font-size: 0.8rem; color: var(--primary); margin-bottom: 8px;">${job.companyName}</div>
                                    <div style="font-weight: 700; color: #10B981; font-size: 0.85rem;">
                                        <c:choose>
                                            <c:when test="${job.salaryMax > 0}">
                                                <fmt:formatNumber value="${job.salaryMin}" type="number" /> - <fmt:formatNumber value="${job.salaryMax}" type="number" />
                                            </c:when>
                                            <c:otherwise>Thỏa thuận</c:otherwise>
                                        </c:choose>
                                    </div>
                                </a>
                            </c:forEach>
                            <a href="${pageContext.request.contextPath}/jobs" class="btn btn-outline" style="width: 100%; margin-top: 10px;">Xem tất cả việc làm</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>


        </div>
    </main>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>

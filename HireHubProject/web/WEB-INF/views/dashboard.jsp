<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - HireHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .dashboard-layout { display: grid; grid-template-columns: 1fr 350px; gap: 30px; margin-top: 40px; }
        @media (max-width: 1024px) { .dashboard-layout { grid-template-columns: 1fr; } }
        
        .recent-apps-section { background: var(--bg-secondary); border: 1px solid var(--border-color); border-radius: 20px; padding: 24px; }
        .recent-app-item { display: flex; align-items: center; justify-content: space-between; padding: 16px; border-bottom: 1px solid var(--border-color); transition: all 0.2s; }
        .recent-app-item:last-child { border-bottom: none; }
        .recent-app-item:hover { background: rgba(255,255,255,0.02); }
        
        .status-badge { padding: 4px 12px; border-radius: 20px; font-size: 0.75rem; font-weight: 700; text-transform: uppercase; }
        .status-pending { background: rgba(245, 158, 11, 0.1); color: #F59E0B; }
        .status-offered { background: rgba(16, 185, 129, 0.1); color: #10B981; }
        .status-rejected { background: rgba(239, 68, 68, 0.1); color: #EF4444; }
        
        .recommend-job-card { background: var(--bg-secondary); border: 1px solid var(--border-color); border-radius: 16px; padding: 20px; margin-bottom: 16px; transition: all 0.3s; position: relative; overflow: hidden; }
        .recommend-job-card:hover { border-color: var(--primary); transform: translateY(-3px); box-shadow: 0 10px 30px rgba(0,0,0,0.1); }
        .recommend-job-card::before { content: ''; position: absolute; top: 0; left: 0; width: 4px; height: 100%; background: var(--primary); opacity: 0; transition: 0.3s; }
        .recommend-job-card:hover::before { opacity: 1; }
        
        .job-tag { font-size: 0.7rem; padding: 2px 8px; border-radius: 4px; background: rgba(99, 102, 241, 0.1); color: var(--primary); font-weight: 600; margin-bottom: 8px; display: inline-block; }
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
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                    </div>
                    <div class="stat-info">
                        <h3>Việc làm đã nộp</h3>
                        <p class="stat-value">${totalApplied != null ? totalApplied : 0}</p>
                    </div>
                </div>

                <div class="stat-card glass-card">
                    <div class="stat-icon" style="background: linear-gradient(135deg, #10B981, #059669);">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2"><path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"/></svg>
                    </div>
                    <div class="stat-info">
                        <h3>Việc làm đã lưu</h3>
                        <p class="stat-value">${totalSaved != null ? totalSaved : 0}</p>
                    </div>
                </div>

                <div class="stat-card glass-card">
                    <div class="stat-icon" style="background: linear-gradient(135deg, #F59E0B, #D97706);">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg>
                    </div>
                    <div class="stat-info">
                        <h3>Thông báo mới</h3>
                        <p class="stat-value">${totalNotifications != null ? totalNotifications : 0}</p>
                    </div>
                </div>
            </div>

            <div class="dashboard-layout animate-fadeInUp" style="animation-delay: 0.2s;">
                <!-- Main Activity Column -->
                <div class="main-column">
                    <div class="section-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                        <h2 style="font-size: 1.5rem; font-weight: 700;">Ứng tuyển gần đây</h2>
                        <a href="${pageContext.request.contextPath}/user/my-applications" style="color: var(--primary); font-size: 0.9rem; font-weight: 600;">Xem tất cả &rarr;</a>
                    </div>
                    
                    <div class="recent-apps-section">
                        <c:choose>
                            <c:when test="${empty recentApps}">
                                <div style="text-align: center; padding: 40px; color: var(--text-muted);">
                                    Bạn chưa có đơn ứng tuyển nào gần đây.
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="app" items="${recentApps}">
                                    <div class="recent-app-item">
                                        <div>
                                            <h4 style="font-size: 1.1rem; color: var(--text-primary); margin-bottom: 4px;">${app.jobTitle}</h4>
                                            <p style="font-size: 0.9rem; color: var(--primary); font-weight: 500;">${app.companyName}</p>
                                        </div>
                                        <div style="text-align: right;">
                                            <span class="status-badge ${app.status == 'PENDING' ? 'status-pending' : (app.status == 'OFFERED' ? 'status-offered' : 'status-rejected')}">
                                                ${app.status}
                                            </span>
                                            <p style="font-size: 0.8rem; color: var(--text-muted); margin-top: 8px;">
                                                <fmt:formatDate value="${app.appliedAt}" pattern="dd/MM/yyyy"/>
                                            </p>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Quick Actions Row -->
                    <div class="section-header" style="margin: 40px 0 20px 0;">
                        <h2 style="font-size: 1.5rem; font-weight: 700;">Thao tác nhanh</h2>
                    </div>
                    <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px;">
                        <a href="${pageContext.request.contextPath}/user/profile" class="action-card glass-card" style="padding: 24px; text-align: center;">
                            <div class="action-icon" style="margin: 0 auto 16px auto;"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg></div>
                            <h4 style="font-size: 0.95rem; font-weight: 700;">Hồ sơ</h4>
                        </a>
                        <a href="${pageContext.request.contextPath}/user/edit-profile" class="action-card glass-card" style="padding: 24px; text-align: center;">
                            <div class="action-icon" style="margin: 0 auto 16px auto;"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg></div>
                            <h4 style="font-size: 0.95rem; font-weight: 700;">Sửa</h4>
                        </a>
                        <a href="${pageContext.request.contextPath}/user/change-password" class="action-card glass-card" style="padding: 24px; text-align: center;">
                            <div class="action-icon" style="margin: 0 auto 16px auto;"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg></div>
                            <h4 style="font-size: 0.95rem; font-weight: 700;">Bảo mật</h4>
                        </a>
                    </div>
                </div>

                <!-- Right Sidebar: Recommended -->
                <aside class="sidebar">
                    <div class="section-header" style="margin-bottom: 20px;">
                        <h2 style="font-size: 1.3rem; font-weight: 700;">Gợi ý cho bạn</h2>
                    </div>
                    <c:forEach var="job" items="${recommendedJobs}">
                        <a href="${pageContext.request.contextPath}/job-detail?id=${job.jobId}" class="recommend-job-card" style="display: block; text-decoration: none;">
                            <div class="job-tag">Mới đăng</div>
                            <h4 style="color: var(--text-primary); font-size: 1rem; margin-bottom: 8px; line-height: 1.4; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                                ${job.title}
                            </h4>
                            <p style="color: var(--text-secondary); font-size: 0.85rem; margin-bottom: 16px; display: flex; align-items: center; gap: 6px;">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"></path></svg>
                                ${not empty job.companyName ? job.companyName : 'Công ty đang ẩn danh'}
                            </p>
                            <div style="display: flex; justify-content: space-between; align-items: center; padding-top: 12px; border-top: 1px dashed var(--border-color);">
                                <span style="color: #10B981; font-weight: 700; font-size: 0.9rem; display: flex; align-items: center; gap: 4px;">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="6" width="20" height="12" rx="2"/><circle cx="12" cy="12" r="2"/><path d="M6 12h.01M18 12h.01"/></svg>
                                    ${job.formattedSalary}
                                </span>
                                <span style="color: var(--text-muted); font-size: 0.75rem;">Chi tiết &rarr;</span>
                            </div>
                        </a>
                    </c:forEach>
                    <a href="${pageContext.request.contextPath}/jobs" class="btn btn-outline" style="width: 100%; margin-top: 10px;">Xem thêm việc làm</a>
                </aside>
            </div>


        </div>
    </main>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>

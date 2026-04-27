<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Nhà tuyển dụng - HireHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* Thẻ thống kê lớn */
        .stat-card {
            background: var(--bg-secondary);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 28px;
            display: flex;
            align-items: center;
            gap: 20px;
            transition: transform 0.2s ease;
        }
        .stat-card:hover { transform: translateY(-4px); }
        .stat-icon {
            width: 64px;
            height: 64px;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }
        .stat-value {
            font-size: 2.2rem;
            font-weight: 800;
            color: var(--text-primary);
            line-height: 1;
        }
        .stat-label {
            font-size: 0.85rem;
            color: var(--text-muted);
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 6px;
        }
        .action-card {
            background: var(--bg-secondary);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 32px;
            transition: all 0.3s ease;
        }
        .action-card:hover { border-color: var(--primary); transform: translateY(-5px); box-shadow: 0 10px 30px rgba(0,0,0,0.1); }
        .action-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
        }

        .dashboard-grid { display: grid; grid-template-columns: 1fr 380px; gap: 30px; margin-top: 40px; align-items: start; }
        @media (max-width: 1024px) { .dashboard-grid { grid-template-columns: 1fr; } }

        .data-section { background: var(--bg-secondary); border: 1px solid var(--border-color); border-radius: 20px; padding: 24px; margin-bottom: 30px; }
        .data-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; padding-bottom: 16px; border-bottom: 1px solid var(--border-color); }
        
        .applicant-item { display: flex; align-items: center; gap: 16px; padding: 16px; border-bottom: 1px solid var(--border-color); transition: background 0.2s; border-radius: 12px; }
        .applicant-item:last-child { border-bottom: none; }
        .applicant-item:hover { background: rgba(255,255,255,0.02); }
        .applicant-avatar { width: 48px; height: 48px; border-radius: 12px; background: linear-gradient(135deg, var(--primary), #8B5CF6); display: flex; align-items: center; justify-content: center; font-weight: 800; color: white; box-shadow: 0 4px 12px rgba(99, 102, 241, 0.3); }
        
        .job-summary-item { padding: 16px; border: 1px solid var(--border-color); border-radius: 16px; margin-bottom: 12px; transition: all 0.3s; }
        .job-summary-item:hover { border-color: var(--primary); background: rgba(255,255,255,0.02); transform: translateX(5px); }
        
        .badge { padding: 6px 12px; border-radius: 8px; font-size: 0.7rem; font-weight: 800; text-transform: uppercase; letter-spacing: 0.5px; }
        .badge-pending { background: rgba(245, 158, 11, 0.1); color: #F59E0B; }
        .badge-interview { background: rgba(99, 102, 241, 0.1); color: #6366F1; }
        .badge-offered { background: rgba(16, 185, 129, 0.1); color: #10B981; }
        .badge-rejected { background: rgba(239, 68, 68, 0.1); color: #EF4444; }
        .badge-withdrawn { background: rgba(107, 114, 128, 0.1); color: #6B7280; }
    </style>
</head>
<body class="app-page">
    <jsp:include page="/WEB-INF/views/header.jsp" />

    <main class="main-content">
        <div class="container animate-fadeInUp">

            <!-- Tiêu đề trang -->
            <div style="margin-bottom: 40px;">
                <h1 style="font-size: 2rem; font-weight: 800; color: var(--text-primary); margin-bottom: 8px;">
                    Chào mừng, ${sessionScope.userFullName}!
                </h1>
                <p style="color: var(--text-secondary); font-size: 1.05rem;">
                    Đây là tổng quan hiệu quả tuyển dụng của bạn hôm nay.
                </p>
            </div>

            <!-- Thẻ thống kê -->
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-bottom: 40px;">
                <div class="stat-card" style="padding: 20px;">
                    <div class="stat-icon" style="background: rgba(99, 102, 241, 0.1); width: 48px; height: 48px;">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#6366F1" stroke-width="2"><rect x="2" y="7" width="20" height="14" rx="2" ry="2"></rect><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"></path></svg>
                    </div>
                    <div>
                        <div class="stat-label" style="font-size: 0.75rem;">Tin tuyển dụng</div>
                        <div class="stat-value" style="font-size: 1.5rem;">${totalJobs}</div>
                    </div>
                </div>

                <div class="stat-card" style="padding: 20px;">
                    <div class="stat-icon" style="background: rgba(16, 185, 129, 0.1); width: 48px; height: 48px;">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#10B981" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle></svg>
                    </div>
                    <div>
                        <div class="stat-label" style="font-size: 0.75rem;">Tổng ứng viên</div>
                        <div class="stat-value" style="font-size: 1.5rem;">${totalApplicants}</div>
                    </div>
                </div>

                <div class="stat-card" style="padding: 20px;">
                    <div class="stat-icon" style="background: rgba(245, 158, 11, 0.1); width: 48px; height: 48px;">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#F59E0B" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                    </div>
                    <div>
                        <div class="stat-label" style="font-size: 0.75rem;">Chờ duyệt</div>
                        <div class="stat-value" style="font-size: 1.5rem; color: #F59E0B;">${pendingApps}</div>
                    </div>
                </div>

                <div class="stat-card" style="padding: 20px;">
                    <div class="stat-icon" style="background: rgba(99, 102, 241, 0.1); width: 48px; height: 48px;">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#6366F1" stroke-width="2"><path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><polyline points="16 11 18 13 22 9"></polyline></svg>
                    </div>
                    <div>
                        <div class="stat-label" style="font-size: 0.75rem;">Đang phỏng vấn</div>
                        <div class="stat-value" style="font-size: 1.5rem; color: #6366F1;">${interviewApps}</div>
                    </div>
                </div>
            </div>

            <div class="dashboard-grid animate-fadeInUp" style="animation-delay: 0.2s;">
                <!-- Main Content: Recent Applicants -->
                <div class="main-content-column">
                    <div class="data-section">
                        <div class="data-header">
                            <h2 style="font-size: 1.3rem; font-weight: 700;">Ứng viên mới nhất</h2>
                            <a href="${pageContext.request.contextPath}/employer/applications" style="color: var(--primary); font-size: 0.9rem; font-weight: 600;">Xem tất cả</a>
                        </div>
                        <div class="applicants-list">
                            <c:choose>
                                <c:when test="${empty recentApplicants}">
                                    <p style="text-align: center; color: var(--text-muted); padding: 20px;">Chưa có ứng viên nào nộp đơn.</p>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="app" items="${recentApplicants}">
                                        <div class="applicant-item">
                                            <div class="applicant-avatar">
                                                ${app.candidateName != null && app.candidateName.length() > 0 ? app.candidateName.substring(0,1).toUpperCase() : '?'}
                                            </div>
                                            <div style="flex: 1;">
                                                <h4 style="font-size: 1.05rem; font-weight: 700; color: var(--text-primary); margin-bottom: 4px;">${app.candidateName}</h4>
                                                <p style="font-size: 0.85rem; color: var(--text-muted);">Ứng tuyển: <span style="color: var(--primary); font-weight: 600;">${app.jobTitle}</span></p>
                                            </div>
                                            <div style="text-align: right; min-width: 120px;">
                                                <c:set var="statusClass" value="badge-pending" />
                                                <c:if test="${app.status == 'INTERVIEWING' || app.status == 'INTERVIEW_ROUND_2'}"><c:set var="statusClass" value="badge-interview" /></c:if>
                                                <c:if test="${app.status == 'OFFERED'}"><c:set var="statusClass" value="badge-offered" /></c:if>
                                                <c:if test="${app.status == 'REJECTED'}"><c:set var="statusClass" value="badge-rejected" /></c:if>
                                                <c:if test="${app.status == 'WITHDRAWN'}"><c:set var="statusClass" value="badge-withdrawn" /></c:if>
                                                
                                                <span class="badge ${statusClass}">${app.status}</span>
                                                <p style="font-size: 0.75rem; color: var(--text-muted); margin-top: 8px; font-weight: 500;">
                                                    <fmt:formatDate value="${app.appliedAt}" pattern="dd/MM HH:mm"/>
                                                </p>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Manage Links Section -->
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                        <div class="action-card" style="padding: 24px;">
                            <div class="action-icon" style="background: rgba(99, 102, 241, 0.1); margin-bottom: 16px;"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#6366F1" stroke-width="2"><path d="M12 5v14M5 12h14"/></svg></div>
                            <h3 style="font-size: 1rem; margin-bottom: 8px;">Đăng tin mới</h3>
                            <a href="${pageContext.request.contextPath}/employer/jobs" class="btn btn-primary" style="padding: 8px 16px; font-size: 0.85rem;">Bắt đầu ngay</a>
                        </div>
                        <div class="action-card" style="padding: 24px;">
                            <div class="action-icon" style="background: rgba(16, 185, 129, 0.1); margin-bottom: 16px;"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#10B981" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle></svg></div>
                            <h3 style="font-size: 1rem; margin-bottom: 8px;">Quản lý ứng viên</h3>
                            <a href="${pageContext.request.contextPath}/employer/applications" class="btn btn-secondary" style="padding: 8px 16px; font-size: 0.85rem; background: rgba(16,185,129,0.1); color: #10B981; border: none;">Chi tiết</a>
                        </div>
                    </div>
                </div>

                <!-- Sidebar: Recent Jobs -->
                <aside class="sidebar-column">
                    <div class="data-section">
                        <div class="data-header">
                            <h2 style="font-size: 1.2rem; font-weight: 700;">Tin đăng gần đây</h2>
                        </div>
                        <div class="jobs-summary-list">
                            <c:forEach var="job" items="${recentJobs}">
                                <div class="job-summary-item">
                                    <h4 style="font-size: 0.95rem; color: var(--text-primary); margin-bottom: 6px;">${job.title}</h4>
                                    <div style="display: flex; justify-content: space-between; align-items: center; font-size: 0.8rem; color: var(--text-muted);">
                                        <span>${job.viewCount} lượt xem</span>
                                        <span style="color: #10B981; font-weight: 600;">${job.status}</span>
                                    </div>
                                </div>
                            </c:forEach>
                            <a href="${pageContext.request.contextPath}/employer/jobs" class="btn btn-outline" style="width: 100%; margin-top: 10px; font-size: 0.9rem;">Tất cả tin đăng</a>
                        </div>
                    </div>
                </aside>
            </div>

        </div>
    </main>
</body>
</html>

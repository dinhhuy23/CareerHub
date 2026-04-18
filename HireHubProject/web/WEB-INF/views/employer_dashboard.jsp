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
        /* Card hành động nhanh */
        .action-card {
            background: var(--bg-secondary);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 32px;
            transition: border-color 0.2s ease;
        }
        .action-card:hover { border-color: var(--primary); }
        .action-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
        }
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
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: 24px; margin-bottom: 40px;">

                <!-- Thống kê: Tin đang tuyển -->
                <div class="stat-card">
                    <div class="stat-icon" style="background: rgba(99, 102, 241, 0.15);">
                        <svg width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="#6366F1" stroke-width="2">
                            <rect x="2" y="7" width="20" height="14" rx="2" ry="2"></rect>
                            <path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"></path>
                        </svg>
                    </div>
                    <div>
                        <div class="stat-label">Tin đang tuyển</div>
                        <div class="stat-value">${totalJobs}</div>
                    </div>
                </div>

                <!-- Thống kê: Lượt xem -->
                <div class="stat-card">
                    <div class="stat-icon" style="background: rgba(6, 182, 212, 0.15);">
                        <svg width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="#06B6D4" stroke-width="2">
                            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                            <circle cx="12" cy="12" r="3"></circle>
                        </svg>
                    </div>
                    <div>
                        <div class="stat-label">Tổng lượt xem</div>
                        <div class="stat-value"><fmt:formatNumber value="${totalViews}" /></div>
                    </div>
                </div>

                <!-- Thống kê: Ứng viên -->
                <div class="stat-card">
                    <div class="stat-icon" style="background: rgba(16, 185, 129, 0.15);">
                        <svg width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="#10B981" stroke-width="2">
                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                            <circle cx="9" cy="7" r="4"></circle>
                            <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                            <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                        </svg>
                    </div>
                    <div>
                        <div class="stat-label">Ứng viên đã nộp</div>
                        <div class="stat-value">${totalApplicants}</div>
                    </div>
                </div>

            </div>

            <!-- Hành động nhanh -->
            <h2 style="font-size: 1.25rem; font-weight: 700; color: var(--text-primary); margin-bottom: 20px;">Quản lý nhanh</h2>
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 24px;">

                <!-- Card: Quản lý tin đăng -->
                <div class="action-card">
                    <div class="action-icon" style="background: rgba(99, 102, 241, 0.15);">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#6366F1" stroke-width="2">
                            <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                            <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                        </svg>
                    </div>
                    <h3 style="font-size: 1.1rem; font-weight: 700; color: var(--text-primary); margin-bottom: 10px;">Quản lý tin tuyển dụng</h3>
                    <p style="color: var(--text-secondary); margin-bottom: 24px; font-size: 0.95rem; line-height: 1.6;">
                        Đăng tin mới, chỉnh sửa hoặc đóng các vị trí đang tuyển dụng.
                    </p>
                    <a href="${pageContext.request.contextPath}/employer/jobs" class="btn btn-primary" style="display: inline-flex; align-items: center; gap: 8px;">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10"></circle>
                            <line x1="12" y1="8" x2="12" y2="16"></line>
                            <line x1="8" y1="12" x2="16" y2="12"></line>
                        </svg>
                        Quản lý tin
                    </a>
                </div>

                <!-- Card: Xem hồ sơ ứng tuyển -->
                <div class="action-card">
                    <div class="action-icon" style="background: rgba(16, 185, 129, 0.15);">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#10B981" stroke-width="2">
                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                            <circle cx="9" cy="7" r="4"></circle>
                            <polyline points="16 11 18 13 22 9"></polyline>
                        </svg>
                    </div>
                    <h3 style="font-size: 1.1rem; font-weight: 700; color: var(--text-primary); margin-bottom: 10px;">Hồ sơ ứng tuyển</h3>
                    <p style="color: var(--text-secondary); margin-bottom: 24px; font-size: 0.95rem; line-height: 1.6;">
                        Xem chi tiết hồ sơ, CV và phản hồi cho ứng viên đã nộp đơn.
                    </p>
                    <a href="${pageContext.request.contextPath}/employer/applications" class="btn btn-secondary" style="display: inline-flex; align-items: center; gap: 8px; background: rgba(16,185,129,0.15); color: #10B981; border: 1px solid rgba(16,185,129,0.3);">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                            <circle cx="12" cy="12" r="3"></circle>
                        </svg>
                        Duyệt hồ sơ (${totalApplicants})
                    </a>
                </div>

            </div>

        </div>
    </main>
</body>
</html>

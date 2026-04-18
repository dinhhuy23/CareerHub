<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Việc làm đã ứng tuyển - HireHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* Timeline trạng thái đơn ứng tuyển */
        .app-card {
            background: var(--bg-secondary);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 24px;
            margin-bottom: 16px;
            display: flex;
            gap: 20px;
            align-items: flex-start;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .app-card:hover {
            border-color: var(--primary);
            box-shadow: 0 4px 20px rgba(99,102,241,0.1);
        }
        .company-logo {
            width: 56px; height: 56px;
            border-radius: 12px;
            background: var(--bg-tertiary);
            border: 1px solid var(--border-color);
            display: flex; align-items: center; justify-content: center;
            font-size: 1.4rem; font-weight: 800;
            color: var(--primary);
            flex-shrink: 0;
        }
        .app-info { flex: 1; min-width: 0; }
        .app-job-title {
            font-size: 1.1rem; font-weight: 700;
            color: var(--text-primary); margin-bottom: 4px;
        }
        .app-company {
            font-size: 0.9rem; color: var(--primary);
            font-weight: 600; margin-bottom: 12px;
        }
        .app-meta {
            display: flex; align-items: center; gap: 16px;
            flex-wrap: wrap;
        }
        .app-meta span {
            font-size: 0.82rem; color: var(--text-muted);
            display: flex; align-items: center; gap: 5px;
        }
        /* Badge trạng thái */
        .status-badge {
            padding: 5px 14px; border-radius: 20px;
            font-size: 0.8rem; font-weight: 700;
            text-transform: uppercase; letter-spacing: 0.3px;
        }
        .status-PENDING     { background: rgba(245,158,11,0.15);  color: #F59E0B; }
        .status-REVIEWING   { background: rgba(99,102,241,0.15);  color: #6366F1; }
        .status-INTERVIEWING{ background: rgba(6,182,212,0.15);   color: #06B6D4; }
        .status-OFFERED     { background: rgba(16,185,129,0.15);  color: #10B981; }
        .status-REJECTED    { background: rgba(239,68,68,0.15);   color: #EF4444; }

        /* Timeline bar */
        .timeline-bar {
            display: flex; gap: 0; margin-top: 16px;
            border-radius: 8px; overflow: hidden;
            height: 6px; background: var(--bg-tertiary);
            width: 100%; max-width: 400px;
        }
        .timeline-step {
            flex: 1; height: 100%;
            background: var(--border-color);
            transition: background 0.3s;
        }
        .timeline-step.done { background: var(--primary); }
        .timeline-step.active { background: var(--accent); }
        .timeline-step.success { background: var(--success); }
        .timeline-step.error { background: var(--error); }

        .withdraw-btn {
            padding: 6px 14px; border-radius: 8px; font-size: 0.82rem;
            font-weight: 600; cursor: pointer; border: 1px solid var(--border-color);
            background: transparent; color: var(--text-muted);
            transition: all 0.2s;
        }
        .withdraw-btn:hover {
            border-color: var(--error); color: var(--error);
            background: var(--error-light);
        }
        .cv-link {
            display: inline-flex; align-items: center; gap: 6px;
            font-size: 0.82rem; color: var(--primary-light);
            font-weight: 600; text-decoration: none;
        }
        .cv-link:hover { text-decoration: underline; }
    </style>
</head>
<body class="app-page">
    <jsp:include page="/WEB-INF/views/header.jsp" />

    <main class="main-content">
        <div class="container animate-fadeInUp">

            <%-- Tiêu đề trang --%>
            <div style="margin-bottom: 32px;">
                <h1 style="font-size: 2rem; font-weight: 800; color: var(--text-primary); margin-bottom: 8px;">
                    Việc làm đã ứng tuyển
                </h1>
                <p style="color: var(--text-secondary);">
                    Theo dõi tiến trình xét duyệt hồ sơ của bạn theo thời gian thực.
                </p>
            </div>

            <%-- Thông báo thành công khi rút đơn --%>
            <c:if test="${param.success eq 'withdrawn'}">
                <div class="alert alert-success" style="margin-bottom: 20px;">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"></polyline></svg>
                    Đã rút đơn ứng tuyển thành công.
                </div>
            </c:if>
            <c:if test="${param.error eq 'cannot_withdraw'}">
                <div class="alert alert-error" style="margin-bottom: 20px;">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                    Không thể rút đơn. Chỉ rút được khi trạng thái còn là "Chờ duyệt".
                </div>
            </c:if>

            <%-- Trường hợp chưa ứng tuyển công việc nào --%>
            <c:if test="${empty applications}">
                <div class="glass-card" style="padding: 80px; text-align: center;">
                    <svg width="72" height="72" viewBox="0 0 24 24" fill="none" stroke="var(--text-muted)" stroke-width="1.2" style="margin-bottom: 20px;">
                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                        <polyline points="14 2 14 8 20 8"></polyline>
                        <line x1="16" y1="13" x2="8" y2="13"></line>
                        <line x1="16" y1="17" x2="8" y2="17"></line>
                    </svg>
                    <p style="font-size: 1.2rem; font-weight: 600; color: var(--text-primary); margin-bottom: 8px;">Chưa có đơn ứng tuyển nào</p>
                    <p style="color: var(--text-secondary); margin-bottom: 24px;">Hãy khám phá các cơ hội việc làm phù hợp và nộp đơn ngay hôm nay!</p>
                    <a href="${pageContext.request.contextPath}/jobs" class="btn btn-primary">Tìm việc ngay</a>
                </div>
            </c:if>

            <%-- Danh sách đơn ứng tuyển --%>
            <c:if test="${not empty applications}">
                <%-- Thống kê nhanh --%>
                <div style="display: flex; gap: 12px; margin-bottom: 28px; flex-wrap: wrap;">
                    <div style="background: var(--bg-secondary); border: 1px solid var(--border-color); border-radius: 10px; padding: 12px 20px;">
                        <span style="font-size: 0.8rem; color: var(--text-muted); display: block;">Tổng đã nộp</span>
                        <span style="font-size: 1.4rem; font-weight: 800; color: var(--text-primary);">${applications.size()}</span>
                    </div>
                </div>

                <c:forEach var="app" items="${applications}">
                    <div class="app-card">
                        <%-- Icon công ty (chữ cái đầu) --%>
                        <div class="company-logo">
                            ${app.companyName != null and app.companyName.length() > 0 ? app.companyName.substring(0,1).toUpperCase() : 'C'}
                        </div>

                        <div class="app-info">
                            <div class="app-job-title">
                                <a href="${pageContext.request.contextPath}/job-detail?id=${app.jobId}" style="color: inherit; text-decoration: none;">
                                    ${app.jobTitle}
                                </a>
                            </div>
                            <div class="app-company">${app.companyName}</div>

                            <div class="app-meta">
                                <%-- Ngày nộp --%>
                                <span>
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                                    Nộp ngày <fmt:formatDate value="${app.appliedAt}" pattern="dd/MM/yyyy"/>
                                </span>

                                <%-- Link CV --%>
                                <c:if test="${not empty app.cvUrl}">
                                    <a href="${app.cvUrl}" target="_blank" class="cv-link">
                                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline></svg>
                                        Xem CV
                                    </a>
                                </c:if>
                            </div>

                            <%-- Thanh tiến trình --%>
                            <div class="timeline-bar" style="margin-top: 14px;">
                                <div class="timeline-step ${app.status == 'PENDING' || app.status == 'REVIEWING' || app.status == 'INTERVIEWING' || app.status == 'OFFERED' || app.status == 'REJECTED' ? 'done' : ''}"></div>
                                <div class="timeline-step ${app.status == 'REVIEWING' || app.status == 'INTERVIEWING' || app.status == 'OFFERED' ? 'done' : (app.status == 'REJECTED' ? 'error' : '')}"></div>
                                <div class="timeline-step ${app.status == 'INTERVIEWING' || app.status == 'OFFERED' ? 'active' : (app.status == 'REJECTED' ? 'error' : '')}"></div>
                                <div class="timeline-step ${app.status == 'OFFERED' ? 'success' : (app.status == 'REJECTED' ? 'error' : '')}"></div>
                            </div>
                        </div>

                        <%-- Bên phải: Badge trạng thái + nút rút đơn --%>
                        <div style="display: flex; flex-direction: column; align-items: flex-end; gap: 10px; flex-shrink: 0;">
                            <span class="status-badge status-${app.status}">
                                <c:choose>
                                    <c:when test="${app.status == 'PENDING'}">⏳ Chờ duyệt</c:when>
                                    <c:when test="${app.status == 'REVIEWING'}">📋 Đang xem xét</c:when>
                                    <c:when test="${app.status == 'INTERVIEWING'}">📅 Phỏng vấn</c:when>
                                    <c:when test="${app.status == 'OFFERED'}">🎉 Trúng tuyển</c:when>
                                    <c:when test="${app.status == 'REJECTED'}">❌ Không phù hợp</c:when>
                                    <c:otherwise>${app.status}</c:otherwise>
                                </c:choose>
                            </span>

                            <%-- Chỉ cho rút đơn khi còn PENDING --%>
                            <c:if test="${app.status == 'PENDING'}">
                                <form action="${pageContext.request.contextPath}/user/my-applications" method="POST"
                                      onsubmit="return confirm('Bạn chắc chắn muốn rút đơn ứng tuyển này?')">
                                    <input type="hidden" name="action" value="withdraw">
                                    <input type="hidden" name="applicationId" value="${app.applicationId}">
                                    <button type="submit" class="withdraw-btn">Rút đơn</button>
                                </form>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </c:if>

        </div>
    </main>
</body>
</html>

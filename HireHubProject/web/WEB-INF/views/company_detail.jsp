<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>${company.companyName} - Hồ sơ công ty | HireHub</title>
                <meta name="description" content="${company.description}">
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                <style>
                    /* ── Cover Banner ── */
                    .company-cover {
                        width: 100%;
                        height: 220px;
                        background: linear-gradient(135deg, #1e1b4b 0%, #312e81 40%, #4c1d95 100%);
                        position: relative;
                        overflow: hidden;
                        border-radius: 0 0 var(--radius-xl) var(--radius-xl);
                    }

                    .company-cover::before {
                        content: '';
                        position: absolute;
                        inset: 0;
                        background: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23ffffff' fill-opacity='0.04'%3E%3Ccircle cx='30' cy='30' r='4'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E");
                    }

                    .cover-blob-1 {
                        position: absolute;
                        width: 300px;
                        height: 300px;
                        background: var(--primary);
                        filter: blur(80px);
                        opacity: 0.3;
                        top: -100px;
                        right: 10%;
                        border-radius: 50%;
                    }

                    .cover-blob-2 {
                        position: absolute;
                        width: 200px;
                        height: 200px;
                        background: var(--accent);
                        filter: blur(60px);
                        opacity: 0.25;
                        bottom: -80px;
                        left: 15%;
                        border-radius: 50%;
                    }

                    /* ── Profile Hero ── */
                    .profile-hero {
                        max-width: 1100px;
                        margin: 0 auto;
                        padding: 0 var(--space-lg);
                        position: relative;
                    }

                    .profile-hero-inner {
                        display: flex;
                        align-items: flex-end;
                        gap: var(--space-xl);
                        margin-top: -60px;
                        padding-bottom: var(--space-xl);
                        flex-wrap: wrap;
                    }

                    .company-logo-wrap {
                        width: 120px;
                        height: 120px;
                        flex-shrink: 0;
                        background: var(--bg-secondary);
                        border: 3px solid var(--glass-border);
                        border-radius: 20px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        overflow: hidden;
                        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.4);
                        position: relative;
                        z-index: 2;
                    }

                    .company-logo-wrap img {
                        width: 100%;
                        height: 100%;
                        object-fit: contain;
                    }

                    .company-initial-big {
                        font-size: 3rem;
                        font-weight: 800;
                        background: linear-gradient(135deg, var(--primary-light), var(--accent-light));
                        -webkit-background-clip: text;
                        -webkit-text-fill-color: transparent;
                        background-clip: text;
                    }

                    .hero-info {
                        flex: 1;
                        min-width: 260px;
                        padding-bottom: 8px;
                    }

                    .hero-info h1 {
                        font-size: 2rem;
                        font-weight: 800;
                        color: var(--text-primary);
                        margin-bottom: 10px;
                        line-height: 1.2;
                    }

                    .hero-tags {
                        display: flex;
                        flex-wrap: wrap;
                        gap: 10px;
                        margin-bottom: 14px;
                    }

                    .hero-tag {
                        display: inline-flex;
                        align-items: center;
                        gap: 6px;
                        padding: 5px 14px;
                        border-radius: var(--radius-full);
                        font-size: 0.8rem;
                        font-weight: 500;
                        background: rgba(255, 255, 255, 0.06);
                        border: 1px solid var(--glass-border);
                        color: var(--text-secondary);
                    }

                    .hero-tag svg {
                        flex-shrink: 0;
                    }

                    .hero-tag.verified {
                        background: rgba(16, 185, 129, 0.1);
                        border-color: rgba(16, 185, 129, 0.25);
                        color: var(--success);
                    }

                    /* ── Layout grid ── */
                    .detail-layout {
                        max-width: 1100px;
                        margin: 0 auto;
                        padding: 0 var(--space-lg) var(--space-3xl);
                        display: grid;
                        grid-template-columns: minmax(0, 2fr) 340px;
                        gap: var(--space-xl);
                        align-items: start;
                    }

                    @media (max-width: 900px) {
                        .detail-layout {
                            grid-template-columns: 1fr;
                        }
                    }

                    /* ── Section card ── */
                    .section-card {
                        background: var(--glass-bg);
                        backdrop-filter: var(--glass-blur);
                        -webkit-backdrop-filter: var(--glass-blur);
                        border: 1px solid var(--glass-border);
                        border-radius: var(--radius-xl);
                        padding: var(--space-xl);
                        box-shadow: var(--glass-shadow);
                        margin-bottom: var(--space-lg);
                        transition: border-color 0.2s;
                    }

                    .section-card:hover {
                        border-color: rgba(99, 102, 241, 0.2);
                    }

                    .section-heading {
                        font-size: 1.1rem;
                        font-weight: 700;
                        color: var(--text-primary);
                        margin-bottom: var(--space-lg);
                        padding-bottom: 12px;
                        border-bottom: 1px solid var(--glass-border);
                        display: flex;
                        align-items: center;
                        gap: 10px;
                    }

                    .section-heading-icon {
                        width: 32px;
                        height: 32px;
                        border-radius: var(--radius-sm);
                        background: var(--primary-100);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        color: var(--primary-light);
                        flex-shrink: 0;
                    }

                    /* ── About text ── */
                    .about-text {
                        color: var(--text-secondary);
                        line-height: 1.9;
                        font-size: 0.975rem;
                        white-space: pre-wrap;
                    }

                    /* ── Info list ── */
                    .info-list {
                        display: flex;
                        flex-direction: column;
                        gap: 0;
                    }

                    .info-row {
                        display: flex;
                        align-items: flex-start;
                        gap: 14px;
                        padding: 14px 0;
                        border-bottom: 1px solid rgba(255, 255, 255, 0.04);
                    }

                    .info-row:last-child {
                        border-bottom: none;
                        padding-bottom: 0;
                    }

                    .info-row:first-child {
                        padding-top: 0;
                    }

                    .info-icon {
                        width: 38px;
                        height: 38px;
                        flex-shrink: 0;
                        border-radius: 10px;
                        background: var(--primary-100);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        color: var(--primary-light);
                        margin-top: 1px;
                    }

                    .info-content {}

                    .info-label {
                        font-size: 0.75rem;
                        font-weight: 600;
                        text-transform: uppercase;
                        letter-spacing: 0.5px;
                        color: var(--text-muted);
                        margin-bottom: 3px;
                    }

                    .info-value {
                        font-size: 0.9375rem;
                        color: var(--text-primary);
                        font-weight: 500;
                    }

                    .info-value a {
                        color: var(--primary-light);
                    }

                    .info-value a:hover {
                        color: var(--accent-light);
                        text-decoration: underline;
                    }

                    /* ── Stats bar ── */
                    .stats-bar {
                        display: grid;
                        grid-template-columns: repeat(3, 1fr);
                        gap: 1px;
                        background: var(--glass-border);
                        border-radius: var(--radius-lg);
                        overflow: hidden;
                        margin-bottom: var(--space-lg);
                    }

                    .stat-item {
                        background: var(--glass-bg);
                        backdrop-filter: var(--glass-blur);
                        padding: var(--space-lg);
                        text-align: center;
                    }

                    .stat-num {
                        font-size: 1.6rem;
                        font-weight: 800;
                        background: linear-gradient(135deg, var(--primary-light), var(--accent-light));
                        -webkit-background-clip: text;
                        -webkit-text-fill-color: transparent;
                        background-clip: text;
                        display: block;
                    }

                    .stat-lbl {
                        font-size: 0.78rem;
                        color: var(--text-muted);
                        margin-top: 4px;
                        display: block;
                    }

                    /* ── Job cards ── */
                    .job-link {
                        display: block;
                        padding: 16px;
                        border: 1px solid var(--glass-border);
                        border-radius: var(--radius-md);
                        text-decoration: none;
                        transition: all 0.25s ease;
                        margin-bottom: 10px;
                        background: rgba(255, 255, 255, 0.02);
                    }

                    .job-link:hover {
                        border-color: var(--primary);
                        background: var(--primary-50);
                        transform: translateX(4px);
                    }

                    .job-link:last-child {
                        margin-bottom: 0;
                    }

                    .job-link-title {
                        font-weight: 700;
                        color: var(--text-primary);
                        font-size: 0.975rem;
                        margin-bottom: 6px;
                    }

                    .job-link-meta {
                        display: flex;
                        flex-wrap: wrap;
                        gap: 8px;
                    }

                    .job-meta-tag {
                        font-size: 0.78rem;
                        color: var(--text-muted);
                        background: var(--bg-tertiary);
                        padding: 3px 10px;
                        border-radius: 6px;
                    }

                    .job-meta-tag.salary {
                        background: var(--success-light);
                        color: var(--success);
                        font-weight: 600;
                    }

                    /* ── Empty state ── */
                    .empty-jobs {
                        text-align: center;
                        padding: var(--space-xl) 0;
                        color: var(--text-muted);
                    }

                    .empty-jobs svg {
                        opacity: 0.3;
                        margin-bottom: 12px;
                    }

                    /* ── Back button ── */
                    .back-btn {
                        display: inline-flex;
                        align-items: center;
                        gap: 8px;
                        padding: 8px 18px;
                        border-radius: var(--radius-full);
                        background: rgba(255, 255, 255, 0.06);
                        border: 1px solid var(--glass-border);
                        color: var(--text-secondary);
                        font-size: 0.875rem;
                        font-weight: 500;
                        text-decoration: none;
                        transition: all 0.2s;
                        margin-bottom: var(--space-xl);
                        max-width: 1100px;
                        margin-left: auto;
                        margin-right: auto;
                        display: flex;
                        width: fit-content;
                    }

                    .back-btn:hover {
                        background: var(--primary-50);
                        border-color: var(--primary);
                        color: var(--primary-light);
                        transform: translateX(-3px);
                    }

                    .back-btn-wrap {
                        max-width: 1100px;
                        margin: 0 auto;
                        padding: var(--space-lg) var(--space-lg) 0;
                    }

                    /* ── Status badge ── */
                    .company-status {
                        display: inline-flex;
                        align-items: center;
                        gap: 6px;
                        padding: 4px 12px;
                        border-radius: var(--radius-full);
                        font-size: 0.78rem;
                        font-weight: 700;
                        text-transform: uppercase;
                        letter-spacing: 0.5px;
                    }

                    .company-status.active {
                        background: var(--success-light);
                        color: var(--success);
                    }

                    .company-status.inactive {
                        background: var(--error-light);
                        color: var(--error);
                    }

                    .status-dot {
                        width: 7px;
                        height: 7px;
                        border-radius: 50%;
                        background: currentColor;
                    }

                    /* ── Jobs count badge ── */
                    .jobs-count-badge {
                        margin-left: auto;
                        background: var(--primary-100);
                        color: var(--primary-light);
                        font-size: 0.78rem;
                        font-weight: 700;
                        padding: 2px 10px;
                        border-radius: var(--radius-full);
                    }
                </style>
            </head>

            <body class="app-page">
                <jsp:include page="/WEB-INF/views/header.jsp" />

                <main>
                    <!-- Cover -->
                    <div class="company-cover">
                        <div class="cover-blob-1"></div>
                        <div class="cover-blob-2"></div>
                    </div>

                    <!-- Back button -->
                    <div class="back-btn-wrap">
                        <a href="${pageContext.request.contextPath}/jobs" class="back-btn">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                stroke-width="2">
                                <line x1="19" y1="12" x2="5" y2="12" />
                                <polyline points="12 19 5 12 12 5" />
                            </svg>
                            Quay lại việc làm
                        </a>
                    </div>

                    <!-- Hero -->
                    <div class="profile-hero">
                        <div class="profile-hero-inner animate-fadeInUp">
                            <div class="company-logo-wrap">
                                <c:choose>
                                    <c:when test="${not empty company.logoUrl}">
                                        <img src="${company.logoUrl}" alt="${company.companyName}">
                                    </c:when>
                                    <c:otherwise>
                                        <span
                                            class="company-initial-big">${company.companyName.substring(0,1).toUpperCase()}</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="hero-info">
                                <h1>${company.companyName}</h1>
                                <div class="hero-tags">
                                    <c:if test="${not empty company.industry}">
                                        <span class="hero-tag">
                                            <svg width="13" height="13" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <rect x="2" y="7" width="20" height="14" rx="2" />
                                                <path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16" />
                                            </svg>
                                            ${company.industry}
                                        </span>
                                    </c:if>
                                    <c:if test="${not empty company.companySize}">
                                        <span class="hero-tag">
                                            <svg width="13" height="13" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
                                                <circle cx="9" cy="7" r="4" />
                                                <path d="M23 21v-2a4 4 0 0 0-3-3.87" />
                                                <path d="M16 3.13a4 4 0 0 1 0 7.75" />
                                            </svg>
                                            ${company.companySize}
                                        </span>
                                    </c:if>
                                    <c:if test="${not empty company.foundedYear}">
                                        <span class="hero-tag">
                                            <svg width="13" height="13" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2">
                                                <rect x="3" y="4" width="18" height="18" rx="2" />
                                                <line x1="16" y1="2" x2="16" y2="6" />
                                                <line x1="8" y1="2" x2="8" y2="6" />
                                                <line x1="3" y1="10" x2="21" y2="10" />
                                            </svg>
                                            Thành lập ${company.foundedYear}
                                        </span>
                                    </c:if>
                                    <span class="hero-tag verified">
                                        <svg width="13" height="13" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2.5">
                                            <polyline points="20 6 9 17 4 12" />
                                        </svg>
                                        Đã xác minh
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Stats bar -->
                    <div style="max-width:1100px; margin: 0 auto; padding: 0 var(--space-lg) var(--space-lg);">
                        <div class="stats-bar animate-fadeInUp" style="animation-delay:0.1s;">
                            <div class="stat-item">
                                <span class="stat-num">${companyJobs.size()}</span>
                                <span class="stat-lbl">Vị trí đang tuyển</span>
                            </div>
                            <div class="stat-item">
                                <span class="stat-num">${not empty company.companySize ? company.companySize :
                                    '—'}</span>
                                <span class="stat-lbl">Quy mô nhân sự</span>
                            </div>
                            <div class="stat-item">
                                <span class="stat-num">${not empty company.foundedYear ? company.foundedYear :
                                    '—'}</span>
                                <span class="stat-lbl">Năm thành lập</span>
                            </div>
                        </div>
                    </div>

                    <!-- Main layout -->
                    <div class="detail-layout">

                        <!-- LEFT: About + Contact -->
                        <div>
                            <!-- About -->
                            <div class="section-card animate-fadeInUp" style="animation-delay:0.15s;">
                                <div class="section-heading">
                                    <div class="section-heading-icon">
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2">
                                            <circle cx="12" cy="12" r="10" />
                                            <line x1="12" y1="8" x2="12" y2="12" />
                                            <line x1="12" y1="16" x2="12.01" y2="16" />
                                        </svg>
                                    </div>
                                    Giới thiệu về công ty
                                </div>
                                <div class="about-text">
                                    <c:choose>
                                        <c:when test="${not empty company.description}">${company.description}</c:when>
                                        <c:otherwise><em style="color:var(--text-muted);">Chưa có thông tin giới
                                                thiệu.</em></c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <!-- Contact info -->
                            <div class="section-card animate-fadeInUp" style="animation-delay:0.2s;">
                                <div class="section-heading">
                                    <div class="section-heading-icon">
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2">
                                            <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z" />
                                            <circle cx="12" cy="10" r="3" />
                                        </svg>
                                    </div>
                                    Thông tin liên hệ
                                </div>
                                <div class="info-list">
                                    <c:if test="${not empty company.websiteUrl}">
                                        <div class="info-row">
                                            <div class="info-icon">
                                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <circle cx="12" cy="12" r="10" />
                                                    <line x1="2" y1="12" x2="22" y2="12" />
                                                    <path
                                                        d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z" />
                                                </svg>
                                            </div>
                                            <div class="info-content">
                                                <div class="info-label">Website</div>
                                                <div class="info-value"><a href="${company.websiteUrl}" target="_blank"
                                                        rel="noopener">${company.websiteUrl}</a></div>
                                            </div>
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty company.email}">
                                        <div class="info-row">
                                            <div class="info-icon">
                                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <path
                                                        d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z" />
                                                    <polyline points="22,6 12,13 2,6" />
                                                </svg>
                                            </div>
                                            <div class="info-content">
                                                <div class="info-label">Email</div>
                                                <div class="info-value"><a
                                                        href="mailto:${company.email}">${company.email}</a></div>
                                            </div>
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty company.phoneNumber}">
                                        <div class="info-row">
                                            <div class="info-icon">
                                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <path
                                                        d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07A19.5 19.5 0 0 1 4.69 12 19.79 19.79 0 0 1 1.6 3.42 2 2 0 0 1 3.58 1.25h3a2 2 0 0 1 2 1.72c.127.96.361 1.903.7 2.81a2 2 0 0 1-.45 2.11L7.91 8.96a16 16 0 0 0 6.09 6.09l1.08-.91a2 2 0 0 1 2.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0 1 22 16.92z" />
                                                </svg>
                                            </div>
                                            <div class="info-content">
                                                <div class="info-label">Số điện thoại</div>
                                                <div class="info-value">${company.phoneNumber}</div>
                                            </div>
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty company.addressLine}">
                                        <div class="info-row">
                                            <div class="info-icon">
                                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z" />
                                                    <polyline points="9 22 9 12 15 12 15 22" />
                                                </svg>
                                            </div>
                                            <div class="info-content">
                                                <div class="info-label">Địa chỉ</div>
                                                <div class="info-value">${company.addressLine}</div>
                                            </div>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>

                        <!-- RIGHT: Jobs -->
                        <div>
                            <div class="section-card animate-fadeInUp"
                                style="animation-delay:0.25s; position: sticky; top: 80px;">
                                <div class="section-heading">
                                    <div class="section-heading-icon">
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                            stroke="currentColor" stroke-width="2">
                                            <rect x="2" y="7" width="20" height="14" rx="2" />
                                            <path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16" />
                                        </svg>
                                    </div>
                                    Vị trí đang tuyển
                                    <span class="jobs-count-badge">${companyJobs.size()}</span>
                                </div>

                                <div>
                                    <c:choose>
                                        <c:when test="${not empty companyJobs}">
                                            <c:forEach var="job" items="${companyJobs}">
                                                <a href="${pageContext.request.contextPath}/job-detail?id=${job.jobId}"
                                                    class="job-link">
                                                    <div class="job-link-title">${job.title}</div>
                                                    <div class="job-link-meta">
                                                        <c:if test="${not empty job.locationName}">
                                                            <span class="job-meta-tag">📍 ${job.locationName}</span>
                                                        </c:if>
                                                        <c:if
                                                            test="${not empty job.salaryMin and not empty job.salaryMax}">
                                                            <span class="job-meta-tag salary">💰 ${job.salaryMin} –
                                                                ${job.salaryMax} ${job.currencyCode}</span>
                                                        </c:if>
                                                    </div>
                                                </a>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="empty-jobs">
                                                <svg width="48" height="48" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="1.5">
                                                    <rect x="2" y="7" width="20" height="14" rx="2" />
                                                    <path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16" />
                                                </svg>
                                                <p>Hiện chưa có tin tuyển dụng.</p>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                    </div>
                </main>
            </body>

            </html>
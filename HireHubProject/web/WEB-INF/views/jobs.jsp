<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tìm kiếm việc làm - HireHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>
        :root {
            color-scheme: dark;
        }

        .jobs-page-shell {
            display: flex;
            flex-direction: column;
            gap: 28px;
        }

        .jobs-hero {
            position: relative;
            overflow: hidden;
            padding: 32px;
            border-radius: 28px;
            background:
                radial-gradient(circle at top right, rgba(99,102,241,0.18), transparent 28%),
                radial-gradient(circle at bottom left, rgba(16,185,129,0.12), transparent 32%),
                rgba(255,255,255,0.03);
            border: 1px solid rgba(255,255,255,0.08);
            box-shadow: 0 18px 48px rgba(0,0,0,0.35);
            backdrop-filter: blur(18px);
            -webkit-backdrop-filter: blur(18px);
        }

        .jobs-hero::before {
            content: "";
            position: absolute;
            right: -70px;
            top: -70px;
            width: 220px;
            height: 220px;
            border-radius: 50%;
            background: rgba(99,102,241,0.15);
            filter: blur(42px);
            pointer-events: none;
        }

        .jobs-hero-top {
            position: relative;
            z-index: 1;
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 20px;
            flex-wrap: wrap;
            margin-bottom: 22px;
        }

        .jobs-hero-text h1 {
            font-size: 3rem;
            line-height: 1.06;
            font-weight: 800;
            letter-spacing: -0.03em;
            margin-bottom: 10px;
        }

        .jobs-hero-text p {
            color: var(--text-secondary);
            font-size: 1.05rem;
            max-width: 720px;
        }

        .jobs-hero-badge {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 12px 16px;
            border-radius: 999px;
            background: rgba(255,255,255,0.05);
            border: 1px solid rgba(255,255,255,0.07);
            color: var(--text-secondary);
            font-weight: 600;
        }

        .jobs-search-card {
            position: relative;
            z-index: 1;
            padding: 24px;
            border-radius: 26px;
            background: rgba(6, 10, 24, 0.92);
            border: 1px solid rgba(255,255,255,0.06);
            box-shadow: inset 0 1px 0 rgba(255,255,255,0.03);
        }

        .jobs-search-grid {
            display: grid;
            grid-template-columns: 1.7fr 1fr 1fr 1fr auto auto;
            gap: 14px;
            align-items: end;
        }

        .jobs-input-wrap {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .jobs-label {
            font-size: 0.92rem;
            color: #94a3b8;
            font-weight: 700;
        }

        .jobs-input {
            width: 100%;
            min-height: 56px;
            padding: 0 18px;
            border-radius: 18px;
            border: 1px solid rgba(255,255,255,0.08);
            background: #111827;
            color: #ffffff;
            outline: none;
            transition: border-color 0.2s ease, box-shadow 0.2s ease, transform 0.2s ease;
        }

        .jobs-input::placeholder {
            color: #7c8aa5;
        }

        .jobs-input:focus {
            border-color: rgba(129,140,248,0.45);
            box-shadow: 0 0 0 4px rgba(99,102,241,0.12);
        }

        .jobs-select-wrap {
            position: relative;
        }

        .jobs-select-wrap::after {
            content: "";
            position: absolute;
            right: 18px;
            top: 50%;
            width: 10px;
            height: 10px;
            border-right: 2px solid #cbd5e1;
            border-bottom: 2px solid #cbd5e1;
            transform: translateY(-60%) rotate(45deg);
            pointer-events: none;
        }

        .jobs-select {
            width: 100%;
            min-height: 56px;
            padding: 0 44px 0 18px;
            border-radius: 18px;
            border: 1px solid rgba(255,255,255,0.08);
            background: #111827 !important;
            color: #ffffff !important;
            outline: none;
            appearance: none;
            -webkit-appearance: none;
            -moz-appearance: none;
            transition: border-color 0.2s ease, box-shadow 0.2s ease;
        }

        .jobs-select:focus {
            border-color: rgba(129,140,248,0.45);
            box-shadow: 0 0 0 4px rgba(99,102,241,0.12);
        }

        .jobs-select option,
        .jobs-select optgroup {
            background: #111827 !important;
            color: #ffffff !important;
        }

        .jobs-search-btn,
        .jobs-reset-btn {
            min-height: 56px;
            border-radius: 18px;
            padding: 0 22px;
            font-weight: 700;
            white-space: nowrap;
        }

        .jobs-reset-btn {
            background: #111827;
            border: 1px solid rgba(255,255,255,0.08);
            color: #ffffff;
        }

        .jobs-reset-btn:hover {
            border-color: rgba(255,255,255,0.16);
            color: #ffffff;
        }

        .jobs-summary {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            flex-wrap: wrap;
        }

        .jobs-summary h2 {
            font-size: 2rem;
            font-weight: 800;
            letter-spacing: -0.02em;
        }

        .jobs-summary h2 span {
            color: #A78BFA;
        }

        .jobs-summary-meta {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 10px 14px;
            border-radius: 999px;
            background: rgba(255,255,255,0.03);
            border: 1px solid rgba(255,255,255,0.06);
            color: var(--text-secondary);
            font-size: 0.95rem;
        }

        .jobs-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 22px;
        }

        .job-card-premium {
            position: relative;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            gap: 18px;
            min-height: 330px;
            padding: 22px;
            border-radius: 26px;
            background:
                linear-gradient(180deg, rgba(255,255,255,0.045), rgba(255,255,255,0.025)),
                rgba(16,18,36,0.86);
            border: 1px solid rgba(255,255,255,0.07);
            box-shadow: 0 14px 34px rgba(0,0,0,0.24);
            transition: transform 0.22s ease, border-color 0.22s ease, box-shadow 0.22s ease;
        }

        .job-card-premium:hover {
            transform: translateY(-5px);
            border-color: rgba(129,140,248,0.30);
            box-shadow: 0 18px 40px rgba(0,0,0,0.30);
        }

        .job-card-premium::after {
            content: "";
            position: absolute;
            right: -45px;
            top: -45px;
            width: 140px;
            height: 140px;
            border-radius: 50%;
            background: rgba(99,102,241,0.12);
            filter: blur(28px);
            pointer-events: none;
        }

        .job-card-top {
            display: flex;
            align-items: flex-start;
            gap: 16px;
        }

        .job-logo-badge {
            width: 72px;
            height: 72px;
            border-radius: 22px;
            flex-shrink: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            font-weight: 800;
            color: #7C83FF;
            background: linear-gradient(135deg, rgba(99,102,241,0.14), rgba(99,102,241,0.06));
            border: 1px solid rgba(255,255,255,0.06);
            box-shadow: inset 0 1px 0 rgba(255,255,255,0.05);
        }

        .job-card-title-wrap {
            flex: 1;
            min-width: 0;
        }

        .job-card-title {
            font-size: 1.55rem;
            line-height: 1.28;
            font-weight: 800;
            color: var(--text-primary);
            margin-bottom: 8px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .job-card-company {
            color: var(--text-secondary);
            font-size: 1rem;
            font-weight: 500;
            display: -webkit-box;
            -webkit-line-clamp: 1;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .job-save-btn {
            width: 50px;
            height: 50px;
            border-radius: 18px;
            border: 1px solid rgba(255,255,255,0.09);
            background: rgba(255,255,255,0.03);
            color: #8FA0C7;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.2s ease;
            flex-shrink: 0;
        }

        .job-save-btn:hover {
            transform: translateY(-2px);
            border-color: rgba(129,140,248,0.30);
            color: #A78BFA;
        }

        .job-save-btn.saved {
            color: #A78BFA;
            border-color: rgba(167,139,250,0.32);
            background: rgba(167,139,250,0.10);
        }

        .job-tag-row {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .job-chip {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 9px 12px;
            border-radius: 999px;
            background: rgba(255,255,255,0.04);
            border: 1px solid rgba(255,255,255,0.05);
            color: var(--text-secondary);
            font-size: 0.9rem;
            font-weight: 600;
        }

       .job-salary-wrap {
    display: flex;
    flex-direction: column;
    gap: 10px;
}

.job-salary-label {
    display: inline-flex;
    align-items: center;
    width: fit-content;
    padding: 6px 12px;
    border-radius: 999px;
    background: rgba(255,255,255,0.04);
    border: 1px solid rgba(255,255,255,0.06);
    color: #94a3b8;
    font-size: 0.85rem;
    font-weight: 700;
    letter-spacing: 0.02em;
    text-transform: uppercase;
}

.job-salary-box {
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    gap: 6px;
    width: 100%;
    padding: 16px 18px;
    border-radius: 20px;
    background:
        linear-gradient(135deg, rgba(16,185,129,0.10), rgba(6,182,212,0.08)),
        rgba(10, 25, 27, 0.72);
    border: 1px solid rgba(45, 212, 191, 0.18);
    box-shadow:
        inset 0 1px 0 rgba(255,255,255,0.04),
        0 10px 22px rgba(0,0,0,0.18);
}

.job-salary-value {
    color: #2dd4bf;
    font-size: 1.95rem;
    font-weight: 800;
    line-height: 1.1;
    letter-spacing: -0.02em;
    word-break: break-word;
}

.job-salary-unit {
    color: #9fb3c8;
    font-size: 0.88rem;
    font-weight: 600;
}

@media (max-width: 640px) {
    .job-salary-value {
        font-size: 1.55rem;
    }
}
        .job-card-desc {
            color: var(--text-secondary);
            line-height: 1.7;
            font-size: 0.98rem;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
            min-height: 76px;
        }

        .job-card-footer {
            margin-top: auto;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            flex-wrap: wrap;
            padding-top: 16px;
            border-top: 1px solid rgba(255,255,255,0.05);
        }

        .job-footer-left {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .job-footer-pill {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 13px;
            border-radius: 14px;
            background: rgba(255,255,255,0.03);
            color: var(--text-secondary);
            font-size: 0.9rem;
            font-weight: 600;
        }

        .job-detail-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 11px 16px;
            border-radius: 14px;
            background: rgba(99,102,241,0.12);
            border: 1px solid rgba(99,102,241,0.20);
            color: #A5B4FC;
            font-weight: 700;
            text-decoration: none;
            transition: all 0.2s ease;
        }

        .job-detail-link:hover {
            transform: translateY(-2px);
            color: white;
            border-color: rgba(129,140,248,0.32);
            box-shadow: 0 10px 24px rgba(99,102,241,0.20);
        }

        .jobs-empty {
            padding: 54px 28px;
            text-align: center;
            border-radius: 28px;
            background: rgba(255,255,255,0.03);
            border: 1px dashed rgba(255,255,255,0.14);
        }

        .jobs-empty-icon {
            width: 82px;
            height: 82px;
            margin: 0 auto 18px;
            border-radius: 24px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(99,102,241,0.12);
            color: #A5B4FC;
        }

        .jobs-empty h3 {
            font-size: 1.5rem;
            margin-bottom: 8px;
        }

        .jobs-empty p {
            color: var(--text-secondary);
            max-width: 560px;
            margin: 0 auto;
        }

        @media (max-width: 1280px) {
            .jobs-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .jobs-search-grid {
                grid-template-columns: 1.4fr 1fr 1fr;
            }
        }

        @media (max-width: 992px) {
            .jobs-hero {
                padding: 24px;
            }

            .jobs-hero-text h1 {
                font-size: 2.35rem;
            }

            .jobs-search-grid {
                grid-template-columns: 1fr 1fr;
            }

            .jobs-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 640px) {
            .jobs-hero-text h1 {
                font-size: 1.95rem;
            }

            .jobs-search-grid {
                grid-template-columns: 1fr;
            }

            .jobs-summary h2 {
                font-size: 1.6rem;
            }

            .job-card-title {
                font-size: 1.28rem;
            }

            .job-salary-box {
                font-size: 1.45rem;
            }
        }
    </style>
</head>
<c:if test="${not empty deactivateAt}">
    <div style="color: orange;">
        Tài khoản sẽ bị khóa vào:
        <fmt:formatDate value="${deactivateAt}" pattern="HH:mm dd/MM/yyyy"/>
    </div>
</c:if>
<body class="app-page">
    
    <jsp:include page="/WEB-INF/views/header.jsp" />

    <main class="main-content">
        <div class="container animate-fadeInUp jobs-page-shell">

            <section class="jobs-hero">
                <div class="jobs-hero-top">
                    <div class="jobs-hero-text">
                        <h1>Tìm kiếm việc làm phù hợp</h1>
                        <p>
                            Khám phá các vị trí tuyển dụng mới nhất, lọc nhanh theo kỹ năng, địa điểm,
                            hình thức làm việc và yêu cầu kinh nghiệm để tìm đúng công việc phù hợp.
                        </p>
                    </div>

                    <div class="jobs-hero-badge">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="11" cy="11" r="8"></circle>
                            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                        </svg>
                        HireHub Job Explorer
                    </div>
                </div>

                <form action="${pageContext.request.contextPath}/jobs" method="get" class="jobs-search-card">
                    <div class="jobs-search-grid">

                        <div class="jobs-input-wrap">
                            <label class="jobs-label">Từ khóa</label>
                            <input
                                type="text"
                                name="keyword"
                                class="jobs-input"
                                placeholder="Tên công việc, kỹ năng, công ty..."
                                value="${fn:escapeXml(param.keyword)}">
                        </div>

                        <div class="jobs-input-wrap">
                            <label class="jobs-label">Địa điểm</label>
                            <div class="jobs-select-wrap">
                                <select name="locationId" class="jobs-select">
                                    <option value="">Tất cả địa điểm</option>
                                    <c:forEach items="${locations}" var="loc">
                                        <option value="${loc.locationId}" ${param.locationId == loc.locationId ? 'selected' : ''}>
                                            ${loc.locationName}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="jobs-input-wrap">
                            <label class="jobs-label">Hình thức</label>
                            <div class="jobs-select-wrap">
                                <select name="employmentTypeId" class="jobs-select">
                                    <option value="">Tất cả hình thức</option>
                                    <c:forEach items="${employmentTypes}" var="type">
                                        <option value="${type.employmentTypeId}" ${param.employmentTypeId == type.employmentTypeId ? 'selected' : ''}>
                                            ${type.typeName}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="jobs-input-wrap">
                            <label class="jobs-label">Kinh nghiệm</label>
                            <div class="jobs-select-wrap">
                                <select name="experienceLevelId" class="jobs-select">
                                    <option value="">Tất cả mức kinh nghiệm</option>
                                    <c:forEach items="${experienceLevels}" var="lvl">
                                        <option value="${lvl.experienceLevelId}" ${param.experienceLevelId == lvl.experienceLevelId ? 'selected' : ''}>
                                            ${lvl.levelName}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <button type="button"
                                class="jobs-reset-btn"
                                onclick="window.location.href='${pageContext.request.contextPath}/jobs'">
                            Xóa bộ lọc
                        </button>

                        <button type="submit" class="btn btn-primary jobs-search-btn">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="margin-right: 8px;">
                                <circle cx="11" cy="11" r="8"></circle>
                                <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                            </svg>
                            Tìm kiếm việc làm
                        </button>
                    </div>
                </form>
            </section>

            <section class="jobs-summary">
                <h2>Có <span>${empty jobs ? 0 : jobs.size()}</span> việc làm phù hợp</h2>
                <div class="jobs-summary-meta">
                    <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>
                        <polyline points="7 10 12 15 17 10"></polyline>
                        <line x1="12" y1="15" x2="12" y2="3"></line>
                    </svg>
                  
                </div>
            </section>

            <c:choose>
                <c:when test="${empty jobs}">
                    <div class="jobs-empty">
                        <div class="jobs-empty-icon">
                            <svg width="34" height="34" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <circle cx="11" cy="11" r="8"></circle>
                                <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                            </svg>
                        </div>
                        <h3>Chưa tìm thấy công việc phù hợp</h3>
                        <p>
                            Hãy thử đổi từ khóa, bỏ bớt điều kiện lọc hoặc mở rộng khu vực tìm kiếm
                            để xem thêm nhiều cơ hội việc làm hơn.
                        </p>
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="jobs-grid">
                        <c:forEach items="${jobs}" var="job">
                            <div class="job-card-premium">
                                <div class="job-card-top">
                                    <div class="job-logo-badge">
                                        <c:choose>
                                            <c:when test="${not empty job.companyName}">
                                                ${fn:substring(job.companyName, 0, 1)}
                                            </c:when>
                                            <c:when test="${not empty job.employerName}">
                                                ${fn:substring(job.employerName, 0, 1)}
                                            </c:when>
                                            <c:otherwise>H</c:otherwise>
                                        </c:choose>
                                    </div>

                                    <div class="job-card-title-wrap">
                                        <div class="job-card-title">${job.title}</div>
                                        <div class="job-card-company">
                                            <c:choose>
                                                <c:when test="${not empty job.companyName}">
                                                    ${job.companyName}
                                                </c:when>
                                                <c:otherwise>
                                                    ${job.employerName}
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>

                                    <c:if test="${sessionScope.userRole == 'CANDIDATE'}">
                                        <c:set var="isSaved" value="${savedJobIds != null && savedJobIds.contains(job.jobId)}" />
                                        <button type="button"
                                                id="save-btn-${job.jobId}"
                                                class="job-save-btn ${isSaved ? 'saved' : ''}"
                                                title="${isSaved ? 'Đã lưu việc làm' : 'Lưu việc làm'}"
                                                onclick="toggleSaveJob(${job.jobId})">
                                            <svg id="save-icon-${job.jobId}" width="24" height="24" viewBox="0 0 24 24" fill="${isSaved ? 'currentColor' : 'none'}" stroke="currentColor" stroke-width="2">
                                                <path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"></path>
                                            </svg>
                                        </button>
                                    </c:if>
                                </div>

                                <div class="job-tag-row">
                                    <div class="job-chip">
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <ellipse cx="12" cy="5" rx="9" ry="3"></ellipse>
                                            <path d="M21 12c0 1.66-4 3-9 3s-9-1.34-9-3"></path>
                                            <path d="M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5"></path>
                                        </svg>
                                        ${job.categoryName != null ? job.categoryName : 'Khác'}
                                    </div>

                                    <div class="job-chip">
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                                            <circle cx="12" cy="10" r="3"></circle>
                                        </svg>
                                        ${job.locationName}
                                    </div>

                                    <c:if test="${not empty job.experienceLevelName}">
                                        <div class="job-chip">
                                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                <circle cx="12" cy="12" r="10"></circle>
                                                <polyline points="12 6 12 12 16 14"></polyline>
                                            </svg>
                                            ${job.experienceLevelName}
                                        </div>
                                    </c:if>

                                    <c:if test="${not empty job.employmentTypeName}">
                                        <div class="job-chip">
                                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                <rect x="2" y="7" width="20" height="14" rx="2" ry="2"></rect>
                                                <path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"></path>
                                            </svg>
                                            ${job.employmentTypeName}
                                        </div>
                                    </c:if>
                                </div>

                               <div class="job-salary-wrap">
    <div class="job-salary-label">Mức lương</div>

    <div class="job-salary-box">
        <div class="job-salary-value">
            <c:choose>
                <c:when test="${job.salaryMin != null && job.salaryMax != null}">
                    <fmt:formatNumber value="${job.salaryMin}" maxFractionDigits="0" />
                    -
                    <fmt:formatNumber value="${job.salaryMax}" maxFractionDigits="0" />
                </c:when>
                <c:otherwise>
                    Thỏa thuận
                </c:otherwise>
            </c:choose>
        </div>

        <c:if test="${job.salaryMin != null && job.salaryMax != null}">
            <div class="job-salary-unit">VND / tháng</div>
        </c:if>
    </div>
</div>

                                <div class="job-card-desc">
                                    <c:choose>
                                        <c:when test="${not empty job.description}">
                                            ${job.description}
                                        </c:when>
                                        <c:otherwise>
                                            Cơ hội việc làm hấp dẫn với môi trường chuyên nghiệp, chế độ đãi ngộ tốt và
                                            lộ trình phát triển rõ ràng dành cho ứng viên phù hợp.
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="job-card-footer">
                                    <div class="job-footer-left">
                                        <div class="job-footer-pill">
                                            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                <circle cx="12" cy="12" r="10"></circle>
                                                <polyline points="12 6 12 12 16 14"></polyline>
                                            </svg>
                                            Hạn nộp:
                                            <fmt:formatDate value="${job.deadlineAt}" pattern="dd/MM/yyyy"/>
                                        </div>

                                        <c:if test="${job.viewCount != null}">
                                            <div class="job-footer-pill">
                                                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                                                    <circle cx="12" cy="12" r="3"></circle>
                                                </svg>
                                                ${job.viewCount} lượt xem
                                            </div>
                                        </c:if>
                                    </div>

                                    <a class="job-detail-link" href="${pageContext.request.contextPath}/job-detail?id=${job.jobId}">
                                        Xem chi tiết
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <line x1="5" y1="12" x2="19" y2="12"></line>
                                            <polyline points="12 5 19 12 12 19"></polyline>
                                        </svg>
                                    </a>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>

        </div>
    </main>

    <script>
        function toggleSaveJob(jobId) {
            const btn = document.getElementById('save-btn-' + jobId);
            const icon = document.getElementById('save-icon-' + jobId);
            const isSaved = btn.classList.contains('saved');
            const action = isSaved ? 'unsave' : 'save';

            btn.style.opacity = '0.7';
            btn.style.pointerEvents = 'none';

            fetch('${pageContext.request.contextPath}/user/save-job', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'jobId=' + jobId + '&action=' + action
            })
            .then(async response => {
                const data = await response.json().catch(() => null);
                if (!data) {
                    throw new Error('Response không hợp lệ');
                }
                return data;
            })
            .then(data => {
                if (data.success) {
                    if (action === 'save') {
                        btn.classList.add('saved');
                        icon.setAttribute('fill', 'currentColor');
                        btn.setAttribute('title', 'Đã lưu việc làm');
                    } else {
                        btn.classList.remove('saved');
                        icon.setAttribute('fill', 'none');
                        btn.setAttribute('title', 'Lưu việc làm');
                    }
                } else {
                    alert('Có lỗi xảy ra: ' + (data.message || 'Update failed'));
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Không thể lưu việc làm lúc này.');
            })
            .finally(() => {
                btn.style.opacity = '1';
                btn.style.pointerEvents = 'auto';
            });
        }
    </script>
</body>
</html>
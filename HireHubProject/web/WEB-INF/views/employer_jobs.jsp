<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý tin tuyển dụng - HireHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>
        .jobs-page {
            display: flex;
            flex-direction: column;
            gap: 24px;
        }

        .jobs-hero {
            position: relative;
            overflow: hidden;
            padding: 32px;
            border-radius: 24px;
            background:
                radial-gradient(circle at top right, rgba(99,102,241,0.20), transparent 30%),
                radial-gradient(circle at bottom left, rgba(139,92,246,0.18), transparent 35%),
                rgba(255,255,255,0.04);
            border: 1px solid rgba(255,255,255,0.08);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            box-shadow: 0 16px 40px rgba(0,0,0,0.35);
        }

        .jobs-hero::before {
            content: "";
            position: absolute;
            right: -80px;
            top: -80px;
            width: 220px;
            height: 220px;
            border-radius: 50%;
            background: rgba(99,102,241,0.18);
            filter: blur(40px);
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
        }

        .jobs-hero h1 {
            font-size: 3rem;
            line-height: 1.1;
            font-weight: 800;
            margin-bottom: 10px;
            letter-spacing: -0.02em;
        }

        .jobs-hero p {
            color: var(--text-secondary);
            font-size: 1.05rem;
            max-width: 720px;
        }

        .jobs-add-btn {
            min-width: 200px;
            justify-content: center;
            border-radius: 18px;
            padding: 16px 22px;
            font-size: 1rem;
            font-weight: 700;
            box-shadow: 0 12px 30px rgba(99,102,241,0.35);
        }

        .jobs-stats {
            position: relative;
            z-index: 1;
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 16px;
            margin-top: 24px;
        }

        .jobs-stat-card {
            padding: 18px 20px;
            border-radius: 18px;
            background: rgba(255,255,255,0.04);
            border: 1px solid rgba(255,255,255,0.06);
        }

        .jobs-stat-label {
            color: var(--text-muted);
            font-size: 0.9rem;
            margin-bottom: 6px;
        }

        .jobs-stat-value {
            font-size: 1.6rem;
            font-weight: 800;
            color: var(--text-primary);
            line-height: 1.1;
        }

        .jobs-board {
            padding: 22px;
            border-radius: 24px;
        }

        .jobs-board-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            padding: 6px 4px 18px;
            border-bottom: 1px solid rgba(255,255,255,0.06);
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .jobs-board-title {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--text-primary);
        }

        .jobs-board-subtitle {
            color: var(--text-muted);
            font-size: 0.95rem;
        }

        .job-list {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .job-item {
            display: grid;
            grid-template-columns: minmax(0, 1.8fr) minmax(0, 1fr) auto;
            gap: 18px;
            align-items: center;
            padding: 20px;
            border-radius: 22px;
            background: linear-gradient(180deg, rgba(255,255,255,0.03), rgba(255,255,255,0.02));
            border: 1px solid rgba(255,255,255,0.06);
            transition: transform 0.2s ease, border-color 0.2s ease, box-shadow 0.2s ease;
        }

        .job-item:hover {
            transform: translateY(-2px);
            border-color: rgba(129,140,248,0.35);
            box-shadow: 0 12px 30px rgba(0,0,0,0.22);
        }

        .job-main {
            min-width: 0;
        }

        .job-title {
            font-size: 1.35rem;
            font-weight: 800;
            color: var(--text-primary);
            margin-bottom: 8px;
            line-height: 1.35;
        }

        .job-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 10px 14px;
            color: var(--text-secondary);
            font-size: 0.95rem;
        }

        .job-meta-pill {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 12px;
            border-radius: 999px;
            background: rgba(255,255,255,0.04);
            border: 1px solid rgba(255,255,255,0.05);
            white-space: nowrap;
        }

        .job-side {
            display: flex;
            flex-direction: column;
            gap: 10px;
            align-items: flex-start;
        }

        .job-status {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 14px;
            border-radius: 999px;
            font-weight: 700;
            font-size: 0.92rem;
            border: 1px solid transparent;
        }

        .job-status.published {
            color: #34D399;
            background: rgba(16,185,129,0.12);
            border-color: rgba(16,185,129,0.22);
        }

        .job-status.closed {
            color: #F59E0B;
            background: rgba(245,158,11,0.12);
            border-color: rgba(245,158,11,0.22);
        }

        .job-status.draft {
            color: #94A3B8;
            background: rgba(148,163,184,0.12);
            border-color: rgba(148,163,184,0.22);
        }

        .job-salary {
            font-size: 1.35rem;
            font-weight: 800;
            color: var(--success);
            line-height: 1.2;
        }

        .job-salary-sub {
            font-size: 0.88rem;
            color: var(--text-muted);
        }

        .job-mini-info {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .job-mini-card {
            min-width: 110px;
            padding: 10px 12px;
            border-radius: 16px;
            background: rgba(255,255,255,0.03);
            border: 1px solid rgba(255,255,255,0.05);
        }

        .job-mini-label {
            font-size: 0.8rem;
            color: var(--text-muted);
            margin-bottom: 3px;
        }

        .job-mini-value {
            font-size: 1rem;
            font-weight: 700;
            color: var(--text-primary);
        }

        .job-actions {
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 10px;
            flex-wrap: wrap;
        }

        .job-action-btn,
        .job-actions form button {
            width: 46px;
            height: 46px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 16px !important;
            padding: 0 !important;
            font-size: 0.9rem;
            transition: all 0.2s ease;
        }

        .job-action-btn:hover,
        .job-actions form button:hover {
            transform: translateY(-2px);
        }

        .btn-view {
            background: rgba(255,255,255,0.02);
            border: 1px solid rgba(255,255,255,0.08);
            color: var(--text-secondary);
        }

        .btn-view:hover {
            border-color: rgba(129,140,248,0.35);
            color: var(--primary-light);
        }

        .btn-edit {
            box-shadow: 0 10px 24px rgba(99,102,241,0.24);
        }

        .empty-jobs {
            padding: 48px 24px;
            text-align: center;
            border-radius: 22px;
            background: rgba(255,255,255,0.03);
            border: 1px dashed rgba(255,255,255,0.12);
        }

        .empty-jobs-icon {
            width: 72px;
            height: 72px;
            margin: 0 auto 18px;
            border-radius: 22px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(99,102,241,0.12);
            color: var(--primary-light);
        }

        .empty-jobs h3 {
            font-size: 1.35rem;
            margin-bottom: 8px;
        }

        .empty-jobs p {
            color: var(--text-secondary);
            margin-bottom: 20px;
        }

        @media (max-width: 1200px) {
            .job-item {
                grid-template-columns: 1fr;
                align-items: flex-start;
            }

            .job-actions {
                justify-content: flex-start;
            }
        }

        @media (max-width: 768px) {
            .jobs-hero {
                padding: 24px;
            }

            .jobs-hero h1 {
                font-size: 2.2rem;
            }

            .jobs-stats {
                grid-template-columns: 1fr;
            }

            .jobs-add-btn {
                width: 100%;
            }

            .job-title {
                font-size: 1.15rem;
            }

            .job-actions {
                width: 100%;
            }
        }
    </style>
</head>
<body class="app-page">
    <jsp:include page="/WEB-INF/views/header.jsp" />

    <main class="main-content">
        <div class="container animate-fadeInUp jobs-page">

            <div class="jobs-hero">
                <div class="jobs-hero-top">
                    <div>
                        <h1>Quản lý tin tuyển dụng</h1>
                        <p>
                            Theo dõi tất cả bài đăng của doanh nghiệp, chỉnh sửa nhanh thông tin,
                            đóng hoặc mở lại tin tuyển dụng ngay trên một màn hình.
                        </p>
                    </div>

                    <button onclick="openModal()" class="btn btn-primary jobs-add-btn">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <line x1="12" y1="5" x2="12" y2="19"></line>
                            <line x1="5" y1="12" x2="19" y2="12"></line>
                        </svg>
                        Đăng tin mới
                    </button>
                </div>

                <div class="jobs-stats">
                    <div class="jobs-stat-card">
                        <div class="jobs-stat-label">Tổng tin đăng</div>
                        <div class="jobs-stat-value">${empty jobs ? 0 : jobs.size()}</div>
                    </div>
                    <div class="jobs-stat-card">
                        <div class="jobs-stat-label">Trạng thái hiện tại</div>
                        <div class="jobs-stat-value" style="font-size: 1.2rem;">Đang quản lý tập trung</div>
                    </div>
                    <div class="jobs-stat-card">
                        <div class="jobs-stat-label">Thao tác</div>
                        <div class="jobs-stat-value" style="font-size: 1.2rem;">Xem · Sửa · Đóng · Xóa</div>
                    </div>
                </div>
            </div>

            <div class="glass-card jobs-board">
                <div class="jobs-board-header">
                    <div>
                        <div class="jobs-board-title">Danh sách bài đăng</div>
                        <div class="jobs-board-subtitle">Giao diện đã tối ưu lại để dễ nhìn và thuận thao tác hơn</div>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${empty jobs}">
                        <div class="empty-jobs">
                            <div class="empty-jobs-icon">
                                <svg width="34" height="34" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <rect x="3" y="4" width="18" height="16" rx="2"></rect>
                                    <line x1="8" y1="2" x2="8" y2="6"></line>
                                    <line x1="16" y1="2" x2="16" y2="6"></line>
                                    <line x1="3" y1="10" x2="21" y2="10"></line>
                                </svg>
                            </div>
                            <h3>Bạn chưa có tin tuyển dụng nào</h3>
                            <p>Hãy tạo bài đăng đầu tiên để bắt đầu nhận hồ sơ ứng viên.</p>
                            <button onclick="openModal()" class="btn btn-primary">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <line x1="12" y1="5" x2="12" y2="19"></line>
                                    <line x1="5" y1="12" x2="19" y2="12"></line>
                                </svg>
                                Đăng tin ngay
                            </button>
                        </div>
                    </c:when>

                    <c:otherwise>
                        <div class="job-list">
                            <c:forEach items="${jobs}" var="job">
                                <div class="job-item">
                                    <div class="job-main">
                                        <div class="job-title">${job.title}</div>

                                        <div class="job-meta" style="margin-bottom: 14px;">
                                            <div class="job-meta-pill">
                                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                    <ellipse cx="12" cy="5" rx="9" ry="3"></ellipse>
                                                    <path d="M21 12c0 1.66-4 3-9 3s-9-1.34-9-3"></path>
                                                    <path d="M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5"></path>
                                                </svg>
                                                ${job.categoryName}
                                            </div>

                                            <div class="job-meta-pill">
                                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                    <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                                                    <circle cx="12" cy="10" r="3"></circle>
                                                </svg>
                                                ${job.locationName}
                                            </div>
                                        </div>

                                        <div class="job-mini-info">
                                            <div class="job-mini-card">
                                                <div class="job-mini-label">Hết hạn</div>
                                                <div class="job-mini-value">
                                                    <fmt:formatDate value="${job.deadlineAt}" pattern="dd/MM/yyyy"/>
                                                </div>
                                            </div>

                                            <div class="job-mini-card">
                                                <div class="job-mini-label">Lượt xem</div>
                                                <div class="job-mini-value">${job.viewCount}</div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="job-side">
                                        <c:choose>
                                            <c:when test="${job.status == 'PUBLISHED'}">
                                                <span class="job-status published">
                                                    <span style="width:8px;height:8px;border-radius:50%;background:currentColor;display:inline-block;"></span>
                                                    Đang mở
                                                </span>
                                            </c:when>
                                            <c:when test="${job.status == 'CLOSED'}">
                                                <span class="job-status closed">
                                                    <span style="width:8px;height:8px;border-radius:50%;background:currentColor;display:inline-block;"></span>
                                                    Đã đóng
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="job-status draft">
                                                    <span style="width:8px;height:8px;border-radius:50%;background:currentColor;display:inline-block;"></span>
                                                    Bản nháp
                                                </span>
                                            </c:otherwise>
                                        </c:choose>

                                        <div class="job-salary">
                                            <c:if test="${job.salaryMax != null}">
                                                <fmt:formatNumber value="${job.salaryMin}" maxFractionDigits="0" />
                                                -
                                                <fmt:formatNumber value="${job.salaryMax}" maxFractionDigits="0" />
                                            </c:if>
                                            <c:if test="${job.salaryMax == null}">Thỏa thuận</c:if>
                                        </div>
                                        <div class="job-salary-sub">VND / tháng</div>
                                    </div>

                                    <div class="job-actions">
                                        <a href="${pageContext.request.contextPath}/job-detail?id=${job.jobId}" target="_blank"
                                           class="job-action-btn btn-view"
                                           title="Xem bài đăng">
                                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                                                <circle cx="12" cy="12" r="3"></circle>
                                            </svg>
                                        </a>

                                        <button class="btn btn-primary job-action-btn btn-edit" title="Sửa bài"
                                                onclick="openModal(this)"
                                                data-id="${job.jobId}"
                                                data-title="<c:out value='${job.title}'/>"
                                                data-category="${job.categoryId}"
                                                data-location="${job.locationId}"
                                                data-type="${job.employmentTypeId}"
                                                data-level="${job.experienceLevelId}"
                                                data-min="${job.salaryMin != null ? job.salaryMin.stripTrailingZeros().toPlainString() : ''}"
                                                data-max="${job.salaryMax != null ? job.salaryMax.stripTrailingZeros().toPlainString() : ''}"
                                                data-deadline="${not empty job.deadlineAt ? String.valueOf(job.deadlineAt).substring(0, 10) : ''}"
                                                data-status="${job.status}"
                                                data-desc="<c:out value='${job.description}'/>"
                                                data-req="<c:out value='${job.requirements}'/>"
                                                data-resp="<c:out value='${job.responsibilities}'/>">
                                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                                                <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                                            </svg>
                                        </button>

                                        <c:choose>
                                            <c:when test="${job.status == 'PUBLISHED'}">
                                                <form action="${pageContext.request.contextPath}/employer/jobs" method="post" style="display:inline;">
                                                    <input type="hidden" name="action" value="status">
                                                    <input type="hidden" name="id" value="${job.jobId}">
                                                    <input type="hidden" name="status" value="CLOSED">
                                                    <button type="submit" class="btn btn-outline text-warning"
                                                            style="border-color: var(--warning);"
                                                            title="Đóng bài đăng"
                                                            onclick="return confirm('Bạn có chắc chắn muốn ĐÓNG bài đăng này?');">
                                                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                            <path d="M18.36 6.64a9 9 0 1 1-12.73 0"></path>
                                                            <line x1="12" y1="2" x2="12" y2="12"></line>
                                                        </svg>
                                                    </button>
                                                </form>
                                            </c:when>

                                            <c:when test="${job.status == 'CLOSED'}">
                                                <form action="${pageContext.request.contextPath}/employer/jobs" method="post" style="display:inline;">
                                                    <input type="hidden" name="action" value="status">
                                                    <input type="hidden" name="id" value="${job.jobId}">
                                                    <input type="hidden" name="status" value="PUBLISHED">
                                                    <button type="submit" class="btn btn-outline text-success"
                                                            style="border-color: var(--success);"
                                                            title="Mở lại bài đăng"
                                                            onclick="return confirm('Bạn muốn MỞ LẠI và tiếp tục nhận hồ sơ cho bài đăng này?');">
                                                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                            <polyline points="1 4 1 10 7 10"></polyline>
                                                            <polyline points="23 20 23 14 17 14"></polyline>
                                                            <path d="M20.49 9A9 9 0 0 0 5.64 5.64L1 10m22 4l-4.64 4.36A9 9 0 0 1 3.51 15"></path>
                                                        </svg>
                                                    </button>
                                                </form>
                                            </c:when>

                                            <c:otherwise>
                                                <form action="${pageContext.request.contextPath}/employer/jobs" method="post" style="display:inline;">
                                                    <input type="hidden" name="action" value="status">
                                                    <input type="hidden" name="id" value="${job.jobId}">
                                                    <input type="hidden" name="status" value="PUBLISHED">
                                                    <button type="submit" class="btn btn-outline text-success"
                                                            style="border-color: var(--success);"
                                                            title="Đăng công khai"
                                                            onclick="return confirm('Bạn muốn đăng công khai bài tuyển dụng này?');">
                                                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                            <polyline points="1 4 1 10 7 10"></polyline>
                                                            <polyline points="23 20 23 14 17 14"></polyline>
                                                            <path d="M20.49 9A9 9 0 0 0 5.64 5.64L1 10m22 4l-4.64 4.36A9 9 0 0 1 3.51 15"></path>
                                                        </svg>
                                                    </button>
                                                </form>
                                            </c:otherwise>
                                        </c:choose>

                                        <form action="${pageContext.request.contextPath}/employer/jobs" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="status">
                                            <input type="hidden" name="id" value="${job.jobId}">
                                            <input type="hidden" name="status" value="DELETED">
                                            <button type="submit" class="btn btn-outline text-danger"
                                                    style="border-color: var(--error);"
                                                    title="Xóa bài đăng"
                                                    onclick="return confirm('Sau khi xóa không thể khôi phục. Tiếp tục?');">
                                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                    <polyline points="3 6 5 6 21 6"></polyline>
                                                    <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                                                </svg>
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>

    <!-- Modal Xem/Sửa -->
    <div id="jobModal" style="display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.4); backdrop-filter: blur(4px); z-index: 1000; overflow-y: auto; padding: 40px 20px;">
        <div class="glass-card animate-fadeInUp" style="position: relative; width: 100%; max-width: 900px; margin: 0 auto; padding: var(--space-2xl); background: var(--bg-secondary); border-radius: 16px; box-shadow: 0 20px 50px rgba(0,0,0,0.5);">
            <button onclick="closeModal()" type="button" style="position: absolute; top: 20px; right: 20px; background: none; border: none; color: var(--text-muted); cursor: pointer; padding: 8px;">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="18" y1="6" x2="6" y2="18"></line>
                    <line x1="6" y1="6" x2="18" y2="18"></line>
                </svg>
            </button>

            <h2 id="modalTitle" style="margin-bottom: var(--space-xl); font-size: 1.75rem;">Đăng tin tuyển dụng mới</h2>

            <form id="jobForm" action="${pageContext.request.contextPath}/employer/jobs" method="post" class="edit-form">
                <input type="hidden" name="jobId" id="modalJobId" value="">

                <div class="form-group">
                    <label class="form-label">Tiêu đề công việc <span class="required">*</span></label>
                    <input type="text" name="title" id="modalTitleInput" class="form-input" required style="padding-left: 14px;">
                </div>

                <div class="form-row" style="display: grid; grid-template-columns: 1fr 1fr; gap: var(--space-md);">
                    <div class="form-group">
                        <label class="form-label">Danh mục <span class="required">*</span></label>
                        <select name="categoryId" id="modalCategory" class="form-input form-select" required>
                            <option value="">Chọn danh mục</option>
                            <c:forEach items="${categories}" var="cat">
                                <option value="${cat.categoryId}">${cat.categoryName}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Địa điểm <span class="required">*</span></label>
                        <select name="locationId" id="modalLocation" class="form-input form-select" required>
                            <option value="">Chọn địa điểm</option>
                            <c:forEach items="${locations}" var="loc">
                                <option value="${loc.locationId}">${loc.locationName}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-row" style="display: grid; grid-template-columns: 1fr 1fr; gap: var(--space-md);">
                    <div class="form-group">
                        <label class="form-label">Hình thức <span class="required">*</span></label>
                        <select name="employmentTypeId" id="modalType" class="form-input form-select" required>
                            <option value="">Chọn hình thức</option>
                            <c:forEach items="${employmentTypes}" var="type">
                                <option value="${type.employmentTypeId}">${type.typeName}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Kinh nghiệm <span class="required">*</span></label>
                        <select name="experienceLevelId" id="modalLevel" class="form-input form-select" required>
                            <option value="">Chọn yêu cầu</option>
                            <c:forEach items="${experienceLevels}" var="lvl">
                                <option value="${lvl.experienceLevelId}">${lvl.levelName}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-row" style="display: grid; grid-template-columns: 1fr 1fr; gap: var(--space-md);">
                    <div class="form-group">
                        <label class="form-label">Mức lương tối thiểu (VND)</label>
                        <input type="number" name="salaryMin" id="modalMin" class="form-input" style="padding-left: 14px;">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Mức lương tối đa (VND)</label>
                        <input type="number" name="salaryMax" id="modalMax" class="form-input" style="padding-left: 14px;">
                    </div>
                </div>

                <div class="form-row" style="display: grid; grid-template-columns: 1fr 1fr; gap: var(--space-md);">
                    <div class="form-group">
                        <label class="form-label">Hạn nộp hồ sơ <span class="required">*</span></label>
                        <input type="date" name="deadlineAt" id="modalDeadline" class="form-input" required style="padding-left: 14px;">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Trạng thái <span class="required">*</span></label>
                        <select name="status" id="modalStatus" class="form-input form-select" required>
                            <option value="PUBLISHED">Công khai</option>
                            <option value="DRAFT">Bản nháp</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Mô tả công việc <span class="required">*</span></label>
                    <textarea name="description" id="modalDesc" class="form-input" rows="5" required style="padding: 14px;"></textarea>
                </div>

                <div class="form-group">
                    <label class="form-label">Yêu cầu ứng viên <span class="required">*</span></label>
                    <textarea name="requirements" id="modalReq" class="form-input" rows="5" required style="padding: 14px;"></textarea>
                </div>

                <div class="form-group">
                    <label class="form-label">Quyền lợi</label>
                    <textarea name="responsibilities" id="modalResp" class="form-input" rows="4" style="padding: 14px;"></textarea>
                </div>

                <div style="margin-top: var(--space-xl); display: flex; gap: var(--space-md); justify-content: flex-end;">
                    <button type="button" onclick="closeModal()" class="btn btn-outline">Hủy bỏ</button>
                    <button type="submit" class="btn btn-primary" style="padding: 14px 32px;">Lưu tin tuyển dụng</button>
                </div>
            </form>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
    <script>
        function openModal(btn) {
            const modal = document.getElementById('jobModal');
            document.body.style.overflow = 'hidden';
            modal.style.display = 'flex';

            if (btn) {
                document.getElementById('modalTitle').textContent = 'Chỉnh sửa tin tuyển dụng';
                document.getElementById('modalJobId').value = btn.getAttribute('data-id');
                document.getElementById('modalTitleInput').value = btn.getAttribute('data-title');
                document.getElementById('modalCategory').value = btn.getAttribute('data-category');
                document.getElementById('modalLocation').value = btn.getAttribute('data-location');
                document.getElementById('modalType').value = btn.getAttribute('data-type');
                document.getElementById('modalLevel').value = btn.getAttribute('data-level');
                document.getElementById('modalMin').value = btn.getAttribute('data-min');
                document.getElementById('modalMax').value = btn.getAttribute('data-max');
                document.getElementById('modalDeadline').value = btn.getAttribute('data-deadline');

                let s = btn.getAttribute('data-status');
                document.getElementById('modalStatus').value = (s === 'CLOSED') ? 'PUBLISHED' : s;

                document.getElementById('modalDesc').value = btn.getAttribute('data-desc');
                document.getElementById('modalReq').value = btn.getAttribute('data-req');
                document.getElementById('modalResp').value = btn.getAttribute('data-resp');
            } else {
                document.getElementById('modalTitle').textContent = 'Đăng tin tuyển dụng mới';
                document.getElementById('jobForm').reset();
                document.getElementById('modalJobId').value = '';
                document.getElementById('modalStatus').value = 'PUBLISHED';
            }
        }

        function closeModal() {
            document.getElementById('jobModal').style.display = 'none';
            document.body.style.overflow = 'auto';
        }
    </script>
</body>
</html>
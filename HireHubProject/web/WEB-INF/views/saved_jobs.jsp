<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Việc làm đã lưu - HireHub</title>
                    <link
                        href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
                        rel="stylesheet">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                    <style>
                        .job-card {
                            background: var(--bg-secondary);
                            border: 1px solid var(--border-color);
                            border-radius: 16px;
                            padding: 24px;
                            margin-bottom: 16px;
                            display: flex;
                            gap: 20px;
                            align-items: center;
                            transition: border-color 0.2s, box-shadow 0.2s, transform 0.2s;
                        }

                        .job-card:hover {
                            border-color: var(--primary);
                            box-shadow: 0 4px 20px rgba(99, 102, 241, 0.1);
                            transform: translateY(-2px);
                        }

                        .company-logo {
                            width: 64px;
                            height: 64px;
                            border-radius: 14px;
                            background: var(--bg-tertiary);
                            border: 1px solid var(--border-color);
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            font-size: 1.6rem;
                            font-weight: 800;
                            color: var(--primary);
                            flex-shrink: 0;
                        }

                        .job-info {
                            flex: 1;
                            min-width: 0;
                        }

                        .job-title {
                            font-size: 1.25rem;
                            font-weight: 700;
                            color: var(--text-primary);
                            margin-bottom: 4px;
                            text-decoration: none;
                            display: block;
                        }

                        .job-title:hover {
                            color: var(--primary-light);
                        }

                        .company-name {
                            font-size: 0.95rem;
                            color: var(--text-secondary);
                            font-weight: 500;
                            margin-bottom: 12px;
                        }

                        .job-meta {
                            display: flex;
                            align-items: center;
                            gap: 16px;
                            flex-wrap: wrap;
                        }

                        .job-meta span {
                            font-size: 0.85rem;
                            color: var(--text-muted);
                            display: flex;
                            align-items: center;
                            gap: 6px;
                        }

                        .salary-badge {
                            color: #10B981;
                            font-weight: 700;
                            font-size: 0.9rem;
                        }

                        .job-actions {
                            display: flex;
                            align-items: center;
                            gap: 12px;
                            flex-shrink: 0;
                        }

                        .favorite-btn {
                            background: none;
                            border: none;
                            padding: 8px;
                            cursor: pointer;
                            transition: transform 0.2s cubic-bezier(0.175, 0.885, 0.32, 1.275), color 0.2s;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            color: var(--text-muted);
                        }

                        .favorite-btn:hover {
                            transform: scale(1.18);
                        }

                        .favorite-btn.active {
                            color: #EF4444;
                        }

                        .favorite-btn.active svg {
                            fill: #EF4444;
                            stroke: #EF4444;
                        }

                        .unsave-btn {
                            background: rgba(239, 68, 68, 0.1);
                            color: #EF4444;
                            border: 1px solid rgba(239, 68, 68, 0.2);
                            padding: 8px 16px;
                            border-radius: 10px;
                            font-size: 0.85rem;
                            font-weight: 600;
                            cursor: pointer;
                            transition: all 0.2s;
                        }

                        .unsave-btn:hover {
                            background: rgba(239, 68, 68, 0.16);
                        }

                        .job-card.is-favorite {
                            border-left: 5px solid #F59E0B;
                            background: linear-gradient(90deg, rgba(245, 158, 11, 0.03) 0%, var(--bg-secondary) 100%);
                        }

                        .section-title {
                            font-size: 1.08rem;
                            font-weight: 800;
                            margin-bottom: 20px;
                            display: flex;
                            align-items: center;
                            gap: 8px;
                            letter-spacing: .2px;
                        }

                        .section-title.favorite {
                            color: #F59E0B;
                        }

                        .section-title.normal {
                            color: var(--text-secondary);
                        }

                        @media (max-width: 768px) {
                            .job-card {
                                flex-direction: column;
                                align-items: flex-start;
                            }

                            .job-actions {
                                width: 100%;
                                justify-content: flex-end;
                            }
                        }
                    </style>
                </head>

                <body class="app-page">
                    <jsp:include page="/WEB-INF/views/header.jsp" />

                    <main class="main-content">
                        <div class="container animate-fadeInUp">

                            <div style="margin-bottom: 32px;">
                                <h1
                                    style="font-size: 2.2rem; font-weight: 800; color: var(--text-primary); margin-bottom: 8px;">
                                    Danh sách đã lưu
                                </h1>
                                <p style="color: var(--text-secondary);">
                                    Nơi lưu trữ những cơ hội bạn quan tâm nhất. Bạn có thể bấm trái tim để đánh dấu ưu
                                    tiên.
                                </p>
                            </div>

                            <%-- Thanh công cụ tìm kiếm --%>
                            <form action="${pageContext.request.contextPath}/user/saved-jobs" method="GET" style="display: flex; gap: 16px; margin-bottom: 32px; flex-wrap: wrap;">
                                <input type="text" name="title" value="${param.title}" placeholder="Tìm theo tên công việc..." 
                                    style="padding: 12px 16px; border-radius: 12px; border: 1px solid var(--border-color); flex: 1; min-width: 200px; background: var(--bg-secondary); color: var(--text-primary); font-family: inherit; font-size: 0.95rem;">
                                <input type="text" name="company" value="${param.company}" placeholder="Tìm theo tên công ty..." 
                                    style="padding: 12px 16px; border-radius: 12px; border: 1px solid var(--border-color); flex: 1; min-width: 200px; background: var(--bg-secondary); color: var(--text-primary); font-family: inherit; font-size: 0.95rem;">
                                <input type="text" name="location" value="${param.location}" placeholder="Tìm theo địa điểm..." 
                                    style="padding: 12px 16px; border-radius: 12px; border: 1px solid var(--border-color); flex: 1; min-width: 200px; background: var(--bg-secondary); color: var(--text-primary); font-family: inherit; font-size: 0.95rem;">
                                <div style="display: flex; gap: 12px;">
                                    <button type="submit" class="btn btn-primary" style="padding: 12px 32px; border-radius: 12px; font-weight: 600;">Tìm kiếm</button>
                                    <c:if test="${not empty param.title or not empty param.company or not empty param.location}">
                                        <a href="${pageContext.request.contextPath}/user/saved-jobs" class="btn" style="padding: 12px 24px; border-radius: 12px; font-weight: 600; background: var(--bg-tertiary); color: var(--text-primary); text-decoration: none; display: flex; align-items: center; justify-content: center; border: 1px solid var(--border-color);">Xóa lọc</a>
                                    </c:if>
                                </div>
                            </form>

                            <c:if test="${empty savedJobs}">
                                <div class="glass-card"
                                    style="padding: 100px 40px; text-align: center; border-style: dashed;">
                                    <div
                                        style="width: 80px; height: 80px; background: rgba(99,102,241,0.1); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 24px;">
                                        <svg width="40" height="40" viewBox="0 0 24 24" fill="none"
                                            stroke="var(--primary)" stroke-width="1.5">
                                            <path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"></path>
                                        </svg>
                                    </div>
                                    <h3
                                        style="font-size: 1.4rem; font-weight: 700; color: var(--text-primary); margin-bottom: 12px;">
                                        Bạn chưa lưu việc làm nào</h3>
                                    <p
                                        style="color: var(--text-secondary); margin-bottom: 32px; max-width: 450px; margin-left: auto; margin-right: auto;">
                                        Lưu lại các tin tuyển dụng hấp dẫn để bạn có thể dễ dàng so sánh và nộp đơn sau
                                        này.
                                    </p>
                                    <a href="${pageContext.request.contextPath}/jobs" class="btn btn-primary"
                                        style="padding: 12px 32px;">Khám phá việc làm</a>
                                </div>
                            </c:if>

                            <c:if test="${not empty savedJobs}">
                                <c:set var="hasFavorite" value="false" />
                                <c:set var="hasNormal" value="false" />

                                <c:forEach var="sj" items="${savedJobs}">
                                    <c:if test="${sj.favorite}">
                                        <c:set var="hasFavorite" value="true" />
                                    </c:if>
                                    <c:if test="${!sj.favorite}">
                                        <c:set var="hasNormal" value="true" />
                                    </c:if>
                                </c:forEach>

                                <div class="saved-list">

                                    <c:if test="${hasFavorite}">
                                        <h3 class="section-title favorite">
                                            <svg width="20" height="20" viewBox="0 0 24 24" fill="#F59E0B">
                                                <path
                                                    d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z" />
                                            </svg>
                                            VIỆC LÀM ƯU TIÊN
                                        </h3>

                                        <c:forEach var="sj" items="${savedJobs}">
                                            <c:if test="${sj.favorite}">
                                                <div class="job-card is-favorite" id="job-card-${sj.jobId}">
                                                    <div class="company-logo">
                                                        <c:choose>
                                                            <c:when test="${not empty sj.job.companyName}">
                                                                ${fn:toUpperCase(fn:substring(sj.job.companyName, 0,
                                                                1))}
                                                            </c:when>
                                                            <c:otherwise>H</c:otherwise>
                                                        </c:choose>
                                                    </div>

                                                    <div class="job-info">
                                                        <a href="${pageContext.request.contextPath}/job-detail?id=${sj.jobId}"
                                                            class="job-title">${sj.job.title}</a>
                                                        <div class="company-name">${sj.job.companyName}</div>

                                                        <div class="job-meta">
                                                            <span class="salary-badge">
                                                                <c:choose>
                                                                    <c:when test="${sj.job.salaryMin != null and sj.job.salaryMax != null}">
                                                                        <fmt:formatNumber value="${sj.job.salaryMin}" maxFractionDigits="0" />
                                                                        -
                                                                        <fmt:formatNumber value="${sj.job.salaryMax}" maxFractionDigits="0" />
                                                                        ${sj.job.currencyCode}
                                                                    </c:when>
                                                                    <c:otherwise>Thỏa thuận</c:otherwise>
                                                                </c:choose>
                                                            </span>
                                                            <span>${sj.job.locationName}</span>
                                                        </div>
                                                    </div>

                                                    <div class="job-actions">
                                                        <button type="button" class="favorite-btn active"
                                                            onclick="toggleFavorite(${sj.jobId})" title="Bỏ ưu tiên">
                                                            <svg width="24" height="24" viewBox="0 0 24 24"
                                                                fill="currentColor" stroke="currentColor"
                                                                stroke-width="1.5">
                                                                <path
                                                                    d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l8.72-8.72 1.06-1.06a5.5 5.5 0 0 0 0-7.78z">
                                                                </path>
                                                            </svg>
                                                        </button>
                                                        <button type="button" class="unsave-btn"
                                                            onclick="unsaveJob(${sj.jobId})">Bỏ lưu</button>
                                                    </div>
                                                </div>
                                            </c:if>
                                        </c:forEach>

                                        <c:if test="${hasNormal}">
                                            <hr
                                                style="border: none; border-top: 1px dashed var(--border-color); margin: 40px 0;">
                                        </c:if>
                                    </c:if>

                                    <c:if test="${hasNormal}">
                                        <h3 class="section-title normal">DANH SÁCH KHÁC</h3>

                                        <c:forEach var="sj" items="${savedJobs}">
                                            <c:if test="${!sj.favorite}">
                                                <div class="job-card" id="job-card-${sj.jobId}">
                                                    <div class="company-logo">
                                                        <c:choose>
                                                            <c:when test="${not empty sj.job.companyName}">
                                                                ${fn:toUpperCase(fn:substring(sj.job.companyName, 0,
                                                                1))}
                                                            </c:when>
                                                            <c:otherwise>H</c:otherwise>
                                                        </c:choose>
                                                    </div>

                                                    <div class="job-info">
                                                        <a href="${pageContext.request.contextPath}/job-detail?id=${sj.jobId}"
                                                            class="job-title">${sj.job.title}</a>
                                                        <div class="company-name">${sj.job.companyName}</div>

                                                        <div class="job-meta">
                                                            <span class="salary-badge">
                                                                <c:choose>
                                                                    <c:when test="${sj.job.salaryMin != null and sj.job.salaryMax != null}">
                                                                        <fmt:formatNumber value="${sj.job.salaryMin}" maxFractionDigits="0" />
                                                                        -
                                                                        <fmt:formatNumber value="${sj.job.salaryMax}" maxFractionDigits="0" />
                                                                        ${sj.job.currencyCode}
                                                                    </c:when>
                                                                    <c:otherwise>Thỏa thuận</c:otherwise>
                                                                </c:choose>
                                                            </span>
                                                            <span>${sj.job.locationName}</span>
                                                        </div>
                                                    </div>

                                                    <div class="job-actions">
                                                        <button type="button" class="favorite-btn"
                                                            onclick="toggleFavorite(${sj.jobId})"
                                                            title="Đánh dấu ưu tiên">
                                                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2">
                                                                <path
                                                                    d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l8.72-8.72 1.06-1.06a5.5 5.5 0 0 0 0-7.78z">
                                                                </path>
                                                            </svg>
                                                        </button>
                                                        <button type="button" class="unsave-btn"
                                                            onclick="unsaveJob(${sj.jobId})">Bỏ lưu</button>
                                                    </div>
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                    </c:if>

                                </div>
                                
                                <%-- Component Phân trang --%>
                                <c:url var="pagedUrl" value="/user/saved-jobs">
                                    <c:if test="${not empty param.title}">
                                        <c:param name="title" value="${param.title}" />
                                    </c:if>
                                    <c:if test="${not empty param.company}">
                                        <c:param name="company" value="${param.company}" />
                                    </c:if>
                                    <c:if test="${not empty param.location}">
                                        <c:param name="location" value="${param.location}" />
                                    </c:if>
                                </c:url>
                                <jsp:include page="/WEB-INF/views/components/pagination.jsp">
                                    <jsp:param name="currentPage" value="${currentPage}" />
                                    <jsp:param name="totalPages" value="${totalPages}" />
                                    <jsp:param name="actionUrl" value="${pagedUrl}" />
                                </jsp:include>
                            </c:if>

                        </div>
                    </main>

                    <script>
                        function toggleFavorite(jobId) {
                            fetch('${pageContext.request.contextPath}/user/save-job', {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/x-www-form-urlencoded'
                                },
                                body: 'jobId=' + encodeURIComponent(jobId) + '&action=toggle-favorite'
                            })
                                .then(response => response.json())
                                .then(data => {
                                    if (data.success) {
                                        location.reload();
                                    } else {
                                        alert('Lỗi: ' + (data.message || 'Không thể cập nhật yêu thích'));
                                    }
                                })
                                .catch(error => {
                                    console.error('Error:', error);
                                    alert('Không thể kết nối đến server.');
                                });
                        }

                        function unsaveJob(jobId) {
                            if (!confirm('Bạn muốn bỏ lưu việc làm này?')) {
                                return;
                            }

                            fetch('${pageContext.request.contextPath}/user/save-job', {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/x-www-form-urlencoded'
                                },
                                body: 'jobId=' + encodeURIComponent(jobId) + '&action=unsave'
                            })
                                .then(response => response.json())
                                .then(data => {
                                    if (data.success) {
                                        const card = document.getElementById('job-card-' + jobId);
                                        if (card) {
                                            card.style.opacity = '0';
                                            card.style.transform = 'translateX(20px)';
                                            setTimeout(() => {
                                                location.reload();
                                            }, 250);
                                        } else {
                                            location.reload();
                                        }
                                    } else {
                                        alert('Có lỗi xảy ra: ' + (data.message || 'Không thể bỏ lưu'));
                                    }
                                })
                                .catch(error => {
                                    console.error('Error:', error);
                                    alert('Không thể thực hiện lúc này.');
                                });
                        }
                    </script>
                </body>

                </html>
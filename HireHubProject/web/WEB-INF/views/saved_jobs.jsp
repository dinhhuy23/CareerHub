<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Việc làm đã lưu - HireHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
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
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .job-card:hover {
            border-color: var(--primary);
            box-shadow: 0 4px 20px rgba(99,102,241,0.1);
        }
        .company-logo {
            width: 64px; height: 64px;
            border-radius: 14px;
            background: var(--bg-tertiary);
            border: 1px solid var(--border-color);
            display: flex; align-items: center; justify-content: center;
            font-size: 1.6rem; font-weight: 800;
            color: var(--primary);
            flex-shrink: 0;
        }
        .job-info { flex: 1; min-width: 0; }
        .job-title {
            font-size: 1.25rem; font-weight: 700;
            color: var(--text-primary); margin-bottom: 4px;
            text-decoration: none;
            display: block;
        }
        .job-title:hover { color: var(--primary-light); }
        .company-name {
            font-size: 0.95rem; color: var(--text-secondary);
            font-weight: 500; margin-bottom: 12px;
        }
        .job-meta {
            display: flex; align-items: center; gap: 16px;
            flex-wrap: wrap;
        }
        .job-meta span {
            font-size: 0.85rem; color: var(--text-muted);
            display: flex; align-items: center; gap: 6px;
        }
        .salary-badge {
            color: #10B981; font-weight: 700; font-size: 0.9rem;
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
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .unsave-btn:hover {
            background: #EF4444;
            color: white;
        }
    </style>
</head>
<body class="app-page">
    <jsp:include page="/WEB-INF/views/header.jsp" />

    <main class="main-content">
        <div class="container animate-fadeInUp">

            <%-- Tiêu đề trang --%>
            <div style="margin-bottom: 32px; display: flex; justify-content: space-between; align-items: flex-end;">
                <div>
                    <h1 style="font-size: 2.2rem; font-weight: 800; color: var(--text-primary); margin-bottom: 8px;">
                        Việc làm đã lưu
                    </h1>
                    <p style="color: var(--text-secondary);">
                        Danh sách các công việc bạn đã lưu để xem lại sau.
                    </p>
                </div>
                <div style="background: var(--bg-secondary); border: 1px solid var(--border-color); border-radius: 12px; padding: 10px 20px; text-align: center;">
                    <span style="font-size: 0.8rem; color: var(--text-muted); display: block; text-transform: uppercase; letter-spacing: 0.5px;">Tổng cộng</span>
                    <span style="font-size: 1.5rem; font-weight: 800; color: var(--primary);">${savedJobs.size()}</span>
                </div>
            </div>

            <%-- Trường hợp chưa lưu việc làm nào --%>
            <c:if test="${empty savedJobs}">
                <div class="glass-card" style="padding: 100px 40px; text-align: center; border-style: dashed;">
                    <div style="width: 80px; height: 80px; background: rgba(99,102,241,0.1); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 24px;">
                        <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="var(--primary)" stroke-width="1.5">
                            <path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"></path>
                        </svg>
                    </div>
                    <h3 style="font-size: 1.4rem; font-weight: 700; color: var(--text-primary); margin-bottom: 12px;">Bạn chưa lưu việc làm nào</h3>
                    <p style="color: var(--text-secondary); margin-bottom: 32px; max-width: 450px; margin-left: auto; margin-right: auto;">
                        Lưu lại các tin tuyển dụng hấp dẫn để bạn có thể dễ dàng so sánh và nộp đơn sau này.
                    </p>
                    <a href="${pageContext.request.contextPath}/jobs" class="btn btn-primary" style="padding: 12px 32px;">Khám phá việc làm</a>
                </div>
            </c:if>

            <%-- Danh sách việc làm đã lưu --%>
            <c:if test="${not empty savedJobs}">
                <div class="saved-list">
                    <c:forEach var="sj" items="${savedJobs}">
                        <div class="job-card" id="job-card-${sj.jobId}">
                            <div class="company-logo">
                                ${not empty sj.job.companyName ? sj.job.companyName.substring(0,1).toUpperCase() : 'H'}
                            </div>

                            <div class="job-info">
                                <a href="${pageContext.request.contextPath}/job-detail?id=${sj.jobId}" class="job-title">
                                    ${sj.job.title}
                                </a>
                                <div class="company-name">${sj.job.companyName}</div>

                                <div class="job-meta">
                                    <span class="salary-badge">
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="6" width="20" height="12" rx="2"/><circle cx="12" cy="12" r="2"/></svg>
                                        <c:choose>
                                            <c:when test="${sj.job.salaryMin != null && sj.job.salaryMax != null}">
                                                <fmt:formatNumber value="${sj.job.salaryMin}" maxFractionDigits="0" /> - <fmt:formatNumber value="${sj.job.salaryMax}" maxFractionDigits="0" />
                                            </c:when>
                                            <c:otherwise>Thỏa thuận</c:otherwise>
                                        </c:choose>
                                    </span>
                                    <span>
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>
                                        ${sj.job.locationName}
                                    </span>
                                    <span>
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                                        Lưu ngày <fmt:formatDate value="${sj.savedAt}" pattern="dd/MM/yyyy"/>
                                    </span>
                                </div>
                            </div>

                            <div class="job-actions">
                                <button type="button" class="unsave-btn" onclick="unsaveJob(${sj.jobId})">
                                    <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor" stroke="currentColor" stroke-width="2"><path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"></path></svg>
                                    Bỏ lưu
                                </button>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>

        </div>
    </main>

    <script>
        function unsaveJob(jobId) {
            if (!confirm('Bạn muốn bỏ lưu việc làm này?')) return;

            fetch('${pageContext.request.contextPath}/user/save-job', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'jobId=' + jobId + '&action=unsave'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    const card = document.getElementById('job-card-' + jobId);
                    card.style.opacity = '0';
                    card.style.transform = 'translateX(20px)';
                    setTimeout(() => {
                        card.remove();
                        if (document.querySelectorAll('.job-card').length === 0) {
                            location.reload();
                        }
                    }, 300);
                } else {
                    alert('Có lỗi xảy ra: ' + data.message);
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

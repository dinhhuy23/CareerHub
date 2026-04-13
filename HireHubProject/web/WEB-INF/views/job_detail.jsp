<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${job.title} - HireHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="app-page">
    <jsp:include page="/WEB-INF/views/header.jsp" />

    <main class="main-content">
        <div class="container animate-fadeInUp">
            
            <a href="${pageContext.request.contextPath}/jobs" class="btn btn-outline" style="margin-bottom: var(--space-xl); padding: 8px 16px; display: inline-flex; border-radius: 20px;">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="margin-right: 6px;"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>
                Quay lại
            </a>

            <!-- Job Header -->
            <div class="glass-card" style="padding: var(--space-2xl); margin-bottom: var(--space-xl); position: relative; overflow: hidden;">
                <!-- Decorative background elements -->
                <div style="position: absolute; right: -50px; top: -50px; width: 200px; height: 200px; background: var(--primary); filter: blur(60px); opacity: 0.15; border-radius: 50%;"></div>
                
                <div style="display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap; gap: var(--space-lg);">
                    <div class="job-header-info">
                        <h1 style="font-size: 2.2rem; font-weight: 800; margin-bottom: var(--space-sm); background: linear-gradient(135deg, #fff, var(--text-secondary)); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">${job.title}</h1>
                        <p class="text-gradient" style="font-size: 1.25rem; font-weight: 600; margin-bottom: var(--space-md);">
                            ${job.companyName != null ? job.companyName : job.employerName}
                        </p>
                        
                        <div class="tags" style="display: flex; flex-wrap: wrap; gap: 12px; margin-bottom: var(--space-lg);">
                            <span class="badge" style="background: rgba(148, 163, 184, 0.1); padding: 6px 12px; border-radius: 6px;">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="var(--primary-light)" stroke-width="2" style="vertical-align: -3px; margin-right: 4px;"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>
                                ${job.locationName} <c:if test="${not empty job.addressDetail}">- ${job.addressDetail}</c:if>
                            </span>
                            <span class="badge" style="background: rgba(148, 163, 184, 0.1); padding: 6px 12px; border-radius: 6px;">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="var(--success)" stroke-width="2" style="vertical-align: -3px; margin-right: 4px;"><rect x="2" y="7" width="20" height="14" rx="2" ry="2"></rect><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"></path></svg>
                                ${job.employmentTypeName}
                            </span>
                            <span class="badge" style="background: rgba(148, 163, 184, 0.1); padding: 6px 12px; border-radius: 6px;">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="var(--warning)" stroke-width="2" style="vertical-align: -3px; margin-right: 4px;"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                                ${job.experienceLevelName}
                            </span>
                            <c:if test="${job.vacancyCount != null && job.vacancyCount > 0}">
                                <span class="badge" style="background: rgba(148, 163, 184, 0.1); padding: 6px 12px; border-radius: 6px;">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="var(--info)" stroke-width="2" style="vertical-align: -3px; margin-right: 4px;"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                                    Số lượng: ${job.vacancyCount}
                                </span>
                            </c:if>
                        </div>
                    </div>
                    
                    <div class="job-action-card" style="text-align: right; background: rgba(0,0,0,0.2); padding: var(--space-lg); border-radius: var(--radius-lg); border: 1px solid var(--border-color); min-width: 250px;">
                        <div class="salary-box" style="margin-bottom: var(--space-md);">
                            <div style="font-size: 0.85rem; color: var(--text-muted); margin-bottom: 4px;">Mức lương</div>
                            <c:choose>
                                <c:when test="${job.salaryMax != null}">
                                    <div class="text-success" style="font-size: 1.5rem; font-weight: 700;">
                                        <fmt:formatNumber value="${job.salaryMin}" maxFractionDigits="0" /> - <fmt:formatNumber value="${job.salaryMax}" maxFractionDigits="0" /> ${job.currencyCode}
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-primary" style="font-size: 1.5rem; font-weight: 700;">Thỏa thuận</div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        
                        <c:if test="${sessionScope.userRole == 'CANDIDATE'}">
                            <button id="btnSaveJob" onclick="toggleSaveJob(${job.jobId})" class="btn ${isSaved ? 'btn-outline' : 'btn-primary'} btn-full" style="margin-bottom: var(--space-sm);">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="${isSaved ? 'currentColor' : 'none'}" stroke="currentColor" stroke-width="2"><path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"></path></svg>
                                <span id="saveJobText">${isSaved ? 'Đã lưu việc làm' : 'Lưu việc làm'}</span>
                            </button>
                            <button class="btn btn-outline btn-full" style="background: var(--success); color: white; border: none;">
                                Ứng tuyển ngay
                            </button>
                        </c:if>
                        <c:if test="${empty sessionScope.userRole}">
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-primary btn-full" style="margin-bottom: var(--space-sm);">Đăng nhập để ứng tuyển</a>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- Job Content -->
            <div class="job-content glass-card" style="padding: var(--space-2xl); line-height: 1.8;">
                <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--primary-light); margin-bottom: var(--space-md); border-bottom: 1px solid var(--border-color); padding-bottom: 8px;">Mô tả công việc</h3>
                <div class="rich-text" style="margin-bottom: var(--space-2xl); color: var(--text-primary);">
                    ${job.description}
                </div>

                <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--primary-light); margin-bottom: var(--space-md); border-bottom: 1px solid var(--border-color); padding-bottom: 8px;">Yêu cầu ứng viên</h3>
                <div class="rich-text" style="margin-bottom: var(--space-2xl); color: var(--text-primary);">
                    ${job.requirements}
                </div>

                <c:if test="${not empty job.responsibilities}">
                    <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--primary-light); margin-bottom: var(--space-md); border-bottom: 1px solid var(--border-color); padding-bottom: 8px;">Trách nhiệm</h3>
                    <div class="rich-text" style="margin-bottom: var(--space-2xl); color: var(--text-primary);">
                        ${job.responsibilities}
                    </div>
                </c:if>

                <div style="background: rgba(148, 163, 184, 0.05); padding: var(--space-lg); border-radius: var(--radius-md); border-left: 4px solid var(--primary); margin-top: var(--space-2xl);">
                    <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 8px;">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="var(--primary)" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                        <span style="font-weight: 600;">Hạn nộp hồ sơ:</span> 
                        <fmt:formatDate value="${job.deadlineAt}" pattern="dd/MM/yyyy"/>
                    </div>
                </div>
            </div>
            
        </div>
    </main>

    <script>
        function toggleSaveJob(jobId) {
            const btn = document.getElementById('btnSaveJob');
            const isSaved = btn.classList.contains('btn-outline');
            const action = isSaved ? 'unsave' : 'save';
            
            // Add loading state
            btn.style.opacity = '0.7';
            btn.style.pointerEvents = 'none';

            fetch('${pageContext.request.contextPath}/user/save-job', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'jobId=' + jobId + '&action=' + action
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    if (action === 'save') {
                        btn.classList.remove('btn-primary');
                        btn.classList.add('btn-outline');
                        btn.querySelector('svg').setAttribute('fill', 'currentColor');
                        document.getElementById('saveJobText').innerText = 'Đã lưu việc làm';
                    } else {
                        btn.classList.remove('btn-outline');
                        btn.classList.add('btn-primary');
                        btn.querySelector('svg').setAttribute('fill', 'none');
                        document.getElementById('saveJobText').innerText = 'Lưu việc làm';
                    }
                } else {
                    alert('Có lỗi xảy ra: ' + data.message);
                }
            })
            .catch(error => console.error('Error:', error))
            .finally(() => {
                btn.style.opacity = '1';
                btn.style.pointerEvents = 'auto';
            });
        }
    </script>
</body>
</html>

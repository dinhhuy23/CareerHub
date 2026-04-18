<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tìm kiếm việc làm - HireHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

</head>
<body class="app-page">
    <jsp:include page="/WEB-INF/views/header.jsp" />

    <main class="main-content">
        <div class="container" style="margin-top: 30px;">
            <!-- Filter Top Bar -->
            <div class="filter-topbar glass-card animate-fadeInUp" style="padding: var(--space-lg); margin-bottom: var(--space-xl);">
                <form action="${pageContext.request.contextPath}/jobs" method="get" class="filter-form" style="display: flex; flex-direction: column; gap: var(--space-md);">
                    
                    <!-- Dòng 1: Tìm kiếm từ khóa -->
                    <div class="form-group" style="margin-bottom: 0;">
                        <input type="text" name="keyword" class="form-input" placeholder="Nhập tên công việc, kỹ năng, tên công ty..." value="${keyword}" style="font-size: 1.05rem; padding: 14px 16px;">
                    </div>

                    <!-- Dòng 2: Bộ lọc ngang -->
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: var(--space-md);">
                        <div class="form-group" style="margin-bottom: 0;">
                            <select name="category" class="form-input form-select">
                                <option value="">Tất cả danh mục ngành nghề</option>
                                <c:forEach items="${categories}" var="cat">
                                    <option value="${cat.categoryId}" ${cat.categoryId == selectedCategory ? 'selected' : ''}>${cat.categoryName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group" style="margin-bottom: 0;">
                            <select name="location" class="form-input form-select">
                                <option value="">Tất cả địa điểm làm việc</option>
                                <c:forEach items="${locations}" var="loc">
                                    <option value="${loc.locationId}" ${loc.locationId == selectedLocation ? 'selected' : ''}>${loc.locationName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group" style="margin-bottom: 0;">
                            <select name="type" class="form-input form-select">
                                <option value="">Tất cả hình thức</option>
                                <c:forEach items="${employmentTypes}" var="type">
                                    <option value="${type.employmentTypeId}" ${type.employmentTypeId == selectedType ? 'selected' : ''}>${type.typeName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group" style="margin-bottom: 0;">
                            <select name="level" class="form-input form-select">
                                <option value="">Tất cả cấp bậc kinh nghiệm</option>
                                <c:forEach items="${experienceLevels}" var="lvl">
                                    <option value="${lvl.experienceLevelId}" ${lvl.experienceLevelId == selectedLevel ? 'selected' : ''}>${lvl.levelName}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <!-- Dòng 3: Nút bấm -->
                    <div style="display: flex; gap: 12px; justify-content: flex-end; margin-top: 8px;">
                        <a href="${pageContext.request.contextPath}/jobs" class="btn btn-outline" style="padding: 10px 24px;">Xóa bộ lọc</a>
                        <button type="submit" class="btn btn-primary" style="padding: 10px 32px;">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="margin-right: 8px; vertical-align: -4px;"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                            Tìm kiếm việc làm
                        </button>
                    </div>
                </form>
            </div>

            <!-- Job List -->
            <div class="job-list-container">
                <div class="section-header animate-fadeInUp" style="animation-delay: 0.1s;">
                    <h2>Có <span class="text-gradient">${totalJobs}</span> việc làm phù hợp</h2>
                </div>

                <div class="job-grid">
                    <c:choose>
                        <c:when test="${empty jobs}">
                            <div class="glass-card text-center" style="grid-column: 1 / -1; padding: var(--space-2xl);">
                                <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="var(--text-muted)" stroke-width="1.5" style="margin: 0 auto var(--space-md);"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                                <h3>Không tìm thấy việc làm</h3>
                                <p class="text-secondary">Hãy thử điều chỉnh lại bộ lọc tìm kiếm của bạn.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${jobs}" var="job" varStatus="status">
                                <div class="job-card-cv animate-fadeInUp" style="animation-delay: ${0.05 * status.index}s;" onclick="window.location='${pageContext.request.contextPath}/job-detail?id=${job.jobId}'">
                                    <button class="btn-save-job" onclick="event.stopPropagation(); toggleHeart(this, ${job.jobId})">
                                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l8.78-8.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path></svg>
                                    </button>

                                    <div class="job-card-main">
                                        <div class="job-company-logo">
                                            <div class="job-company-initial">
                                                <c:out value="${(not empty job.companyName) ? job.companyName.substring(0,1) : (not empty job.employerName ? job.employerName.substring(0,1) : 'H')}" />
                                            </div>
                                        </div>
                                        <div class="job-info">
                                            <div class="job-card-title" title="${job.title}">${job.title}</div>
                                            <div class="job-card-company">${job.companyName != null ? job.companyName : job.employerName}</div>
                                        </div>
                                    </div>

                                    <div class="job-card-meta">
                                        <div class="job-card-salary">
                                            <c:choose>
                                                <c:when test="${not empty job.salaryMin and not empty job.salaryMax}">
                                                    <fmt:formatNumber value="${job.salaryMin/1000000}" maxFractionDigits="1" />-<fmt:formatNumber value="${job.salaryMax/1000000}" maxFractionDigits="1" /> triệu
                                                </c:when>
                                                <c:otherwise>Thỏa thuận</c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="job-card-location">${job.locationName}</div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Pagination Controls -->
                <c:if test="${totalPages > 1}">
                    <div class="pagination animate-fadeInUp" style="display: flex; justify-content: center; gap: 8px; margin-top: var(--space-xl); margin-bottom: var(--space-2xl);">
                        <c:if test="${currentPage > 1}">
                            <a href="?page=${currentPage - 1}&keyword=${keyword}&category=${selectedCategory}&location=${selectedLocation}&type=${selectedType}&level=${selectedLevel}" class="page-link" style="padding: 8px 16px; border-radius: 8px; background: var(--bg-card); color: var(--text-primary); text-decoration: none; border: 1px solid var(--border-color); transition: all 0.3s;">Trước</a>
                        </c:if>
                        
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <a href="?page=${i}&keyword=${keyword}&category=${selectedCategory}&location=${selectedLocation}&type=${selectedType}&level=${selectedLevel}" class="page-link" style="padding: 8px 16px; border-radius: 8px; background: ${i == currentPage ? 'var(--primary)' : 'var(--bg-card)'}; color: ${i == currentPage ? 'white' : 'var(--text-primary)'}; text-decoration: none; border: 1px solid ${i == currentPage ? 'var(--primary)' : 'var(--border-color)'}; font-weight: ${i == currentPage ? '600' : '400'}; transition: all 0.3s;">${i}</a>
                        </c:forEach>
                        
                        <c:if test="${currentPage < totalPages}">
                            <a href="?page=${currentPage + 1}&keyword=${keyword}&category=${selectedCategory}&location=${selectedLocation}&type=${selectedType}&level=${selectedLevel}" class="page-link" style="padding: 8px 16px; border-radius: 8px; background: var(--bg-card); color: var(--text-primary); text-decoration: none; border: 1px solid var(--border-color); transition: all 0.3s;">Sau</a>
                        </c:if>
                    </div>
                </c:if>
            </div>
        </div>
    </main>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
    <script>
        function toggleHeart(btn, jobId) {
            btn.classList.toggle('active');
            const svg = btn.querySelector('svg');
            if (btn.classList.contains('active')) {
                svg.setAttribute('fill', '#EF4444');
                svg.setAttribute('stroke', '#EF4444');
            } else {
                svg.setAttribute('fill', 'none');
                svg.setAttribute('stroke', 'currentColor');
            }
            
            // Call API if needed
            console.log('Toggled job:', jobId);
        }
    </script>
</body>
</html>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${company.companyName} - Trình hồ sơ công ty</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="app-page">
    <jsp:include page="/WEB-INF/views/header.jsp" />

    <main class="main-content">
        <div class="container animate-fadeInUp">
            
            <!-- Nút quay lại -->
            <a href="${pageContext.request.contextPath}/jobs" class="btn btn-outline" style="margin-bottom: var(--space-xl); padding: 8px 16px; display: inline-flex; border-radius: 20px;">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="margin-right: 6px;"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>
                Quay lại danh sách việc làm
            </a>

            <!-- Header Công ty -->
            <div class="glass-card animate-fadeInUp" style="padding: var(--space-2xl); margin-bottom: var(--space-xl); position: relative; overflow: hidden; display: flex; gap: 32px; align-items: flex-start; flex-wrap: wrap;">
                <div style="position: absolute; right: -50px; top: -50px; width: 250px; height: 250px; background: var(--primary); filter: blur(80px); opacity: 0.15; border-radius: 50%;"></div>
                
                <div style="width: 140px; height: 140px; background: var(--bg-tertiary); border: 1px solid var(--border-color); border-radius: 20px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; box-shadow: 0 4px 12px rgba(0,0,0,0.3); overflow: hidden;">
                    <c:choose>
                        <c:when test="${not empty company.logoUrl}">
                            <img src="${company.logoUrl}" alt="${company.companyName} logo" style="width: 100%; height: 100%; object-fit: contain;">
                        </c:when>
                        <c:otherwise>
                            <span style="font-size: 3rem; font-weight: 800; color: var(--primary);">${company.companyName.substring(0, 1).toUpperCase()}</span>
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <div style="flex: 1; min-width: 300px; z-index: 2;">
                    <h1 style="font-size: 2.2rem; font-weight: 800; margin-bottom: 12px; color: var(--text-primary);">${company.companyName}</h1>
                    
                    <div style="display: flex; flex-direction: column; gap: 12px; margin-bottom: 24px;">
                        <c:if test="${not empty company.industry}">
                            <div style="display: flex; align-items: center; gap: 8px; color: var(--text-secondary);">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="var(--primary)" stroke-width="2"><rect x="2" y="7" width="20" height="14" rx="2" ry="2"></rect><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"></path></svg>
                                <span><strong>Ngành nghề:</strong> ${company.industry}</span>
                            </div>
                        </c:if>
                        <c:if test="${not empty company.address}">
                            <div style="display: flex; align-items: center; gap: 8px; color: var(--text-secondary);">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="var(--primary)" stroke-width="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>
                                <span><strong>Địa chỉ:</strong> ${company.address}</span>
                            </div>
                        </c:if>
                        <c:if test="${not empty company.websiteUrl}">
                            <div style="display: flex; align-items: center; gap: 8px; color: var(--text-secondary);">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="var(--primary)" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><line x1="2" y1="12" x2="22" y2="12"></line><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"></path></svg>
                                <a href="${company.websiteUrl}" target="_blank" style="color: var(--primary); text-decoration: none;">${company.websiteUrl}</a>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>

            <div style="display: grid; grid-template-columns: minmax(0, 2fr) minmax(300px, 1fr); gap: var(--space-xl); align-items: start;">
                <!-- Giới thiệu -->
                <div class="glass-card animate-fadeInUp" style="animation-delay: 0.1s; padding: var(--space-2xl);">
                    <h3 style="font-size: 1.35rem; font-weight: 700; color: var(--text-primary); margin-bottom: 16px; display: flex; align-items: center; border-bottom: 2px solid var(--bg-primary); padding-bottom: 10px;">
                        Giới thiệu công ty
                    </h3>
                    <div style="color: var(--text-secondary); line-height: 1.8; font-size: 1.05rem; white-space: pre-wrap;">
                        <c:choose>
                            <c:when test="${not empty company.description}">
                                ${company.description}
                            </c:when>
                            <c:otherwise>
                                <em>Chưa có thông tin giới thiệu.</em>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Danh sách việc làm đang mở -->
                <div class="glass-card animate-fadeInUp" style="animation-delay: 0.2s; padding: var(--space-xl);">
                    <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--text-primary); margin-bottom: 20px; display: flex; align-items: center; justify-content: space-between;">
                        Tuyển dụng (${companyJobs.size()})
                        <div style="width: 32px; height: 32px; background: rgba(59, 130, 246, 0.1); border-radius: 50%; color: var(--primary); display: flex; align-items: center; justify-content: center;">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"></path></svg>
                        </div>
                    </h3>
                    
                    <div style="display: flex; flex-direction: column; gap: 16px;">
                        <c:forEach var="job" items="${companyJobs}">
                            <a href="${pageContext.request.contextPath}/job-detail?id=${job.jobId}" style="display: flex; flex-direction: column; gap: 8px; padding: 16px; border: 1px solid var(--border-color); border-radius: 12px; text-decoration: none; transition: all 0.3s ease; background: var(--bg-primary);" onmouseover="this.style.borderColor='var(--primary)'; this.style.transform='translateY(-2px)';" onmouseout="this.style.borderColor='var(--border-color)'; this.style.transform='none';">
                                <span style="font-weight: 700; color: var(--text-primary); font-size: 1.05rem;">${job.title}</span>
                                <div style="display: flex; align-items: center; gap: 12px; color: var(--text-muted); font-size: 0.85rem;">
                                    <span>📍 ${job.locationName}</span>
                                    <span>💰 ${job.salaryMin} - ${job.salaryMax} ${job.currencyCode}</span>
                                </div>
                            </a>
                        </c:forEach>
                        <c:if test="${empty companyJobs}">
                            <div style="text-align: center; color: var(--text-muted); padding: 20px 0;">
                                Hiện chưa có tin tuyển dụng nào.
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>

        </div>
    </main>
</body>
</html>

<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Công ty ưu tiên - HireHub</title>
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                <style>
                    .company-card {
                        background: var(--bg-secondary);
                        border: 1px solid var(--border-color);
                        border-radius: 20px;
                        padding: 24px;
                        margin-bottom: 16px;
                        display: flex;
                        gap: 24px;
                        align-items: center;
                        transition: all 0.3s ease;
                    }

                    .company-card:hover {
                        border-color: var(--primary);
                        box-shadow: 0 8px 30px rgba(99, 102, 241, 0.08);
                        transform: translateY(-2px);
                    }

                    .company-logo-large {
                        width: 80px;
                        height: 80px;
                        border-radius: 18px;
                        background: white;
                        border: 1px solid var(--border-color);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-size: 2rem;
                        font-weight: 800;
                        color: var(--primary);
                        flex-shrink: 0;
                        overflow: hidden;
                    }

                    .company-logo-large img {
                        width: 100%;
                        height: 100%;
                        object-fit: cover;
                    }

                    .company-details {
                        flex: 1;
                    }

                    .company-title {
                        font-size: 1.3rem;
                        font-weight: 700;
                        color: var(--text-primary);
                        margin-bottom: 6px;
                        text-decoration: none;
                        display: block;
                    }

                    .company-title:hover {
                        color: var(--primary);
                    }

                    .company-tagline {
                        font-size: 0.9rem;
                        color: var(--text-secondary);
                        margin-bottom: 12px;
                        display: flex;
                        gap: 12px;
                    }

                    .tag-item {
                        display: flex;
                        align-items: center;
                        gap: 4px;
                    }

                    .unfavorite-btn {
                        background: transparent;
                        color: #EF4444;
                        border: 1px solid rgba(239, 68, 68, 0.3);
                        padding: 10px 20px;
                        border-radius: 12px;
                        font-size: 0.9rem;
                        font-weight: 700;
                        cursor: pointer;
                        transition: all 0.2s;
                        display: flex;
                        align-items: center;
                        gap: 8px;
                    }

                    .unfavorite-btn:hover {
                        background: #EF4444;
                        color: white;
                    }

                    /* Tabs Styling (Same as saved_jobs.jsp) */
                    .tabs-container {
                        display: flex;
                        gap: 8px;
                        margin-bottom: 24px;
                        border-bottom: 1px solid var(--border-color);
                        padding-bottom: 1px;
                    }

                    .tab-item {
                        padding: 12px 24px;
                        font-weight: 600;
                        color: var(--text-secondary);
                        text-decoration: none;
                        border-bottom: 3px solid transparent;
                        transition: all 0.2s;
                        display: flex;
                        align-items: center;
                        gap: 8px;
                    }

                    .tab-item:hover {
                        color: var(--primary);
                        background: rgba(99, 102, 241, 0.05);
                    }

                    .tab-item.active {
                        color: var(--primary);
                        border-bottom-color: var(--primary);
                    }

                    .tab-count {
                        background: var(--bg-tertiary);
                        padding: 2px 8px;
                        border-radius: 20px;
                        font-size: 0.75rem;
                    }
                </style>
            </head>

            <body class="app-page">
                <jsp:include page="/WEB-INF/views/header.jsp" />

                <main class="main-content">
                    <div class="container animate-fadeInUp">

                        %-- Tiêu đề trang --%>
                        <div style="margin-bottom: 32px;">
                            <h1
                                style="font-size: 2.2rem; font-weight: 800; color: var(--text-primary); margin-bottom: 8px;">
                                Danh sách đã lưu
                            </h1>
                            <p style="color: var(--text-secondary);">
                                Nơi lưu giữ những cơ hội và doanh nghiệp bạn quan tâm nhất.
                            </p>
                        </div>

                        %-- Tabs --%>
                        <div class="tabs-container">
                            <a href="${pageContext.request.contextPath}/user/saved-jobs" class="tab-item">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2">
                                    <path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"></path>
                                </svg>
                                Việc làm đã lưu
                            </a>
                            <a href="${pageContext.request.contextPath}/user/favorite-companies"
                                class="tab-item active">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                    stroke-width="2">
                                    <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                                    <polyline points="9 22 9 12 15 12 15 22"></polyline>
                                </svg>
                                Công ty ưu tiên
                                <span class="tab-count">${fn:length(favoriteCompanies)}</span>
                            </a>
                        </div>

                        <c:if test="${empty favoriteCompanies}">
                            <div class="glass-card"
                                style="padding: 100px 40px; text-align: center; border-style: dashed;">
                                <div
                                    style="width: 80px; height: 80px; background: rgba(99,102,241,0.1); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 24px;">
                                    <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="var(--primary)"
                                        stroke-width="1.5">
                                        <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                                        <polyline points="9 22 9 12 15 12 15 22"></polyline>
                                    </svg>
                                </div>
                                <h3
                                    style="font-size: 1.4rem; font-weight: 700; color: var(--text-primary); margin-bottom: 12px;">
                                    Bạn chưa ưu tiên công ty nào</h3>
                                <p
                                    style="color: var(--text-secondary); margin-bottom: 32px; max-width: 450px; margin-left: auto; margin-right: auto;">
                                    Theo dõi các công ty hàng đầu để nhận thông báo về những vị trí tuyển dụng mới nhất
                                    từ họ.
                                </p>
                                <a href="${pageContext.request.contextPath}/jobs" class="btn btn-primary"
                                    style="padding: 12px 32px;">Tìm kiếm công ty</a>
                            </div>
                        </c:if>

                        <div class="company-list">
                            <c:forEach var="c" items="${favoriteCompanies}">
                                <div class="company-card" id="company-card-${c.companyId}">
                                    <div class="company-logo-large">
                                        <c:choose>
                                            <c:when test="${not empty c.logoUrl}">
                                                <img src="${c.logoUrl}" alt="${c.companyName}">
                                            </c:when>
                                            <c:otherwise>${fn:toUpperCase(fn:substring(c.companyName, 0, 1))}
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <div class="company-details">
                                        <a href="${pageContext.request.contextPath}/company-detail?id=${c.companyId}"
                                            class="company-title">
                                            ${c.companyName}
                                        </a>
                                        <div class="company-tagline">
                                            <span class="tag-item">
                                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <path
                                                        d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z">
                                                    </path>
                                                    <polyline points="3.27 6.96 12 12.01 20.73 6.96"></polyline>
                                                    <line x1="12" y1="22.08" x2="12" y2="12"></line>
                                                </svg>
                                                ${c.industry}
                                            </span>
                                            <span class="tag-item">
                                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                                    <circle cx="9" cy="7" r="4"></circle>
                                                    <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                                    <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                                                </svg>
                                                ${c.companySize} nhân viên
                                            </span>
                                            <span class="tag-item">
                                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                                                    <circle cx="12" cy="10" r="3"></circle>
                                                </svg>
                                                ${c.location.locationName}
                                            </span>
                                        </div>
                                    </div>

                                    <button class="unfavorite-btn" onclick="unfavoriteCompany(${c.companyId})">
                                        <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor"
                                            stroke="currentColor" stroke-width="2">
                                            <path
                                                d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l8.84-8.84 1.06-1.06a5.5 5.5 0 0 0 0-7.78z">
                                            </path>
                                        </svg>
                                        Bỏ ưu tiên
                                    </button>
                                </div>
                            </c:forEach>
                        </div>

                    </div>
                </main>

                <script>
                    function unfavoriteCompany(companyId) {
                        if (!confirm('Bạn muốn bỏ công ty này khỏi danh sách ưu tiên?')) return;

                        fetch('${pageContext.request.contextPath}/user/favorite-company', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                            body: 'companyId=' + companyId + '&action=unfavorite'
                        })
                            .then(response => {
                                if (response.ok) {
                                    const card = document.getElementById('company-card-' + companyId);
                                    card.style.opacity = '0';
                                    card.style.transform = 'scale(0.95)';
                                    setTimeout(() => {
                                        card.remove();
                                        if (document.querySelectorAll('.company-card').length === 0) {
                                            location.reload();
                                        }
                                    }, 300);
                                } else {
                                    alert('Có lỗi xảy ra khi bỏ ưu tiên.');
                                }
                            })
                            .catch(error => console.error('Error:', error));
                    }
                </script>
            </body>

            </html>
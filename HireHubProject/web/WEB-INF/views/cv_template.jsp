<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Chọn mẫu CV - HireHub</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    </head>

    <body class="app-page cv-page">

        <jsp:include page="/WEB-INF/views/header.jsp" />

        <main class="main-content">
            <div class="container">

                <div class="page-header cv-header animate-fadeInUp">
                    <div class="header-left">
                        <h1>📄 Chọn mẫu CV</h1>
                        <div class="cv-filters">
                            <a href="?tag=all" class="filter-btn ${currentTag == 'all' ? 'active' : ''}">Tất cả</a>
                            <a href="?tag=simple" class="filter-btn ${currentTag == 'simple' ? 'active' : ''}">Đơn giản</a>
                            <a href="?tag=professional" class="filter-btn ${currentTag == 'professional' ? 'active' : ''}">Chuyên nghiệp</a>
                            <a href="?tag=modern" class="filter-btn ${currentTag == 'modern' ? 'active' : ''}">Hiện đại</a>
                            <a href="?tag=creative" class="filter-btn ${currentTag == 'creative' ? 'active' : ''}">Sáng tạo</a>
                        </div>
                    </div>

                    <div class="header-right">
                        <a href="${pageContext.request.contextPath}/user/dashboard" class="btn btn-outline">
                            ← Quay lại
                        </a>
                    </div>
                </div>

                <div class="cv-grid">
                    <c:forEach var="cv" items="${cvList}" varStatus="loop">
                        <div class="cv-card glass-card animate-fadeInUp"
                             style="animation-delay: ${loop.index * 0.1}s;">

                            <div class="cv-preview">
                                <img src="${cv.image}">

                                <div class="cv-overlay">
                                    <a href="${pageContext.request.contextPath}/user/create_cv?template=${cv.id}"
                                       class="btn btn-primary btn-use-cv">
                                        Dùng mẫu này
                                    </a>
                                </div>
                            </div>

                            <div class="cv-info">
                                <h3>${cv.name}</h3>
                                <div class="cv-tags">
                                    <c:forEach var="t" items="${cv.tags}">
                                        <span class="cv-tag">${t}</span>
                                    </c:forEach>
                                </div>
                            </div>

                        </div>
                    </c:forEach>
                </div>
            </div>
        </main>

        <script src="${pageContext.request.contextPath}/js/main.js"></script>

    </body>
</html>
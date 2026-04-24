<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Tìm kiếm ứng viên | HireHub</title>

        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

        <style>
            /* Các style cũ giữ nguyên */
            .search-hero-section {
                padding: 100px 0 60px;
                text-align: center;
                background: linear-gradient(180deg, rgba(99, 102, 241, 0.1) 0%, transparent 100%);
            }
            .search-container {
                max-width: 800px;
                margin: 0 auto;
                position: relative;
                z-index: 10;
            }
            .candidate-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
                gap: 24px;
                padding-bottom: 80px;
            }
            .candidate-card {
                padding: var(--space-xl);
                display: flex;
                flex-direction: column;
                align-items: center;
                text-align: center;
                transition: all var(--transition-base);
                position: relative;
            }
            .candidate-card:hover {
                transform: translateY(-8px);
                border-color: var(--primary);
                background: var(--bg-card-hover);
            }
            .avatar-circle-lg {
                width: 84px;
                height: 84px;
                background: linear-gradient(135deg, var(--primary), var(--accent));
                color: white;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 2rem;
                font-weight: 800;
                margin-bottom: var(--space-md);
                box-shadow: 0 8px 20px rgba(99, 102, 241, 0.3);
            }
            .target-badge {
                background: var(--primary-100);
                color: var(--primary-light);
                padding: 6px 16px;
                border-radius: var(--radius-full);
                font-size: 0.85rem;
                font-weight: 600;
                margin-bottom: var(--space-sm);
            }
        </style>
    </head>
    <body class="app-page">
        <jsp:include page="/WEB-INF/views/header.jsp" />
        <div class="bg-decoration">
            <div class="bg-circle bg-circle-1"></div>
            <div class="bg-circle bg-circle-2"></div>
        </div>

        <header class="search-hero-section">
            <div class="search-container">
                <h1 class="welcome-text"><span class="text-gradient">Tìm kiếm nhân tài</span></h1>
                <p class="welcome-subtitle">Kết nối với những ứng viên xuất sắc nhất</p>

                <form action="${pageContext.request.contextPath}/employer/browse_cv" method="GET" class="input-wrapper" style="margin-top: 30px; display: flex; box-shadow: 0 10px 25px rgba(0,0,0,0.1); border-radius: var(--radius-full);">
                    <span class="input-icon" style="font-size: 1.2rem; margin-top: 5px;">🔍</span>
                    <input type="text" name="keyword" value="${keyword}" class="form-input" 
                           placeholder="Nhập vị trí ứng tuyển mong muốn (VD: Java, Marketing)..." 
                           style="padding-right: 20px; flex-grow: 1; font-size: 1.1rem; height: 60px; border: none;">
                    <button type="submit" class="btn btn-primary" style="border-radius: 0 var(--radius-full) var(--radius-full) 0; padding: 0 40px; font-weight: 700; font-size: 1.1rem; height: 60px;">TÌM KIẾM</button>
                </form>
            </div>
        </header>

        <main class="container main-content">
            <div class="candidate-grid" id="cvGrid">
                <c:forEach items="${listCV}" var="cv">
                        <c:set var="fName" value="${cv.fullName != null ? cv.fullName : 'Ứng viên ẩn danh'}" />
                        <c:set var="tRole" value="${cv.targetRole != null ? cv.targetRole : 'Chưa cập nhật vị trí'}" />
                        <c:set var="cTitle" value="${cv.cvTitle != null ? cv.cvTitle : 'CV Tải lên'}" />

                        <div class="glass-card candidate-card cv-item" 
                             data-title="${fn:toLowerCase(fName)} ${fn:toLowerCase(tRole)} ${fn:toLowerCase(cTitle)}">

                            <div class="avatar-circle-lg">
                                ${fn:toUpperCase(fn:substring(fName, 0, 1))}
                            </div>
                            <span class="target-badge">${tRole}</span>
                            <h3 style="color: var(--text-primary); margin-bottom: 5px;">${fName}</h3>
                            <p style="color: var(--text-secondary); font-size: 0.9rem; margin-bottom: 25px;">${cTitle}</p>

                        <a href="${pageContext.request.contextPath}/user/cv/preview?id=${cv.userCVId}" class="btn btn-outline btn-full" target="_blank">
                            Xem hồ sơ chi tiết
                        </a>
                    </div>
                </c:forEach>
            </div>

            <c:if test="${empty listCV}">
                <div id="noResults" class="glass-card" style="text-align: center; padding: 60px; border-style: dashed;">
                    <p style="color: var(--text-secondary);">Không tìm thấy ứng viên nào phù hợp với từ khóa.</p>
                    <a href="${pageContext.request.contextPath}/employer/browse_cv" class="btn btn-outline mt-3">Xóa tìm kiếm</a>
                </div>
            </c:if>

            <div class="pagination mt-5 d-flex justify-content-center gap-2" style="padding-top: 20px;">
                <c:if test="${totalPages > 1}">
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <a href="?keyword=${keyword}&page=${i}" class="btn ${currentPage == i ? 'btn-primary' : 'btn-outline'}">${i}</a>
                    </c:forEach>
                </c:if>
            </div>
        </main>

        <script>
            function toggleDropdown() {
                document.getElementById("userDropdown").classList.toggle("show");
            }
        </script>
    </body>
</html>
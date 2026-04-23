<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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

                <div class="input-wrapper" style="margin-top: 30px;">
                    <span class="input-icon">🔍</span>
                    <input type="text" id="cvSearchInput" class="form-input" 
                           placeholder="Nhập tên ứng viên, vị trí hoặc tiêu đề hồ sơ..." 
                           onkeyup="filterCVs()" style="padding-right: 20px;">
                </div>
            </div>
        </header>

        <main class="container main-content">
            <div class="candidate-grid" id="cvGrid">
                <c:forEach items="${listCV}" var="cv">
                    <div class="glass-card candidate-card cv-item" 
                         data-title="${cv.fullName.toLowerCase()} ${cv.targetRole.toLowerCase()} ${cv.cvTitle.toLowerCase()}">

                        <div class="avatar-circle-lg">
                            ${cv.fullName.substring(0,1).toUpperCase()}
                        </div>
                        <span class="target-badge">${cv.targetRole}</span>
                        <h3 style="color: var(--text-primary); margin-bottom: 5px;">${cv.fullName}</h3>
                        <p style="color: var(--text-secondary); font-size: 0.9rem; margin-bottom: 25px;">${cv.cvTitle}</p>

                        <a href="${pageContext.request.contextPath}/user/cv/view?id=${cv.userCVId}" class="btn btn-outline btn-full">
                            Xem hồ sơ chi tiết
                        </a>
                    </div>
                </c:forEach>
            </div>

            <div id="noResults" class="glass-card" style="display: none; text-align: center; padding: 60px; border-style: dashed;">
                <p style="color: var(--text-secondary);">Không tìm thấy ứng viên nào phù hợp với từ khóa.</p>
                <button onclick="resetSearch()" class="auth-link" style="background: none; border: none; cursor: pointer; margin-top: 15px;">Xóa tìm kiếm</button>
            </div>
        </main>

        <script>
            // Hàm lọc CV giống như manage_cv của bạn
            function filterCVs() {
                let input = document.getElementById('cvSearchInput').value.toLowerCase();
                let cvItems = document.getElementsByClassName('cv-item');
                let foundCount = 0;

                for (let item of cvItems) {
                    let searchData = item.getAttribute('data-title');
                    if (searchData.includes(input)) {
                        item.style.display = ""; // Hiển thị theo grid
                        foundCount++;
                    } else {
                        item.style.display = "none";
                    }
                }

                // Hiển thị thông báo nếu không tìm thấy ai
                const noResults = document.getElementById('noResults');
                if (foundCount === 0) {
                    noResults.style.display = "block";
                } else {
                    noResults.style.display = "none";
                }
            }

            function resetSearch() {
                document.getElementById('cvSearchInput').value = "";
                filterCVs();
            }

            function toggleDropdown() {
                document.getElementById("userDropdown").classList.toggle("show");
            }
        </script>
    </body>
</html>
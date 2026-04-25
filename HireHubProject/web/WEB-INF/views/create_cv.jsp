<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Tạo CV - HireHub</title>

        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    </head>

    <body class="app-page cv-page">

        <!-- NAVBAR -->
        <nav class="navbar glass-nav">
            <div class="nav-container">
                <a href="${pageContext.request.contextPath}/user/dashboard" class="nav-logo">
                    <svg width="36" height="36" viewBox="0 0 48 48" fill="none">
                    <rect width="48" height="48" rx="12" fill="url(#navLogo)"/>
                    <path d="M14 20h20M14 28h14M14 14h8v4h-8zM26 14h8v4h-8z"
                          stroke="white" stroke-width="2.5" stroke-linecap="round"/>
                    <defs>
                    <linearGradient id="navLogo" x1="0" y1="0" x2="48" y2="48">
                    <stop stop-color="#6366F1"/>
                    <stop offset="1" stop-color="#8B5CF6"/>
                    </linearGradient>
                    </defs>
                    </svg>
                    <span>HireHub</span>
                </a>

                <div class="nav-links">
                    <a href="${pageContext.request.contextPath}/user/dashboard" class="nav-link">Dashboard</a>
                    <a href="${pageContext.request.contextPath}/user/profile" class="nav-link">Hồ sơ</a>
                    <a href="${pageContext.request.contextPath}/user/cv_template" class="nav-link active">Tạo CV</a>
                </div>

                <div class="nav-user">
                    <div class="user-dropdown">
                        <button class="user-btn" onclick="toggleDropdown()">
                            <div class="user-avatar">${sessionScope.userFullName.substring(0,1)}</div>
                            <span class="user-name">${sessionScope.userFullName}</span>
                            <svg width="16" height="16" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z"/></svg>
                        </button>
                        <div class="dropdown-menu" id="userDropdown">
                            <a href="${pageContext.request.contextPath}/user/profile" class="dropdown-item">Thông tin cá nhân</a>
                            <a href="${pageContext.request.contextPath}/user/edit-profile" class="dropdown-item">Chỉnh sửa hồ sơ</a>
                            <a href="${pageContext.request.contextPath}/user/change-password" class="dropdown-item">Đổi mật khẩu</a>
                            <hr class="dropdown-divider">
                            <a href="${pageContext.request.contextPath}/logout" class="dropdown-item text-danger">Đăng xuất</a>
                        </div>
                    </div>
                </div>
            </div>
        </nav>

        <!-- MAIN -->
        <main class="main-content">
            <div class="container">

                <!-- HEADER -->
                <div class="page-header cv-header animate-fadeInUp">

                    <div class="header-left">
                        <h1>📄 Xem trước mẫu CV</h1>
                        <p style="color: var(--text-secondary); font-size: 0.9rem;">
                            Chọn mẫu phù hợp và bắt đầu tạo CV của bạn
                        </p>
                    </div>

                </div>

                <!-- LAYOUT -->
                <div class="cv-preview-layout"
                     style="display:flex; gap:24px; margin-top:20px;">

                    <!-- LEFT: PREVIEW -->
                    <div class="glass-card cv-preview-left"
                         style="flex:1.4; padding:20px;">

                        <div class="cv-preview-box"
                             style="border-radius:16px; overflow:hidden;">

                            <img src="${selectedTemplate.image}"
                                 alt="${selectedTemplate.name}"
                                 style="width:100%; height:auto; border-radius:12px;" 
                                 onerror="this.src='${pageContext.request.contextPath}/images/default-cv-preview.png'"/>

                        </div>

                    </div>

                    <!-- RIGHT: INFO -->
                    <div class="glass-card cv-preview-right"
                         style="flex:1; padding:24px; height:fit-content; position:sticky; top:90px;">

                        <!-- TITLE -->
                        <h2 style="font-size:1.3rem; font-weight:700;">
                            ${selectedTemplate.name}
                        </h2>

                        <!-- TAGS -->
                        <div class="cv-tags">
                            <c:forEach var="t" items="${selectedTemplate.tags}">
                                <span class="cv-tag">${t}</span>
                            </c:forEach>
                        </div>

                        <!-- DESCRIPTION -->
                        <p style="margin-top:12px; color:var(--text-secondary); font-size:0.9rem;">
                            Mẫu CV được thiết kế theo xu hướng hiện đại, tối ưu cho ứng tuyển và ATS.
                        </p>

                        <!-- FEATURES -->
                        <div style="margin-top:16px; font-size:0.85rem; color:var(--text-secondary);">
                            ✔ Chuẩn ATS <br>
                            ✔ Dễ chỉnh sửa <br>
                            ✔ Thiết kế chuyên nghiệp
                        </div>
                        <!-- ACTION BUTTON -->
                        <a href="${pageContext.request.contextPath}/user/create_cv?template=${selectedTemplate.id}&action=form"
                           class="btn btn-primary btn-full"
                           style="margin-top:20px;">
                            🚀 Bắt đầu tạo CV
                        </a>

                        <a href="${pageContext.request.contextPath}/user/cv_template"
                           class="btn btn-outline btn-full"
                           style="margin-top:10px;">
                            ← Chọn mẫu khác
                        </a>

                    </div>

                </div>

            </div>
        </main>

    </body>
</html>
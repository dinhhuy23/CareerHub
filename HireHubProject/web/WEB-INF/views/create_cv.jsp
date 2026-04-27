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

        <jsp:include page="/WEB-INF/views/header.jsp" />
        
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
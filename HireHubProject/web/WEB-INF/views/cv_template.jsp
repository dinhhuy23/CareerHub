<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chọn mẫu CV | HireHub</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* ===== PAGE HEADER ===== */
        .tpl-header { padding: 48px 0 32px; }
        .tpl-breadcrumb { display: inline-flex; align-items: center; gap: 7px; font-size: 0.78rem; color: rgba(255,255,255,0.4); background: rgba(255,255,255,0.06); border: 1px solid rgba(255,255,255,0.1); border-radius: 99px; padding: 5px 14px; margin-bottom: 18px; }
        .tpl-breadcrumb i { font-size: 0.9rem; }
        .tpl-title { font-size: 2.4rem; font-weight: 800; color: #f1f5f9; margin-bottom: 10px; line-height: 1.2; }
        .tpl-title span { background: linear-gradient(135deg, #6366f1, #8b5cf6); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
        .tpl-sub { color: rgba(255,255,255,0.45); font-size: 0.92rem; margin-bottom: 0; }
        .tpl-toprow { display: flex; justify-content: space-between; align-items: flex-start; gap: 16px; margin-bottom: 28px; }
        .back-btn { display: inline-flex; align-items: center; gap: 6px; padding: 9px 18px; border-radius: 99px; border: 1.5px solid rgba(255,255,255,0.12); background: rgba(255,255,255,0.05); color: rgba(255,255,255,0.6); font-size: 0.83rem; font-weight: 600; text-decoration: none; white-space: nowrap; transition: all .2s; margin-top: 4px; }
        .back-btn:hover { border-color: rgba(255,255,255,0.25); color: #fff; }

        /* ===== FILTER BAR ===== */
        .filter-bar { display: flex; align-items: center; gap: 10px; flex-wrap: wrap; background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.08); border-radius: 14px; padding: 12px 18px; margin-bottom: 28px; }
        .filter-label { font-size: 0.75rem; color: rgba(255,255,255,0.35); font-weight: 700; text-transform: uppercase; letter-spacing: .5px; margin-right: 4px; }
        .fp { display: inline-flex; align-items: center; gap: 6px; padding: 7px 16px; border-radius: 99px; border: 1.5px solid rgba(255,255,255,0.1); background: rgba(255,255,255,0.04); color: rgba(255,255,255,0.45); font-size: 0.8rem; font-weight: 600; text-decoration: none; transition: all .2s; cursor: pointer; }
        .fp:hover { border-color: rgba(99,102,241,0.5); color: #a5b4fc; background: rgba(99,102,241,0.08); }
        .fp.active { background: #6366f1; border-color: #6366f1; color: #fff; }
        .fp .dot { width: 7px; height: 7px; border-radius: 50%; display: inline-block; }
        .dot-all  { background: #fff; }
        .dot-s    { background: #60a5fa; }
        .dot-p    { background: #a78bfa; }
        .dot-m    { background: #34d399; }
        .dot-c    { background: #fb923c; }

        /* ===== COUNT ===== */
        .tpl-count { font-size: 0.83rem; color: rgba(255,255,255,0.4); margin-bottom: 20px; }
        .tpl-count strong { color: #a5b4fc; }

        /* ===== GRID ===== */
        .tpl-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(290px, 1fr)); gap: 24px; padding-bottom: 60px; }

        /* ===== CARD ===== */
        .tpl-card { border-radius: 18px; border: 1px solid rgba(255,255,255,0.08); background: rgba(255,255,255,0.03); overflow: hidden; transition: transform .22s, border-color .22s, box-shadow .22s; }
        .tpl-card:hover { transform: translateY(-6px); border-color: rgba(99,102,241,0.35); box-shadow: 0 18px 40px rgba(0,0,0,0.35); }

        /* preview */
        .tpl-preview { position: relative; overflow: hidden; background: #fff; aspect-ratio: 3/4; cursor: pointer; }
        .tpl-preview img { width: 100%; height: 100%; object-fit: cover; object-position: top; display: block; transition: transform .3s; }
        .tpl-card:hover .tpl-preview img { transform: scale(1.04); }
        .tpl-overlay { position: absolute; inset: 0; background: rgba(30,27,60,0.72); display: flex; align-items: center; justify-content: center; opacity: 0; transition: opacity .25s; }
        .tpl-card:hover .tpl-overlay { opacity: 1; }
        .btn-preview { padding: 10px 22px; border-radius: 10px; background: #fff; color: #1e1b3c; font-weight: 700; font-size: 0.83rem; text-decoration: none; transition: background .2s; }
        .btn-preview:hover { background: #e0e7ff; }

        /* badge phổ biến */
        .badge-popular { position: absolute; top: 12px; left: 12px; background: linear-gradient(135deg,#f59e0b,#ef4444); color: #fff; font-size: 0.65rem; font-weight: 800; padding: 3px 10px; border-radius: 99px; letter-spacing: .4px; text-transform: uppercase; }

        /* info */
        .tpl-info { padding: 16px 18px 18px; }
        .tpl-name { font-size: 1rem; font-weight: 700; color: #f1f5f9; margin-bottom: 8px; }
        .tpl-tags { display: flex; gap: 6px; flex-wrap: wrap; margin-bottom: 14px; }
        .tpl-tag { padding: 3px 11px; border-radius: 99px; font-size: 0.7rem; font-weight: 600; border: 1px solid rgba(255,255,255,0.12); color: rgba(255,255,255,0.45); background: rgba(255,255,255,0.04); }
        .tpl-footer { display: flex; align-items: center; justify-content: space-between; }
        .badge-free { display: flex; align-items: center; gap: 5px; font-size: 0.75rem; color: #4ade80; font-weight: 600; }
        .badge-free svg { width: 14px; height: 14px; }
        .btn-use { display: inline-flex; align-items: center; gap: 6px; padding: 8px 18px; border-radius: 10px; background: #6366f1; color: #fff; font-size: 0.8rem; font-weight: 700; text-decoration: none; transition: background .2s; }
        .btn-use:hover { background: #4f46e5; }

        /* empty */
        .tpl-empty { text-align: center; padding: 70px 40px; border: 1px dashed rgba(255,255,255,0.1); border-radius: 18px; }
        .tpl-empty p { color: rgba(255,255,255,0.3); }
    </style>
</head>
<body class="app-page">
<jsp:include page="/WEB-INF/views/header.jsp" />

<div class="bg-decoration">
    <div class="bg-circle bg-circle-1"></div>
    <div class="bg-circle bg-circle-2"></div>
</div>

<main class="main-content">
    <div class="container">

        <%-- HEADER --%>
        <div class="tpl-header animate-fadeInUp">
            <div class="tpl-toprow">
                <div>
                    <div class="tpl-breadcrumb">📄 Thư viện mẫu CV</div>
                    <h1 class="tpl-title">Chọn Mẫu <span>CV Chuyên Nghiệp</span></h1>
                    <p class="tpl-sub">Hàng chục mẫu CV được thiết kế bởi chuyên gia, phù hợp mọi ngành nghề.<br>Chỉnh sửa nhanh, xuất PDF ngay.</p>
                </div>
                <a href="${pageContext.request.contextPath}/user/cv/manage_cv" class="back-btn">← Quay lại</a>
            </div>

            <%-- FILTER --%>
            <div class="filter-bar">
                <span class="filter-label">Lọc theo</span>
                <a href="?tag=all"          class="fp ${empty currentTag || currentTag == 'all'          ? 'active' : ''}"><span class="dot dot-all"></span>Tất cả</a>
                <a href="?tag=simple"       class="fp ${currentTag == 'simple'       ? 'active' : ''}"><span class="dot dot-s"></span>Đơn giản</a>
                <a href="?tag=professional" class="fp ${currentTag == 'professional' ? 'active' : ''}"><span class="dot dot-p"></span>Chuyên nghiệp</a>
                <a href="?tag=modern"       class="fp ${currentTag == 'modern'       ? 'active' : ''}"><span class="dot dot-m"></span>Hiện đại</a>
                <a href="?tag=creative"     class="fp ${currentTag == 'creative'     ? 'active' : ''}"><span class="dot dot-c"></span>Sáng tạo</a>
            </div>
        </div>

        <%-- COUNT --%>
        <p class="tpl-count"><strong>${empty cvList ? 0 : cvList.size()} mẫu CV</strong> &nbsp;· Tất cả miễn phí</p>

        <%-- GRID --%>
        <c:choose>
            <c:when test="${not empty cvList}">
                <div class="tpl-grid">
                    <c:forEach var="cv" items="${cvList}" varStatus="loop">
                        <div class="tpl-card" style="animation-delay: ${loop.index * 0.08}s;">
                            <%-- Preview --%>
                            <div class="tpl-preview">
                                <img src="${cv.image}" alt="${cv.name}" loading="lazy"
                                     onerror="this.src='${pageContext.request.contextPath}/images/cv-placeholder.png'">
                                <c:if test="${loop.index < 2}">
                                    <span class="badge-popular">Phổ biến</span>
                                </c:if>
                                <div class="tpl-overlay">
                                    <a href="${pageContext.request.contextPath}/user/create_cv?template=${cv.id}" class="btn-preview">
                                        👁 Xem trước
                                    </a>
                                </div>
                            </div>

                            <%-- Info --%>
                            <div class="tpl-info">
                                <div class="tpl-name">${cv.name}</div>
                                <div class="tpl-tags">
                                    <c:forEach var="t" items="${cv.tags}">
                                        <span class="tpl-tag">${t}</span>
                                    </c:forEach>
                                </div>

                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="tpl-empty">
                    <p style="font-size:2.5rem; margin-bottom:12px;">📋</p>
                    <p>Chưa có mẫu CV nào. Vui lòng thử lại sau.</p>
                </div>
            </c:otherwise>
        </c:choose>

    </div>
</main>
</body>
</html>
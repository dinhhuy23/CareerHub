<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chọn Mẫu CV - HireHub</title>
    <meta name="description" content="Chọn mẫu CV chuyên nghiệp phù hợp với ngành nghề của bạn. Hơn 6 mẫu CV đẹp, hiện đại, dễ chỉnh sửa.">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* ===== HERO ===== */
        .ct-hero {
            position: relative;
            padding: 64px 0 52px;
            overflow: hidden;
            background: radial-gradient(ellipse 80% 60% at 50% -10%, rgba(99,102,241,0.26) 0%, transparent 70%),
                        var(--bg-primary);
        }
        .ct-hero::before {
            content: '';
            position: absolute;
            inset: 0;
            background: radial-gradient(ellipse 55% 45% at 85% 55%, rgba(139,92,246,0.12) 0%, transparent 70%);
            pointer-events: none;
        }
        .ct-hero-inner {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 24px;
            position: relative;
            z-index: 1;
        }
        .ct-hero-top {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 24px;
            margin-bottom: 40px;
            flex-wrap: wrap;
        }
        .ct-hero-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 5px 14px;
            background: rgba(99,102,241,0.12);
            border: 1px solid rgba(99,102,241,0.3);
            border-radius: 9999px;
            font-size: 0.78rem;
            font-weight: 600;
            color: var(--primary-light);
            margin-bottom: 14px;
        }
        .ct-hero-title {
            font-size: clamp(1.8rem, 4vw, 2.8rem);
            font-weight: 800;
            line-height: 1.25;
            color: var(--text-primary);
            margin-bottom: 10px;
        }
        .ct-hero-title span {
            background: linear-gradient(135deg, #6366F1, #8B5CF6, #06B6D4);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .ct-hero-sub {
            font-size: 0.97rem;
            color: var(--text-secondary);
            line-height: 1.65;
            max-width: 520px;
        }
        .ct-hero-actions {
            display: flex;
            gap: 10px;
            flex-shrink: 0;
            align-items: flex-start;
        }
        .ct-btn-back {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 10px 20px;
            border: 1.5px solid var(--border-color);
            border-radius: 10px;
            color: var(--text-secondary);
            font-size: 0.875rem;
            font-weight: 500;
            background: transparent;
            text-decoration: none;
            transition: all 0.2s;
            font-family: var(--font-family);
        }
        .ct-btn-back:hover {
            border-color: var(--primary);
            color: var(--primary-light);
            background: rgba(99,102,241,0.07);
        }

        /* ===== FILTER PILLS ===== */
        .ct-filters-wrap {
            background: rgba(255,255,255,0.04);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255,255,255,0.09);
            border-radius: 16px;
            padding: 18px 24px;
            display: flex;
            align-items: center;
            gap: 20px;
            flex-wrap: wrap;
            box-shadow: 0 4px 24px rgba(0,0,0,0.25);
        }
        .ct-filter-label {
            font-size: 0.82rem;
            font-weight: 600;
            color: var(--text-muted);
            white-space: nowrap;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        .ct-filter-pills {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }
        .ct-pill {
            padding: 7px 18px;
            border-radius: 9999px;
            font-size: 0.83rem;
            font-weight: 600;
            border: 1.5px solid var(--border-color);
            background: transparent;
            color: var(--text-secondary);
            text-decoration: none;
            transition: all 0.2s;
            cursor: pointer;
            font-family: var(--font-family);
        }
        .ct-pill:hover {
            border-color: var(--primary);
            color: var(--primary-light);
            background: rgba(99,102,241,0.08);
        }
        .ct-pill.active {
            border-color: var(--primary);
            color: white;
            background: linear-gradient(135deg, var(--primary), var(--accent));
            box-shadow: 0 4px 14px rgba(99,102,241,0.35);
        }

        /* ===== STATS BAR ===== */
        .ct-stats-bar {
            max-width: 1200px;
            margin: 28px auto 0;
            padding: 0 24px;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.875rem;
            color: var(--text-secondary);
        }
        .ct-stats-bar strong { color: var(--primary-light); font-weight: 700; }

        /* ===== GRID ===== */
        .ct-main {
            max-width: 1200px;
            margin: 32px auto 80px;
            padding: 0 24px;
        }
        .ct-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 24px;
        }
        @media(max-width: 1024px) { .ct-grid { grid-template-columns: repeat(2, 1fr); } }
        @media(max-width: 640px)  { .ct-grid { grid-template-columns: 1fr; } }

        /* ===== CV CARD ===== */
        .ct-card {
            background: var(--bg-card);
            border: 1.5px solid var(--border-color);
            border-radius: 16px;
            overflow: hidden;
            transition: transform 0.3s cubic-bezier(0.4,0,0.2,1),
                        border-color 0.3s, box-shadow 0.3s;
            animation: fadeSlideUp 0.5s ease both;
        }
        .ct-card:hover {
            transform: translateY(-6px);
            border-color: rgba(99,102,241,0.45);
            box-shadow: 0 16px 40px rgba(0,0,0,0.4), 0 0 0 1px rgba(99,102,241,0.15);
        }
        @keyframes fadeSlideUp {
            from { opacity: 0; transform: translateY(20px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /* Preview area */
        .ct-preview {
            position: relative;
            width: 100%;
            aspect-ratio: 3/4;
            overflow: hidden;
            background: #1a1a2e;
        }
        .ct-preview img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            object-position: top;
            transition: transform 0.5s ease;
            display: block;
        }
        .ct-card:hover .ct-preview img { transform: scale(1.04); }

        /* Overlay */
        .ct-overlay {
            position: absolute;
            inset: 0;
            background: linear-gradient(to top,
                rgba(10,10,20,0.92) 0%,
                rgba(10,10,20,0.3) 40%,
                transparent 70%);
            display: flex;
            align-items: flex-end;
            justify-content: center;
            padding: 24px;
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        .ct-card:hover .ct-overlay { opacity: 1; }
        .ct-btn-use {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 28px;
            background: linear-gradient(135deg, #6366F1, #8B5CF6);
            color: white;
            border-radius: 10px;
            font-size: 0.9rem;
            font-weight: 700;
            text-decoration: none;
            border: none;
            cursor: pointer;
            font-family: var(--font-family);
            box-shadow: 0 4px 20px rgba(99,102,241,0.5);
            transition: transform 0.2s, box-shadow 0.2s;
            transform: translateY(8px);
            transition: transform 0.3s ease, box-shadow 0.2s;
        }
        .ct-card:hover .ct-btn-use { transform: translateY(0); }
        .ct-btn-use:hover {
            box-shadow: 0 8px 28px rgba(99,102,241,0.65);
        }

        /* Popular badge */
        .ct-badge-popular {
            position: absolute;
            top: 14px;
            left: 14px;
            padding: 4px 12px;
            background: linear-gradient(135deg, #F59E0B, #EF4444);
            color: white;
            border-radius: 9999px;
            font-size: 0.72rem;
            font-weight: 800;
            letter-spacing: 0.04em;
            box-shadow: 0 2px 10px rgba(245,158,11,0.4);
        }
        .ct-badge-new {
            position: absolute;
            top: 14px;
            left: 14px;
            padding: 4px 12px;
            background: linear-gradient(135deg, #10B981, #06B6D4);
            color: white;
            border-radius: 9999px;
            font-size: 0.72rem;
            font-weight: 800;
            letter-spacing: 0.04em;
            box-shadow: 0 2px 10px rgba(16,185,129,0.4);
        }

        /* Card info */
        .ct-info {
            padding: 18px 20px 20px;
        }
        .ct-info h3 {
            font-size: 1rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 10px;
        }
        .ct-tag-row {
            display: flex;
            gap: 6px;
            flex-wrap: wrap;
            margin-bottom: 14px;
        }
        .ct-tag {
            padding: 3px 10px;
            background: var(--bg-tertiary);
            border-radius: 6px;
            font-size: 0.73rem;
            color: var(--text-muted);
            font-weight: 500;
            border: 1px solid var(--border-color);
        }
        .ct-info-footer {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .ct-info-free {
            font-size: 0.8rem;
            color: var(--success);
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 4px;
        }
        .ct-btn-use-sm {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 7px 16px;
            background: linear-gradient(135deg, var(--primary), var(--accent));
            color: white;
            border-radius: 8px;
            font-size: 0.82rem;
            font-weight: 600;
            text-decoration: none;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .ct-btn-use-sm:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 14px rgba(99,102,241,0.4);
            color: white;
        }

        /* Empty state */
        .ct-empty {
            grid-column: 1/-1;
            text-align: center;
            padding: 80px 24px;
            color: var(--text-muted);
        }
        .ct-empty h3 { color: var(--text-secondary); font-size: 1.1rem; margin: 16px 0 8px; }
    </style>
</head>
<body class="app-page">

    <jsp:include page="/WEB-INF/views/header.jsp" />

    <!-- HERO -->
    <section class="ct-hero">
        <div class="ct-hero-inner">
            <div class="ct-hero-top">
                <div>
                    <div class="ct-hero-badge">
                        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
                        Thư viện mẫu CV
                    </div>
                    <h1 class="ct-hero-title">Chọn Mẫu <span>CV Chuyên Nghiệp</span></h1>
                    <p class="ct-hero-sub">Hàng chục mẫu CV được thiết kế bởi chuyên gia, phù hợp mọi ngành nghề. Chỉnh sửa nhanh, xuất PDF ngay.</p>
                </div>
                <div class="ct-hero-actions">
                    <a href="${pageContext.request.contextPath}/user/dashboard" class="ct-btn-back">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="15 18 9 12 15 6"/></svg>
                        Quay lại
                    </a>
                </div>
            </div>

            <!-- FILTER BAR -->
            <div class="ct-filters-wrap">
                <span class="ct-filter-label">Lọc theo:</span>
                <div class="ct-filter-pills">
                    <a href="?tag=all"          class="ct-pill ${currentTag == 'all'          ? 'active' : ''}">✦ Tất cả</a>
                    <a href="?tag=simple"       class="ct-pill ${currentTag == 'simple'       ? 'active' : ''}">📄 Đơn giản</a>
                    <a href="?tag=professional" class="ct-pill ${currentTag == 'professional' ? 'active' : ''}">💼 Chuyên nghiệp</a>
                    <a href="?tag=modern"       class="ct-pill ${currentTag == 'modern'       ? 'active' : ''}">🚀 Hiện đại</a>
                    <a href="?tag=creative"     class="ct-pill ${currentTag == 'creative'     ? 'active' : ''}">🎨 Sáng tạo</a>
                </div>
            </div>
        </div>
    </section>

    <!-- STATS -->
    <div class="ct-stats-bar">
        <strong>${empty cvList ? 0 : cvList.size()}</strong> mẫu CV
        <c:if test="${currentTag != 'all'}">
            trong nhóm "<strong>${currentTag}</strong>"
        </c:if>
        &nbsp;·&nbsp; Tất cả miễn phí
    </div>

    <!-- GRID -->
    <div class="ct-main">
        <div class="ct-grid">
            <c:choose>
                <c:when test="${empty cvList}">
                    <div class="ct-empty">
                        <svg width="56" height="56" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" opacity="0.35"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
                        <h3>Không tìm thấy mẫu CV</h3>
                        <p>Thử chọn bộ lọc khác.</p>
                        <a href="?tag=all" class="btn btn-outline" style="margin-top:16px; display:inline-flex;">Xem tất cả</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="cv" items="${cvList}" varStatus="loop">
                        <div class="ct-card" style="animation-delay: ${loop.index * 0.07}s;">

                            <div class="ct-preview">
                                <img src="${cv.image}" alt="${cv.name}" loading="lazy">

                                <%-- Badge: first 2 cards get "Phổ biến", odd index 4+ get "Mới" --%>
                                <c:if test="${loop.index < 2}">
                                    <span class="ct-badge-popular">🔥 Phổ biến</span>
                                </c:if>
                                <c:if test="${loop.index >= 4}">
                                    <span class="ct-badge-new">✨ Mới</span>
                                </c:if>

                                <div class="ct-overlay">
                                    <a href="${pageContext.request.contextPath}/user/create_cv?template=${cv.id}"
                                       class="ct-btn-use">
                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg>
                                        Dùng mẫu này
                                    </a>
                                </div>
                            </div>

                            <div class="ct-info">
                                <h3>${cv.name}</h3>
                                <div class="ct-tag-row">
                                    <c:forEach var="t" items="${cv.tags}">
                                        <span class="ct-tag">${t}</span>
                                    </c:forEach>
                                </div>
                                <div class="ct-info-footer">
                                    <span class="ct-info-free">
                                        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg>
                                        Miễn phí
                                    </span>
                                    <a href="${pageContext.request.contextPath}/user/create_cv?template=${cv.id}"
                                       class="ct-btn-use-sm">
                                        Dùng ngay →
                                    </a>
                                </div>
                            </div>

                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

</body>
</html>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bộ Câu Hỏi Phỏng Vấn - HireHub</title>
    <meta name="description" content="Tổng hợp hơn 40 câu hỏi phỏng vấn phổ biến theo lĩnh vực: IT, Marketing, Sales, HR, Tài chính, Kỹ năng mềm.">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        /* ===== HERO SECTION ===== */
        .iq-hero {
            position: relative;
            padding: 72px 0 56px;
            overflow: hidden;
            background: radial-gradient(ellipse 80% 60% at 50% -10%, rgba(99,102,241,0.28) 0%, transparent 70%),
                        var(--bg-primary);
        }
        .iq-hero::before {
            content: '';
            position: absolute;
            inset: 0;
            background: radial-gradient(ellipse 60% 50% at 80% 50%, rgba(139,92,246,0.12) 0%, transparent 70%);
            pointer-events: none;
        }
        .iq-hero-inner {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 24px;
            position: relative;
            z-index: 1;
            text-align: center;
        }
        .iq-hero-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 6px 16px;
            background: rgba(99,102,241,0.12);
            border: 1px solid rgba(99,102,241,0.3);
            border-radius: 9999px;
            font-size: 0.8rem;
            font-weight: 600;
            color: var(--primary-light);
            margin-bottom: 20px;
        }
        .iq-hero-title {
            font-size: clamp(2rem, 5vw, 3.2rem);
            font-weight: 800;
            line-height: 1.2;
            color: var(--text-primary);
            margin-bottom: 16px;
        }
        .iq-hero-title span {
            background: linear-gradient(135deg, #6366F1, #8B5CF6, #06B6D4);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .iq-hero-sub {
            font-size: 1.05rem;
            color: var(--text-secondary);
            max-width: 580px;
            margin: 0 auto 40px;
            line-height: 1.7;
        }

        /* ===== SEARCH CARD ===== */
        .iq-search-card {
            background: rgba(255,255,255,0.04);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255,255,255,0.09);
            border-radius: 18px;
            padding: 28px 32px;
            max-width: 860px;
            margin: 0 auto;
            box-shadow: 0 8px 32px rgba(0,0,0,0.35);
        }
        .iq-search-row {
            display: grid;
            grid-template-columns: 1fr 180px 160px auto;
            gap: 12px;
            align-items: center;
        }
        @media(max-width: 768px) {
            .iq-search-row { grid-template-columns: 1fr; }
        }
        .iq-input {
            padding: 11px 16px;
            background: var(--bg-tertiary);
            border: 1.5px solid var(--border-color);
            border-radius: 10px;
            color: var(--text-primary);
            font-size: 0.9rem;
            font-family: var(--font-family);
            outline: none;
            transition: border-color 0.2s;
        }
        .iq-input:focus { border-color: var(--primary); }
        .iq-input::placeholder { color: var(--text-muted); }
        .iq-btn-search {
            padding: 11px 24px;
            background: linear-gradient(135deg, var(--primary), var(--accent));
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 0.9rem;
            font-weight: 600;
            cursor: pointer;
            white-space: nowrap;
            transition: transform 0.2s, box-shadow 0.2s;
            font-family: var(--font-family);
        }
        .iq-btn-search:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(99,102,241,0.4);
        }

        /* ===== STATS BAR ===== */
        .iq-stats {
            max-width: 1200px;
            margin: 36px auto 0;
            padding: 0 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 12px;
        }
        .iq-stats-text {
            font-size: 0.9rem;
            color: var(--text-secondary);
        }
        .iq-stats-text strong { color: var(--primary-light); }

        /* ===== CATEGORY PILLS ===== */
        .iq-cats {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }
        .iq-cat-pill {
            padding: 5px 14px;
            border-radius: 9999px;
            font-size: 0.8rem;
            font-weight: 600;
            border: 1.5px solid var(--border-color);
            background: transparent;
            color: var(--text-secondary);
            cursor: pointer;
            text-decoration: none;
            transition: all 0.2s;
            font-family: var(--font-family);
        }
        .iq-cat-pill:hover, .iq-cat-pill.active {
            border-color: var(--primary);
            color: var(--primary-light);
            background: rgba(99,102,241,0.1);
        }

        /* ===== MAIN LAYOUT ===== */
        .iq-main {
            max-width: 1200px;
            margin: 32px auto 80px;
            padding: 0 24px;
            display: grid;
            grid-template-columns: 1fr 300px;
            gap: 28px;
        }
        @media(max-width: 960px) { .iq-main { grid-template-columns: 1fr; } }

        /* ===== ACCORDION LIST ===== */
        .iq-group-title {
            font-size: 1rem;
            font-weight: 700;
            color: var(--text-secondary);
            text-transform: uppercase;
            letter-spacing: 0.06em;
            margin: 32px 0 14px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .iq-group-title:first-child { margin-top: 0; }
        .iq-group-count {
            background: var(--primary-100);
            color: var(--primary-light);
            border-radius: 9999px;
            padding: 2px 10px;
            font-size: 0.75rem;
            font-weight: 700;
        }
        .iq-accordion {
            border: 1.5px solid var(--border-color);
            border-radius: 14px;
            overflow: hidden;
            margin-bottom: 10px;
            background: var(--bg-card);
            transition: border-color 0.25s, box-shadow 0.25s;
        }
        .iq-accordion.open {
            border-color: rgba(99,102,241,0.4);
            box-shadow: 0 4px 20px rgba(99,102,241,0.1);
        }
        .iq-accordion-header {
            display: flex;
            align-items: flex-start;
            gap: 14px;
            padding: 18px 20px;
            cursor: pointer;
            user-select: none;
        }
        .iq-accordion-header:hover { background: rgba(255,255,255,0.025); }
        .iq-q-num {
            width: 28px;
            height: 28px;
            border-radius: 8px;
            background: var(--primary-100);
            color: var(--primary-light);
            font-size: 0.75rem;
            font-weight: 800;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            margin-top: 1px;
        }
        .iq-q-text {
            flex: 1;
            font-size: 0.97rem;
            font-weight: 600;
            color: var(--text-primary);
            line-height: 1.5;
        }
        .iq-level-badge {
            padding: 3px 10px;
            border-radius: 9999px;
            font-size: 0.72rem;
            font-weight: 700;
            flex-shrink: 0;
        }
        .level-JUNIOR  { background: rgba(16,185,129,0.12); color: #10B981; }
        .level-MID     { background: rgba(245,158,11,0.12);  color: #F59E0B; }
        .level-SENIOR  { background: rgba(239,68,68,0.12);   color: #EF4444; }
        .level-ALL     { background: rgba(99,102,241,0.12);  color: #818CF8; }
        .iq-chevron {
            flex-shrink: 0;
            color: var(--text-muted);
            transition: transform 0.3s ease;
            margin-top: 3px;
        }
        .iq-accordion.open .iq-chevron { transform: rotate(180deg); }
        .iq-accordion-body {
            display: none;
            padding: 0 20px 20px 62px;
            animation: fadeSlide 0.25s ease;
        }
        .iq-accordion.open .iq-accordion-body { display: block; }
        @keyframes fadeSlide {
            from { opacity: 0; transform: translateY(-6px); }
            to   { opacity: 1; transform: translateY(0); }
        }
        .iq-answer {
            font-size: 0.9rem;
            color: var(--text-secondary);
            line-height: 1.8;
            white-space: pre-line;
            padding: 16px;
            background: rgba(255,255,255,0.03);
            border-radius: 10px;
            border-left: 3px solid var(--primary);
        }
        .iq-tags {
            display: flex;
            gap: 6px;
            flex-wrap: wrap;
            margin-top: 12px;
        }
        .iq-tag {
            padding: 3px 10px;
            background: var(--bg-tertiary);
            border-radius: 6px;
            font-size: 0.75rem;
            color: var(--text-muted);
            font-weight: 500;
        }

        /* ===== EMPTY STATE ===== */
        .iq-empty {
            text-align: center;
            padding: 80px 24px;
            color: var(--text-muted);
        }
        .iq-empty svg { margin-bottom: 16px; opacity: 0.4; }
        .iq-empty h3 { font-size: 1.1rem; color: var(--text-secondary); margin-bottom: 8px; }

        /* ===== SIDEBAR ===== */
        .iq-sidebar { display: flex; flex-direction: column; gap: 20px; }
        .iq-sidebar-card {
            background: rgba(255,255,255,0.04);
            border: 1px solid var(--border-color);
            border-radius: 14px;
            padding: 22px;
        }
        .iq-sidebar-title {
            font-size: 0.85rem;
            font-weight: 700;
            color: var(--text-secondary);
            text-transform: uppercase;
            letter-spacing: 0.06em;
            margin-bottom: 16px;
        }
        .iq-tip-item {
            display: flex;
            gap: 10px;
            margin-bottom: 14px;
            font-size: 0.875rem;
            color: var(--text-secondary);
            line-height: 1.5;
        }
        .iq-tip-item:last-child { margin-bottom: 0; }
        .iq-tip-icon {
            font-size: 1.1rem;
            flex-shrink: 0;
            margin-top: 1px;
        }
        .iq-cat-list { display: flex; flex-direction: column; gap: 6px; }
        .iq-cat-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 9px 12px;
            border-radius: 8px;
            font-size: 0.875rem;
            color: var(--text-secondary);
            text-decoration: none;
            transition: all 0.2s;
            cursor: pointer;
        }
        .iq-cat-item:hover { background: var(--primary-50); color: var(--primary-light); }
        .iq-cat-item.active { background: var(--primary-100); color: var(--primary-light); font-weight: 600; }
        .iq-cat-item-count {
            font-size: 0.75rem;
            background: var(--bg-tertiary);
            padding: 2px 8px;
            border-radius: 9999px;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/header.jsp" />

    <!-- HERO -->
    <section class="iq-hero">
        <div class="iq-hero-inner">
            <div class="iq-hero-badge">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M12 20h9"/><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5z"/></svg>
                Tài liệu ôn thi phỏng vấn
            </div>
            <h1 class="iq-hero-title">Bộ Câu Hỏi <span>Phỏng Vấn</span> Phổ Biến</h1>
            <p class="iq-hero-sub">Tổng hợp câu hỏi phỏng vấn thường gặp kèm gợi ý trả lời chi tiết, phân loại theo ngành nghề và cấp độ kinh nghiệm.</p>

            <div class="iq-search-card">
                <form method="GET" action="${pageContext.request.contextPath}/interview-questions">
                    <div class="iq-search-row">
                        <input type="text" name="keyword" class="iq-input"
                               placeholder="🔍 Tìm câu hỏi, kỹ năng, từ khóa..."
                               value="${keyword}">
                        <select name="category" class="iq-input">
                            <option value="">Tất cả lĩnh vực</option>
                            <option value="IT"          ${category == 'IT'          ? 'selected' : ''}>💻 Lập trình / IT</option>
                            <option value="MARKETING"   ${category == 'MARKETING'   ? 'selected' : ''}>📊 Marketing</option>
                            <option value="SALES"       ${category == 'SALES'       ? 'selected' : ''}>💼 Kinh doanh</option>
                            <option value="HR"          ${category == 'HR'          ? 'selected' : ''}>👥 Nhân sự (HR)</option>
                            <option value="FINANCE"     ${category == 'FINANCE'     ? 'selected' : ''}>💰 Tài chính</option>
                            <option value="SOFT_SKILLS" ${category == 'SOFT_SKILLS' ? 'selected' : ''}>🧠 Kỹ năng mềm</option>
                        </select>
                        <select name="level" class="iq-input">
                            <option value="">Mọi cấp độ</option>
                            <option value="JUNIOR" ${level == 'JUNIOR' ? 'selected' : ''}>Junior</option>
                            <option value="MID"    ${level == 'MID'    ? 'selected' : ''}>Mid-level</option>
                            <option value="SENIOR" ${level == 'SENIOR' ? 'selected' : ''}>Senior</option>
                        </select>
                        <button type="submit" class="iq-btn-search">Tìm kiếm</button>
                    </div>
                </form>
            </div>
        </div>
    </section>

    <!-- STATS + PILLS -->
    <div class="iq-stats">
        <p class="iq-stats-text">
            Tìm thấy <strong>${totalCount}</strong> câu hỏi
            <c:if test="${not empty keyword}"> cho "<strong>${keyword}</strong>"</c:if>
        </p>
        <div class="iq-cats">
            <a href="${pageContext.request.contextPath}/interview-questions"
               class="iq-cat-pill ${empty category ? 'active' : ''}">Tất cả</a>
            <a href="${pageContext.request.contextPath}/interview-questions?category=IT"
               class="iq-cat-pill ${category == 'IT' ? 'active' : ''}">💻 IT</a>
            <a href="${pageContext.request.contextPath}/interview-questions?category=MARKETING"
               class="iq-cat-pill ${category == 'MARKETING' ? 'active' : ''}">📊 Marketing</a>
            <a href="${pageContext.request.contextPath}/interview-questions?category=SALES"
               class="iq-cat-pill ${category == 'SALES' ? 'active' : ''}">💼 Kinh doanh</a>
            <a href="${pageContext.request.contextPath}/interview-questions?category=HR"
               class="iq-cat-pill ${category == 'HR' ? 'active' : ''}">👥 HR</a>
            <a href="${pageContext.request.contextPath}/interview-questions?category=FINANCE"
               class="iq-cat-pill ${category == 'FINANCE' ? 'active' : ''}">💰 Tài chính</a>
            <a href="${pageContext.request.contextPath}/interview-questions?category=SOFT_SKILLS"
               class="iq-cat-pill ${category == 'SOFT_SKILLS' ? 'active' : ''}">🧠 Kỹ năng mềm</a>
        </div>
    </div>

    <!-- MAIN CONTENT -->
    <div class="iq-main">
        <!-- LEFT: Q&A LIST -->
        <div class="iq-list-col">
            <c:choose>
                <c:when test="${empty questions}">
                    <div class="iq-empty">
                        <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
                        <h3>Không tìm thấy câu hỏi phù hợp</h3>
                        <p>Thử thay đổi từ khóa hoặc bộ lọc khác.</p>
                        <a href="${pageContext.request.contextPath}/interview-questions" class="btn btn-outline" style="margin-top:16px; display:inline-flex;">Xem tất cả câu hỏi</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <%-- Group by category --%>
                    <c:set var="lastCat" value="__NONE__" />
                    <c:set var="idx" value="0" />
                    <c:forEach var="q" items="${questions}">
                        <c:if test="${q.category != lastCat}">
                            <div class="iq-group-title">
                                ${q.categoryLabel}
                                <%-- count badge per group --%>
                            </div>
                            <c:set var="lastCat" value="${q.category}" />
                            <c:set var="idx" value="0" />
                        </c:if>
                        <c:set var="idx" value="${idx + 1}" />

                        <div class="iq-accordion" id="acc-${q.id}">
                            <div class="iq-accordion-header" onclick="toggleAcc(${q.id})">
                                <div class="iq-q-num">${idx}</div>
                                <div class="iq-q-text">${q.question}</div>
                                <span class="iq-level-badge level-${q.level}">${q.levelLabel}</span>
                                <svg class="iq-chevron" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="6 9 12 15 18 9"/></svg>
                            </div>
                            <div class="iq-accordion-body">
                                <div class="iq-answer">${q.answer}</div>
                                <div class="iq-tags">
                                    <c:forEach var="tag" items="${q.tags}">
                                        <span class="iq-tag">${tag}</span>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- RIGHT: SIDEBAR -->
        <aside class="iq-sidebar">
            <!-- Tips -->
            <div class="iq-sidebar-card">
                <div class="iq-sidebar-title">💡 Mẹo phỏng vấn</div>
                <div class="iq-tip-item">
                    <span class="iq-tip-icon">📌</span>
                    <span>Dùng phương pháp <strong>STAR</strong> (Situation – Task – Action – Result) để trả lời câu hỏi hành vi.</span>
                </div>
                <div class="iq-tip-item">
                    <span class="iq-tip-icon">⏱️</span>
                    <span>Trả lời trong vòng <strong>1–2 phút</strong> cho mỗi câu. Không dài quá, không ngắn quá.</span>
                </div>
                <div class="iq-tip-item">
                    <span class="iq-tip-icon">🔢</span>
                    <span>Luôn dùng <strong>số liệu cụ thể</strong> để minh chứng thành tích của bạn.</span>
                </div>
                <div class="iq-tip-item">
                    <span class="iq-tip-icon">🤝</span>
                    <span>Chuẩn bị <strong>2–3 câu hỏi ngược lại</strong> cho nhà tuyển dụng để thể hiện sự quan tâm.</span>
                </div>
                <div class="iq-tip-item">
                    <span class="iq-tip-icon">🎯</span>
                    <span>Nghiên cứu kỹ <strong>sản phẩm, văn hóa, tin tức</strong> của công ty trước khi phỏng vấn.</span>
                </div>
            </div>

            <!-- Quick links by category -->
            <div class="iq-sidebar-card">
                <div class="iq-sidebar-title">📂 Theo lĩnh vực</div>
                <div class="iq-cat-list">
                    <a href="${pageContext.request.contextPath}/interview-questions?category=IT"
                       class="iq-cat-item ${category == 'IT' ? 'active' : ''}">
                        💻 Lập trình / IT <span class="iq-cat-item-count">8</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/interview-questions?category=MARKETING"
                       class="iq-cat-item ${category == 'MARKETING' ? 'active' : ''}">
                        📊 Marketing <span class="iq-cat-item-count">4</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/interview-questions?category=SALES"
                       class="iq-cat-item ${category == 'SALES' ? 'active' : ''}">
                        💼 Kinh doanh / Sales <span class="iq-cat-item-count">3</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/interview-questions?category=HR"
                       class="iq-cat-item ${category == 'HR' ? 'active' : ''}">
                        👥 Nhân sự (HR) <span class="iq-cat-item-count">3</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/interview-questions?category=FINANCE"
                       class="iq-cat-item ${category == 'FINANCE' ? 'active' : ''}">
                        💰 Tài chính <span class="iq-cat-item-count">2</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/interview-questions?category=SOFT_SKILLS"
                       class="iq-cat-item ${category == 'SOFT_SKILLS' ? 'active' : ''}">
                        🧠 Kỹ năng mềm <span class="iq-cat-item-count">5</span>
                    </a>
                </div>
            </div>

            <!-- Level filter -->
            <div class="iq-sidebar-card">
                <div class="iq-sidebar-title">🎯 Theo cấp độ</div>
                <div class="iq-cat-list">
                    <a href="${pageContext.request.contextPath}/interview-questions?level=JUNIOR"
                       class="iq-cat-item ${level == 'JUNIOR' ? 'active' : ''}">
                        🟢 Junior <span class="iq-cat-item-count">7</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/interview-questions?level=MID"
                       class="iq-cat-item ${level == 'MID' ? 'active' : ''}">
                        🟡 Mid-level <span class="iq-cat-item-count">7</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/interview-questions?level=SENIOR"
                       class="iq-cat-item ${level == 'SENIOR' ? 'active' : ''}">
                        🔴 Senior <span class="iq-cat-item-count">6</span>
                    </a>
                </div>
            </div>
        </aside>
    </div>

    <script>
        function toggleAcc(id) {
            const el = document.getElementById('acc-' + id);
            if (!el) return;
            const isOpen = el.classList.contains('open');
            // Close all others
            document.querySelectorAll('.iq-accordion.open').forEach(a => a.classList.remove('open'));
            if (!isOpen) el.classList.add('open');
        }
    </script>
</body>
</html>

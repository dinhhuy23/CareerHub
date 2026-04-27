<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tìm kiếm hồ sơ | HireHub</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        .hero-section { padding: 90px 0 44px; text-align: center; background: linear-gradient(180deg, rgba(99,102,241,0.12) 0%, transparent 100%); }
        .search-wrap { max-width: 780px; margin: 24px auto 0; display: flex; border-radius: 99px; overflow: hidden; box-shadow: 0 8px 28px rgba(0,0,0,0.25); border: 1.5px solid rgba(255,255,255,0.1); background: rgba(255,255,255,0.06); }
        .search-wrap .s-icon { display: flex; align-items: center; padding: 0 14px 0 20px; color: rgba(255,255,255,0.4); font-size: 1.1rem; }
        .search-wrap input { flex: 1; height: 54px; padding: 0 10px 0 0; font-size: 0.95rem; border: none; outline: none; background: transparent; color: #fff; }
        .search-wrap input::placeholder { color: rgba(255,255,255,0.3); }
        .search-wrap button { height: 54px; padding: 0 32px; font-weight: 700; background: #6366f1; color: #fff; border: none; cursor: pointer; font-size: 0.9rem; transition: background .2s; border-radius: 0 99px 99px 0; flex-shrink: 0; }
        .search-wrap button:hover { background: #4f46e5; }

        /* stats pill */
        .stats-pill { display: inline-flex; align-items: center; gap: 8px; background: rgba(99,102,241,0.12); border: 1px solid rgba(99,102,241,0.25); border-radius: 99px; padding: 7px 18px; font-size: 0.83rem; color: #a5b4fc; margin-bottom: 18px; }
        .stats-pill i { font-size: 1rem; }

        /* toolbar */
        .toolbar { display: flex; align-items: center; gap: 8px; flex-wrap: wrap; margin-bottom: 26px; }
        .toolbar-label { font-size: 0.78rem; color: rgba(255,255,255,0.35); font-weight: 600; margin-right: 2px; }
        .fp { padding: 6px 16px; border-radius: 8px; border: 1.5px solid rgba(255,255,255,0.1); background: rgba(255,255,255,0.04); color: rgba(255,255,255,0.5); font-size: 0.8rem; font-weight: 600; text-decoration: none; cursor: pointer; transition: all .2s; white-space: nowrap; }
        .fp:hover { border-color: rgba(99,102,241,0.5); color: #a5b4fc; }
        .fp.active { background: #6366f1; border-color: #6366f1; color: #fff; }
        .divider { width: 1px; height: 24px; background: rgba(255,255,255,0.1); margin: 0 6px; }

        /* grid */
        .cv-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(290px,1fr)); gap: 20px; padding-bottom: 60px; }

        /* card */
        .cv-card { border-radius: 16px; padding: 22px; display: flex; flex-direction: column; align-items: center; text-align: center; position: relative; border: 1px solid rgba(255,255,255,0.08); background: rgba(255,255,255,0.03); transition: transform .22s, border-color .22s, box-shadow .22s; }
        .cv-card:hover { transform: translateY(-5px); border-color: rgba(99,102,241,0.4); box-shadow: 0 16px 36px rgba(0,0,0,0.3); }

        /* source tag top-right */
        .src-tag { position: absolute; top: 12px; right: 12px; font-size: 0.58rem; font-weight: 700; letter-spacing: .5px; padding: 3px 9px; border-radius: 6px; }
        .src-web    { background: rgba(99,102,241,0.2);  color: #a5b4fc; }
        .src-upload { background: rgba(16,185,129,0.2);  color: #6ee7b7; }

        /* avatar */
        .av { width: 72px; height: 72px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.75rem; font-weight: 800; color: #fff; margin-bottom: 12px; box-shadow: 0 6px 18px rgba(0,0,0,0.25); }
        .av-img { width: 72px; height: 72px; border-radius: 50%; object-fit: cover; margin-bottom: 12px; border: 3px solid rgba(99,102,241,0.35); }
        .av0 { background: linear-gradient(135deg,#6366f1,#8b5cf6); }
        .av1 { background: linear-gradient(135deg,#06b6d4,#3b82f6); }
        .av2 { background: linear-gradient(135deg,#f59e0b,#ef4444); }
        .av3 { background: linear-gradient(135deg,#10b981,#059669); }
        .av4 { background: linear-gradient(135deg,#ec4899,#8b5cf6); }

        .role-tag { background: rgba(99,102,241,0.13); color: #a5b4fc; padding: 4px 13px; border-radius: 99px; font-size: 0.73rem; font-weight: 600; margin-bottom: 8px; max-width: 100%; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
        .cv-name  { font-size: 0.97rem; font-weight: 700; color: #f1f5f9; margin-bottom: 3px; }
        .cv-title { font-size: 0.76rem; color: rgba(255,255,255,0.35); font-style: italic; margin-bottom: 14px; }

        /* contact info (masked) */
        .info-line { display: flex; align-items: center; gap: 7px; font-size: 0.75rem; color: rgba(255,255,255,0.45); margin-bottom: 4px; align-self: stretch; }
        .info-line i { font-size: 0.8rem; color: rgba(99,102,241,0.6); width: 14px; }
        .info-block { width: 100%; margin-bottom: 12px; }

        /* action buttons */
        .card-btns { display: flex; gap: 8px; width: 100%; margin-top: auto; }
        .btn-view { flex: 1; padding: 9px 0; border-radius: 9px; background: rgba(255,255,255,0.06); border: 1.5px solid rgba(255,255,255,0.12); color: rgba(255,255,255,0.7); font-size: 0.78rem; font-weight: 600; cursor: pointer; text-decoration: none; display: flex; align-items: center; justify-content: center; gap: 5px; transition: all .2s; }
        .btn-view:hover { background: rgba(99,102,241,0.2); border-color: #6366f1; color: #fff; }
        .btn-contact { padding: 9px 13px; border-radius: 9px; background: rgba(99,102,241,0.15); border: 1.5px solid rgba(99,102,241,0.3); color: #a5b4fc; font-size: 0.78rem; font-weight: 600; cursor: pointer; transition: all .2s; display: flex; align-items: center; gap: 5px; }
        .btn-contact:hover { background: rgba(99,102,241,0.35); color: #fff; }

        /* empty */
        .empty-state { text-align: center; padding: 70px 40px; border: 1px dashed rgba(255,255,255,0.1); border-radius: 18px; }
        .empty-state i { font-size: 3rem; color: rgba(255,255,255,0.12); display: block; margin-bottom: 14px; }

        /* pagination */
        .paging { display: flex; justify-content: center; gap: 8px; padding: 16px 0 60px; flex-wrap: wrap; }
        .pg { padding: 8px 16px; border-radius: 9px; font-weight: 600; font-size: 0.83rem; border: 1.5px solid rgba(255,255,255,0.1); background: rgba(255,255,255,0.04); color: rgba(255,255,255,0.45); cursor: pointer; text-decoration: none; transition: all .2s; }
        .pg:hover { border-color: #6366f1; color: #a5b4fc; }
        .pg.active { background: #6366f1; border-color: #6366f1; color: #fff; }
        .pg.off { opacity: .25; pointer-events: none; }

        /* contact modal */
        .m-overlay { display: none; position: fixed; inset: 0; z-index: 9000; background: rgba(0,0,0,0.65); backdrop-filter: blur(8px); align-items: center; justify-content: center; }
        .m-overlay.show { display: flex; }
        .m-box { background: #1a1d2e; border: 1px solid rgba(255,255,255,0.1); border-radius: 20px; padding: 30px; width: 370px; max-width: 92vw; box-shadow: 0 24px 60px rgba(0,0,0,0.55); animation: mIn .25s ease; }
        @keyframes mIn { from{transform:translateY(-16px);opacity:0} to{transform:translateY(0);opacity:1} }
        .m-box h4 { color: #f1f5f9; font-weight: 700; margin-bottom: 3px; }
        .m-sub { color: rgba(255,255,255,0.3); font-size: 0.8rem; margin-bottom: 20px; }
        .m-row { display: flex; align-items: center; gap: 12px; background: rgba(255,255,255,0.05); border-radius: 11px; padding: 11px 14px; margin-bottom: 9px; }
        .m-row .lbl { font-size: 0.68rem; color: rgba(255,255,255,0.3); margin-bottom: 2px; }
        .m-row .val { font-size: 0.88rem; color: #e2e8f0; font-weight: 600; }
        .m-row .val a { color: #a5b4fc; text-decoration: none; }
        .m-close { width: 100%; margin-top: 14px; padding: 10px; border-radius: 10px; border: none; background: rgba(99,102,241,0.18); color: #a5b4fc; font-weight: 600; cursor: pointer; transition: all .2s; font-size: 0.88rem; }
        .m-close:hover { background: rgba(99,102,241,0.38); color: #fff; }
    </style>
</head>
<body class="app-page">
<jsp:include page="/WEB-INF/views/header.jsp" />
<div class="bg-decoration">
    <div class="bg-circle bg-circle-1"></div>
    <div class="bg-circle bg-circle-2"></div>
</div>

<%-- HERO --%>
<header class="hero-section">
    <h1 class="welcome-text"><span class="text-gradient">Tìm kiếm hồ sơ</span></h1>
    <p class="welcome-subtitle">Khám phá hàng nghìn hồ sơ chất lượng, tìm ứng viên phù hợp nhất</p>
    <form action="${pageContext.request.contextPath}/employer/browse_cv" method="GET" class="search-wrap">
        <input type="hidden" name="cvType" value="${cvType}">
        <input type="hidden" name="sort"   value="${sort}">
        <span class="s-icon"><i class="bi bi-search"></i></span>
        <input type="text"  name="keyword" value="${keyword}"
               placeholder="Tìm theo tên ứng viên, tên hồ sơ...">
        <button type="submit"><i class="bi bi-search me-2"></i>TÌM KIẾM</button>
    </form>
</header>

<main class="container main-content">

    <%-- Stats pill --%>
    <div style="margin-bottom:18px;">
        <span class="stats-pill">
            <i class="bi bi-file-earmark-person-fill"></i>
            <strong>${totalCVs}</strong> hồ sơ có sẵn
            <c:if test="${not empty keyword}"> · kết quả cho "<em>${keyword}</em>"</c:if>
        </span>
    </div>

    <%-- Toolbar --%>
    <div class="toolbar">
        <span class="toolbar-label"><i class="bi bi-funnel me-1"></i>Lọc:</span>
        <a href="?keyword=${keyword}&sort=${sort}&cvType=all"
           class="fp ${cvType == 'all' ? 'active' : ''}">
            <i class="bi bi-grid me-1"></i>Tất cả
        </a>
        <a href="?keyword=${keyword}&sort=${sort}&cvType=web"
           class="fp ${cvType == 'web' ? 'active' : ''}">
            <i class="bi bi-window-sidebar me-1"></i>Web Builder
        </a>
        <a href="?keyword=${keyword}&sort=${sort}&cvType=upload"
           class="fp ${cvType == 'upload' ? 'active' : ''}">
            <i class="bi bi-file-earmark-arrow-up me-1"></i>File tải lên
        </a>

        <div class="divider"></div>
        <span class="toolbar-label">Sắp xếp:</span>
        <a href="?keyword=${keyword}&cvType=${cvType}&sort=newest&page=1"
           class="fp ${sort == 'newest' ? 'active' : ''}">
            <i class="bi bi-calendar-event me-1"></i>Mới nhất
        </a>
        <a href="?keyword=${keyword}&cvType=${cvType}&sort=az&page=1"
           class="fp ${sort == 'az' ? 'active' : ''}">
            <i class="bi bi-sort-alpha-down me-1"></i>A – Z
        </a>
    </div>

    <%-- Grid --%>
    <c:choose>
        <c:when test="${not empty listCV}">
            <div class="cv-grid">
                <c:forEach items="${listCV}" var="cv" varStatus="vs">
                    <c:set var="fName"  value="${not empty cv.fullName   ? cv.fullName   : 'Người dùng ẩn danh'}"/>
                    <c:set var="tRole"  value="${not empty cv.targetRole  ? cv.targetRole  : 'Chưa cập nhật'}"/>
                    <c:set var="cTitle" value="${not empty cv.cvTitle    ? cv.cvTitle    : 'Hồ sơ tải lên'}"/>
                    <c:set var="init"   value="${fn:toUpperCase(fn:substring(fName,0,1))}"/>

                    <%-- Mask email: abc***@domain.com --%>
                    <c:set var="rawEmail" value="${cv.email}"/>
                    <c:set var="maskEmail" value=""/>
                    <c:if test="${not empty rawEmail}">
                        <c:set var="atIdx" value="${fn:indexOf(rawEmail,'@')}"/>
                        <c:choose>
                            <c:when test="${atIdx > 3}">
                                <c:set var="maskEmail" value="${fn:substring(rawEmail,0,3)}***${fn:substring(rawEmail,atIdx,fn:length(rawEmail))}"/>
                            </c:when>
                            <c:otherwise>
                                <c:set var="maskEmail" value="${rawEmail}"/>
                            </c:otherwise>
                        </c:choose>
                    </c:if>

                    <%-- Mask phone: 0976****20 --%>
                    <c:set var="rawPhone" value="${cv.phone}"/>
                    <c:set var="maskPhone" value=""/>
                    <c:if test="${not empty rawPhone}">
                        <c:set var="pLen" value="${fn:length(rawPhone)}"/>
                        <c:choose>
                            <c:when test="${pLen >= 8}">
                                <c:set var="maskPhone" value="${fn:substring(rawPhone,0,4)}****${fn:substring(rawPhone,pLen-2,pLen)}"/>
                            </c:when>
                            <c:otherwise>
                                <c:set var="maskPhone" value="${rawPhone}"/>
                            </c:otherwise>
                        </c:choose>
                    </c:if>

                    <div class="glass-card cv-card">
                        <%-- Source tag (top-right) --%>
                        <span class="src-tag ${cv.isUpload == 1 ? 'src-upload' : 'src-web'}">
                            ${cv.isUpload == 1 ? 'UPLOAD' : 'WEB'}
                        </span>

                        <%-- Avatar: luon hien chu cai gradient (khong hien anh) --%>
                        <div class="av av${vs.index % 5}">${init}</div>

                        <span class="role-tag">${tRole}</span>
                        <div class="cv-name">${fName}</div>
                        <div class="cv-title">${cTitle}</div>

                        <%-- Masked contact info --%>
                        <div class="info-block">
                            <c:if test="${not empty maskEmail}">
                                <div class="info-line">
                                    <i class="bi bi-envelope-fill"></i> ${maskEmail}
                                </div>
                            </c:if>
                            <c:if test="${not empty maskPhone}">
                                <div class="info-line">
                                    <i class="bi bi-telephone-fill"></i> ${maskPhone}
                                </div>
                            </c:if>
                            <c:if test="${not empty cv.updatedAt}">
                                <div class="info-line">
                                    <i class="bi bi-calendar3"></i>
                                    Cập nhật: <fmt:formatDate value="${cv.updatedAt}" pattern="dd/MM/yyyy"/>
                                </div>
                            </c:if>
                        </div>

                        <%-- Buttons --%>
                        <div class="card-btns">
                            <c:choose>
                                <c:when test="${cv.isUpload == 1}">
                                    <a href="${pageContext.request.contextPath}/user/cv/view?id=${cv.userCVId}"
                                       class="btn-view" target="_blank">
                                        <i class="bi bi-eye"></i>Xem hồ sơ
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/user/cv/preview?id=${cv.userCVId}"
                                       class="btn-view" target="_blank">
                                        <i class="bi bi-eye"></i>Xem hồ sơ
                                    </a>
                                </c:otherwise>
                            </c:choose>
                            <c:if test="${not empty cv.email or not empty cv.phone}">
                                <button class="btn-contact"
                                        onclick="openContact('${fn:escapeXml(fName)}','${fn:escapeXml(tRole)}','${fn:escapeXml(cv.email)}','${fn:escapeXml(cv.phone)}')">
                                    <i class="bi bi-send-fill"></i>Liên hệ
                                </button>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="empty-state glass-card">
                <i class="bi bi-file-earmark-person"></i>
                <p style="color:rgba(255,255,255,0.35); margin-bottom:18px;">Không tìm thấy hồ sơ phù hợp.</p>
                <a href="${pageContext.request.contextPath}/employer/browse_cv" class="btn btn-outline">Xem tất cả hồ sơ</a>
            </div>
        </c:otherwise>
    </c:choose>

    <%-- Pagination --%>
    <c:if test="${totalPages > 1}">
        <div class="paging">
            <a href="?keyword=${keyword}&cvType=${cvType}&sort=${sort}&page=${currentPage > 1 ? currentPage-1 : 1}"
               class="pg ${currentPage <= 1 ? 'off' : ''}"><i class="bi bi-chevron-left"></i></a>
            <c:forEach begin="1" end="${totalPages}" var="i">
                <c:choose>
                    <c:when test="${i == currentPage}"><span class="pg active">${i}</span></c:when>
                    <c:otherwise><a href="?keyword=${keyword}&cvType=${cvType}&sort=${sort}&page=${i}" class="pg">${i}</a></c:otherwise>
                </c:choose>
            </c:forEach>
            <a href="?keyword=${keyword}&cvType=${cvType}&sort=${sort}&page=${currentPage < totalPages ? currentPage+1 : totalPages}"
               class="pg ${currentPage >= totalPages ? 'off' : ''}"><i class="bi bi-chevron-right"></i></a>
        </div>
    </c:if>
</main>

<%-- CONTACT MODAL (full info) --%>
<div class="m-overlay" id="cModal" onclick="if(event.target.id==='cModal')closeContact()">
    <div class="m-box">
        <h4 id="mName"></h4>
        <p class="m-sub" id="mRole"></p>
        <div class="m-row" id="mEmailRow">
            <span style="font-size:1.35rem;">📧</span>
            <div><div class="lbl">Email</div><div class="val"><a id="mEmail" href=""></a></div></div>
        </div>
        <div class="m-row" id="mPhoneRow">
            <span style="font-size:1.35rem;">📞</span>
            <div><div class="lbl">Điện thoại</div><div class="val" id="mPhone"></div></div>
        </div>
        <button class="m-close" onclick="closeContact()">Đóng</button>
    </div>
</div>

<script>
    function openContact(name, role, email, phone) {
        document.getElementById('mName').textContent = name;
        document.getElementById('mRole').textContent = role;
        var er = document.getElementById('mEmailRow'), me = document.getElementById('mEmail');
        if (email && email.trim()) { me.textContent = email; me.href = 'mailto:' + email; er.style.display = 'flex'; }
        else er.style.display = 'none';
        var pr = document.getElementById('mPhoneRow'), mp = document.getElementById('mPhone');
        if (phone && phone.trim()) { mp.textContent = phone; pr.style.display = 'flex'; }
        else pr.style.display = 'none';
        document.getElementById('cModal').classList.add('show');
    }
    function closeContact() { document.getElementById('cModal').classList.remove('show'); }
    document.addEventListener('keydown', function(e){ if(e.key==='Escape') closeContact(); });
</script>
</body>
</html>
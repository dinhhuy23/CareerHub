<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Recruiting Companies</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/company.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <style>
            .toast-container{position:fixed;top:24px;right:24px;z-index:9999;display:flex;flex-direction:column;gap:10px}
            .toast{display:flex;align-items:center;gap:12px;padding:14px 20px;border-radius:12px;font-size:.88rem;font-weight:600;min-width:280px;max-width:420px;box-shadow:0 8px 32px rgba(0,0,0,.35);animation:toastIn .3s ease;backdrop-filter:blur(10px)}
            .toast.success{background:rgba(16,185,129,.18);color:#34d399;border:1px solid rgba(16,185,129,.3)}
            .toast.error{background:rgba(239,68,68,.18);color:#f87171;border:1px solid rgba(239,68,68,.3)}
            .toast-close{margin-left:auto;cursor:pointer;opacity:.7;background:none;border:none;color:inherit;font-size:1rem;line-height:1;padding:0}
            .toast-close:hover{opacity:1}
            @keyframes toastIn{from{opacity:0;transform:translateX(30px)}to{opacity:1;transform:translateX(0)}}
            @keyframes toastOut{from{opacity:1;transform:translateX(0)}to{opacity:0;transform:translateX(30px)}}
        </style>
    </head>
    <body>
        <jsp:include page="/WEB-INF/views/header.jsp" />

        <%-- Toast flash from session --%>
        <c:if test="${not empty toastType}">
            <div class="toast-container" id="toastContainer">
                <div class="toast ${toastType}" id="mainToast">
                    <c:choose>
                        <c:when test="${toastType == 'success'}"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" style="flex-shrink:0"><polyline points="20 6 9 17 4 12"/></svg></c:when>
                        <c:otherwise><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="flex-shrink:0"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg></c:otherwise>
                    </c:choose>
                    <span><c:out value="${toastMsg}"/></span>
                    <button class="toast-close" onclick="this.closest('.toast').remove()">&times;</button>
                </div>
            </div>
            <script>
                (function(){var t=document.getElementById('mainToast');if(!t)return;setTimeout(function(){t.style.animation='toastOut .3s ease forwards';setTimeout(function(){t.remove()},320)},4000);})();
            </script>
        </c:if>

        <div class="page-container">
            <div class="page-header">
                <h1 class="page-title">Danh sách công ty</h1>
                <a class="btn btn-primary" href="${pageContext.request.contextPath}/company/create">+ Thêm Công Ty</a>
            </div>

            <div class="list-toolbar">
                <form method="get" action="" id="filterForm" style="display:contents;">
                    <input type="text" name="keyword" class="search-box" id="searchInput"
                           value="<c:out value='${keyword}'/>"
                           placeholder="Tìm tên công ty...">

                    <select name="industry" class="filter-select" id="industryFilter" onchange="this.form.submit()">
                        <option value="All" ${industry == 'All' ? 'selected' : ''}>All Industries</option>
                        <c:forEach items="${industriesList}" var="ind">
                            <option value="${ind}" ${industry == ind ? 'selected' : ''}>${ind}</option>
                        </c:forEach>
                    </select>

                    <select name="location" class="filter-select" id="locationFilter" onchange="this.form.submit()">
                        <option value="All" ${location == 'All' ? 'selected' : ''}>All Locations</option>
                        <c:forEach items="${locationsList}" var="loc">
                            <option value="${loc.locationName}" ${location == loc.locationName ? 'selected' : ''}>${loc.locationName}</option>
                        </c:forEach>
                    </select>

                    <select name="size" class="filter-select" id="sizeFilter" onchange="this.form.submit()">
                        <option value="All" ${size == 'All' ? 'selected' : ''}>All Sizes</option>
                        <c:forEach items="${sizesList}" var="s">
                            <option value="${s}" ${size == s ? 'selected' : ''}>${s}</option>
                        </c:forEach>
                    </select>

                    <select name="status" class="filter-select" id="statusFilter" onchange="this.form.submit()">
                        <option value="All" ${status == 'All' ? 'selected' : ''}>All Statuses</option>
                        <c:forEach items="${statusesList}" var="st">
                            <option value="${st}" ${status == st ? 'selected' : ''}>${st}</option>
                        </c:forEach>
                    </select>

                    <button type="submit" style="padding:10px 18px;border-radius:8px;background:linear-gradient(135deg,var(--primary),var(--accent));color:white;border:none;font-size:0.875rem;font-weight:600;cursor:pointer;white-space:nowrap;">Tìm kiếm</button>
                </form>
            </div>


            <div class="company-list-grid" id="companyList">
                <c:forEach items="${companies}" var="company">
                    <div class="company-card"
                         data-name="${fn:toLowerCase(company.companyName)}"
                         data-industry="${company.industry}"
                         data-location="${not empty company.location ? company.location.locationName : ''}">
                        <div class="company-card-header">
                            <img src="${company.logoUrl}" alt="${company.companyName} Logo" class="company-card-logo">
                            <div class="company-card-info">
                                <h2>${company.companyName}</h2>
                                <p>${company.industry}</p>
                                <span class="status-badge ${company.status == 'ACTIVE' ? 'status-active' : (company.status == 'PENDING' ? 'status-pending' : 'status-inactive')}">${company.status}</span>
                            </div>
                        </div>
                        <div class="company-card-body">
                            <p><strong>Size:</strong> ${company.companySize}</p>
                            <p><strong>Location:</strong> <c:out value="${not empty company.location ? company.location.locationName : 'N/A'}"/></p>
                            <p><strong>Website:</strong> ${company.websiteUrl}</p>
                            <p class="company-short-desc">${company.description}</p>
                        </div>
                        <div class="company-card-footer">
                            <a href="${pageContext.request.contextPath}/company/detail?id=${company.companyId}" class="btn btn-primary">Xem Chi Tiết</a>
                        </div>
                    </div>
                </c:forEach>
                <c:if test="${empty companies}">
                    <p style="text-align:center;padding:48px;color:var(--text-muted);width:100%;">
                        Không tìm thấy công ty phù hợp.
                    </p>
                </c:if>
            </div>

            <%-- Pagination --%>
            <c:if test="${totalPages > 1}">
            <div style="display:flex;align-items:center;justify-content:space-between;padding:24px 0;flex-wrap:wrap;gap:12px;">
                <span style="font-size:0.85rem;color:var(--text-muted);">
                    Hiển thị ${(currentPage-1)*10+1}–${(currentPage*10 > totalItems) ? totalItems : currentPage*10}
                    trong <strong style="color:var(--text-primary);">${totalItems}</strong> công ty
                </span>
                <div style="display:flex;align-items:center;gap:6px;">
                    <c:choose>
                        <c:when test="${currentPage == 1}"><span class="pg-btn disabled">&#8592;</span></c:when>
                        <c:otherwise><a class="pg-btn" href="?page=${currentPage-1}&keyword=${fn:escapeXml(keyword)}&industry=${fn:escapeXml(industry)}&location=${fn:escapeXml(location)}&size=${fn:escapeXml(size)}&status=${fn:escapeXml(status)}">&#8592;</a></c:otherwise>
                    </c:choose>
                    <c:forEach var="pn" items="${pageNums}">
                        <c:choose>
                            <c:when test="${pn == -1}"><span style="padding:0 6px;color:var(--text-muted);">&#8230;</span></c:when>
                            <c:when test="${pn == currentPage}"><span class="pg-btn active">${pn}</span></c:when>
                            <c:otherwise><a class="pg-btn" href="?page=${pn}&keyword=${fn:escapeXml(keyword)}&industry=${fn:escapeXml(industry)}&location=${fn:escapeXml(location)}&size=${fn:escapeXml(size)}&status=${fn:escapeXml(status)}">${pn}</a></c:otherwise>
                        </c:choose>
                    </c:forEach>
                    <c:choose>
                        <c:when test="${currentPage == totalPages}"><span class="pg-btn disabled">&#8594;</span></c:when>
                        <c:otherwise><a class="pg-btn" href="?page=${currentPage+1}&keyword=${fn:escapeXml(keyword)}&industry=${fn:escapeXml(industry)}&location=${fn:escapeXml(location)}&size=${fn:escapeXml(size)}&status=${fn:escapeXml(status)}">&#8594;</a></c:otherwise>
                    </c:choose>
                </div>
            </div>
            </c:if>
        </div>

        <%-- Pagination button styles --%>
        <style>
            .pg-btn { display:inline-flex;align-items:center;justify-content:center;min-width:36px;height:36px;padding:0 10px;border-radius:8px;font-size:0.85rem;font-weight:600;text-decoration:none;background:var(--glass-bg,rgba(255,255,255,0.05));border:1px solid var(--glass-border,rgba(255,255,255,0.1));color:var(--text-secondary,#94a3b8);transition:all 0.15s;cursor:pointer; }
            .pg-btn:hover:not(.disabled):not(.active){background:rgba(99,102,241,0.1);border-color:#6366f1;color:#818cf8;}
            .pg-btn.active{background:linear-gradient(135deg,#6366f1,#8b5cf6);border-color:transparent;color:white;box-shadow:0 4px 12px rgba(99,102,241,0.4);}
            .pg-btn.disabled{opacity:0.35;cursor:not-allowed;pointer-events:none;}
        </style>
        <script>
            // Submit on Enter
            (function(){
                var si = document.getElementById('searchInput');
                if (si) si.addEventListener('keydown', function(e){
                    if (e.key === 'Enter'){ e.preventDefault(); document.getElementById('filterForm').submit(); }
                });
            })();
        </script>
    </body>
</html>
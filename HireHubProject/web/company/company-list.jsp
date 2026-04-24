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
                <input type="text" class="search-box" id="searchInput" placeholder="Search company name...">

                <select class="filter-select" id="industryFilter">
                    <option value="All">All Industries</option>
                    <option value="Information Technology">Information Technology</option>
                    <option value="Technology & Digital Services">Technology & Digital Services</option>
                    <option value="Finance & Banking">Finance & Banking</option>
                    <option value="Software Outsourcing">Software Outsourcing</option>
                    <option value="Healthcare">Healthcare</option>
                    <option value="Human Resources Technology">Human Resources Technology</option>
                </select>

                <select class="filter-select" id="locationFilter">
                    <option value="All">All Locations</option>
                    <option value="Ha Noi">Ha Noi</option>
                    <option value="Ho Chi Minh City">Ho Chi Minh City</option>
                    <option value="Da Nang">Da Nang</option>
                </select>
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
                                <span class="status-badge status-active">${company.status}</span>
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
            </div>
        </div>

        <%-- Script nhúng thẳng vào trang, không dùng file company.js ngoài để tránh cache cũ --%>
        <script>
            (function () {
                var searchInput    = document.getElementById('searchInput');
                var industryFilter = document.getElementById('industryFilter');
                var locationFilter = document.getElementById('locationFilter');
                var container      = document.getElementById('companyList');

                function filterCards() {
                    if (!container) return;
                    var search   = searchInput   ? searchInput.value.trim().toLowerCase() : '';
                    var industry = industryFilter ? industryFilter.value : 'All';
                    var location = locationFilter ? locationFilter.value : 'All';

                    var cards = container.querySelectorAll('.company-card');
                    var visible = 0;

                    cards.forEach(function (card) {
                        var name = (card.getAttribute('data-name') || '').toLowerCase();
                        var ind  = (card.getAttribute('data-industry') || '');
                        var loc  = (card.getAttribute('data-location') || '');

                        var ok = name.includes(search)
                            && (industry === 'All' || ind === industry)
                            && (location === 'All' || loc === location);

                        card.style.display = ok ? '' : 'none';
                        if (ok) visible++;
                    });

                    var msg = container.querySelector('.empty-filter-msg');
                    if (visible === 0 && cards.length > 0) {
                        if (!msg) {
                            msg = document.createElement('p');
                            msg.className = 'empty-filter-msg empty-text';
                            msg.style.cssText = 'text-align:center;padding:32px;color:var(--text-muted);width:100%;';
                            msg.textContent = 'Không tìm thấy công ty phù hợp.';
                            container.appendChild(msg);
                        }
                    } else if (msg) {
                        msg.remove();
                    }
                }

                if (searchInput)    searchInput.addEventListener('input',   filterCards);
                if (industryFilter) industryFilter.addEventListener('change', filterCards);
                if (locationFilter) locationFilter.addEventListener('change', filterCards);
            })();
        </script>
    </body>
</html>
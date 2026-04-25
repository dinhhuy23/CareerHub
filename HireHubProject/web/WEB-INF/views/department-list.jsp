<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý phòng ban | HireHub Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .dl-container {
            max-width: 1400px; margin: 0 auto;
            padding: var(--space-xl) var(--space-lg) var(--space-3xl);
        }

        /* ── Header ── */
        .dl-header {
            display: flex; align-items: center; justify-content: space-between;
            margin-bottom: var(--space-xl); flex-wrap: wrap; gap: 12px;
        }
        .dl-title {
            font-size: 1.6rem; font-weight: 800; color: var(--text-primary);
            display: flex; align-items: center; gap: 12px;
        }
        .dl-title-icon {
            width: 42px; height: 42px; border-radius: 12px;
            background: linear-gradient(135deg, var(--primary), var(--accent));
            display: flex; align-items: center; justify-content: center;
            box-shadow: 0 4px 12px rgba(99,102,241,0.4);
        }

        /* ── Stats ── */
        .dl-stats {
            display: flex; gap: var(--space-md); margin-bottom: var(--space-xl); flex-wrap: wrap;
        }
        .dl-stat {
            background: var(--glass-bg); backdrop-filter: var(--glass-blur);
            border: 1px solid var(--glass-border); border-radius: var(--radius-lg);
            padding: 14px 20px; display: flex; align-items: center; gap: 12px;
            box-shadow: var(--glass-shadow); flex: 1; min-width: 150px;
        }
        .dl-stat-icon {
            width: 38px; height: 38px; border-radius: 10px;
            display: flex; align-items: center; justify-content: center; flex-shrink: 0;
        }
        .dl-stat-icon.primary { background: var(--primary-100); color: var(--primary-light); }
        .dl-stat-icon.success { background: var(--success-light); color: var(--success); }
        .dl-stat-icon.error   { background: var(--error-light);   color: var(--error); }
        .dl-stat-num { font-size: 1.4rem; font-weight: 800; color: var(--text-primary); display: block; }
        .dl-stat-lbl { font-size: 0.75rem; color: var(--text-muted); margin-top: 2px; display: block; }

        /* ── Toolbar ── */
        .dl-toolbar {
            display: flex; gap: 12px; margin-bottom: var(--space-xl); flex-wrap: wrap;
        }
        .search-wrap { position: relative; flex: 1; min-width: 240px; }
        .search-icon {
            position: absolute; left: 12px; top: 50%; transform: translateY(-50%);
            color: var(--text-muted); pointer-events: none;
        }
        .dl-search {
            width: 100%; padding: 11px 16px 11px 40px;
            background: var(--glass-bg); backdrop-filter: var(--glass-blur);
            border: 1px solid var(--glass-border); border-radius: var(--radius-md);
            color: var(--text-primary); font-size: 0.9rem; outline: none;
            transition: border-color 0.2s;
        }
        .dl-search:focus { border-color: var(--primary); }
        .dl-search::placeholder { color: var(--text-muted); }
        .dl-filter {
            padding: 11px 16px; min-width: 170px;
            background: var(--glass-bg); backdrop-filter: var(--glass-blur);
            border: 1px solid var(--glass-border); border-radius: var(--radius-md);
            color: var(--text-primary); font-size: 0.9rem; outline: none; cursor: pointer;
            transition: border-color 0.2s;
        }
        .dl-filter:focus { border-color: var(--primary); }
        .dl-filter option { background: var(--bg-secondary); }

        /* ── Table card ── */
        .dl-card {
            background: var(--glass-bg); backdrop-filter: var(--glass-blur);
            -webkit-backdrop-filter: var(--glass-blur);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-xl); box-shadow: var(--glass-shadow);
            overflow: hidden;
        }
        .dl-table-wrap { overflow-x: auto; }
        .dl-table { width: 100%; border-collapse: collapse; }
        .dl-table thead tr {
            background: linear-gradient(135deg, var(--primary), var(--accent));
        }
        .dl-table th {
            padding: 14px 12px; text-align: left;
            font-size: 0.75rem; font-weight: 700;
            text-transform: uppercase; letter-spacing: 0.5px;
            color: rgba(255,255,255,0.9); white-space: nowrap;
        }
        .dl-table td {
            padding: 14px 12px; font-size: 0.875rem;
            border-bottom: 1px solid rgba(255,255,255,0.04);
            color: var(--text-primary); vertical-align: middle;
        }
        .dl-table tbody tr { transition: background 0.15s; }
        .dl-table tbody tr:hover { background: var(--primary-50); }
        .dl-table tbody tr:last-child td { border-bottom: none; }

        /* ── Dept icon ── */
        .dept-icon {
            width: 36px; height: 36px; border-radius: 10px; flex-shrink: 0;
            background: linear-gradient(135deg, var(--primary), var(--accent));
            display: inline-flex; align-items: center; justify-content: center;
            font-weight: 700; font-size: 0.82rem; color: white; margin-right: 10px;
        }
        .name-cell { display: flex; align-items: center; }
        .name-main { font-weight: 600; color: var(--text-primary); }
        .desc-cell {
            max-width: 240px; white-space: nowrap;
            overflow: hidden; text-overflow: ellipsis;
            color: var(--text-secondary); font-size: 0.85rem;
        }

        /* ── Company badge ── */
        .company-badge {
            display: inline-flex; align-items: center; gap: 5px;
            padding: 4px 10px; border-radius: 6px; font-size: 0.78rem; font-weight: 600;
            background: rgba(59,130,246,0.1); color: #60A5FA;
            border: 1px solid rgba(59,130,246,0.15);
        }

        /* ── Status ── */
        .status-pill {
            display: inline-flex; align-items: center; gap: 5px;
            padding: 4px 12px; border-radius: var(--radius-full);
            font-size: 0.72rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px;
        }
        .status-pill.active   { background: var(--success-light); color: var(--success); }
        .status-pill.inactive { background: var(--error-light);   color: var(--error); }
        .status-dot { width: 6px; height: 6px; border-radius: 50%; background: currentColor; }

        /* ── Actions ── */
        .action-btns { display: flex; gap: 8px; }
        .btn-icon {
            display: inline-flex; align-items: center; gap: 5px;
            padding: 6px 12px; border-radius: var(--radius-sm);
            font-size: 0.78rem; font-weight: 600;
            text-decoration: none; transition: all 0.15s; border: none; cursor: pointer;
        }
        .btn-icon.edit {
            background: rgba(99,102,241,0.1); color: var(--primary-light);
            border: 1px solid rgba(99,102,241,0.2);
        }
        .btn-icon.edit:hover { background: rgba(99,102,241,0.2); }
        .btn-icon.del {
            background: var(--error-light); color: var(--error);
            border: 1px solid rgba(239,68,68,0.2);
        }
        .btn-icon.del:hover { background: rgba(239,68,68,0.2); }

        /* ── Empty ── */
        .dl-empty {
            text-align: center; padding: var(--space-3xl); color: var(--text-muted);
        }
        .dl-empty svg { opacity: 0.3; display: block; margin: 0 auto 16px; }
        .dl-empty p { font-size: 0.95rem; }
    </style>
</head>
<body class="app-page">
    <jsp:include page="/WEB-INF/views/header.jsp" />

    <main class="main-content">
        <div class="dl-container">

            <!-- Header -->
            <div class="dl-header">
                <div class="dl-title">
                    <div class="dl-title-icon">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5">
                            <rect x="2" y="7" width="20" height="14" rx="2"/>
                            <path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/>
                        </svg>
                    </div>
                    Quản lý phòng ban
                </div>
                <a href="${pageContext.request.contextPath}/admin/departments?action=create" class="btn btn-primary" style="padding:10px 20px;">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" style="margin-right:6px;">
                        <line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>
                    </svg>
                    Thêm phòng ban
                </a>
            </div>

            <c:set var="activeCount" value="${activeCount}"/>

            <div class="dl-stats animate-fadeInUp">
                <div class="dl-stat">
                    <div class="dl-stat-icon primary">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="7" width="20" height="14" rx="2"/><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/></svg>
                    </div>
                    <div>
                        <span class="dl-stat-num">${totalCount}</span>
                        <span class="dl-stat-lbl">Tổng phòng ban</span>
                    </div>
                </div>
                <div class="dl-stat">
                    <div class="dl-stat-icon success">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"/></svg>
                    </div>
                    <div>
                        <span class="dl-stat-num">${activeCount}</span>
                        <span class="dl-stat-lbl">Đang hoạt động</span>
                    </div>
                </div>
                <div class="dl-stat">
                    <div class="dl-stat-icon error">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>
                    </div>
                    <div>
                        <span class="dl-stat-num">${totalCount - activeCount}</span>
                        <span class="dl-stat-lbl">Không hoạt động</span>
                    </div>
                </div>
            </div>

            <!-- Toolbar – server-side filter form -->
            <form method="get" action="" id="filterForm" class="dl-toolbar animate-fadeInUp" style="animation-delay:0.05s;">
                <div class="search-wrap">
                    <svg class="search-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
                    </svg>
                    <input type="text" name="keyword" class="dl-search" id="searchInput"
                           value="<c:out value='${keyword}'/>"
                           placeholder="Tìm tên phòng ban hoặc công ty...">
                </div>
                <select name="company" class="dl-filter" id="companyFilter" onchange="this.form.submit()">
                    <option value="All" ${companyFilter == 'All' ? 'selected' : ''}>Tất cả công ty</option>
                    <c:forEach var="c" items="${allCompanies}">
                        <option value="${fn:escapeXml(c.companyName)}" ${companyFilter == c.companyName ? 'selected' : ''}>
                            <c:out value="${c.companyName}"/>
                        </option>
                    </c:forEach>
                </select>
                <select name="status" class="dl-filter" id="statusFilter" onchange="this.form.submit()">
                    <option value="All"      ${statusFilter == 'All'      ? 'selected' : ''}>Tất cả trạng thái</option>
                    <option value="active"   ${statusFilter == 'active'   ? 'selected' : ''}>Đang hoạt động</option>
                    <option value="inactive" ${statusFilter == 'inactive' ? 'selected' : ''}>Không hoạt động</option>
                </select>
                <button type="submit" class="btn btn-primary" style="padding:10px 18px;white-space:nowrap;">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" style="margin-right:5px;"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>Tìm kiếm
                </button>
            </form>

            <!-- Table -->
            <div class="dl-card animate-fadeInUp" style="animation-delay:0.1s;">
                <div class="dl-table-wrap">
                    <table class="dl-table">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Tên phòng ban</th>
                                <th>Công ty</th>
                                <th>Mô tả</th>
                                <th>Trạng thái</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <tbody id="deptBody">
                            <c:choose>
                                <c:when test="${not empty list}">
                                    <c:forEach var="d" items="${list}" varStatus="loop">
                                        <c:set var="initial" value="${not empty d.departmentName ? fn:toUpperCase(fn:substring(d.departmentName, 0, 1)) : '?'}"/>
                                        <tr data-name="${fn:escapeXml(fn:toLowerCase(d.departmentName))}"
                                            data-company="${fn:escapeXml(d.companyName)}"
                                            data-active="${d.isActive}">
                                            <td style="color:var(--text-muted); font-size:0.8rem;">${(currentPage - 1) * 10 + loop.index + 1}</td>
                                            <td>
                                                <div class="name-cell">
                                                    <div class="dept-icon">${initial}</div>
                                                    <div class="name-main"><c:out value="${d.departmentName}"/></div>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="company-badge">
                                                    <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/></svg>
                                                    <c:out value="${d.companyName}"/>
                                                </span>
                                            </td>
                                            <td>
                                                <div class="desc-cell">
                                                    <c:out value="${not empty d.description ? d.description : '—'}"/>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="status-pill ${d.isActive ? 'active' : 'inactive'}">
                                                    <span class="status-dot"></span>
                                                    ${d.isActive ? 'Active' : 'Inactive'}
                                                </span>
                                            </td>
                                            <td>
                                                <div class="action-btns">
                                                    <a class="btn-icon edit" href="${pageContext.request.contextPath}/admin/departments?action=view&id=${d.departmentId}" style="background: rgba(16, 185, 129, 0.1); color: var(--success); border-color: rgba(16, 185, 129, 0.2);">
                                                        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>
                                                        Xem
                                                    </a>
                                                    <c:if test="${d.isActive}">
                                                        <a class="btn-icon edit" href="${pageContext.request.contextPath}/admin/departments?action=edit&id=${d.departmentId}">
                                                            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                                                            Sửa
                                                        </a>
                                                        <a class="btn-icon del"
                                                           href="${pageContext.request.contextPath}/admin/departments?action=delete&id=${d.departmentId}"
                                                           onclick="return confirm('Xác nhận khóa phòng ban này?')">
                                                            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
                                                            Khóa
                                                        </a>
                                                    </c:if>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="6">
                                            <div class="dl-empty">
                                                <svg width="52" height="52" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                                                    <rect x="2" y="7" width="20" height="14" rx="2"/>
                                                    <path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/>
                                                </svg>
                                                <p>Chưa có phòng ban nào.</p>
                                            </div>
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

            <%-- Pagination --%>
            <c:if test="${totalPages > 1}">
            <div class="pagination-wrap animate-fadeInUp" style="animation-delay:0.15s;">
                <span class="pagination-info">
                    Hiển thị ${(currentPage-1)*10+1}–${(currentPage*10 > totalItems) ? totalItems : currentPage*10}
                    trong <strong>${totalItems}</strong> kết quả
                </span>
                <div class="pagination-controls">
                    <c:choose>
                        <c:when test="${currentPage == 1}"><span class="page-btn disabled">&#8592;</span></c:when>
                        <c:otherwise><a class="page-btn" href="?page=${currentPage-1}&keyword=${fn:escapeXml(keyword)}&status=${fn:escapeXml(statusFilter)}&company=${fn:escapeXml(companyFilter)}">&#8592;</a></c:otherwise>
                    </c:choose>
                    <c:forEach var="pn" items="${pageNums}">
                        <c:choose>
                            <c:when test="${pn == -1}"><span class="page-ellipsis">&#8230;</span></c:when>
                            <c:when test="${pn == currentPage}"><span class="page-btn active">${pn}</span></c:when>
                            <c:otherwise><a class="page-btn" href="?page=${pn}&keyword=${fn:escapeXml(keyword)}&status=${fn:escapeXml(statusFilter)}&company=${fn:escapeXml(companyFilter)}">${pn}</a></c:otherwise>
                        </c:choose>
                    </c:forEach>
                    <c:choose>
                        <c:when test="${currentPage == totalPages}"><span class="page-btn disabled">&#8594;</span></c:when>
                        <c:otherwise><a class="page-btn" href="?page=${currentPage+1}&keyword=${fn:escapeXml(keyword)}&status=${fn:escapeXml(statusFilter)}&company=${fn:escapeXml(companyFilter)}">&#8594;</a></c:otherwise>
                    </c:choose>
                </div>
            </div>
            </c:if>

        </div>
    </main>

    <style>
        .pagination-wrap { display:flex; align-items:center; justify-content:space-between; padding:var(--space-lg) 0; flex-wrap:wrap; gap:12px; }
        .pagination-info { font-size:0.85rem; color:var(--text-muted); }
        .pagination-info strong { color:var(--text-primary); }
        .pagination-controls { display:flex; align-items:center; gap:6px; }
        .page-btn { display:inline-flex; align-items:center; justify-content:center; min-width:36px; height:36px; padding:0 10px; border-radius:var(--radius-md); font-size:0.85rem; font-weight:600; text-decoration:none; background:var(--glass-bg); border:1px solid var(--glass-border); color:var(--text-secondary); transition:all 0.15s; cursor:pointer; }
        .page-btn:hover:not(.disabled):not(.active) { background:rgba(99,102,241,0.1); border-color:var(--primary); color:var(--primary-light); }
        .page-btn.active { background:linear-gradient(135deg,var(--primary),var(--accent)); border-color:transparent; color:white; box-shadow:0 4px 12px rgba(99,102,241,0.4); }
        .page-btn.disabled { opacity:0.35; cursor:not-allowed; pointer-events:none; }
        .page-ellipsis { display:inline-flex; align-items:center; justify-content:center; min-width:36px; height:36px; color:var(--text-muted); font-size:0.85rem; }
    </style>
    <script>
        (function(){
            var si = document.getElementById('searchInput');
            if (si) si.addEventListener('keydown', function(e){
                if (e.key === 'Enter') { e.preventDefault(); document.getElementById('filterForm').submit(); }
            });
        })();
    </script>
</body>
</html>

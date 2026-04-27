<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý nhà tuyển dụng | HireHub Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* ── Page layout ── */
        .rl-container {
            max-width: 1400px; margin: 0 auto;
            padding: var(--space-xl) var(--space-lg) var(--space-3xl);
        }

        /* ── Page header ── */
        .rl-header {
            display: flex; align-items: center; justify-content: space-between;
            margin-bottom: var(--space-xl); flex-wrap: wrap; gap: 12px;
        }
        .rl-title {
            font-size: 1.6rem; font-weight: 800; color: var(--text-primary);
            display: flex; align-items: center; gap: 12px;
        }
        .rl-title-icon {
            width: 42px; height: 42px; border-radius: 12px;
            background: linear-gradient(135deg, var(--primary), var(--accent));
            display: flex; align-items: center; justify-content: center;
            box-shadow: 0 4px 12px rgba(99,102,241,0.4);
        }

        /* ── Toolbar ── */
        .rl-toolbar {
            display: flex; gap: 12px; margin-bottom: var(--space-xl); flex-wrap: wrap;
        }
        .rl-search {
            flex: 1; min-width: 240px;
            padding: 11px 16px 11px 40px;
            background: var(--glass-bg); backdrop-filter: var(--glass-blur);
            border: 1px solid var(--glass-border); border-radius: var(--radius-md);
            color: var(--text-primary); font-size: 0.9rem; outline: none;
            transition: border-color 0.2s;
            position: relative;
        }
        .rl-search:focus { border-color: var(--primary); }
        .rl-search::placeholder { color: var(--text-muted); }
        .search-wrap { position: relative; flex: 1; min-width: 240px; }
        .search-icon {
            position: absolute; left: 12px; top: 50%; transform: translateY(-50%);
            color: var(--text-muted); pointer-events: none;
        }
        .rl-filter {
            padding: 11px 16px; min-width: 160px;
            background: var(--glass-bg); backdrop-filter: var(--glass-blur);
            border: 1px solid var(--glass-border); border-radius: var(--radius-md);
            color: var(--text-primary); font-size: 0.9rem; outline: none;
            cursor: pointer; transition: border-color 0.2s;
        }
        .rl-filter:focus { border-color: var(--primary); }
        .rl-filter option { background: var(--bg-secondary); }

        /* ── Stats strip ── */
        .rl-stats {
            display: flex; gap: var(--space-md); margin-bottom: var(--space-xl); flex-wrap: wrap;
        }
        .rl-stat {
            background: var(--glass-bg); backdrop-filter: var(--glass-blur);
            border: 1px solid var(--glass-border); border-radius: var(--radius-lg);
            padding: 14px 20px; display: flex; align-items: center; gap: 12px;
            box-shadow: var(--glass-shadow); flex: 1; min-width: 160px;
        }
        .rl-stat-icon {
            width: 38px; height: 38px; border-radius: 10px;
            display: flex; align-items: center; justify-content: center; flex-shrink: 0;
        }
        .rl-stat-icon.primary { background: var(--primary-100); color: var(--primary-light); }
        .rl-stat-icon.success { background: var(--success-light); color: var(--success); }
        .rl-stat-icon.error   { background: var(--error-light);   color: var(--error);   }
        .rl-stat-num { font-size: 1.4rem; font-weight: 800; color: var(--text-primary); display: block; }
        .rl-stat-lbl { font-size: 0.75rem; color: var(--text-muted); margin-top: 2px; display: block; }

        /* ── Table card ── */
        .rl-card {
            background: var(--glass-bg); backdrop-filter: var(--glass-blur);
            -webkit-backdrop-filter: var(--glass-blur);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-xl); box-shadow: var(--glass-shadow);
            overflow: hidden;
        }
        .rl-table-wrap { overflow-x: auto; }
        .rl-table { width: 100%; border-collapse: collapse; }
        .rl-table thead tr {
            background: linear-gradient(135deg, var(--primary), var(--accent));
        }
        .rl-table th {
            padding: 14px 16px; text-align: left;
            font-size: 0.75rem; font-weight: 700;
            text-transform: uppercase; letter-spacing: 0.5px;
            color: rgba(255,255,255,0.9); white-space: nowrap;
        }
        .rl-table td {
            padding: 14px 16px; font-size: 0.875rem;
            border-bottom: 1px solid rgba(255,255,255,0.04);
            color: var(--text-primary); vertical-align: middle;
        }
        .rl-table tbody tr { transition: background 0.15s; }
        .rl-table tbody tr:hover { background: var(--primary-50); }
        .rl-table tbody tr:last-child td { border-bottom: none; }

        /* ── Avatar ── */
        .rec-avatar {
            width: 36px; height: 36px; border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), var(--accent));
            display: inline-flex; align-items: center; justify-content: center;
            font-weight: 700; font-size: 0.8rem; color: white;
            flex-shrink: 0; margin-right: 10px;
        }
        .name-cell { display: flex; align-items: center; }
        .name-main { font-weight: 600; color: var(--text-primary); }
        .name-email { font-size: 0.75rem; color: var(--text-muted); margin-top: 2px; }

        /* ── Job title badge ── */
        .job-title-badge {
            display: inline-flex; align-items: center; gap: 5px;
            padding: 4px 10px; border-radius: 6px;
            font-size: 0.78rem; font-weight: 600;
            background: rgba(99,102,241,0.1); color: var(--primary-light);
            border: 1px solid rgba(99,102,241,0.15);
        }

        /* ── Company badge ── */
        .company-badge {
            font-size: 0.85rem; font-weight: 500; color: var(--text-secondary);
        }

        /* ── Dept badge ── */
        .dept-badge {
            display: inline-flex; padding: 4px 10px;
            border-radius: 6px; font-size: 0.75rem; font-weight: 600;
            background: rgba(59,130,246,0.1); color: #60A5FA;
            border: 1px solid rgba(59,130,246,0.15);
        }

        /* ── Status ── */
        .status-pill {
            display: inline-flex; align-items: center; gap: 5px;
            padding: 4px 12px; border-radius: var(--radius-full);
            font-size: 0.72rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px;
        }
        .status-pill.active { background: var(--success-light); color: var(--success); }
        .status-pill.inactive { background: var(--error-light); color: var(--error); }
        .status-dot { width: 6px; height: 6px; border-radius: 50%; background: currentColor; }

        /* ── Bio truncate ── */
        .bio-cell {
            max-width: 220px; white-space: nowrap;
            overflow: hidden; text-overflow: ellipsis;
            color: var(--text-secondary); font-size: 0.85rem;
        }

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
        .btn-icon.edit:hover { background: rgba(99,102,241,0.2); color: var(--primary-light); }
        .btn-icon.del {
            background: var(--error-light); color: var(--error);
            border: 1px solid rgba(239,68,68,0.2);
        }
        .btn-icon.del:hover { background: rgba(239,68,68,0.2); }

        /* ── Empty state ── */
        .rl-empty {
            text-align: center; padding: var(--space-3xl);
            color: var(--text-muted);
        }
        .rl-empty svg { opacity: 0.3; margin-bottom: 16px; }
        .rl-empty p { font-size: 0.95rem; }

        /* ── Row hidden by filter ── */
        tr.hidden-row { display: none; }
        /* ── Toast notification ── */
        .toast-container {
            position: fixed; top: 24px; right: 24px; z-index: 9999;
            display: flex; flex-direction: column; gap: 10px;
        }
        .toast {
            display: flex; align-items: center; gap: 12px;
            padding: 14px 20px; border-radius: 12px;
            font-size: 0.88rem; font-weight: 600;
            min-width: 280px; max-width: 420px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.35);
            animation: toastIn 0.3s ease;
            backdrop-filter: blur(10px);
        }
        .toast.success {
            background: rgba(16,185,129,0.18); color: #34d399;
            border: 1px solid rgba(16,185,129,0.3);
        }
        .toast.error {
            background: rgba(239,68,68,0.18); color: #f87171;
            border: 1px solid rgba(239,68,68,0.3);
        }
        .toast-close {
            margin-left: auto; cursor: pointer; opacity: 0.7;
            background: none; border: none; color: inherit;
            font-size: 1rem; line-height: 1; padding: 0;
        }
        .toast-close:hover { opacity: 1; }
        @keyframes toastIn {
            from { opacity: 0; transform: translateX(30px); }
            to   { opacity: 1; transform: translateX(0); }
        }
        @keyframes toastOut {
            from { opacity: 1; transform: translateX(0); }
            to   { opacity: 0; transform: translateX(30px); }
        }
    </style>
</head>
<body class="app-page">
    <jsp:include page="/WEB-INF/views/header.jsp" />

    <main class="main-content">
        <div class="rl-container">

            <%-- Toast notification (flash from session) --%>
            <c:if test="${not empty toastType}">
                <div class="toast-container" id="toastContainer">
                    <div class="toast ${toastType}" id="mainToast">
                        <c:choose>
                            <c:when test="${toastType == 'success'}">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" style="flex-shrink:0"><polyline points="20 6 9 17 4 12"/></svg>
                            </c:when>
                            <c:otherwise>
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="flex-shrink:0"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                            </c:otherwise>
                        </c:choose>
                        <span><c:out value="${toastMsg}"/></span>
                        <button class="toast-close" onclick="this.closest('.toast').remove()">&times;</button>
                    </div>
                </div>
                <script>
                    (function(){
                        var t = document.getElementById('mainToast');
                        if (!t) return;
                        setTimeout(function(){
                            t.style.animation = 'toastOut 0.3s ease forwards';
                            setTimeout(function(){ t.remove(); }, 320);
                        }, 4000);
                    })();
                </script>
            </c:if>

            <!-- Header -->
            <div class="rl-header">
                <div class="rl-title">
                    <div class="rl-title-icon">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5">
                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                            <circle cx="9" cy="7" r="4"/>
                            <path d="M23 21v-2a4 4 0 0 0-3-3.87"/>
                            <path d="M16 3.13a4 4 0 0 1 0 7.75"/>
                        </svg>
                    </div>
                    Quản lý nhà tuyển dụng
                </div>
                <a href="${pageContext.request.contextPath}/admin/recruiters?action=create" class="btn btn-primary" style="padding:10px 20px;">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" style="margin-right:6px;">
                        <line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>
                    </svg>
                    Thêm nhà tuyển dụng
                </a>
            </div>

            <!-- Stats -->
            <div class="rl-stats animate-fadeInUp">
                <div class="rl-stat">
                    <div class="rl-stat-icon primary">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                    </div>
                    <div>
                        <span class="rl-stat-num">${totalCount}</span>
                        <span class="rl-stat-lbl">Tổng nhà tuyển dụng</span>
                    </div>
                </div>
                <div class="rl-stat">
                    <div class="rl-stat-icon success">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"/></svg>
                    </div>
                    <div>
                        <span class="rl-stat-num">${activeCount}</span>
                        <span class="rl-stat-lbl">Đang hoạt động</span>
                    </div>
                </div>
                <div class="rl-stat">
                    <div class="rl-stat-icon error">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>
                    </div>
                    <div>
                        <span class="rl-stat-num">${totalCount - activeCount}</span>
                        <span class="rl-stat-lbl">Không hoạt động</span>
                    </div>
                </div>
            </div>

            <!-- Toolbar – server-side filter form -->
            <form method="get" action="" id="filterForm" class="rl-toolbar animate-fadeInUp" style="animation-delay:0.05s;">
                <div class="search-wrap">
                    <svg class="search-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
                    </svg>
                    <input type="text" name="keyword" class="rl-search" id="searchInput"
                           value="<c:out value='${keyword}'/>"
                           placeholder="Tìm theo tên, email, công ty...">
                </div>
                <select name="status" class="rl-filter" id="statusFilter" onchange="this.form.submit()">
                    <option value="All" ${statusFilter == 'All' ? 'selected' : ''}>Tất cả trạng thái</option>
                    <option value="ACTIVE"   ${statusFilter == 'ACTIVE'   ? 'selected' : ''}>Đang hoạt động</option>
                    <option value="INACTIVE" ${statusFilter == 'INACTIVE' ? 'selected' : ''}>Không hoạt động</option>
                </select>
                <select name="company" class="rl-filter" id="companyFilter" onchange="this.form.submit()">
                    <option value="All" ${companyFilter == 'All' ? 'selected' : ''}>Tất cả công ty</option>
                    <c:forEach var="c" items="${allCompanies}">
                        <option value="${fn:escapeXml(c.companyName)}" ${companyFilter == c.companyName ? 'selected' : ''}>
                            <c:out value="${c.companyName}"/>
                        </option>
                    </c:forEach>
                </select>
                <button type="submit" class="btn btn-primary" style="padding:10px 18px;white-space:nowrap;">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" style="margin-right:5px;"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>Tìm kiếm
                </button>
            </form>


            <!-- Table -->
            <div class="rl-card animate-fadeInUp" style="animation-delay:0.1s;">
                <div class="rl-table-wrap">
                    <table class="rl-table" id="recruiterTable">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Nhà tuyển dụng</th>
                                <th>Chức danh</th>
                                <th>Công ty</th>
                                <th>Phòng ban</th>
                                <th>Bio</th>
                                <th>Trạng thái</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <tbody id="recruiterBody">
                            <c:choose>
                                <c:when test="${not empty list}">
                                    <c:forEach var="r" items="${list}" varStatus="loop">
                                        <c:set var="initial" value="${not empty r.fullName ? fn:toUpperCase(fn:substring(r.fullName, 0, 1)) : '?'}"/>
                                        <tr data-name="${fn:escapeXml(fn:toLowerCase(r.fullName))} ${fn:escapeXml(fn:toLowerCase(r.email))}"
                                            data-company="${fn:escapeXml(r.companyName)}"
                                            data-jobtitle="${fn:escapeXml(fn:toLowerCase(r.jobTitle))}"
                                            data-status="${r.status}">
                                            <td style="color:var(--text-muted); font-size:0.8rem;">${(currentPage - 1) * 10 + loop.index + 1}</td>
                                            <td>
                                                <div class="name-cell">
                                                    <div class="rec-avatar">${initial}</div>
                                                    <div>
                                                        <div class="name-main">
                                                            <c:out value="${not empty r.fullName ? r.fullName : '(Chưa cập nhật)'}"/>
                                                        </div>
                                                        <div class="name-email"><c:out value="${r.email}"/></div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="job-title-badge">
                                                    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="7" width="20" height="14" rx="2"/><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/></svg>
                                                    <c:out value="${r.jobTitle}"/>
                                                </span>
                                            </td>
                                            <td><span class="company-badge"><c:out value="${r.companyName}"/></span></td>
                                            <td>
                                                <c:if test="${not empty r.departmentName}">
                                                    <span class="dept-badge"><c:out value="${r.departmentName}"/></span>
                                                </c:if>
                                                <c:if test="${empty r.departmentName}">
                                                    <span style="color:var(--text-muted); font-size:0.8rem;">—</span>
                                                </c:if>
                                            </td>
                                            <td><div class="bio-cell"><c:out value="${r.bio}"/></div></td>
                                            <td>
                                                <span class="status-pill ${r.status == 'ACTIVE' ? 'active' : 'inactive'}">
                                                    <span class="status-dot"></span>
                                                    ${r.status}
                                                </span>
                                            </td>
                                            <td>
                                                <div class="action-btns">
                                                    <c:if test="${r.status == 'ACTIVE'}">
                                                        <a class="btn-icon edit" href="${pageContext.request.contextPath}/admin/recruiters?action=edit&id=${r.recruiterId}">
                                                            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                                                            Sửa
                                                        </a>
                                                        <a class="btn-icon del" href="${pageContext.request.contextPath}/admin/recruiters?action=delete&id=${r.recruiterId}"
                                                           onclick="return confirm('Xác nhận khóa nhà tuyển dụng này?')">
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
                                    <tr id="emptyServerRow">
                                        <td colspan="8">
                                            <div class="rl-empty">
                                                <svg width="52" height="52" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" style="display:block; margin:0 auto 12px;">
                                                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/>
                                                    <path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/>
                                                </svg>
                                                <p>Chưa có nhà tuyển dụng nào.</p>
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
                    <%-- Prev --%>
                    <c:choose>
                        <c:when test="${currentPage == 1}">
                            <span class="page-btn disabled">&#8592;</span>
                        </c:when>
                        <c:otherwise>
                            <a class="page-btn" href="?page=${currentPage-1}&keyword=${fn:escapeXml(keyword)}&status=${fn:escapeXml(statusFilter)}&company=${fn:escapeXml(companyFilter)}">&#8592;</a>
                        </c:otherwise>
                    </c:choose>
                    <%-- Page numbers --%>
                    <c:forEach var="pn" items="${pageNums}">
                        <c:choose>
                            <c:when test="${pn == -1}"><span class="page-ellipsis">&#8230;</span></c:when>
                            <c:when test="${pn == currentPage}"><span class="page-btn active">${pn}</span></c:when>
                            <c:otherwise><a class="page-btn" href="?page=${pn}&keyword=${fn:escapeXml(keyword)}&status=${fn:escapeXml(statusFilter)}&company=${fn:escapeXml(companyFilter)}">${pn}</a></c:otherwise>
                        </c:choose>
                    </c:forEach>
                    <%-- Next --%>
                    <c:choose>
                        <c:when test="${currentPage == totalPages}">
                            <span class="page-btn disabled">&#8594;</span>
                        </c:when>
                        <c:otherwise>
                            <a class="page-btn" href="?page=${currentPage+1}&keyword=${fn:escapeXml(keyword)}&status=${fn:escapeXml(statusFilter)}&company=${fn:escapeXml(companyFilter)}">&#8594;</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            </c:if>

        </div>
    </main>

    <style>
        /* ── Pagination ── */
        .pagination-wrap {
            display: flex; align-items: center; justify-content: space-between;
            padding: var(--space-lg) 0; flex-wrap: wrap; gap: 12px;
        }
        .pagination-info { font-size: 0.85rem; color: var(--text-muted); }
        .pagination-info strong { color: var(--text-primary); }
        .pagination-controls { display: flex; align-items: center; gap: 6px; }
        .page-btn {
            display: inline-flex; align-items: center; justify-content: center;
            min-width: 36px; height: 36px; padding: 0 10px;
            border-radius: var(--radius-md);
            font-size: 0.85rem; font-weight: 600; text-decoration: none;
            background: var(--glass-bg); border: 1px solid var(--glass-border);
            color: var(--text-secondary); transition: all 0.15s; cursor: pointer;
        }
        .page-btn:hover:not(.disabled):not(.active) {
            background: rgba(99,102,241,0.1); border-color: var(--primary);
            color: var(--primary-light);
        }
        .page-btn.active {
            background: linear-gradient(135deg, var(--primary), var(--accent));
            border-color: transparent; color: white;
            box-shadow: 0 4px 12px rgba(99,102,241,0.4);
        }
        .page-btn.disabled { opacity: 0.35; cursor: not-allowed; pointer-events: none; }
        .page-ellipsis { display: inline-flex; align-items: center; justify-content: center;
            min-width: 36px; height: 36px; color: var(--text-muted); font-size: 0.85rem; }
    </style>
    <script>
        // Auto-submit form on Enter in search box
        (function(){
            var si = document.getElementById('searchInput');
            if (si) si.addEventListener('keydown', function(e){
                if (e.key === 'Enter') { e.preventDefault(); document.getElementById('filterForm').submit(); }
            });
        })();
    </script>
</body>
</html>

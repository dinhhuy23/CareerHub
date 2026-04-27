<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@page import="java.util.List" %>
        <%@page import="model.Company" %>
            <%@page import="model.Recruiter" %>

                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Chi tiết công ty | HireHub Admin</title>
                    <link
                        href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
                        rel="stylesheet">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/company.css">
                    <style>
                        /* ── Cover ── */
                        .admin-cover {
                            width: 100%;
                            height: 180px;
                            background: linear-gradient(135deg, #0f172a 0%, #1e1b4b 50%, #312e81 100%);
                            position: relative;
                            overflow: hidden;
                        }

                        .admin-cover::after {
                            content: '';
                            position: absolute;
                            inset: 0;
                            background: repeating-linear-gradient(45deg, transparent, transparent 20px,
                                    rgba(255, 255, 255, 0.015) 20px, rgba(255, 255, 255, 0.015) 40px);
                        }

                        .cover-glow {
                            position: absolute;
                            width: 320px;
                            height: 320px;
                            background: var(--primary);
                            filter: blur(90px);
                            opacity: 0.2;
                            top: -100px;
                            right: 5%;
                            border-radius: 50%;
                        }

                        /* ── Hero strip ── */
                        .admin-hero {
                            background: var(--glass-bg);
                            backdrop-filter: var(--glass-blur);
                            border-bottom: 1px solid var(--glass-border);
                            box-shadow: var(--glass-shadow);
                        }

                        .admin-hero-inner {
                            max-width: 1100px;
                            margin: 0 auto;
                            padding: 0 var(--space-lg);
                            display: flex;
                            align-items: flex-end;
                            gap: var(--space-xl);
                            margin-top: -56px;
                            padding-bottom: var(--space-xl);
                            flex-wrap: wrap;
                        }

                        .admin-logo-wrap {
                            width: 110px;
                            height: 110px;
                            flex-shrink: 0;
                            background: var(--bg-secondary);
                            border: 3px solid var(--glass-border);
                            border-radius: 18px;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            overflow: hidden;
                            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.5);
                            position: relative;
                            z-index: 2;
                        }

                        .admin-logo-wrap img {
                            width: 100%;
                            height: 100%;
                            object-fit: contain;
                        }

                        .logo-placeholder-big {
                            font-size: 2.8rem;
                            font-weight: 800;
                            background: linear-gradient(135deg, var(--primary-light), var(--accent-light));
                            -webkit-background-clip: text;
                            -webkit-text-fill-color: transparent;
                            background-clip: text;
                        }

                        .admin-hero-text {
                            flex: 1;
                            min-width: 240px;
                            padding-bottom: 4px;
                        }

                        .admin-hero-text h1 {
                            font-size: 1.8rem;
                            font-weight: 800;
                            color: var(--text-primary);
                            margin-bottom: 10px;
                            line-height: 1.2;
                        }

                        .admin-meta-tags {
                            display: flex;
                            flex-wrap: wrap;
                            gap: 8px;
                        }

                        .admin-tag {
                            display: inline-flex;
                            align-items: center;
                            gap: 5px;
                            padding: 4px 12px;
                            border-radius: var(--radius-full);
                            font-size: 0.78rem;
                            font-weight: 500;
                            background: rgba(255, 255, 255, 0.06);
                            border: 1px solid var(--glass-border);
                            color: var(--text-secondary);
                        }

                        .admin-hero-actions {
                            display: flex;
                            gap: 10px;
                            align-items: center;
                            padding-bottom: var(--space-md);
                        }

                        .status-pill {
                            display: inline-flex;
                            align-items: center;
                            gap: 6px;
                            padding: 5px 14px;
                            border-radius: var(--radius-full);
                            font-size: 0.78rem;
                            font-weight: 700;
                            text-transform: uppercase;
                            letter-spacing: 0.5px;
                        }

                        .status-pill.active {
                            background: var(--success-light);
                            color: var(--success);
                        }

                        .status-pill.inactive {
                            background: var(--error-light);
                            color: var(--error);
                        }

                        .status-dot {
                            width: 7px;
                            height: 7px;
                            border-radius: 50%;
                            background: currentColor;
                        }

                        /* ── Main layout ── */
                        .admin-detail-wrap {
                            max-width: 1100px;
                            margin: 0 auto;
                            padding: var(--space-xl) var(--space-lg) var(--space-3xl);
                            display: grid;
                            grid-template-columns: minmax(0, 1.5fr) 320px;
                            gap: var(--space-xl);
                            align-items: start;
                        }

                        @media (max-width: 900px) {
                            .admin-detail-wrap {
                                grid-template-columns: 1fr;
                            }
                        }

                        /* ── Cards ── */
                        .d-card {
                            background: var(--glass-bg);
                            backdrop-filter: var(--glass-blur);
                            -webkit-backdrop-filter: var(--glass-blur);
                            border: 1px solid var(--glass-border);
                            border-radius: var(--radius-xl);
                            padding: var(--space-xl);
                            box-shadow: var(--glass-shadow);
                            margin-bottom: var(--space-lg);
                            transition: border-color 0.2s;
                        }

                        .d-card:hover {
                            border-color: rgba(99, 102, 241, 0.2);
                        }

                        .d-heading {
                            font-size: 1rem;
                            font-weight: 700;
                            color: var(--text-primary);
                            margin-bottom: var(--space-lg);
                            padding-bottom: 12px;
                            border-bottom: 1px solid var(--glass-border);
                            display: flex;
                            align-items: center;
                            gap: 10px;
                        }

                        .d-heading-icon {
                            width: 30px;
                            height: 30px;
                            border-radius: 8px;
                            background: var(--primary-100);
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            color: var(--primary-light);
                        }

                        /* ── Info rows ── */
                        .d-info-list {
                            display: flex;
                            flex-direction: column;
                        }

                        .d-info-row {
                            display: flex;
                            align-items: flex-start;
                            gap: 14px;
                            padding: 13px 0;
                            border-bottom: 1px solid rgba(255, 255, 255, 0.04);
                        }

                        .d-info-row:last-child {
                            border-bottom: none;
                            padding-bottom: 0;
                        }

                        .d-info-row:first-child {
                            padding-top: 0;
                        }

                        .d-icon {
                            width: 36px;
                            height: 36px;
                            flex-shrink: 0;
                            border-radius: 9px;
                            background: var(--primary-100);
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            color: var(--primary-light);
                        }

                        .d-label {
                            font-size: 0.72rem;
                            font-weight: 600;
                            text-transform: uppercase;
                            letter-spacing: 0.5px;
                            color: var(--text-muted);
                            margin-bottom: 2px;
                        }

                        .d-value {
                            font-size: 0.9375rem;
                            color: var(--text-primary);
                            font-weight: 500;
                        }

                        .d-value a {
                            color: var(--primary-light);
                        }

                        .d-value a:hover {
                            text-decoration: underline;
                            color: var(--accent-light);
                        }

                        /* ── About ── */
                        .about-body {
                            color: var(--text-secondary);
                            line-height: 1.9;
                            font-size: 0.95rem;
                            white-space: pre-wrap;
                        }

                        /* ── Recruiter table ── */
                        .rec-table {
                            width: 100%;
                            border-collapse: collapse;
                        }

                        .rec-table thead tr {
                            background: linear-gradient(135deg, var(--primary), var(--accent));
                        }

                        .rec-table th {
                            padding: 12px 14px;
                            text-align: left;
                            font-size: 0.78rem;
                            font-weight: 700;
                            text-transform: uppercase;
                            letter-spacing: 0.5px;
                            color: white;
                            white-space: nowrap;
                        }

                        .rec-table th:first-child {
                            border-radius: 10px 0 0 0;
                        }

                        .rec-table th:last-child {
                            border-radius: 0 10px 0 0;
                        }

                        .rec-table td {
                            padding: 12px 14px;
                            font-size: 0.875rem;
                            border-bottom: 1px solid rgba(255, 255, 255, 0.04);
                            color: var(--text-primary);
                            vertical-align: middle;
                        }

                        .rec-table tbody tr {
                            transition: background 0.15s;
                        }

                        .rec-table tbody tr:hover {
                            background: var(--primary-50);
                        }

                        .rec-table tbody tr:last-child td {
                            border-bottom: none;
                        }

                        .rec-name {
                            font-weight: 600;
                        }

                        .rec-avatar {
                            width: 36px;
                            height: 36px;
                            border-radius: 50%;
                            background: linear-gradient(135deg, var(--primary), var(--accent));
                            display: inline-flex;
                            align-items: center;
                            justify-content: center;
                            font-weight: 700;
                            font-size: 0.8rem;
                            color: white;
                            flex-shrink: 0;
                            margin-right: 10px;
                        }

                        .name-cell {
                            display: flex;
                            align-items: center;
                        }

                        .rec-status {
                            display: inline-flex;
                            align-items: center;
                            gap: 5px;
                            padding: 3px 10px;
                            border-radius: var(--radius-full);
                            font-size: 0.72rem;
                            font-weight: 700;
                        }

                        .rec-status.active {
                            background: var(--success-light);
                            color: var(--success);
                        }

                        .rec-status.inactive {
                            background: var(--error-light);
                            color: var(--error);
                        }

                        .table-wrap {
                            overflow-x: auto;
                            border-radius: 12px;
                        }

                        .empty-rec {
                            text-align: center;
                            padding: var(--space-xl);
                            color: var(--text-muted);
                            font-size: 0.9rem;
                        }

                        /* ── Action buttons ── */
                        .action-bar {
                            max-width: 1100px;
                            margin: 0 auto;
                            padding: 0 var(--space-lg) var(--space-xl);
                            display: flex;
                            gap: 10px;
                        }
                    </style>
                </head>

                <body class="app-page">
                    <jsp:include page="/WEB-INF/views/header.jsp" />

                    <% Company company=(Company) request.getAttribute("company"); List<Recruiter> recruiters = (List
                        <Recruiter>) request.getAttribute("recruiters");
                            String locationName = (String) request.getAttribute("locationName");
                            boolean isActive = company != null && "ACTIVE".equalsIgnoreCase(company.getStatus());
                            %>

                            <!-- Cover -->
                            <div class="admin-cover">
                                <div class="cover-glow"></div>
                            </div>

                            <!-- Hero -->
                            <div class="admin-hero">
                                <div class="admin-hero-inner animate-fadeInUp">
                                    <div class="admin-logo-wrap">
                                        <% if (company !=null && company.getLogoUrl() !=null &&
                                            !company.getLogoUrl().trim().isEmpty()) { %>
                                            <img src="<%= company.getLogoUrl() %>" alt="Logo">
                                            <% } else { %>
                                                <span class="logo-placeholder-big">
                                                    <%= company !=null ?
                                                        company.getCompanyName().substring(0,1).toUpperCase() : "?" %>
                                                </span>
                                                <% } %>
                                    </div>

                                    <div class="admin-hero-text">
                                        <h1>
                                            <%= company !=null ? company.getCompanyName() : "Chi tiết công ty" %>
                                        </h1>
                                        <div class="admin-meta-tags">
                                            <% if (company !=null && company.getIndustry() !=null) { %>
                                                <span class="admin-tag">
                                                    <svg width="12" height="12" viewBox="0 0 24 24" fill="none"
                                                        stroke="currentColor" stroke-width="2">
                                                        <rect x="2" y="7" width="20" height="14" rx="2" />
                                                        <path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16" />
                                                    </svg>
                                                    <%= company.getIndustry() %>
                                                </span>
                                                <% } %>
                                                    <% if (company !=null && company.getCompanySize() !=null) { %>
                                                        <span class="admin-tag">
                                                            <svg width="12" height="12" viewBox="0 0 24 24" fill="none"
                                                                stroke="currentColor" stroke-width="2">
                                                                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
                                                                <circle cx="9" cy="7" r="4" />
                                                                <path d="M23 21v-2a4 4 0 0 0-3-3.87" />
                                                                <path d="M16 3.13a4 4 0 0 1 0 7.75" />
                                                            </svg>
                                                            <%= company.getCompanySize() %>
                                                        </span>
                                                        <% } %>
                                                            <% if (company !=null && company.getFoundedYear() !=null) {
                                                                %>
                                                                <span class="admin-tag">
                                                                    <svg width="12" height="12" viewBox="0 0 24 24"
                                                                        fill="none" stroke="currentColor"
                                                                        stroke-width="2">
                                                                        <rect x="3" y="4" width="18" height="18"
                                                                            rx="2" />
                                                                        <line x1="16" y1="2" x2="16" y2="6" />
                                                                        <line x1="8" y1="2" x2="8" y2="6" />
                                                                        <line x1="3" y1="10" x2="21" y2="10" />
                                                                    </svg>
                                                                    Thành lập <%= company.getFoundedYear() %>
                                                                </span>
                                                                <% } %>
                                                                    <span class="status-pill <%= isActive ? " active"
                                                                        : "inactive" %>">
                                                                        <span class="status-dot"></span>
                                                                        <%= company !=null && company.getStatus() !=null
                                                                            ? company.getStatus() : "N/A" %>
                                                                    </span>
                                        </div>
                                    </div>

                                    <div class="admin-hero-actions">
                                        <a href="${pageContext.request.contextPath}/admin/company"
                                            class="btn btn-outline"
                                            style="padding:8px 18px; border-radius:var(--radius-full);">
                                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2" style="margin-right:5px;">
                                                <line x1="19" y1="12" x2="5" y2="12" />
                                                <polyline points="12 19 5 12 12 5" />
                                            </svg>
                                            Danh sách
                                        </a>
                                        <% if (company !=null) { %>
                                            <a href="${pageContext.request.contextPath}/company/edit?id=<%= company.getCompanyId() %>"
                                                class="btn btn-primary" style="padding:8px 18px;">
                                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2" style="margin-right:5px;">
                                                    <path
                                                        d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
                                                    <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
                                                </svg>
                                                Chỉnh sửa
                                            </a>
                                            <% } %>
                                    </div>
                                </div>
                            </div>

                            <!-- Main content -->
                            <div class="admin-detail-wrap">

                                <!-- LEFT -->
                                <div>
                                    <!-- About -->
                                    <div class="d-card animate-fadeInUp" style="animation-delay:0.1s;">
                                        <div class="d-heading">
                                            <div class="d-heading-icon">
                                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <circle cx="12" cy="12" r="10" />
                                                    <line x1="12" y1="8" x2="12" y2="12" />
                                                    <line x1="12" y1="16" x2="12.01" y2="16" />
                                                </svg>
                                            </div>
                                            Giới thiệu công ty
                                        </div>
                                        <div class="about-body">
                                            <%= (company !=null && company.getDescription() !=null &&
                                                !company.getDescription().trim().isEmpty()) ? company.getDescription()
                                                : "Chưa có thông tin giới thiệu." %>
                                        </div>
                                    </div>

                                    <!-- Recruiters -->
                                    <div class="d-card animate-fadeInUp" style="animation-delay:0.2s;">
                                        <div class="d-heading">
                                            <div class="d-heading-icon">
                                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
                                                    <circle cx="9" cy="7" r="4" />
                                                    <path d="M23 21v-2a4 4 0 0 0-3-3.87" />
                                                    <path d="M16 3.13a4 4 0 0 1 0 7.75" />
                                                </svg>
                                            </div>
                                            Đội ngũ tuyển dụng
                                            <span
                                                style="margin-left:auto; background:var(--primary-100); color:var(--primary-light); font-size:0.75rem; font-weight:700; padding:2px 10px; border-radius:var(--radius-full);">
                                                <%= recruiters !=null ? recruiters.size() : 0 %> người
                                            </span>
                                        </div>
                                        <div class="table-wrap">
                                            <% if (recruiters !=null && !recruiters.isEmpty()) { %>
                                                <table class="rec-table">
                                                    <thead>
                                                        <tr>
                                                            <th>Họ và tên</th>
                                                            <th>Chức danh</th>
                                                            <th>Email</th>
                                                            <th>Điện thoại</th>
                                                            <th>Trạng thái</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <% for (Recruiter r : recruiters) { boolean rActive="ACTIVE"
                                                            .equalsIgnoreCase(r.getStatus()); String
                                                            initial=r.getFullName() !=null && !r.getFullName().isEmpty()
                                                            ? r.getFullName().substring(0,1).toUpperCase() : "?" ; %>
                                                            <tr>
                                                                <td>
                                                                    <div class="name-cell">
                                                                        <span class="rec-avatar">
                                                                            <%= initial %>
                                                                        </span>
                                                                        <span class="rec-name">
                                                                            <%= r.getFullName() %>
                                                                        </span>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <%= r.getJobTitle() !=null ? r.getJobTitle() : "—"
                                                                        %>
                                                                </td>
                                                                <td>
                                                                    <%= r.getEmail() !=null ? r.getEmail() : "—" %>
                                                                </td>
                                                                <td>
                                                                    <%= r.getPhoneNumber() !=null ? r.getPhoneNumber()
                                                                        : "—" %>
                                                                </td>
                                                                <td>
                                                                    <span class="rec-status <%= rActive ? " active"
                                                                        : "inactive" %>">
                                                                        <span class="status-dot"></span>
                                                                        <%= r.getStatus() %>
                                                                    </span>
                                                                </td>
                                                            </tr>
                                                            <% } %>
                                                    </tbody>
                                                </table>
                                                <% } else { %>
                                                    <div class="empty-rec">
                                                        <svg width="40" height="40" viewBox="0 0 24 24" fill="none"
                                                            stroke="currentColor" stroke-width="1.5"
                                                            style="opacity:0.3; margin-bottom:8px; display:block; margin-inline:auto;">
                                                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
                                                            <circle cx="9" cy="7" r="4" />
                                                            <path d="M23 21v-2a4 4 0 0 0-3-3.87" />
                                                            <path d="M16 3.13a4 4 0 0 1 0 7.75" />
                                                        </svg>
                                                        Chưa có nhà tuyển dụng nào.
                                                    </div>
                                                    <% } %>
                                        </div>
                                    </div>
                                </div>

                                <!-- RIGHT: Contact info -->
                                <div>
                                    <div class="d-card animate-fadeInUp"
                                        style="animation-delay:0.15s; position:sticky; top:80px;">
                                        <div class="d-heading">
                                            <div class="d-heading-icon">
                                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none"
                                                    stroke="currentColor" stroke-width="2">
                                                    <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z" />
                                                    <circle cx="12" cy="10" r="3" />
                                                </svg>
                                            </div>
                                            Thông tin liên hệ
                                        </div>
                                        <div class="d-info-list">
                                            <% if (company !=null && company.getWebsiteUrl() !=null) { %>
                                                <div class="d-info-row">
                                                    <div class="d-icon"><svg width="14" height="14" viewBox="0 0 24 24"
                                                            fill="none" stroke="currentColor" stroke-width="2">
                                                            <circle cx="12" cy="12" r="10" />
                                                            <line x1="2" y1="12" x2="22" y2="12" />
                                                            <path
                                                                d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z" />
                                                        </svg></div>
                                                    <div>
                                                        <div class="d-label">Website</div>
                                                        <div class="d-value"><a href="<%= company.getWebsiteUrl() %>"
                                                                target="_blank">
                                                                <%= company.getWebsiteUrl() %>
                                                            </a></div>
                                                    </div>
                                                </div>
                                                <% } %>
                                                    <% if (company !=null && company.getEmail() !=null) { %>
                                                        <div class="d-info-row">
                                                            <div class="d-icon"><svg width="14" height="14"
                                                                    viewBox="0 0 24 24" fill="none"
                                                                    stroke="currentColor" stroke-width="2">
                                                                    <path
                                                                        d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z" />
                                                                    <polyline points="22,6 12,13 2,6" />
                                                                </svg></div>
                                                            <div>
                                                                <div class="d-label">Email</div>
                                                                <div class="d-value"><a
                                                                        href="mailto:<%= company.getEmail() %>">
                                                                        <%= company.getEmail() %>
                                                                    </a></div>
                                                            </div>
                                                        </div>
                                                        <% } %>
                                                            <% if (company !=null && company.getPhoneNumber() !=null) {
                                                                %>
                                                                <div class="d-info-row">
                                                                    <div class="d-icon"><svg width="14" height="14"
                                                                            viewBox="0 0 24 24" fill="none"
                                                                            stroke="currentColor" stroke-width="2">
                                                                            <path
                                                                                d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07A19.5 19.5 0 0 1 4.69 12 19.79 19.79 0 0 1 1.6 3.42 2 2 0 0 1 3.58 1.25h3a2 2 0 0 1 2 1.72c.127.96.361 1.903.7 2.81a2 2 0 0 1-.45 2.11L7.91 8.96a16 16 0 0 0 6.09 6.09l1.08-.91a2 2 0 0 1 2.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0 1 22 16.92z" />
                                                                        </svg></div>
                                                                    <div>
                                                                        <div class="d-label">Số điện thoại</div>
                                                                        <div class="d-value">
                                                                            <%= company.getPhoneNumber() %>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <% } %>
                                                                    <% if (locationName !=null &&
                                                                        !locationName.isEmpty()) { %>
                                                                        <div class="d-info-row">
                                                                            <div class="d-icon"><svg width="14"
                                                                                    height="14" viewBox="0 0 24 24"
                                                                                    fill="none" stroke="currentColor"
                                                                                    stroke-width="2">
                                                                                    <path
                                                                                        d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z" />
                                                                                    <circle cx="12" cy="10" r="3" />
                                                                                </svg></div>
                                                                            <div>
                                                                                <div class="d-label">Tỉnh / Thành phố
                                                                                </div>
                                                                                <div class="d-value">
                                                                                    <%= locationName %>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                        <% } %>
                                                                            <% if (company !=null &&
                                                                                company.getAddressLine() !=null) { %>
                                                                                <div class="d-info-row">
                                                                                    <div class="d-icon"><svg width="14"
                                                                                            height="14"
                                                                                            viewBox="0 0 24 24"
                                                                                            fill="none"
                                                                                            stroke="currentColor"
                                                                                            stroke-width="2">
                                                                                            <path
                                                                                                d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z" />
                                                                                            <polyline
                                                                                                points="9 22 9 12 15 12 15 22" />
                                                                                        </svg></div>
                                                                                    <div>
                                                                                        <div class="d-label">Địa chỉ
                                                                                        </div>
                                                                                        <div class="d-value">
                                                                                            <%= company.getAddressLine()
                                                                                                %>
                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                                                                <% } %>
                                        </div>
                                    </div>
                                </div>
                            </div>

                </body>

                </html>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết phòng ban | HireHub Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .dd-container {
            max-width: 800px; margin: 0 auto;
            padding: var(--space-xl) var(--space-lg) var(--space-3xl);
        }

        /* ── Back ── */
        .back-link {
            display: inline-flex; align-items: center; gap: 7px;
            color: var(--text-secondary); font-size: 0.875rem;
            text-decoration: none; margin-bottom: var(--space-xl);
            transition: color 0.2s, transform 0.2s;
        }
        .back-link:hover { color: var(--primary-light); transform: translateX(-3px); }

        /* ── Card ── */
        .dd-card {
            background: var(--glass-bg); backdrop-filter: var(--glass-blur);
            -webkit-backdrop-filter: var(--glass-blur);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-xl); box-shadow: var(--glass-shadow);
            overflow: hidden;
        }

        /* ── Card header ── */
        .dd-card-header {
            padding: var(--space-xl);
            background: linear-gradient(135deg, rgba(99,102,241,0.12), rgba(139,92,246,0.08));
            border-bottom: 1px solid var(--glass-border);
            display: flex; align-items: center; justify-content: space-between; gap: 16px;
        }
        
        .dd-header-left {
            display: flex; align-items: center; gap: 16px;
        }
        
        .dd-header-icon {
            width: 56px; height: 56px; border-radius: 14px; flex-shrink: 0;
            background: linear-gradient(135deg, var(--primary), var(--accent));
            display: flex; align-items: center; justify-content: center;
            box-shadow: 0 4px 12px rgba(99,102,241,0.4);
            font-size: 1.5rem; font-weight: 800; color: white; text-transform: uppercase;
        }
        .dd-card-title { font-size: 1.5rem; font-weight: 800; color: var(--text-primary); }
        .dd-card-subtitle { 
            font-size: 0.95rem; color: var(--primary); margin-top: 5px; font-weight: 600;
            display: inline-flex; align-items: center; gap: 5px;
            padding: 4px 10px; border-radius: 6px;
            background: rgba(99, 102, 241, 0.1); border: 1px solid rgba(99, 102, 241, 0.2);
        }

        /* ── Status ── */
        .status-badge {
            display: inline-flex; align-items: center; gap: 6px;
            padding: 6px 14px; border-radius: var(--radius-full);
            font-size: 0.85rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px;
        }
        .status-badge.active   { background: var(--success-light); color: var(--success); border: 1px solid rgba(16, 185, 129, 0.2); }
        .status-badge.inactive { background: var(--error-light);   color: var(--error); border: 1px solid rgba(239, 68, 68, 0.2); }
        .status-dot { width: 8px; height: 8px; border-radius: 50%; background: currentColor; }

        /* ── Body ── */
        .dd-body { padding: var(--space-2xl) var(--space-xl); display: flex; flex-direction: column; gap: var(--space-xl); }

        /* ── Section title ── */
        .dd-section-title {
            font-size: 0.85rem; font-weight: 700; text-transform: uppercase;
            letter-spacing: 0.8px; color: var(--text-secondary);
            margin-bottom: var(--space-md); display: flex; align-items: center; gap: 10px;
        }
        .dd-section-title::after {
            content: ''; flex: 1; height: 1px;
            background: var(--glass-border);
        }

        /* ── Grid Info ── */
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
        }
        
        .info-item {
            background: var(--bg-secondary);
            padding: 16px 20px;
            border-radius: var(--radius-md);
            border: 1px solid var(--border-color);
        }
        
        .info-label {
            font-size: 0.8rem; font-weight: 600; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.5px;
            margin-bottom: 6px; display: block;
        }
        
        .info-value {
            font-size: 1rem; font-weight: 500; color: var(--text-primary);
            word-break: break-word;
        }
        
        .info-value.empty {
            color: var(--text-muted); font-style: italic; font-size: 0.9rem;
        }
        
        .desc-box {
            background: var(--bg-secondary);
            padding: 20px;
            border-radius: var(--radius-md);
            border: 1px solid var(--border-color);
            color: var(--text-primary);
            line-height: 1.6;
        }

        /* ── Actions ── */
        .dd-actions {
            padding: var(--space-lg) var(--space-xl);
            border-top: 1px solid var(--glass-border);
            display: flex; justify-content: flex-end; gap: 12px;
            background: rgba(255, 255, 255, 0.02);
        }
        
        .btn-edit {
            background: linear-gradient(135deg, var(--primary), var(--accent));
            color: white; padding: 11px 24px;
            border-radius: var(--radius-md); border: none; cursor: pointer;
            font-size: 0.9375rem; font-weight: 700; font-family: var(--font-family);
            display: inline-flex; align-items: center; gap: 8px; text-decoration: none;
            box-shadow: 0 4px 14px rgba(99,102,241,0.35);
            transition: all 0.2s;
        }
        .btn-edit:hover { transform: translateY(-2px); box-shadow: 0 6px 20px rgba(99,102,241,0.45); }
        
        .btn-delete {
            padding: 11px 20px; border-radius: var(--radius-md);
            background: var(--error-light); border: 1px solid rgba(239, 68, 68, 0.2);
            color: var(--error); font-size: 0.9375rem; font-weight: 600;
            text-decoration: none; transition: all 0.2s;
            display: inline-flex; align-items: center; gap: 8px;
        }
        .btn-delete:hover { background: rgba(239, 68, 68, 0.15); }
    </style>
</head>
<body class="app-page">
    <jsp:include page="/WEB-INF/views/header.jsp" />

    <main class="main-content">
        <div class="dd-container animate-fadeInUp">

            <!-- Back -->
            <a href="${pageContext.request.contextPath}/admin/departments" class="back-link">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/>
                </svg>
                Quay lại danh sách
            </a>

            <div class="dd-card">
                <!-- Card header -->
                <div class="dd-card-header">
                    <div class="dd-header-left">
                        <div class="dd-header-icon">
                            ${not empty department.departmentName ? department.departmentName.substring(0, 1).toUpperCase() : '?'}
                        </div>
                        <div>
                            <div class="dd-card-title"><c:out value="${department.departmentName}"/></div>
                            <div class="dd-card-subtitle">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/></svg>
                                <c:out value="${department.companyName}"/>
                            </div>
                        </div>
                    </div>
                    <div>
                        <span class="status-badge ${department.isActive ? 'active' : 'inactive'}">
                            <span class="status-dot"></span>
                            ${department.isActive ? 'Đang hoạt động' : 'Đã khóa'}
                        </span>
                    </div>
                </div>

                <div class="dd-body">
                    
                    <div>
                        <div class="dd-section-title">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="12"/><line x1="12" y1="8" x2="12.01" y2="8"/></svg>
                            Thông tin cơ bản
                        </div>
                        <div class="info-grid">
                            <div class="info-item">
                                <span class="info-label">Mã phòng ban (ID)</span>
                                <span class="info-value">#${department.departmentId}</span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Mô tả</span>
                                <c:choose>
                                    <c:when test="${not empty department.description}">
                                        <div class="desc-box"><c:out value="${department.description}"/></div>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="info-value empty">Chưa có mô tả</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <div>
                        <div class="dd-section-title">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg>
                            Thông tin liên hệ & Vị trí
                        </div>
                        <div class="info-grid">
                            <div class="info-item">
                                <span class="info-label">Người quản lý</span>
                                <span class="info-value ${empty department.managerName ? 'empty' : ''}">
                                    ${not empty department.managerName ? department.managerName : 'Chưa cập nhật'}
                                </span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Email liên hệ</span>
                                <span class="info-value ${empty department.contactEmail ? 'empty' : ''}">
                                    <c:if test="${not empty department.contactEmail}">
                                        <a href="mailto:${department.contactEmail}" style="color: var(--primary); text-decoration: none;">
                                            <c:out value="${department.contactEmail}"/>
                                        </a>
                                    </c:if>
                                    <c:if test="${empty department.contactEmail}">Chưa cập nhật</c:if>
                                </span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Số điện thoại</span>
                                <span class="info-value ${empty department.phoneNumber ? 'empty' : ''}">
                                    ${not empty department.phoneNumber ? department.phoneNumber : 'Chưa cập nhật'}
                                </span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Địa điểm làm việc</span>
                                <span class="info-value ${empty department.location ? 'empty' : ''}">
                                    ${not empty department.location ? department.location : 'Chưa cập nhật'}
                                </span>
                            </div>
                        </div>
                    </div>

                </div>

                <!-- Actions -->
                <div class="dd-actions">
                    <c:if test="${department.isActive}">
                        <a href="${pageContext.request.contextPath}/admin/departments?action=delete&id=${department.departmentId}" 
                           class="btn-delete" onclick="return confirm('Xác nhận khóa phòng ban này?')">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                            </svg>
                            Khóa phòng ban
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/departments?action=edit&id=${department.departmentId}" class="btn-edit">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                            </svg>
                            Chỉnh sửa
                        </a>
                    </c:if>
                </div>
            </div>

        </div>
    </main>
</body>
</html>

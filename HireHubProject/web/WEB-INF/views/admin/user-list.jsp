<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý người dùng - HireHub Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #6366f1;
            --primary-dark: #4f46e5;
            --success: #10b981;
            --warning: #f59e0b;
            --danger: #ef4444;
            --info: #3b82f6;
            --bg: #0f0f23;
            --bg2: #1a1a3e;
            --card: rgba(255,255,255,0.05);
            --border: rgba(255,255,255,0.1);
            --text: #e2e8f0;
            --text-muted: #94a3b8;
            --radius: 12px;
        }
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Inter',sans-serif; background:var(--bg); color:var(--text); min-height:100vh; }

        /* NAVBAR */
        .navbar { background:rgba(15,15,35,0.95); backdrop-filter:blur(20px); border-bottom:1px solid var(--border); padding:0 24px; height:64px; display:flex; align-items:center; position:sticky; top:0; z-index:100; }
        .navbar .inner { max-width:1400px; margin:0 auto; width:100%; display:flex; align-items:center; justify-content:space-between; }
        .nav-logo { display:flex; align-items:center; gap:10px; text-decoration:none; font-weight:700; font-size:20px; color:var(--text); }
        .nav-logo svg { flex-shrink:0; }
        .nav-links { display:flex; gap:8px; }
        .nav-link { padding:8px 16px; border-radius:8px; text-decoration:none; color:var(--text-muted); font-size:14px; font-weight:500; transition:all .2s; }
        .nav-link:hover, .nav-link.active { background:var(--card); color:var(--text); }
        .nav-avatar { width:36px; height:36px; border-radius:50%; background:linear-gradient(135deg,var(--primary),#8b5cf6); display:flex; align-items:center; justify-content:center; font-weight:700; font-size:14px; cursor:pointer; }

        /* MAIN */
        .main { max-width:1400px; margin:0 auto; padding:32px 24px; }

        /* PAGE HEADER */
        .page-header { display:flex; align-items:center; justify-content:space-between; margin-bottom:24px; }
        .page-header h1 { font-size:28px; font-weight:800; background:linear-gradient(135deg,#fff,#94a3b8); -webkit-background-clip:text; -webkit-text-fill-color:transparent; }
        .btn { display:inline-flex; align-items:center; gap:8px; padding:10px 20px; border-radius:8px; font-size:14px; font-weight:600; cursor:pointer; border:none; transition:all .2s; text-decoration:none; }
        .btn-primary { background:linear-gradient(135deg,var(--primary),#8b5cf6); color:#fff; }
        .btn-primary:hover { transform:translateY(-1px); box-shadow:0 8px 20px rgba(99,102,241,.4); }
        .btn-sm { padding:6px 14px; font-size:12px; }
        .btn-outline { background:transparent; color:var(--text); border:1px solid var(--border); }
        .btn-outline:hover { border-color:var(--primary); color:var(--primary); }
        .btn-danger { background:var(--danger); color:#fff; }
        .btn-success { background:var(--success); color:#fff; }
        .btn-warning { background:var(--warning); color:#000; }

        /* ALERT */
        .alert { padding:14px 18px; border-radius:10px; margin-bottom:20px; font-size:14px; font-weight:500; display:flex; align-items:center; gap:10px; }
        .alert-success { background:rgba(16,185,129,.15); border:1px solid rgba(16,185,129,.3); color:#34d399; }
        .alert-error   { background:rgba(239,68,68,.15);  border:1px solid rgba(239,68,68,.3);  color:#f87171; }

        /* FILTER CARD */
        .card { background:var(--card); border:1px solid var(--border); border-radius:var(--radius); padding:20px; }
        .filter-grid { display:grid; grid-template-columns:1fr 1fr 1fr auto; gap:16px; align-items:end; }
        .form-group label { display:block; font-size:12px; font-weight:600; color:var(--text-muted); margin-bottom:6px; text-transform:uppercase; letter-spacing:.5px; }
        .form-input { width:100%; background:rgba(255,255,255,.06); border:1px solid var(--border); border-radius:8px; padding:10px 14px; color:var(--text); font-size:14px; font-family:inherit; outline:none; transition:border-color .2s; }
        .form-input:focus { border-color:var(--primary); box-shadow:0 0 0 3px rgba(99,102,241,.15); }
        option { background:#1e1e3f; }

        /* TABLE */
        .table-card { margin-top:20px; overflow:hidden; }
        .table-wrap { overflow-x:auto; }
        table { width:100%; border-collapse:collapse; }
        thead tr { background:rgba(255,255,255,.04); border-bottom:1px solid var(--border); }
        th { padding:14px 16px; text-align:left; font-size:11px; font-weight:700; color:var(--text-muted); text-transform:uppercase; letter-spacing:.8px; white-space:nowrap; }
        td { padding:14px 16px; font-size:13px; border-bottom:1px solid rgba(255,255,255,.04); vertical-align:middle; }
        tbody tr:hover { background:rgba(255,255,255,.03); }
        tbody tr:last-child td { border-bottom:none; }
        .table-empty { text-align:center; color:var(--text-muted); padding:48px 16px !important; }

        /* BADGES */
        .badge { display:inline-flex; align-items:center; padding:4px 10px; border-radius:20px; font-size:11px; font-weight:700; letter-spacing:.3px; }
        .badge-admin    { background:rgba(99,102,241,.2);  color:#a5b4fc; border:1px solid rgba(99,102,241,.3); }
        .badge-recruiter{ background:rgba(59,130,246,.2);  color:#93c5fd; border:1px solid rgba(59,130,246,.3); }
        .badge-candidate{ background:rgba(16,185,129,.2);  color:#6ee7b7; border:1px solid rgba(16,185,129,.3); }
        .badge-active   { background:rgba(16,185,129,.2);  color:#6ee7b7; border:1px solid rgba(16,185,129,.3); }
        .badge-inactive { background:rgba(100,116,139,.2); color:#94a3b8; border:1px solid rgba(100,116,139,.3);}
        .badge-locked   { background:rgba(239,68,68,.2);   color:#fca5a5; border:1px solid rgba(239,68,68,.3);  }
        .badge-pending  { background:rgba(245,158,11,.2);  color:#fcd34d; border:1px solid rgba(245,158,11,.3); }
        .badge-yes      { background:rgba(16,185,129,.2);  color:#6ee7b7; }
        .badge-no       { background:rgba(239,68,68,.15);  color:#fca5a5; }
        .user-info { display:flex; align-items:center; gap:10px; }
        .user-av { width:34px; height:34px; border-radius:50%; background:linear-gradient(135deg,var(--primary),#8b5cf6); display:flex; align-items:center; justify-content:center; font-weight:700; font-size:13px; flex-shrink:0; }
        .user-av img { width:34px; height:34px; border-radius:50%; object-fit:cover; }
        .user-name { font-weight:600; font-size:13px; }
        .user-email { font-size:11px; color:var(--text-muted); }
        .actions { display:flex; gap:6px; }

        /* PAGER */
        .pager { display:flex; align-items:center; justify-content:space-between; margin-top:20px; }
        .pager-info { font-size:13px; color:var(--text-muted); }
        .pager-links { display:flex; align-items:center; gap:8px; }
        .pager-cur { font-size:13px; font-weight:600; padding:6px 12px; background:var(--card); border-radius:6px; }

        /* MODAL */
        .modal-overlay { position:fixed; inset:0; background:rgba(0,0,0,.7); backdrop-filter:blur(4px); z-index:1000; display:none; align-items:center; justify-content:center; padding:20px; }
        .modal-overlay.open { display:flex; animation:fadeIn .2s ease; }
        @keyframes fadeIn { from{opacity:0} to{opacity:1} }
        .modal { background:#1a1a3e; border:1px solid var(--border); border-radius:16px; width:100%; max-width:600px; max-height:90vh; overflow-y:auto; box-shadow:0 25px 60px rgba(0,0,0,.6); animation:slideUp .25s ease; }
        @keyframes slideUp { from{transform:translateY(30px);opacity:0} to{transform:translateY(0);opacity:1} }
        .modal-header { display:flex; align-items:center; justify-content:space-between; padding:24px 28px 0; }
        .modal-title { font-size:20px; font-weight:700; }
        .modal-close { width:32px; height:32px; border-radius:8px; border:none; background:rgba(255,255,255,.08); color:var(--text); cursor:pointer; font-size:18px; display:flex; align-items:center; justify-content:center; transition:all .2s; }
        .modal-close:hover { background:rgba(239,68,68,.2); color:#f87171; }
        .modal-body { padding:24px 28px; }
        .modal-footer { display:flex; gap:12px; justify-content:flex-end; padding:0 28px 24px; }
        .form-grid { display:grid; grid-template-columns:1fr 1fr; gap:16px; }
        .form-grid .full { grid-column:1/-1; }
        .form-label { display:block; font-size:12px; font-weight:600; color:var(--text-muted); margin-bottom:6px; text-transform:uppercase; letter-spacing:.5px; }
        .form-error { background:rgba(239,68,68,.15); border:1px solid rgba(239,68,68,.3); color:#f87171; padding:10px 14px; border-radius:8px; font-size:13px; margin-bottom:16px; border-radius:8px; }
        .hint { font-size:11px; color:var(--text-muted); margin-top:4px; }

        /* SCROLLBAR */
        ::-webkit-scrollbar { width:6px; height:6px; }
        ::-webkit-scrollbar-thumb { background:rgba(255,255,255,.1); border-radius:3px; }

        @media(max-width:768px){
            .filter-grid { grid-template-columns:1fr; }
            .form-grid { grid-template-columns:1fr; }
            .form-grid .full { grid-column:1; }
        }
    </style>
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar">
    <div class="inner">
        <a href="${pageContext.request.contextPath}/" class="nav-logo">
            <svg width="32" height="32" viewBox="0 0 48 48" fill="none">
                <rect width="48" height="48" rx="12" fill="url(#lg1)"/>
                <path d="M14 20h20M14 28h14M14 14h8v4h-8zM26 14h8v4h-8z" stroke="white" stroke-width="2.5" stroke-linecap="round"/>
                <defs><linearGradient id="lg1" x1="0" y1="0" x2="48" y2="48"><stop stop-color="#6366F1"/><stop offset="1" stop-color="#8B5CF6"/></linearGradient></defs>
            </svg>
            HireHub Admin
        </a>
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/admin/users" class="nav-link active">Quản lý người dùng</a>
        </div>
        <div class="nav-avatar">${empty requestScope.userFullName ? 'A' : fn:substring(requestScope.userFullName,0,1)}</div>
    </div>
</nav>

<main class="main">
    <!-- PAGE HEADER -->
    <div class="page-header">
        <h1>Quản lý người dùng</h1>
        <button class="btn btn-primary" onclick="openCreateModal()">
            ＋ Tạo tài khoản
        </button>
    </div>

    <!-- ALERTS -->
    <c:if test="${param.success == 'created'}">
        <div class="alert alert-success">✓ Tạo tài khoản thành công.</div>
    </c:if>
    <c:if test="${param.success == 'updated'}">
        <div class="alert alert-success">✓ Cập nhật tài khoản thành công.</div>
    </c:if>
    <c:if test="${param.success == 'status_updated'}">
        <div class="alert alert-success">✓ Cập nhật trạng thái thành công.</div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="alert alert-error">✕ Thao tác không thành công. Vui lòng thử lại.</div>
    </c:if>

    <!-- FILTER -->
    <div class="card">
        <form action="${pageContext.request.contextPath}/admin/users" method="GET" class="filter-grid">
            <div class="form-group">
                <label>Từ khóa</label>
                <input type="text" class="form-input" name="q" value="${empty q ? '' : q}" placeholder="Tên hoặc email...">
            </div>
            <div class="form-group">
                <label>Vai trò</label>
                <select class="form-input" name="role">
                    <option value="">Tất cả vai trò</option>
                    <c:forEach var="role" items="${roles}">
                        <option value="${role.roleCode}" ${selectedRole == role.roleCode ? 'selected' : ''}>${role.roleName}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group">
                <label>Trạng thái</label>
                <select class="form-input" name="status">
                    <option value="">Tất cả</option>
                    <option value="ACTIVE"   ${selectedStatus == 'ACTIVE'   ? 'selected':''}>Active</option>
                    <option value="INACTIVE" ${selectedStatus == 'INACTIVE' ? 'selected':''}>Inactive</option>
                    <option value="LOCKED"   ${selectedStatus == 'LOCKED'   ? 'selected':''}>Locked</option>
                    <option value="PENDING"  ${selectedStatus == 'PENDING'  ? 'selected':''}>Pending</option>
                </select>
            </div>
            <div class="form-group">
                <label>&nbsp;</label>
                <button type="submit" class="btn btn-primary" style="width:100%">Lọc</button>
            </div>
        </form>
    </div>

    <!-- TABLE -->
    <div class="card table-card">
        <div class="table-wrap">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Người dùng</th>
                        <th>Giới tính</th>
                        <th>Ngày sinh</th>
                        <th>Số điện thoại</th>
                        <th>Vai trò</th>
                        <th>Trạng thái</th>
                        <th>Xác thực email</th>
                        <th>Ngày tạo</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty users}">
                            <tr><td colspan="10" class="table-empty">Không có dữ liệu người dùng</td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="u" items="${users}">
                                <tr>
                                    <td style="color:var(--text-muted);font-size:12px">#${u.userId}</td>
                                    <td>
                                        <div class="user-info">
                                            <div class="user-av">
                                                <c:choose>
                                                    <c:when test="${not empty u.avatarUrl}">
                                                        <img src="${u.avatarUrl}" alt="${u.fullName}">
                                                    </c:when>
                                                    <c:otherwise>${fn:substring(u.fullName,0,1)}</c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div>
                                                <div class="user-name">${u.fullName}</div>
                                                <div class="user-email">${u.email}</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td style="color:var(--text-muted);font-size:12px">
                                        <c:choose>
                                            <c:when test="${u.gender == 'MALE'}">Nam</c:when>
                                            <c:when test="${u.gender == 'FEMALE'}">Nữ</c:when>
                                            <c:when test="${u.gender == 'OTHER'}">Khác</c:when>
                                            <c:otherwise>—</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="font-size:12px;color:var(--text-muted)">${empty u.dateOfBirth ? '—' : u.dateOfBirth}</td>
                                    <td style="font-size:12px">${empty u.phoneNumber ? '—' : u.phoneNumber}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.roleCode == 'ADMIN'}"><span class="badge badge-admin">ADMIN</span></c:when>
                                            <c:when test="${u.roleCode == 'RECRUITER'}"><span class="badge badge-recruiter">RECRUITER</span></c:when>
                                            <c:otherwise><span class="badge badge-candidate">${empty u.roleCode ? 'CANDIDATE' : u.roleCode}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <span class="badge badge-${fn:toLowerCase(u.status)}">${u.status}</span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.emailVerified}"><span class="badge badge-yes">✓ Đã xác thực</span></c:when>
                                            <c:otherwise><span class="badge badge-no">✕ Chưa xác thực</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="font-size:11px;color:var(--text-muted)">${empty u.createdAt ? '—' : fn:substring(u.createdAt.toString(),0,10)}</td>
                                    <td>
                                        <div class="actions">
                                            <button class="btn btn-outline btn-sm"
                                                onclick="openEditModal(
                                                    ${u.userId},
                                                    '${fn:escapeXml(u.email)}',
                                                    '${fn:escapeXml(u.fullName)}',
                                                    '${empty u.phoneNumber ? '' : fn:escapeXml(u.phoneNumber)}',
                                                    '${empty u.gender ? '' : u.gender}',
                                                    '${empty u.dateOfBirth ? '' : u.dateOfBirth}',
                                                    '${u.status}',
                                                    '${empty u.roleCode ? '' : u.roleCode}',
                                                    ${u.emailVerified ? 'true' : 'false'}
                                                )">Sửa</button>
                                            <form action="${pageContext.request.contextPath}/admin/users/delete" method="POST" style="display:inline" onsubmit="return confirmAction(this)">
                                                <input type="hidden" name="id" value="${u.userId}">
                                                <c:choose>
                                                    <c:when test="${u.status == 'INACTIVE'}">
                                                        <input type="hidden" name="action" value="restore">
                                                        <button type="submit" class="btn btn-success btn-sm">Mở lại</button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <input type="hidden" name="action" value="deactivate">
                                                        <button type="submit" class="btn btn-danger btn-sm">Khóa</button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>

    <!-- PAGER -->
    <div class="pager">
        <div class="pager-info">Tổng: <strong>${totalUsers}</strong> người dùng</div>
        <div class="pager-links">
            <c:if test="${currentPage > 1}">
                <a class="btn btn-outline btn-sm" href="${pageContext.request.contextPath}/admin/users?page=${currentPage - 1}&q=${q}&role=${selectedRole}&status=${selectedStatus}">← Trước</a>
            </c:if>
            <span class="pager-cur">Trang ${currentPage} / ${totalPages}</span>
            <c:if test="${currentPage < totalPages}">
                <a class="btn btn-outline btn-sm" href="${pageContext.request.contextPath}/admin/users?page=${currentPage + 1}&q=${q}&role=${selectedRole}&status=${selectedStatus}">Sau →</a>
            </c:if>
        </div>
    </div>
</main>

<!-- ===== MODAL CREATE ===== -->
<div class="modal-overlay" id="createModal">
    <div class="modal">
        <div class="modal-header">
            <div class="modal-title">➕ Tạo tài khoản mới</div>
            <button class="modal-close" onclick="closeModal('createModal')">✕</button>
        </div>
        <form action="${pageContext.request.contextPath}/admin/users/create" method="POST">
            <div class="modal-body">
                <c:if test="${not empty error and formMode == 'create'}">
                    <div class="form-error">⚠ ${error}</div>
                </c:if>
                <div class="form-grid">
                    <div class="form-group full">
                        <label class="form-label">Họ và tên *</label>
                        <input type="text" class="form-input" name="fullName" required placeholder="Nguyễn Văn A" value="${empty user ? '' : fn:escapeXml(user.fullName)}">
                    </div>
                    <div class="form-group full">
                        <label class="form-label">Email *</label>
                        <input type="email" class="form-input" name="email" required placeholder="example@hirehub.com" value="${empty user ? '' : fn:escapeXml(user.email)}">
                    </div>
                    <div class="form-group full">
                        <label class="form-label">Mật khẩu *</label>
                        <input type="password" class="form-input" name="password" required placeholder="Tối thiểu 8 ký tự, có hoa, thường, số">
                        <div class="hint">Ví dụ: Admin@123</div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Số điện thoại</label>
                        <input type="text" class="form-input" name="phoneNumber" placeholder="0900000000" value="${empty user ? '' : fn:escapeXml(user.phoneNumber)}">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Giới tính</label>
                        <select class="form-input" name="gender">
                            <option value="">-- Chọn --</option>
                            <option value="MALE">Nam</option>
                            <option value="FEMALE">Nữ</option>
                            <option value="OTHER">Khác</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Ngày sinh</label>
                        <input type="date" class="form-input" name="dateOfBirth" value="${empty user ? '' : user.dateOfBirth}">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Vai trò *</label>
                        <select class="form-input" name="roleId" required>
                            <option value="">-- Chọn vai trò --</option>
                            <c:forEach var="role" items="${roles}">
                                <option value="${role.roleId}" ${selectedRoleId == role.roleId ? 'selected' : ''}>${role.roleName} (${role.roleCode})</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Trạng thái</label>
                        <select class="form-input" name="status">
                            <option value="ACTIVE">Active</option>
                            <option value="INACTIVE">Inactive</option>
                            <option value="PENDING">Pending</option>
                            <option value="LOCKED">Locked</option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" onclick="closeModal('createModal')">Hủy</button>
                <button type="submit" class="btn btn-primary">Tạo tài khoản</button>
            </div>
        </form>
    </div>
</div>

<!-- ===== MODAL EDIT ===== -->
<div class="modal-overlay" id="editModal">
    <div class="modal">
        <div class="modal-header">
            <div class="modal-title">✏️ Chỉnh sửa tài khoản</div>
            <button class="modal-close" onclick="closeModal('editModal')">✕</button>
        </div>
        <form action="${pageContext.request.contextPath}/admin/users/edit" method="POST">
            <input type="hidden" name="id" id="editUserId">
            <div class="modal-body">
                <c:if test="${not empty error and formMode == 'edit'}">
                    <div class="form-error">⚠ ${error}</div>
                </c:if>
                <div class="form-grid">
                    <div class="form-group full">
                        <label class="form-label">Họ và tên *</label>
                        <input type="text" class="form-input" name="fullName" id="editFullName" required placeholder="Nguyễn Văn A">
                    </div>
                    <div class="form-group full">
                        <label class="form-label">Email *</label>
                        <input type="email" class="form-input" name="email" id="editEmail" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Số điện thoại</label>
                        <input type="text" class="form-input" name="phoneNumber" id="editPhone" placeholder="0900000000">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Giới tính</label>
                        <select class="form-input" name="gender" id="editGender">
                            <option value="">-- Chọn --</option>
                            <option value="MALE">Nam</option>
                            <option value="FEMALE">Nữ</option>
                            <option value="OTHER">Khác</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Ngày sinh</label>
                        <input type="date" class="form-input" name="dateOfBirth" id="editDob">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Vai trò *</label>
                        <select class="form-input" name="roleId" id="editRoleId" required>
                            <option value="">-- Chọn vai trò --</option>
                            <c:forEach var="role" items="${roles}">
                                <option value="${role.roleId}" data-code="${role.roleCode}">${role.roleName} (${role.roleCode})</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Trạng thái</label>
                        <select class="form-input" name="status" id="editStatus">
                            <option value="ACTIVE">Active</option>
                            <option value="INACTIVE">Inactive</option>
                            <option value="PENDING">Pending</option>
                            <option value="LOCKED">Locked</option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" onclick="closeModal('editModal')">Hủy</button>
                <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openCreateModal() {
        document.getElementById('createModal').classList.add('open');
        document.body.style.overflow = 'hidden';
    }

    function openEditModal(id, email, fullName, phone, gender, dob, status, roleCode, emailVerified) {
        document.getElementById('editUserId').value  = id;
        document.getElementById('editEmail').value   = email;
        document.getElementById('editFullName').value= fullName;
        document.getElementById('editPhone').value   = phone;
        document.getElementById('editDob').value     = dob;

        // Set gender
        const genderSel = document.getElementById('editGender');
        for (let o of genderSel.options) o.selected = (o.value === gender);

        // Set status
        const statusSel = document.getElementById('editStatus');
        for (let o of statusSel.options) o.selected = (o.value === status);

        // Set role bằng roleCode
        const roleSel = document.getElementById('editRoleId');
        for (let o of roleSel.options) {
            o.selected = (o.dataset.code === roleCode);
        }

        document.getElementById('editModal').classList.add('open');
        document.body.style.overflow = 'hidden';
    }

    function closeModal(id) {
        document.getElementById(id).classList.remove('open');
        document.body.style.overflow = '';
    }

    // Đóng modal khi click ngoài
    document.querySelectorAll('.modal-overlay').forEach(overlay => {
        overlay.addEventListener('click', function(e) {
            if (e.target === this) closeModal(this.id);
        });
    });

    // Đóng modal bằng Escape
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            document.querySelectorAll('.modal-overlay.open').forEach(m => closeModal(m.id));
        }
    });

    function confirmAction(form) {
        const action = form.querySelector('[name=action]').value;
        const msg = action === 'deactivate' ? 'Bạn có chắc muốn KHÓA tài khoản này?' : 'Bạn có chắc muốn MỞ LẠI tài khoản này?';
        return confirm(msg);
    }

    // Tự mở lại modal edit nếu có lỗi từ server
    <c:if test="${not empty error and formMode == 'edit'}">
    window.addEventListener('DOMContentLoaded', function() {
        document.getElementById('editModal').classList.add('open');
    });
    </c:if>
    <c:if test="${not empty error and formMode == 'create'}">
    window.addEventListener('DOMContentLoaded', function() {
        document.getElementById('createModal').classList.add('open');
    });
    </c:if>
</script>
</body>
</html>

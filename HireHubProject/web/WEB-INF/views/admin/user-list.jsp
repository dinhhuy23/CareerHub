<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý người dùng - HireHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="app-page">
<nav class="navbar glass-nav">
    <div class="nav-container">
        <a href="${pageContext.request.contextPath}/user/dashboard" class="nav-logo">
            <svg width="36" height="36" viewBox="0 0 48 48" fill="none">
                <rect width="48" height="48" rx="12" fill="url(#adminLogo)"/>
                <path d="M14 20h20M14 28h14M14 14h8v4h-8zM26 14h8v4h-8z" stroke="white" stroke-width="2.5" stroke-linecap="round"/>
                <defs><linearGradient id="adminLogo" x1="0" y1="0" x2="48" y2="48"><stop stop-color="#6366F1"/><stop offset="1" stop-color="#8B5CF6"/></linearGradient></defs>
            </svg>
            <span>HireHub</span>
        </a>
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/user/dashboard" class="nav-link">Dashboard</a>
            <a href="${pageContext.request.contextPath}/admin/users" class="nav-link active">Quản lý người dùng</a>
        </div>
        <div class="nav-user">
            <div class="user-dropdown">
                <button class="user-btn" onclick="toggleDropdown()">
                    <div class="user-avatar">${sessionScope.userFullName.substring(0,1)}</div>
                    <span class="user-name">${sessionScope.userFullName}</span>
                </button>
                <div class="dropdown-menu" id="userDropdown">
                    <a href="${pageContext.request.contextPath}/user/profile" class="dropdown-item">Thông tin cá nhân</a>
                    <hr class="dropdown-divider">
                    <a href="${pageContext.request.contextPath}/logout" class="dropdown-item text-danger">Đăng xuất</a>
                </div>
            </div>
        </div>
    </div>
</nav>

<main class="main-content">
    <div class="container">
        <div class="page-header animate-fadeInUp">
            <h1>Quản lý người dùng</h1>
            <a href="${pageContext.request.contextPath}/admin/users/create" class="btn btn-primary">Tạo tài khoản</a>
        </div>

        <c:if test="${param.success == 'created'}">
            <div class="alert alert-success animate-slideDown"><span>Tạo tài khoản thành công.</span></div>
        </c:if>
        <c:if test="${param.success == 'updated'}">
            <div class="alert alert-success animate-slideDown"><span>Cập nhật tài khoản thành công.</span></div>
        </c:if>
        <c:if test="${param.success == 'status_updated'}">
            <div class="alert alert-success animate-slideDown"><span>Cập nhật trạng thái thành công.</span></div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="alert alert-error animate-slideDown"><span>Thao tác không thành công. Vui lòng thử lại.</span></div>
        </c:if>

        <div class="form-card glass-card animate-fadeInUp" style="margin-bottom: 20px;">
            <form action="${pageContext.request.contextPath}/admin/users" method="GET" class="admin-filter-grid">
                <div class="form-group">
                    <label class="form-label">Từ khóa</label>
                    <input type="text" class="form-input" name="q" value="${empty q ? '' : q}" placeholder="Tên hoặc email">
                </div>
                <div class="form-group">
                    <label class="form-label">Vai trò</label>
                    <select class="form-input form-select" name="role">
                        <option value="">Tất cả</option>
                        <c:forEach var="role" items="${roles}">
                            <option value="${role.roleCode}" ${selectedRole == role.roleCode ? 'selected' : ''}>${role.roleName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">Trạng thái</label>
                    <select class="form-input form-select" name="status">
                        <option value="">Tất cả</option>
                        <option value="ACTIVE" ${selectedStatus == 'ACTIVE' ? 'selected' : ''}>ACTIVE</option>
                        <option value="INACTIVE" ${selectedStatus == 'INACTIVE' ? 'selected' : ''}>INACTIVE</option>
                        <option value="LOCKED" ${selectedStatus == 'LOCKED' ? 'selected' : ''}>LOCKED</option>
                        <option value="PENDING" ${selectedStatus == 'PENDING' ? 'selected' : ''}>PENDING</option>
                    </select>
                </div>
                <div class="form-group admin-filter-actions">
                    <button type="submit" class="btn btn-primary">Lọc</button>
                </div>
            </form>
        </div>

        <div class="glass-card table-card animate-fadeInUp">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Họ tên</th>
                        <th>Email</th>
                        <th>Vai trò</th>
                        <th>Trạng thái</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty users}">
                            <tr>
                                <td colspan="6" class="table-empty">Không có dữ liệu</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="user" items="${users}">
                                <tr>
                                    <td>${user.userId}</td>
                                    <td>${user.fullName}</td>
                                    <td>${user.email}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${user.roleCode == 'ADMIN'}"><span class="role-badge role-admin">ADMIN</span></c:when>
                                            <c:when test="${user.roleCode == 'RECRUITER'}"><span class="role-badge role-recruiter">RECRUITER</span></c:when>
                                            <c:otherwise><span class="role-badge role-candidate">CANDIDATE</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <span class="status-badge status-${fn:toLowerCase(user.status)}">${user.status}</span>
                                    </td>
                                    <td>
                                        <div class="table-actions">
                                            <a class="btn btn-outline btn-sm" href="${pageContext.request.contextPath}/admin/users/edit?id=${user.userId}">Sửa</a>
                                            <form action="${pageContext.request.contextPath}/admin/users/delete" method="POST" class="inline-form">
                                                <input type="hidden" name="id" value="${user.userId}">
                                                <c:choose>
                                                    <c:when test="${user.status == 'INACTIVE'}">
                                                        <input type="hidden" name="action" value="restore">
                                                        <button type="submit" class="btn btn-primary btn-sm">Mở lại</button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <input type="hidden" name="action" value="deactivate">
                                                        <button type="submit" class="btn btn-outline btn-sm">Khóa</button>
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

        <div class="pager-wrap animate-fadeInUp">
            <div class="pager-info">Tổng: ${totalUsers}</div>
            <div class="pager-links">
                <c:if test="${currentPage > 1}">
                    <a class="btn btn-outline btn-sm" href="${pageContext.request.contextPath}/admin/users?page=${currentPage - 1}&q=${q}&role=${selectedRole}&status=${selectedStatus}">Trước</a>
                </c:if>
                <span class="pager-current">Trang ${currentPage}/${totalPages}</span>
                <c:if test="${currentPage < totalPages}">
                    <a class="btn btn-outline btn-sm" href="${pageContext.request.contextPath}/admin/users?page=${currentPage + 1}&q=${q}&role=${selectedRole}&status=${selectedStatus}">Sau</a>
                </c:if>
            </div>
        </div>
    </div>
</main>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>

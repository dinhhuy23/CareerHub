<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${formMode == 'edit' ? 'Chỉnh sửa tài khoản' : 'Tạo tài khoản'} - HireHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="app-page">
<nav class="navbar glass-nav">
    <div class="nav-container">
        <a href="${pageContext.request.contextPath}/admin/users" class="nav-logo">
            <svg width="36" height="36" viewBox="0 0 48 48" fill="none">
                <rect width="48" height="48" rx="12" fill="url(#adminFormLogo)"/>
                <path d="M14 20h20M14 28h14M14 14h8v4h-8zM26 14h8v4h-8z" stroke="white" stroke-width="2.5" stroke-linecap="round"/>
                <defs><linearGradient id="adminFormLogo" x1="0" y1="0" x2="48" y2="48"><stop stop-color="#6366F1"/><stop offset="1" stop-color="#8B5CF6"/></linearGradient></defs>
            </svg>
            <span>HireHub</span>
        </a>
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/admin/users" class="nav-link active">Quản lý người dùng</a>
        </div>
        <div class="nav-user">
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline">Đăng xuất</a>
        </div>
    </div>
</nav>

<main class="main-content">
    <div class="container">
        <div class="page-header animate-fadeInUp">
            <h1>${formMode == 'edit' ? 'Chỉnh sửa tài khoản' : 'Tạo tài khoản mới'}</h1>
            <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline">Quay lại</a>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-error animate-slideDown"><span>${error}</span></div>
        </c:if>

        <div class="form-card glass-card animate-fadeInUp">
            <form action="${pageContext.request.contextPath}${formMode == 'edit' ? '/admin/users/edit' : '/admin/users/create'}" method="POST" class="edit-form">
                <c:if test="${formMode == 'edit'}">
                    <input type="hidden" name="id" value="${user.userId}">
                </c:if>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Họ và tên *</label>
                        <input class="form-input" type="text" name="fullName" value="${user.fullName}" required maxlength="150">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Email *</label>
                        <input class="form-input" type="email" name="email" value="${user.email}" required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Số điện thoại</label>
                        <input class="form-input" type="text" name="phoneNumber" value="${user.phoneNumber}">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Giới tính</label>
                        <select class="form-input form-select" name="gender">
                            <option value="" ${empty user.gender ? 'selected' : ''}>-- Chọn --</option>
                            <option value="Nam" ${user.gender == 'Nam' ? 'selected' : ''}>Nam</option>
                            <option value="Nu" ${user.gender == 'Nu' ? 'selected' : ''}>Nữ</option>
                            <option value="Khac" ${user.gender == 'Khac' ? 'selected' : ''}>Khác</option>
                        </select>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Ngày sinh</label>
                        <input class="form-input" type="date" name="dateOfBirth" value="<fmt:formatDate value='${user.dateOfBirth}' pattern='yyyy-MM-dd'/>">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Trạng thái</label>
                        <select class="form-input form-select" name="status">
                            <c:set var="statusValue" value="${not empty selectedStatus ? selectedStatus : user.status}"/>
                            <option value="ACTIVE" ${statusValue == 'ACTIVE' ? 'selected' : ''}>ACTIVE</option>
                            <option value="INACTIVE" ${statusValue == 'INACTIVE' ? 'selected' : ''}>INACTIVE</option>
                            <option value="LOCKED" ${statusValue == 'LOCKED' ? 'selected' : ''}>LOCKED</option>
                            <option value="PENDING" ${statusValue == 'PENDING' ? 'selected' : ''}>PENDING</option>
                        </select>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Vai trò *</label>
                        <select class="form-input form-select" name="roleId" required>
                            <option value="">-- Chọn vai trò --</option>
                            <c:forEach var="role" items="${roles}">
                                <option value="${role.roleId}"
                                        ${(not empty selectedRoleId and selectedRoleId == role.roleId) or (empty selectedRoleId and user.roleCode == role.roleCode) ? 'selected' : ''}>
                                    ${role.roleName} (${role.roleCode})
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <c:if test="${formMode != 'edit'}">
                        <div class="form-group">
                            <label class="form-label">Mật khẩu *</label>
                            <input class="form-input" type="password" name="password" required>
                        </div>
                    </c:if>
                </div>

                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline">Hủy</a>
                    <button type="submit" class="btn btn-primary">${formMode == 'edit' ? 'Lưu thay đổi' : 'Tạo tài khoản'}</button>
                </div>
            </form>
        </div>
    </div>
</main>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>

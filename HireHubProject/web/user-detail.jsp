<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết người dùng</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>
        .page-header{
            display:flex;
            justify-content:space-between;
            align-items:center;
            margin-bottom:20px;
        }

        .profile-card{
            padding:30px;
        }

        .profile-header{
            display:flex;
            align-items:center;
            gap:20px;
            margin-bottom:30px;
        }

        .profile-avatar-large{
            width:80px;
            height:80px;
            border-radius:50%;
            display:flex;
            align-items:center;
            justify-content:center;
            font-size:32px;
            font-weight:bold;
            color:white;
            background:linear-gradient(135deg,#6366f1,#8b5cf6);
        }

        .profile-header-info h2{
            color:white;
            margin-bottom:8px;
        }

        .role-badge{
            padding:6px 12px;
            border-radius:999px;
            color:white;
            font-size:13px;
        }

        .role-admin{
            background:#ef4444;
        }

        .role-recruiter{
            background:#3b82f6;
        }

        .role-candidate{
            background:#22c55e;
        }

        .profile-details{
            margin-top:20px;
        }

        .detail-row{
            display:flex;
            justify-content:space-between;
            padding:14px 0;
            border-bottom:1px solid rgba(255,255,255,0.08);
        }

        .detail-label{
            color:#cbd5e1;
            font-weight:600;
        }

        .detail-value{
            color:white;
        }

        .status-badge{
            padding:6px 12px;
            border-radius:999px;
            font-size:12px;
            color:white;
        }

        .status-active{
            background:#22c55e;
        }

        .status-inactive{
            background:#ef4444;
        }

        .btn-back{
            display:inline-block;
            margin-top:25px;
            padding:10px 16px;
            border-radius:10px;
            text-decoration:none;
            color:white;
            background:linear-gradient(135deg,#6366f1,#8b5cf6);
        }
    </style>
</head>

<body class="app-page">

<jsp:include page="/WEB-INF/views/header.jsp" />

<main class="main-content">
    <div class="container">

        <div class="page-header">
            <h1 style="color:white;">👤 Chi tiết người dùng</h1>
        </div>

        <div class="glass-card profile-card">

            <!-- Header -->
            <div class="profile-header">
                <div class="profile-avatar-large">
                    ${user.fullName.substring(0,1)}
                </div>

                <div class="profile-header-info">
                    <h2>${user.fullName}</h2>

                    <span class="role-badge role-${user.roleCode.toLowerCase()}">
                        <c:choose>
                            <c:when test="${user.roleCode == 'ADMIN'}">Quản trị viên</c:when>
                            <c:when test="${user.roleCode == 'RECRUITER'}">Nhà tuyển dụng</c:when>
                            <c:when test="${user.roleCode == 'CANDIDATE'}">Ứng viên</c:when>
                            <c:otherwise>${user.roleCode}</c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </div>

            <!-- Detail -->
            <div class="profile-details">

                <div class="detail-row">
                    <div class="detail-label">ID</div>
                    <div class="detail-value">${user.userId}</div>
                </div>

                <div class="detail-row">
                    <div class="detail-label">Email</div>
                    <div class="detail-value">${user.email}</div>
                </div>

                <div class="detail-row">
                    <div class="detail-label">Họ và tên</div>
                    <div class="detail-value">${user.fullName}</div>
                </div>

                <div class="detail-row">
                    <div class="detail-label">Số điện thoại</div>
                    <div class="detail-value">
                        ${not empty user.phoneNumber ? user.phoneNumber : 'Chưa cập nhật'}
                    </div>
                </div>

                <div class="detail-row">
                    <div class="detail-label">Giới tính</div>
                    <div class="detail-value">
                        ${not empty user.gender ? user.gender : 'Chưa cập nhật'}
                    </div>
                </div>

                <div class="detail-row">
                    <div class="detail-label">Ngày sinh</div>
                    <div class="detail-value">
                        <c:choose>
                            <c:when test="${not empty user.dateOfBirth}">
                                <fmt:formatDate value="${user.dateOfBirth}" pattern="dd/MM/yyyy"/>
                            </c:when>
                            <c:otherwise>Chưa cập nhật</c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="detail-row">
                    <div class="detail-label">Trạng thái</div>
                    <div class="detail-value">
                        <span class="status-badge ${user.status == 'ACTIVE' ? 'status-active' : 'status-inactive'}">
                            ${user.status}
                        </span>
                    </div>
                </div>

                <div class="detail-row">
                    <div class="detail-label">Ngày tạo</div>
                    <div class="detail-value">
                        <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                    </div>
                </div>

                <div class="detail-row">
                    <div class="detail-label">Lần đăng nhập cuối</div>
                    <div class="detail-value">
                        <c:choose>
                            <c:when test="${not empty user.lastLoginAt}">
                                <fmt:formatDate value="${user.lastLoginAt}" pattern="dd/MM/yyyy HH:mm"/>
                            </c:when>
                            <c:otherwise>Chưa đăng nhập</c:otherwise>
                        </c:choose>
                    </div>
                </div>

            </div>

            <a href="usermanager" class="btn-back">← Quay lại danh sách</a>

        </div>
    </div>
</main>

</body>
</html>
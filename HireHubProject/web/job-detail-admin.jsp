<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết Job</title>

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
            border-radius:16px;
            display:flex;
            align-items:center;
            justify-content:center;
            font-size:28px;
            font-weight:bold;
            color:white;
            background:linear-gradient(135deg,#22c55e,#4ade80);
        }

        .profile-header-info h2{
            color:white;
            margin-bottom:8px;
        }

        .status-badge{
            padding:6px 12px;
            border-radius:999px;
            font-size:12px;
            color:white;
        }

        .status-published{
            background:#22c55e;
        }

        .status-draft{
            background:#9ca3af;
        }

        .status-closed{
            background:#ef4444;
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
            text-align:right;
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

        .btn-group{
            display:flex;
            gap:10px;
        }

        .btn-delete{
            background: rgba(255,80,80,0.15);
            color:#ff6b6b;
        }

        .btn-edit{
            background: linear-gradient(135deg,#6366f1,#8b5cf6);
            color:white;
        }
    </style>
</head>

<body class="app-page">

<jsp:include page="/WEB-INF/views/header.jsp" />

<main class="main-content">
    <div class="container">

        <div class="page-header">
            <h1 style="color:white;">💼 Chi tiết Job</h1>

            <div class="btn-group">
                <a class="btn btn-edit"
                   href="#"
                   onclick="openEditModal(
                       '${job.jobId}',
                       '${job.title}',
                       '${job.salaryMin}',
                       '${job.salaryMax}'
                   )">
                    ✏️ Sửa
                </a>

                <a class="btn btn-delete"
                   href="jobmanager?action=delete&id=${job.jobId}"
                   onclick="return confirm('Đóng job này?')">
                    🔒 Đóng
                </a>
            </div>
        </div>

        <div class="glass-card profile-card">

            <!-- HEADER -->
            <div class="profile-header">
                <div class="profile-avatar-large">
                    💼
                </div>

                <div class="profile-header-info">
                    <h2>${job.title}</h2>

                    <span class="status-badge
                        ${job.status == 'PUBLISHED' ? 'status-published' : 
                          job.status == 'DRAFT' ? 'status-draft' : 'status-closed'}">
                        ${job.status}
                    </span>
                </div>
            </div>

            <!-- DETAILS -->
            <div class="profile-details">

                <div class="detail-row">
                    <div class="detail-label">ID</div>
                    <div class="detail-value">${job.jobId}</div>
                </div>

                <div class="detail-row">
                    <div class="detail-label">Công ty</div>
                    <div class="detail-value">${job.companyName}</div>
                </div>

                <div class="detail-row">
                    <div class="detail-label">Lương</div>
                    <div class="detail-value">
                        <c:choose>
                            <c:when test="${job.salaryMax != null}">
                                <fmt:formatNumber value="${job.salaryMin}" /> -
                                <fmt:formatNumber value="${job.salaryMax}" /> VND
                            </c:when>
                            <c:otherwise>Thỏa thuận</c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="detail-row">
                    <div class="detail-label">Hạn nộp</div>
                    <div class="detail-value">
                        <fmt:formatDate value="${job.deadlineAt}" pattern="dd/MM/yyyy"/>
                    </div>
                </div>

                <div class="detail-row">
                    <div class="detail-label">Lượt xem</div>
                    <div class="detail-value">${job.viewCount}</div>
                </div>

                <div class="detail-row">
                    <div class="detail-label">Ngành</div>
                    <div class="detail-value">${job.categoryName}</div>
                </div>

                <div class="detail-row">
                    <div class="detail-label">Địa điểm</div>
                    <div class="detail-value">${job.locationName}</div>
                </div>

                <div class="detail-row">
                    <div class="detail-label">Kinh nghiệm</div>
                    <div class="detail-value">${job.experienceLevelName}</div>
                </div>

                <div class="detail-row">
                    <div class="detail-label">Hình thức</div>
                    <div class="detail-value">${job.employmentTypeName}</div>
                </div>

                <div class="detail-row">
                    <div class="detail-label">Mô tả</div>
                    <div class="detail-value">${job.description}</div>
                </div>

                <div class="detail-row">
                    <div class="detail-label">Yêu cầu</div>
                    <div class="detail-value">${job.requirements}</div>
                </div>

                <div class="detail-row">
                    <div class="detail-label">Quyền lợi</div>
                    <div class="detail-value">${job.responsibilities}</div>
                </div>

            </div>

            <a href="jobmanager" class="btn-back">← Quay lại danh sách</a>

        </div>
    </div>
</main>

</body>
</html>

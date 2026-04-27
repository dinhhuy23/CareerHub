<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Admin - Notification Management</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>
        .table-container{ margin-top: 20px; }

        table{
            width:100%;
            border-collapse: collapse;
            color: white;
        }

        th, td{
            padding:14px;
            border-bottom:1px solid rgba(255,255,255,0.08);
        }

        th{ opacity:0.7; }

        tr:hover{ background: rgba(255,255,255,0.05); }

        .page-title{
            text-align:center;
            font-size:26px;
            margin-bottom:20px;
            color:white;
        }

        .btn{
            padding:8px 14px;
            border-radius:10px;
            text-decoration:none;
            font-size:13px;
            margin-right:6px;
        }

        .btn-view{
            background: linear-gradient(135deg,#6366f1,#8b5cf6);
            color:white;
        }

        .btn-create{
            background: linear-gradient(135deg,#22c55e,#4ade80);
            color:white;
        }

        table td, table th {
            text-align: center;
            vertical-align: middle;
        }

        .search-box{
            display:flex;
            justify-content:center;
            gap:10px;
            margin-bottom:20px;
        }

        .search-box input{
            width:300px;
            padding:10px 14px;
            border-radius:10px;
            border:none;
            background: rgba(255,255,255,0.08);
            color:white;
        }

        .search-box button{
            padding:10px 18px;
            border-radius:10px;
            border:none;
            background: linear-gradient(135deg,#6366f1,#8b5cf6);
            color:white;
        }
    </style>
</head>

<body class="app-page">

<jsp:include page="/WEB-INF/views/header.jsp" />

<main class="main-content">
    <div class="container">

        <div class="page-title">📤 Thông báo đã gửi</div>

        <div class="glass-card table-container">

            <!-- SEARCH -->
            <form action="notification" method="get" class="search-box">
                <input type="hidden" name="view" value="sent"/>
                <input type="text" name="keyword"
                       placeholder="🔍 Tìm theo tiêu đề..."
                       value="${keyword}" />
                <button type="submit">Tìm</button>
            </form>

            <!-- TABLE -->
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Tiêu đề</th>
                        <th>Nội dung</th>
                        <th>Thời gian</th>
                    </tr>
                </thead>

                <tbody>
                    <c:forEach var="n" items="${notifications}">
                        <tr>
                            <td>${n.notificationId}</td>
                            <td>${n.title}</td>
                            <td>${n.message}</td>
                            <td>${n.createdAt}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <!-- PAGINATION -->
            <div style="text-align:center; margin-top:20px;">

                <c:if test="${currentPage > 1}">
                    <a class="btn btn-view"
                       href="notification?view=sent&page=${currentPage - 1}&keyword=${keyword}">
                        ← Trước
                    </a>
                </c:if>

                <c:forEach begin="1" end="${totalPages}" var="i">
                    <a class="btn"
                       style="${i == currentPage ? 'background:#4ade80;color:black' : ''}"
                       href="notification?view=sent&page=${i}&keyword=${keyword}">
                        ${i}
                    </a>
                </c:forEach>

                <c:if test="${currentPage < totalPages}">
                    <a class="btn btn-view"
                       href="notification?view=sent&page=${currentPage + 1}&keyword=${keyword}">
                        Sau →
                    </a>
                </c:if>

            </div>

        </div>

        <div style="margin-top:20px; text-align:center;">
                    <a href="admin" class="btn btn-view">
                        ← Quay lại Dashboard
                    </a>
                </div>

    </div>
</main>

</body>
</html>

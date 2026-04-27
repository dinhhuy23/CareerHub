<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Admin - Report Management</title>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

        <style>
            .page-title{
                text-align:center;
                font-size:26px;
                margin-bottom:20px;
                color:white;
            }

            .glass-card{
                padding:20px;
            }

            .search-box{
                display:flex;
                justify-content:center;
                gap:10px;
                margin-bottom:20px;
                flex-wrap:wrap;
            }

            .search-box input,
            .search-box select{
                padding:10px 14px;
                border-radius:10px;
                border:none;
                outline:none;
                background: rgba(255,255,255,0.08);
                color:white;
            }

            .search-box input::placeholder{
                color:rgba(255,255,255,0.5);
            }

            .search-box button{
                padding:10px 18px;
                border-radius:10px;
                border:none;
                background: linear-gradient(135deg,#6366f1,#8b5cf6);
                color:white;
                cursor:pointer;
            }

            table{
                width:100%;
                border-collapse: collapse;
                color:white;
            }

            th, td{
                padding:14px;
                border-bottom:1px solid rgba(255,255,255,0.08);
                text-align:center;
            }

            tr:hover{
                background: rgba(255,255,255,0.05);
            }

            .status-badge{
                padding:5px 10px;
                border-radius:10px;
                font-size:12px;
                font-weight:600;
            }

            .pending{
                background: rgba(250,204,21,0.2);
                color:#facc15;
            }
            .approved{
                background: rgba(34,197,94,0.2);
                color:#22c55e;
            }
            .rejected{
                background: rgba(239,68,68,0.2);
                color:#ef4444;
            }

            .btn{
                padding:6px 10px;
                border-radius:8px;
                border:none;
                cursor:pointer;
                color:white;
            }

            .btn-approve{
                background:#22c55e;
            }
            .btn-reject{
                background:#ef4444;
            }

            .pagination{
                text-align:center;
                margin-top:20px;
            }

            .pagination a{
                margin:0 5px;
                padding:6px 12px;
                border-radius:8px;
                background: rgba(255,255,255,0.1);
                color:white;
                text-decoration:none;
            }

            .pagination a.active{
                background:#4ade80;
                color:black;
            }
            .status-select {
                padding: 10px 14px;
                border-radius: 10px;
                border: none;
                outline: none;

                background: rgba(255,255,255,0.08);
                color: white;

                cursor: pointer;
            }

            /* option fix màu khi dropdown mở */
            .status-select option {
                background: #1e1e2f;
                color: white;
            }

        </style>
    </head>

    <body class="app-page">

        <jsp:include page="/WEB-INF/views/header.jsp" />

        <main class="main-content">
            <div class="container">

                <div class="page-title">🚨 Quản lý Report</div>

                <!-- 🔍 SEARCH + FILTER -->
                <form action="report" method="get" class="search-box">

                    <input type="text"
                           name="keyword"
                           placeholder="🔍 Tìm nội dung..."
                           value="${keyword}" />

                    <!-- STATUS FILTER (đã làm đẹp hơn) -->
                    <select name="status" class="status-select">
                        <option value="" ${empty status ? 'selected' : ''}>Tất cả</option>
                        <option value="PENDING" ${status == 'PENDING' ? 'selected' : ''}>Chưa xử lý</option>
                        <option value="APPROVED" ${status == 'APPROVED' ? 'selected' : ''}>Đã duyệt</option>
                        <option value="REJECTED" ${status == 'REJECTED' ? 'selected' : ''}>Từ chối</option>
                    </select>

                    <button type="submit">Tìm</button>
                </form>

                <div class="glass-card">

                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Người báo cáo</th>
                                <th>Nội dung</th>
                                <th>Trạng thái</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>

                        <tbody>
                            <c:forEach var="r" items="${reports}">
                                <tr>
                                    <td>${r.reportId}</td>
                                    <td>${r.targetType} #${r.targetId}</td>
                                    <td>${r.content}</td>

                                    <td>
                                        <span class="status-badge
                                              ${r.status == 'PENDING' ? 'pending' :
                                                r.status == 'APPROVED' ? 'approved' : 'rejected'}">

                                            <c:choose>
                                                <c:when test="${r.status == 'PENDING'}">Chưa xử lý</c:when>
                                                <c:when test="${r.status == 'APPROVED'}">Đã duyệt</c:when>
                                                <c:otherwise>Từ chối</c:otherwise>
                                            </c:choose>

                                        </span>
                                    </td>

                                    <td>
                                        <form action="report" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="approve"/>
                                            <input type="hidden" name="id" value="${r.reportId}"/>
                                            <button class="btn btn-approve">✔</button>
                                        </form>

                                        <form action="report" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="reject"/>
                                            <input type="hidden" name="id" value="${r.reportId}"/>
                                            <button class="btn btn-reject"
                                                    onclick="return confirm('Từ chối report này?')">
                                                ✖
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                </div>

                <!-- 📄 PAGINATION -->
                <div class="pagination">

                    <c:if test="${currentPage > 1}">
                        <a href="report?page=${currentPage - 1}&keyword=${keyword}&status=${status}">←</a>
                    </c:if>

                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <a href="report?page=${i}&keyword=${keyword}&status=${status}"
                           class="${i == currentPage ? 'active' : ''}">
                            ${i}
                        </a>
                    </c:forEach>

                    <c:if test="${currentPage < totalPages}">
                        <a href="report?page=${currentPage + 1}&keyword=${keyword}&status=${status}">→</a>
                    </c:if>

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

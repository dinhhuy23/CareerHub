<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Admin - Report Management</title>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

        <style>
            .table-container{
                margin-top: 20px;
            }

            table{
                width:100%;
                border-collapse: collapse;
                color: white;
            }

            th, td{
                padding:14px;
                border-bottom:1px solid rgba(255,255,255,0.08);
            }

            th{
                opacity:0.7;
            }

            tr:hover{
                background: rgba(255,255,255,0.05);
            }

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
                border:none;
                cursor:pointer;
            }

            .btn-approve{
                background: linear-gradient(135deg,#22c55e,#4ade80);
                color:white;
            }

            .btn-reject{
                background: rgba(255,80,80,0.15);
                color:#ff6b6b;
            }

            .status-badge {
                padding:4px 10px;
                border-radius:10px;
                font-size:12px;
                font-weight:600;
            }

            .pending {
                background: rgba(250,204,21,0.2);
                color: #facc15;
            }

            .approved {
                background: rgba(34,197,94,0.2);
                color: #22c55e;
            }

            .rejected {
                background: rgba(239,68,68,0.2);
                color: #ef4444;
            }
            table td, table th {
                text-align: center;
                vertical-align: middle;
            }
        </style>
    </head>

    <body class="app-page">

        <jsp:include page="/WEB-INF/views/header.jsp" />

        <main class="main-content">
            <div class="container">

                <div class="page-title">🚨 Quản lý Report</div>

                <div class="glass-card table-container">

                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Mục tiêu</th>
                                <th>Nội dung</th>
                                <th>Trạng thái</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>

                        <tbody>
                            <c:forEach var="r" items="${reports}">
                                <tr>                  
                                    <td>${r.reportId}</td>
                                    <td>${r.targetType} - ${r.targetId}</td>
                                    <td>${r.content}</td>

                                    <td>
                                        <span class="status-badge
                                              ${r.status == 'PENDING' ? 'pending' :
                                                r.status == 'APPROVED' ? 'approved' : 'rejected'}">

                                            <c:choose>
                                                <c:when test="${r.status == 'PENDING'}">Chưa giải quyết</c:when>
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
                                            <button onclick="return confirm('Bạn chắc chắn muốn từ chối?')" class="btn btn-reject">✖</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>

                    </table>
                </div>

                <div style="margin-top:20px;">
                    <a href="AdminServlet">← Quay lại Dashboard</a>
                </div>

            </div>
        </main>

    </body>
</html>

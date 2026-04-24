<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Admin - Job Management</title>

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

            .action-top{
                text-align:right;
                margin-bottom:15px;
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
            .btn-delete{
                background: rgba(255,80,80,0.15);
                color:#ff6b6b;
            }
            .btn-create{
                background: linear-gradient(135deg,#22c55e,#4ade80);
                color:white;
            }

            table td, table th {
                text-align: center;
            }

            .modal-overlay {
                position: fixed;
                top:0;
                left:0;
                width:100%;
                height:100%;
                display:flex;
                justify-content:center;
                align-items:center;
                background: rgba(0,0,0,0.5);
                z-index:9999;
            }

            .modal-box {
                background:#1e1e2f;
                padding:25px;
                border-radius:16px;
                width:450px;
                color:white;
            }
        </style>
    </head>

    <body class="app-page">

        <jsp:include page="/WEB-INF/views/header.jsp" />

        <main class="main-content">
            <div class="container">

                <div class="page-title">💼 Quản lý Job</div>

                <div class="action-top">
                    <button class="btn btn-create" onclick="openModal()">➕ Tạo Job</button>
                </div>

                <!-- TABLE -->
                <div class="glass-card table-container">

                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tiêu đề</th>
                                <th>Lương Từ (VNĐ) </th>
                                <th>Lương Đến (VNĐ) </th>
                                <th>Trạng thái</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>

                        <tbody>
                            <c:forEach var="j" items="${list}">
                                <tr>
                                    <td>${j.jobId}</td>
                                    <td>${j.title}</td>
                                    <td>${j.salaryMin} </td>
                                    <td> ${j.salaryMax}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${j.status == 'PUBLISHED'}">
                                                <span style="color: green;">${j.status}</span>
                                            </c:when>
                                            <c:when test="${j.status == 'DRAFT'}">
                                                <span style="color: gray;">${j.status}</span>
                                            </c:when>
                                            <c:when test="${j.status == 'CLOSED'}">
                                                <span style="color: red;">${j.status}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: orange;">${j.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td>
                                        <a class="btn btn-view"
                                           href="job-detail?action=view&id=${j.jobId}">
                                            Chi tiết
                                        </a>

                                        <a class="btn btn-view"
                                           href="#"
                                           onclick="openEditModal(
                                                           '${j.jobId}',
                                                           '${j.title}',
                                                           '${j.salaryMin}',
                                                           '${j.salaryMax}'
                                                           )">
                                            Sửa
                                        </a>

                                        <a class="btn btn-delete"
                                           href="jobmanager?action=delete&id=${j.jobId}"
                                           onclick="return confirm('Bạn có chắc chắn muốn Đóng Job này?')">
                                            Đóng
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <!-- PAGING -->
                    <div style="text-align:center; margin-top:20px;">

                        <c:if test="${currentPage > 1}">
                            <a class="btn btn-view"
                               href="jobmanager?page=${currentPage - 1}">
                                ← Trước
                            </a>
                        </c:if>

                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <a class="btn"
                               style="${i == currentPage ? 'background:#4ade80;color:black' : ''}"
                               href="jobmanager?page=${i}">
                                ${i}
                            </a>
                        </c:forEach>

                        <c:if test="${currentPage < totalPages}">
                            <a class="btn btn-view"
                               href="jobmanager?page=${currentPage + 1}">
                                Tiếp →
                            </a>
                        </c:if>

                    </div>
                </div>

                <!-- MODAL -->
                <div id="jobModal" class="modal-overlay" style="display:none;">
                    <div class="modal-box">

                        <h2 id="modalTitle">➕ Tạo Job</h2>

                        <form action="${pageContext.request.contextPath}/jobmanager"
                              method="post"
                              id="jobForm">

                            <input type="hidden" name="jobId" id="jobId">

                            <div class="form-group">
                                <label>Title</label>
                                <input type="text" name="title" id="title" required>
                            </div>

                            <div class="form-group">
                                <label>Salary Min</label>
                                <input type="number" name="salaryMin" id="salaryMin">
                            </div>

                            <div class="form-group">
                                <label>Salary Max</label>
                                <input type="number" name="salaryMax" id="salaryMax">
                            </div>

                            <div style="text-align:center; margin-top:15px;">
                                <button type="submit" class="btn btn-create">💾 Lưu</button>
                                <button type="button" class="btn btn-delete" onclick="closeModal()">Thoát</button>
                            </div>

                        </form>
                    </div>
                </div>

                <div style="margin-top:20px;">
                    <a href="AdminServlet">← Quay lại Dashboard</a>
                </div>

            </div>
        </main>

        <script>
            const modal = document.getElementById("jobModal");
            const form = document.getElementById("jobForm");

            function openModal() {
                modal.style.display = "flex";
                document.getElementById("modalTitle").innerText = "➕ Create Job";
                form.reset();
            }

            function closeModal() {
                modal.style.display = "none";
            }

            function openEditModal(id, title, min, max) {
                modal.style.display = "flex";
                document.getElementById("modalTitle").innerText = "✏️ Edit Job";

                document.getElementById("jobId").value = id;
                document.getElementById("title").value = title;
                document.getElementById("salaryMin").value = min;
                document.getElementById("salaryMax").value = max;
            }
        </script>

    </body>
</html>
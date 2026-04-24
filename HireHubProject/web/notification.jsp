<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Notification Management</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>
        .page-title {
            text-align: center;
            font-size: 26px;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            color: white;
        }

        th, td {
            padding: 12px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            text-align: center;
        }

        tr:hover {
            background: rgba(255,255,255,0.05);
        }

        .btn-read {
            background: #22c55e;
            color: white;
        }

        .btn-create {
            margin-bottom: 15px;
        }

        .unread {
            font-weight: bold;
            color: #facc15;
        }

        /* modal */
        .modal-overlay {
            position: fixed;
            inset: 0;
            display: none;
            justify-content: center;
            align-items: center;
            background: rgba(0,0,0,0.6);
            z-index: 999;
        }

        .modal-box {
            width: 400px;
            background: #1e1e2f;
            padding: 20px;
            border-radius: 12px;
        }

        textarea, input, select {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
            border-radius: 8px;
            border: 1px solid #333;
            background: #111;
            color: white;
        }
    </style>
</head>

<body class="app-page">

<jsp:include page="/WEB-INF/views/header.jsp" />

<main class="main-content">
<div class="container">

    <div class="page-title">🔔 Quản lý Thông báo</div>

    <!-- BUTTON -->
    <button class="btn btn-primary btn-create" onclick="openModal()">➕ Tạo thông báo</button>

    <!-- TABLE -->
    <div class="glass-card table-container">

        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Tiêu đề</th>
                    <th>Nội dung</th>
                    <th>Trạng thái</th>
                    <th>Hành động</th>
                </tr>
            </thead>

            <tbody>
                <c:forEach var="n" items="${list}">
                    <tr>
                        <td>${n.notificationId}</td>
                        <td>${n.title}</td>
                        <td>${n.content}</td>

                        <td>
                            <span class="${n.isRead ? '' : 'unread'}">
                                ${n.isRead ? 'Đã đọc' : 'Chưa đọc'}
                            </span>
                        </td>

                        <td>
                            <c:if test="${!n.isRead}">
                                <form action="notification" method="post">
                                    <input type="hidden" name="action" value="read"/>
                                    <input type="hidden" name="id" value="${n.notificationRecipientId}"/>
                                    <button class="btn btn-read">✔ Đọc</button>
                                </form>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>

        </table>
    </div>

</div>
</main>

<!-- ================= MODAL ================= -->
<div id="modal" class="modal-overlay" onclick="closeModal()">

    <div class="modal-box" onclick="event.stopPropagation()">

        <h3 style="text-align:center;">Tạo thông báo</h3>

        <form id="notiForm" action="notification" method="post">

            <input type="hidden" name="action" value="create">

            <div>
                <label>Tiêu đề</label>
                <input type="text" name="title" required>
            </div>

            <div>
                <label>Nội dung</label>
                <textarea name="content" required></textarea>
            </div>

            <div>
                <label>Gửi tới</label>
                <select name="role">
                    <option value="USER">User</option>
                    <option value="RECRUITER">Recruiter</option>
                    <option value="ADMIN">Admin</option>
                </select>
            </div>

            <div style="text-align:center; margin-top:15px;">
                <button class="btn btn-primary">🚀 Gửi</button>
                <button type="button" class="btn btn-outline" onclick="closeModal()">Huỷ</button>
            </div>

        </form>

    </div>
</div>

<script>
    function openModal() {
        document.getElementById("modal").style.display = "flex";
    }

    function closeModal() {
        document.getElementById("modal").style.display = "none";
    }
</script>

</body>
</html>
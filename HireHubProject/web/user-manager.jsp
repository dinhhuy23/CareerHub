<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Admin - User Management</title>

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
                vertical-align: middle;
            }
            .modal-overlay {
                position: fixed; /* 👈 QUAN TRỌNG */
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;

                display: flex;
                justify-content: center;  /* 👈 căn ngang */
                align-items: center;      /* 👈 căn dọc */

                background: rgba(0,0,0,0.5); /* nền mờ */
                z-index: 9999;
            }

            .modal-box {
                background: #1e1e2f;
                padding: 25px;
                border-radius: 16px;
                width: 400px;
                color: white;
            }
            .error-text{
                color:#ff6b6b;
                font-size:12px;
                display:block;
                margin-top:4px;
            }

            .input-error{
                border:1px solid #ff6b6b !important;
            }

            .input-success{
                border:1px solid #22c55e !important;
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

            .search-box button:hover{
                opacity:0.9;
            }
            .status-filter{
                padding:10px 14px;
                border-radius:10px;
                border:none;
                outline:none;

                background: rgba(255,255,255,0.08);
                color:white;

                cursor:pointer;
                min-width:180px;

                transition: 0.2s ease;
            }

            .status-filter:hover{
                background: rgba(255,255,255,0.12);
            }

            .status-filter option{
                color:black; /* option dropdown vẫn dễ đọc */
            }


        </style>
    </head>

    <body class="app-page">

        <jsp:include page="/WEB-INF/views/header.jsp" />

        <main class="main-content">
            <div class="container">

                <div class="page-title">👤 Quản lý người dùng</div>
                <form action="usermanager" method="get" class="search-box">

                    <input type="text"
                           name="keyword"
                           placeholder="🔍 Tìm theo tên..."
                           value="${keyword}" />

                    <!-- STATUS FILTER -->
                    <select name="status" class="status-filter">
                        <option value="">🔎 Tất cả trạng thái</option>
                        <option value="ACTIVE" ${status == 'ACTIVE' ? 'selected' : ''}>🟢 Active</option>
                        <option value="INACTIVE" ${status == 'INACTIVE' ? 'selected' : ''}>🔴 Inactive</option>
                    </select>

                    <button class="btn btn-view" type="submit">Tìm</button>
                </form>
                <!-- CREATE BUTTON -->
                <div class="action-top">
                    <button class="btn btn-create" onclick="openModal()">➕ Tạo User</button>
                </div>

                <!-- TABLE -->
                <div class="glass-card table-container">

                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tên</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th>Giới tính</th>
                                <th>Trạng thái</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>

                        <tbody>
                            <c:forEach var="u" items="${list}">
                                <tr>
                                    <td>${u.userId}</td>
                                    <td>${u.fullName}</td>
                                    <td>${u.email}</td>
                                    <td>${u.phoneNumber}</td>
                                    <td>${u.gender}</td>

                                    <td>
                                        <span class="status-badge
                                              ${u.status == 'ACTIVE' ? 'status-active' : 'status-inactive'}">
                                            ${u.status}
                                        </span>
                                    </td>

                                    <td>
                                        <a class="btn btn-view"
                                           href="usermanager?action=view&id=${u.userId}">
                                            Chi tiết
                                        </a>

                                        <a class="btn btn-view"
                                           href="#"
                                           onclick="openEditModal(
                                                           '${u.userId}',
                                                           '${u.email}',
                                                           '${u.fullName}',
                                                           '${u.phoneNumber}',
                                                           '${u.gender}'
                                                           )">
                                            Sửa
                                        </a>

                                        <!--                                        <a class="btn btn-delete"
                                                                                   href="usermanager?action=delete&id=${u.userId}"
                                                                                   onclick="return confirm('Bạn có chắc chắn muốn ban tài khoản này ?')">
                                                                                    Chặn
                                                                                </a>-->
                                        <!--                                        <button class="btn btn-delete"
                                                                                        onclick="return confirm('Xác nhận khóa tài khoản?')">
                                                                                    Chặn
                                                                                </button>-->
                                        <button class="btn btn-delete" onclick="return askReason(${u.userId})">Chặn</button
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>

                    </table>
                    <div style="text-align:center; margin-top:20px;">

                        <c:if test="${currentPage > 1}">

                            <c:url value="usermanager" var="prevUrl">
                                <c:param name="page" value="${currentPage - 1}" />
                                <c:param name="keyword" value="${keyword}" />
                                <c:param name="status" value="${status}" />
                            </c:url>

                            <a class="btn btn-view" href="${prevUrl}">
                                ← Trước đó
                            </a>
                        </c:if>


                        <c:forEach begin="1" end="${totalPages}" var="i">

                            <c:url value="usermanager" var="pageUrl">
                                <c:param name="page" value="${i}" />
                                <c:param name="keyword" value="${keyword}" />
                                <c:param name="status" value="${status}" />
                            </c:url>

                            <a class="btn"
                               style="${i == currentPage ? 'background:#4ade80;color:black' : ''}"
                               href="${pageUrl}">
                                ${i}
                            </a>

                        </c:forEach>


                        <c:if test="${currentPage < totalPages}">

                            <c:url value="usermanager" var="nextUrl">
                                <c:param name="page" value="${currentPage + 1}" />
                                <c:param name="keyword" value="${keyword}" />
                                <c:param name="status" value="${status}" />
                            </c:url>

                            <a class="btn btn-view" href="${nextUrl}">
                                Tiếp →
                            </a>
                        </c:if>

                    </div>
                </div>
                <div id="userModal" class="modal-overlay" style="display:none;">
                    <div class="modal-box">

                        <h2 id="modalTitle">➕ Create User</h2>
                        <c:if test="${not empty error}">
                            <div style="color:red; margin-bottom:10px;">
                                ${error}
                            </div>
                        </c:if>
                        <form action="${pageContext.request.contextPath}/usermanager" method="post"id="userForm">

                            <input type="hidden" name="userId" id="userId">
                            <input type="hidden" name="action" id="formAction" value="create">

                            <div class="form-group">
                                <label>Email</label>
                                <input type="text" name="email" id="email" required>
                                <span id="emailError" class="error-text"></span>
                            </div>

                            <div class="form-group">
                                <label>Tên</label>
                                <input type="text" name="fullName" id="fullName" required>
                            </div>

                            <div class="form-group">
                                <label>Mật khẩu</label>
                                <input type="password" name="password" id="password">
                            </div>

                            <div class="form-group">
                                <label>SĐT</label>
                                <input type="text" name="phone" id="phone">
                                <span id="phoneError" class="error-text"></span>
                            </div>

                            <div class="form-group">
                                <label>Giới tính</label>
                                <select name="gender" id="genderValue">
                                    <option value="Nam">Nam</option>
                                    <option value="Nữ">Nữ</option>
                                    <option value="Khác">Khác</option>
                                </select>
                            </div>

                            <div style="text-align:center; margin-top:15px;">
                                <button type="submit" class="btn btn-create">💾 Lưu</button>
                                <button type="button" class="btn btn-delete" onclick="closeModal()">Thoát</button>
                            </div>

                        </form>
                    </div>
                </div>
                <!-- BACK -->
                <div style="margin-top:20px; text-align:center;">
                    <a href="admin" class="btn btn-view">
                        ← Quay lại Dashboard
                    </a>
                </div>

            </div>
        </main>

        <!-- MODAL -->


        <script>
            function askReason(userId) {
                let reason = prompt("Nhập lý do khóa:");
                if (!reason)
                    return false;

                window.location = "usermanager?action=delete&id=" + userId + "&reason=" + encodeURIComponent(reason);
            }
            function openModal() {
                document.getElementById("userModal").style.display = "flex";
                document.getElementById("formAction").value = "create";
                document.getElementById("modalTitle").innerText = "➕ Create User";
                document.querySelector("form").reset();
            }

            function closeModal() {
                document.getElementById("userModal").style.display = "none";
            }

            function openEditModal(id, email, name, phone, gender) {
                document.getElementById("userModal").style.display = "flex";

                document.getElementById("modalTitle").innerText = "✏️ Edit User";
                document.getElementById("formAction").value = "update";

                document.getElementById("userId").value = id;
                document.getElementById("email").value = email;
                document.getElementById("fullName").value = name;
                document.getElementById("phone").value = phone;
                document.getElementById("genderValue").value = gender;
            }
            const form = document.getElementById("userForm");

            const phoneInput = document.getElementById("phone");
            const phoneError = document.getElementById("phoneError");

            const emailInput = document.getElementById("email");
            const emailError = document.getElementById("emailError");

            form.addEventListener("submit", function (e) {

                let isValid = true;

                // ===== PHONE =====
                const phone = phoneInput.value.trim();
                const phoneRegex = /^0\d{9,10}$/;

                if (!phoneRegex.test(phone)) {
                    phoneError.innerText = "SĐT không hợp lệ";
                    phoneInput.classList.add("input-error");
                    isValid = false;
                } else {
                    phoneError.innerText = "";
                    phoneInput.classList.remove("input-error");
                }

                // ===== EMAIL =====
                const email = emailInput.value.trim();
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

                if (!emailRegex.test(email)) {
                    emailError.innerText = "Email không hợp lệ (phải có @)";
                    emailInput.classList.add("input-error");
                    isValid = false;
                } else {
                    emailError.innerText = "";
                    emailInput.classList.remove("input-error");
                }

                // ===== BLOCK SUBMIT =====
                if (!isValid) {
                    e.preventDefault();
                }
            });

        </script>

    </body>
</html>

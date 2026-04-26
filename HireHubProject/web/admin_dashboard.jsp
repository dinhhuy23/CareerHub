<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard - HireHub</title>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    </head>
    <style>
        textarea {
            width: 100%;
            padding: 12px;
            border-radius: 10px;
            border: 1px solid var(--border-color);
            background: var(--bg-input);
            color: black;
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
    </style>
    <body class="app-page">

        <!-- Header -->
        <jsp:include page="/WEB-INF/views/header.jsp" />

        <main class="main-content">
            <div class="container">

                <!-- Welcome -->
                <div class="welcome-section">
                    <h1>Xin chào, 
                        <span class="text-gradient">${sessionScope.userFullName}</span> 👋
                    </h1>
                    <p>Quản lý hệ thống HireHub</p>
                </div>
                <c:if test="${param.success == 1}">
                    <div class="alert success">✅ Gửi thông báo thành công!</div>
                </c:if>
                <!-- Stats -->
                <div class="stats-grid">

                    <div class="stat-card glass-card">
                        <h3>Tổng người dùng</h3>
                        <p class="stat-value">${totalUsers}</p>
                        <a href="usermanager" class="btn btn-primary">Quản lý User</a>
                    </div>

                    <div class="stat-card glass-card">
                        <h3>Tổng công việc</h3>
                        <p class="stat-value">${totalJobs}</p>
                        <a href="jobmanager" class="btn btn-primary">Quản lý Job</a>
                    </div>
                    <div class="stat-card glass-card">
                        <h3>Quản lí nhà tuyển dụng</h3>
                        <a href="/HireHubProject/admin/recruiters" class="btn btn-primary">Xem</a>
                    </div>  
                    <div class="stat-card glass-card">
                        <h3>Quản   lí   Công  ty     </h3>
                        <a href="company" class="btn btn-primary">Xem</a>
                    </div>
                    <div class="stat-card glass-card">
                        <h3>Quản lí CV        </h3>
                        <a href="/user/cv/manage_cv" class="btn btn-primary">Xem</a>
                    </div>
                    <div class="stat-card glass-card">
                        <h3>Quản lí Recruiters     </h3>
                        <a href="/admin/recruiters" class="btn btn-primary">Xem</a>
                    </div>
                </div>
                <div class="section-header">
                <h2>Thông Báo</h2>
            </div>

            <div class="actions-grid">

                <a href="notification?view=sent" class="action-card glass-card">
                    <h3>Thông báo</h3>
                    <p>Tất cả thông báo đã gửi</p>
                </a>

                <div class="action-card glass-card" onclick="openNotiModal()">
                    <h3>➕ Tạo Thông báo</h3>
                    <p>Gửi thông báo tới người dùng</p>
                </div>
                <div class="stat-card glass-card">
                    <div class="card-icon">🚨</div>
                    <h3>Reports</h3>
                    <p class="stat-value">${totalReports}</p>
                    <a href="report" class="btn btn-primary">Xem Reports</a>
                </div>
            </div>        
            </div>

            <!-- Quick Actions -->
            

            <!-- Activity -->
            <div class="section-header">
                <h2>Hoạt động gần đây</h2>
            </div>

            <div class="token-card glass-card">
                <p>✔ Admin đã đăng nhập</p>
                <p>✔ Hệ thống hoạt động bình thường</p>
                <p>✔ Có thể quản lý user & job</p>
            </div>

        </div>
    </main>
    <!-- 🔔 Notification Modal -->
    <div id="notiModal" class="modal-overlay" style="display:none;" onclick="closeNotiModal()">

        <div class="modal-box" onclick="event.stopPropagation()">

            <h2 style="text-align:center; margin-bottom:15px;">🔔 Tạo Thông báo</h2>

            <form id="notiForm" action="notification" method="post">

                <input type="hidden" name="action" value="create">

                <div class="form-group">
                    <label>Tiêu đề</label>
                    <input type="text" name="title" class="form-input" required minlength="3">
                </div>

                <div class="form-group">
                    <label>Nội dung</label>
                    <textarea name="content" rows="4" class="form-input" required></textarea>
                </div>

                <div class="form-group">
                    <label>Gửi tới</label>
                    <select name="role" class="form-input">
                        <option value="ALL">🌍 Tất cả hệ thống</option>
                        <option value="USER">User</option>
                        <option value="RECRUITER">Recruiter</option>
                        <option value="null">riêng</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Hoặc gửi riêng userId</label>
                    <input type="number" name="userId" class="form-input" placeholder="Nhập userId (nếu muốn gửi riêng)">
                </div>

                <div style="text-align:center; margin-top:15px;">
                    <button type="submit" class="btn btn-primary">🚀 Gửi</button>
                    <button type="button" class="btn btn-outline" onclick="closeNotiModal()">Huỷ</button>
                </div>

            </form>

        </div>
    </div>             
</body>
<script>
    function openNotiModal() {
        document.getElementById("notiModal").style.display = "flex";
    }

    function closeNotiModal() {
        document.getElementById("notiModal").style.display = "none";
    }
    document.getElementById("notiForm").addEventListener("submit", function () {
        closeNotiModal();
    });
</script>
</html>
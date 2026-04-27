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

        /* Admin Styles */
        .admin-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
            margin-top: 30px;
        }
        @media (max-width: 992px) { .admin-grid { grid-template-columns: 1fr; } }

        .data-list {
            margin-top: 15px;
        }
        .data-item {
            display: flex;
            justify-content: space-between;
            padding: 12px;
            border-bottom: 1px solid var(--border-color);
            font-size: 0.9rem;
        }
        .data-item:last-child { border-bottom: none; }

        .tag {
            padding: 2px 8px;
            border-radius: 4px;
            font-size: 0.7rem;
            font-weight: 700;
            text-transform: uppercase;
        }
        .tag.blue { background: rgba(59, 130, 246, 0.1); color: #3B82F6; }
        .tag.green { background: rgba(16, 185, 129, 0.1); color: #10B981; }
        .tag.red { background: rgba(239, 68, 68, 0.1); color: #EF4444; }

        .stat-detail {
            font-size: 0.8rem;
            color: var(--text-muted);
            margin-top: 8px;
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
                        <div style="display: flex; justify-content: space-between;">
                            <h3>Người dùng</h3>
                            <div class="card-icon">👥</div>
                        </div>
                        <p class="stat-value">${totalUsers}</p>
                        <div class="stat-detail">
                            <span style="color: #10B981;">${candidateCount}</span> Ứng viên | 
                            <span style="color: #6366F1;">${recruiterCount}</span> Tuyển dụng
                        </div>
                        <a href="usermanager" class="btn btn-outline" style="margin-top: 15px; width: 100%;">Quản trị User</a>
                    </div>

                    <div class="stat-card glass-card">
                        <div style="display: flex; justify-content: space-between;">
                            <h3>Tin tuyển dụng</h3>
                            <div class="card-icon">💼</div>
                        </div>
                        <p class="stat-value">${totalJobs}</p>
                        <div class="stat-detail">Tổng số tin đăng trên toàn hệ thống</div>
                        <a href="jobmanager" class="btn btn-outline" style="margin-top: 15px; width: 100%;">Quản trị Job</a>
                    </div>

                    <div class="stat-card glass-card">
                        <div style="display: flex; justify-content: space-between;">
                            <h3>Báo cáo (Reports)</h3>
                            <div class="card-icon">🚨</div>
                        </div>
                        <p class="stat-value">${totalReports}</p>
                        <div class="stat-detail">Yêu cầu hỗ trợ & phản hồi</div>
                        <a href="report" class="btn btn-outline" style="margin-top: 15px; width: 100%;">Xử lý Reports</a>
                    </div>    
                </div>

                <!-- Quick Actions -->
                <div class="section-header">
                    <h2>Thao tác nhanh</h2>
                </div>

                <div class="actions-grid">

                    <a href="${pageContext.request.contextPath}/usermanager" class="action-card glass-card">
                        <h3>➕ Tạo User</h3>
                        <p>Thêm người dùng mới</p>
                    </a>

                    <a href="${pageContext.request.contextPath}/jobmanager" class="action-card glass-card">
                        <h3>➕ Tạo Job</h3>
                        <p>Thêm công việc mới</p>
                    </a>
                    <div class="action-card glass-card" onclick="openNotiModal()">
                        <h3>➕ Tạo Thông báo</h3>
                        <p>Gửi thông báo tới người dùng</p>
                    </div>
                </div>

                <!-- Activity Grid -->
                <div class="admin-grid">
                    <!-- Left: Recent Users -->
                    <div class="glass-card">
                        <h2 style="font-size: 1.1rem; font-weight: 700; margin-bottom: 15px;">Người dùng mới nhất</h2>
                        <div class="data-list">
                            <c:forEach var="user" items="${recentUsers}">
                                <div class="data-item">
                                    <div>
                                        <div style="font-weight: 600;">${user.fullName}</div>
                                        <div style="font-size: 0.75rem; color: var(--text-muted);">${user.email}</div>
                                    </div>
                                    <span class="tag ${user.role == 'CANDIDATE' ? 'green' : 'blue'}">${user.role}</span>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- Right: Recent Jobs -->
                    <div class="glass-card">
                        <h2 style="font-size: 1.1rem; font-weight: 700; margin-bottom: 15px;">Tin đăng mới nhất</h2>
                        <div class="data-list">
                            <c:forEach var="job" items="${recentJobs}">
                                <div class="data-item">
                                    <div style="max-width: 70%;">
                                        <div style="font-weight: 600; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">${job.title}</div>
                                        <div style="font-size: 0.75rem; color: var(--text-muted);">${job.companyName}</div>
                                    </div>
                                    <span class="tag ${job.status == 'PUBLISHED' ? 'blue' : 'red'}">${job.status}</span>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <!-- System Health -->
                <div class="section-header" style="margin-top: 40px;">
                    <h2>Trạng thái hệ thống</h2>
                </div>

                <div class="token-card glass-card" style="border-left: 4px solid #10B981;">
                    <div style="display: flex; gap: 20px;">
                        <div style="color: #10B981; font-weight: 800;">ONLINE</div>
                        <div>
                            <p>✔ Server: Tomcat 10.1 - Hoạt động bình thường</p>
                            <p>✔ Database: SQL Server - Kết nối ổn định</p>
                            <p>✔ Storage: Cloudinary/Local - Sẵn sàng</p>
                        </div>
                    </div>
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
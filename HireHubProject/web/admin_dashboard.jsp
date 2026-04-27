<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard - HireHub</title>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

        <style>
            textarea {
                width: 100%;
                padding: 12px;
                border-radius: 10px;
                border: 1px solid var(--border-color);
                background: var(--bg-input);
            }

            .modal-overlay {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                display: flex;
                justify-content: center;
                align-items: center;
                background: rgba(0,0,0,0.5);
                z-index: 9999;
            }

            .modal-box {
                background: #1e1e2f;
                padding: 25px;
                border-radius: 16px;
                width: 400px;
                color: white;
            }

            /* ===== TABLE ===== */
            .table-container {
                padding: 20px;
            }

            .table-container table {
                width: 100%;
                border-collapse: collapse;
            }

            .table-container thead {
                background: rgba(255,255,255,0.05);
            }

            .table-container th {
                padding: 14px;
                color: #94a3b8;
                font-size: 13px;
                text-transform: uppercase;
            }

            .table-container td {
                padding: 14px;
                border-top: 1px solid rgba(255,255,255,0.05);
                color: white;
            }

            .table-container tr:hover {
                background: rgba(99,102,241,0.1);
            }

            .user-avatar {
                width: 36px;
                height: 36px;
                border-radius: 50%;
                background: linear-gradient(135deg,#6366f1,#8b5cf6);
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-weight: bold;
            }

            .status-badge {
                padding: 6px 12px;
                border-radius: 999px;
                font-size: 12px;
            }

            .status-active {
                background: rgba(34,197,94,0.2);
                color: #22c55e;
            }

            .status-inactive {
                background: rgba(239,68,68,0.2);
                color: #ef4444;
            }
            .table-container {
                margin: 20px auto;   /* 👈 căn giữa ngang */
                width: 95%;          /* 👈 tránh dính sát viền */
            }

            table {
                width: 100%;
                table-layout: fixed; /* 👈 BẮT BUỘC */
            }

            th, td {
                text-align: center;
                vertical-align: middle;
            }
        </style>
    </head>

    <body class="app-page">

        <jsp:include page="/WEB-INF/views/header.jsp" />

        <main class="main-content">
            <div class="container">

                <!-- ===== WELCOME ===== -->
                <div class="welcome-section">
                    <h1>Xin chào 
                        <span class="text-gradient">${sessionScope.userFullName}</span> 👋
                    </h1>
                    <p>Quản lý hệ thống HireHub</p>
                </div>
                <c:if test="${param.success == 1}">
                    <div class="alert success">✅ Gửi thông báo thành công!</div>
                </c:if>
                <!-- ===== STATS ===== -->
                <div class="stats-grid">

                    <div class="stat-card glass-card">
                        <h3>Tổng người dùng</h3>
                        <p class="stat-value">${totalUsers}</p>
                        <a href="usermanager" class="btn btn-primary">Quản lý</a>
                    </div>

                    <div class="stat-card glass-card">
                        <h3>Tổng công việc</h3>
                        <p class="stat-value">${totalJobs}</p>
                        <a href="jobmanager" class="btn btn-primary">Quản lý</a>
                    </div>

                    <div class="stat-card glass-card">
                        <h3>Reports</h3>
                        <p class="stat-value">${totalReports}</p>
                        <a href="report" class="btn btn-primary">Xem</a>
                    </div>

                    <div class="stat-card glass-card">
                        <h3>Quản lí Công ty</h3>
                        <p class="stat-value">${totalCompany}</p>
                        <a href="company" class="btn btn-primary">Xem</a>
                    </div>
                    <div class="stat-card glass-card">
                        <h3>Quản lí nhà tuyển dụng</h3>
                        <p class="stat-value">${totalRecruter}</p>
                        <a href="/HireHubProject/admin/recruiters" class="btn btn-primary">Xem</a>
                    </div>
                    <div class="stat-card glass-card">
                        <h3>Quản lí phòng ban</h3>
                        <p class="stat-value">${totalDepartment}</p>
                        <a href="/HireHubProject/admin/departments" class="btn btn-primary">Xem</a>
                    </div>

                </div>

                <!-- ===== USER LIST ===== -->
                <div class="section-header">
                    <h2>👥 Người dùng mới</h2>
                </div>

                <div class="glass-card table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Người dùng</th>
                                <th>Phone</th>
                                <th>Giới tính</th>
                                <th>Trạng thái</th>
                                <th></th>
                            </tr>
                        </thead>

                        <tbody>
                            <c:forEach var="u" items="${listuser}">
                                <tr>
                                    <td>#${u.userId}</td>

                                    <td style="display:flex; gap:10px; align-items:center;">
                                        <div class="user-avatar">
                                            ${u.fullName.substring(0,1)}
                                        </div>
                                        <div>
                                            <div style="font-weight:600">${u.fullName}</div>
                                            <div style="font-size:12px; color:#94a3b8">${u.email}</div>
                                        </div>
                                    </td>

                                    <td>${u.phoneNumber}</td>
                                    <td>${u.gender}</td>

                                    <td>
                                        <span class="status-badge
                                              ${u.status == 'ACTIVE' ? 'status-active' : 'status-inactive'}">
                                            ${u.status}
                                        </span>
                                    </td>

                                    <td>
                                        <a href="usermanager?action=view&id=${u.userId}" 
                                           class="btn btn-outline" 
                                           style="font-size:12px;">
                                            Xem
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty listuser}">
                                <tr>
                                    <td colspan="6" style="text-align:center;">
                                        Không có dữ liệu
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
                <div class="section-header">
                    <h2>💼 Job mới</h2>
                </div>

                <div class="glass-card table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Job</th>
                                <th>Lương</th>
                                <th>Trạng thái</th>
                                <th></th>
                            </tr>
                        </thead>

                        <tbody>
                            <c:forEach var="j" items="${listJob}">
                                <tr>
                                    <td>#${j.jobId}</td>

                                    <!-- JOB -->
                                    <td>
                                        <div class="job-cell">
                                            <div class="job-title">${j.title}</div>
                                        </div>
                                    </td>

                                    <!-- SALARY -->
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty j.salaryMin}">
                                                ${j.salaryMin} - ${j.salaryMax}
                                            </c:when>
                                            <c:otherwise>Thoả thuận</c:otherwise>
                                        </c:choose>
                                    </td>

                                    <!-- STATUS -->
                                    <td>
                                        <span class="status-badge
                                              ${j.status == 'PUBLISHED' ? 'status-active' : 
                                                j.status == 'DRAFT' ? 'status-draft' : 
                                                j.status == 'CLOSED' ? 'status-inactive' : ''}">
                                                  ${j.status}
                                              </span>
                                        </td>

                                        <!-- ACTION -->
                                        <td>
                                            <a href="jobmanager?action=view&id=${j.jobId}" 
                                               class="btn btn-outline" 
                                               style="font-size:12px;">
                                                Xem
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>

                                <c:if test="${empty listJob}">
                                    <tr>
                                        <td colspan="5" style="text-align:center;">
                                            Không có job
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>

                    <!-- ===== ACTION ===== -->
                    <div class="section-header">
                        <h2>🔔 Thông báo</h2>
                    </div>

                    <div class="actions-grid">
                        <a href="notification?view=sent" class="action-card glass-card">
                            <h3>Thông báo</h3>
                            <p>Danh sách thông báo</p>
                        </a>

                        <div class="action-card glass-card" onclick="openNotiModal()">
                            <h3>➕ Tạo thông báo</h3>
                            <p>Gửi cho user</p>
                        </div>
                    </div>

                </div>
            </main>

            <!-- ===== MODAL ===== -->
            <div id="notiModal" class="modal-overlay" style="display:none;" onclick="closeNotiModal()">
                <div class="modal-box" onclick="event.stopPropagation()">

                    <h2>🔔 Tạo thông báo</h2>

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

            <script>
                function openNotiModal() {
                    document.getElementById("notiModal").style.display = "flex";
                }

                function closeNotiModal() {
                    document.getElementById("notiModal").style.display = "none";
                }
            </script>

        </body>
    </html>

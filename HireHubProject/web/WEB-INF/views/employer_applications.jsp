<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý ứng viên - HireHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* Bảng danh sách ứng viên */
        .app-table {
            width: 100%;
            border-collapse: collapse;
        }
        .app-table th {
            padding: 14px 20px;
            text-align: left;
            font-size: 0.8rem;
            font-weight: 700;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            background: var(--bg-primary);
            border-bottom: 1px solid var(--border-color);
        }
        .app-table td {
            padding: 16px 20px;
            border-bottom: 1px solid var(--border-color);
            vertical-align: middle;
        }
        .app-table tr:hover td { background: var(--bg-primary); }
        .app-table tr:last-child td { border-bottom: none; }

        /* Badge trạng thái */
        .badge {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.78rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }
        .badge-PENDING    { background: rgba(245,158,11,0.15); color: #F59E0B; }
        .badge-REVIEWING  { background: rgba(99,102,241,0.15); color: #6366F1; }
        .badge-INTERVIEWING { background: rgba(6,182,212,0.15); color: #06B6D4; }
        .badge-OFFERED    { background: rgba(16,185,129,0.15); color: #10B981; }
        .badge-REJECTED   { background: rgba(239,68,68,0.15);  color: #EF4444; }
        .badge-WITHDRAW_REQUESTED { background: rgba(245,158,11,0.15); color: #F59E0B; border: 1px dashed #F59E0B; }
        .badge-WITHDRAWN  { background: rgba(107,114,128,0.15); color: #6B7280; }

        /* Side-peek panel */
        .peek-overlay {
            position: fixed; top: 0; left: 0;
            width: 100%; height: 100%;
            background: rgba(0,0,0,0.6);
            backdrop-filter: blur(4px);
            z-index: 1500;
            display: none;
        }
        .peek-overlay.active { display: block; }

        .peek-panel {
            position: fixed;
            top: 0; right: -560px;
            width: 520px; height: 100vh;
            background: var(--bg-secondary);
            border-left: 1px solid var(--border-color);
            box-shadow: -10px 0 40px rgba(0,0,0,0.3);
            z-index: 2000;
            overflow-y: auto;
            transition: right 0.35s cubic-bezier(0.16, 1, 0.3, 1);
            padding: 32px;
        }
        .peek-panel.active { right: 0; }

        .peek-avatar {
            width: 80px; height: 80px;
            border-radius: 20px;
            display: flex; align-items: center; justify-content: center;
            font-size: 2rem; font-weight: 800; color: white;
            background: linear-gradient(135deg, #6366F1, #8B5CF6);
            margin-bottom: 20px;
        }
        .peek-section-title {
            font-size: 0.78rem;
            font-weight: 700;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 10px;
        }
    </style>
</head>
<body class="app-page">
    <jsp:include page="/WEB-INF/views/header.jsp" />

    <main class="main-content">
        <div class="container animate-fadeInUp">

            <!-- Tiêu đề -->
            <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 32px; flex-wrap: wrap; gap: 16px;">
                <div>
                    <h1 style="font-size: 2rem; font-weight: 800; color: var(--text-primary); margin-bottom: 8px;">Danh sách Ứng viên</h1>
                    <p style="color: var(--text-secondary);">Quản lý và duyệt hồ sơ các ứng viên đã nộp đơn vào vị trí của bạn.</p>
                </div>
                <div style="background: var(--bg-secondary); border: 1px solid var(--border-color); border-radius: 10px; padding: 10px 20px; font-weight: 700; color: var(--primary);">
                    Tổng: ${applications.size()} ứng viên
                </div>
            </div>

            <!-- Thông báo thành công khi cập nhật trạng thái -->
            <c:if test="${param.success eq 'updated'}">
                <div class="alert alert-success" style="margin-bottom: 20px;">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"></polyline></svg>
                    Cập nhật trạng thái ứng viên thành công!
                </div>
            </c:if>

            <!-- Trường hợp chưa có ứng viên nào -->
            <c:if test="${empty applications}">
                <div class="glass-card" style="padding: 60px; text-align: center;">
                    <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="var(--text-muted)" stroke-width="1.5" style="margin-bottom: 20px;">
                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                        <circle cx="9" cy="7" r="4"></circle>
                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                    </svg>
                    <p style="color: var(--text-secondary); font-size: 1.1rem;">Chưa có ứng viên nào nộp đơn vào các vị trí của bạn.</p>
                    <a href="${pageContext.request.contextPath}/employer/jobs" class="btn btn-primary" style="margin-top: 20px;">Xem tin đang đăng</a>
                </div>
            </c:if>

            <!-- Bảng danh sách ứng viên -->
            <c:if test="${not empty applications}">
                <div class="glass-card" style="padding: 0; overflow: hidden;">
                    <table class="app-table">
                        <thead>
                            <tr>
                                <th>Ứng viên</th>
                                <th>Vị trí ứng tuyển</th>
                                <th>Ngày nộp</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%-- Lặp qua danh sách ứng viên từ Controller --%>
                            <c:forEach var="app" items="${applications}">
                                <tr>
                                    <td>
                                        <div style="display: flex; align-items: center; gap: 12px;">
                                            <%-- Avatar chữ cái đầu --%>
                                            <div style="width: 40px; height: 40px; border-radius: 50%; background: linear-gradient(135deg, #6366F1, #8B5CF6); color: white; display: flex; align-items: center; justify-content: center; font-weight: 700; flex-shrink: 0;">
                                                ${app.candidateName != null and app.candidateName.length() > 0 ? app.candidateName.substring(0, 1).toUpperCase() : 'U'}
                                            </div>
                                            <div>
                                                <div style="font-weight: 700; color: var(--text-primary);">${app.candidateName}</div>
                                                <div style="font-size: 0.85rem; color: var(--text-muted);">${app.candidateEmail}</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <span style="font-weight: 600; color: var(--primary);">${app.jobTitle}</span>
                                    </td>
                                    <td style="color: var(--text-secondary); font-size: 0.9rem;">
                                        <fmt:formatDate value="${app.appliedAt}" pattern="dd/MM/yyyy"/>
                                    </td>
                                    <td>
                                        <span class="badge badge-${app.status}">${app.status}</span>
                                    </td>
                                    <td>
                                        <%-- Sử dụng data attributes để tránh lỗi ngoặc kép trong chuỗi --%>
                                        <button class="btn btn-outline" style="padding: 6px 14px; font-size: 0.85rem;"
                                            data-id="${app.applicationId}"
                                            data-name="${app.candidateName}"
                                            data-email="${app.candidateEmail}"
                                            data-job="${app.jobTitle}"
                                            data-status="${app.status}"
                                            data-cv="${app.cvUrl}"
                                            data-letter="${app.coverLetter}"
                                            data-hr="${app.hrNote}"
                                            onclick="openPeekUser(this)">
                                            Xem chi tiết
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:if>

        </div>
    </main>

    <!-- Overlay nền mờ -->
    <div id="peekOverlay" class="peek-overlay" onclick="closePeek()"></div>

    <!-- Bảng chi tiết ứng viên - trượt từ phải -->
    <div id="peekPanel" class="peek-panel">

        <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 24px;">
            <!-- Avatar lớn -->
            <div id="peekAvatar" class="peek-avatar">A</div>
            <!-- Nút đóng panel -->
            <button onclick="closePeek()" style="background: var(--bg-primary); border: 1px solid var(--border-color); width: 36px; height: 36px; border-radius: 50%; cursor: pointer; color: var(--text-muted); display: flex; align-items: center; justify-content: center;">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="18" y1="6" x2="6" y2="18"></line>
                    <line x1="6" y1="6" x2="18" y2="18"></line>
                </svg>
            </button>
        </div>

        <!-- Tên và email ứng viên -->
        <h2 id="peekName" style="font-size: 1.6rem; font-weight: 800; color: var(--text-primary); margin-bottom: 4px;"></h2>
        <p id="peekEmail" style="color: var(--text-muted); margin-bottom: 28px; padding-bottom: 24px; border-bottom: 1px solid var(--border-color);"></p>

        <!-- Vị trí ứng tuyển -->
        <div style="margin-bottom: 24px;">
            <div class="peek-section-title">Vị trí ứng tuyển</div>
            <div id="peekJob" style="font-size: 1.05rem; font-weight: 700; color: var(--primary);"></div>
        </div>

        <!-- Link CV -->
        <div style="margin-bottom: 24px;">
            <div class="peek-section-title">Hồ sơ / CV</div>
            <a id="peekCV" href="#" target="_blank" style="display: flex; align-items: center; gap: 12px; padding: 14px; background: var(--bg-primary); border: 1px solid var(--border-color); border-radius: 10px; text-decoration: none; color: var(--text-primary); transition: border-color 0.2s;" onmouseover="this.style.borderColor='var(--primary)'" onmouseout="this.style.borderColor='var(--border-color)'">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="var(--primary)" stroke-width="2">
                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                    <polyline points="14 2 14 8 20 8"></polyline>
                </svg>
                <span style="font-weight: 600; flex: 1;">Xem CV Online</span>
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="var(--text-muted)" stroke-width="2">
                    <path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"></path>
                    <polyline points="15 3 21 3 21 9"></polyline>
                    <line x1="10" y1="14" x2="21" y2="3"></line>
                </svg>
            </a>
        </div>

        <!-- Thư giới thiệu -->
        <div style="margin-bottom: 28px;">
            <div class="peek-section-title">Thư giới thiệu</div>
            <div id="peekLetter" style="background: var(--bg-primary); border: 1px solid var(--border-color); padding: 16px; border-radius: 10px; font-size: 0.95rem; line-height: 1.7; color: var(--text-secondary); max-height: 200px; overflow-y: auto; white-space: pre-wrap;"></div>
        </div>

        <!-- Form cập nhật trạng thái -->
        <div style="border-top: 1px solid var(--border-color); padding-top: 24px;">
            <div class="peek-section-title" style="margin-bottom: 14px;">Cập nhật trạng thái ứng viên</div>
            <form action="${pageContext.request.contextPath}/employer/application/status" method="POST">
                <%-- ID được gán tự động bằng JS khi mở panel --%>
                <input type="hidden" name="applicationId" id="peekAppId">
                <select name="status" id="peekStatusSelect" class="form-control" style="width: 100%; margin-bottom: 16px;" onchange="toggleInterviewForm(this.value)">
                    <option value="PENDING">PENDING - Chờ duyệt</option>
                    <option value="REVIEWING">REVIEWING - Đang xem xét</option>
                    <option value="INTERVIEWING">INTERVIEWING - Phỏng vấn</option>
                    <option value="OFFERED">OFFERED - Trúng tuyển</option>
                    <option value="REJECTED">REJECTED - Từ chối</option>
                    <option value="WITHDRAW_REQUESTED">WITHDRAW_REQUESTED - Yêu cầu rút đơn</option>
                    <option value="WITHDRAWN">WITHDRAWN - Đã rút (Đồng ý cho rút)</option>
                </select>

                <!-- Vùng hẹn phỏng vấn (Chỉ hiện khi chọn INTERVIEWING) -->
                <div id="interviewFormBlock" style="display: none; background: rgba(6,182,212,0.05); border: 1px dashed #06B6D4; padding: 16px; border-radius: 8px; margin-bottom: 16px;">
                    <div style="font-weight: 600; color: #06B6D4; margin-bottom: 12px;">📅 Xếp lịch phỏng vấn</div>
                    
                    <label style="font-size: 0.85rem; font-weight: 600; margin-bottom: 4px; display: block;">Ngày giờ bắt đầu</label>
                    <input type="datetime-local" name="startAt" class="form-control" style="width: 100%; margin-bottom: 12px;">

                    <label style="font-size: 0.85rem; font-weight: 600; margin-bottom: 4px; display: block;">Link Meeting (VD: Google Meet)</label>
                    <input type="url" name="meetingLink" class="form-control" placeholder="https://meet.google.com/..." style="width: 100%; margin-bottom: 12px;">

                     <label style="font-size: 0.85rem; font-weight: 600; margin-bottom: 4px; display: block;">Ghi chú gửi ứng viên</label>
                    <textarea name="interviewNote" class="form-control" rows="2" style="width: 100%; resize: none;"></textarea>
                </div>

                <div class="form-group" style="margin-bottom: 16px;">
                    <label style="font-size: 0.85rem; font-weight: 600; margin-bottom: 4px; display: block;">Ghi chú nội bộ HR</label>
                    <textarea name="hrNote" id="peekHrNote" class="form-control" rows="2" style="width: 100%; resize: none;"></textarea>
                </div>

                <button type="submit" class="btn btn-primary" style="width: 100%;">Cập nhật hồ sơ</button>
            </form>
        </div>

    </div>

    <script>
        function toggleInterviewForm(val) {
            const block = document.getElementById('interviewFormBlock');
            if (val === 'INTERVIEWING') {
                block.style.display = 'block';
            } else {
                block.style.display = 'none';
            }
        }

        // Hàm mở bảng chi tiết ứng viên (Side-peek)
        function openPeekUser(btn) {
            // Lấy dữ liệu từ data attributes
            const id = btn.getAttribute('data-id');
            const name = btn.getAttribute('data-name');
            const email = btn.getAttribute('data-email');
            const job = btn.getAttribute('data-job');
            const status = btn.getAttribute('data-status');
            const cv = btn.getAttribute('data-cv');
            const letter = btn.getAttribute('data-letter');
            const hrNote = btn.getAttribute('data-hr');

            // Gán dữ liệu của ứng viên vào các phần tử HTML trong panel
            document.getElementById('peekAppId').value = id;
            document.getElementById('peekAvatar').innerText = name ? name.charAt(0).toUpperCase() : 'U';
            document.getElementById('peekName').innerText = name;
            document.getElementById('peekEmail').innerText = email;
            document.getElementById('peekJob').innerText = job;
            document.getElementById('peekCV').href = cv && cv !== 'null' && cv !== '' ? cv : '#';
            if(!cv || cv === 'null' || cv === '') document.getElementById('peekCV').innerText = 'Không có CV đính kèm';
            else document.getElementById('peekCV').innerText = 'Xem CV Online';
            document.getElementById('peekLetter').innerText = letter && letter !== 'null' ? letter : 'Ứng viên không gửi thư giới thiệu.';
            document.getElementById('peekStatusSelect').value = status;
            document.getElementById('peekHrNote').value = hrNote && hrNote !== 'null' ? hrNote : '';
            
            toggleInterviewForm(status);

            // Mở panel và overlay
            document.getElementById('peekPanel').classList.add('active');
            document.getElementById('peekOverlay').classList.add('active');
            document.body.style.overflow = 'hidden';
        }

        // Hàm đóng panel
        function closePeek() {
            document.getElementById('peekPanel').classList.remove('active');
            document.getElementById('peekOverlay').classList.remove('active');
            document.body.style.overflow = 'auto';
        }
    </script>


</body>
</html>

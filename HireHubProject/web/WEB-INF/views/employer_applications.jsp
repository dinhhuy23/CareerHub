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

        /* Tùy chỉnh giao diện Select2 cho đẹp và khớp với thiết kế Dark Mode */
        .select2-container .select2-selection--single {
            height: 42px !important;
            border: 1px solid var(--border-color) !important;
            border-radius: 8px !important;
            display: flex;
            align-items: center;
            background-color: transparent !important;
        }
        .select2-container--default .select2-selection--single .select2-selection__rendered {
            color: var(--text-primary) !important;
            line-height: 42px !important;
            padding-left: 14px !important;
            font-weight: 500;
        }
        .select2-container--default .select2-selection--single .select2-selection__arrow {
            height: 40px !important;
            right: 8px !important;
        }
        /* Style cho Dropdown list (Phần thả xuống) */
        .select2-dropdown {
            background-color: var(--bg-secondary) !important;
            border: 1px solid var(--border-color) !important;
            border-radius: 8px !important;
            box-shadow: 0 10px 25px rgba(0,0,0,0.5) !important;
            overflow: hidden;
        }
        /* Style cho ô Search nhập text */
        .select2-search__field {
            background-color: var(--bg-primary) !important;
            color: var(--text-primary) !important;
            border-radius: 6px !important;
            padding: 8px 12px !important;
            border: 1px solid var(--border-color) !important;
            outline: none;
        }
        /* Style cho từng dòng lựa chọn */
        .select2-container--default .select2-results__option {
            background-color: var(--bg-secondary) !important;
            color: var(--text-secondary) !important;
            padding: 10px 14px !important;
        }
        /* Style khi hover hoặc chọn mục */
        .select2-container--default .select2-results__option--highlighted[aria-selected], 
        .select2-container--default .select2-results__option[aria-selected="true"] {
            background-color: rgba(99, 102, 241, 0.15) !important;
            color: #6366F1 !important; /* Màu primary */
            font-weight: 600;
        }
    </style>
</head>
<body class="app-page">
    <jsp:include page="/WEB-INF/views/header.jsp" />

    <main class="main-content">
        <div class="container animate-fadeInUp">

            <!-- Tiêu đề -->
            <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 24px; flex-wrap: wrap; gap: 16px;">
                <div>
                    <h1 style="font-size: 2rem; font-weight: 800; color: var(--text-primary); margin-bottom: 8px;">Danh sách Ứng viên</h1>
                    <p style="color: var(--text-secondary);">Quản lý và duyệt hồ sơ các ứng viên đã nộp đơn vào vị trí của bạn.</p>
                </div>
                <div style="background: var(--bg-secondary); border: 1px solid var(--border-color); border-radius: 10px; padding: 10px 20px; font-weight: 700; color: var(--primary);">
                    Tổng: ${applications.size()} ứng viên
                </div>
            </div>

            <!-- Thanh Filter -->
            <div style="margin-bottom: 32px; background: var(--bg-secondary); padding: 20px; border-radius: 16px; border: 1px solid var(--border-color); display: flex; align-items: center; gap: 16px; flex-wrap: wrap;">
                <form action="${pageContext.request.contextPath}/employer/applications" method="GET" style="display: flex; align-items: center; gap: 12px; flex: 1; flex-wrap: wrap;">
                    
                    <!-- Lọc theo Dropdown -->
                    <div style="display: flex; align-items: center; gap: 10px;">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="var(--text-muted)" stroke-width="2"><polygon points="22 3 2 3 10 12.46 10 19 14 21 14 12.46 22 3"></polygon></svg>
                        <span style="font-weight: 700; color: var(--text-secondary); font-size: 0.9rem; text-transform: uppercase; letter-spacing: 0.5px;">Bộ lọc:</span>
                    </div>
                    <select name="jobId" id="jobIdFilter" class="form-control" style="min-width: 220px; background: var(--bg-primary);" onchange="this.form.submit()">
                        <option value="">Tất cả vị trí ứng tuyển</option>
                        <c:forEach var="job" items="${jobs}">
                            <option value="${job.jobId}" ${selectedJobId == job.jobId ? 'selected' : ''}>
                                ${job.title} (${job.status})
                            </option>
                        </c:forEach>
                    </select>

                    <!-- Lọc theo Text (Từ khóa) -->
                    <div style="position: relative; flex: 1; min-width: 250px;">
                        <div style="position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: var(--text-muted);">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                        </div>
                        <input type="text" name="keyword" class="form-control" placeholder="Tìm tên ứng viên, email..." value="${searchKeyword}" style="width: 100%; padding-left: 40px; background: var(--bg-primary);">
                    </div>
                    
                    <!-- Nút Tìm kiếm -->
                    <button type="submit" class="btn btn-primary" style="padding: 10px 20px;">Tìm kiếm</button>
                    
                    <!-- Nút Xóa lọc -->
                    <c:if test="${not empty selectedJobId or not empty searchKeyword}">
                        <a href="${pageContext.request.contextPath}/employer/applications" 
                           style="color: var(--text-muted); font-size: 0.85rem; text-decoration: none; display: flex; align-items: center; gap: 4px; padding: 10px 16px; border-radius: 8px; background: var(--bg-primary); border: 1px solid var(--border-color); transition: all 0.2s;"
                           onmouseover="this.style.color='var(--primary)'; this.style.borderColor='var(--primary)'"
                           onmouseout="this.style.color='var(--text-muted)'; this.style.borderColor='var(--border-color)'">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                            Xóa lọc
                        </a>
                    </c:if>
                </form>
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
                
                <%-- Component Phân trang --%>
                <div style="padding-bottom: 24px;">
                    <jsp:include page="/WEB-INF/views/components/pagination.jsp">
                        <jsp:param name="currentPage" value="${currentPage}" />
                        <jsp:param name="totalPages" value="${totalPages}" />
                        <jsp:param name="actionUrl" value="${pageContext.request.contextPath}/employer/applications?jobId=${selectedJobId}&keyword=${searchKeyword}" />
                    </jsp:include>
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
                    <option value="INTERVIEWING">Vòng 1 - Phỏng vấn Online</option>
                    <option value="INTERVIEW_ROUND_2">Vòng 2 - Phỏng vấn Trực tiếp</option>
                    <option value="OFFERED">OFFERED - Trúng tuyển</option>
                    <option value="REJECTED">REJECTED - Từ chối</option>
                    <option value="WITHDRAW_REQUESTED">WITHDRAW_REQUESTED - Yêu cầu rút đơn</option>
                    <option value="WITHDRAWN">WITHDRAWN - Đã rút (Đồng ý cho rút)</option>
                </select>

                <div id="interviewFormBlock" style="display: none; background: rgba(6,182,212,0.05); border: 1px dashed #06B6D4; padding: 16px; border-radius: 8px; margin-bottom: 16px;">
                    <div style="font-weight: 600; color: #06B6D4; margin-bottom: 12px;">📅 Xếp lịch phỏng vấn</div>
                    
                    <label style="font-size: 0.85rem; font-weight: 600; margin-bottom: 4px; display: block;">Ngày giờ bắt đầu</label>
                    <input type="datetime-local" name="startAt" class="form-control" style="width: 100%; margin-bottom: 12px;">

                    <div id="meetingLinkField">
                        <label style="font-size: 0.85rem; font-weight: 600; margin-bottom: 4px; display: block;">Link Meeting (VD: Google Meet)</label>
                        <input type="url" name="meetingLink" class="form-control" placeholder="https://meet.google.com/..." style="width: 100%; margin-bottom: 12px;">
                    </div>

                    <div id="locationTextField" style="display: none;">
                        <label style="font-size: 0.85rem; font-weight: 600; margin-bottom: 4px; display: block;">Địa điểm phỏng vấn (Văn phòng)</label>
                        <input type="text" name="locationText" class="form-control" placeholder="Tầng 5, Tòa nhà A, Số 123..." style="width: 100%; margin-bottom: 12px;">
                    </div>

                     <label style="font-size: 0.85rem; font-weight: 600; margin-bottom: 4px; display: block;" id="noteLabel">Ghi chú gửi ứng viên</label>
                    <textarea name="interviewNote" id="interviewNoteField" class="form-control" rows="3" placeholder="Nhắc ứng viên mang theo Laptop, CCCD..." style="width: 100%; resize: none;"></textarea>
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
            const meetingField = document.getElementById('meetingLinkField');
            const locationField = document.getElementById('locationTextField');
            const noteLabel = document.getElementById('noteLabel');
            const noteField = document.getElementById('interviewNoteField');

            if (val === 'INTERVIEWING' || val === 'INTERVIEW_ROUND_2') {
                block.style.display = 'block';
                if (val === 'INTERVIEW_ROUND_2') {
                    meetingField.style.display = 'none';
                    locationField.style.display = 'block';
                    noteLabel.innerText = "Yêu cầu cho ứng viên (Cần mang theo gì?)";
                    noteField.placeholder = "Ví dụ: Mang theo laptop, trang phục lịch sự, CCCD gốc...";
                } else {
                    meetingField.style.display = 'block';
                    locationField.style.display = 'none';
                    noteLabel.innerText = "Ghi chú gửi ứng viên";
                    noteField.placeholder = "Nhắc ứng viên chuẩn bị mic, camera...";
                }
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
            // Xử lý URL CV: nếu là đường dẫn tương đối thì thêm contextPath
            const contextPath = '${pageContext.request.contextPath}';
            let cvHref = '#';
            let cvText = 'Không có CV đính kèm';
            if (cv && cv !== 'null' && cv !== '') {
                // Nếu bắt đầu bằng / thì là relative URL → thêm contextPath
                cvHref = cv.startsWith('/') ? contextPath + cv : cv;
                cvText = cv.includes('/user/cv/view') ? '📄 Xem CV Online' : '📎 Xem File CV';
            }
            document.getElementById('peekCV').href = cvHref;
            document.getElementById('peekCV').innerText = cvText;
            if (!cv || cv === 'null' || cv === '') {
                document.getElementById('peekCV').style.pointerEvents = 'none';
                document.getElementById('peekCV').style.opacity = '0.5';
            } else {
                document.getElementById('peekCV').style.pointerEvents = '';
                document.getElementById('peekCV').style.opacity = '';
            }
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

    <!-- Thư viện jQuery và Select2 để tạo Dropdown có tính năng Search -->
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
    
    <script>
        $(document).ready(function() {
            // Khởi tạo Select2 cho Dropdown Vị trí ứng tuyển
            $('#jobIdFilter').select2({
                placeholder: "Nhập text để tìm vị trí ứng tuyển...",
                allowClear: true,
                width: 'resolve'
            });

            // Khi người dùng chọn một mục, tự động submit form
            $('#jobIdFilter').on('select2:select', function (e) {
                $(this).closest('form').submit();
            });
            
            // Khi người dùng xóa chọn (nhấn dấu x), cũng submit form
            $('#jobIdFilter').on('select2:unselect', function (e) {
                $(this).closest('form').submit();
            });
        });
    </script>
</body>
</html>

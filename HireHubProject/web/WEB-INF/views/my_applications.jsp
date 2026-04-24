<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Việc làm đã ứng tuyển - HireHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* Timeline trạng thái đơn ứng tuyển */
        .app-card {
            background: var(--bg-secondary);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 24px;
            margin-bottom: 16px;
            display: flex;
            gap: 20px;
            align-items: flex-start;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .app-card:hover {
            border-color: var(--primary);
            box-shadow: 0 4px 20px rgba(99,102,241,0.1);
        }
        .company-logo {
            width: 56px; height: 56px;
            border-radius: 12px;
            background: var(--bg-tertiary);
            border: 1px solid var(--border-color);
            display: flex; align-items: center; justify-content: center;
            font-size: 1.4rem; font-weight: 800;
            color: var(--primary);
            flex-shrink: 0;
        }
        .app-info { flex: 1; min-width: 0; }
        .app-job-title {
            font-size: 1.1rem; font-weight: 700;
            color: var(--text-primary); margin-bottom: 4px;
        }
        .app-company {
            font-size: 0.9rem; color: var(--primary);
            font-weight: 600; margin-bottom: 12px;
        }
        .app-meta {
            display: flex; align-items: center; gap: 16px;
            flex-wrap: wrap;
        }
        .app-meta span {
            font-size: 0.82rem; color: var(--text-muted);
            display: flex; align-items: center; gap: 5px;
        }
        /* Badge trạng thái */
        .status-badge {
            padding: 5px 14px; border-radius: 20px;
            font-size: 0.8rem; font-weight: 700;
            text-transform: uppercase; letter-spacing: 0.3px;
        }
        .status-PENDING     { background: rgba(245,158,11,0.15);  color: #F59E0B; }
        .status-REVIEWING   { background: rgba(99,102,241,0.15);  color: #6366F1; }
        .status-INTERVIEWING{ background: rgba(6,182,212,0.15);   color: #06B6D4; }
        .status-OFFERED     { background: rgba(16,185,129,0.15);  color: #10B981; }
        .status-REJECTED    { background: rgba(239,68,68,0.15);   color: #EF4444; }
        .status-WITHDRAWN   { background: rgba(148,163,184,0.15); color: #94A3B8; }

        /* Timeline bar */
        .timeline-bar {
            display: flex; gap: 0; margin-top: 16px;
            border-radius: 8px; overflow: hidden;
            height: 6px; background: var(--bg-tertiary);
            width: 100%; max-width: 400px;
        }
        .timeline-step {
            flex: 1; height: 100%;
            background: var(--border-color);
            transition: background 0.3s;
        }
        .timeline-step.done { background: var(--primary); }
        .timeline-step.active { background: var(--accent); }
        .timeline-step.success { background: var(--success); }
        .timeline-step.error { background: var(--error); }

        .withdraw-btn {
            padding: 6px 14px; border-radius: 8px; font-size: 0.82rem;
            font-weight: 600; cursor: pointer; border: 1px solid var(--border-color);
            background: transparent; color: var(--text-muted);
            transition: all 0.2s;
        }
        .withdraw-btn:hover {
            border-color: var(--error); color: var(--error);
            background: var(--error-light);
        }
        .cv-link {
            display: inline-flex; align-items: center; gap: 6px;
            font-size: 0.82rem; color: var(--primary-light);
            font-weight: 600; text-decoration: none;
        }
        .cv-link:hover { text-decoration: underline; }
    </style>
</head>
<body class="app-page">
    <jsp:include page="/WEB-INF/views/header.jsp" />

    <main class="main-content">
        <div class="container animate-fadeInUp">

            <%-- Tiêu đề trang --%>
            <div style="margin-bottom: 32px;">
                <h1 style="font-size: 2rem; font-weight: 800; color: var(--text-primary); margin-bottom: 8px;">
                    Việc làm đã ứng tuyển
                </h1>
                <p style="color: var(--text-secondary);">
                    Theo dõi tiến trình xét duyệt hồ sơ của bạn theo thời gian thực.
                </p>
            </div>

            <%-- Thông báo thành công khi rút đơn --%>
            <c:if test="${param.success eq 'withdrawn'}">
                <div class="alert alert-success" style="margin-bottom: 20px;">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="20 6 9 17 4 12"></polyline></svg>
                    Đã rút đơn ứng tuyển thành công.
                </div>
            </c:if>
            <c:if test="${param.error eq 'cannot_withdraw'}">
                <div class="alert alert-error" style="margin-bottom: 20px;">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                    Không thể rút đơn. Chỉ rút được khi trạng thái còn là "Chờ duyệt".
                </div>
            </c:if>

            <%-- Thanh Filter --%>
            <c:if test="${not empty applications or not empty searchStatus or not empty searchKeyword}">
                <div style="background: var(--bg-secondary); padding: 20px; border-radius: 16px; border: 1px solid var(--border-color); display: flex; align-items: center; gap: 16px; flex-wrap: wrap; margin-bottom: 24px;">
                    <form action="${pageContext.request.contextPath}/user/my-applications" method="GET" style="display: flex; align-items: center; gap: 12px; flex: 1; flex-wrap: wrap; width: 100%;">
                        
                        <div style="display: flex; align-items: center; gap: 10px;">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="var(--text-muted)" stroke-width="2"><polygon points="22 3 2 3 10 12.46 10 19 14 21 14 12.46 22 3"></polygon></svg>
                            <span style="font-weight: 700; color: var(--text-secondary); font-size: 0.9rem; text-transform: uppercase; letter-spacing: 0.5px;">Bộ lọc:</span>
                        </div>

                        <!-- Lọc theo Trạng thái -->
                        <select name="status" class="form-control" style="min-width: 180px; background: var(--bg-primary);" onchange="this.form.submit()">
                            <option value="">Tất cả trạng thái</option>
                            <option value="PENDING" ${searchStatus == 'PENDING' ? 'selected' : ''}>Chờ duyệt (Pending)</option>
                            <option value="REVIEWING" ${searchStatus == 'REVIEWING' ? 'selected' : ''}>Đang xem xét (Reviewing)</option>
                            <option value="INTERVIEWING" ${searchStatus == 'INTERVIEWING' ? 'selected' : ''}>Phỏng vấn (Interviewing)</option>
                            <option value="OFFERED" ${searchStatus == 'OFFERED' ? 'selected' : ''}>Trúng tuyển (Offered)</option>
                            <option value="REJECTED" ${searchStatus == 'REJECTED' ? 'selected' : ''}>Không phù hợp (Rejected)</option>
                        </select>

                        <!-- Lọc theo Text (Từ khóa) -->
                        <div style="position: relative; flex: 1; min-width: 250px;">
                            <div style="position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: var(--text-muted);">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                            </div>
                            <input type="text" name="keyword" class="form-control" placeholder="Tìm theo công ty, công việc..." value="${searchKeyword}" style="width: 100%; padding-left: 40px; background: var(--bg-primary);">
                        </div>
                        
                        <!-- Nút Tìm kiếm -->
                        <button type="submit" class="btn btn-primary" style="padding: 10px 20px;">Tìm kiếm</button>
                        
                        <!-- Nút Xóa lọc -->
                        <c:if test="${not empty searchStatus or not empty searchKeyword}">
                            <a href="${pageContext.request.contextPath}/user/my-applications" 
                               style="color: var(--text-muted); font-size: 0.85rem; text-decoration: none; display: flex; align-items: center; gap: 4px; padding: 10px 16px; border-radius: 8px; background: var(--bg-primary); border: 1px solid var(--border-color); transition: all 0.2s;"
                               onmouseover="this.style.color='var(--primary)'; this.style.borderColor='var(--primary)'"
                               onmouseout="this.style.color='var(--text-muted)'; this.style.borderColor='var(--border-color)'">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                                Xóa lọc
                            </a>
                        </c:if>
                    </form>
                </div>
            </c:if>

            <%-- Trường hợp chưa ứng tuyển công việc nào HOẶC lọc không ra kết quả --%>
            <c:if test="${empty applications}">
                <div class="glass-card" style="padding: 80px; text-align: center;">
                    <svg width="72" height="72" viewBox="0 0 24 24" fill="none" stroke="var(--text-muted)" stroke-width="1.2" style="margin-bottom: 20px;">
                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                        <polyline points="14 2 14 8 20 8"></polyline>
                        <line x1="16" y1="13" x2="8" y2="13"></line>
                        <line x1="16" y1="17" x2="8" y2="17"></line>
                    </svg>
                    <p style="font-size: 1.2rem; font-weight: 600; color: var(--text-primary); margin-bottom: 8px;">Chưa có đơn ứng tuyển nào</p>
                    <p style="color: var(--text-secondary); margin-bottom: 24px;">Hãy khám phá các cơ hội việc làm phù hợp và nộp đơn ngay hôm nay!</p>
                    <a href="${pageContext.request.contextPath}/jobs" class="btn btn-primary">Tìm việc ngay</a>
                </div>
            </c:if>

            <%-- Danh sách đơn ứng tuyển --%>
            <c:if test="${not empty applications}">
                <%-- Thống kê nhanh --%>
                <div style="display: flex; gap: 12px; margin-bottom: 28px; flex-wrap: wrap;">
                    <div style="background: var(--bg-secondary); border: 1px solid var(--border-color); border-radius: 10px; padding: 12px 20px;">
                        <span style="font-size: 0.8rem; color: var(--text-muted); display: block;">Tổng đã nộp</span>
                        <span style="font-size: 1.4rem; font-weight: 800; color: var(--text-primary);">${applications.size()}</span>
                    </div>
                </div>

                <c:forEach var="app" items="${applications}">
                    <div class="app-card">
                        <%-- Icon công ty (chữ cái đầu) --%>
                        <div class="company-logo">
                            ${app.companyName != null and app.companyName.length() > 0 ? app.companyName.substring(0,1).toUpperCase() : 'C'}
                        </div>

                        <div class="app-info">
                            <div class="app-job-title">
                                <a href="${pageContext.request.contextPath}/job-detail?id=${app.jobId}" style="color: inherit; text-decoration: none;">
                                    ${app.jobTitle}
                                </a>
                            </div>
                            <div class="app-company">${app.companyName}</div>

                            <div class="app-meta">
                                <%-- Ngày nộp --%>
                                <span>
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                                    Nộp ngày <fmt:formatDate value="${app.appliedAt}" pattern="dd/MM/yyyy"/>
                                </span>

                                <%-- Link CV --%>
                                <c:if test="${not empty app.cvUrl}">
                                    <a href="${app.cvUrl}" target="_blank" class="cv-link">
                                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline></svg>
                                        Xem CV
                                    </a>
                                </c:if>
                            </div>

                            <%-- Thanh tiến trình --%>
                            <div class="timeline-bar" style="margin-top: 14px;">
                                <div class="timeline-step ${app.status == 'PENDING' || app.status == 'REVIEWING' || app.status == 'INTERVIEWING' || app.status == 'OFFERED' || app.status == 'REJECTED' ? 'done' : ''}"></div>
                                <div class="timeline-step ${app.status == 'REVIEWING' || app.status == 'INTERVIEWING' || app.status == 'OFFERED' ? 'done' : (app.status == 'REJECTED' ? 'error' : '')}"></div>
                                <div class="timeline-step ${app.status == 'INTERVIEWING' || app.status == 'OFFERED' ? 'active' : (app.status == 'REJECTED' ? 'error' : '')}"></div>
                                <div class="timeline-step ${app.status == 'OFFERED' ? 'success' : (app.status == 'REJECTED' ? 'error' : '')}"></div>
                            </div>
                        </div>

                        <%-- Bên phải: Badge trạng thái + nút rút đơn --%>
                        <div style="display: flex; flex-direction: column; align-items: flex-end; gap: 10px; flex-shrink: 0;">
                            <span class="status-badge status-${app.status}">
                                <c:choose>
                                    <c:when test="${app.status == 'PENDING'}">⏳ Chờ duyệt</c:when>
                                    <c:when test="${app.status == 'REVIEWING'}">📋 Đang xem xét</c:when>
                                    <c:when test="${app.status == 'INTERVIEWING'}">📅 Phỏng vấn</c:when>
                                    <c:when test="${app.status == 'OFFERED'}">🎉 Trúng tuyển</c:when>
                                    <c:when test="${app.status == 'REJECTED'}">❌ Không phù hợp</c:when>
                                    <c:when test="${app.status == 'WITHDRAWN'}">🔘 Đã rút đơn</c:when>
                                    <c:otherwise>${app.status}</c:otherwise>
                                </c:choose>
                            </span>

                            <%-- Chỉ cho rút đơn khi còn PENDING --%>
                            <c:if test="${app.status == 'PENDING'}">
                                <form action="${pageContext.request.contextPath}/user/my-applications" method="POST"
                                      id="withdrawForm-${app.applicationId}">
                                    <input type="hidden" name="action" value="withdraw">
                                    <input type="hidden" name="applicationId" value="${app.applicationId}">
                                    <input type="hidden" name="reason" id="withdrawReason-${app.applicationId}">
                                    <button type="button" class="withdraw-btn" onclick="openWithdrawModal('${app.applicationId}')">Rút đơn</button>
                                </form>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
                
                <%-- Component Phân trang --%>
                <jsp:include page="/WEB-INF/views/components/pagination.jsp">
                    <jsp:param name="currentPage" value="${currentPage}" />
                    <jsp:param name="totalPages" value="${totalPages}" />
                    <jsp:param name="actionUrl" value="${pageContext.request.contextPath}/user/my-applications?status=${searchStatus}&keyword=${searchKeyword}" />
                </jsp:include>
            </c:if>

        </div>
    </main>

    <!-- Modal Rút đơn (Messenger Box Style) -->
    <div id="withdrawModal" style="display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.5); backdrop-filter: blur(5px); z-index: 2000; align-items: center; justify-content: center;">
        <div style="background: var(--bg-secondary); border: 1px solid var(--border-color); border-radius: 16px; width: 90%; max-width: 420px; padding: 24px; box-shadow: 0 20px 50px rgba(0,0,0,0.5); animation: scaleUp 0.3s cubic-bezier(0.16, 1, 0.3, 1);">
            <div style="display: flex; align-items: center; gap: 14px; margin-bottom: 20px;">
                <div style="width: 44px; height: 44px; border-radius: 50%; background: rgba(239, 68, 68, 0.1); display: flex; align-items: center; justify-content: center; color: #EF4444; flex-shrink: 0;">
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path><line x1="12" y1="9" x2="12" y2="13"></line><line x1="12" y1="17" x2="12.01" y2="17"></line></svg>
                </div>
                <div>
                    <h3 style="font-size: 1.15rem; font-weight: 800; color: var(--text-primary); margin: 0 0 4px 0;">Rút đơn ứng tuyển</h3>
                    <p style="font-size: 0.85rem; color: var(--text-secondary); margin: 0; line-height: 1.4;">Hành động này không thể hoàn tác. Vui lòng nhập lý do để HR nắm thông tin.</p>
                </div>
            </div>

            <textarea id="modalReasonInput" rows="3" placeholder="Ví dụ: Tôi đã tìm được công việc khác phù hợp hơn..." style="width: 100%; background: var(--bg-primary); border: 1px solid var(--border-color); border-radius: 10px; padding: 14px; color: var(--text-primary); outline: none; resize: none; margin-bottom: 16px; font-family: 'Inter', sans-serif; font-size: 0.95rem; pointer-events: auto; user-select: text; position: relative; z-index: 2010;"></textarea>
            
            <p id="modalErrorMsg" style="color: #EF4444; font-size: 0.85rem; margin-top: -8px; margin-bottom: 16px; display: none; font-weight: 500;">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="vertical-align: text-bottom; margin-right: 4px;"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                Vui lòng không để trống lý do.
            </p>

            <div style="display: flex; gap: 12px; justify-content: flex-end; position: relative; z-index: 2010;">
                <button type="button" onclick="closeWithdrawModal()" style="padding: 10px 18px; border-radius: 10px; background: rgba(255,255,255,0.05); border: 1px solid var(--border-color); color: var(--text-primary); cursor: pointer; font-weight: 600; font-family: 'Inter', sans-serif; transition: all 0.2s;" onmouseover="this.style.background='rgba(255,255,255,0.1)'" onmouseout="this.style.background='rgba(255,255,255,0.05)'">Hủy bỏ</button>
                <button type="button" onclick="submitWithdraw()" style="padding: 10px 18px; border-radius: 10px; background: #EF4444; border: none; color: white; cursor: pointer; font-weight: 600; font-family: 'Inter', sans-serif; box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3); transition: all 0.2s;" onmouseover="this.style.background='#DC2626'; this.style.transform='translateY(-1px)'" onmouseout="this.style.background='#EF4444'; this.style.transform='none'">Xác nhận rút</button>
            </div>
        </div>
    </div>

    <script>
        // CSS Animation keyframes
        const style = document.createElement('style');
        style.innerHTML = `
            @keyframes scaleUp {
                from { opacity: 0; transform: scale(0.95); }
                to { opacity: 1; transform: scale(1); }
            }
        `;
        document.head.appendChild(style);

        let currentWithdrawAppId = null;

        function openWithdrawModal(appId) {
            currentWithdrawAppId = appId;
            const reasonInput = document.getElementById('modalReasonInput');
            reasonInput.value = '';
            document.getElementById('modalErrorMsg').style.display = 'none';
            document.getElementById('withdrawModal').style.display = 'flex';
            
            // Tự động focus vào ô nhập liệu sau khi modal hiện ra
            setTimeout(() => {
                reasonInput.focus();
            }, 100);
        }

        function closeWithdrawModal() {
            document.getElementById('withdrawModal').style.display = 'none';
            currentWithdrawAppId = null;
        }

        function submitWithdraw() {
            const reason = document.getElementById('modalReasonInput').value.trim();
            if (reason === '') {
                document.getElementById('modalErrorMsg').style.display = 'block';
                return;
            }

            if (currentWithdrawAppId) {
                const form = document.getElementById('withdrawForm-' + currentWithdrawAppId);
                const reasonInput = document.getElementById('withdrawReason-' + currentWithdrawAppId);
                reasonInput.value = reason;
                form.submit();
            }
        }
    </script>
</body>
</html>

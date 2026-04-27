<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Khám phá ứng viên - HireHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .candidate-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 24px;
            margin-top: 32px;
        }

        .candidate-card {
            background: var(--bg-secondary);
            border: 1px solid var(--border-color);
            border-radius: 20px;
            padding: 24px;
            text-align: center;
            transition: all 0.3s ease;
            position: relative;
        }

        .candidate-card:hover {
            transform: translateY(-8px);
            border-color: var(--primary);
            box-shadow: 0 12px 30px rgba(99,102,241,0.1);
        }

        .candidate-avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            margin: 0 auto 16px;
            background: linear-gradient(135deg, #6366F1, #8B5CF6);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            font-weight: 800;
            color: white;
            border: 4px solid var(--bg-primary);
        }

        .candidate-name {
            font-size: 1.25rem;
            font-weight: 800;
            color: var(--text-primary);
            margin-bottom: 4px;
        }

        .candidate-email {
            font-size: 0.9rem;
            color: var(--text-muted);
            margin-bottom: 20px;
        }

        .candidate-actions {
            display: flex;
            gap: 10px;
            justify-content: center;
        }

        .btn-invite {
            background: var(--primary);
            color: white;
            padding: 8px 16px;
            border-radius: 10px;
            font-weight: 700;
            font-size: 0.9rem;
            border: none;
            cursor: pointer;
            transition: opacity 0.2s;
        }

        .btn-cv {
            background: transparent;
            color: var(--primary);
            border: 1px solid var(--primary);
            padding: 8px 16px;
            border-radius: 10px;
            font-weight: 700;
            font-size: 0.9rem;
            text-decoration: none;
        }

        /* Modal Invitation */
        .modal {
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0,0,0,0.6); backdrop-filter: blur(4px);
            display: none; align-items: center; justify-content: center; z-index: 9999;
        }
        .modal.active { display: flex; }
        .modal-content {
            background: var(--bg-secondary); width: 100%; max-width: 500px;
            padding: 32px; border-radius: 24px; border: 1px solid var(--border-color);
        }

        .job-select-item {
            display: block; width: 100%; padding: 12px 16px;
            border: 1px solid var(--border-color); border-radius: 12px;
            background: var(--bg-primary); color: var(--text-primary);
            margin-bottom: 12px; cursor: pointer; text-align: left;
            transition: all 0.2s;
        }
        .job-select-item:hover { border-color: var(--primary); background: rgba(99,102,241,0.05); }
    </style>
</head>
<body class="app-page">
    <jsp:include page="/WEB-INF/views/header.jsp" />

    <main class="main-content">
        <div class="container animate-fadeInUp">
            
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px;">
                <div>
                    <h1 style="font-size: 2.5rem; font-weight: 800; color: var(--text-primary); margin-bottom: 8px;">Săn tìm nhân tài</h1>
                    <p style="color: var(--text-secondary); font-size: 1.1rem;">Chủ động kết nối với những ứng viên phù hợp nhất cho công ty của bạn.</p>
                </div>
            </div>

            <c:if test="${param.success == 'invited'}">
                <div class="alert alert-success" style="margin-bottom: 24px;">
                    🎉 Đã gửi lời mời ứng tuyển thành công!
                </div>
            </c:if>

            <c:if test="${not empty candidates}">
                <div class="candidate-grid">
                    <c:forEach var="c" items="${candidates}">
                        <div class="candidate-card">
                            <div class="candidate-avatar">
                                ${c.fullName.substring(0,1).toUpperCase()}
                            </div>
                            <div class="candidate-name">${c.fullName}</div>
                            <div class="candidate-email">${c.email}</div>
                            
                            <div class="candidate-actions">
                                <c:if test="${not empty c.cvUrl}">
                                    <a href="${c.cvUrl}" target="_blank" class="btn-cv">Xem CV</a>
                                </c:if>
                                <button class="btn-invite" onclick="openInviteModal('${c.userId}', '${c.fullName}')">
                                    📩 Mời ứng tuyển
                                </button>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                
                <%-- Component Phân trang --%>
                <jsp:include page="/WEB-INF/views/components/pagination.jsp">
                    <jsp:param name="currentPage" value="${currentPage}" />
                    <jsp:param name="totalPages" value="${totalPages}" />
                    <jsp:param name="actionUrl" value="${pageContext.request.contextPath}/employer/candidates" />
                </jsp:include>
            </c:if>

            <c:if test="${empty candidates}">
                <div class="glass-card" style="padding: 60px; text-align: center;">
                    <p style="color: var(--text-muted);">Hiện chưa có ứng viên nào trên hệ thống.</p>
                </div>
            </c:if>

        </div>
    </main>

    <!-- Modal Chọn Công Việc -->
    <div id="inviteModal" class="modal">
        <div class="modal-content animate-fadeInUp">
            <h2 style="margin-bottom: 12px;">Mời ứng tuyển</h2>
            <p style="color: var(--text-secondary); margin-bottom: 24px;">Mời <strong><span id="modalCandidateName"></span></strong> ứng tuyển vào vị trí nào?</p>
            
            <form action="${pageContext.request.contextPath}/employer/candidates" method="POST">
                <input type="hidden" name="action" value="invite">
                <input type="hidden" name="candidateUserId" id="modalCandidateUserId">
                
                <div style="margin-bottom: 20px;">
                    <label style="display: block; font-weight: 700; margin-bottom: 8px; color: var(--text-primary);">Vị trí ứng tuyển</label>
                    <c:choose>
                        <c:when test="${not empty myJobs}">
                            <select name="jobId" class="form-control" style="width: 100%; background: var(--bg-primary);" required onchange="updateDefaultMessage()">
                                <option value="">-- Chọn công việc --</option>
                                <c:forEach var="job" items="${myJobs}">
                                    <option value="${job.jobId}" data-title="${job.title}">${job.title}</option>
                                </c:forEach>
                            </select>
                        </c:when>
                        <c:otherwise>
                            <div style="padding: 12px; background: rgba(239, 68, 68, 0.1); color: #EF4444; border-radius: 12px; font-size: 0.9rem;">
                                Bạn chưa đăng tin tuyển dụng nào để mời.
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div style="margin-bottom: 24px;">
                    <label style="display: block; font-weight: 700; margin-bottom: 8px; color: var(--text-primary);">Lời mời (Thư mời)</label>
                    <textarea name="inviteMessage" id="inviteMessage" class="form-control" rows="6" 
                              placeholder="Chào bạn, mình thấy hồ sơ của bạn rất phù hợp..." 
                              style="width: 100%; background: var(--bg-primary); resize: none;"></textarea>
                    <p style="font-size: 0.75rem; color: var(--text-muted); margin-top: 6px;">Bạn có thể chỉnh sửa nội dung thư mời trước khi gửi.</p>
                </div>
                
                <div style="display: flex; gap: 12px;">
                    <button type="button" onclick="closeInviteModal()" class="btn btn-outline" style="flex: 1;">Hủy</button>
                    <button type="submit" class="btn btn-primary" style="flex: 1; padding: 12px;">Gửi lời mời ngay</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function openInviteModal(userId, name) {
            document.getElementById('modalCandidateUserId').value = userId;
            document.getElementById('modalCandidateName').innerText = name;
            document.getElementById('inviteModal').classList.add('active');
            document.body.style.overflow = 'hidden';
            updateDefaultMessage();
        }

        function updateDefaultMessage() {
            const select = document.querySelector('select[name="jobId"]');
            const candidateName = document.getElementById('modalCandidateName').innerText;
            const textarea = document.getElementById('inviteMessage');
            
            if (select && select.selectedIndex > 0) {
                const jobTitle = select.options[select.selectedIndex].getAttribute('data-title');
                textarea.value = `Chào ${candidateName},\n\nMình là tuyển dụng từ hệ thống HireHub. Sau khi xem qua hồ sơ của bạn, mình thấy bạn rất tiềm năng và phù hợp với vị trí "${jobTitle}" mà công ty mình đang tuyển dụng.\n\nMời bạn xem chi tiết công việc và phản hồi lại cho mình nhé. Hy vọng có cơ hội hợp tác với bạn!\n\nTrân trọng.`;
            } else {
                textarea.value = "";
            }
        }

        function closeInviteModal() {
            document.getElementById('inviteModal').classList.remove('active');
            document.body.style.overflow = 'auto';
        }

        window.onclick = function(event) {
            if (event.target == document.getElementById('inviteModal')) {
                closeInviteModal();
            }
        }
    </script>
</body>
</html>

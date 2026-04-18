<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý tin tuyển dụng - HireHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

</head>
<body class="app-page">
    <jsp:include page="/WEB-INF/views/header.jsp" />

    <main class="main-content">
        <div class="container animate-fadeInUp">
            
            <div class="section-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: var(--space-xl);">
                <div>
                    <h1>Quản lý tin tuyển dụng</h1>
                    <p class="text-secondary">Hiển thị các bài đăng của bạn</p>
                </div>
                <button onclick="openModal()" class="btn btn-primary">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                    Đăng tin mới
                </button>
            </div>

            <div class="glass-card" style="overflow-x: auto;">
                <table class="table-glass">
                    <thead>
                        <tr>
                            <th>Tiêu đề / Ngành nghề</th>
                            <th>Trạng thái</th>
                            <th>Mức lương</th>
                            <th>Ngày hết hạn</th>
                            <th>Lượt xem</th>
                            <th style="text-align: right;">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty jobs}">
                                <tr>
                                    <td colspan="6" class="text-center text-muted" style="padding: 30px;">
                                        Bạn chưa đăng tin tuyển dụng nào.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach items="${jobs}" var="job">
                                    <tr>
                                        <td>
                                            <div style="font-weight: 600; color: var(--text-primary); margin-bottom: 4px;">${job.title}</div>
                                            <div style="font-size: 0.85rem; color: var(--text-muted);">${job.categoryName} • ${job.locationName}</div>
                                        </td>
                                        <td>
                                            <span class="status-badge status-${job.status}">
                                                <c:choose>
                                                    <c:when test="${job.status == 'PUBLISHED'}">Đang mở</c:when>
                                                    <c:when test="${job.status == 'CLOSED'}">Đã đóng</c:when>
                                                    <c:when test="${job.status == 'DRAFT'}">Bản nháp</c:when>
                                                    <c:otherwise>${job.status}</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>
                                        <td class="text-success" style="font-weight: 600;">
                                            <c:if test="${job.salaryMax != null}">
                                                <fmt:formatNumber value="${job.salaryMin}" maxFractionDigits="0" /> - <fmt:formatNumber value="${job.salaryMax}" maxFractionDigits="0" />
                                            </c:if>
                                            <c:if test="${job.salaryMax == null}">Thỏa thuận</c:if>
                                        </td>
                                        <td><fmt:formatDate value="${job.deadlineAt}" pattern="dd/MM/yyyy"/></td>
                                        <td>${job.viewCount}</td>
                                        <td style="text-align: right;">
                                            <div style="display: flex; justify-content: flex-end; gap: 8px;">
                                                <a href="${pageContext.request.contextPath}/job-detail?id=${job.jobId}" target="_blank" class="btn btn-outline" style="padding: 6px 12px; font-size: 0.85rem;" title="Xem bài">
                                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path><circle cx="12" cy="12" r="3"></circle></svg>
                                                </a>
                                                <button class="btn btn-primary" style="padding: 6px 12px; font-size: 0.85rem;" title="Sửa bài"
                                                        onclick="openModal(this)"
                                                        data-id="${job.jobId}"
                                                        data-title="<c:out value='${job.title}'/>"
                                                        data-category="${job.categoryId}"
                                                        data-location="${job.locationId}"
                                                        data-type="${job.employmentTypeId}"
                                                        data-level="${job.experienceLevelId}"
                                                        data-min="${job.salaryMin != null ? job.salaryMin.stripTrailingZeros().toPlainString() : ''}"
                                                        data-max="${job.salaryMax != null ? job.salaryMax.stripTrailingZeros().toPlainString() : ''}"
                                                        data-deadline="${not empty job.deadlineAt ? String.valueOf(job.deadlineAt).substring(0, 10) : ''}"
                                                        data-status="${job.status}"
                                                        data-desc="<c:out value='${job.description}'/>"
                                                        data-req="<c:out value='${job.requirements}'/>"
                                                        data-resp="<c:out value='${job.responsibilities}'/>">
                                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
                                                </button>
                                                <c:choose>
                                                    <c:when test="${job.status == 'PUBLISHED'}">
                                                        <form action="${pageContext.request.contextPath}/employer/jobs" method="post" style="display: inline;">
                                                            <input type="hidden" name="action" value="status">
                                                            <input type="hidden" name="id" value="${job.jobId}">
                                                            <input type="hidden" name="status" value="CLOSED">
                                                            <button type="submit" class="btn btn-outline text-warning" style="padding: 6px 12px; font-size: 0.85rem; border-color: var(--warning);" title="Đóng bài đăng" onclick="return confirm('Bạn có chắc chắn muốn ĐÓNG bài đăng này?');">
                                                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18.36 6.64a9 9 0 1 1-12.73 0"></path><line x1="12" y1="2" x2="12" y2="12"></line></svg>
                                                            </button>
                                                        </form>
                                                    </c:when>
                                                    <c:when test="${job.status == 'CLOSED'}">
                                                        <form action="${pageContext.request.contextPath}/employer/jobs" method="post" style="display: inline;">
                                                            <input type="hidden" name="action" value="status">
                                                            <input type="hidden" name="id" value="${job.jobId}">
                                                            <input type="hidden" name="status" value="PUBLISHED">
                                                            <button type="submit" class="btn btn-outline text-success" style="padding: 6px 12px; font-size: 0.85rem; border-color: var(--success);" title="Mở lại bài đăng" onclick="return confirm('Bạn muốn MỞ LẠI và tiếp tục nhận hồ sơ cho bài đăng này?');">
                                                                <!-- Refresh icon for reopening -->
                                                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="1 4 1 10 7 10"></polyline><polyline points="23 20 23 14 17 14"></polyline><path d="M20.49 9A9 9 0 0 0 5.64 5.64L1 10m22 4l-4.64 4.36A9 9 0 0 1 3.51 15"></path></svg>
                                                            </button>
                                                        </form>
                                                    </c:when>
                                                </c:choose>

                                                <form action="${pageContext.request.contextPath}/employer/jobs" method="post" style="display: inline;">
                                                    <input type="hidden" name="action" value="status">
                                                    <input type="hidden" name="id" value="${job.jobId}">
                                                    <input type="hidden" name="status" value="DELETED">
                                                    <button type="submit" class="btn btn-outline text-danger" style="padding: 6px 12px; font-size: 0.85rem; border-color: var(--error);" title="Xóa bài đăng" onclick="return confirm('Sau khi xóa không thể khôi phục. Tiếp tục?');">
                                                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg>
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <!-- Modal Xem/Sửa -->
    <div id="jobModal" style="display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.4); backdrop-filter: blur(4px); z-index: 1000; overflow-y: auto; padding: 40px 20px;">
        <div class="glass-card animate-fadeInUp" style="position: relative; width: 100%; max-width: 900px; margin: 0 auto; padding: var(--space-2xl); background: var(--bg-secondary); border-radius: 16px; box-shadow: 0 20px 50px rgba(0,0,0,0.5);">
            <button onclick="closeModal()" type="button" style="position: absolute; top: 20px; right: 20px; background: none; border: none; color: var(--text-muted); cursor: pointer; padding: 8px;">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
            </button>
            <h2 id="modalTitle" style="margin-bottom: var(--space-xl); font-size: 1.75rem;">Đăng tin tuyển dụng mới</h2>
            
            <form id="jobForm" action="${pageContext.request.contextPath}/employer/jobs" method="post" class="edit-form">
                <input type="hidden" name="jobId" id="modalJobId" value="">

                <div class="form-group">
                    <label class="form-label">Tiêu đề công việc <span class="required">*</span></label>
                    <input type="text" name="title" id="modalTitleInput" class="form-input" required style="padding-left: 14px;">
                </div>

                <div class="form-row" style="display: grid; grid-template-columns: 1fr 1fr; gap: var(--space-md);">
                    <div class="form-group">
                        <label class="form-label">Danh mục <span class="required">*</span></label>
                        <select name="categoryId" id="modalCategory" class="form-input form-select" required>
                            <option value="">Chọn danh mục</option>
                            <c:forEach items="${categories}" var="cat">
                                <option value="${cat.categoryId}">${cat.categoryName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Địa điểm <span class="required">*</span></label>
                        <select name="locationId" id="modalLocation" class="form-input form-select" required>
                            <option value="">Chọn địa điểm</option>
                            <c:forEach items="${locations}" var="loc">
                                <option value="${loc.locationId}">${loc.locationName}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-row" style="display: grid; grid-template-columns: 1fr 1fr; gap: var(--space-md);">
                    <div class="form-group">
                        <label class="form-label">Hình thức <span class="required">*</span></label>
                        <select name="employmentTypeId" id="modalType" class="form-input form-select" required>
                            <option value="">Chọn hình thức</option>
                            <c:forEach items="${employmentTypes}" var="type">
                                <option value="${type.employmentTypeId}">${type.typeName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Kinh nghiệm <span class="required">*</span></label>
                        <select name="experienceLevelId" id="modalLevel" class="form-input form-select" required>
                            <option value="">Chọn yêu cầu</option>
                            <c:forEach items="${experienceLevels}" var="lvl">
                                <option value="${lvl.experienceLevelId}">${lvl.levelName}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-row" style="display: grid; grid-template-columns: 1fr 1fr; gap: var(--space-md);">
                    <div class="form-group">
                        <label class="form-label">Mức lương tối thiểu (VND)</label>
                        <input type="number" name="salaryMin" id="modalMin" class="form-input" style="padding-left: 14px;">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Mức lương tối đa (VND)</label>
                        <input type="number" name="salaryMax" id="modalMax" class="form-input" style="padding-left: 14px;">
                    </div>
                </div>

                <div class="form-row" style="display: grid; grid-template-columns: 1fr 1fr; gap: var(--space-md);">
                    <div class="form-group">
                        <label class="form-label">Hạn nộp hồ sơ <span class="required">*</span></label>
                        <input type="date" name="deadlineAt" id="modalDeadline" class="form-input" required style="padding-left: 14px;">
                    </div>
                    <div class="form-group">
                        <label class="form-label">Trạng thái <span class="required">*</span></label>
                        <select name="status" id="modalStatus" class="form-input form-select" required>
                            <option value="PUBLISHED">Công khai</option>
                            <option value="DRAFT">Bản nháp</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Mô tả công việc <span class="required">*</span></label>
                    <textarea name="description" id="modalDesc" class="form-input" rows="5" required style="padding: 14px;"></textarea>
                </div>

                <div class="form-group">
                    <label class="form-label">Yêu cầu ứng viên <span class="required">*</span></label>
                    <textarea name="requirements" id="modalReq" class="form-input" rows="5" required style="padding: 14px;"></textarea>
                </div>

                <div class="form-group">
                    <label class="form-label">Quyền lợi</label>
                    <textarea name="responsibilities" id="modalResp" class="form-input" rows="4" style="padding: 14px;"></textarea>
                </div>

                <div style="margin-top: var(--space-xl); display: flex; gap: var(--space-md); justify-content: flex-end;">
                    <button type="button" onclick="closeModal()" class="btn btn-outline">Hủy bỏ</button>
                    <button type="submit" class="btn btn-primary" style="padding: 14px 32px;">Lưu tin tuyển dụng</button>
                </div>
            </form>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
    <script>
        function openModal(btn) {
            const modal = document.getElementById('jobModal');
            document.body.style.overflow = 'hidden'; // prevent bg scroll
            modal.style.display = 'flex';
            
            if (btn) {
                // Sửa bài
                document.getElementById('modalTitle').textContent = 'Chỉnh sửa tin tuyển dụng';
                document.getElementById('modalJobId').value = btn.getAttribute('data-id');
                document.getElementById('modalTitleInput').value = btn.getAttribute('data-title');
                document.getElementById('modalCategory').value = btn.getAttribute('data-category');
                document.getElementById('modalLocation').value = btn.getAttribute('data-location');
                document.getElementById('modalType').value = btn.getAttribute('data-type');
                document.getElementById('modalLevel').value = btn.getAttribute('data-level');
                document.getElementById('modalMin').value = btn.getAttribute('data-min');
                document.getElementById('modalMax').value = btn.getAttribute('data-max');
                document.getElementById('modalDeadline').value = btn.getAttribute('data-deadline');
                
                let s = btn.getAttribute('data-status');
                document.getElementById('modalStatus').value = (s === 'CLOSED') ? 'PUBLISHED' : s;
                
                document.getElementById('modalDesc').value = btn.getAttribute('data-desc');
                document.getElementById('modalReq').value = btn.getAttribute('data-req');
                document.getElementById('modalResp').value = btn.getAttribute('data-resp');
            } else {
                // Đăng mới
                document.getElementById('modalTitle').textContent = 'Đăng tin tuyển dụng mới';
                document.getElementById('jobForm').reset();
                document.getElementById('modalJobId').value = '';
                document.getElementById('modalStatus').value = 'PUBLISHED';
            }
        }

        function closeModal() {
            document.getElementById('jobModal').style.display = 'none';
            document.body.style.overflow = 'auto';
        }
    </script>
</body>
</html>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${not empty job ? 'Sửa' : 'Đăng'} tin tuyển dụng - HireHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="app-page">
    <jsp:include page="/WEB-INF/views/header.jsp" />

    <main class="main-content">
        <div class="container animate-fadeInUp">
            
            <a href="${pageContext.request.contextPath}/employer/jobs" class="btn btn-outline" style="margin-bottom: var(--space-xl); padding: 8px 16px; display: inline-flex; border-radius: 20px;">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="margin-right: 6px;"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>
                Quay lại danh sách
            </a>

            <div class="glass-card" style="padding: var(--space-2xl); max-width: 900px; margin: 0 auto;">
                <h1 style="margin-bottom: var(--space-xl); font-size: 2rem;">${not empty job ? 'Chỉnh sửa tin tuyển dụng' : 'Đăng tin tuyển dụng mới'}</h1>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-error">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                        <span>${errorMessage}</span>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/employer/jobs" method="post" class="edit-form">
                    <input type="hidden" name="jobId" value="${not empty job ? job.jobId : ''}">

                    <div class="form-group">
                        <label class="form-label">Tiêu đề công việc <span class="required">*</span></label>
                        <div class="input-wrapper">
                            <input type="text" name="title" class="form-input" value="${job.title}" required style="padding-left: 14px;">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Danh mục <span class="required">*</span></label>
                            <select name="categoryId" class="form-input form-select" required>
                                <option value="">Chọn danh mục</option>
                                <c:forEach items="${categories}" var="cat">
                                    <option value="${cat.categoryId}" ${job.categoryId == cat.categoryId ? 'selected' : ''}>${cat.categoryName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Địa điểm <span class="required">*</span></label>
                            <select name="locationId" class="form-input form-select" required>
                                <option value="">Chọn địa điểm</option>
                                <c:forEach items="${locations}" var="loc">
                                    <option value="${loc.locationId}" ${job.locationId == loc.locationId ? 'selected' : ''}>${loc.locationName}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Hình thức <span class="required">*</span></label>
                            <select name="employmentTypeId" class="form-input form-select" required>
                                <option value="">Chọn hình thức</option>
                                <c:forEach items="${employmentTypes}" var="type">
                                    <option value="${type.employmentTypeId}" ${job.employmentTypeId == type.employmentTypeId ? 'selected' : ''}>${type.typeName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Kinh nghiệm <span class="required">*</span></label>
                            <select name="experienceLevelId" class="form-input form-select" required>
                                <option value="">Chọn yêu cầu kinh nghiệm</option>
                                <c:forEach items="${experienceLevels}" var="lvl">
                                    <option value="${lvl.experienceLevelId}" ${job.experienceLevelId == lvl.experienceLevelId ? 'selected' : ''}>${lvl.levelName}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Mức lương tối thiểu (VND)</label>
                            <input type="number" name="salaryMin" class="form-input" value="${job.salaryMin != null ? job.salaryMin.stripTrailingZeros().toPlainString() : ''}" style="padding-left: 14px;">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Mức lương tối đa (VND)</label>
                            <input type="number" name="salaryMax" class="form-input" value="${job.salaryMax != null ? job.salaryMax.stripTrailingZeros().toPlainString() : ''}" style="padding-left: 14px;">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Hạn nộp hồ sơ <span class="required">*</span></label>
                            <input type="date" name="deadlineAt" class="form-input" required style="padding-left: 14px;" value="${not empty job.deadlineAt ? String.valueOf(job.deadlineAt).substring(0, 10) : ''}">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Trạng thái <span class="required">*</span></label>
                            <select name="status" class="form-input form-select" required>
                                <option value="PUBLISHED" ${job.status == 'PUBLISHED' ? 'selected' : ''}>Công khai</option>
                                <option value="DRAFT" ${job.status == 'DRAFT' ? 'selected' : ''}>Bản nháp</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Mô tả công việc <span class="required">*</span></label>
                        <textarea name="description" class="form-input" rows="5" required style="padding: 14px;">${job.description}</textarea>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Yêu cầu ứng viên <span class="required">*</span></label>
                        <textarea name="requirements" class="form-input" rows="5" required style="padding: 14px;">${job.requirements}</textarea>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Quyền lợi</label>
                        <textarea name="responsibilities" class="form-input" rows="4" style="padding: 14px;">${job.responsibilities}</textarea>
                    </div>

                    <div style="margin-top: var(--space-xl); display: flex; gap: var(--space-md); justify-content: flex-end;">
                        <a href="${pageContext.request.contextPath}/employer/jobs" class="btn btn-outline">Hủy bỏ</a>
                        <button type="submit" class="btn btn-primary" style="padding: 14px 32px;">Lưu tin tuyển dụng</button>
                    </div>
                </form>
            </div>
        </div>
    </main>
</body>
</html>

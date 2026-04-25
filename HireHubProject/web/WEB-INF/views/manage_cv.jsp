<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>

    <head>
        <title>Quản lý CV | HireHub</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
              rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
              rel="stylesheet">
        <link rel="stylesheet"
              href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

        <style>
            .cv-date-container {
                display: flex;
                flex-direction: column;
                gap: 5px;
                margin-bottom: 1.5rem;
            }

            .cv-date-item {
                display: flex;
                align-items: center;
                gap: 8px;
                font-size: 0.8rem;
            }

            .cv-date-label {
                color: rgba(255, 255, 255, 0.5);
                min-width: 100px;
            }

            .cv-date-value {
                color: rgba(255, 255, 255, 0.9);
                font-weight: 500;
            }

            .text-white-80 {
                color: rgba(255, 255, 255, 0.8);
            }

            .cv-card {
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                border: 1px solid rgba(255, 255, 255, 0.05) !important;
                position: relative;
                overflow: hidden;
                background: rgba(255, 255, 255, 0.03);
                backdrop-filter: blur(10px);
            }

            .cv-card:hover {
                transform: translateY(-5px);
                border-color: #007bff !important;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
            }

            .border-accepted {
                border: 1px solid rgba(16, 185, 129, 0.5) !important;
                background: linear-gradient(135deg, rgba(16, 185, 129, 0.08) 0%, rgba(0, 0, 0, 0) 100%);
            }

            .accepted-badge {
                position: absolute;
                top: 10px;
                right: -30px;
                background: #10b981;
                color: white;
                padding: 5px 35px;
                transform: rotate(45deg);
                font-size: 0.6rem;
                font-weight: 700;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
                z-index: 1;
            }

            .filter-pill {
                border-radius: 20px;
                border: 1px solid rgba(255, 255, 255, 0.1);
                font-size: 0.8rem;
                color: white;
                transition: 0.3s;
                background: rgba(255, 255, 255, 0.05);
            }

            .filter-pill:hover,
            .filter-pill.active {
                background: #007bff;
                border-color: #007bff;
                color: white;
            }

            .search-input-group {
                background: rgba(255, 255, 255, 0.05);
                border: 1px solid rgba(255, 255, 255, 0.1);
                border-radius: 10px;
                overflow: hidden;
            }

            .limit-info {
                font-size: 0.9rem;
                padding: 4px 12px;
                border-radius: 50px;
                background: rgba(255, 255, 255, 0.05);
                border: 1px solid rgba(255, 255, 255, 0.1);
            }

            .upload-zone {
                border: 2px dashed rgba(255, 255, 255, 0.1) !important;
                transition: 0.3s;
                cursor: pointer;
            }

            .upload-zone:hover {
                border-color: #007bff !important;
                background: rgba(0, 123, 255, 0.05);
            }

            .cursor-pointer {
                cursor: pointer;
            }

            /* 1. Xóa viền trắng và bóng mặc định của ô input */
            #cvSearch.form-control {
                border: none !important;
                box-shadow: none !important;
                outline: none !important;
            }

            /* 2. Điều chỉnh placeholder cho tiệp màu giao diện */
            #cvSearch::placeholder {
                color: rgba(255, 255, 255, 0.3);
            }

            /* 3. Hiệu ứng viền cho toàn bộ group khi người dùng nhấn vào */
            .search-input-group:focus-within {
                border-color: #007bff !important;
                background: rgba(255, 255, 255, 0.1);
                box-shadow: 0 0 10px rgba(0, 123, 255, 0.2);
                transition: all 0.3s ease;
            }

            .status-public {
                color: #10b981 !important;
                /* Màu xanh lá */
                font-weight: 600;
            }

            .status-private {
                color: #6c757d !important;
                /* Màu xám */
                font-weight: 600;
            }

            .cv-date-item i.bi-eye-fill {
                font-size: 0.9rem;
            }

            .cv-action-top-right {
                position: absolute;
                top: 15px;
                right: 15px;
                z-index: 10;
            }

            .cv-action-top-right .btn-icon {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                width: 32px;
                height: 32px;
                border-radius: 50%;
                background: rgba(255, 255, 255, 0.1);
                color: rgba(255, 255, 255, 0.8);
                transition: all 0.2s ease;
                text-decoration: none;
                backdrop-filter: blur(5px);
            }

            .cv-action-top-right .btn-icon:hover {
                background: #10b981;
                color: white;
                transform: scale(1.1);
            }

            /* Style cho nút gạt Toggle Switch (Dark Theme) */
            .switch-container {
                display: flex;
                align-items: center;
                justify-content: space-between;
                background: rgba(255, 255, 255, 0.05);
                padding: 12px 15px;
                border-radius: 12px;
                border: 1px solid rgba(255, 255, 255, 0.1);
            }

            .switch {
                position: relative;
                display: inline-block;
                width: 50px;
                height: 24px;
                margin-bottom: 0;
            }

            .switch input {
                opacity: 0;
                width: 0;
                height: 0;
            }

            .slider {
                position: absolute;
                cursor: pointer;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background-color: #6c757d;
                transition: .4s;
                border-radius: 24px;
            }

            .slider:before {
                position: absolute;
                content: "";
                height: 18px;
                width: 18px;
                left: 4px;
                bottom: 3px;
                background-color: white;
                transition: .4s;
                border-radius: 50%;
            }

            input:checked+.slider {
                background-color: #4A90E2;
            }

            input:checked+.slider:before {
                transform: translateX(26px);
            }

            .switch-label {
                font-size: 0.9rem;
                color: rgba(255, 255, 255, 0.8);
                font-weight: 500;
            }
        </style>
    </head>

    <body class="app-page">

        <jsp:include page="/WEB-INF/views/header.jsp" />

        <div class="bg-decoration">
            <div class="bg-circle bg-circle-1"></div>
            <div class="bg-circle bg-circle-2"></div>
        </div>

        <div class="container py-5 main-content" style="position: relative; z-index: 10;">
            <div class="row mb-3">
                <div class="col-md-8">
                    <c:if test="${not empty sessionScope.msg}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="bi bi-check-circle-fill me-2"></i> ${sessionScope.msg}
                            <button type="button" class="btn-close btn-close-white"
                                    data-bs-dismiss="alert"></button>
                        </div>
                        <c:remove var="msg" scope="session" />
                    </c:if>
                </div>
            </div>

            <div class="row">
                <div class="col-md-8">
                    <c:set var="currentCount" value="${fn:length(cvList)}" />

                    <div
                        class="page-header mb-4 d-flex flex-wrap justify-content-between align-items-center gap-3">
                        <div style="margin-bottom: 16px;">
                            <h1
                                style="font-size: 2.2rem; font-weight: 800; color: var(--text-primary); margin-bottom: 8px;">
                                Quản lý CV
                            </h1>
                            <div class="d-flex align-items-center gap-3">
                                <p style="color: var(--text-secondary); margin-bottom: 0;">Theo dõi hồ sơ
                                    của bạn</p>
                                <span class="limit-info">
                                    <i class="bi bi-files me-1"></i>
                                    <span
                                        class="${currentCount >= 10 ? 'text-danger fw-bold' : 'text-primary'}">${currentCount}</span>/10
                                    CV
                                </span>
                            </div>
                        </div>

                        <div class="d-flex gap-2">
                            <c:choose>
                                <c:when test="${currentCount >= 10}">
                                    <button class="btn btn-outline-light border-0 bg-white bg-opacity-10"
                                            onclick="showLimitAlert()">
                                        <i class="bi bi-upload"></i> Tải lên
                                    </button>
                                    <button class="btn btn-primary px-4 opacity-50"
                                            onclick="showLimitAlert()">
                                        <i class="bi bi-lock-fill"></i> Tạo CV Mới
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <button class="btn btn-outline-light border-0 bg-white bg-opacity-10"
                                            data-bs-toggle="modal" data-bs-target="#uploadCVModal">
                                        <i class="bi bi-upload me-1"></i> Tải lên
                                    </button>
                                    <a href="${pageContext.request.contextPath}/user/cv_template"
                                       class="btn btn-primary px-4 shadow">
                                        <i class="bi bi-plus-lg me-1"></i> Tạo CV Mới
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="glass-card p-3 mb-4">
                        <div class="row g-3">
                            <div class="col-lg-5">
                                <div class="input-group search-input-group">
                                    <span class="input-group-text bg-transparent border-0 text-secondary">
                                        <i class="bi bi-search"></i>
                                    </span>
                                    <input type="text" id="cvSearch"
                                           class="form-control bg-transparent text-white"
                                           placeholder="Tìm theo tên CV..." onkeyup="filterCVs()">
                                </div>
                            </div>
                            <div class="col-lg-7">
                                <div
                                    class="d-flex flex-wrap gap-2 justify-content-lg-end h-100 align-items-center">
                                    <button class="btn btn-sm filter-pill active"
                                            onclick="applyFilter('all', this)">Tất cả</button>
                                    <button class="btn btn-sm filter-pill"
                                            onclick="applyFilter('accepted', this)">Đã duyệt</button>
                                    <button class="btn btn-sm filter-pill"
                                            onclick="applyFilter('web', this)">Tạo từ Web</button>
                                    <button class="btn btn-sm filter-pill"
                                            onclick="applyFilter('upload', this)">File Tải lên</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row" id="cvContainer">
                        <c:forEach var="cv" items="${cvList}">
                        <div class="col-md-6 mb-4 cv-item-card" data-title="${cv.cvTitle.toLowerCase()}"
                                 data-source="${cv.isUpload == 1 ? 'upload' : 'web'}"
                                 data-status="${cv.isAccepted ? 'accepted' : 'pending'}">

                                <div
                                    class="glass-card cv-card h-100 ${cv.isAccepted ? 'border-accepted' : ''}">
                                    <c:if test="${cv.isAccepted}">
                                        <div class="accepted-badge" title="CV này đã được nhà tuyển dụng chấp nhận (OFFERED hoặc INTERVIEWING)">✓ DUYỆT</div>
                                    </c:if>

                                    <!-- Nút tải xuống ở góc phải -->
                                    <div class="cv-action-top-right"
                                         style="${cv.isAccepted ? 'right: 55px;' : ''}">
                                        <c:choose>
                                            <c:when test="${cv.isUpload == 1}">
                                                <!-- Đối với File Tải lên: không hiện tải xuống nữa theo yêu cầu -->
                                            </c:when>
                                            <c:otherwise>
                                                <!-- Đối với Web Builder: hiện icon tải xuống -->
                                                <a href="${pageContext.request.contextPath}/user/cv/preview?id=${cv.userCVId}"
                                                   onclick="alert('Mẹo: Trình duyệt sẽ mở tab mới. Bạn hãy nhấn Ctrl+P (hoặc Cmd+P trên Mac) và chọn Lưu dưới dạng PDF để tải CV này nhé!');"
                                                   class="btn-icon" target="_blank" title="Tải xuống CV">
                                                    <i class="bi bi-download"></i>
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <div class="card-body p-4">
                                        <div class="mb-2">
                                            <span
                                                class="badge ${cv.isUpload == 0 ? 'bg-primary' : 'bg-info'} bg-opacity-10 ${cv.isUpload == 0 ? 'text-primary' : 'text-info'}"
                                                style="font-size: 0.65rem;">
                                                <i
                                                    class="bi ${cv.isUpload == 0 ? 'bi-window-sidebar' : 'bi-file-earmark-arrow-up'} me-1"></i>
                                                ${cv.isUpload == 0 ? 'WEB BUILDER' : 'UPLOADED FILE'}
                                            </span>
                                        </div>

                                        <h5 class="fw-bold mb-1 text-white text-truncate">${cv.cvTitle}</h5>
                                        <c:choose>
                                            <%-- Nếu là Web Builder (isUpload==0) thì hiện Target Role bình
                                                thường --%>
                                            <c:when test="${cv.isUpload == 0}">
                                                <p class="small text-secondary mb-4 text-truncate">
                                                    ${not empty cv.targetRole ? cv.targetRole : 'Chưa
                                                      cập nhật vị trí'}
                                                </p>
                                            </c:when>
                                            <%-- Nếu là File Upload (isUpload==1) thì ẩn chữ nhưng giữ
                                                khoảng trống (margin/height) --%>
                                            <c:otherwise>
                                                <p class="small mb-4" style="visibility: hidden;">
                                                    &nbsp;</p>
                                                </c:otherwise>
                                            </c:choose>

                                        <div class="cv-date-container">
                                            <div class="cv-date-item">
                                                <i class="bi bi-calendar-plus text-primary"></i>
                                                <span class="cv-date-label">Ngày tạo:</span>
                                                <span class="cv-date-value">
                                                    <fmt:formatDate value="${cv.createdAt}"
                                                                    pattern="dd/MM/yyyy" />
                                                </span>
                                            </div>

                                            <div class="cv-date-item">
                                                <c:choose>
                                                    <c:when test="${cv.isUpload == 0}">
                                                        <i class="bi bi-pencil-square text-info"></i>
                                                        <span class="cv-date-label">Cập nhật:</span>
                                                        <span class="cv-date-value">
                                                            <fmt:formatDate
                                                                value="${cv.updatedAt != null ? cv.updatedAt : cv.createdAt}"
                                                                pattern="dd/MM/yyyy" />
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div style="height: 1.2rem;"></div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>

                                            <%-- THÊM MỚI: Dòng Trạng thái tìm kiếm --%>
                                            <div class="cv-date-item">
                                                <i
                                                    class="bi ${cv.isSearchable == 1 ? 'bi-eye-fill' : 'bi-eye-slash-fill'} ${cv.isSearchable == 1 ? 'text-success' : 'text-secondary'}"></i>
                                                <span class="cv-date-label">Tìm kiếm:</span>
                                                <span
                                                    class="cv-date-value ${cv.isSearchable == 1 ? 'status-public' : 'status-private'}">
                                                    ${cv.isSearchable == 1 ? 'Đang bật' : 'Đang tắt'}
                                                </span>
                                            </div>
                                            <%-- Trạng thái được duyệt (set bởi ApplicationDAO khi đơn OFFERED/INTERVIEWING) --%>
                                            <div class="cv-date-item">
                                                <c:choose>
                                                    <c:when test="${cv.hireStatusCode == 'OFFERED'}">
                                                        <i class="bi bi-trophy-fill text-warning"></i>
                                                        <span class="cv-date-label">Tuyển dụng:</span>
                                                        <span class="cv-date-value" style="color:#F59E0B; font-weight:700;">🎉 Đã tuyển</span>
                                                    </c:when>
                                                    <c:when test="${cv.hireStatusCode == 'INTERVIEWING'}">
                                                        <i class="bi bi-calendar-check-fill text-info"></i>
                                                        <span class="cv-date-label">Tuyển dụng:</span>
                                                        <span class="cv-date-value" style="color:#06B6D4; font-weight:600;">📅 Đang phỏng vấn</span>
                                                    </c:when>
                                                    <c:when test="${cv.isAccepted}">
                                                        <i class="bi bi-patch-check-fill text-success"></i>
                                                        <span class="cv-date-label">Tuyển dụng:</span>
                                                        <span class="cv-date-value status-public">Đã được duyệt</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="bi bi-hourglass-split text-secondary"></i>
                                                        <span class="cv-date-label">Tuyển dụng:</span>
                                                        <span class="cv-date-value status-private">Chưa duyệt</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>

                                        <div class="d-flex gap-2 pt-3"
                                             style="border-top: 1px solid rgba(255,255,255,0.05);">
                                            <c:choose>
                                                <c:when test="${cv.isUpload == 1}">
                                                    <a href="${pageContext.request.contextPath}/user/cv/view?id=${cv.userCVId}"
                                                       class="btn btn-sm btn-info flex-fill text-white"
                                                       target="_blank">
                                                        <i class="fas fa-file-pdf me-1"></i> Xem PDF
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="${pageContext.request.contextPath}/user/cv/preview?id=${cv.userCVId}"
                                                       class="btn btn-sm btn-outline-light border-0 bg-white bg-opacity-10 flex-fill"
                                                       target="_blank">
                                                        <i class="bi bi-eye me-1"></i> Xem
                                                    </a>
                                                    <c:choose>
                                                        <%-- TRƯỜNG HỢP 1: CV ĐÃ DUYỆT -> Khóa nút Sửa --%>
                                                         <c:when test="${cv.isAccepted}">
                                                            <button
                                                                class="btn btn-sm btn-outline-light border-0 bg-white bg-opacity-5 flex-fill opacity-50"
                                                                style="cursor: not-allowed;"
                                                                onclick="alert('CV này đã được nhà tuyển dụng duyệt (trạng thái OFFERED hoặc INTERVIEWING). Không thể chỉnh sửa để đảm bảo tính toàn vẹn hồ sơ.')"
                                                                title="CV đã được duyệt — khóa chỉnh sửa">
                                                                <i class="bi bi-lock-fill me-1"></i> Sửa
                                                            </button>
                                                        </c:when>

                                                        <%-- TRƯỜNG HỢP 2: CV CHƯA DUYỆT -> Cho phép sửa
                                                        --%>
                                                        <c:otherwise>
                                                            <a href="${pageContext.request.contextPath}/user/cv/edit?id=${cv.userCVId}"
                                                               class="btn btn-sm btn-outline-light border-0 bg-white bg-opacity-10 flex-fill">
                                                                <i
                                                                    class="bi bi-pencil-square me-1"></i>
                                                                Sửa
                                                            </a>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:otherwise>
                                            </c:choose>

                                            <button
                                                class="btn btn-sm btn-outline-danger border-0 bg-danger bg-opacity-10"
                                                onclick="confirmDelete('${cv.userCVId}', '${cv.cvTitle}')"
                                                title="${cv.isAccepted ? 'CV này đã duyệt — hãy chắc chắn trước khi xóa' : 'Xóa CV'}">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="glass-card p-4 mb-4 border-0"
                         style="background: linear-gradient(135deg, rgba(16, 185, 129, 0.1), rgba(5, 150, 105, 0.1));">
                        <h5 class="text-white fw-bold mb-3"><i
                                class="bi bi-lightbulb text-warning me-2"></i>Mẹo nhỏ</h5>
                        <p class="small text-white-80">CV có trạng thái <b class="text-success">Duyệt</b> sẽ
                            có tỉ lệ được nhà tuyển dụng chú ý cao hơn 40%.</p>
                    </div>

                    <h4 class="fw-bold text-white mb-3">Việc làm phù hợp</h4>
                    <div class="d-flex flex-column gap-3">
                        <c:forEach var="job" items="${jobList}">
                            <a href="${pageContext.request.contextPath}/job-detail?id=${job.jobId}"
                               class="glass-card p-3 text-decoration-none shadow-hover d-block">
                                <h6 class="fw-bold text-white mb-1">${job.title}</h6>
                                <p class="small text-secondary mb-2">${job.companyName != null ?
                                                                       job.companyName : 'Đang cập nhật công ty'}</p>
                                <div class="d-flex justify-content-between align-items-center">
                                    <span class="text-success fw-bold small">
                                        ${job.formattedSalary} ${job.formattedSalary != 'Thỏa thuận' ?
                                          job.currencyCode : ''}
                                    </span>
                                    <span class="badge bg-primary">Chi tiết</span>
                                </div>
                            </a>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="uploadCVModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content glass-card border-0" style="background: #1a1d21;">
                    <div class="modal-header border-0">
                        <h5 class="modal-title text-white fw-bold">Tải CV lên hệ thống</h5>
                        <button type="button" class="btn-close btn-close-white"
                                data-bs-dismiss="modal"></button>
                    </div>
                    <form action="${pageContext.request.contextPath}/user/cv/upload" method="post"
                          enctype="multipart/form-data">
                        <div class="modal-body p-4">
                            <div class="mb-3">
                                <label class="text-white-50 small mb-2">Tên CV gợi nhớ</label>
                                <input type="text" name="cvTitle"
                                       class="form-control bg-dark border-secondary text-white"
                                       placeholder="Ví dụ: CV Java Developer - [Tên của bạn]" required>
                            </div>
                            <div class="mb-3">
                                <label class="text-white-50 small mb-2">Vị trí mong muốn <span
                                        class="text-danger">*</span></label>
                                <input type="text" name="targetRole"
                                       class="form-control bg-dark border-secondary text-white"
                                       placeholder="Ví dụ: Lập trình viên Java, Chuyên viên Marketing..."
                                       required>
                            </div>
                            <div class="switch-container mb-4">
                                <span class="switch-label">Cho phép nhà tuyển dụng tìm thấy CV</span>
                                <label class="switch">
                                    <input type="checkbox" name="isSearchable" value="1" checked>
                                    <span class="slider"></span>
                                </label>
                            </div>
                            <div class="upload-zone p-4 rounded-3 text-center mb-3"
                                 onclick="document.getElementById('cvFileInput').click()">
                                <i class="bi bi-file-earmark-pdf text-primary fs-1"></i>
                                <input type="file" name="cvFile" id="cvFileInput" class="d-none"
                                       accept=".pdf" required onchange="updateFileName(this)">
                                <div class="mt-2">
                                    <span class="text-white d-block" id="fileNameLabel">Chọn file PDF từ
                                        thiết bị</span>
                                    <span class="text-secondary small">Dung lượng tối đa 5MB</span>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer border-0">
                            <button type="button" class="btn btn-link text-secondary text-decoration-none"
                                    data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-primary px-4">Tải lên</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                           function updateFileName(input) {
                                               const label = document.getElementById('fileNameLabel');
                                               if (input.files && input.files[0]) {
                                                   label.innerText = "Đã chọn: " + input.files[0].name;
                                                   label.classList.add('text-primary', 'fw-bold');
                                               }
                                           }

                                           function showLimitAlert() {
                                               alert("⚠️ Bạn đã đạt giới hạn 10 hồ sơ. Vui lòng xóa bớt để tiếp tục.");
                                           }

                                           function confirmDelete(cvId, cvTitle) {
                                               if (confirm("Bạn có chắc chắn muốn xóa hồ sơ: " + cvTitle + "?")) {
                                                   window.location.href = "${pageContext.request.contextPath}/user/cv/delete?id=" + cvId;
                                               }
                                           }

                                           function filterCVs() {
                                               let input = document.getElementById('cvSearch').value.toLowerCase();
                                               let cards = document.getElementsByClassName('cv-item-card');
                                               for (let card of cards) {
                                                   let title = card.getAttribute('data-title');
                                                   card.style.display = title.includes(input) ? "" : "none";
                                               }
                                           }

                                           function applyFilter(filterType, btn) {
                                               document.querySelectorAll('.filter-pill').forEach(b => b.classList.remove('active'));
                                               btn.classList.add('active');

                                               let cards = document.getElementsByClassName('cv-item-card');
                                               for (let card of cards) {
                                                   let source = card.getAttribute('data-source');
                                                   let status = card.getAttribute('data-status');

                                                   if (filterType === 'all') {
                                                       card.style.display = "";
                                                   } else if (filterType === 'accepted') {
                                                       card.style.display = (status === 'accepted') ? "" : "none";
                                                   } else {
                                                       card.style.display = (source === filterType) ? "" : "none";
                                                   }
                                               }
                                           }
        </script>
    </body>

</html>
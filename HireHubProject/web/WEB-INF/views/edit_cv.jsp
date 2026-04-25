<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Chỉnh sửa CV - HireHub</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <style>
            /* Kế thừa các style từ mẫu của bạn */
            .avatar-upload-container {
                display: flex;
                align-items: center;
                gap: 25px;
                margin-bottom: 25px;
                padding: 20px;
                background: rgba(255, 255, 255, 0.6);
                border-radius: 15px;
                border: 1px dashed #4A90E2;
            }
            .avatar-preview {
                width: 110px;
                height: 110px;
                border-radius: 50%;
                object-fit: cover;
                border: 4px solid #fff;
                box-shadow: 0 4px 12px rgba(0,0,0,0.15);
                transition: all 0.3s ease;
                cursor: pointer;
            }
            .avatar-preview:hover {
                transform: scale(1.05);
            }

            .modal-save {
                display: none;
                position: fixed;
                z-index: 1000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0,0,0,0.6);
                backdrop-filter: blur(5px);
            }
            .modal-content {
                background-color: #fff;
                margin: 10% auto;
                padding: 30px;
                border-radius: 20px;
                width: 450px;
                animation: modalFadeIn 0.3s ease;
            }
            @keyframes modalFadeIn {
                from {
                    transform: translateY(-50px);
                    opacity: 0;
                }
                to {
                    transform: translateY(0);
                    opacity: 1;
                }
            }
            .action-bar {
                display: flex;
                gap: 15px;
                margin-top: 35px;
            }
            /* CSS cho bộ chọn Template */
            .template-selector {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 20px;
                margin-top: 15px;
            }
            .template-card {
                position: relative;
                border: 2px solid #eee;
                border-radius: 12px;
                padding: 10px;
                cursor: pointer;
                transition: all 0.3s ease;
                text-align: center;
                background: #fff;
            }
            .template-card:hover {
                border-color: #4A90E2;
                transform: translateY(-5px);
            }
            .template-card.active {
                border-color: #4CAF50;
                background: #f0f9f0;
            }
            .template-card img {
                width: 100%;
                height: 250px;
                object-fit: cover;
                border-radius: 8px;
                margin-bottom: 10px;
            }
            .template-card input[type="radio"] {
                display: none; /* Ẩn nút radio mặc định */
            }
            .template-name {
                font-weight: 700;
                color: #333;
            }
            .check-badge {
                position: absolute;
                top: 10px;
                right: 10px;
                background: #4CAF50;
                color: white;
                width: 25px;
                height: 25px;
                border-radius: 50%;
                display: none;
                align-items: center;
                justify-content: center;
                font-size: 14px;
            }
            .template-card.active .check-badge {
                display: flex;
            }
            /* Nút gạt tùy chỉnh trong Modal */
            .modal-status-row {
                display: flex;
                align-items: center;
                justify-content: space-between;
                margin-top: 20px;
                padding: 12px 15px;
                background: #f9f9f9;
                border-radius: 10px;
            }

            .switch {
                position: relative;
                display: inline-block;
                width: 44px;
                height: 22px;
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
                background-color: #ccc;
                transition: .4s;
                border-radius: 22px;
            }

            .slider:before {
                position: absolute;
                content: "";
                height: 16px;
                width: 16px;
                left: 3px;
                bottom: 3px;
                background-color: white;
                transition: .4s;
                border-radius: 50%;
            }

            input:checked + .slider {
                background-color: #4CAF50;
            }
            input:checked + .slider:before {
                transform: translateX(22px);
            }

            .modal-status-label {
                font-size: 0.95rem;
                color: #333;
                font-weight: 600;
            }
        </style>
    </head>
    <body class="app-page">
        <div class="bg-decoration">
            <div class="bg-circle bg-circle-1"></div>
            <div class="bg-circle bg-circle-2"></div>
        </div>

        <div class="container form-container" style="position: relative; z-index: 10; padding-top: 50px; padding-bottom: 50px;">
            <div class="header-mb" style="margin-bottom: 40px; text-align: center;">
                <h1 class="text-gradient" style="font-size: 2.5rem; font-weight: 800; margin-bottom: 10px;">📝 Chỉnh sửa hồ sơ</h1>
                <p class="logo-subtitle">Đang chỉnh sửa bản: <span class="auth-link">${cv.cvTitle}</span></p>
            </div>

            <%-- Action sẽ gửi về Servlet xử lý Update --%>
            <form id="cvForm" action="${pageContext.request.contextPath}/user/cv/update" method="POST" enctype="multipart/form-data" class="edit-form">
                <%-- Các hidden fields quan trọng --%>
                <input type="hidden" name="cvId" value="${cv.userCVId}">
                <input type="hidden" name="currentAvatarUrl" value="${cv.avatarUrl}">
                <input type="hidden" name="cvTitle" id="finalCvTitle" value="${cv.cvTitle}">
                <input type="hidden" name="formAction" id="formAction" value="update">
                <input type="hidden" name="isSearchable" id="finalIsSearchable" value="${cv.isSearchable}">

                <%-- SECTION 1: THÔNG TIN CƠ BẢN --%>
                <div class="form-section animate-fadeInUp">
                    <h3>👤 Thông tin cơ bản</h3>
                    <div class="avatar-upload-container">
                        <img id="previewImg" 
                             src="${not empty cv.avatarUrl ? cv.avatarUrl : pageContext.request.contextPath.concat('/images/default-avatar.png')}" 
                             class="avatar-preview" onclick="document.getElementById('avatarInput').click()">
                        <div class="upload-controls">
                            <label class="form-label">Ảnh đại diện</label>
                            <input type="file" name="avatarFile" id="avatarInput" class="form-input" accept="image/*" onchange="previewImage(this)">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Họ và tên <span class="required">*</span></label>
                        <input type="text" name="fullName" class="form-input" value="${cv.fullName}" required>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Vị trí ứng tuyển <span class="required">*</span></label>
                            <input type="text" name="targetRole" class="form-input" value="${cv.targetRole}" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Ngày sinh</label>
                            <input type="date" name="birthDate" class="form-input" value="${cv.birthDate}">
                        </div>
                    </div>
                </div>

                <%-- SECTION 2: LIÊN HỆ --%>
                <div class="form-section animate-fadeInUp">
                    <h3>📞 Liên hệ</h3>
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Số điện thoại <span class="required">*</span></label>
                            <input type="tel" name="phone" class="form-input" value="${cv.phone}" required pattern="^(0|84)(3|5|7|8|9)([0-9]{8})$">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Email <span class="required">*</span></label>
                            <input type="email" name="email" class="form-input" value="${cv.email}" required>
                        </div>
                    </div>
                </div>

                <%-- SECTION 3: NỘI DUNG CHI TIẾT --%>
                <div class="form-section animate-fadeInUp">
                    <h3>🎯 Mục tiêu & Kinh nghiệm</h3>
                    <div class="form-group">
                        <label class="form-label">Mục tiêu nghề nghiệp</label>
                        <textarea name="objective" class="form-input" rows="3">${cv.summary}</textarea>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Học vấn</label>
                        <textarea name="educationRaw" class="form-input" rows="4">${cv.educationRaw}</textarea>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Kinh nghiệm làm việc</label>
                        <textarea name="experienceDetail" class="form-input" rows="6">${cv.experienceRaw}</textarea>
                    </div>
                </div>

                <%-- SECTION: CHỌN MẪU GIAO DIỆN --%>
                <div class="form-section animate-fadeInUp">
                    <h3>🎨 Chọn mẫu giao diện CV</h3>
                    <div class="template-selector">
                        <c:forEach items="${listT}" var="t">
                            <label class="template-card ${cv.templateId == t.templateId ? 'active' : ''}" id="card-${t.templateId}">
                                <div class="check-badge">✓</div>

                                <%-- Input radio thực tế sẽ lưu TemplateId vào DB --%>
                                <input type="radio" name="templateId" value="${t.templateId}" 
                                       ${cv.templateId == t.templateId ? 'checked' : ''} 
                                       onchange="updateTemplateSelection(this, ${t.templateId})">

                                <%-- Hiển thị ImageThumbnail từ Cloudinary --%>
                                <img src="${t.imageThumbnail}" alt="${t.name}">

                                <%-- Hiển thị tên (Thanh Lịch, Tiêu Chuẩn, Tham Vọng) --%>
                                <div class="template-name">${t.name}</div>
                            </label>
                        </c:forEach>
                    </div>
                </div>

                <%-- ACTIONS --%>
                <div class="action-bar animate-slideDown">
                    <button type="button" onclick="openSaveModal()" class="btn btn-primary" style="flex: 2; background: #4CAF50;">
                        💾 Cập nhật thay đổi
                    </button>
                    <a href="${pageContext.request.contextPath}/user/cv/manage_cv" 
                       class="btn btn-outline" style="flex: 1; text-align: center; border: 1px solid #ccc; text-decoration: none; display: flex; align-items: center; justify-content: center;">
                        Hủy bỏ
                    </a>
                </div>
            </form>
        </div>

        <%-- MODAL XÁC NHẬN TÊN CV & TRẠNG THÁI --%>
        <div id="saveCvModal" class="modal-save">
            <div class="modal-content">
                <div class="modal-header" style="text-align: center; margin-bottom: 20px;">
                    <h3>Hoàn tất chỉnh sửa</h3>
                    <p style="color: #666;">Vui lòng kiểm tra lại các thiết lập cuối cùng</p>
                </div>

                <%-- 1. Đổi tên CV --%>
                <div class="form-group">
                    <label class="form-label">Tên gợi nhớ cho CV</label>
                    <input type="text" id="modalCvTitle" class="form-input" value="${cv.cvTitle}">
                </div>

                <%-- 2. Cho phép tìm kiếm (isSearchable) --%>
                <div class="modal-status-row">
                    <div class="modal-status-label">
                        🌐 Cho phép tìm kiếm hồ sơ
                    </div>
                    <label class="switch">
                        <%-- Chỗ này lấy giá trị hiện tại từ Object cv --%>
                        <input type="checkbox" id="modalSearchableToggle" ${cv.isSearchable == 1 ? 'checked' : ''}>
                        <span class="slider"></span>
                    </label>
                </div>

                <div class="modal-footer" style="display: flex; gap: 10px; margin-top: 25px;">
                    <button type="button" onclick="closeSaveModal()" class="btn btn-outline" style="flex: 1;">
                        Quay lại
                    </button>
                    <button type="button" onclick="confirmSave()" class="btn btn-primary" style="flex: 2; background: #4CAF50;">
                        Xác nhận Lưu
                    </button>
                </div>
            </div>
        </div>

        
        

        <script>
            function previewImage(input) {
                if (input.files && input.files[0]) {
                    var reader = new FileReader();
                    reader.onload = function (e) {
                        document.getElementById('previewImg').src = e.target.result;
                    }
                    reader.readAsDataURL(input.files[0]);
                }
            }

            function openSaveModal() {
                if (document.getElementById('cvForm').checkValidity()) {
                    document.getElementById('saveCvModal').style.display = 'block';
                } else {
                    document.getElementById('cvForm').reportValidity();
                }
            }

            function closeSaveModal() {
                document.getElementById('saveCvModal').style.display = 'none';
            }

            function confirmSave() {
                const newTitle = document.getElementById('modalCvTitle').value;
                const isSearchableChecked = document.getElementById('modalSearchableToggle').checked;
                if (newTitle.trim() === "") {
                    alert("Vui lòng nhập tên CV");
                    return;
                }
                document.getElementById('finalCvTitle').value = newTitle;
                document.getElementById('finalIsSearchable').value = isSearchableChecked ? "1" : "0";
                document.getElementById('cvForm').submit();
            }
            function updateTemplateSelection(radio, templateId) {
                // Xóa class active ở tất cả các card
                document.querySelectorAll('.template-card').forEach(card => {
                    card.classList.remove('active');
                });

                // Thêm class active cho card vừa chọn
                if (radio.checked) {
                    document.getElementById('card-' + templateId).classList.add('active');
                }
            }
        </script>
    </body>
</html>
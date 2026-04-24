<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Hoàn thiện CV - HireHub</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <style>
            /* Các style cũ của bạn giữ nguyên */
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
                box-shadow: 0 6px 20px rgba(74, 144, 226, 0.3);
            }
            .preview-loading {
                opacity: 0.5;
                filter: blur(2px);
            }
            .upload-hint {
                font-size: 0.8rem;
                color: #6c757d;
                margin-top: 8px;
            }
            .action-bar {
                display: flex;
                gap: 15px;
                margin-top: 35px;
                padding-bottom: 20px;
            }
            .form-input:invalid:focus {
                border-color: #ff4d4f;
                box-shadow: 0 0 0 2px rgba(255, 77, 79, 0.2);
            }

            /* STYLE MỚI CHO MODAL LƯU CV */
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
                box-shadow: 0 10px 40px rgba(0,0,0,0.2);
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
            .modal-header {
                margin-bottom: 20px;
                text-align: center;
            }
            .modal-header h3 {
                color: #333;
                font-size: 1.5rem;
                margin: 0;
            }
            .modal-footer {
                display: flex;
                gap: 10px;
                margin-top: 25px;
            }
            /* Style cho nút gạt Toggle Switch */
            .switch-container {
                display: flex;
                align-items: center;
                justify-content: space-between;
                background: #f8f9fa;
                padding: 12px 15px;
                border-radius: 12px;
                margin-top: 15px;
                border: 1px solid #eee;
            }

            .switch {
                position: relative;
                display: inline-block;
                width: 50px;
                height: 24px;
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

            input:checked + .slider {
                background-color: #4A90E2;
            }

            input:checked + .slider:before {
                transform: translateX(26px);
            }

            .switch-label {
                font-size: 0.9rem;
                color: #444;
                font-weight: 500;
            }
        </style>
    </head>
    <body class="app-page">

        <div class="bg-decoration">
            <div class="bg-circle bg-circle-1"></div>
            <div class="bg-circle bg-circle-2"></div>
            <div class="bg-circle bg-circle-3"></div>
        </div>

        <div class="container form-container" style="position: relative; z-index: 10;">
            <div class="header-mb" style="margin-bottom: 40px; text-align: center;">
                <h1 class="text-gradient" style="font-size: 2.5rem; font-weight: 800; margin-bottom: 10px;">✍️ Hoàn thiện hồ sơ</h1>
                <p class="logo-subtitle">Mẫu thiết kế: <span class="auth-link">${selectedTemplate.name}</span></p>
            </div>

            <form id="cvForm" action="${pageContext.request.contextPath}/user/cv/preview" method="POST" enctype="multipart/form-data" class="edit-form">
                <input type="hidden" name="templateId" value="${selectedTemplate.id}">
                <input type="hidden" name="currentAvatarUrl" value="${userBase.avatarUrl}">
                <input type="hidden" name="cvTitle" id="finalCvTitle">
                <input type="hidden" name="formAction" id="formAction" value="preview">
                <input type="hidden" name="isSearchable" id="finalIsSearchable" value="0">

                <%-- SECTION 1: THÔNG TIN CƠ BẢN --%>
                <div class="form-section animate-fadeInUp">
                    <h3>👤 Thông tin cơ bản</h3>
                    <div class="avatar-upload-container">
                        <img id="previewImg" 
                             src="${userBase.avatarUrl != null ? userBase.avatarUrl : pageContext.request.contextPath.concat('/images/default-avatar.png')}" 
                             alt="Avatar Preview" class="avatar-preview" title="Click để đổi ảnh">
                        <div class="upload-controls">
                            <label class="form-label">Ảnh đại diện chân dung</label>
                            <input type="file" name="avatarFile" id="avatarInput" class="form-input" accept="image/*" onchange="previewImage(this)">
                            <p class="upload-hint">* Định dạng JPG, PNG. Tối đa 2MB.</p>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Họ và tên <span class="required">*</span></label>
                        <input type="text" name="fullName" class="form-input" value="${userBase.fullName}" 
                               required minlength="3" pattern="^[a-zA-ZÀ-ỹ\s]+$" title="Họ tên chỉ chứa chữ cái">
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Vị trí mong muốn <span class="required">*</span></label>
                            <input type="text" name="targetRole" class="form-input" value="${profile.headline}" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Ngày sinh</label>
                            <input type="date" name="birthDate" id="birthDate" class="form-input" value="${userBase.dateOfBirth}">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Giới tính</label>
                        <select name="gender" class="form-input">
                            <option value="Nam" ${userBase.gender == 'Nam' ? 'selected' : ''}>Nam</option>
                            <option value="Nữ" ${userBase.gender == 'Nữ' ? 'selected' : ''}>Nữ</option>
                            <option value="Khác" ${userBase.gender == 'Khác' ? 'selected' : ''}>Khác</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Địa chỉ</label>
                        <input type="text" name="address" class="form-input" value="${profile.currentLocationName}">
                    </div>
                </div>

                <%-- SECTION 2: LIÊN HỆ --%>
                <div class="form-section animate-fadeInUp" style="animation-delay: 0.1s;">
                    <h3>📞 Thông tin liên hệ</h3>
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Số điện thoại <span class="required">*</span></label>
                            <input type="tel" name="phone" id="phoneInput" class="form-input" value="${userBase.phoneNumber}" 
                                   required 
                                   pattern="^(0|84)(3|5|7|8|9)([0-9]{8})$" 
                                   title="Vui lòng nhập số điện thoại Việt Nam hợp lệ">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Email cá nhân <span class="required">*</span></label>
                            <input type="email" name="email" class="form-input" value="${userBase.email}" required>
                        </div>
                    </div>
                </div>

                <%-- SECTION 3: MỤC TIÊU --%>
                <div class="form-section animate-fadeInUp" style="animation-delay: 0.2s;">
                    <h3>🎯 Mục tiêu nghề nghiệp</h3>
                    <div class="form-group">
                        <textarea name="objective" class="form-input" rows="4" placeholder="Chia sẻ dự định...">${profile.summary}</textarea>
                    </div>
                </div>

                <%-- SECTION 4 & 5: HỌC VẤN & KINH NGHIỆM --%>
                <div class="form-section animate-fadeInUp" style="animation-delay: 0.3s;">
                    <h3>🎓 Học vấn</h3>
                    <textarea name="educationRaw" class="form-input" rows="5"><c:forEach var="edu" items="${listEdu}">${edu.schoolName} - (<fmt:formatDate value="${edu.startDate}" pattern="yyyy"/> - ${edu.endDate != null ? '' : 'Hiện tại'}<fmt:formatDate value="${edu.endDate}" pattern="yyyy"/>)&#10;${edu.major} - GPA: ${edu.gpa}&#10;${edu.description}&#10;&#10;</c:forEach></textarea>
                    </div>

                    <div class="form-section animate-fadeInUp" style="animation-delay: 0.4s;">
                        <h3>💼 Kinh nghiệm làm việc</h3>
                        <textarea name="experienceDetail" class="form-input" rows="7"><c:forEach var="exp" items="${listExp}">${exp.startDate} - ${exp.isCurrentJob ? 'Hiện tại' : exp.endDate}: ${exp.companyName}&#10;${exp.description}&#10;&#10;</c:forEach></textarea>
                    </div>

                <%-- ACTIONS --%>
                <div class="action-bar animate-slideDown">
                    <button type="button" onclick="openSaveModal()" class="btn btn-secondary" style="flex: 1;">💾 Lưu CV</button>
                    <button type="submit" onclick="setAction('preview')" class="btn btn-primary" style="flex: 2;">👁️ Xem trước</button>
                    <a href="${pageContext.request.contextPath}/user/cv_template" class="btn btn-outline" style="flex: 1; text-align: center;">Hủy</a>
                </div>
            </form>
        </div>

        <div id="saveCvModal" class="modal-save">
            <div class="modal-content">
                <div class="modal-header">
                    <h3>💾 Lưu CV của bạn</h3>
                    <p style="color: #666; font-size: 0.9rem; margin-top: 5px;">Đặt tên để dễ dàng quản lý trong danh sách CV.</p>
                </div>
                <div class="form-group">
                    <label class="form-label">Tên CV <span class="required">*</span></label>
                    <input type="text" id="modalCvTitle" class="form-input" placeholder="Ví dụ: CV Java Web Backend - Nguyễn Văn A" required>
                </div>
                <div class="switch-container">
                    <span class="switch-label">Cho phép nhà tuyển dụng tìm thấy CV</span>
                    <label class="switch">
                        <input type="checkbox" id="modalSearchable" checked>
                        <span class="slider"></span>
                    </label>
                </div>
                <div class="modal-footer">
                    <button type="button" onclick="closeSaveModal()" class="btn btn-outline" style="flex: 1;">Hủy</button>
                    <button type="button" onclick="confirmSave()" class="btn btn-primary" style="flex: 2; background: #FF9800;">Xác nhận Lưu</button>
                </div>
            </div>
        </div>

        <script>
            const cvForm = document.getElementById('cvForm');

            // Hàm chuyển đổi action ẩn
            function setAction(action) {
                document.getElementById('formAction').value = action;
            }

            // MODAL LOGIC
            function openSaveModal() {
                // Kiểm tra validate form cơ bản trước khi mở modal
                if (cvForm.checkValidity()) {
                    document.getElementById('saveCvModal').style.display = 'block';
                } else {
                    cvForm.reportValidity(); // Hiện lỗi validate nếu chưa điền đủ
                }
            }

            function closeSaveModal() {
                document.getElementById('saveCvModal').style.display = 'none';
            }

            function confirmSave() {
                const titleInput = document.getElementById('modalCvTitle');
                const title = titleInput.value.trim();

                if (!title) {
                    alert("Vui lòng nhập tên CV!");
                    titleInput.focus();
                    return;
                }

                // Lấy giá trị từ checkbox Toggle
                const isSearchableChecked = document.getElementById('modalSearchable').checked;

                // Gán dữ liệu vào các input ẩn trong form chính
                document.getElementById('finalCvTitle').value = title;
                document.getElementById('finalIsSearchable').value = isSearchableChecked ? "1" : "0";
                document.getElementById('formAction').value = 'save';

                // Gửi form đi
                console.log("Đang gửi form...");
                cvForm.submit();
            }

            // Đóng modal khi click ra ngoài
            window.onclick = function (event) {
                const modal = document.getElementById('saveCvModal');
                if (event.target == modal)
                    closeSaveModal();
            }

            // Xử lý validate khi Submit (Chỉ dùng cho nút "Xem trước")
            cvForm.addEventListener('submit', function (e) {
                const action = document.getElementById('formAction').value;

                // Nếu đang thực hiện hành động Lưu, ta đã validate ở modal rồi nên bỏ qua listener này
                if (action === 'save')
                    return;

                const phone = document.getElementById('phoneInput').value.trim();
                const birthDate = document.getElementById('birthDate').value;
                const today = new Date().toISOString().split('T')[0];

                const phoneRegex = /^(0|84)(3|5|7|8|9)([0-9]{8})$/;
                if (!phoneRegex.test(phone)) {
                    alert("Số điện thoại không đúng định dạng Việt Nam.");
                    e.preventDefault();
                    return;
                }

                if (birthDate && birthDate > today) {
                    alert("Ngày sinh không thể lớn hơn ngày hiện tại.");
                    e.preventDefault();
                    return;
                }
            });

            // Preview ảnh
            function previewImage(input) {
                const preview = document.getElementById('previewImg');
                const file = input.files[0];
                if (file) {
                    const validTypes = ['image/jpeg', 'image/png', 'image/jpg'];
                    if (!validTypes.includes(file.type)) {
                        alert("Chỉ chấp nhận ảnh JPG, PNG.");
                        input.value = "";
                        return;
                    }
                    if (file.size > 2 * 1024 * 1024) { // Chỉnh lại cho khớp với hint 2MB
                        alert("Ảnh không được vượt quá 2MB.");
                        input.value = "";
                        return;
                    }
                    const reader = new FileReader();
                    preview.classList.add('preview-loading');
                    reader.onload = (e) => {
                        preview.src = e.target.result;
                        preview.classList.remove('preview-loading');
                    };
                    reader.readAsDataURL(file);
                }
            }

            document.getElementById('previewImg').onclick = () => document.getElementById('avatarInput').click();
            document.getElementById('birthDate').max = new Date().toISOString().split('T')[0];
        </script>
    </body>
</html>
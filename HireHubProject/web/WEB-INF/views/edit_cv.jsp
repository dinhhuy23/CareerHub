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
            .template-name {
                font-weight: 700; color: #333;
                font-size: 1rem; margin-top: 12px;
            }
            /* ===== TEMPLATE CAROUSEL (multi-slide) ===== */
            .template-carousel-wrap {
                position: relative; margin-top: 16px;
                user-select: none; padding: 0 52px;
            }
            .template-viewport {
                overflow: hidden; width: 100%;
            }
            .template-track {
                display: flex;
                transition: transform 0.38s cubic-bezier(.4,0,.2,1);
                will-change: transform;
            }
            /* Moi slide chiem 1/3 viewport (3 cot) */
            .template-slide {
                flex: 0 0 calc(100% / 3);
                box-sizing: border-box;
                padding: 0 10px;
            }
            @media (max-width: 768px) {
                .template-slide { flex: 0 0 50%; }
                .template-carousel-wrap { padding: 0 44px; }
            }
            @media (max-width: 480px) {
                .template-slide { flex: 0 0 100%; }
            }
            /* Arrow buttons */
            .carousel-arrow {
                position: absolute; top: 50%; transform: translateY(-50%);
                background: rgba(74,144,226,0.13);
                border: 2px solid rgba(74,144,226,0.35);
                color: #4A90E2; border-radius: 50%;
                width: 42px; height: 42px;
                display: flex; align-items: center; justify-content: center;
                cursor: pointer; font-size: 1.2rem; z-index: 10;
                transition: all 0.2s;
            }
            .carousel-arrow:hover:not(:disabled) {
                background: rgba(74,144,226,0.28); border-color: #4A90E2;
                transform: translateY(-50%) scale(1.05);
            }
            .carousel-arrow.left  { left:  0; }
            .carousel-arrow.right { right: 0; }
            .carousel-arrow:disabled { opacity: 0.2; cursor: default; pointer-events: none; }
            /* Card ben trong slide */
            .tpl-card {
                width: 100%;
                border: 3px solid #e0e0e0; border-radius: 14px;
                padding: 10px; text-align: center;
                background: #fff; cursor: pointer;
                transition: border-color 0.25s, box-shadow 0.25s, transform 0.2s;
                position: relative;
            }
            .tpl-card:hover   { transform: translateY(-4px); border-color: #4A90E2; }
            .tpl-card.active  { border-color: #4CAF50; box-shadow: 0 8px 24px rgba(76,175,80,0.22); }
            /* Anh to hon, khong bi bop */
            .tpl-card img {
                width: 100%;
                height: 380px;
                object-fit: contain;
                object-position: top;
                border-radius: 8px;
                background: #f5f5f5;
            }
            .tpl-check {
                position: absolute; top: 10px; right: 10px;
                background: #4CAF50; color: #fff;
                width: 28px; height: 28px; border-radius: 50%;
                display: none; align-items: center; justify-content: center;
                font-size: 15px; font-weight: 700; box-shadow: 0 2px 8px rgba(0,0,0,0.15);
            }
            .tpl-card.active .tpl-check { display: flex; }
            /* Dots */
            .carousel-dots {
                display: flex; justify-content: center;
                gap: 7px; margin-top: 14px;
            }
            .carousel-dot {
                width: 9px; height: 9px; border-radius: 50%;
                background: #ccc; cursor: pointer; border: none; padding: 0;
                transition: background 0.2s, transform 0.2s;
            }
            .carousel-dot.active { background: #4A90E2; transform: scale(1.35); }
            .carousel-counter {
                text-align: center; font-size: 0.82rem;
                color: #999; margin-top: 6px;
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

                <%-- SECTION: CHON MAU GIAO DIEN --%>
                <div class="form-section animate-fadeInUp">
                    <h3>&#127912; Ch&#7885;n m&#7851;u giao di&#7879;n CV</h3>

                    <div class="template-carousel-wrap">
                        <button type="button" class="carousel-arrow left" id="arrowLeft"
                                onclick="slideTemplate(-1)">&#8592;</button>

                        <div class="template-viewport">
                            <div class="template-track" id="tplTrack">
                                <c:forEach items="${listT}" var="t" varStatus="vs">
                                    <div class="template-slide">
                                        <div class="tpl-card ${cv.templateId == t.templateId ? 'active' : ''}"
                                             id="tplCard-${t.templateId}"
                                             onclick="selectTemplate(${t.templateId})">
                                            <div class="tpl-check">&#10003;</div>
                                            <img src="${t.imageThumbnail}" alt="${t.name}">
                                            <div class="template-name">${t.name}</div>
                                            <input type="radio" name="templateId" value="${t.templateId}"
                                                   id="radio-${t.templateId}"
                                                   ${cv.templateId == t.templateId ? 'checked' : ''}
                                                   style="display:none;">
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>

                        <button type="button" class="carousel-arrow right" id="arrowRight"
                                onclick="slideTemplate(1)">&#8594;</button>
                    </div>

                    <div class="carousel-dots" id="tplDots"></div>
                    <div class="carousel-counter" id="tplCounter"></div>
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
            /* ===== TEMPLATE CAROUSEL (multi-slide) ===== */
            (function() {
                var track    = document.getElementById('tplTrack');
                var slides   = document.querySelectorAll('.template-slide');
                var dotsWrap = document.getElementById('tplDots');
                var counter  = document.getElementById('tplCounter');
                var arrowL   = document.getElementById('arrowLeft');
                var arrowR   = document.getElementById('arrowRight');
                var total    = slides.length;
                var current  = 0;

                function getPerView() {
                    if (window.innerWidth <= 480) return 1;
                    if (window.innerWidth <= 768) return 2;
                    return 3;
                }
                function maxOffset() { return Math.max(0, total - getPerView()); }

                function goTo(idx) {
                    var pv  = getPerView();
                    var max = maxOffset();
                    idx = Math.max(0, Math.min(idx, max));
                    current = idx;
                    track.style.transform = 'translateX(-' + (100 / pv * idx) + '%)';
                    arrowL.disabled = (idx === 0);
                    arrowR.disabled = (idx >= max);
                    var pageIdx   = Math.floor(idx / pv);
                    var pageCount = Math.ceil(total / pv);
                    document.querySelectorAll('.carousel-dot').forEach(function(d, i) {
                        d.classList.toggle('active', i === pageIdx);
                    });
                    counter.textContent = (pageIdx + 1) + ' / ' + pageCount;
                }

                function buildDots() {
                    dotsWrap.innerHTML = '';
                    var pv        = getPerView();
                    var pageCount = Math.ceil(total / pv);
                    for (var i = 0; i < pageCount; i++) {
                        var d = document.createElement('button');
                        d.type = 'button'; d.className = 'carousel-dot';
                        (function(pi) { d.onclick = function() { goTo(pi * getPerView()); }; })(i);
                        dotsWrap.appendChild(d);
                    }
                }

                // Khoi tao: tim slide co template dang active
                var startIdx = 0;
                slides.forEach(function(s, i) {
                    if (s.querySelector('.tpl-card.active')) startIdx = i;
                });
                buildDots();
                goTo(Math.floor(startIdx / getPerView()) * getPerView());

                window.addEventListener('resize', function() { buildDots(); goTo(current); });

                window.slideTemplate = function(dir) { goTo(current + dir); };

                window.selectTemplate = function(tplId) {
                    document.querySelectorAll('.tpl-card').forEach(function(c) { c.classList.remove('active'); });
                    var card  = document.getElementById('tplCard-' + tplId);
                    var radio = document.getElementById('radio-' + tplId);
                    if (card)  card.classList.add('active');
                    if (radio) radio.checked = true;
                };
            })();
        </script>
    </body>
</html>
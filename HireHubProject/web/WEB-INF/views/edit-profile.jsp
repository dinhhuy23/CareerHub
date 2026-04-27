<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh sửa hồ sơ - HireHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .section-divider {
            display: flex;
            align-items: center;
            gap: 14px;
            margin: 28px 0 20px;
        }
        .section-divider .divider-line {
            flex: 1;
            height: 1px;
            background: var(--border-color);
        }
        .section-divider .divider-label {
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: var(--text-muted);
            white-space: nowrap;
        }

        .login-email-box {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 14px 18px;
            border-radius: 12px;
            background: rgba(99,102,241,0.06);
            border: 1px solid rgba(99,102,241,0.2);
        }
        .login-email-box .lock-icon {
            color: var(--primary);
            flex-shrink: 0;
        }
        .login-email-box .email-display {
            font-weight: 600;
            color: var(--text-primary);
            font-size: 0.95rem;
            word-break: break-all;
        }
        .login-email-box .email-note {
            font-size: 0.78rem;
            color: var(--text-muted);
            margin-top: 2px;
        }

        .contact-email-hint {
            font-size: 0.8rem;
            color: var(--text-muted);
            margin-top: 6px;
            line-height: 1.5;
        }
        .contact-email-hint strong {
            color: var(--primary);
        }

        /* Validation Styles */
        .error-message {
            color: #ef4444;
            font-size: 0.75rem;
            margin-top: 5px;
            display: none;
            font-weight: 500;
        }
        .form-input.invalid {
            border-color: #ef4444;
            background-color: rgba(239, 68, 68, 0.02);
        }
        .form-input.invalid:focus {
            box-shadow: 0 0 0 4px rgba(239, 68, 68, 0.1);
        }
        .required {
            color: #ef4444;
        }
    </style>
</head>
<body class="app-page">
    <jsp:include page="/WEB-INF/views/header.jsp" />

    <main class="main-content">
        <div class="container">
            <div class="page-header animate-fadeInUp">
                <h1>Chỉnh sửa hồ sơ</h1>
                <a href="${pageContext.request.contextPath}/user/profile" class="btn btn-outline">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/></svg>
                    Quay lại
                </a>
            </div>

            <%-- Thông báo lỗi --%>
            <c:if test="${not empty error}">
                <div class="alert alert-error animate-slideDown">
                    <svg width="20" height="20" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z"/></svg>
                    <span>${error}</span>
                </div>
            </c:if>

            <div class="form-card glass-card animate-fadeInUp" style="animation-delay: 0.1s;">
                <form action="${pageContext.request.contextPath}/user/edit-profile" method="POST" class="edit-form" id="editProfileForm">

                    <%-- ============================================== --%>
                    <%-- PHẦN 1: TÀI KHOẢN ĐĂNG NHẬP (KHÔNG ĐỔI ĐƯỢC) --%>
                    <%-- ============================================== --%>
                    <div class="section-divider">
                        <div class="divider-line"></div>
                        <span class="divider-label">Tài khoản đăng nhập</span>
                        <div class="divider-line"></div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Email đăng nhập</label>
                        <div class="login-email-box">
                            <div class="lock-icon">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                                    <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                                </svg>
                            </div>
                            <div>
                                <div class="email-display">${user.email}</div>
                                <div class="email-note">Email đăng nhập không thể thay đổi để bảo mật tài khoản.</div>
                            </div>
                        </div>
                    </div>

                    <%-- ============================================== --%>
                    <%-- PHẦN 2: THÔNG TIN CÁ NHÂN                     --%>
                    <%-- ============================================== --%>
                    <div class="section-divider">
                        <div class="divider-line"></div>
                        <span class="divider-label">Thông tin cá nhân</span>
                        <div class="divider-line"></div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="fullName" class="form-label">Họ và tên <span class="required">*</span></label>
                            <input type="text" id="fullName" name="fullName" class="form-input"
                                   value="${user.fullName}" required maxlength="150"
                                   placeholder="Nguyễn Văn A">
                            <div class="error-message" id="fullNameError">Họ tên chỉ chứa chữ cái và ít nhất 2 ký tự.</div>
                        </div>

                        <div class="form-group">
                            <label for="phoneNumber" class="form-label">Số điện thoại</label>
                            <input type="tel" id="phoneNumber" name="phoneNumber" class="form-input"
                                   value="${user.phoneNumber}" placeholder="0901234567">
                            <div class="error-message" id="phoneNumberError">Số điện thoại 10 chữ số không hợp lệ (VD: 0912345678).</div>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="gender" class="form-label">Giới tính</label>
                            <select id="gender" name="gender" class="form-input form-select">
                                <option value="">-- Chọn --</option>
                                <option value="Nam"  ${user.gender == 'Nam'  ? 'selected' : ''}>Nam</option>
                                <option value="Nu"   ${user.gender == 'Nu'   ? 'selected' : ''}>Nữ</option>
                                <option value="Khac" ${user.gender == 'Khac' ? 'selected' : ''}>Khác</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="dateOfBirth" class="form-label">Ngày sinh</label>
                            <input type="date" id="dateOfBirth" name="dateOfBirth" class="form-input"
                                   value="<fmt:formatDate value='${user.dateOfBirth}' pattern='yyyy-MM-dd'/>">
                            <div class="error-message" id="dobError">Bạn phải ít nhất 15 tuổi.</div>
                        </div>
                    </div>

                    <%-- ============================================== --%>
                    <%-- PHẦN 3: GMAIL LIÊN HỆ (TÁCH BIỆT)             --%>
                    <%-- ============================================== --%>
                    <div class="section-divider">
                        <div class="divider-line"></div>
                        <span class="divider-label">Gmail liên hệ</span>
                        <div class="divider-line"></div>
                    </div>

                    <div class="form-group">
                        <label for="contactEmail" class="form-label">
                            Gmail liên hệ
                            <span style="font-weight: 400; color: var(--text-muted); font-size: 0.85rem;">(Tùy chọn)</span>
                        </label>
                        <input type="email" id="contactEmail" name="contactEmail" class="form-input"
                               value="${user.contactEmail}"
                               placeholder="example@gmail.com">
                        <div class="error-message" id="contactEmailError">Gmail không hợp lệ hoặc không phải @gmail.com</div>
                        <p class="contact-email-hint">
                            Đây là Gmail dùng để nhà tuyển dụng hoặc hệ thống liên hệ với bạn. 
                            Phải là địa chỉ <strong>@gmail.com</strong> và mỗi tài khoản chỉ được liên kết 
                            <strong>1 Gmail duy nhất</strong>. 
                            Để trống nếu bạn không muốn cung cấp.
                        </p>
                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/user/profile" class="btn btn-outline">Hủy</a>
                        <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                    </div>
                </form>
            </div>
        </div>
    </main>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('editProfileForm');
            const fullName = document.getElementById('fullName');
            const phoneNumber = document.getElementById('phoneNumber');
            const dateOfBirth = document.getElementById('dateOfBirth');
            const contactEmail = document.getElementById('contactEmail');

            // Regex patterns
            const nameRegex = /^[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểếỊỈỊịỉịỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪỬỮỰỵỷỹý\s]{2,150}$/;
            const phoneRegex = /^(\+84|0)[35789][0-9]{8}$/;
            const emailRegex = /^[a-zA-Z0-9._%+-]+@gmail\.com$/;

            function validateField(input, regex, errorId, isRequired = false) {
                const value = input.value.trim();
                const errorEl = document.getElementById(errorId);
                
                if (isRequired && !value) {
                    input.classList.add('invalid');
                    errorEl.textContent = 'Trường này là bắt buộc.';
                    errorEl.style.display = 'block';
                    return false;
                }

                if (value && regex && !regex.test(value)) {
                    input.classList.add('invalid');
                    errorEl.style.display = 'block';
                    return false;
                }

                input.classList.remove('invalid');
                errorEl.style.display = 'none';
                return true;
            }

            function validateDOB() {
                const value = dateOfBirth.value;
                const errorEl = document.getElementById('dobError');
                if (!value) return true;

                const dob = new Date(value);
                const today = new Date();
                let age = today.getFullYear() - dob.getFullYear();
                const m = today.getMonth() - dob.getMonth();
                if (m < 0 || (m === 0 && today.getDate() < dob.getDate())) {
                    age--;
                }

                if (age < 15) {
                    dateOfBirth.classList.add('invalid');
                    errorEl.textContent = 'Bạn phải ít nhất 15 tuổi.';
                    errorEl.style.display = 'block';
                    return false;
                }
                
                if (age > 120) {
                    dateOfBirth.classList.add('invalid');
                    errorEl.textContent = 'Ngày sinh không hợp lệ.';
                    errorEl.style.display = 'block';
                    return false;
                }

                dateOfBirth.classList.remove('invalid');
                errorEl.style.display = 'none';
                return true;
            }

            // Real-time validation
            fullName.addEventListener('input', () => validateField(fullName, nameRegex, 'fullNameError', true));
            phoneNumber.addEventListener('input', () => validateField(phoneNumber, phoneRegex, 'phoneNumberError'));
            contactEmail.addEventListener('input', () => validateField(contactEmail, emailRegex, 'contactEmailError'));
            dateOfBirth.addEventListener('change', validateDOB);

            form.addEventListener('submit', function(e) {
                const isNameValid = validateField(fullName, nameRegex, 'fullNameError', true);
                const isPhoneValid = validateField(phoneNumber, phoneRegex, 'phoneNumberError');
                const isEmailValid = validateField(contactEmail, emailRegex, 'contactEmailError');
                const isDobValid = validateDOB();

                if (!isNameValid || !isPhoneValid || !isEmailValid || !isDobValid) {
                    e.preventDefault();
                    // Scroll to first error
                    const firstError = document.querySelector('.form-input.invalid');
                    if (firstError) firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
                }
            });
        });
    </script>
</body>
</html>

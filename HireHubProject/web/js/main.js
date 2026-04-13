/**
 * HireHub - Main JavaScript
 * Client-side validation, UI interactions, and animations
 */

// ==========================================
// Toggle Password Visibility
// ==========================================
function togglePassword(inputId) {
    const input = document.getElementById(inputId);
    if (!input) return;

    if (input.type === 'password') {
        input.type = 'text';
    } else {
        input.type = 'password';
    }
}

// ==========================================
// User Dropdown Toggle
// ==========================================
function toggleDropdown() {
    const dropdown = document.getElementById('userDropdown');
    if (dropdown) {
        dropdown.classList.toggle('show');
    }
}

// Close dropdown when clicking outside
document.addEventListener('click', function (e) {
    const dropdown = document.getElementById('userDropdown');
    const userBtn = document.querySelector('.user-btn');

    if (dropdown && userBtn && !userBtn.contains(e.target) && !dropdown.contains(e.target)) {
        dropdown.classList.remove('show');
    }
});

// ==========================================
// Password Strength Indicator
// ==========================================
function checkPasswordStrength(password) {
    let score = 0;
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    if (/[a-z]/.test(password)) score++;
    if (/[A-Z]/.test(password)) score++;
    if (/\d/.test(password)) score++;
    if (/[^a-zA-Z0-9]/.test(password)) score++;

    return score;
}

function updateStrengthIndicator(password) {
    const fill = document.getElementById('strengthFill');
    const text = document.getElementById('strengthText');

    if (!fill || !text) return;

    if (!password || password.length === 0) {
        fill.style.width = '0%';
        text.textContent = '';
        return;
    }

    const score = checkPasswordStrength(password);

    let width, color, label;

    if (score <= 2) {
        width = '25%';
        color = '#EF4444';
        label = 'Yếu';
    } else if (score <= 3) {
        width = '50%';
        color = '#F59E0B';
        label = 'Trung bình';
    } else if (score <= 4) {
        width = '75%';
        color = '#3B82F6';
        label = 'Khá';
    } else {
        width = '100%';
        color = '#10B981';
        label = 'Mạnh';
    }

    fill.style.width = width;
    fill.style.background = color;
    text.textContent = label;
    text.style.color = color;
}

// ==========================================
// Form Validation
// ==========================================
function validateEmail(email) {
    const re = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    return re.test(email);
}

function showFieldError(input, message) {
    // Remove existing error
    removeFieldError(input);

    input.style.borderColor = '#EF4444';
    const errorDiv = document.createElement('div');
    errorDiv.className = 'field-error';
    errorDiv.style.cssText = 'color: #EF4444; font-size: 0.8rem; margin-top: 4px;';
    errorDiv.textContent = message;
    input.closest('.form-group').appendChild(errorDiv);
}

function removeFieldError(input) {
    input.style.borderColor = '';
    const existing = input.closest('.form-group').querySelector('.field-error');
    if (existing) existing.remove();
}

// ==========================================
// Initialize Event Listeners
// ==========================================
document.addEventListener('DOMContentLoaded', function () {

    // Password strength monitoring
    const passwordInputs = document.querySelectorAll('#regPassword, #newPassword');
    passwordInputs.forEach(function (input) {
        input.addEventListener('input', function () {
            updateStrengthIndicator(this.value);
        });
    });

    // Registration form validation
    const registerForm = document.getElementById('registerForm');
    if (registerForm) {
        registerForm.addEventListener('submit', function (e) {
            const email = document.getElementById('regEmail');
            const fullName = document.getElementById('fullName');
            const password = document.getElementById('regPassword');
            const confirm = document.getElementById('confirmPassword');
            let valid = true;

            // Clear errors
            [email, fullName, password, confirm].forEach(function (el) {
                if (el) removeFieldError(el);
            });

            if (fullName && fullName.value.trim().length < 2) {
                showFieldError(fullName, 'Họ và tên phải có ít nhất 2 ký tự');
                valid = false;
            }

            if (email && !validateEmail(email.value)) {
                showFieldError(email, 'Email không hợp lệ');
                valid = false;
            }

            if (password && password.value.length < 8) {
                showFieldError(password, 'Mật khẩu phải có ít nhất 8 ký tự');
                valid = false;
            }

            if (confirm && password && confirm.value !== password.value) {
                showFieldError(confirm, 'Mật khẩu xác nhận không khớp');
                valid = false;
            }

            if (!valid) {
                e.preventDefault();
            }
        });
    }

    // Change password form validation
    const changePasswordForm = document.getElementById('changePasswordForm');
    if (changePasswordForm) {
        changePasswordForm.addEventListener('submit', function (e) {
            const newPwd = document.getElementById('newPassword');
            const confirmPwd = document.getElementById('confirmNewPassword');
            let valid = true;

            [newPwd, confirmPwd].forEach(function (el) {
                if (el) removeFieldError(el);
            });

            if (newPwd && newPwd.value.length < 8) {
                showFieldError(newPwd, 'Mật khẩu phải có ít nhất 8 ký tự');
                valid = false;
            }

            if (confirmPwd && newPwd && confirmPwd.value !== newPwd.value) {
                showFieldError(confirmPwd, 'Mật khẩu xác nhận không khớp');
                valid = false;
            }

            if (!valid) {
                e.preventDefault();
            }
        });
    }

    // Auto-hide alerts after 5 seconds
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(function (alert) {
        setTimeout(function () {
            alert.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
            alert.style.opacity = '0';
            alert.style.transform = 'translateY(-10px)';
            setTimeout(function () {
                alert.remove();
            }, 500);
        }, 5000);
    });

    // Add input focus animations
    const inputs = document.querySelectorAll('.form-input');
    inputs.forEach(function (input) {
        input.addEventListener('focus', function () {
            this.closest('.input-wrapper').style.transform = 'scale(1.01)';
            this.closest('.input-wrapper').style.transition = 'transform 0.2s ease';
        });

        input.addEventListener('blur', function () {
            this.closest('.input-wrapper').style.transform = 'scale(1)';
        });
    });
});

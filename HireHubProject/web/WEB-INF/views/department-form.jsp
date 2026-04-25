<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${department != null ? 'Sửa' : 'Thêm'} phòng ban | HireHub Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .df-container {
            max-width: 680px; margin: 0 auto;
            padding: var(--space-xl) var(--space-lg) var(--space-3xl);
        }

        /* ── Back ── */
        .back-link {
            display: inline-flex; align-items: center; gap: 7px;
            color: var(--text-secondary); font-size: 0.875rem;
            text-decoration: none; margin-bottom: var(--space-xl);
            transition: color 0.2s, transform 0.2s;
        }
        .back-link:hover { color: var(--primary-light); transform: translateX(-3px); }

        /* ── Card ── */
        .df-card {
            background: var(--glass-bg); backdrop-filter: var(--glass-blur);
            -webkit-backdrop-filter: var(--glass-blur);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-xl); box-shadow: var(--glass-shadow);
            overflow: hidden;
        }

        /* ── Card header ── */
        .df-card-header {
            padding: var(--space-xl);
            background: linear-gradient(135deg, rgba(99,102,241,0.12), rgba(139,92,246,0.08));
            border-bottom: 1px solid var(--glass-border);
            display: flex; align-items: center; gap: 16px;
        }
        .df-header-icon {
            width: 48px; height: 48px; border-radius: 14px; flex-shrink: 0;
            background: linear-gradient(135deg, var(--primary), var(--accent));
            display: flex; align-items: center; justify-content: center;
            box-shadow: 0 4px 12px rgba(99,102,241,0.4);
        }
        .df-card-title { font-size: 1.3rem; font-weight: 800; color: var(--text-primary); }
        .df-card-subtitle { font-size: 0.85rem; color: var(--text-muted); margin-top: 3px; }

        /* ── Form body ── */
        .df-body { padding: var(--space-xl); display: flex; flex-direction: column; gap: var(--space-lg); }

        /* ── Section title ── */
        .df-section-title {
            font-size: 0.8rem; font-weight: 700; text-transform: uppercase;
            letter-spacing: 0.6px; color: var(--primary-light);
            margin-bottom: var(--space-md); display: flex; align-items: center; gap: 8px;
        }
        .df-section-title::after {
            content: ''; flex: 1; height: 1px;
            background: linear-gradient(90deg, rgba(99,102,241,0.3), transparent);
        }

        /* ── Form group ── */
        .df-group { display: flex; flex-direction: column; gap: 6px; }
        .df-label {
            font-size: 0.82rem; font-weight: 600; color: var(--text-secondary);
            display: flex; align-items: center; gap: 5px;
        }
        .df-label .req { color: var(--error); }

        .df-input, .df-select, .df-textarea {
            width: 100%; padding: 11px 14px;
            background: var(--bg-input); border: 1.5px solid var(--border-color);
            border-radius: var(--radius-md); color: var(--text-primary);
            font-size: 0.9375rem; font-family: var(--font-family);
            transition: all 0.2s; outline: none;
        }
        .df-input:focus, .df-select:focus, .df-textarea:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px var(--primary-50);
        }
        .df-input::placeholder, .df-textarea::placeholder { color: var(--text-muted); }
        .df-textarea { resize: vertical; min-height: 100px; }
        .df-select option { background: var(--bg-secondary); }

        /* ── Char counter ── */
        .df-meta {
            display: flex; justify-content: flex-end;
            min-height: 18px;
        }
        .df-chars { font-size: 0.75rem; color: var(--text-muted); transition: color 0.2s; }
        .df-chars.warn  { color: var(--warning); }
        .df-chars.limit { color: var(--error); font-weight: 600; }

        /* ── Alert ── */
        .df-alert {
            display: flex; align-items: flex-start; gap: 10px;
            padding: 12px 16px; border-radius: var(--radius-md);
            background: var(--error-light); color: var(--error);
            border: 1px solid rgba(239,68,68,0.2);
            font-size: 0.875rem; margin: 0 var(--space-xl);
        }

        /* ── Actions ── */
        .df-actions {
            padding: var(--space-lg) var(--space-xl);
            border-top: 1px solid var(--glass-border);
            display: flex; justify-content: flex-end; gap: 10px;
        }
        .btn-save {
            background: linear-gradient(135deg, var(--primary), var(--accent));
            color: white; padding: 11px 24px;
            border-radius: var(--radius-md); border: none; cursor: pointer;
            font-size: 0.9375rem; font-weight: 700; font-family: var(--font-family);
            display: inline-flex; align-items: center; gap: 8px;
            box-shadow: 0 4px 14px rgba(99,102,241,0.35);
            transition: all 0.2s;
        }
        .btn-save:hover { transform: translateY(-2px); box-shadow: 0 6px 20px rgba(99,102,241,0.45); }
        .btn-cancel {
            padding: 11px 20px; border-radius: var(--radius-md);
            background: var(--glass-bg); border: 1px solid var(--glass-border);
            color: var(--text-secondary); font-size: 0.9375rem; font-weight: 600;
            text-decoration: none; transition: all 0.2s;
            display: inline-flex; align-items: center; gap: 8px;
        }
        .btn-cancel:hover { border-color: var(--primary); color: var(--primary-light); }
    </style>
</head>
<body class="app-page">
    <jsp:include page="/WEB-INF/views/header.jsp" />

    <main class="main-content">
        <!-- Alert Toast -->
        <c:if test="${not empty error}">
            <div id="toast-notification" style="position: fixed; top: 80px; right: 20px; z-index: 9999; 
                        background: var(--glass-bg); backdrop-filter: blur(10px); -webkit-backdrop-filter: blur(10px);
                        border-left: 4px solid var(--error); border-radius: var(--radius-md); 
                        box-shadow: 0 10px 25px rgba(0,0,0,0.2); padding: 16px 20px; 
                        display: flex; align-items: center; gap: 12px; max-width: 350px;
                        animation: slideInRight 0.3s ease-out forwards;">
                <div style="display: flex; align-items: center; justify-content: center; width: 24px; height: 24px; border-radius: 50%; background: var(--error-light); color: var(--error); flex-shrink: 0;">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                        <line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line>
                    </svg>
                </div>
                <div>
                    <div style="font-weight: 600; font-size: 0.9rem; margin-bottom: 2px; color: var(--text-primary);">Lỗi!</div>
                    <div style="font-size: 0.8rem; color: var(--text-muted);"><c:out value="${error}"/></div>
                </div>
            </div>
            <style>
                @keyframes slideInRight {
                    from { transform: translateX(100%); opacity: 0; }
                    to { transform: translateX(0); opacity: 1; }
                }
                @keyframes fadeOutRight {
                    from { transform: translateX(0); opacity: 1; }
                    to { transform: translateX(100%); opacity: 0; }
                }
            </style>
            <script>
                setTimeout(() => {
                    const toast = document.getElementById('toast-notification');
                    if (toast) {
                        toast.style.animation = 'fadeOutRight 0.3s ease-out forwards';
                        setTimeout(() => toast.remove(), 300);
                    }
                }, 5000);
            </script>
        </c:if>
        <div class="df-container animate-fadeInUp">

            <!-- Back -->
            <a href="${pageContext.request.contextPath}/admin/departments" class="back-link">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/>
                </svg>
                Quay lại danh sách
            </a>

            <div class="df-card">
                <!-- Card header -->
                <div class="df-card-header">
                    <div class="df-header-icon">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5">
                            <rect x="2" y="7" width="20" height="14" rx="2"/>
                            <path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/>
                        </svg>
                    </div>
                    <div>
                        <div class="df-card-title">
                            <c:choose>
                                <c:when test="${department != null}">Chỉnh sửa phòng ban</c:when>
                                <c:otherwise>Thêm phòng ban mới</c:otherwise>
                            </c:choose>
                        </div>
                        <div class="df-card-subtitle" style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 500px;">
                            <c:choose>
                                <c:when test="${department != null}">Cập nhật thông tin cho phòng ban <strong><c:out value="${department.departmentName}"/></strong></c:when>
                                <c:otherwise>Điền thông tin để tạo phòng ban mới cho công ty</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>



                <!-- Form -->
                <form action="${pageContext.request.contextPath}/admin/departments" method="post">
                    <input type="hidden" name="id" value="${department.departmentId}">

                    <div class="df-body">
                        <div class="df-section-title">Thông tin phòng ban</div>

                        <!-- Tên phòng ban -->
                        <div class="df-group">
                            <label class="df-label">Tên phòng ban <span class="req">*</span></label>
                            <input type="text" name="departmentName" class="df-input char-input"
                                   value="${department.departmentName}" maxlength="150" data-max="150"
                                   placeholder="VD: Phòng Kỹ thuật, Phòng Marketing..." required>
                            <div class="df-meta">
                                <small class="df-chars">0/150</small>
                            </div>
                        </div>

                        <!-- Công ty -->
                        <div class="df-group">
                            <label class="df-label">Thuộc công ty <span class="req">*</span></label>
                            <select name="companyId" class="df-select" required>
                                <option value="">-- Chọn công ty --</option>
                                <c:forEach var="c" items="${companies}">
                                    <option value="${c.companyId}"
                                            ${c.companyId == department.companyId ? 'selected' : ''}>
                                        <c:out value="${c.companyName}"/>
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Mô tả -->
                        <div class="df-group">
                            <label class="df-label">Mô tả</label>
                            <textarea name="description" class="df-textarea char-input"
                                      rows="4" maxlength="500" data-max="500"
                                      placeholder="Mô tả ngắn về chức năng và nhiệm vụ của phòng ban..."><c:out value="${department.description}"/></textarea>
                            <div class="df-meta">
                                <small class="df-chars">0/500</small>
                            </div>
                        </div>

                        <div class="df-section-title" style="margin-top: var(--space-md);">Thông tin liên hệ & Khác</div>

                        <!-- Tên người quản lý -->
                        <div class="df-group">
                            <label class="df-label">Người quản lý</label>
                            <input type="text" name="managerName" class="df-input char-input"
                                   value="${department.managerName}" maxlength="255" data-max="255"
                                   placeholder="VD: Nguyễn Văn A">
                            <div class="df-meta">
                                <small class="df-chars">0/255</small>
                            </div>
                        </div>

                        <!-- Email liên hệ -->
                        <div class="df-group">
                            <label class="df-label">Email liên hệ</label>
                            <input type="email" name="contactEmail" class="df-input char-input"
                                   value="${department.contactEmail}" maxlength="255" data-max="255"
                                   placeholder="VD: contact@department.com">
                            <div class="df-meta">
                                <small class="df-chars">0/255</small>
                            </div>
                        </div>

                        <!-- Số điện thoại -->
                        <div class="df-group">
                            <label class="df-label">Số điện thoại</label>
                            <input type="text" name="phoneNumber" class="df-input char-input"
                                   value="${department.phoneNumber}" maxlength="50" data-max="50"
                                   placeholder="VD: 0123456789">
                            <div class="df-meta">
                                <small class="df-chars">0/50</small>
                            </div>
                        </div>

                        <!-- Địa điểm -->
                        <div class="df-group">
                            <label class="df-label">Địa điểm làm việc</label>
                            <input type="text" name="location" class="df-input char-input"
                                   value="${department.location}" maxlength="255" data-max="255"
                                   placeholder="VD: Tầng 3, Tòa nhà A">
                            <div class="df-meta">
                                <small class="df-chars">0/255</small>
                            </div>
                        </div>

                        <div class="df-section-title" style="margin-top: var(--space-md);">Gán Nhà Tuyển Dụng</div>
                        <div class="df-group">
                            <label class="df-label">Chọn danh sách nhân sự thuộc phòng ban này</label>
                            <div class="recruiter-list-container" style="max-height: 250px; overflow-y: auto; border: 1.5px solid var(--border-color); border-radius: var(--radius-md); padding: 10px; background: var(--bg-input);">
                                <c:choose>
                                    <c:when test="${not empty allRecruiters}">
                                        <c:forEach var="r" items="${allRecruiters}">
                                            <label class="recruiter-item" data-company-id="${r.companyId}" style="display: flex; align-items: center; gap: 12px; padding: 10px; border-radius: var(--radius-sm); cursor: pointer; transition: background 0.2s;">
                                                <input type="checkbox" name="recruiterIds" value="${r.recruiterId}" class="recruiter-checkbox"
                                                       ${r.departmentId != null && r.departmentId == department.departmentId ? 'checked' : ''}
                                                       style="accent-color: var(--primary); width: 18px; height: 18px; cursor: pointer;">
                                                <div style="width: 36px; height: 36px; border-radius: 50%; background: linear-gradient(135deg, var(--primary), var(--accent)); color: white; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 0.85rem; flex-shrink: 0; box-shadow: 0 2px 5px rgba(0,0,0,0.1);">
                                                    ${not empty r.fullName ? r.fullName.substring(0, 1).toUpperCase() : '?'}
                                                </div>
                                                <div style="flex: 1;">
                                                    <div style="font-weight: 600; font-size: 0.9rem; color: var(--text-primary);"><c:out value="${not empty r.fullName ? r.fullName : 'Chưa cập nhật'}"/></div>
                                                    <div style="font-size: 0.75rem; color: var(--text-muted);"><c:out value="${r.jobTitle}"/> - <c:out value="${r.email}"/></div>
                                                </div>
                                            </label>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div style="padding: 10px; color: var(--text-muted); font-size: 0.85rem; text-align: center;">Chưa có nhà tuyển dụng nào trong hệ thống.</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <small class="df-chars" style="margin-top: 6px;">Lưu ý: Chỉ những nhà tuyển dụng thuộc công ty trên mới được hiển thị. Nếu đổi công ty, hệ thống sẽ tự bỏ chọn nhân sự thuộc công ty cũ.</small>
                        </div>
                    </div>

                    <!-- Actions -->
                    <div class="df-actions">
                        <a href="${pageContext.request.contextPath}/admin/departments" class="btn-cancel">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/>
                            </svg>
                            Hủy
                        </a>
                        <button type="submit" class="btn-save">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                                <polyline points="20 6 9 17 4 12"/>
                            </svg>
                            <c:choose>
                                <c:when test="${department != null}">Lưu thay đổi</c:when>
                                <c:otherwise>Tạo phòng ban</c:otherwise>
                            </c:choose>
                        </button>
                    </div>
                </form>
            </div>

        </div>
    </main>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // Char counter logic
            document.querySelectorAll('.char-input').forEach(function (input) {
                var counter = input.closest('.df-group').querySelector('.df-chars');
                if (!counter) return;
                var max = parseInt(input.dataset.max || input.getAttribute('maxlength')) || 0;

                function update() {
                    var len = input.value.length;
                    counter.textContent = len + '/' + max;
                    counter.classList.remove('warn', 'limit');
                    if (len >= max) counter.classList.add('limit');
                    else if (len >= max * 0.8) counter.classList.add('warn');
                }
                input.addEventListener('input', update);
                update();
            });

            // Recruiter filter by Company logic
            const companySelect = document.querySelector('select[name="companyId"]');
            const recruiterItems = document.querySelectorAll('.recruiter-item');

            function filterRecruiters() {
                const selectedCompanyId = companySelect.value;
                let visibleCount = 0;
                
                recruiterItems.forEach(item => {
                    if (selectedCompanyId && item.dataset.companyId === selectedCompanyId) {
                        item.style.display = 'flex';
                        visibleCount++;
                    } else {
                        item.style.display = 'none';
                        const checkbox = item.querySelector('input[type="checkbox"]');
                        if (checkbox) checkbox.checked = false; // Uncheck hidden ones to prevent saving wrong data
                    }
                });
                
                // You can add a message if visibleCount === 0 here if you want
            }

            if (companySelect) {
                companySelect.addEventListener('change', filterRecruiters);
                // Initial filter on load
                filterRecruiters();
            }
            
            // Highlight checked rows
            document.querySelectorAll('.recruiter-checkbox').forEach(cb => {
                const updateRowStyle = (chk) => {
                    if (chk.checked) chk.closest('.recruiter-item').style.background = 'rgba(99, 102, 241, 0.08)';
                    else chk.closest('.recruiter-item').style.background = 'transparent';
                };
                updateRowStyle(cb);
                cb.addEventListener('change', (e) => updateRowStyle(e.target));
            });
        });
    </script>
</body>
</html>

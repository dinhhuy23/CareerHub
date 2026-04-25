<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${isCreate ? 'Thêm' : 'Sửa'} nhà tuyển dụng | HireHub Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* ── Page ── */
        .rf-container {
            max-width: 820px; margin: 0 auto;
            padding: var(--space-xl) var(--space-lg) var(--space-3xl);
        }

        /* ── Back link ── */
        .back-link {
            display: inline-flex; align-items: center; gap: 7px;
            color: var(--text-secondary); font-size: 0.875rem;
            text-decoration: none; margin-bottom: var(--space-xl);
            transition: color 0.2s, transform 0.2s;
        }
        .back-link:hover { color: var(--primary-light); transform: translateX(-3px); }

        /* ── Card ── */
        .rf-card {
            background: var(--glass-bg); backdrop-filter: var(--glass-blur);
            -webkit-backdrop-filter: var(--glass-blur);
            border: 1px solid var(--glass-border);
            border-radius: var(--radius-xl); box-shadow: var(--glass-shadow);
            overflow: hidden;
        }

        /* ── Card header ── */
        .rf-card-header {
            padding: var(--space-xl);
            background: linear-gradient(135deg, rgba(99,102,241,0.12), rgba(139,92,246,0.08));
            border-bottom: 1px solid var(--glass-border);
            display: flex; align-items: center; gap: 16px;
        }
        .rf-header-icon {
            width: 48px; height: 48px; border-radius: 14px; flex-shrink: 0;
            background: linear-gradient(135deg, var(--primary), var(--accent));
            display: flex; align-items: center; justify-content: center;
            box-shadow: 0 4px 12px rgba(99,102,241,0.4);
        }
        .rf-card-title { font-size: 1.3rem; font-weight: 800; color: var(--text-primary); }
        .rf-card-subtitle { font-size: 0.85rem; color: var(--text-muted); margin-top: 3px; }

        /* ── Form body ── */
        .rf-body { padding: var(--space-xl); }

        /* ── Section divider ── */
        .rf-section {
            margin-bottom: var(--space-xl);
            padding-bottom: var(--space-xl);
            border-bottom: 1px solid var(--glass-border);
        }
        .rf-section:last-of-type { border-bottom: none; margin-bottom: 0; padding-bottom: 0; }
        .rf-section-title {
            font-size: 0.8rem; font-weight: 700; text-transform: uppercase;
            letter-spacing: 0.6px; color: var(--primary-light);
            margin-bottom: var(--space-lg); display: flex; align-items: center; gap: 8px;
        }
        .rf-section-title::after {
            content: ''; flex: 1; height: 1px;
            background: linear-gradient(90deg, rgba(99,102,241,0.3), transparent);
        }

        /* ── Grid ── */
        .rf-grid { display: grid; grid-template-columns: 1fr 1fr; gap: var(--space-lg); }
        .rf-grid .full { grid-column: span 2; }
        @media (max-width: 600px) {
            .rf-grid { grid-template-columns: 1fr; }
            .rf-grid .full { grid-column: span 1; }
        }

        /* ── Form group ── */
        .rf-group { display: flex; flex-direction: column; gap: 6px; }
        .rf-label {
            font-size: 0.82rem; font-weight: 600; color: var(--text-secondary);
            display: flex; align-items: center; gap: 5px;
        }
        .rf-label .req { color: var(--error); }

        .rf-input, .rf-select, .rf-textarea {
            width: 100%; padding: 11px 14px;
            background: var(--bg-input); border: 1.5px solid var(--border-color);
            border-radius: var(--radius-md); color: var(--text-primary);
            font-size: 0.9375rem; font-family: var(--font-family);
            transition: all 0.2s; outline: none;
        }
        .rf-input:focus, .rf-select:focus, .rf-textarea:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px var(--primary-50);
        }
        .rf-input::placeholder, .rf-textarea::placeholder { color: var(--text-muted); }
        .rf-textarea { resize: vertical; min-height: 100px; }
        .rf-select option { background: var(--bg-secondary); }
        .rf-input:disabled { opacity: 0.5; cursor: not-allowed; }

        /* ── Input meta (char count + error) ── */
        .rf-meta {
            display: flex; justify-content: space-between; align-items: center;
            min-height: 18px;
        }
        .rf-error { font-size: 0.78rem; color: var(--error); }
        .rf-chars { font-size: 0.75rem; color: var(--text-muted); transition: color 0.2s; }
        .rf-chars.warn  { color: var(--warning); }
        .rf-chars.limit { color: var(--error); font-weight: 600; }

        /* ── Alert ── */
        .rf-alert {
            display: flex; align-items: flex-start; gap: 10px;
            padding: 12px 16px; border-radius: var(--radius-md);
            background: var(--error-light); color: var(--error);
            border: 1px solid rgba(239,68,68,0.2);
            font-size: 0.875rem; margin-bottom: var(--space-lg);
        }

        /* ── Actions ── */
        .rf-actions {
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
        <div class="rf-container animate-fadeInUp">

            <!-- Back -->
            <a href="${pageContext.request.contextPath}/admin/recruiters" class="back-link">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/>
                </svg>
                Quay lại danh sách
            </a>

            <div class="rf-card">
                <!-- Card header -->
                <div class="rf-card-header">
                    <div class="rf-header-icon">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5">
                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                            <circle cx="9" cy="7" r="4"/>
                            <path d="M23 21v-2a4 4 0 0 0-3-3.87"/>
                            <path d="M16 3.13a4 4 0 0 1 0 7.75"/>
                        </svg>
                    </div>
                    <div>
                        <div class="rf-card-title">
                            <c:choose>
                                <c:when test="${not isCreate}">Chỉnh sửa nhà tuyển dụng</c:when>
                                <c:otherwise>Thêm nhà tuyển dụng mới</c:otherwise>
                            </c:choose>
                        </div>
                        <div class="rf-card-subtitle">
                            <c:choose>
                                <c:when test="${not isCreate}">Cập nhật thông tin cho ${recruiter.fullName}</c:when>
                                <c:otherwise>Điền thông tin để tạo tài khoản nhà tuyển dụng</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <!-- Alert -->
                <c:if test="${not empty error}">
                    <div style="padding: var(--space-lg) var(--space-xl) 0;">
                        <div class="rf-alert">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="flex-shrink:0; margin-top:1px;">
                                <circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/>
                            </svg>
                            ${error}
                        </div>
                    </div>
                </c:if>

                <!-- Form -->
                <form action="${pageContext.request.contextPath}/admin/recruiters" method="post">
                    <%-- Chỉ gửi id khi đang ở chế độ Sửa, không gửi khi Thêm mới --%>
                    <c:if test="${not isCreate}">
                        <input type="hidden" name="id" value="${recruiter.recruiterId}">
                    </c:if>

                    <div class="rf-body">

                        <!-- Section: Tài khoản (chỉ hiện khi tạo mới) -->
                        <c:if test="${isCreate}">
                            <div class="rf-section">
                                <div class="rf-section-title">Thông tin tài khoản</div>
                                <div class="rf-grid">
                                    <div class="rf-group">
                                        <label class="rf-label">Email <span class="req">*</span></label>
                                        <input type="email" name="email" class="rf-input char-input"
                                               value="${recruiter.email}" data-max="255"
                                               placeholder="example@email.com">
                                        <div class="rf-meta">
                                            <c:if test="${not empty errors.email}">
                                                <small class="rf-error">${errors.email}</small>
                                            </c:if>
                                            <small class="rf-chars" style="margin-left:auto;">0/255</small>
                                        </div>
                                    </div>
                                    <div class="rf-group">
                                        <label class="rf-label">Họ và tên đầy đủ <span class="req">*</span></label>
                                        <input type="text" name="fullName" class="rf-input char-input"
                                               value="${recruiter.fullName}" data-max="150"
                                               placeholder="Nguyễn Văn A">
                                        <div class="rf-meta">
                                            <c:if test="${not empty errors.fullName}">
                                                <small class="rf-error">${errors.fullName}</small>
                                            </c:if>
                                            <small class="rf-chars" style="margin-left:auto;">0/150</small>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:if>

                        <!-- Section: Thông tin công việc -->
                        <div class="rf-section">
                            <div class="rf-section-title">Thông tin công việc</div>
                            <div class="rf-grid">

                                <div class="rf-group full">
                                    <label class="rf-label">Chức danh công việc <span class="req">*</span></label>
                                    <input type="text" name="jobTitle" class="rf-input char-input"
                                           value="${recruiter.jobTitle}" data-max="150"
                                           placeholder="VD: Senior Technical Recruiter">
                                    <div class="rf-meta">
                                        <c:if test="${not empty errors.jobTitle}">
                                            <small class="rf-error">${errors.jobTitle}</small>
                                        </c:if>
                                        <small class="rf-chars" style="margin-left:auto;">0/150</small>
                                    </div>
                                </div>

                                <div class="rf-group">
                                    <label class="rf-label">Công ty <span class="req">*</span></label>
                                    <select name="companyId" id="companySelect" class="rf-select" required>
                                        <option value="">-- Chọn công ty --</option>
                                        <c:forEach var="c" items="${companies}">
                                            <option value="${c.companyId}"
                                                    ${c.companyId == recruiter.companyId ? 'selected' : ''}>
                                                ${c.companyName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="rf-group">
                                    <label class="rf-label">Phòng ban</label>
                                    <select name="departmentId" id="departmentSelect" class="rf-select">
                                        <option value="">-- Chọn phòng ban --</option>
                                    </select>
                                </div>

                                <c:if test="${not isCreate}">
                                    <div class="rf-group">
                                        <label class="rf-label">Trạng thái <span class="req">*</span></label>
                                        <select name="status" class="rf-select" required>
                                            <option value="ACTIVE" ${recruiter.status == 'ACTIVE' ? 'selected' : ''}>Đang hoạt động (ACTIVE)</option>
                                            <option value="INACTIVE" ${recruiter.status == 'INACTIVE' ? 'selected' : ''}>Ngừng hoạt động (INACTIVE)</option>
                                        </select>
                                    </div>
                                </c:if>

                            </div>
                        </div>

                        <!-- Section: Giới thiệu -->
                        <div class="rf-section">
                            <div class="rf-section-title">Giới thiệu bản thân</div>
                            <div class="rf-group">
                                <label class="rf-label">Bio</label>
                                <textarea name="bio" class="rf-textarea char-input"
                                          rows="5" data-max="1000"
                                          placeholder="Mô tả ngắn về kinh nghiệm và chuyên môn...">${recruiter.bio}</textarea>
                                <div class="rf-meta">
                                    <c:if test="${not empty errors.bio}">
                                        <small class="rf-error">${errors.bio}</small>
                                    </c:if>
                                    <small class="rf-chars" style="margin-left:auto;">0/1000</small>
                                </div>
                            </div>
                        </div>

                    </div><!-- /rf-body -->

                    <!-- Actions -->
                    <div class="rf-actions">
                        <a href="${pageContext.request.contextPath}/admin/recruiters" class="btn-cancel">
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
                                <c:when test="${not isCreate}">Lưu thay đổi</c:when>
                                <c:otherwise>Tạo tài khoản</c:otherwise>
                            </c:choose>
                        </button>
                    </div>

                </form>
            </div>

        </div>
    </main>

    <script>
        const selectedDepartmentId = "${recruiter.departmentId}";

        document.getElementById("companySelect").addEventListener("change", function () {
            const companyId = this.value;
            if (!companyId) return;
            fetch("${pageContext.request.contextPath}/getDepartmentsByCompany?companyId=" + companyId)
                .then(res => res.json())
                .then(data => {
                    const deptSelect = document.getElementById("departmentSelect");
                    deptSelect.innerHTML = '<option value="">-- Chọn phòng ban --</option>';
                    data.forEach(d => {
                        const option = document.createElement("option");
                        option.value = d.departmentId;
                        option.textContent = d.departmentName;
                        if (d.departmentId == selectedDepartmentId) option.selected = true;
                        deptSelect.appendChild(option);
                    });
                }).catch(() => {});
        });

        // Trigger on load to populate departments if editing
        window.addEventListener("DOMContentLoaded", function () {
            const companyId = document.getElementById("companySelect").value;
            if (companyId) {
                document.getElementById("companySelect").dispatchEvent(new Event("change"));
            }

            // Character counters – read data-max only (no maxlength)
            document.querySelectorAll(".char-input").forEach(function (input) {
                const counter = input.closest('.rf-group').querySelector('.rf-chars');
                if (!counter) return;
                const max = parseInt(input.dataset.max, 10) || 0;

                function update() {
                    const len = input.value.length;
                    counter.textContent = len + "/" + max;
                    counter.classList.remove("warn", "limit");
                    if (len >= max) counter.classList.add("limit");
                    else if (len >= max * 0.8) counter.classList.add("warn");
                }
                input.addEventListener("input", update);
                update();
            });
        });
    </script>
</body>
</html>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, java.util.Map, model.Location, model.Company"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= "edit".equalsIgnoreCase((String)request.getAttribute("mode")) ? "Chỉnh sửa" : "Thêm" %> công ty | HireHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/company.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* ── Form layout ── */
        .cf-container { max-width: 860px; margin: 0 auto; padding: var(--space-xl) var(--space-lg) var(--space-3xl); }
        .cf-back { display:inline-flex; align-items:center; gap:7px; color:var(--text-secondary); font-size:.875rem; text-decoration:none; margin-bottom:var(--space-xl); transition:color .2s,transform .2s; }
        .cf-back:hover { color:var(--primary-light); transform:translateX(-3px); }
        .cf-card { background:var(--glass-bg); backdrop-filter:var(--glass-blur); border:1px solid var(--glass-border); border-radius:var(--radius-xl); box-shadow:var(--glass-shadow); overflow:hidden; }

        /* ── Card header ── */
        .cf-header { padding:var(--space-xl); background:linear-gradient(135deg,rgba(99,102,241,.12),rgba(139,92,246,.08)); border-bottom:1px solid var(--glass-border); display:flex; align-items:center; gap:16px; }
        .cf-header-icon { width:48px; height:48px; border-radius:14px; flex-shrink:0; background:linear-gradient(135deg,var(--primary),var(--accent)); display:flex; align-items:center; justify-content:center; box-shadow:0 4px 12px rgba(99,102,241,.4); }
        .cf-title { font-size:1.3rem; font-weight:800; color:var(--text-primary); }
        .cf-subtitle { font-size:.85rem; color:var(--text-muted); margin-top:3px; }

        /* ── Body / sections ── */
        .cf-body { padding:var(--space-xl); }
        .cf-section { margin-bottom:var(--space-xl); padding-bottom:var(--space-xl); border-bottom:1px solid var(--glass-border); }
        .cf-section:last-of-type { border-bottom:none; margin-bottom:0; padding-bottom:0; }
        .cf-section-title { font-size:.8rem; font-weight:700; text-transform:uppercase; letter-spacing:.6px; color:var(--primary-light); margin-bottom:var(--space-lg); display:flex; align-items:center; gap:8px; }
        .cf-section-title::after { content:''; flex:1; height:1px; background:linear-gradient(90deg,rgba(99,102,241,.3),transparent); }

        /* ── Grid ── */
        .cf-grid { display:grid; grid-template-columns:1fr 1fr; gap:var(--space-lg); }
        .cf-grid .full { grid-column:span 2; }
        @media(max-width:600px){ .cf-grid{grid-template-columns:1fr} .cf-grid .full{grid-column:span 1} }

        /* ── Form group ── */
        .cf-group { display:flex; flex-direction:column; gap:6px; }
        .cf-label { font-size:.82rem; font-weight:600; color:var(--text-secondary); display:flex; align-items:center; gap:5px; }
        .cf-label .req { color:var(--error); }
        .cf-input, .cf-select, .cf-textarea {
            width:100%; padding:11px 14px;
            background:var(--bg-input); border:1.5px solid var(--border-color);
            border-radius:var(--radius-md); color:var(--text-primary);
            font-size:.9375rem; font-family:var(--font-family);
            transition:all .2s; outline:none;
        }
        .cf-input:focus,.cf-select:focus,.cf-textarea:focus { border-color:var(--primary); box-shadow:0 0 0 3px var(--primary-50); }
        .cf-input::placeholder,.cf-textarea::placeholder { color:var(--text-muted); }
        .cf-textarea { resize:vertical; min-height:110px; }
        .cf-select option { background:var(--bg-secondary); }
        .cf-input.error-field,.cf-select.error-field,.cf-textarea.error-field { border-color:var(--error); }

        /* ── Meta row (char counter + error) ── */
        .cf-meta { display:flex; justify-content:space-between; align-items:center; min-height:18px; }
        .cf-error { font-size:.78rem; color:var(--error); }
        .cf-chars { font-size:.75rem; color:var(--text-muted); transition:color .2s; }
        .cf-chars.warn  { color:var(--warning); }
        .cf-chars.limit { color:var(--error); font-weight:600; }

        /* ── Global error alert ── */
        .cf-alert { display:flex; align-items:flex-start; gap:10px; padding:12px 16px; border-radius:var(--radius-md); background:var(--error-light); color:var(--error); border:1px solid rgba(239,68,68,.2); font-size:.875rem; margin-bottom:var(--space-lg); }

        /* ── Logo preview ── */
        .logo-preview { max-width:120px; max-height:80px; border-radius:8px; margin-top:8px; object-fit:contain; display:block; }

        /* ── Actions ── */
        .cf-actions { padding:var(--space-lg) var(--space-xl); border-top:1px solid var(--glass-border); display:flex; justify-content:flex-end; gap:10px; }
        .btn-save { background:linear-gradient(135deg,var(--primary),var(--accent)); color:white; padding:11px 24px; border-radius:var(--radius-md); border:none; cursor:pointer; font-size:.9375rem; font-weight:700; font-family:var(--font-family); display:inline-flex; align-items:center; gap:8px; box-shadow:0 4px 14px rgba(99,102,241,.35); transition:all .2s; }
        .btn-save:hover { transform:translateY(-2px); box-shadow:0 6px 20px rgba(99,102,241,.45); }
        .btn-cancel { padding:11px 20px; border-radius:var(--radius-md); background:var(--glass-bg); border:1px solid var(--glass-border); color:var(--text-secondary); font-size:.9375rem; font-weight:600; text-decoration:none; transition:all .2s; display:inline-flex; align-items:center; gap:8px; }
        .btn-cancel:hover { border-color:var(--primary); color:var(--primary-light); }

        /* ── Toast ── */
        .toast-container { position:fixed; top:24px; right:24px; z-index:9999; display:flex; flex-direction:column; gap:10px; }
        .toast { display:flex; align-items:center; gap:12px; padding:14px 20px; border-radius:12px; font-size:.88rem; font-weight:600; min-width:280px; max-width:420px; box-shadow:0 8px 32px rgba(0,0,0,.35); animation:toastIn .3s ease; backdrop-filter:blur(10px); }
        .toast.success { background:rgba(16,185,129,.18); color:#34d399; border:1px solid rgba(16,185,129,.3); }
        .toast.error   { background:rgba(239,68,68,.18);  color:#f87171; border:1px solid rgba(239,68,68,.3); }
        .toast-close { margin-left:auto; cursor:pointer; opacity:.7; background:none; border:none; color:inherit; font-size:1rem; line-height:1; padding:0; }
        .toast-close:hover { opacity:1; }
        @keyframes toastIn  { from{opacity:0;transform:translateX(30px)} to{opacity:1;transform:translateX(0)} }
        @keyframes toastOut { from{opacity:1;transform:translateX(0)} to{opacity:0;transform:translateX(30px)} }
    </style>
</head>
<body class="app-page">
    <jsp:include page="/WEB-INF/views/header.jsp" />
    <%
        Company company = (Company) request.getAttribute("company");
        List<Location> locations = (List<Location>) request.getAttribute("locations");
        Map<String, String> errors = (Map<String, String>) request.getAttribute("errors");
        String mode = (String) request.getAttribute("mode");
        boolean isEdit = "edit".equalsIgnoreCase(mode);

        // Helper: get field value (company bean > empty)
        java.util.function.Function<String,String> val = key -> {
            if (company == null) return "";
            switch(key) {
                case "companyName": return company.getCompanyName() != null ? company.getCompanyName() : "";
                case "taxCode":     return company.getTaxCode()     != null ? company.getTaxCode()     : "";
                case "websiteUrl":  return company.getWebsiteUrl()  != null ? company.getWebsiteUrl()  : "";
                case "email":       return company.getEmail()       != null ? company.getEmail()       : "";
                case "phoneNumber": return company.getPhoneNumber() != null ? company.getPhoneNumber() : "";
                case "industry":    return company.getIndustry()    != null ? company.getIndustry()    : "";
                case "addressLine": return company.getAddressLine() != null ? company.getAddressLine() : "";
                case "description": return company.getDescription() != null ? company.getDescription() : "";
                case "foundedYear": return company.getFoundedYear() != null ? company.getFoundedYear().toString() : "";
                case "companySize": return company.getCompanySize() != null ? company.getCompanySize() : "";
                case "status":      return company.getStatus()      != null ? company.getStatus()      : "ACTIVE";
                case "logoUrl":     return company.getLogoUrl()     != null ? company.getLogoUrl()     : "";
                default: return "";
            }
        };
        String err_cn  = errors != null && errors.containsKey("companyName") ? errors.get("companyName") : null;
        String err_tc  = errors != null && errors.containsKey("taxCode")     ? errors.get("taxCode")     : null;
        String err_wu  = errors != null && errors.containsKey("websiteUrl")  ? errors.get("websiteUrl")  : null;
        String err_em  = errors != null && errors.containsKey("email")       ? errors.get("email")       : null;
        String err_ph  = errors != null && errors.containsKey("phoneNumber") ? errors.get("phoneNumber") : null;
        String err_fy  = errors != null && errors.containsKey("foundedYear") ? errors.get("foundedYear") : null;
        String err_in  = errors != null && errors.containsKey("industry")    ? errors.get("industry")    : null;
        String err_ad  = errors != null && errors.containsKey("addressLine") ? errors.get("addressLine") : null;
        String err_ds  = errors != null && errors.containsKey("description") ? errors.get("description") : null;
        String actionUrl = isEdit ? request.getContextPath() + "/company/edit"
                                  : request.getContextPath() + "/company/create";
        String cancelUrl = (isEdit && company != null)
                         ? request.getContextPath() + "/company/detail?id=" + company.getCompanyId()
                         : request.getContextPath() + "/admin/company";
    %>

    <main class="main-content">
        <div class="cf-container">

            <%-- Toast flash (forward thất bại) --%>
            <c:if test="${not empty toastType}">
                <div class="toast-container" id="toastContainer">
                    <div class="toast ${toastType}" id="mainToast">
                        <c:choose>
                            <c:when test="${toastType == 'success'}">
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" style="flex-shrink:0"><polyline points="20 6 9 17 4 12"/></svg>
                            </c:when>
                            <c:otherwise>
                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="flex-shrink:0"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                            </c:otherwise>
                        </c:choose>
                        <span><c:out value="${toastMsg}"/></span>
                        <button class="toast-close" onclick="this.closest('.toast').remove()">&times;</button>
                    </div>
                </div>
                <script>
                    (function(){var t=document.getElementById('mainToast');if(!t)return;setTimeout(function(){t.style.animation='toastOut .3s ease forwards';setTimeout(function(){t.remove()},320)},4000);})();
                </script>
            </c:if>

            <!-- Back -->
            <a href="<%= cancelUrl %>" class="cf-back">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/></svg>
                Quay lại
            </a>

            <div class="cf-card">
                <!-- Card header -->
                <div class="cf-header">
                    <div class="cf-header-icon">
                        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5"><rect x="2" y="7" width="20" height="14" rx="2"/><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/></svg>
                    </div>
                    <div>
                        <div class="cf-title"><%= isEdit ? "Chỉnh sửa công ty" : "Thêm công ty mới" %></div>
                        <div class="cf-subtitle"><%= isEdit ? "Cập nhật thông tin công ty" : "Điền thông tin để tạo công ty mới" %></div>
                    </div>
                </div>

                <!-- Global error alert -->
                <c:if test="${not empty error}">
                    <div style="padding:var(--space-lg) var(--space-xl) 0;">
                        <div class="cf-alert">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="flex-shrink:0;margin-top:1px"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                            ${error}
                        </div>
                    </div>
                </c:if>

                <form action="<%= actionUrl %>" method="post" enctype="multipart/form-data">
                    <% if (isEdit && company != null) { %>
                    <input type="hidden" name="companyId" value="<%= company.getCompanyId() %>">
                    <% } %>

                    <div class="cf-body">

                        <!-- Section: Thông tin cơ bản -->
                        <div class="cf-section">
                            <div class="cf-section-title">Thông tin cơ bản</div>
                            <div class="cf-grid">

                                <div class="cf-group full">
                                    <label class="cf-label">Tên công ty <span class="req">*</span></label>
                                    <input type="text" name="companyName" class="cf-input char-input <%= err_cn != null ? "error-field" : "" %>"
                                           value="<%= val.apply("companyName") %>" data-max="200"
                                           placeholder="VD: FPT Software">
                                    <div class="cf-meta">
                                        <% if (err_cn != null) { %><small class="cf-error"><%= err_cn %></small><% } %>
                                        <small class="cf-chars" style="margin-left:auto">0/200</small>
                                    </div>
                                </div>

                                <div class="cf-group">
                                    <label class="cf-label">Mã số thuế</label>
                                    <input type="text" name="taxCode" class="cf-input char-input <%= err_tc != null ? "error-field" : "" %>"
                                           value="<%= val.apply("taxCode") %>" data-max="50"
                                           placeholder="VD: 0123456789">
                                    <div class="cf-meta">
                                        <% if (err_tc != null) { %><small class="cf-error"><%= err_tc %></small><% } %>
                                        <small class="cf-chars" style="margin-left:auto">0/50</small>
                                    </div>
                                </div>

                                <div class="cf-group">
                                    <label class="cf-label">Năm thành lập</label>
                                    <input type="number" name="foundedYear" class="cf-input <%= err_fy != null ? "error-field" : "" %>"
                                           value="<%= val.apply("foundedYear") %>"
                                           placeholder="VD: 2000" min="1800" max="2099">
                                    <div class="cf-meta">
                                        <% if (err_fy != null) { %><small class="cf-error"><%= err_fy %></small><% } %>
                                    </div>
                                </div>

                                <div class="cf-group">
                                    <label class="cf-label">Quy mô công ty</label>
                                    <select name="companySize" class="cf-select">
                                        <option value="">-- Chọn quy mô --</option>
                                        <% String[] sizes = {"1-10 employees","11-50 employees","51-200 employees","201-500 employees","500+ employees"};
                                           for (String s : sizes) { %>
                                        <option value="<%= s %>" <%= s.equals(val.apply("companySize")) ? "selected" : "" %>><%= s %></option>
                                        <% } %>
                                    </select>
                                </div>

                                <div class="cf-group">
                                    <label class="cf-label">Ngành nghề</label>
                                    <input type="text" name="industry" class="cf-input char-input <%= err_in != null ? "error-field" : "" %>"
                                           value="<%= val.apply("industry") %>" data-max="100"
                                           placeholder="VD: Information Technology">
                                    <div class="cf-meta">
                                        <% if (err_in != null) { %><small class="cf-error"><%= err_in %></small><% } %>
                                        <small class="cf-chars" style="margin-left:auto">0/100</small>
                                    </div>
                                </div>

                                <div class="cf-group">
                                    <label class="cf-label">Trạng thái</label>
                                    <select name="status" class="cf-select">
                                        <option value="ACTIVE"   <%= "ACTIVE".equalsIgnoreCase(val.apply("status"))   ? "selected" : "" %>>ACTIVE</option>
                                        <option value="INACTIVE" <%= "INACTIVE".equalsIgnoreCase(val.apply("status")) ? "selected" : "" %>>INACTIVE</option>
                                    </select>
                                </div>

                            </div>
                        </div>

                        <!-- Section: Liên hệ -->
                        <div class="cf-section">
                            <div class="cf-section-title">Thông tin liên hệ</div>
                            <div class="cf-grid">

                                <div class="cf-group">
                                    <label class="cf-label">Website</label>
                                    <input type="text" name="websiteUrl" class="cf-input char-input <%= err_wu != null ? "error-field" : "" %>"
                                           value="<%= val.apply("websiteUrl") %>" data-max="255"
                                           placeholder="https://company.com">
                                    <div class="cf-meta">
                                        <% if (err_wu != null) { %><small class="cf-error"><%= err_wu %></small><% } %>
                                        <small class="cf-chars" style="margin-left:auto">0/255</small>
                                    </div>
                                </div>

                                <div class="cf-group">
                                    <label class="cf-label">Email liên hệ</label>
                                    <input type="text" name="email" class="cf-input char-input <%= err_em != null ? "error-field" : "" %>"
                                           value="<%= val.apply("email") %>" data-max="255"
                                           placeholder="contact@company.com">
                                    <div class="cf-meta">
                                        <% if (err_em != null) { %><small class="cf-error"><%= err_em %></small><% } %>
                                        <small class="cf-chars" style="margin-left:auto">0/255</small>
                                    </div>
                                </div>

                                <div class="cf-group">
                                    <label class="cf-label">Số điện thoại</label>
                                    <input type="text" name="phoneNumber" class="cf-input char-input <%= err_ph != null ? "error-field" : "" %>"
                                           value="<%= val.apply("phoneNumber") %>" data-max="20"
                                           placeholder="VD: 0901234567">
                                    <div class="cf-meta">
                                        <% if (err_ph != null) { %><small class="cf-error"><%= err_ph %></small><% } %>
                                        <small class="cf-chars" style="margin-left:auto">0/20</small>
                                    </div>
                                </div>

                                <div class="cf-group">
                                    <label class="cf-label">Logo</label>
                                    <input type="file" name="image" class="cf-input" id="logoFile" accept="image/*">
                                    <input type="hidden" name="imageOrigin" value="<%= val.apply("logoUrl") %>">
                                    <% String logoSrc = val.apply("logoUrl");
                                       if (!logoSrc.isEmpty()) { %>
                                    <img id="previewImg" src="<%= logoSrc %>" class="logo-preview" alt="Logo preview">
                                    <% } else { %>
                                    <img id="previewImg" src="" class="logo-preview" alt="Logo preview" style="display:none">
                                    <% } %>
                                </div>

                            </div>
                        </div>

                        <!-- Section: Địa chỉ -->
                        <div class="cf-section">
                            <div class="cf-section-title">Địa chỉ</div>
                            <div class="cf-grid">

                                <div class="cf-group">
                                    <label class="cf-label">Khu vực</label>
                                    <select name="locationId" class="cf-select">
                                        <option value="">-- Chọn khu vực --</option>
                                        <% if (locations != null) {
                                               for (Location loc : locations) {
                                                   boolean sel = company != null && company.getLocationId() != null
                                                              && company.getLocationId().longValue() == loc.getLocationId(); %>
                                        <option value="<%= loc.getLocationId() %>" <%= sel ? "selected" : "" %>><%= loc.getLocationName() %></option>
                                        <%     }
                                           } %>
                                    </select>
                                </div>

                                <div class="cf-group">
                                    <label class="cf-label">Địa chỉ chi tiết</label>
                                    <input type="text" name="addressLine" class="cf-input char-input <%= err_ad != null ? "error-field" : "" %>"
                                           value="<%= val.apply("addressLine") %>" data-max="300"
                                           placeholder="Số nhà, đường, phường/xã...">
                                    <div class="cf-meta">
                                        <% if (err_ad != null) { %><small class="cf-error"><%= err_ad %></small><% } %>
                                        <small class="cf-chars" style="margin-left:auto">0/300</small>
                                    </div>
                                </div>

                            </div>
                        </div>

                        <!-- Section: Mô tả -->
                        <div class="cf-section">
                            <div class="cf-section-title">Giới thiệu công ty</div>
                            <div class="cf-group">
                                <label class="cf-label">Mô tả</label>
                                <textarea name="description" class="cf-textarea char-input <%= err_ds != null ? "error-field" : "" %>"
                                          rows="6" data-max="3000"
                                          placeholder="Mô tả về công ty, văn hóa, sứ mệnh..."><%= val.apply("description") %></textarea>
                                <div class="cf-meta">
                                    <% if (err_ds != null) { %><small class="cf-error"><%= err_ds %></small><% } %>
                                    <small class="cf-chars" style="margin-left:auto">0/3000</small>
                                </div>
                            </div>
                        </div>

                    </div><!-- /cf-body -->

                    <!-- Actions -->
                    <div class="cf-actions">
                        <a href="<%= cancelUrl %>" class="btn-cancel">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                            Hủy
                        </a>
                        <button type="submit" class="btn-save">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg>
                            <%= isEdit ? "Lưu thay đổi" : "Tạo công ty" %>
                        </button>
                    </div>
                </form>
            </div>

        </div>
    </main>

    <script>
        // Logo preview
        document.getElementById("logoFile").addEventListener("change", function(e) {
            const file = e.target.files[0];
            if (file) {
                const preview = document.getElementById("previewImg");
                preview.src = URL.createObjectURL(file);
                preview.style.display = "block";
            }
        });

        // Character counters
        window.addEventListener("DOMContentLoaded", function() {
            document.querySelectorAll(".char-input").forEach(function(input) {
                const counter = input.closest('.cf-group').querySelector('.cf-chars');
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
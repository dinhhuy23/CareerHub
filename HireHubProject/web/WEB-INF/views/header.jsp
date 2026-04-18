<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%-- Header dùng chung cho toàn bộ ứng dụng. Phân quyền nav theo sessionScope.userRole --%>
<nav class="navbar glass-nav">
    <div class="nav-container">
        <a href="${pageContext.request.contextPath}/" class="nav-logo">
            <svg width="36" height="36" viewBox="0 0 48 48" fill="none">
                <rect width="48" height="48" rx="12" fill="url(#navLogo)"/>
                <path d="M14 20h20M14 28h14M14 14h8v4h-8zM26 14h8v4h-8z" stroke="white" stroke-width="2.5" stroke-linecap="round"/>
                <defs><linearGradient id="navLogo" x1="0" y1="0" x2="48" y2="48"><stop stop-color="#6366F1"/><stop offset="1" stop-color="#8B5CF6"/></linearGradient></defs>
            </svg>
            <span>HireHub</span>
        </a>

        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/jobs" class="nav-link">Việc làm</a>
            <c:if test="${not empty sessionScope.userRole}">
                <c:choose>
                    <%-- Nav dành cho RECRUITER --%>
                    <c:when test="${sessionScope.userRole == 'RECRUITER'}">
                        <a href="${pageContext.request.contextPath}/employer/dashboard" class="nav-link">Dashboard</a>
                        <a href="${pageContext.request.contextPath}/employer/jobs" class="nav-link">Tin đăng</a>
                        <a href="${pageContext.request.contextPath}/employer/applications" class="nav-link">Ứng viên</a>
                    </c:when>
                    <%-- Nav dành cho CANDIDATE --%>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/user/dashboard" class="nav-link">Dashboard</a>
                        <a href="${pageContext.request.contextPath}/user/my-applications" class="nav-link">Hồ sơ đã nộp</a>
                    </c:otherwise>
                </c:choose>
            </c:if>
        </div>

        <div class="nav-user">
            <c:choose>
                <c:when test="${empty sessionScope.userId}">
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-outline" style="padding: 6px 16px; margin-right: 8px;">Đăng nhập</a>
                    <a href="${pageContext.request.contextPath}/register" class="btn btn-primary" style="padding: 6px 16px;">Đăng ký</a>
                </c:when>
                <c:otherwise>
                    <%-- Icon chuông thông báo (chỉ hiện cho CANDIDATE) --%>
                    <c:if test="${sessionScope.userRole == 'CANDIDATE'}">
                        <a href="${pageContext.request.contextPath}/user/notifications" id="notifBell"
                           style="position: relative; display: inline-flex; align-items: center; justify-content: center; width: 40px; height: 40px; border-radius: 50%; background: var(--bg-tertiary); border: 1px solid var(--border-color); margin-right: 10px; color: var(--text-secondary); text-decoration: none; transition: all 0.2s;"
                           onmouseover="this.style.borderColor='var(--primary)'" onmouseout="this.style.borderColor='var(--border-color)'">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path>
                                <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
                            </svg>
                            <%-- Badge số chưa đọc – được inject bằng AJAX --%>
                            <span id="notifCount" style="display:none; position: absolute; top: -4px; right: -4px; background: var(--error); color: white; border-radius: 50%; width: 18px; height: 18px; font-size: 0.65rem; font-weight: 800; align-items: center; justify-content: center;"></span>
                        </a>
                    </c:if>

                    <div class="user-dropdown">
                        <button class="user-btn" onclick="toggleDropdown()">
                            <div class="user-avatar">${sessionScope.userFullName.substring(0,1)}</div>
                            <span class="user-name">${sessionScope.userFullName}</span>
                            <svg width="16" height="16" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z"/></svg>
                        </button>
                        <div class="dropdown-menu" id="userDropdown">
                            <a href="${pageContext.request.contextPath}/user/profile" class="dropdown-item">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                                Tài khoản
                            </a>
                            <c:if test="${sessionScope.userRole == 'CANDIDATE'}">
                                <a href="${pageContext.request.contextPath}/user/my-applications" class="dropdown-item">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
                                    Hồ sơ đã ứng tuyển
                                </a>
                                <a href="${pageContext.request.contextPath}/user/notifications" class="dropdown-item">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></svg>
                                    Thông báo
                                </a>
                            </c:if>
                            <c:if test="${sessionScope.userRole == 'RECRUITER'}">
                                <a href="${pageContext.request.contextPath}/employer/jobs" class="dropdown-item">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                                    Quản lý tin tuyển dụng
                                </a>
                            </c:if>
                            <hr class="dropdown-divider">
                            <a href="${pageContext.request.contextPath}/logout" class="dropdown-item text-danger">
                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
                                Đăng xuất
                            </a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</nav>

<script>
    function toggleDropdown() {
        document.getElementById("userDropdown").classList.toggle("show");
    }
    window.onclick = function(event) {
        if (!event.target.closest('.user-btn')) {
            var dropdowns = document.getElementsByClassName("dropdown-menu");
            for (var i = 0; i < dropdowns.length; i++) {
                if (dropdowns[i].classList.contains('show')) {
                    dropdowns[i].classList.remove('show');
                }
            }
        }
    }

    // Lấy số thông báo chưa đọc bằng AJAX (chỉ cho Candidate)
    (function loadNotifCount() {
        var badge = document.getElementById('notifCount');
        if (!badge) return; // Không phải Candidate
        fetch('${pageContext.request.contextPath}/user/notifications/count')
            .then(function(r) { return r.json(); })
            .then(function(data) {
                if (data.count > 0) {
                    badge.innerText = data.count > 9 ? '9+' : data.count;
                    badge.style.display = 'flex';
                }
            }).catch(function(){});
    })();
</script>

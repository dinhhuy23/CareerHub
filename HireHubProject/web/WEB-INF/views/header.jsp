<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
                <a href="${pageContext.request.contextPath}/user/dashboard" class="nav-link active">Dashboard</a>
            </c:if>
        </div>
        
        <div class="nav-user">
            <c:choose>
                <c:when test="${empty sessionScope.userId}">
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-outline" style="padding: 6px 16px; margin-right: 8px;">Đăng nhập</a>
                    <a href="${pageContext.request.contextPath}/register" class="btn btn-primary" style="padding: 6px 16px;">Đăng ký</a>
                </c:when>
                <c:otherwise>
                    <div class="user-dropdown">
                        <button class="user-btn" onclick="toggleDropdown()">
                            <div class="user-avatar">${sessionScope.userFullName.substring(0,1)}</div>
                            <span class="user-name">${sessionScope.userFullName}</span>
                            <svg width="16" height="16" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z"/></svg>
                        </button>
                        <div class="dropdown-menu" id="userDropdown">
                            <a href="${pageContext.request.contextPath}/user/profile" class="dropdown-item">Tài khoản</a>
                            <c:if test="${sessionScope.userRole == 'RECRUITER'}">
                                <a href="${pageContext.request.contextPath}/employer/jobs" class="dropdown-item">Quản lý tin tuyển dụng</a>
                            </c:if>
                            <hr class="dropdown-divider">
                            <a href="${pageContext.request.contextPath}/logout" class="dropdown-item text-danger">Đăng xuất</a>
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
                var openDropdown = dropdowns[i];
                if (openDropdown.classList.contains('show')) {
                    openDropdown.classList.remove('show');
                }
            }
        }
    }
</script>

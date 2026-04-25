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
            <%-- Lấy URI gốc trước khi forward để so sánh active menu --%>
            <c:set var="currentUri" value="${requestScope['jakarta.servlet.forward.request_uri']}" />
            <c:if test="${empty currentUri}">
                <c:set var="currentUri" value="${pageContext.request.requestURI}" />
            </c:if>

            <%-- Menu mặc định cho người chưa đăng nhập --%>
            <c:if test="${empty sessionScope.userRole}">
                <a href="${pageContext.request.contextPath}/jobs" 
                   class="nav-link ${currentUri.endsWith('/jobs') || currentUri.endsWith('/jobs/') ? 'active' : ''}">
                    Việc làm
                </a>
            </c:if>

            <c:if test="${not empty sessionScope.userRole}">
                <c:choose>
                    <%-- Nav dành cho ADMIN --%>
                    <c:when test="${sessionScope.userRole == 'ADMIN'}">
                        <a href="${pageContext.request.contextPath}/admin/recruiters" 
                           class="nav-link ${currentUri.contains('/admin/recruiters') ? 'active' : ''}">
                            Quản lý nhà tuyển dụng
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/applications" 
                           class="nav-link ${currentUri.contains('/admin/applications') ? 'active' : ''}">
                            Quản lý hồ sơ
                        </a>
                        <a href="${pageContext.request.contextPath}/jobs" 
                           class="nav-link ${currentUri.endsWith('/jobs') || currentUri.endsWith('/jobs/') ? 'active' : ''}">
                            Tất cả việc làm
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/company" class="nav-link ${currentUri.endsWith('/admin/company') || currentUri.endsWith('/admin/company/') ? 'active' : ''}">
                            Quản lý Công ty
                        </a>
                    </c:when>

                    <%-- Nav dành cho RECRUITER --%>
                    <c:when test="${sessionScope.userRole == 'RECRUITER'}">
                        <a href="${pageContext.request.contextPath}/employer/dashboard" 
                           class="nav-link ${currentUri.contains('/employer/dashboard') ? 'active' : ''}">
                            Dashboard
                        </a>
                        <a href="${pageContext.request.contextPath}/employer/jobs" 
                           class="nav-link ${currentUri.contains('/employer/jobs') ? 'active' : ''}">
                            Tin đăng
                        </a>
                        <a href="${pageContext.request.contextPath}/employer/applications" 
                           class="nav-link ${currentUri.contains('/employer/applications') ? 'active' : ''}">
                            Ứng viên
                        </a>
                        <a href="${pageContext.request.contextPath}/employer/browse_cv" 
                           class="nav-link ${currentUri.contains('/employer/browse_cv') ? 'active' : ''}">
                            Tìm ứng viên
                        </a>
                        <a href="${pageContext.request.contextPath}/employer/candidates" 
                           class="nav-link ${currentUri.contains('/employer/candidates') ? 'active' : ''}">
                           Khám phá ứng viên
                        </a>
                    </c:when>


                    <%-- Nav dành cho CANDIDATE --%>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/user/dashboard" 
                           class="nav-link ${currentUri.contains('/user/dashboard') ? 'active' : ''}">
                            Dashboard
                        </a>
                        <a href="${pageContext.request.contextPath}/jobs" 
                           class="nav-link ${currentUri.endsWith('/jobs') || currentUri.endsWith('/jobs/') ? 'active' : ''}">
                            Việc làm
                        </a>
                        <a href="${pageContext.request.contextPath}/user/cv/manage_cv" 
                           class="nav-link ${currentUri.contains('/user/cv/manage_cv') ? 'active' : ''}">
                            Quản Lí CV
                        </a>
                        <a href="${pageContext.request.contextPath}/user/saved-jobs" 
                           class="nav-link ${currentUri.contains('/user/saved-jobs') ? 'active' : ''}">
                            Việc làm đã lưu
                        </a>
                        <a href="${pageContext.request.contextPath}/user/saved-jobs" 
                           class="nav-link ${currentUri.contains('/user/saved-jobs') ? 'active' : ''}">
                           Việc làm đã lưu
                        </a>
                        <a href="${pageContext.request.contextPath}/user/interview-results" 
                           class="nav-link ${currentUri.contains('/user/interview-results') ? 'active' : ''}">
                           Kết quả phỏng vấn
                        </a>
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
<<<<<<< HEAD
=======

                    <%-- Icon chuông thông báo (chỉ hiện cho CANDIDATE) --%>
                    <c:if test="${sessionScope.userRole == 'CANDIDATE'}">
                        <a href="${pageContext.request.contextPath}/notification" id="notifBell"
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


>>>>>>> 5f0f75adbf749284d083c1981d9d7a1980dc5fd2
                    <div class="user-dropdown">
                        <button class="user-btn" type="button" onclick="toggleDropdown(event)">
                            <div class="user-avatar" style="position: relative;">
                                ${sessionScope.userFullName.substring(0,1).toUpperCase()}
                                <c:if test="${sessionScope.userRole == 'CANDIDATE'}">
                                    <span id="notifCount" style="display:none; position: absolute; top: -5px; right: -5px; background: var(--error); color: white; border-radius: 50%; width: 16px; height: 16px; font-size: 0.6rem; font-weight: 800; align-items: center; justify-content: center; border: 2px solid var(--bg-secondary); box-shadow: 0 2px 4px rgba(0,0,0,0.3);"></span>
                                </c:if>
                            </div>
                            <span class="user-name">${sessionScope.userFullName}</span>
                            <svg width="16" height="16" viewBox="0 0 20 20" fill="currentColor">
                                <path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z"/>
                            </svg>
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

                                <a href="${pageContext.request.contextPath}/user/saved-jobs" class="dropdown-item">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"></path></svg>
                                    Việc làm đã lưu
                                </a>
                                <a href="${pageContext.request.contextPath}/user/interview-results" class="dropdown-item">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="9 11 12 14 22 4"></polyline><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path></svg>
                                    Kết quả phỏng vấn
                                </a>
                             

                                <a href="${pageContext.request.contextPath}/notification" class="dropdown-item">
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

<style>
    .hirehub-chat-widget {
        position: fixed;
        right: 26px;
        bottom: 24px;
        z-index: 9999;
        user-select: none;
    }

    .hirehub-chat-widget.dragging {
        transition: none !important;
    }

    .cv-trigger-wrap {
        position: relative;
        width: 118px;
        height: 148px;
        cursor: grab;
        animation: floatCard 3.2s ease-in-out infinite;
    }

    .cv-trigger-wrap:active {
        cursor: grabbing;
    }

    .help-bubble {
        position: absolute;
        right: 110px;
        bottom: 98px;
        width: 260px;
        background: rgba(255,255,255,0.97);
        color: #1f2937;
        padding: 12px 14px;
        border-radius: 16px;
        box-shadow: 0 14px 30px rgba(0,0,0,0.18);
        font-size: 14px;
        line-height: 1.45;
        opacity: 1;
        transform: translateY(0);
        transition: all 0.3s ease;
        border: 1px solid rgba(99,102,241,0.14);
        pointer-events: none;
    }

    .help-bubble::after {
        content: "";
        position: absolute;
        right: -8px;
        bottom: 18px;
        width: 16px;
        height: 16px;
        background: white;
        transform: rotate(45deg);
        border-right: 1px solid rgba(99,102,241,0.14);
        border-top: 1px solid rgba(99,102,241,0.14);
    }

    .cv-card-trigger {
        position: absolute;
        right: 0;
        bottom: 0;
        width: 104px;
        height: 132px;
        border-radius: 20px;
        background: linear-gradient(180deg, #ffffff 0%, #f4f6ff 100%);
        box-shadow: 0 18px 40px rgba(9, 16, 45, 0.35), inset 0 1px 0 rgba(255,255,255,0.9);
        overflow: visible;
        border: 1px solid rgba(255,255,255,0.65);
    }

    .cv-card-top {
        height: 36px;
        background: linear-gradient(135deg, #6366F1, #8B5CF6);
        border-radius: 20px 20px 0 0;
    }

    .cv-lines {
        padding: 14px 14px 10px;
    }

    .cv-line {
        height: 8px;
        border-radius: 999px;
        background: #e3e8ff;
        margin-bottom: 9px;
    }

    .cv-line.w1 { width: 78%; }
    .cv-line.w2 { width: 58%; }
    .cv-line.w3 { width: 84%; }
    .cv-line.w4 { width: 48%; }

    .mini-badge {
        position: absolute;
        left: 12px;
        top: 48px;
        background: rgba(99,102,241,0.12);
        color: #5b5cf0;
        font-size: 11px;
        font-weight: 700;
        padding: 5px 9px;
        border-radius: 999px;
    }

    .ai-peek {
        position: absolute;
        top: -24px;
        right: 10px;
        width: 54px;
        height: 54px;
        border-radius: 50%;
        background: linear-gradient(135deg, #6d72ff, #9d6cff);
        box-shadow: 0 10px 20px rgba(99,102,241,0.34);
        display: flex;
        align-items: center;
        justify-content: center;
        border: 4px solid #ffffff;
    }

    .ai-face {
        width: 34px;
        height: 34px;
        border-radius: 50%;
        background: white;
        position: relative;
    }

    .ai-face::before, .ai-face::after {
        content: "";
        position: absolute;
        top: 12px;
        width: 5px;
        height: 5px;
        border-radius: 50%;
        background: #6366F1;
    }

    .ai-face::before { left: 8px; }
    .ai-face::after { right: 8px; }

    .ai-mouth {
        position: absolute;
        left: 50%;
        bottom: 8px;
        transform: translateX(-50%);
        width: 14px;
        height: 7px;
        border-bottom: 3px solid #6366F1;
        border-radius: 0 0 14px 14px;
    }

    .chat-window {
        position: absolute;
        right: 0;
        bottom: 0;
        width: 390px;
        height: 610px;
        border-radius: 26px;
        overflow: hidden;
        background: rgba(255,255,255,0.97);
        box-shadow: 0 28px 70px rgba(0,0,0,0.33);
        border: 1px solid rgba(255,255,255,0.2);
        opacity: 0;
        visibility: hidden;
        transform: translateY(26px) scale(0.92);
        transform-origin: bottom right;
        transition: all 0.32s ease;
    }

    .chat-window.active {
        opacity: 1;
        visibility: visible;
        transform: translateY(0) scale(1);
    }

    .chat-window-header {
        position: relative;
        padding: 18px 18px 16px;
        color: white;
        background: linear-gradient(135deg, #6366F1, #8B5CF6);
        display: flex;
        align-items: center;
        justify-content: space-between;
        cursor: grab;
    }

    .chat-window-header:active {
        cursor: grabbing;
    }

    .chat-window-header-left {
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .chat-header-avatar {
        width: 48px;
        height: 48px;
        border-radius: 14px;
        background: rgba(255,255,255,0.18);
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .chat-header-title {
        font-size: 18px;
        font-weight: 700;
        margin-bottom: 2px;
    }

    .chat-header-sub {
        font-size: 12px;
        opacity: 0.88;
    }

    .chat-header-close {
        width: 36px;
        height: 36px;
        border: none;
        border-radius: 12px;
        background: rgba(255,255,255,0.16);
        color: white;
        font-size: 18px;
        cursor: pointer;
    }

    .chat-window-body {
        height: calc(100% - 142px);
        overflow-y: auto;
        padding: 18px;
        background: radial-gradient(circle at top left, rgba(99,102,241,0.06), transparent 30%), #f8fafc;
    }

    .msg {
        margin-bottom: 14px;
        display: flex;
        animation: msgIn 0.25s ease;
    }

    .msg.user { justify-content: flex-end; }

    .bubble {
        max-width: 79%;
        padding: 12px 14px;
        border-radius: 16px;
        line-height: 1.55;
        white-space: pre-wrap;
        font-size: 14px;
        box-shadow: 0 8px 20px rgba(15,23,42,0.06);
    }

    .msg.user .bubble {
        background: linear-gradient(135deg, #6366F1, #7C3AED);
        color: white;
        border-bottom-right-radius: 6px;
    }

    .msg.bot .bubble {
        background: white;
        color: #111827;
        border: 1px solid #e5e7eb;
        border-bottom-left-radius: 6px;
    }

    .chat-window-input {
        height: 82px;
        border-top: 1px solid #e5e7eb;
        background: white;
        display: flex;
        align-items: center;
        gap: 10px;
        padding: 14px 16px;
    }

    .chat-window-input textarea {
        flex: 1;
        resize: none;
        height: 52px;
        padding: 14px;
        border: 1px solid #d6d9e4;
        border-radius: 14px;
        font-size: 14px;
        outline: none;
        background: #f8fafc;
    }

    .chat-window-input button {
        width: 56px;
        height: 52px;
        border: none;
        border-radius: 14px;
        background: linear-gradient(135deg, #6366F1, #8B5CF6);
        color: white;
        font-weight: 700;
        cursor: pointer;
        box-shadow: 0 10px 20px rgba(99,102,241,0.24);
    }

    @keyframes floatCard {
        0%, 100% { transform: translateY(0); }
        50% { transform: translateY(-8px); }
    }

    @keyframes msgIn {
        from { opacity: 0; transform: translateY(8px); }
        to { opacity: 1; transform: translateY(0); }
    }

    .typing {
        display: inline-flex;
        align-items: center;
        gap: 5px;
        padding: 4px 2px;
    }

    .typing span {
        width: 7px;
        height: 7px;
        border-radius: 50%;
        background: #98a2b3;
        animation: bounce 1.1s infinite ease-in-out;
    }

    .typing span:nth-child(2) { animation-delay: 0.15s; }
    .typing span:nth-child(3) { animation-delay: 0.3s; }

    @keyframes bounce {
        0%, 80%, 100% { transform: scale(0.8); opacity: 0.6; }
        40% { transform: scale(1.05); opacity: 1; }
    }
</style>

<div class="hirehub-chat-widget" id="hirehubChatWidget">
    <div class="chat-window" id="chatWindow">
        <div class="chat-window-header" id="chatDragHandle">
            <div class="chat-window-header-left">
                <div class="chat-header-avatar">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="12" cy="12" r="9"></circle>
                        <path d="M8 12h.01M16 12h.01"></path>
                        <path d="M9 16c1 .8 2 .8 3 .8s2 0 3-.8"></path>
                    </svg>
                </div>
                <div>
                    <div class="chat-header-title">HireHub AI</div>
                    <div class="chat-header-sub">Tư vấn việc làm & CV 24/7</div>
                </div>
            </div>
            <button class="chat-header-close" type="button" onclick="toggleChat(false, event)">×</button>
        </div>

        <div id="chatBox" class="chat-window-body">
            <div class="msg bot">
                <div class="bubble">Mình có thể hỗ trợ bạn về tìm việc, CV, định hướng ứng tuyển hoặc tối ưu hồ sơ cá nhân.</div>
            </div>
        </div>

        <div class="chat-window-input">
            <textarea id="messageInput" placeholder="Nhập câu hỏi của bạn..."></textarea>
            <button id="sendBtn" onclick="sendMessage()">➤</button>
        </div>
    </div>

    <div class="cv-trigger-wrap" id="chatTrigger" onclick="toggleChat(true, event)">
        <div class="help-bubble" id="helpBubble">
            <strong>HireHub AI:</strong> HireHub có thể hỗ trợ gì không?
        </div>

        <div class="cv-card-trigger">
            <div class="ai-peek">
                <div class="ai-face">
                    <div class="ai-mouth"></div>
                </div>
            </div>
            <div class="cv-card-top"></div>
            <div class="mini-badge">CV</div>
            <div class="cv-lines" style="padding-top: 28px;">
                <div class="cv-line w1"></div>
                <div class="cv-line w2"></div>
                <div class="cv-line w3"></div>
                <div class="cv-line w4"></div>
            </div>
        </div>
    </div>
</div>

<script>
    let chatDragging = false;
    let chatDragMoved = false;
    let lastChatDragTime = 0;
    let chatOffsetX = 0;
    let chatOffsetY = 0;

    function toggleChat(show, event) {
        if (event) {
            event.stopPropagation();
        }

        if (Date.now() - lastChatDragTime < 220) {
            return;
        }

        const chatWindow = document.getElementById("chatWindow");
        const trigger = document.getElementById("chatTrigger");
        const bubble = document.getElementById("helpBubble");

        if (!chatWindow || !trigger) return;

<<<<<<< HEAD
        if (show) {
            chatWindow.classList.add("active");
            if (bubble) bubble.style.opacity = "0";
            setTimeout(function () {
                trigger.style.pointerEvents = "none";
            }, 250);
        } else {
            chatWindow.classList.remove("active");
            trigger.style.pointerEvents = "auto";
            if (bubble) {
                setTimeout(function () {
                    bubble.style.opacity = "1";
                }, 180);
=======
        async function sendAiMessage() {
            const message = chatInput.value.trim();
            if (!message) return;

            appendMessage('user', message);
            chatInput.value = '';

            const loadingId = 'loading-' + Date.now();
            appendMessage('ai', 'Đang suy nghĩ...', loadingId);

            try {
                const res = await fetch('${pageContext.request.contextPath}/ai-chat', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
                    },
                    body: 'message=' + encodeURIComponent(message)
                });

                let data = {};
                try {
                    data = await res.json();
                } catch (e) {
                    data = {};
                }

                const loadingEl = document.getElementById(loadingId);
                if (loadingEl) loadingEl.remove();

                if (res.ok && data.reply) {
                    appendMessage('ai', data.reply);
                } else if (data.error) {
                    appendMessage('ai', data.error);
                } else if (data.message) {
                    appendMessage('ai', data.message);
                } else {
                    appendMessage('ai', 'Xin lỗi, tôi gặp chút trục trặc. Thử lại sau nhé!');
                }
            } catch (err) {
                console.error('Chatbot fetch error:', err);
                const loadingEl = document.getElementById(loadingId);
                if (loadingEl) loadingEl.remove();
                appendMessage('ai', 'Không thể kết nối tới server chatbot.');
            }
        }

        sendBtn.addEventListener('click', sendAiMessage);

        chatInput.addEventListener('keypress', function (e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                sendAiMessage();
            }
        });

        window.sendAiMessage = sendAiMessage;
    })();
</script>
    </script>

<script>
    function toggleDropdown() {
        document.getElementById("userDropdown").classList.toggle("show");
    }
    window.onclick = function (event) {
        if (!event.target.closest('.user-btn')) {
            var dropdowns = document.getElementsByClassName("dropdown-menu");
            for (var i = 0; i < dropdowns.length; i++) {
                if (dropdowns[i].classList.contains('show')) {
                    dropdowns[i].classList.remove('show');
                }
>>>>>>> 5f0f75adbf749284d083c1981d9d7a1980dc5fd2
            }
        }
    }

    function startChatDrag(event) {
        if (event.button !== 0) return;

        const widget = document.getElementById("hirehubChatWidget");
        if (!widget) return;

        if (event.target.closest(".chat-header-close") || event.target.closest("textarea") || event.target.closest("button")) {
            return;
        }

        const rect = widget.getBoundingClientRect();

        widget.style.left = rect.left + "px";
        widget.style.top = rect.top + "px";
        widget.style.right = "auto";
        widget.style.bottom = "auto";

        chatDragging = true;
        chatDragMoved = false;
        chatOffsetX = event.clientX - rect.left;
        chatOffsetY = event.clientY - rect.top;

        widget.classList.add("dragging");
        document.body.style.userSelect = "none";

        document.addEventListener("mousemove", onChatDrag);
        document.addEventListener("mouseup", stopChatDrag);
    }

    function onChatDrag(event) {
        if (!chatDragging) return;

        const widget = document.getElementById("hirehubChatWidget");
        if (!widget) return;

        let left = event.clientX - chatOffsetX;
        let top = event.clientY - chatOffsetY;

        const padding = 8;
        const maxLeft = window.innerWidth - widget.offsetWidth - padding;
        const maxTop = window.innerHeight - widget.offsetHeight - padding;

        if (left < padding) left = padding;
        if (top < padding) top = padding;
        if (left > maxLeft) left = maxLeft;
        if (top > maxTop) top = maxTop;

        widget.style.left = left + "px";
        widget.style.top = top + "px";

        chatDragMoved = true;
    }

    function stopChatDrag() {
        if (!chatDragging) return;

        const widget = document.getElementById("hirehubChatWidget");
        if (widget) {
            widget.classList.remove("dragging");
        }

        if (chatDragMoved) {
            lastChatDragTime = Date.now();
        }

        chatDragging = false;
        document.body.style.userSelect = "";

        document.removeEventListener("mousemove", onChatDrag);
        document.removeEventListener("mouseup", stopChatDrag);
    }

    async function sendMessage() {
        const input = document.getElementById("messageInput");
        const sendBtn = document.getElementById("sendBtn");
        const message = input.value.trim();

        if (!message) return;

        appendMessage("user", message);
        input.value = "";
        sendBtn.disabled = true;

        const typingId = appendTyping();

        try {
            const response = await fetch("${pageContext.request.contextPath}/api/chatbot", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ message: message })
            });

            const data = await response.json();
            removeTyping(typingId);

            if (data.success) {
                appendMessage("bot", data.reply);
            } else {
                appendMessage("bot", "Lỗi: " + (data.message || "Không gọi được chatbot"));
            }
        } catch (error) {
            removeTyping(typingId);
            appendMessage("bot", "Không kết nối được tới server.");
        } finally {
            sendBtn.disabled = false;
            input.focus();
        }
    }

    function appendMessage(role, text) {
        const chatBox = document.getElementById("chatBox");
        if (!chatBox) return;

        const msg = document.createElement("div");
        msg.className = "msg " + role;

        const bubble = document.createElement("div");
        bubble.className = "bubble";
        bubble.textContent = text;

        msg.appendChild(bubble);
        chatBox.appendChild(msg);
        chatBox.scrollTop = chatBox.scrollHeight;
    }

    function appendTyping() {
        const chatBox = document.getElementById("chatBox");
        if (!chatBox) return null;

        const id = "typing-" + Date.now();
        const msg = document.createElement("div");
        msg.className = "msg bot";
        msg.id = id;

        const bubble = document.createElement("div");
        bubble.className = "bubble";
        bubble.innerHTML = '<div class="typing"><span></span><span></span><span></span></div>';

        msg.appendChild(bubble);
        chatBox.appendChild(msg);
        chatBox.scrollTop = chatBox.scrollHeight;

        return id;
    }

    function removeTyping(id) {
        if (!id) return;
        const el = document.getElementById(id);
        if (el) el.remove();
    }

    function toggleDropdown(event) {
        if (event) {
            event.stopPropagation();
        }
        const dropdown = document.getElementById("userDropdown");
        if (dropdown) {
            dropdown.classList.toggle("show");
        }
    }

    document.addEventListener("DOMContentLoaded", function() {
        const input = document.getElementById("messageInput");
        const trigger = document.getElementById("chatTrigger");
        const dragHandle = document.getElementById("chatDragHandle");

        if (input) {
            input.addEventListener("keydown", function(e) {
                if (e.key === "Enter" && !e.shiftKey) {
                    e.preventDefault();
                    sendMessage();
                }
            });
        }

        if (trigger) {
            trigger.addEventListener("mousedown", startChatDrag);
        }

        if (dragHandle) {
            dragHandle.addEventListener("mousedown", startChatDrag);
        }
    });

    window.addEventListener("click", function(event) {
        if (!event.target.closest(".user-btn") && !event.target.closest("#userDropdown")) {
            const dropdown = document.getElementById("userDropdown");
            if (dropdown && dropdown.classList.contains("show")) {
                dropdown.classList.remove("show");
            }
        }
    });

    (function loadNotifCount() {
        var badge = document.getElementById('notifCount');
<<<<<<< HEAD
        if (!badge) return;

        fetch('${pageContext.request.contextPath}/user/notifications/count')
            .then(function(r) { return r.json(); })
            .then(function(data) {
                if (data.count > 0) {
                    badge.innerText = data.count > 9 ? '9+' : data.count;
                    badge.style.display = 'flex';
                }
            })
            .catch(function(){});
=======
        if (!badge)
            return; // Không phải Candidate
        fetch('${pageContext.request.contextPath}/user/notifications/count')
                .then(function (r) {
                    return r.json();
                })
                .then(function (data) {
                    if (data.count > 0) {
                        badge.innerText = data.count > 9 ? '9+' : data.count;
                        badge.style.display = 'flex';
                    }
                }).catch(function () {});
>>>>>>> 5f0f75adbf749284d083c1981d9d7a1980dc5fd2
    })();
</script>
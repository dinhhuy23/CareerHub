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
                <a href="${pageContext.request.contextPath}/interview-questions"
                   class="nav-link ${currentUri.contains('/interview-questions') ? 'active' : ''}">
                    Câu hỏi PV
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
                        
                        <a href="${pageContext.request.contextPath}/admin/company"
                           class="nav-link ${currentUri.contains('/admin/company') ? 'active' : ''}">Quản lý Công ty</a>
                        <a href="${pageContext.request.contextPath}/admin/departments"
                           class="nav-link ${currentUri.contains('/admin/departments') ? 'active' : ''}">Quản lý phòng ban</a>
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
                        <a href="${pageContext.request.contextPath}/user/interview-results" 
                           class="nav-link ${currentUri.contains('/user/interview-results') ? 'active' : ''}">
                           Kết quả phỏng vấn
                        </a>
                        <a href="${pageContext.request.contextPath}/interview-questions"
                           class="nav-link ${currentUri.contains('/interview-questions') ? 'active' : ''}">
                            Câu hỏi PV
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


                    <div class="user-dropdown">
                        <button class="user-btn" onclick="toggleDropdown()">
                            <div class="user-avatar">
                                ${sessionScope.userFullName.substring(0,1).toUpperCase()}
                                <%-- Badge thông báo kiểu tin nhắn: nằm đè lên góc avatar --%>
                                <c:if test="${sessionScope.userRole == 'CANDIDATE'}">
                                    <span id="notifCount" style="display:none; position: absolute; top: -5px; right: -5px; background: var(--error); color: white; border-radius: 50%; width: 16px; height: 16px; font-size: 0.6rem; font-weight: 800; align-items: center; justify-content: center; border: 2px solid var(--bg-secondary); box-shadow: 0 2px 4px rgba(0,0,0,0.3);"></span>
                                </c:if>
                            </div>
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

        <%-- CHATBOT AI SECTION --%>
   <%-- CHATBOT AI SECTION --%>
<style>
    .ai-chat-widget {
        position: fixed;
        bottom: 30px;
        right: 30px;
        z-index: 10000;
        font-family: 'Inter', sans-serif;
    }

    .chat-btn {
        width: 60px;
        height: 60px;
        border-radius: 50%;
        background: linear-gradient(135deg, #6366F1, #8B5CF6);
        box-shadow: 0 8px 32px rgba(99, 102, 241, 0.4);
        border: none;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        transition: transform 0.3s ease;
    }

    .chat-btn:hover {
        transform: scale(1.08);
    }

    .chat-window {
        position: absolute;
        bottom: 80px;
        right: 0;
        width: 350px;
        height: 500px;
        background: rgba(255, 255, 255, 0.96);
        backdrop-filter: blur(10px);
        border-radius: 24px;
        box-shadow: 0 20px 60px rgba(0,0,0,0.15);
        display: none;
        flex-direction: column;
        overflow: hidden;
        border: 1px solid rgba(255,255,255,0.3);
    }

    .chat-window.active {
        display: flex;
    }

    .chat-header {
        background: linear-gradient(135deg, #6366F1, #8B5CF6);
        padding: 20px;
        color: white;
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .chat-body {
        flex: 1;
        padding: 20px;
        overflow-y: auto;
        display: flex;
        flex-direction: column;
        gap: 12px;
        background: #f8fafc;
    }

    .msg {
        max-width: 80%;
        padding: 10px 16px;
        border-radius: 16px;
        font-size: 0.9rem;
        line-height: 1.5;
        white-space: pre-wrap;
        word-break: break-word;
    }

    .msg.user {
        align-self: flex-end;
        background: #6366F1;
        color: white;
        border-bottom-right-radius: 4px;
    }

    .msg.ai {
        align-self: flex-start;
        background: white;
        color: #1e293b;
        border-bottom-left-radius: 4px;
        border: 1px solid #e2e8f0;
    }

    .chat-footer {
        padding: 16px;
        background: white;
        border-top: 1px solid #e2e8f0;
        display: flex;
        gap: 8px;
    }

    .chat-input {
        flex: 1;
        border: 1px solid #e2e8f0;
        border-radius: 12px;
        padding: 10px 16px;
        outline: none;
    }

    .chat-input:focus {
        border-color: #6366F1;
    }

    .send-btn {
        background: #6366F1;
        color: white;
        border: none;
        width: 40px;
        height: 40px;
        border-radius: 10px;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
    }
</style>

<div class="ai-chat-widget">
    <div class="chat-window" id="aiChatWindow">
        <div class="chat-header">
            <div style="width: 40px; height: 40px; background: rgba(255,255,255,0.2); border-radius: 12px; display: flex; align-items: center; justify-content: center;">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M21 11.5a8.38 8.38 0 0 1-.9 3.8 8.5 8.5 0 1 1-7.6-10.6 8.5 8.5 0 0 1 7.6 10.6l.9-3.8z"></path>
                </svg>
            </div>
            <div>
                <div style="font-weight: 800; font-size: 1rem;">HireHub AI</div>
                <div style="font-size: 0.75rem; opacity: 0.8;">Hỗ trợ ứng tuyển 24/7</div>
            </div>
        </div>

        <div class="chat-body" id="chatBody">
            <div class="msg ai">Xin chào! Tôi có thể giúp gì cho bạn trong việc tìm kiếm việc làm hôm nay?</div>
        </div>

        <div class="chat-footer">
            <input type="text" class="chat-input" id="chatInput" placeholder="Nhập câu hỏi...">
            <button type="button" class="send-btn" id="sendChatBtn">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="22" y1="2" x2="11" y2="13"></line>
                    <polygon points="22 2 15 22 11 13 2 9 22 2"></polygon>
                </svg>
            </button>
        </div>
    </div>

    <button type="button" class="chat-btn" id="toggleChatBtn">
        <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path>
        </svg>
    </button>
</div>

<script>
    (function () {
        const chatWindow = document.getElementById('aiChatWindow');
        const toggleBtn = document.getElementById('toggleChatBtn');
        const sendBtn = document.getElementById('sendChatBtn');
        const chatInput = document.getElementById('chatInput');
        const chatBody = document.getElementById('chatBody');

        if (!chatWindow || !toggleBtn || !sendBtn || !chatInput || !chatBody) {
            console.error('Chat widget init failed: thiếu element');
            return;
        }

        toggleBtn.addEventListener('click', function () {
            chatWindow.classList.toggle('active');
        });

        function appendMessage(role, text, id) {
            const div = document.createElement('div');
            div.className = 'msg ' + role;
            if (id) div.id = id;
            div.innerText = text;
            chatBody.appendChild(div);
            chatBody.scrollTop = chatBody.scrollHeight;
        }

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
            }
        }
    }

    // Lấy số thông báo chưa đọc bằng AJAX (chỉ cho Candidate)
    (function loadNotifCount() {
        var badge = document.getElementById('notifCount');
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
    })();
</script>

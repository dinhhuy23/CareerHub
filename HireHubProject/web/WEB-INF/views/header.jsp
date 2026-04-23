<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HireHub Chatbot</title>
    <style>
        * {
            box-sizing: border-box;
        }

        body {
            font-family: Arial, sans-serif;
            background:
                radial-gradient(circle at top left, rgba(99,102,241,0.18), transparent 28%),
                radial-gradient(circle at bottom right, rgba(139,92,246,0.14), transparent 30%),
                linear-gradient(135deg, #070b1f 0%, #0b1028 45%, #090d22 100%);
            margin: 0;
            min-height: 100vh;
            overflow-x: hidden;
        }

        .hirehub-chat-widget {
            position: fixed;
            right: 26px;
            bottom: 24px;
            z-index: 9999;
        }

        .cv-trigger-wrap {
            position: relative;
            width: 118px;
            height: 148px;
            cursor: pointer;
            animation: floatCard 3.2s ease-in-out infinite;
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

        .help-bubble strong {
            color: #5b5cf0;
        }

        .cv-trigger-wrap:hover .help-bubble {
            transform: translateY(-4px);
        }

        .cv-card-trigger {
            position: absolute;
            right: 0;
            bottom: 0;
            width: 104px;
            height: 132px;
            border-radius: 20px;
            background: linear-gradient(180deg, #ffffff 0%, #f4f6ff 100%);
            box-shadow:
                0 18px 40px rgba(9, 16, 45, 0.35),
                inset 0 1px 0 rgba(255,255,255,0.9);
            overflow: visible;
            border: 1px solid rgba(255,255,255,0.65);
        }

        .cv-card-trigger::before {
            content: "";
            position: absolute;
            top: 0;
            right: 0;
            width: 28px;
            height: 28px;
            background: linear-gradient(135deg, #e3e8ff 0%, #cfd8ff 100%);
            clip-path: polygon(0 0, 100% 0, 100% 100%);
            border-top-right-radius: 20px;
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

        .ai-face::before,
        .ai-face::after {
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

        .chat-window.active + .cv-trigger-wrap {
            opacity: 0;
            visibility: hidden;
            transform: translateY(10px) scale(0.9);
            pointer-events: none;
        }

        .chat-window-header {
            position: relative;
            padding: 18px 18px 16px;
            color: white;
            background: linear-gradient(135deg, #6366F1, #8B5CF6);
            display: flex;
            align-items: center;
            justify-content: space-between;
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
            flex-shrink: 0;
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
            transition: 0.2s ease;
        }

        .chat-header-close:hover {
            background: rgba(255,255,255,0.26);
        }

        .chat-window-body {
            height: calc(100% - 142px);
            overflow-y: auto;
            padding: 18px;
            background:
                radial-gradient(circle at top left, rgba(99,102,241,0.06), transparent 30%),
                #f8fafc;
        }

        .chat-window-body::-webkit-scrollbar {
            width: 7px;
        }

        .chat-window-body::-webkit-scrollbar-thumb {
            background: rgba(99,102,241,0.25);
            border-radius: 20px;
        }

        .msg {
            margin-bottom: 14px;
            display: flex;
            animation: msgIn 0.25s ease;
        }

        .msg.user {
            justify-content: flex-end;
        }

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
            transition: 0.2s ease;
        }

        .chat-window-input textarea:focus {
            border-color: #6366F1;
            box-shadow: 0 0 0 4px rgba(99,102,241,0.10);
            background: #fff;
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
            transition: transform 0.18s ease, box-shadow 0.18s ease;
            box-shadow: 0 10px 20px rgba(99,102,241,0.24);
        }

        .chat-window-input button:hover {
            transform: translateY(-1px);
        }

        .chat-window-input button:disabled {
            opacity: 0.65;
            cursor: not-allowed;
            transform: none;
        }

        @keyframes floatCard {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-8px); }
        }

        @keyframes msgIn {
            from {
                opacity: 0;
                transform: translateY(8px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes bounce {
            0%, 80%, 100% { transform: scale(0.8); opacity: 0.6; }
            40% { transform: scale(1.05); opacity: 1; }
        }

        @media (max-width: 768px) {
            .hirehub-chat-widget {
                right: 14px;
                bottom: 14px;
            }

            .chat-window {
                width: calc(100vw - 28px);
                max-width: 390px;
                height: 78vh;
                max-height: 610px;
            }

            .help-bubble {
                width: 220px;
                right: 84px;
                font-size: 13px;
            }
        }
    </style>
</head>
<%-- ================= CHATBOT CAT AI ================= --%>

<style>
.cat-chat-wrapper {
    position: fixed;
    right: 25px;
    bottom: 25px;
    z-index: 9999;
}

/* ===== CV ICON ===== */
.cv-box {
    width: 110px;
    height: 140px;
    background: white;
    border-radius: 20px;
    box-shadow: 0 15px 40px rgba(0,0,0,0.3);
    position: relative;
    cursor: pointer;
    overflow: visible;
}

.cv-top {
    height: 35px;
    background: linear-gradient(135deg,#6366F1,#8B5CF6);
    border-radius: 20px 20px 0 0;
}

.cv-lines {
    padding: 15px;
}

.cv-line {
    height: 8px;
    background: #e5e7eb;
    border-radius: 10px;
    margin-bottom: 8px;
}

/* ===== CAT ===== */
.cat {
    position: absolute;
    top: -30px;
    right: 10px;
    width: 60px;
    animation: floatCat 2.5s infinite ease-in-out;
}

/* ===== SPEECH ===== */
.speech {
    position: absolute;
    right: 120px;
    bottom: 100px;
    background: white;
    padding: 12px 14px;
    border-radius: 15px;
    width: 240px;
    font-size: 14px;
    box-shadow: 0 10px 25px rgba(0,0,0,0.2);
}

.speech:after {
    content: "";
    position: absolute;
    right: -8px;
    bottom: 15px;
    width: 15px;
    height: 15px;
    background: white;
    transform: rotate(45deg);
}

/* ===== CHAT BOX ===== */
.chat-box {
    position: absolute;
    right: 0;
    bottom: 0;
    width: 380px;
    height: 580px;
    background: white;
    border-radius: 25px;
    box-shadow: 0 30px 80px rgba(0,0,0,0.4);
    overflow: hidden;

    transform: scale(0.9) translateY(30px);
    opacity: 0;
    visibility: hidden;
    transition: 0.3s;
}

.chat-box.active {
    transform: scale(1);
    opacity: 1;
    visibility: visible;
}

/* HEADER */
.chat-header {
    background: linear-gradient(135deg,#6366F1,#8B5CF6);
    color: white;
    padding: 15px;
    display: flex;
    justify-content: space-between;
}

/* BODY */
.chat-body {
    height: 420px;
    overflow-y: auto;
    padding: 15px;
    background: #f9fafb;
}

/* MESSAGE */
.msg {
    margin-bottom: 10px;
}

.msg.user {
    text-align: right;
}

.bubble {
    display: inline-block;
    padding: 10px 14px;
    border-radius: 15px;
    max-width: 75%;
}

.msg.user .bubble {
    background: #6366F1;
    color: white;
}

.msg.bot .bubble {
    background: white;
    border: 1px solid #ddd;
}

/* INPUT */
.chat-input {
    display: flex;
    border-top: 1px solid #ddd;
}

.chat-input input {
    flex: 1;
    border: none;
    padding: 12px;
    outline: none;
}

.chat-input button {
    background: #6366F1;
    color: white;
    border: none;
    padding: 12px 15px;
}

/* ANIMATION */
@keyframes floatCat {
    0%,100%{transform: translateY(0)}
    50%{transform: translateY(-8px)}
}
</style>

<div class="cat-chat-wrapper">

    <!-- CHAT BOX -->
    <div class="chat-box" id="chatBox">

        <div class="chat-header">
            <b>HireHub AI</b>
            <button onclick="toggleChat(false)">✖</button>
        </div>

        <div class="chat-body" id="chatBody">
            <div class="msg bot">
                <div class="bubble">
                    Xin chào! Mình là HireHub AI 🐱
                </div>
            </div>
        </div>

        <div class="chat-input">
            <input id="chatInput" placeholder="Nhập câu hỏi...">
            <button onclick="sendMsg()">➤</button>
        </div>

    </div>

    <!-- ICON CV + CAT -->
    <div class="cv-box" onclick="toggleChat(true)">
        <div class="cv-top"></div>

        <div class="cv-lines">
            <div class="cv-line"></div>
            <div class="cv-line"></div>
            <div class="cv-line"></div>
        </div>

        <!-- CAT IMAGE -->
        <img src="https://i.imgur.com/8Qf4K0T.png" class="cat"/>

        <!-- SPEECH -->
        <div class="speech">
            <b>HireHub AI:</b><br>
            Bạn có cần hỗ trợ việc làm - CV không?
        </div>
    </div>

</div>

<script>
function toggleChat(open){
    const box = document.getElementById("chatBox");
    if(open) box.classList.add("active");
    else box.classList.remove("active");
}

function sendMsg(){
    const input = document.getElementById("chatInput");
    const body = document.getElementById("chatBody");

    let text = input.value.trim();
    if(!text) return;

    body.innerHTML += `
        <div class="msg user">
            <div class="bubble">${text}</div>
        </div>
    `;

    input.value = "";

    body.innerHTML += `
        <div class="msg bot">
            <div class="bubble">Đang trả lời...</div>
        </div>
    `;

    body.scrollTop = body.scrollHeight;
}
</script>

    <script>
        function toggleChat(show) {
            const chatWindow = document.getElementById("chatWindow");
            const trigger = document.getElementById("chatTrigger");
            const bubble = document.getElementById("helpBubble");

            if (show) {
                chatWindow.classList.add("active");
                if (bubble) bubble.style.opacity = "0";
                setTimeout(() => {
                    if (trigger) trigger.style.pointerEvents = "none";
                }, 250);
            } else {
                chatWindow.classList.remove("active");
                if (trigger) trigger.style.pointerEvents = "auto";
                if (bubble) {
                    setTimeout(() => {
                        bubble.style.opacity = "1";
                    }, 180);
                }
            }
        }

        async function sendMessage() {
            const input = document.getElementById("messageInput");
            const sendBtn = document.getElementById("sendBtn");
            const chatBox = document.getElementById("chatBox");

            const message = input.value.trim();
            if (!message) return;

            appendMessage("user", message);
            input.value = "";
            sendBtn.disabled = true;

            const typingId = appendTyping();

            try {
                const response = await fetch("${pageContext.request.contextPath}/api/chatbot", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json"
                    },
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
                console.error(error);
                removeTyping(typingId);
                appendMessage("bot", "Không kết nối được tới server.");
            } finally {
                sendBtn.disabled = false;
                input.focus();
            }
        }

        function appendMessage(role, text) {
            const chatBox = document.getElementById("chatBox");
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
            const msg = document.createElement("div");
            const id = "typing-" + Date.now();
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
            const el = document.getElementById(id);
            if (el) el.remove();
        }

        document.getElementById("messageInput").addEventListener("keydown", function(e) {
            if (e.key === "Enter" && !e.shiftKey) {
                e.preventDefault();
                sendMessage();
            }
        });

        setTimeout(function() {
            const bubble = document.getElementById("helpBubble");
            if (bubble) {
                bubble.style.transform = "translateY(-4px)";
                setTimeout(function() {
                    bubble.style.transform = "translateY(0)";
                }, 600);
            }
        }, 1200);
    </script>
</body>
</html>
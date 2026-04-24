<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HireHub Chatbot</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f5f7fb;
            margin: 0;
            padding: 24px;
        }
        .chat-wrapper {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: 16px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.08);
            overflow: hidden;
        }
        .chat-header {
            background: #111827;
            color: white;
            padding: 18px 20px;
            font-size: 20px;
            font-weight: 700;
        }
        .chat-box {
            height: 500px;
            overflow-y: auto;
            padding: 20px;
            background: #fafafa;
        }
        .msg {
            margin-bottom: 14px;
            display: flex;
        }
        .msg.user {
            justify-content: flex-end;
        }
        .bubble {
            max-width: 75%;
            padding: 12px 14px;
            border-radius: 14px;
            line-height: 1.5;
            white-space: pre-wrap;
        }
        .msg.user .bubble {
            background: #2563eb;
            color: white;
        }
        .msg.bot .bubble {
            background: #e5e7eb;
            color: #111827;
        }
        .chat-input {
            display: flex;
            gap: 10px;
            padding: 16px;
            border-top: 1px solid #e5e7eb;
            background: white;
        }
        .chat-input textarea {
            flex: 1;
            resize: none;
            height: 60px;
            padding: 12px;
            border: 1px solid #d1d5db;
            border-radius: 12px;
            font-size: 15px;
        }
        .chat-input button {
            width: 120px;
            border: none;
            border-radius: 12px;
            background: #111827;
            color: white;
            font-weight: 700;
            cursor: pointer;
        }
        .chat-input button:disabled {
            opacity: 0.6;
            cursor: not-allowed;
        }
    </style>
</head>
<body>
    <div class="chat-wrapper">
        <div class="chat-header">HireHub Chatbot</div>

        <div id="chatBox" class="chat-box">
            <div class="msg bot">
                <div class="bubble">Xin chào, tôi có thể hỗ trợ gì cho bạn?</div>
            </div>
        </div>

        <div class="chat-input">
            <textarea id="messageInput" placeholder="Nhập câu hỏi của bạn..."></textarea>
            <button id="sendBtn" onclick="sendMessage()">Gửi</button>
        </div>
    </div>

    <script>
        async function sendMessage() {
            const input = document.getElementById("messageInput");
            const sendBtn = document.getElementById("sendBtn");
            const chatBox = document.getElementById("chatBox");

            const message = input.value.trim();
            if (!message) return;

            appendMessage("user", message);
            input.value = "";
            sendBtn.disabled = true;

            try {
                const response = await fetch("${pageContext.request.contextPath}/api/chatbot", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json"
                    },
                    body: JSON.stringify({ message: message })
                });

                const data = await response.json();

                if (data.success) {
                    appendMessage("bot", data.reply);
                } else {
                    appendMessage("bot", "Lỗi: " + (data.message || "Không gọi được chatbot"));
                }
            } catch (error) {
                console.error(error);
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

        document.getElementById("messageInput").addEventListener("keydown", function(e) {
            if (e.key === "Enter" && !e.shiftKey) {
                e.preventDefault();
                sendMessage();
            }
        });
    </script>
</body>
</html>
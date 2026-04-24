<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.UserCV" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    UserCV cv = (UserCV) request.getAttribute("cvData");
    if (cv == null) cv = new UserCV();

    String fullName = (cv.getFullName() != null) ? cv.getFullName() : "HỌ VÀ TÊN";
    String role = (cv.getTargetRole() != null) ? cv.getTargetRole() : "Vị trí ứng tuyển";
    
    String avatar = (cv.getAvatarUrl() != null && !cv.getAvatarUrl().isEmpty()) 
                    ? cv.getAvatarUrl() 
                    : request.getContextPath() + "/images/default-avatar.png";
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>CV Hiện Đại - <%= fullName %></title>
        <style>
            :root {
                --accent-color: #FF9800;
                --sidebar-bg: #333C44;
                --text-light: #FFFFFF;
                --text-gray: #777;
            }
            body {
                background-color: #f0f0f0;
                font-family: 'Segoe UI', Arial, sans-serif;
                margin: 0;
                padding: 20px;
                color: #333;
            }

            .cv-page {
                width: 210mm;
                min-height: 297mm;
                background: #fff;
                margin: 0 auto;
                display: flex;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }

            /* Sidebar bên trái */
            .sidebar {
                width: 35%;
                background-color: var(--sidebar-bg);
                color: var(--text-light);
                padding: 30px 20px;
                box-sizing: border-box;
            }
            .sidebar-avatar {
                width: 100%;
                aspect-ratio: 1/1;
                background: #eee;
                margin-bottom: 25px;
                overflow: hidden;
            }
            .sidebar-avatar img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .sidebar h2 {
                color: var(--accent-color);
                font-size: 28px;
                margin: 0;
                text-transform: none;
            }
            .sidebar .sidebar-role {
                color: var(--accent-color);
                font-style: italic;
                font-size: 16px;
                margin-bottom: 30px;
            }

            .sidebar-section {
                margin-bottom: 25px;
            }
            .sidebar-title {
                color: var(--accent-color);
                font-weight: bold;
                font-size: 16px;
                border-bottom: 1px solid var(--accent-color);
                margin-bottom: 15px;
                padding-bottom: 5px;
                display: flex;
                align-items: center;
                white-space: nowrap; /* QUAN TRỌNG: Không cho phép xuống dòng */
            }
            .sidebar-title::after {
                content: '';
                flex: 1;
                border-bottom: 1px solid rgba(255,152,0,0.5); /* Tạo đường kẻ mảnh */
                margin-left: 10px;
            }

            .sidebar-item {
                font-size: 13px;
                margin-bottom: 10px;
                display: flex;
                align-items: center;
            }
            .sidebar-item .icon {
                color: var(--accent-color);
                margin-right: 10px;
                width: 15px;
                text-align: center;
            }

            /* Nội dung bên phải */
            .main-content {
                width: 65%;
                padding: 40px 30px;
                box-sizing: border-box;
            }

            .main-section {
                margin-bottom: 30px;
            }
            .main-title {
                color: var(--accent-color);
                font-weight: bold;
                font-size: 18px;
                border-bottom: 1px solid var(--accent-color);
                margin-bottom: 15px;
                padding-bottom: 5px;
                display: flex;
                align-items: center;
                white-space: nowrap; /* QUAN TRỌNG: Không cho phép xuống dòng */
            }
            .main-title::after {
                content: '';
                flex: 1;
                border-bottom: 1px solid rgba(255,152,0,0.3); /* Đường kẻ mờ kéo dài */
                margin-left: 10px;
            }

            .item-row {
                margin-bottom: 15px;
            }
            .item-header {
                display: flex;
                justify-content: space-between;
                font-weight: bold;
                font-size: 14px;
                margin-bottom: 5px;
            }
            .item-sub {
                color: #555;
                font-weight: bold;
                font-size: 14px;
                margin-bottom: 5px;
            }
            .item-time {
                font-style: italic;
                color: var(--text-gray);
                font-weight: normal;
                font-size: 12px;
            }
            .item-body {
                font-size: 13px;
                color: var(--text-gray);
                white-space: pre-line;
                line-height: 1.5;
            }

        </style>
    </head>
    <body>
        <div class="cv-page">
            <div class="sidebar">
                <div class="sidebar-avatar">
                    <img src="<%= avatar %>" alt="Avatar">
                </div>
                <h2><%= fullName %></h2>
                <div class="sidebar-role"><%= role %></div>

                <div class="sidebar-section">
                    <div class="sidebar-title">Thông tin cá nhân</div>
                    <div class="sidebar-item"><span class="icon">📞</span> <%= (cv.getPhone() != null) ? cv.getPhone() : "0123 456 789" %></div>
                    <div class="sidebar-item"><span class="icon">✉</span> <%= (cv.getEmail() != null) ? cv.getEmail() : "email@gmail.com" %></div>
                    <div class="sidebar-item"><span class="icon">🔗</span> facebook.com/User</div>
                    <div class="sidebar-item"><span class="icon">📍</span> <%= (cv.getAddress() != null) ? cv.getAddress() : "Địa chỉ của bạn" %></div>
                </div>

                <div class="sidebar-section">
                    <div class="sidebar-title">Kỹ năng</div>
                    <div class="sidebar-item">Tên kỹ năng</div>
                    <div class="sidebar-item">Tên kỹ năng</div>
                </div>

                <div class="sidebar-section">
                    <div class="sidebar-title">Chứng chỉ</div>
                    <div class="item-body" style="color: white">Thời gian - Tên chứng chỉ</div>
                </div>

                <div class="sidebar-section">
                    <div class="sidebar-title">Sở thích</div>
                    <div class="sidebar-item">Điền các sở thích của bạn</div>
                </div>
            </div>

            <div class="main-content">
                <div class="main-section">
                    <div class="main-title">Mục tiêu nghề nghiệp</div>
                    <div class="item-body"><%= (cv.getSummary() != null && !cv.getSummary().isEmpty()) ? cv.getSummary() : "Mục tiêu nghề nghiệp của bạn..." %></div>
                </div>

                <div class="main-section">
                    <div class="main-title">Kinh nghiệm làm việc</div>
                    <div class="item-row">
                        <div class="item-body"><%= (cv.getExperienceRaw() != null && !cv.getExperienceRaw().trim().isEmpty()) ? cv.getExperienceRaw() : "Mô tả kinh nghiệm của bạn" %></div>
                    </div>
                </div>

                <div class="main-section">
                    <div class="main-title">Học vấn</div>
                    <div class="item-row">
                        <div class="item-body"><%= (cv.getEducationRaw() != null && !cv.getEducationRaw().trim().isEmpty()) ? cv.getEducationRaw() : "Mô tả quá trình học tập của bạn" %></div>
                    </div>
                </div>

                <div class="main-section">
                    <div class="main-title">Hoạt động</div>
                    <div class="item-header">
                        <span>Vị trí của bạn</span>
                        <span class="item-time">Bắt đầu - Kết thúc</span>
                    </div>
                    <div class="item-sub">Tên tổ chức</div>
                    <div class="item-body">Mô tả hoạt động</div>
                </div>
            </div>
        </div>
    </body>
</html>
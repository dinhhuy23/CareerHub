<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.UserCV" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // Lấy dữ liệu từ Servlet thông qua attribute "cvData"
    UserCV cv = (UserCV) request.getAttribute("cvData"); 
    if (cv == null) cv = new UserCV();

    String fullName = (cv.getFullName() != null && !cv.getFullName().isEmpty()) ? cv.getFullName() : "HỌ VÀ TÊN";
    String role = (cv.getTargetRole() != null && !cv.getTargetRole().isEmpty()) ? cv.getTargetRole() : "Vị trí ứng tuyển";
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    String birthDate = (cv.getBirthDate() != null) ? sdf.format(cv.getBirthDate()) : "Ngày sinh";
    
    String avatar = (cv.getAvatarUrl() != null && !cv.getAvatarUrl().isEmpty()) 
                     ? cv.getAvatarUrl() : request.getContextPath() + "/images/default-avatar.png";
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>CV Template 6 - <%= fullName %></title>
        <style>
            :root {
                --sidebar-bg: #7d4444; /* Màu nâu đỏ giống ảnh mẫu */
                --sidebar-dark: #5a3232;
                --accent-color: #a66060;
                --text-white: #ffffff;
                --text-dark: #333333;
            }
            body {
                background-color: #e9eef1;
                font-family: 'Arial', sans-serif;
                margin: 0;
                padding: 20px;
            }

            .cv-container {
                width: 210mm;
                min-height: 297mm;
                background: #fff;
                margin: 0 auto;
                display: flex;
                box-shadow: 0 0 15px rgba(0,0,0,0.2);
            }

            /* Sidebar (Cột trái) */
            .sidebar {
                width: 35%;
                background-color: var(--sidebar-bg);
                color: var(--text-white);
                padding: 40px 25px;
            }

            .avatar-container {
                text-align: center;
                margin-bottom: 30px;
            }
            .avatar-circle {
                width: 160px;
                height: 160px;
                border-radius: 50%;
                border: 5px solid rgba(255,255,255,0.2);
                margin: 0 auto;
                overflow: hidden;
                background: #eee;
            }
            .avatar-circle img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .profile-name {
                font-size: 28px;
                font-weight: bold;
                margin-top: 20px;
                text-align: center;
            }
            .profile-role {
                font-size: 16px;
                font-style: italic;
                opacity: 0.9;
                margin-bottom: 30px;
                text-align: center;
            }

            .contact-info {
                margin-top: 20px;
                font-size: 13px;
            }
            .contact-item {
                display: flex;
                align-items: center;
                margin-bottom: 12px;
                border-bottom: 1px solid rgba(255,255,255,0.1);
                padding-bottom: 5px;
            }
            .contact-item span {
                margin-right: 10px;
                font-size: 16px;
            }

            .sidebar-section-title {
                background-color: var(--accent-color);
                padding: 8px 15px;
                border-radius: 20px;
                font-size: 16px;
                font-weight: bold;
                margin: 30px 0 15px;
            }
            .sidebar-content {
                font-size: 13px;
                line-height: 1.6;
                white-space: pre-line;
            }

            /* Main Content (Cột phải) */
            .main-content {
                width: 65%;
                padding: 40px;
                color: var(--text-dark);
            }

            .main-section {
                margin-bottom: 30px;
            }
            .main-section-header {
                display: flex;
                align-items: center;
                margin-bottom: 15px;
            }
            .section-pill {
                background-color: var(--sidebar-bg);
                color: white;
                padding: 8px 25px;
                border-radius: 25px;
                font-weight: bold;
                font-size: 15px;
                flex-shrink: 0;
            }
            .section-line {
                flex-grow: 1;
                height: 1px;
                background: var(--sidebar-bg);
                margin-left: 15px;
            }

            .entry {
                margin-bottom: 20px;
            }
            .entry-header {
                display: flex;
                justify-content: space-between;
                font-weight: bold;
                font-size: 14px;
                margin-bottom: 5px;
            }
            .entry-sub {
                font-style: italic;
                color: #666;
                font-size: 13px;
                margin-bottom: 5px;
            }
            .entry-desc {
                font-size: 13px;
                line-height: 1.6;
                color: #444;
                white-space: pre-line;
            }
        </style>
    </head>
    <body>
        <div class="cv-container">
            <div class="sidebar">
                <div class="avatar-container">
                    <div class="avatar-circle">
                        <img src="<%= avatar %>" alt="Avatar">
                    </div>
                    <div class="profile-name"><%= fullName %></div>
                    <div class="profile-role"><%= role %></div>
                </div>

                <div class="contact-info">
                    <div class="contact-item"><span>📞</span> <%= (cv.getPhone() != null) ? cv.getPhone() : "Chưa cập nhật" %></div>
                    <div class="contact-item"><span>📅</span> <%= birthDate %></div>
                    <div class="contact-item"><span>✉</span> <%= (cv.getEmail() != null) ? cv.getEmail() : "Chưa cập nhật" %></div>
                    <div class="contact-item"><span>🌐</span> facebook.com/TopCV.vn</div>
                    <div class="contact-item"><span>📍</span> <%= (cv.getAddress() != null) ? cv.getAddress() : "Địa chỉ" %></div>
                </div>

                <div class="sidebar-section-title">Học vấn</div>
                <div class="sidebar-content">
                    <%= (cv.getEducationRaw() != null && !cv.getEducationRaw().trim().isEmpty()) 
                    ? cv.getEducationRaw() : "Ngành học / Môn học\nBắt đầu - Kết thúc\nTên trường học" %>
                </div>
            </div>

            <div class="main-content">
                <div class="main-section">
                    <div class="main-section-header">
                        <div class="section-pill">Mục tiêu nghề nghiệp</div>
                        <div class="section-line"></div>
                    </div>
                    <div class="entry-desc">
                        <%= (cv.getSummary() != null && !cv.getSummary().isEmpty()) 
                        ? cv.getSummary() : "Mục tiêu nghề nghiệp của bạn, bao gồm mục tiêu ngắn hạn và dài hạn." %>
                    </div>
                </div>

                <div class="main-section">
                    <div class="main-section-header">
                        <div class="section-pill">Kinh nghiệm làm việc</div>
                        <div class="section-line"></div>
                    </div>
                    <div class="entry-desc">
                        <%= (cv.getExperienceRaw() != null && !cv.getExperienceRaw().trim().isEmpty()) 
                        ? cv.getExperienceRaw() : "Vị trí công việc | Bắt đầu - Kết thúc\nTên công ty\nMô tả kinh nghiệm làm việc của bạn." %>
                    </div>
                </div>

                <div class="main-section">
                    <div class="main-section-header">
                        <div class="section-pill">Danh hiệu và giải thưởng</div>
                        <div class="section-line"></div>
                    </div>
                    <div class="entry-desc">Thời gian | Tên giải thưởng</div>
                </div>

                <div class="main-section">
                    <div class="main-section-header">
                        <div class="section-pill">Chứng chỉ</div>
                        <div class="section-line"></div>
                    </div>
                    <div class="entry-desc">Thời gian | Tên chứng chỉ</div>
                </div>

                <div class="main-section">
                    <div class="main-section-header">
                        <div class="section-pill">Dự án</div>
                        <div class="section-line"></div>
                    </div>
                    <div class="entry-desc">Mô tả dự án cá nhân hoặc nhóm của bạn.</div>
                </div>
            </div>
        </div>
    </body>
</html>
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
    String birthDate = (cv.getBirthDate() != null) ? sdf.format(cv.getBirthDate()) : "DD/MM/YYYY";
    
    String avatar = (cv.getAvatarUrl() != null && !cv.getAvatarUrl().isEmpty()) 
                     ? cv.getAvatarUrl() : request.getContextPath() + "/images/default-avatar.png";
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>CV Professional - <%= fullName %></title>
        <style>
            :root {
                --primary-bg: #f3f4f6;
                --section-title-bg: #eff2f5;
                --text-dark: #2c3e50;
                --text-gray: #666;
            }
            body {
                background-color: #d1d5db;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                margin: 0;
                padding: 20px;
            }

            .cv-container {
                width: 210mm;
                min-height: 297mm;
                background: #fff;
                margin: 0 auto;
                padding: 50px;
                box-sizing: border-box;
                box-shadow: 0 0 20px rgba(0,0,0,0.2);
            }

            /* Header giống mẫu 2 */
            .header {
                display: flex;
                align-items: center;
                margin-bottom: 30px;
            }
            .avatar-circle {
                width: 140px;
                height: 140px;
                border-radius: 50%;
                overflow: hidden;
                border: 4px solid #fff;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            .avatar-circle img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .header-content {
                flex: 1;
                margin-left: 40px;
            }
            .header-content h1 {
                margin: 0;
                font-size: 38px;
                color: var(--text-dark);
                text-transform: none;
            }
            .header-content .role-title {
                font-size: 20px;
                color: var(--text-gray);
                margin: 5px 0 15px;
            }

            .contact-grid {
                display: grid;
                grid-template-columns: 1fr 1fr 1fr;
                gap: 10px;
                font-size: 12px;
                color: var(--text-gray);
            }
            .contact-item {
                display: flex;
                align-items: center;
            }
            .contact-item span {
                margin-right: 8px;
                font-size: 14px;
            }

            /* Section Titles ngang toàn trang */
            .section {
                margin-top: 25px;
            }
            .section-header {
                background-color: var(--section-title-bg);
                padding: 8px 0;
                text-align: center;
                font-weight: bold;
                text-transform: uppercase;
                color: var(--text-dark);
                letter-spacing: 2px;
                font-size: 16px;
                margin-bottom: 15px;
            }

            .content-block {
                padding: 0 20px;
                font-size: 14px;
                line-height: 1.6;
                color: #333;
                white-space: pre-line;
            }

            /* Layout cho Học vấn/Kinh nghiệm dạng List */
            .entry {
                display: flex;
                margin-bottom: 15px;
            }
            .entry-time {
                width: 150px;
                font-style: italic;
                color: var(--text-gray);
                flex-shrink: 0;
            }
            .entry-detail {
                flex: 1;
            }
            .entry-title {
                font-weight: bold;
                color: var(--text-dark);
            }

            /* Kỹ năng chia cột */
            .skills-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 10px 40px;
            }
            .skill-item {
                display: flex;
                align-items: center;
            }
            .skill-item::before {
                content: "•";
                margin-right: 10px;
                color: var(--text-dark);
            }
        </style>
    </head>
    <body>
        <div class="cv-container">
            <div class="header">
                <div class="avatar-circle">
                    <img src="<%= avatar %>" alt="Avatar">
                </div>
                <div class="header-content">
                    <h1><%= fullName %></h1>
                    <div class="role-title"><%= role %></div>
                    <div class="contact-grid">
                        <div class="contact-item"><span>📅</span> <%= birthDate %></div>
                        <div class="contact-item"><span>📞</span> <%= (cv.getPhone() != null) ? cv.getPhone() : "Chưa cập nhật" %></div>
                        <div class="contact-item"><span>✉</span> <%= (cv.getEmail() != null) ? cv.getEmail() : "Chưa cập nhật" %></div>
                        <div class="contact-item"><span>👤</span> <%= (cv.getGender() != null) ? cv.getGender() : "Nam/Nữ" %></div>
                        <div class="contact-item"><span>📍</span> <%= (cv.getAddress() != null) ? cv.getAddress() : "Địa chỉ" %></div>
                        <div class="contact-item"><span>🔗</span> facebook.com/topcv</div>
                    </div>
                </div>
            </div>

            <div class="section">
                <div class="section-header">Mục tiêu nghề nghiệp</div>
                <div class="content-block">
                    <%= (cv.getSummary() != null && !cv.getSummary().isEmpty()) ? cv.getSummary() : "Mục tiêu nghề nghiệp của bạn, bao gồm mục tiêu ngắn hạn và dài hạn." %>
                </div>
            </div>

            <div class="section">
                <div class="section-header">Học vấn</div>
                <div class="content-block">
                    <%= (cv.getEducationRaw() != null && !cv.getEducationRaw().trim().isEmpty()) ? cv.getEducationRaw() : "Thông tin học vấn của bạn." %>
                </div>
            </div>

            <div class="section">
                <div class="section-header">Kinh nghiệm làm việc</div>
                <div class="content-block">
                    <%= (cv.getExperienceRaw() != null && !cv.getExperienceRaw().trim().isEmpty()) ? cv.getExperienceRaw() : "Mô tả kinh nghiệm làm việc của bạn." %>
                </div>
            </div>

        </div>
    </body>
</html>
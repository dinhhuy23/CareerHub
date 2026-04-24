<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.UserCV" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // ĐIỀU CHỈNH CHÍNH: Đổi "cv" thành "cvData" để khớp với Servlet
    UserCV cv = (UserCV) request.getAttribute("cvData"); 
    if (cv == null) cv = new UserCV();

    String fullName = (cv.getFullName() != null && !cv.getFullName().isEmpty()) ? cv.getFullName() : "HỌ VÀ TÊN";
    String role = (cv.getTargetRole() != null && !cv.getTargetRole().isEmpty()) ? cv.getTargetRole() : "Vị trí ứng tuyển";
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    // Sử dụng giá trị mặc định giống template 1 nếu ngày sinh null
    String birthDate = (cv.getBirthDate() != null) ? sdf.format(cv.getBirthDate()) : "15/05/1995";
    
    String avatar = (cv.getAvatarUrl() != null && !cv.getAvatarUrl().isEmpty()) 
                     ? cv.getAvatarUrl() : request.getContextPath() + "/images/default-avatar.png";
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>CV Chuyên nghiệp - <%= fullName %></title>
        <style>
            :root {
                --navy-blue: #2c3e50;
                --text-main: #333;
                --text-light: #7f8c8d;
            }
            body {
                background-color: #f4f7f6;
                font-family: 'Arial', sans-serif;
                margin: 0;
                padding: 20px;
            }
            .cv-paper {
                width: 210mm;
                min-height: 297mm;
                background: #fff;
                margin: 0 auto;
                box-shadow: 0 0 15px rgba(0,0,0,0.1);
                display: flex;
                flex-direction: column;
            }
            .header-section {
                display: flex;
                padding: 40px;
                align-items: flex-start;
            }
            .avatar-box {
                width: 170px;
                height: 200px;
                margin-right: 35px;
                border: 1px solid #eee;
                overflow: hidden;
            }
            .avatar-box img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .name-box {
                flex: 1;
            }
            .name-box h1 {
                margin: 0;
                font-size: 34px;
                color: var(--navy-blue);
                border-left: 6px solid var(--navy-blue);
                padding-left: 20px;
            }
            .job-title {
                font-size: 19px;
                color: var(--text-light);
                margin: 10px 0 20px 25px;
                font-style: italic;
            }
            .summary-box {
                background: #f8f9fa;
                padding: 15px;
                font-size: 13px;
                line-height: 1.6;
                border-radius: 4px;
            }

            .main-body {
                display: grid;
                grid-template-columns: 1.7fr 1.3fr;
                padding: 0 40px 40px;
                gap: 40px;
            }
            .section-header {
                font-size: 15px;
                font-weight: bold;
                color: var(--navy-blue);
                text-transform: uppercase;
                border-bottom: 2px solid var(--navy-blue);
                margin: 25px 0 12px;
                padding-bottom: 5px;
            }
            .edu-highlight {
                background: var(--navy-blue);
                color: white;
                padding: 20px;
                border-radius: 4px;
            }
            .edu-highlight .section-header {
                color: white;
                border-bottom-color: white;
                margin-top: 0;
            }

            .content-text {
                font-size: 13px;
                line-height: 1.7;
                white-space: pre-line;
            }
            .sidebar-item {
                margin-bottom: 10px;
                font-size: 13px;
                display: flex;
                align-items: center;
            }
            .sidebar-item span {
                margin-right: 10px;
                color: var(--navy-blue);
                font-weight: bold;
                width: 20px;
            }
        </style>
    </head>
    <body>
        <div class="cv-paper">
            <div class="header-section">
                <div class="avatar-box">
                    <img src="<%= avatar %>" alt="Avatar">
                </div>
                <div class="name-box">
                    <h1><%= fullName %></h1>
                    <div class="job-title"><%= role %></div>
                    <div class="summary-box">
                        <%= (cv.getSummary() != null && !cv.getSummary().isEmpty()) ? cv.getSummary() : "Mục tiêu nghề nghiệp của bạn..." %>
                    </div>
                </div>
            </div>

            <div class="main-body">
                <div class="left-col">
                    <div class="edu-highlight">
                        <div class="section-header">Học vấn</div>
                        <div class="content-text"><%= (cv.getEducationRaw() != null && !cv.getEducationRaw().trim().isEmpty()) ? cv.getEducationRaw() : "Tên trường học\nNgành học\n2020 - 2024" %></div>
                    </div>

                    <div class="section-header">Kinh nghiệm làm việc</div>
                    <div class="content-text"><%= (cv.getExperienceRaw() != null && !cv.getExperienceRaw().trim().isEmpty()) ? cv.getExperienceRaw() : "Bắt đầu - Kết thúc\nTên công ty\nVị trí công việc" %></div>

                    <div class="section-header">Hoạt động</div>
                    <div class="content-text">
                        Thông tin các hoạt động ngoại khóa và đóng góp cộng đồng.
                    </div>
                </div>

                <div class="right-col">
                    <div class="section-header">Thông tin cá nhân</div>
                    <div class="sidebar-item"><span>📞</span> <%= (cv.getPhone() != null) ? cv.getPhone() : "0123 456 789" %></div>
                    <div class="sidebar-item"><span>✉</span> <%= (cv.getEmail() != null) ? cv.getEmail() : "email@gmail.com" %></div>
                    <div class="sidebar-item"><span>📍</span> <%= (cv.getAddress() != null) ? cv.getAddress() : "Địa chỉ của bạn" %></div>
                    <div class="sidebar-item"><span>📅</span> <%= birthDate %></div>

                    <div class="section-header">Kỹ năng</div>
                    <div class="content-text">
                        Dữ liệu kỹ năng từ hệ thống.
                    </div>

                    <div class="section-header">Chứng chỉ</div>
                    <div class="content-text">
                        Dữ liệu chứng chỉ từ hệ thống.
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
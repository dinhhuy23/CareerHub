<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.UserCV" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    UserCV cv = (UserCV) request.getAttribute("cvData");
    if (cv == null) cv = new UserCV();

    String fullName = (cv.getFullName() != null) ? cv.getFullName() : "HỌ VÀ TÊN";
    String role = (cv.getTargetRole() != null) ? cv.getTargetRole() : "Vị trí ứng tuyển";
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    String birthDate = (cv.getBirthDate() != null) ? sdf.format(cv.getBirthDate()) : "15/05/1995";
    
    String avatar = (cv.getAvatarUrl() != null && !cv.getAvatarUrl().isEmpty()) ? cv.getAvatarUrl() : request.getContextPath() + "/images/default-avatar.png";
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>CV Thanh Lịch - <%= fullName %></title>
        <style>
            :root {
                --main-color: #A3262A;
                --text-gray: #666;
            }
            body {
                background-color: #f0f0f0;
                font-family: 'Arial', sans-serif;
                margin: 0;
                padding: 20px;
                color: #333;
            }
            .cv-page {
                width: 210mm;
                min-height: 297mm;
                background: #fff;
                margin: 0 auto;
                padding: 40px;
                box-sizing: border-box;
                display: flex;
                flex-direction: column;
            }

            /* Header */
            .cv-header {
                display: flex;
                align-items: flex-start;
                margin-bottom: 20px;
            }
            .avatar {
                width: 160px;
                height: 160px;
                background: #ddd;
                overflow: hidden;
                border: 1px solid #eee;
            }
            .avatar img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }
            .header-info {
                margin-left: 30px;
                flex: 1;
            }
            .header-info h1 {
                color: var(--main-color);
                font-size: 32px;
                margin: 0 0 5px 0;
            }
            .header-info .role {
                font-size: 18px;
                color: #555;
                font-style: italic;
                margin-bottom: 10px;
            }
            .header-info .summary {
                border-top: 1.5px solid #000;
                padding-top: 10px;
                font-size: 13px;
                color: var(--text-gray);
                line-height: 1.6;
            }

            /* Bố cục Grid mới: 3 cột phía trên */
            .cv-body {
                display: grid;
                grid-template-columns: 1fr 1fr 1fr; /* Chia đều 3 cột */
                column-gap: 30px;
                row-gap: 10px;
            }

            /* Section chung */
            .section-title {
                color: #000;
                font-weight: bold;
                font-size: 15px;
                border-bottom: 2px solid var(--main-color);
                margin: 20px 0 10px 0;
                padding-bottom: 5px;
                text-transform: uppercase;
            }

            /* Cột thông tin cá nhân */
            .info-item {
                display: flex;
                align-items: center;
                font-size: 12px;
                margin-bottom: 8px;
            }
            .info-item span.icon {
                width: 20px;
                height: 20px;
                background: var(--main-color);
                color: #fff;
                border-radius: 3px;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-right: 10px;
                font-size: 10px;
            }

            /* Phần mô tả văn bản */
            .item-desc {
                font-size: 12.5px;
                color: #333;
                white-space: pre-line;
                line-height: 1.6;
            }

            /* Ép phần Kinh nghiệm làm việc tràn hết 3 cột */
            .full-row {
                grid-column: 1 / span 3;
            }
        </style>
    </head>
    <body>
        <div class="cv-page">
            <div class="cv-header">
                <div class="avatar">
                    <img src="<%= avatar %>" alt="Avatar">
                </div>
                <div class="header-info">
                    <h1><%= fullName %></h1>
                    <div class="role"><%= role %></div>
                    <div class="summary">
                        <%= (cv.getSummary() != null && !cv.getSummary().isEmpty()) ? cv.getSummary() : "Mục tiêu nghề nghiệp của bạn..." %>
                    </div>
                </div>
            </div>

            <div class="cv-body">

                <div class="column">
                    <div class="section-title">Thông tin cá nhân</div>
                    <div class="info-item"><span class="icon">📅</span> <%= birthDate %></div>
                    <div class="info-item"><span class="icon">✉</span> <%= (cv.getEmail() != null) ? cv.getEmail() : "email@gmail.com" %></div>
                    <div class="info-item"><span class="icon">📞</span> <%= (cv.getPhone() != null) ? cv.getPhone() : "0123 456 789" %></div>
                    <div class="info-item"><span class="icon">📍</span> <%= (cv.getAddress() != null) ? cv.getAddress() : "Địa chỉ của bạn" %></div>
                </div>

                <div class="column">
                    <div class="section-title">Học vấn</div>
                    <div class="item-desc"><%= (cv.getEducationRaw() != null && !cv.getEducationRaw().trim().isEmpty()) ? cv.getEducationRaw() : "Tên trường học\nNgành học\n2020 - 2024" %></div>
                </div>

                <div class="column">
                    <div class="section-title">Chứng chỉ</div>
                    <div class="item-desc">Thời gian
                        Tên chứng chỉ</div>
                </div>

                <div class="full-row">
                    <div class="section-title">Kinh nghiệm làm việc</div>
                    <div class="item-desc"><%= (cv.getExperienceRaw() != null && !cv.getExperienceRaw().trim().isEmpty()) ? cv.getExperienceRaw() : "Bắt đầu - Kết thúc\nTên công ty\nVị trí công việc" %></div>
                </div>

            </div>
        </div>
    </body>
</html>
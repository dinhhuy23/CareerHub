<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.UserCV" %>
<%@ page import="java.text.SimpleDateFormat" %> <%-- THÊM DÒNG NÀY --%>
<%
    UserCV cv = (UserCV) request.getAttribute("cvData");
    if (cv == null) {
        cv = new UserCV();
    }

    // XỬ LÝ FORMAT NGÀY SINH
    String formattedBirthDate = "DD/MM/YYYY";
    if (cv.getBirthDate() != null) {
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        formattedBirthDate = sdf.format(cv.getBirthDate());
    }

    String fullName = (cv.getFullName() != null) ? cv.getFullName() : "HỌ VÀ TÊN";
    String gender = (cv.getGender() != null) ? cv.getGender() : "Chưa xác định";
    // ... các biến khác giữ nguyên ...
    
    String role = (cv.getTargetRole() != null) ? cv.getTargetRole() : "Vị trí ứng tuyển";
    String summary = (cv.getSummary() != null) ? cv.getSummary() : "";
    String education = (cv.getEducationRaw() != null) ? cv.getEducationRaw() : "";
    String experience = (cv.getExperienceRaw() != null) ? cv.getExperienceRaw() : "";
    
    String avatar = (cv.getAvatarUrl() != null) ? cv.getAvatarUrl() : "";
    String defaultAvatar = request.getContextPath() + "/images/default-avatar.png";
    if (avatar.isEmpty()) {
        avatar = defaultAvatar;
    }
%>

<%-- Phần <head> và <style> giữ nguyên như cũ của bạn --%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Xem trước CV - <%= fullName %></title>
        <style>
            /* Giữ nguyên CSS của bạn */
            body { background-color: #f5f5f5; font-family: "Times New Roman", Times, serif; margin: 0; padding: 20px; }
            .cv-container { width: 210mm; min-height: 297mm; margin: 0 auto; background-color: white; padding: 40px; box-shadow: 0 0 15px rgba(0,0,0,0.2); box-sizing: border-box; }
            .cv-header { display: flex; border-bottom: 2px solid #000; padding-bottom: 20px; margin-bottom: 20px; }
            .avatar-box { width: 140px; height: 180px; border: 1px solid #ccc; margin-right: 30px; overflow: hidden; background-color: #eee; }
            .avatar-box img { width: 100%; height: 100%; object-fit: cover; display: block; }
            .header-info { flex: 1; }
            .header-info h1 { margin: 0; font-size: 32px; color: #000; text-transform: uppercase; }
            .header-info .job-title { font-size: 18px; color: #555; font-style: italic; margin: 5px 0 15px 0; }
            .contact-info { display: grid; grid-template-columns: 1fr 1fr; font-size: 14px; gap: 5px; }
            .contact-info div span { font-weight: bold; display: inline-block; width: 90px; }
            .section-title { font-size: 16px; font-weight: bold; text-transform: uppercase; border-bottom: 1px solid #333; margin: 25px 0 10px 0; padding-bottom: 3px; }
            .section-content { font-size: 14px; line-height: 1.6; color: #333; white-space: pre-line; }
            .empty-note { color: #999; font-style: italic; }
        </style>
    </head>
    <body>
        <div class="cv-container">
            <div class="cv-header">
                <div class="avatar-box">
                    <img src="<%= avatar %>" alt="Avatar" onerror="this.onerror=null;this.src='<%= defaultAvatar %>';">
                </div>
                <div class="header-info">
                    <h1><%= fullName %></h1>
                    <div class="job-title"><%= role %></div>
                    <div class="contact-info">
                        <div><span>Ngày sinh:</span> <%= formattedBirthDate %></div>
                        
                        <div><span>Giới tính:</span> <%= gender %></div>
                        <div><span>Điện thoại:</span> <%= (cv.getPhone() != null) ? cv.getPhone() : "" %></div>
                        <div><span>Email:</span> <%= (cv.getEmail() != null) ? cv.getEmail() : "" %></div>
                        <div style="grid-column: span 2;"><span>Địa chỉ:</span> <%= (cv.getAddress() != null) ? cv.getAddress() : "" %></div>
                    </div>
                </div>
            </div>

            <%-- Các section bên dưới giữ nguyên --%>
            <div class="section-title">Mục tiêu nghề nghiệp</div>
            <div class="section-content">
                <%= summary.trim().isEmpty() ? "<span class='empty-note'>Chưa mô tả mục tiêu nghề nghiệp.</span>" : summary %>
            </div>

            <div class="section-title">Học vấn</div>
            <div class="section-content">
                <%= education.trim().isEmpty() ? "<span class='empty-note'>Chưa cập nhật thông tin học vấn.</span>" : education %>
            </div>

            <div class="section-title">Kinh nghiệm làm việc</div>
            <div class="section-content">
                <%= experience.trim().isEmpty() ? "<span class='empty-note'>Chưa cập nhật kinh nghiệm làm việc.</span>" : experience %>
            </div>
        </div>
    </body>
</html>
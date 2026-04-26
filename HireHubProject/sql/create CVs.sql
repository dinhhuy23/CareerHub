-- 1. Tạo bảng CVTags
CREATE TABLE CVTags (
    TagId INT IDENTITY(1,1) PRIMARY KEY,
    TagName NVARCHAR(100) NOT NULL,
    TagSlug VARCHAR(100) NOT NULL
);

-- 2. Tạo bảng CVTemplates
CREATE TABLE CVTemplates (
    TemplateId INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    ImageThumbnail NVARCHAR(500),
    BaseFileJsp VARCHAR(100) NOT NULL,
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- 3. Tạo bảng CVTemplate_Tags (Bảng trung gian n-n giữa CVTags và CVTemplates)
CREATE TABLE CVTemplate_Tags (
    TemplateId INT NOT NULL,
    TagId INT NOT NULL,
    PRIMARY KEY (TemplateId, TagId),
    FOREIGN KEY (TemplateId) REFERENCES CVTemplates(TemplateId),
    FOREIGN KEY (TagId) REFERENCES CVTags(TagId)
);

-- 4. Tạo bảng UserCVs
CREATE TABLE UserCVs (
    UserCVId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL, -- Cột này thường là Foreign Key liên kết với bảng Users (tài khoản)
    TemplateId INT NULL,
    CVTitle NVARCHAR(255),
    Summary NVARCHAR(MAX),
    ExperienceRaw NVARCHAR(MAX),
    EducationRaw NVARCHAR(MAX),
    CreatedAt DATETIME DEFAULT GETDATE(),
    FullName NVARCHAR(100),
    TargetRole NVARCHAR(100),
    AvatarUrl NVARCHAR(500),
    BirthDate DATE,
    Address NVARCHAR(255),
    Phone VARCHAR(20),
    Email VARCHAR(100),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    Gender NVARCHAR(20),
    IsUpload BIT DEFAULT 0,
    IsAccepted BIT DEFAULT 0,
    IsDeleted BIT DEFAULT 0,
    IsSearchable BIT DEFAULT 1,
    FOREIGN KEY (TemplateId) REFERENCES CVTemplates(TemplateId),
	FOREIGN KEY (UserId) REFERENCES Users(UserId)
);
----------------------------------------------------------------------------------------------------------------
-- 1. Thêm dữ liệu vào bảng CVTags
SET IDENTITY_INSERT CVTags ON;

INSERT INTO CVTags (TagId, TagName, TagSlug) 
VALUES
    (1, N'Đơn giản', 'simple'),
    (2, N'Chuyên nghiệp', 'professional'),
    (3, N'Hiện đại', 'modern'),
    (4, N'Sáng tạo', 'creative');

SET IDENTITY_INSERT CVTags OFF;
GO

-- 2. Thêm dữ liệu vào bảng CVTemplates
-- Lưu ý: Cột ImageThumbnail trên ảnh bị che khuất phần đuôi url, 
-- mình đã giả định tên file là template_1.png, template_2.png... Bạn có thể sửa lại cho đúng với thực tế.
SET IDENTITY_INSERT CVTemplates ON;

INSERT INTO CVTemplates (TemplateId, Name, ImageThumbnail, BaseFileJsp, IsActive, CreatedAt) 
VALUES
    (1, N'Thanh Lịch', 'https://res.cloudinary.com/doomoxozs/image/upload/v1776396483/cv1_kjhrur.png', 'template_1.jsp', 1, '2026-04-17 02:14:25.327'),
    (2, N'Tiêu Chuẩn', 'https://res.cloudinary.com/doomoxozs/image/upload/v1776396492/cv2_dvzvia.png', 'template_2.jsp', 1, '2026-04-17 02:14:25.327'),
    (3, N'Tham Vọng', 'https://res.cloudinary.com/doomoxozs/image/upload/v1776396499/cv3_d0jq7z.png', 'template_3.jsp', 1, '2026-04-17 02:14:25.327'),
    (4, N'Tối Giản', 'https://res.cloudinary.com/doomoxozs/image/upload/v1776396506/cv4_yagjhv.png', 'template_4.jsp', 1, '2026-04-17 02:14:25.327'),
    (5, N'Tiêu Chuẩn', 'https://res.cloudinary.com/doomoxozs/image/upload/v1776396510/cv5_v1okku.png', 'template_5.jsp', 1, '2026-04-17 02:14:25.327'),
    (6, N'Ấn Tượng', 'https://res.cloudinary.com/doomoxozs/image/upload/v1776396520/cv6_cg4bkr.png', 'template_6.jsp', 1, '2026-04-17 02:14:25.327');

SET IDENTITY_INSERT CVTemplates OFF;
GO

-- 3. Thêm dữ liệu vào bảng CVTemplate_Tags (Bảng trung gian)
-- Bảng này thường chỉ có khóa ngoại, không có IDENTITY nên không cần SET IDENTITY_INSERT
INSERT INTO CVTemplate_Tags (TemplateId, TagId) 
VALUES
    (1, 1),
    (1, 3),
    (2, 1),
    (3, 2),
    (3, 4),
    (4, 2),
    (4, 3),
    (5, 1);
GO

SELECT * FROM CVTags
SELECT * FROM CVTemplates
SELECT * FROM CVTemplate_Tags

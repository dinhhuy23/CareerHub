-- ==========================================
-- HireHub: HOÀN CHỈNH DỮ LIỆU TEST (DELETE TRƯỚC, INSERT SAU)
-- Tự động điền dữ liệu nếu thiếu để đảm bảo luôn chạy được
-- ==========================================
USE [HireHubDB]
GO

-- ==========================================
-- BƯỚC 0: XÓA DỮ LIỆU CŨ TRƯỚC KHI THÊM
-- Xóa theo thứ tự Ràng buộc Khóa ngoại (Foreign Key)
-- ==========================================
BEGIN TRY
    -- Lấy ID của các user test
    DECLARE @delCandidateUserId BIGINT = (SELECT UserId FROM dbo.Users WHERE Email = N'candidate.test@hirehub.vn');
    DECLARE @delHrUserId BIGINT = (SELECT UserId FROM dbo.Users WHERE Email = N'hr.test@hirehub.vn');
    
    DECLARE @delCandidateId BIGINT = NULL;
    IF @delCandidateUserId IS NOT NULL SET @delCandidateId = (SELECT CandidateId FROM dbo.CandidateProfiles WHERE UserId = @delCandidateUserId);
    
    DECLARE @delHrProfileId BIGINT = NULL;
    IF @delHrUserId IS NOT NULL SET @delHrProfileId = (SELECT RecruiterId FROM dbo.RecruiterProfiles WHERE UserId = @delHrUserId);

    -- Xóa Application History & Applications
    IF @delCandidateId IS NOT NULL
    BEGIN
        DELETE FROM dbo.ApplicationStatusHistory WHERE ApplicationId IN (SELECT ApplicationId FROM dbo.Applications WHERE CandidateId = @delCandidateId);
        DELETE FROM dbo.Applications WHERE CandidateId = @delCandidateId;
    END

    -- Xóa Notifications
    IF @delCandidateUserId IS NOT NULL OR @delHrUserId IS NOT NULL
    BEGIN
        DELETE FROM dbo.NotificationRecipients WHERE UserId IN (@delCandidateUserId, @delHrUserId);
        DELETE FROM dbo.Notifications WHERE CreatedByUserId IN (@delCandidateUserId, @delHrUserId);
    END

    -- Xóa Jobs của test HR (phải xóa JobSkills, SavedJobs nếu có trước khi xóa Job)
    IF @delHrProfileId IS NOT NULL
    BEGIN
        DECLARE @jobIds TABLE (JobId BIGINT);
        INSERT INTO @jobIds SELECT JobId FROM dbo.Jobs WHERE PostedByRecruiterId = @delHrProfileId;
        
        DELETE FROM dbo.SavedJobs WHERE JobId IN (SELECT JobId FROM @jobIds);
        DELETE FROM dbo.JobSkills WHERE JobId IN (SELECT JobId FROM @jobIds);
        DELETE FROM dbo.Jobs WHERE PostedByRecruiterId = @delHrProfileId;
    END

    -- Xóa Profiles
    IF @delCandidateUserId IS NOT NULL DELETE FROM dbo.CandidateProfiles WHERE UserId = @delCandidateUserId;
    IF @delHrUserId IS NOT NULL DELETE FROM dbo.RecruiterProfiles WHERE UserId = @delHrUserId;

    -- Xóa Roles và Users
    IF @delCandidateUserId IS NOT NULL OR @delHrUserId IS NOT NULL
    BEGIN
        DELETE FROM dbo.UserRoles WHERE UserId IN (@delCandidateUserId, @delHrUserId);
        DELETE FROM dbo.Users WHERE UserId IN (@delCandidateUserId, @delHrUserId);
    END

    PRINT N'✅ Đã xóa sạch dữ liệu test cũ.';
END TRY
BEGIN CATCH
    PRINT N'⚠️ Có lỗi khi xóa (có thể do thiếu bảng hoặc ràng buộc khác), tiếp tục chạy...';
    PRINT ERROR_MESSAGE();
END CATCH
GO

-- ==========================================
-- BƯỚC 1: ĐẢM BẢO BẢNG STATUSES CÓ DỮ LIỆU
-- ==========================================
IF NOT EXISTS (SELECT 1 FROM dbo.ApplicationStatuses)
BEGIN
    SET IDENTITY_INSERT dbo.ApplicationStatuses ON;
    INSERT INTO dbo.ApplicationStatuses (ApplicationStatusId, StatusCode, StatusName, SortOrder, IsFinalStatus, IsActive)
    VALUES 
        (1, N'PENDING', N'Chờ duyệt', 1, 0, 1),
        (2, N'REVIEWING', N'Đang xem xét', 2, 0, 1),
        (3, N'INTERVIEWING', N'Phỏng vấn', 3, 0, 1),
        (4, N'OFFERED', N'Trúng tuyển', 4, 1, 1),
        (5, N'REJECTED', N'Không phù hợp', 5, 1, 1),
        (6, N'WITHDRAWN', N'Rút đơn', 6, 1, 1);
    SET IDENTITY_INSERT dbo.ApplicationStatuses OFF;
    PRINT N'✅ Đã khởi tạo dữ liệu cho ApplicationStatuses';
END
GO

-- ==========================================
-- BƯỚC 2: TẠO CANDIDATE
-- Dùng số điện thoại ngẫu nhiên để tránh lỗi Unique Phone Number
-- ==========================================
DECLARE @candidateUserId BIGINT;
-- Dùng số điện thoại 0999000111 để tránh đụng với user khác
INSERT INTO dbo.Users (Email, PasswordHash, FullName, PhoneNumber, Gender, Status, EmailVerified, CreatedAt, UpdatedAt)
VALUES (N'candidate.test@hirehub.vn', N'$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LnS37cux2Vm', N'Nguyễn Văn Ứng Viên', N'0999000111', N'MALE', N'ACTIVE', 1, SYSUTCDATETIME(), SYSUTCDATETIME());
SET @candidateUserId = SCOPE_IDENTITY();

INSERT INTO dbo.UserRoles (UserId, RoleId, AssignedAt, IsActive)
SELECT @candidateUserId, RoleId, SYSUTCDATETIME(), 1 FROM dbo.Roles WHERE RoleCode = N'CANDIDATE';

INSERT INTO dbo.CandidateProfiles (UserId, Headline, EmploymentStatus, IsPublicProfile, CreatedAt, UpdatedAt)
VALUES (@candidateUserId, N'Java Developer', N'OPEN_TO_WORK', 1, SYSUTCDATETIME(), SYSUTCDATETIME());
PRINT N'✅ Đã tạo Candidate Test';
GO

-- ==========================================
-- BƯỚC 3: TẠO RECRUITER & COMPANY
-- ==========================================
-- Tạo Company nếu chưa có
DECLARE @companyId BIGINT = (SELECT TOP 1 CompanyId FROM dbo.Companies WHERE Status = N'ACTIVE');
IF @companyId IS NULL
BEGIN
    INSERT INTO dbo.Companies (CompanyName, Status, CreatedAt, UpdatedAt) VALUES (N'Công ty TNHH HireHub Test', N'ACTIVE', SYSUTCDATETIME(), SYSUTCDATETIME());
    SET @companyId = SCOPE_IDENTITY();
END

DECLARE @hrUserId BIGINT;
-- Dùng số điện thoại 0999000222 để tránh bị trùng
INSERT INTO dbo.Users (Email, PasswordHash, FullName, PhoneNumber, Gender, Status, EmailVerified, CreatedAt, UpdatedAt)
VALUES (N'hr.test@hirehub.vn', N'$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LnS37cux2Vm', N'Trần Thị HR', N'0999000222', N'FEMALE', N'ACTIVE', 1, SYSUTCDATETIME(), SYSUTCDATETIME());
SET @hrUserId = SCOPE_IDENTITY();

INSERT INTO dbo.UserRoles (UserId, RoleId, AssignedAt, IsActive)
SELECT @hrUserId, RoleId, SYSUTCDATETIME(), 1 FROM dbo.Roles WHERE RoleCode = N'RECRUITER';

INSERT INTO dbo.RecruiterProfiles (UserId, CompanyId, JobTitle, IsPrimaryContact, Status, CreatedAt, UpdatedAt)
VALUES (@hrUserId, @companyId, N'Trưởng phòng Nhân sự', 1, N'ACTIVE', SYSUTCDATETIME(), SYSUTCDATETIME());
PRINT N'✅ Đã tạo HR Test & Company';
GO

-- ==========================================
-- BƯỚC 4: TẠO JOB ĐANG MỞ (PUBLISHED)
-- ==========================================
DECLARE @hrId BIGINT = (SELECT TOP 1 RecruiterId FROM dbo.RecruiterProfiles p JOIN dbo.Users u ON p.UserId = u.UserId WHERE u.Email = N'hr.test@hirehub.vn');
DECLARE @compId BIGINT = (SELECT CompanyId FROM dbo.RecruiterProfiles WHERE RecruiterId = @hrId);
DECLARE @catId BIGINT = ISNULL((SELECT TOP 1 CategoryId FROM dbo.JobCategories), 1);
DECLARE @empTypeId BIGINT = ISNULL((SELECT TOP 1 EmploymentTypeId FROM dbo.EmploymentTypes), 1);

INSERT INTO dbo.Jobs (CompanyId, PostedByRecruiterId, CategoryId, EmploymentTypeId, Title, Description, CurrencyCode, VacancyCount, Status, CreatedAt, UpdatedAt)
VALUES (@compId, @hrId, @catId, @empTypeId, N'Lập trình viên Java Senior', N'Mô tả chi tiết công việc Java', N'VND', 5, N'PUBLISHED', SYSUTCDATETIME(), SYSUTCDATETIME());

INSERT INTO dbo.Jobs (CompanyId, PostedByRecruiterId, CategoryId, EmploymentTypeId, Title, Description, CurrencyCode, VacancyCount, Status, CreatedAt, UpdatedAt)
VALUES (@compId, @hrId, @catId, @empTypeId, N'Chuyên viên Marketing', N'Mô tả chi tiết công việc Marketing', N'VND', 2, N'PUBLISHED', SYSUTCDATETIME(), SYSUTCDATETIME());
PRINT N'✅ Đã tạo 2 tin công việc (Jobs)';
GO

-- ==========================================
-- BƯỚC 5: INSERT VÀO APPLICATIONS & HISTORY
-- ==========================================
DECLARE @cUserId BIGINT = (SELECT UserId FROM dbo.Users WHERE Email = N'candidate.test@hirehub.vn');
DECLARE @cProfileId BIGINT = (SELECT CandidateId FROM dbo.CandidateProfiles WHERE UserId = @cUserId);

DECLARE @hrProfileId BIGINT = (SELECT TOP 1 RecruiterId FROM dbo.RecruiterProfiles p JOIN dbo.Users u ON p.UserId = u.UserId WHERE u.Email = N'hr.test@hirehub.vn');
DECLARE @hrUserId BIGINT = (SELECT UserId FROM dbo.Users WHERE Email = N'hr.test@hirehub.vn');

DECLARE @jId1 BIGINT = (SELECT TOP 1 JobId FROM dbo.Jobs WHERE PostedByRecruiterId = @hrProfileId ORDER BY JobId DESC);
DECLARE @jId2 BIGINT = (SELECT TOP 1 JobId FROM dbo.Jobs WHERE PostedByRecruiterId = @hrProfileId ORDER BY JobId ASC);

DECLARE @stPending BIGINT = (SELECT TOP 1 ApplicationStatusId FROM dbo.ApplicationStatuses WHERE StatusCode = N'PENDING');
DECLARE @stReviewing BIGINT = (SELECT TOP 1 ApplicationStatusId FROM dbo.ApplicationStatuses WHERE StatusCode = N'REVIEWING');

IF @cProfileId IS NOT NULL AND @jId1 IS NOT NULL AND @stPending IS NOT NULL
BEGIN
    -- Đơn 1: Mới nộp (PENDING)
    INSERT INTO dbo.Applications (JobId, CandidateId, CurrentStatusId, CoverLetter, ExpectedSalary, SourceChannel, AppliedAt, LastStatusChangedAt)
    VALUES (@jId1, @cProfileId, @stPending, N'Thư ứng tuyển PENDING', 15000000, N'Website', DATEADD(DAY, -2, SYSUTCDATETIME()), DATEADD(DAY, -2, SYSUTCDATETIME()));
    
    -- Lưu History: Nộp hồ sơ
    DECLARE @appId1 BIGINT = SCOPE_IDENTITY();
    INSERT INTO dbo.ApplicationStatusHistory (ApplicationId, FromStatusId, ToStatusId, ChangedByUserId, ChangedAt, Note)
    VALUES (@appId1, NULL, @stPending, @cUserId, DATEADD(DAY, -2, SYSUTCDATETIME()), N'Ứng viên nộp hồ sơ');
    PRINT N'✅ Inserted Đơn 1 (PENDING)';

    -- Đơn 2: Đang được review bởi HR
    INSERT INTO dbo.Applications (JobId, CandidateId, CurrentStatusId, CoverLetter, RecruiterNote, ExpectedSalary, SourceChannel, AppliedAt, LastStatusChangedAt)
    VALUES (@jId2, @cProfileId, @stReviewing, N'Thư ứng tuyển REVIEWING', N'HR ghi chú: ứng viên rất tuyệt vời', 20000000, N'Facebook', DATEADD(DAY, -5, SYSUTCDATETIME()), DATEADD(DAY, -1, SYSUTCDATETIME()));
    
    -- Lưu History: Có 2 bước (Lúc Candidate nộp và lúc HR chuyển sang REVIEWING)
    DECLARE @appId2 BIGINT = SCOPE_IDENTITY();

    INSERT INTO dbo.ApplicationStatusHistory (ApplicationId, FromStatusId, ToStatusId, ChangedByUserId, ChangedAt, Note)
    VALUES 
    (@appId2, NULL, @stPending, @cUserId, DATEADD(DAY, -5, SYSUTCDATETIME()), N'Ứng viên nộp hồ sơ'),
    (@appId2, @stPending, @stReviewing, @hrUserId, DATEADD(DAY, -1, SYSUTCDATETIME()), N'HR bắt đầu xem xét hồ sơ');
    PRINT N'✅ Inserted Đơn 2 (REVIEWING)';
END
ELSE
BEGIN
    PRINT N'❌ Bị lỗi khi tìm ID:';
    SELECT @cProfileId AS CandidateProfileId, @jId1 AS JobId, @stPending AS PendingStatusId;
END
GO

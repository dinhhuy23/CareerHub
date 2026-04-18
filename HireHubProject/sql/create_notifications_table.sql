-- ==========================================
-- HireHub: Bảng Notifications (thông báo hệ thống)
-- ==========================================
USE [HireHubDB]
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Notifications')
BEGIN
    CREATE TABLE Notifications (
        NotificationId BIGINT IDENTITY(1,1) PRIMARY KEY,
        UserId         BIGINT NOT NULL,
        Title          NVARCHAR(200) NOT NULL,
        Message        NVARCHAR(MAX) NULL,
        Type           NVARCHAR(50) DEFAULT 'SYSTEM',  -- APPLICATION_UPDATE, NEW_APPLICANT, SYSTEM
        IsRead         BIT DEFAULT 0,
        RelatedId      BIGINT NULL,                    -- ApplicationId hoặc JobId tương ứng
        CreatedAt      DATETIME2 DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_Notifications_Users FOREIGN KEY (UserId) REFERENCES Users(UserId)
    );
    PRINT 'Created table: Notifications';

    CREATE INDEX IX_Notifications_UserId ON Notifications(UserId);
    CREATE INDEX IX_Notifications_IsRead ON Notifications(IsRead);
END
GO

-- Thêm cột HRNote vào Applications (ghi chú nội bộ cho HR)
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Applications') AND name = 'HRNote')
BEGIN
    ALTER TABLE Applications ADD HRNote NVARCHAR(MAX) NULL;
    PRINT 'Added column HRNote to Applications';
END
GO

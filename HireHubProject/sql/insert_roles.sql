-- ==========================================
-- HireHub - Insert Required Roles Data
-- Run this AFTER creating the database
-- ==========================================

USE [HireHubDB]
GO

-- Check if roles already exist before inserting
IF NOT EXISTS (SELECT 1 FROM Roles WHERE RoleCode = 'CANDIDATE')
BEGIN
    INSERT INTO Roles (RoleCode, RoleName, [Description], IsActive, CreatedAt)
    VALUES ('CANDIDATE', N'Ứng viên', N'Người tìm việc - Candidate', 1, SYSUTCDATETIME());
    PRINT 'Inserted role: CANDIDATE';
END
GO

IF NOT EXISTS (SELECT 1 FROM Roles WHERE RoleCode = 'RECRUITER')
BEGIN
    INSERT INTO Roles (RoleCode, RoleName, [Description], IsActive, CreatedAt)
    VALUES ('RECRUITER', N'Nhà tuyển dụng', N'Người đăng tin tuyển dụng - Recruiter', 1, SYSUTCDATETIME());
    PRINT 'Inserted role: RECRUITER';
END
GO

IF NOT EXISTS (SELECT 1 FROM Roles WHERE RoleCode = 'ADMIN')
BEGIN
    INSERT INTO Roles (RoleCode, RoleName, [Description], IsActive, CreatedAt)
    VALUES ('ADMIN', N'Quản trị viên', N'Administrator - Quản trị hệ thống', 1, SYSUTCDATETIME());
    PRINT 'Inserted role: ADMIN';
END
GO

-- Verify
SELECT * FROM Roles;
GO

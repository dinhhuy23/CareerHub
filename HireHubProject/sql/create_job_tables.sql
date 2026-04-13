-- ==========================================
-- HireHub - Create Job Post & Search Tables
-- Run this AFTER creating the Users and Roles tables
-- ==========================================

USE [HireHubDB]
GO

-- 1. Create Categories Table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Categories')
BEGIN
    CREATE TABLE Categories (
        CategoryId INT IDENTITY(1,1) PRIMARY KEY,
        Name NVARCHAR(100) NOT NULL,
        Description NVARCHAR(255) NULL,
        Icon NVARCHAR(50) NULL -- FontAwesome or SVG icon string
    );
    PRINT 'Created table: Categories';

    -- Insert Some Default Categories
    INSERT INTO Categories (Name, Description, Icon) VALUES
    (N'IT / Software Development', N'Các công việc liên quan đến lập trình, phần mềm', 'fa-laptop-code'),
    (N'Marketing / PR', N'Tiếp thị, quảng cáo, quan hệ công chúng', 'fa-bullhorn'),
    (N'Sales / Business Development', N'Kinh doanh, bán hàng', 'fa-chart-line'),
    (N'Finance / Accounting', N'Kế toán, kiểm toán, tài chính', 'fa-file-invoice-dollar'),
    (N'Human Resources', N'Nhân sự, hành chính', 'fa-users'),
    (N'Design / Creative', N'Thiết kế đồ họa, UI/UX', 'fa-palette'),
    (N'Engineering / Technical', N'Kỹ thuật, cơ khí, điện tử', 'fa-cogs'),
    (N'Education / Training', N'Giáo dục, đào tạo', 'fa-chalkboard-teacher');
    PRINT 'Inserted default Categories data';
END
GO

-- 2. Create Jobs Table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Jobs')
BEGIN
    CREATE TABLE Jobs (
        JobId BIGINT IDENTITY(1,1) PRIMARY KEY,
        EmployerId BIGINT NOT NULL, -- FK to Users (Recruiter)
        Title NVARCHAR(200) NOT NULL,
        [Description] NVARCHAR(MAX) NOT NULL,
        Requirements NVARCHAR(MAX) NULL,
        Benefits NVARCHAR(MAX) NULL,
        SalaryMin DECIMAL(18,2) NULL,
        SalaryMax DECIMAL(18,2) NULL,
        Location NVARCHAR(100) NULL, -- e.g. 'Hà Nội', 'Hồ Chí Minh', 'Đà Nẵng', 'Remote'
        EmploymentType VARCHAR(50) NULL, -- 'FULL_TIME', 'PART_TIME', 'CONTRACT', 'INTERNSHIP'
        ExperienceLevel VARCHAR(50) NULL, -- 'FRESHER', 'JUNIOR', 'MIDDLE', 'SENIOR', 'MANAGER'
        CategoryId INT NULL, -- FK to Categories
        ApplicationDeadline DATE NULL,
        ViewCount INT DEFAULT 0,
        Status VARCHAR(20) DEFAULT 'PUBLISHED', -- 'DRAFT', 'PUBLISHED', 'CLOSED', 'DELETED'
        CreatedAt DATETIME2 DEFAULT SYSUTCDATETIME(),
        UpdatedAt DATETIME2 DEFAULT SYSUTCDATETIME(),
        
        CONSTRAINT FK_Jobs_Users FOREIGN KEY (EmployerId) REFERENCES Users(UserId),
        CONSTRAINT FK_Jobs_Categories FOREIGN KEY (CategoryId) REFERENCES Categories(CategoryId)
    );
    PRINT 'Created table: Jobs';
END
GO

-- 3. Create SavedJobs Table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'SavedJobs')
BEGIN
    CREATE TABLE SavedJobs (
        UserId BIGINT NOT NULL, -- FK to Users (Candidate)
        JobId BIGINT NOT NULL, -- FK to Jobs
        SavedAt DATETIME2 DEFAULT SYSUTCDATETIME(),
        
        PRIMARY KEY (UserId, JobId),
        CONSTRAINT FK_SavedJobs_Users FOREIGN KEY (UserId) REFERENCES Users(UserId),
        CONSTRAINT FK_SavedJobs_Jobs FOREIGN KEY (JobId) REFERENCES Jobs(JobId)
    );
    PRINT 'Created table: SavedJobs';
END
GO

-- Optional: Create Indexes for faster searching
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Jobs_Status')
    CREATE INDEX IX_Jobs_Status ON Jobs(Status);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Jobs_EmployerId')
    CREATE INDEX IX_Jobs_EmployerId ON Jobs(EmployerId);
GO

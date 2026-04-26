-- ================================================================
-- MIGRATION: Thêm cột ContactEmail vào bảng Users
-- Chạy script này 1 lần duy nhất trên database HireHub
-- ================================================================

-- Thêm cột ContactEmail (nullable, unique)
-- Tách biệt hoàn toàn với cột Email (tài khoản đăng nhập)
ALTER TABLE Users
    ADD ContactEmail NVARCHAR(255) NULL;

-- Tạo UNIQUE CONSTRAINT để đảm bảo mỗi Gmail chỉ dùng cho 1 tài khoản
-- Dùng WHERE ContactEmail IS NOT NULL để các user chưa đặt không conflict
CREATE UNIQUE INDEX UQ_Users_ContactEmail
    ON Users (ContactEmail)
    WHERE ContactEmail IS NOT NULL;

-- Kiểm tra kết quả
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Users'
  AND COLUMN_NAME IN ('Email', 'ContactEmail');

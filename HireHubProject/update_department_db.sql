-- Run this script in your SQL Server Database to add the new columns to the Departments table

ALTER TABLE Departments
ADD ManagerName NVARCHAR(255) NULL,
    ContactEmail VARCHAR(255) NULL,
    PhoneNumber VARCHAR(50) NULL,
    Location NVARCHAR(255) NULL;
GO

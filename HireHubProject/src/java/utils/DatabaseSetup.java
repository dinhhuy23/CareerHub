package utils;

import dal.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;

/**
 * File này dùng để cài đặt các dữ liệu mẫu hoặc cấu hình cần thiết cho Database
 * Bạn chỉ cần chạy file này một lần duy nhất để cập nhật các trạng thái mới.
 */
public class DatabaseSetup {
    public static void main(String[] args) {
        DBContext db = new DBContext();
        
        // Thêm trạng thái Phỏng vấn Vòng 2 vào hệ thống
        String sql = "IF NOT EXISTS (SELECT 1 FROM ApplicationStatuses WHERE StatusCode = 'INTERVIEW_ROUND_2') " +
                     "BEGIN INSERT INTO ApplicationStatuses (StatusCode, StatusName, Description) " +
                     "VALUES ('INTERVIEW_ROUND_2', N'Phỏng vấn vòng 2', N'Phỏng vấn trực tiếp tại công ty') END";
                     
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.executeUpdate();
            System.out.println("Thiet lap Database thanh cong: Da them trang thai INTERVIEW_ROUND_2.");
        } catch (Exception e) {
            System.err.println("Loi khi thiet lap Database: " + e.getMessage());
            e.printStackTrace();
        }
    }
}

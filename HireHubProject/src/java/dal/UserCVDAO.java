package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Template;
import model.UserCV;

public class UserCVDAO {

    private Connection conn;

    public UserCVDAO() {
        try {
            this.conn = new DBContext().getConnection();
        } catch (Exception e) {
            System.err.println("DEBUG: Lỗi khởi tạo UserCVDAO: " + e.getMessage());
        }
    }

    /**
     * Chèn CV mới vào Database IsUpload: 1 (Web), 0 (Upload) IsAccepted: Mặc
     * định là 0 khi mới tạo
     */
    public boolean insertCV(UserCV cv) {
        if (this.conn == null) {
            return false;
        }

        // Thêm [IsSearchable] vào query
        String sql = "INSERT INTO [dbo].[UserCVs] ([UserId], [TemplateId], [CVTitle], [Summary], "
                + "[ExperienceRaw], [EducationRaw], [FullName], [TargetRole], [AvatarUrl], "
                + "[BirthDate], [Address], [Phone], [Email], [Gender], [IsUpload], [IsAccepted], "
                + "[CreatedAt], [UpdatedAt], [IsSearchable]) " // <--- Thêm ở đây
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0, GETDATE(), GETDATE(), ?)"; // <--- Thêm ? cuối cùng

        try (PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, cv.getUserId());
            if (cv.getTemplateId() > 0) {
                st.setInt(2, cv.getTemplateId());
            } else {
                st.setNull(2, Types.INTEGER);
            }

            st.setString(3, cv.getCvTitle());
            st.setString(4, cv.getSummary());
            st.setString(5, cv.getExperienceRaw());
            st.setString(6, cv.getEducationRaw());
            st.setString(7, cv.getFullName());
            st.setString(8, cv.getTargetRole());
            st.setString(9, cv.getAvatarUrl());

            if (cv.getBirthDate() != null) {
                st.setDate(10, cv.getBirthDate());
            } else {
                st.setNull(10, Types.DATE);
            }

            st.setString(11, cv.getAddress());
            st.setString(12, cv.getPhone());
            st.setString(13, cv.getEmail());
            st.setString(14, cv.getGender());
            st.setInt(15, cv.getIsUpload());
            st.setInt(16, cv.getIsSearchable()); // <--- Gán giá trị IsSearchable (Tham số thứ 16)

            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Lấy danh sách CV theo UserId. JOIN với Applications để lấy trạng thái
     * tuyển dụng mới nhất (OFFERED / INTERVIEWING) nhằm hiển thị "Đã tuyển" trên UI.
     */
    public List<UserCV> getCVsByUserId(int userId) {
        List<UserCV> list = new ArrayList<>();
        // Subquery lấy StatusCode mới nhất của đơn ứng tuyển liên quan đến CV này
        // a.ResumeId = u.UserId là mapping hiện tại trong hệ thống
        String sql = "SELECT u.[UserCVId], u.[UserId], u.[TemplateId], u.[CVTitle], u.[TargetRole], "
                + "u.[IsUpload], u.[IsAccepted], u.[IsSearchable], u.[CreatedAt], u.[UpdatedAt], "
                + "( SELECT TOP 1 ast.StatusCode "
                + "  FROM Applications a "
                + "  JOIN ApplicationStatuses ast ON a.CurrentStatusId = ast.ApplicationStatusId "
                + "  WHERE a.ResumeId = u.UserCVId "
                + "    AND ast.StatusCode IN ('OFFERED', 'INTERVIEWING') "
                + "  ORDER BY a.LastStatusChangedAt DESC "
                + ") AS HireStatusCode "
                + "FROM [dbo].[UserCVs] u "
                + "WHERE u.[UserId] = ? AND (u.[isDeleted] = 0 OR u.[isDeleted] IS NULL) "
                + "ORDER BY u.[UpdatedAt] DESC";

        if (this.conn == null) {
            return list;
        }

        try (PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, userId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    UserCV cv = new UserCV();
                    cv.setUserCVId(rs.getInt("UserCVId"));
                    cv.setUserId(rs.getInt("UserId"));
                    cv.setTemplateId(rs.getInt("TemplateId"));
                    cv.setCvTitle(rs.getString("CVTitle"));
                    cv.setTargetRole(rs.getString("TargetRole"));
                    cv.setIsUpload(rs.getInt("IsUpload"));
                    cv.setIsAccepted(rs.getInt("IsAccepted") == 1);
                    cv.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    cv.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
                    cv.setIsSearchable(rs.getInt("IsSearchable"));
                    cv.setHireStatusCode(rs.getString("HireStatusCode")); // null nếu chưa có đơn OFFERED/INTERVIEWING
                    list.add(cv);
                }
            }
        } catch (SQLException e) {
            System.err.println("DEBUG: Lỗi tại getCVsByUserId: " + e.getMessage());
        }
        return list;
    }

    public boolean deleteCV(int cvId, int userId) {
        if (this.conn == null) {
            return false;
        }

        // Chuyển từ DELETE thành UPDATE trạng thái isDeleted
        String sql = "UPDATE [dbo].[UserCVs] SET [isDeleted] = 1 WHERE [UserCVId] = ? AND [UserId] = ?";
        try (PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, cvId);
            st.setInt(2, userId);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public UserCV getCVById(int cvId) {
        // 1. Thêm [IsUpload] và [AvatarUrl] vào câu lệnh SELECT
        String sql = "SELECT [UserCVId], [UserId], [TemplateId], [CVTitle], [Summary], "
                + "[ExperienceRaw], [EducationRaw], [FullName], [TargetRole], "
                + "[AvatarUrl], [BirthDate], [Address], [Phone], [Email], [Gender], [IsUpload], [IsSearchable] " // Thêm [IsUpload] ở đây
                + "FROM [UserCVs] WHERE [UserCVId] = ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, cvId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    UserCV cv = new UserCV();
                    cv.setUserCVId(rs.getInt("UserCVId"));
                    cv.setUserId(rs.getInt("UserId"));
                    cv.setTemplateId(rs.getInt("TemplateId"));
                    cv.setCvTitle(rs.getString("CVTitle"));
                    cv.setSummary(rs.getString("Summary"));
                    cv.setExperienceRaw(rs.getString("ExperienceRaw"));
                    cv.setEducationRaw(rs.getString("EducationRaw"));
                    cv.setFullName(rs.getString("FullName"));
                    cv.setTargetRole(rs.getString("TargetRole"));
                    cv.setAvatarUrl(rs.getString("AvatarUrl"));
                    cv.setBirthDate(rs.getDate("BirthDate"));
                    cv.setAddress(rs.getString("Address"));
                    cv.setPhone(rs.getString("Phone"));
                    cv.setEmail(rs.getString("Email"));
                    cv.setGender(rs.getString("Gender"));

                    // 2. PHẢI CÓ DÒNG NÀY để Object cv có giá trị isUpload
                    cv.setIsUpload(rs.getInt("IsUpload"));
                    cv.setIsSearchable(rs.getInt("IsSearchable"));

                    return cv;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateCV(UserCV cv) {
        String sql = "UPDATE [dbo].[UserCVs] SET "
                + "[CVTitle] = ?, [FullName] = ?, [TargetRole] = ?, "
                + "[BirthDate] = ?, [Address] = ?, [Phone] = ?, "
                + "[Email] = ?, [Gender] = ?, [Summary] = ?, "
                + "[EducationRaw] = ?, [ExperienceRaw] = ?, [AvatarUrl] = ?, "
                + "[TemplateId] = ?, [IsSearchable] = ?, " // <--- Thêm mới ở đây
                + "[UpdatedAt] = GETDATE() "
                + "WHERE [UserCVId] = ?";

        try (Connection connection = new DBContext().getConnection(); PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, cv.getCvTitle());
            ps.setString(2, cv.getFullName());
            ps.setString(3, cv.getTargetRole());

            if (cv.getBirthDate() != null) {
                ps.setDate(4, cv.getBirthDate());
            } else {
                ps.setNull(4, java.sql.Types.DATE);
            }

            ps.setString(5, cv.getAddress());
            ps.setString(6, cv.getPhone());
            ps.setString(7, cv.getEmail());
            ps.setString(8, cv.getGender());
            ps.setString(9, cv.getSummary());
            ps.setString(10, cv.getEducationRaw());
            ps.setString(11, cv.getExperienceRaw());
            ps.setString(12, cv.getAvatarUrl());
            ps.setInt(13, cv.getTemplateId());
            ps.setInt(14, cv.getIsSearchable()); // <--- Gán giá trị IsSearchable (Tham số thứ 14)
            ps.setInt(15, cv.getUserCVId());     // <--- ID chuyển thành tham số thứ 15

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Template> getAllTemplates() {
        List<Template> list = new ArrayList<>();
        String sql = "SELECT * FROM CVTemplates WHERE IsActive = 1";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Template t = new Template();
                t.setTemplateId(rs.getInt("TemplateId"));
                t.setName(rs.getString("Name"));
                t.setImageThumbnail(rs.getString("ImageThumbnail"));
                t.setBaseFileJsp(rs.getString("BaseFileJsp"));
                list.add(t);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<UserCV> getAllPublicCVs() {
        List<UserCV> list = new ArrayList<>();
        // Truy vấn các trường cần thiết để hiển thị ở trang danh sách
        String sql = "SELECT c.[UserCVId], c.[UserId], c.[CVTitle], ISNULL(c.[FullName], u.[FullName]) AS FullName, c.[TargetRole], "
                + "c.[AvatarUrl], c.[UpdatedAt], c.[Email], c.[Phone], c.[IsUpload] "
                + "FROM [dbo].[UserCVs] c JOIN [dbo].[Users] u ON c.[UserId] = u.[UserId] "
                + "WHERE c.[IsSearchable] = 1 AND (c.[isDeleted] = 0 OR c.[isDeleted] IS NULL) "
                + "ORDER BY c.[UpdatedAt] DESC";

        if (this.conn == null) {
            return list;
        }

        try (PreparedStatement st = conn.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                UserCV cv = new UserCV();
                cv.setUserCVId(rs.getInt("UserCVId"));
                cv.setUserId(rs.getInt("UserId"));
                cv.setCvTitle(rs.getString("CVTitle"));
                cv.setFullName(rs.getString("FullName"));
                cv.setTargetRole(rs.getString("TargetRole"));
                cv.setAvatarUrl(rs.getString("AvatarUrl"));
                cv.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
                cv.setEmail(rs.getString("Email"));
                cv.setPhone(rs.getString("Phone"));
                cv.setIsUpload(rs.getInt("IsUpload"));
                list.add(cv);
            }
        } catch (SQLException e) {
            System.err.println("DEBUG: Lỗi tại getAllPublicCVs: " + e.getMessage());
        }
        return list;
    }

    public int countSearchableCVs(String keyword) {
        String sql = "SELECT COUNT(*) FROM [dbo].[UserCVs] WHERE [IsSearchable] = 1 AND ([isDeleted] = 0 OR [isDeleted] IS NULL)";
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND [TargetRole] LIKE ?";
        }
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(1, "%" + keyword + "%");
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<UserCV> getSearchableCVsPaginated(String keyword, int page, int pageSize) {
        List<UserCV> list = new ArrayList<>();
        String sql = "SELECT c.[UserCVId], c.[UserId], c.[CVTitle], ISNULL(c.[FullName], u.[FullName]) AS FullName, c.[TargetRole], "
                + "c.[AvatarUrl], c.[UpdatedAt], c.[Email], c.[Phone], c.[IsUpload] "
                + "FROM [dbo].[UserCVs] c JOIN [dbo].[Users] u ON c.[UserId] = u.[UserId] "
                + "WHERE c.[IsSearchable] = 1 AND (c.[isDeleted] = 0 OR c.[isDeleted] IS NULL) ";
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND c.[TargetRole] LIKE ? ";
        }
        
        sql += " ORDER BY c.[UpdatedAt] DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            int paramIndex = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + keyword + "%");
            }
            ps.setInt(paramIndex++, (page - 1) * pageSize);
            ps.setInt(paramIndex++, pageSize);
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                UserCV cv = new UserCV();
                cv.setUserCVId(rs.getInt("UserCVId"));
                cv.setUserId(rs.getInt("UserId"));
                cv.setCvTitle(rs.getString("CVTitle"));
                cv.setFullName(rs.getString("FullName"));
                cv.setTargetRole(rs.getString("TargetRole"));
                cv.setAvatarUrl(rs.getString("AvatarUrl"));
                cv.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
                cv.setEmail(rs.getString("Email"));
                cv.setPhone(rs.getString("Phone"));
                cv.setIsUpload(rs.getInt("IsUpload"));
                list.add(cv);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<UserCV> searchPublicCVsByRole(String roleKeyword) {
        List<UserCV> list = new ArrayList<>();
        // Truy vấn tìm kiếm CV công khai theo TargetRole hoặc CVTitle
        // Sử dụng N'%' để hỗ trợ tìm kiếm tiếng Việt có dấu trên SQL Server
        String sql = "SELECT * FROM UserCVs "
                + "WHERE isSearchable = 1 " // Chỉ lấy CV ở chế độ công khai
                + "AND (targetRole LIKE ? OR cvTitle LIKE ?)";

        try (Connection connection = new DBContext().getConnection(); PreparedStatement ps = connection.prepareStatement(sql)) {

            String query = "%" + roleKeyword + "%";
            ps.setString(1, query);
            ps.setString(2, query);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                UserCV cv = new UserCV();
                cv.setUserCVId(rs.getInt("userCVId"));
                cv.setUserId(rs.getInt("userId"));
                cv.setFullName(rs.getString("fullName"));
                cv.setCvTitle(rs.getString("cvTitle"));
                cv.setTargetRole(rs.getString("targetRole"));
                cv.setIsUpload(rs.getInt("IsUpload"));
                // Set các trường khác tương ứng với database của bạn

                list.add(cv);
            }
        } catch (Exception e) {
            System.err.println("Error in searchPublicCVsByRole: " + e.getMessage());
        }
        return list;
    }
}

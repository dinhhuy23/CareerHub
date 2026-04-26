package dal;

import model.CVTemplate;
import java.sql.*;
import java.util.*;

public class CVTemplateDAO {

    private Connection conn;

    public CVTemplateDAO(Connection conn) {
        this.conn = conn;
    }

    // ==========================================
    // LẤY TẤT CẢ MẪU CV (Kèm danh sách Tags)
    // ==========================================
    public List<CVTemplate> getAll() {
        Map<Integer, CVTemplate> map = new LinkedHashMap<>();

        // Sử dụng bảng mới: CVTemplates, CVTemplate_Tags, CVTags
        String sql = """
            SELECT t.TemplateId, t.Name, t.ImageThumbnail, tg.TagName
            FROM CVTemplates t
            LEFT JOIN CVTemplate_Tags ct ON t.TemplateId = ct.TemplateId
            LEFT JOIN CVTags tg ON tg.TagId = ct.TagId
            WHERE t.IsActive = 1
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                int id = rs.getInt("TemplateId");
                CVTemplate cv = map.get(id);

                if (cv == null) {
                    cv = new CVTemplate();
                    cv.setId(id);
                    cv.setName(rs.getString("Name"));
                    cv.setImage(rs.getString("ImageThumbnail")); // Cột ImageThumbnail trong DB
                    cv.setTags(new ArrayList<>());
                    map.put(id, cv);
                }

                String tagName = rs.getString("TagName");
                if (tagName != null) {
                    cv.getTags().add(tagName);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new ArrayList<>(map.values());
    }

    // ==========================================
    // LỌC THEO TAG SLUG (Dùng cho URL ?tag=modern)
    // ==========================================
    public List<CVTemplate> filterByTag(String tagSlug) {
        if (tagSlug == null || tagSlug.equalsIgnoreCase("all")) {
            return getAll();
        }

        List<CVTemplate> list = new ArrayList<>();
        // Truy vấn dựa trên TagSlug để khớp với tham số từ URL
        String sql = """
            SELECT DISTINCT t.TemplateId, t.Name, t.ImageThumbnail
            FROM CVTemplates t
            JOIN CVTemplate_Tags ct ON t.TemplateId = ct.TemplateId
            JOIN CVTags tg ON tg.TagId = ct.TagId
            WHERE tg.TagSlug = ? AND t.IsActive = 1
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, tagSlug);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                CVTemplate cv = new CVTemplate();
                int id = rs.getInt("TemplateId");
                cv.setId(id);
                cv.setName(rs.getString("Name"));
                cv.setImage(rs.getString("ImageThumbnail"));
                cv.setTags(getTagsByTemplateId(id)); // Load đầy đủ các tag của mẫu đó
                list.add(cv);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private List<String> getTagsByTemplateId(int templateId) {
        List<String> tags = new ArrayList<>();
        String sql = """
            SELECT tg.TagName
            FROM CVTemplate_Tags ct
            JOIN CVTags tg ON tg.TagId = ct.TagId
            WHERE ct.TemplateId = ?
        """;
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, templateId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                tags.add(rs.getString("TagName"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return tags;
    }

    public CVTemplate getById(int id) {
        String sql = """
            SELECT t.TemplateId, t.Name, t.ImageThumbnail, tg.TagName
            FROM CVTemplates t
            LEFT JOIN CVTemplate_Tags ct ON t.TemplateId = ct.TemplateId
            LEFT JOIN CVTags tg ON tg.TagId = ct.TagId
            WHERE t.TemplateId = ? AND t.IsActive = 1
        """;
        CVTemplate cv = null;
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                if (cv == null) {
                    cv = new CVTemplate();
                    cv.setId(rs.getInt("TemplateId"));
                    cv.setName(rs.getString("Name"));
                    cv.setImage(rs.getString("ImageThumbnail"));
                    cv.setTags(new ArrayList<>());
                }
                String tag = rs.getString("TagName");
                if (tag != null) {
                    cv.getTags().add(tag);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return cv;
    }

    public CVTemplate getTemplateById(int templateId) {
        // Câu lệnh SQL lấy theo đúng tên cột trong Database của bạn
        String sql = "SELECT * FROM CVTemplates WHERE TemplateId = ?";

        try (PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, templateId);

            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    CVTemplate t = new CVTemplate();

                    // Ánh xạ từ cột Database sang các field trong model CVTemplate của bạn
                    t.setId(rs.getInt("TemplateId"));
                    t.setName(rs.getString("Name"));

                    // Giữ nguyên dùng t.setImage() theo Model của bạn
                    // rs.getString("ImageThumbnail") là tên cột thực tế trong DB bạn đã cung cấp
                    t.setImage(rs.getString("ImageThumbnail"));

                    t.setBaseFileJsp(rs.getString("BaseFileJsp"));

                    // Lưu ý: isIsActive() là tên Getter/Setter bạn đã định nghĩa trong Model
                    t.setIsActive(rs.getBoolean("IsActive"));

                    // Trường tags thường cần một câu query riêng hoặc xử lý chuỗi 
                    // Tạm thời để null nếu bạn chưa xử lý bảng trung gian cho Tags
                    t.setTags(null);

                    return t;
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi tại getTemplateById: " + e.getMessage());
        }
        return null;
    }
}

package util;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.util.Map;

public class CloudinaryUtil {

    private static final String CLOUD_NAME = "doomoxozs";
    private static final String API_KEY = "831553961773574";
    private static final String API_SECRET = "Fpwm3adxcseDHjsdY7sgtq-RJP0";

    private static Cloudinary cloudinary;

    public static Cloudinary getCloudinary() {
        if (cloudinary == null) {
            cloudinary = new Cloudinary(ObjectUtils.asMap(
                    "cloud_name", CLOUD_NAME,
                    "api_key", API_KEY,
                    "api_secret", API_SECRET,
                    "secure", true
            ));
        }
        return cloudinary;
    }

    public static String uploadImage(Part filePart, String folder) {
        // Kiểm tra đầu vào để tránh NullPointerException
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }

        try {
            byte[] fileBytes = filePart.getInputStream().readAllBytes();
            Map params = ObjectUtils.asMap(
                    "folder", folder,
                    "resource_type", "image"
            );

            // Thực hiện upload và lấy URL bảo mật
            Map uploadResult = getCloudinary().uploader().upload(fileBytes, params);
            return (String) uploadResult.get("secure_url");
        } catch (Exception e) {
            // Log lỗi chi tiết để debug thay vì văng lỗi 500 ra trình duyệt
            System.err.println("Cloudinary Upload Error: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
}
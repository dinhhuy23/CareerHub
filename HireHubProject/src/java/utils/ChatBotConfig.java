package utils;

import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ChatBotConfig {

    public static final String GEMINI_API_KEY = loadApiKey();

    private static String loadApiKey() {
        // 1. Thử đọc từ System Property (VM Options)
        String key = System.getProperty("GEMINI_API_KEY");
        if (key != null && !key.trim().isEmpty()) return key.trim();

        // 2. Thử đọc từ Environment Variable
        key = System.getenv("GEMINI_API_KEY");
        if (key != null && !key.trim().isEmpty()) return key.trim();

        // 3. Thử đọc từ file local gemini_key.txt (Dùng để test máy cá nhân, đã gitignored)
        String[] candidatePaths = {
            "gemini_key.txt",
            System.getProperty("user.home") + "/gemini_key.txt",
            System.getProperty("user.dir") + "/gemini_key.txt",
            System.getProperty("user.dir") + "/gemini_key.txt".replace("/", java.io.File.separator),
        };
        for (String path : candidatePaths) {
            try {
                java.io.File f = new java.io.File(path);
                if (f.exists()) {
                    key = new String(Files.readAllBytes(f.toPath())).trim();
                    if (!key.isEmpty()) return key;
                }
            } catch (Exception e) {
                // Im lặng nếu không tìm thấy file
            }
        }

        return "";
    }

    public static final String MODEL = "gemini-1.5-flash";

    public static final String API_URL = "https://generativelanguage.googleapis.com/v1beta/models/" + MODEL
            + ":generateContent?key=";

    public static final String SYSTEM_PROMPT = "Bạn là HireHub AI, trợ lý hỗ trợ tìm việc của hệ thống HireHub. "
            + "Hãy trả lời ngắn gọn, rõ ràng, thân thiện bằng tiếng Việt. "
            + "Ưu tiên hỗ trợ tìm việc, CV, ứng tuyển và giải đáp về hệ thống.";
}
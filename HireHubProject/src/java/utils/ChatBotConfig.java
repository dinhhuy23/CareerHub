package utils;

public class ChatBotConfig {

    private static final String ENV_KEY = System.getenv("GEMINI_API_KEY");

    public static final String GEMINI_API_KEY = ENV_KEY != null ? ENV_KEY.trim() : "";

    public static final String MODEL = "gemini-1.5-flash"; 

    public static final String API_URL = "https://generativelanguage.googleapis.com/v1beta/models/" + MODEL
            + ":generateContent?key=";

    public static final String SYSTEM_PROMPT = "Bạn là HireHub AI, trợ lý hỗ trợ tìm việc của hệ thống HireHub. "
            + "Hãy trả lời ngắn gọn, rõ ràng, thân thiện bằng tiếng Việt. "
            + "Ưu tiên hỗ trợ tìm việc, CV, ứng tuyển và giải đáp về hệ thống.";
}
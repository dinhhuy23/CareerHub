package utils;

public class ChatBotConfig {

    private static final String ENV_KEY = System.getenv("OPENAI_API_KEY");

    public static final String OPENAI_API_KEY =
            ENV_KEY != null ? ENV_KEY.trim() : "";

    // Dùng model này cho rẻ và hợp lý hơn GPT-3.5 Turbo
    public static final String MODEL = "gpt-4o-mini";

    // Giữ cách cũ để ít phải sửa controller
    public static final String API_URL = "https://api.openai.com/v1/chat/completions";

    public static final String SYSTEM_PROMPT =
            "Bạn là HireHub AI, trợ lý hỗ trợ tìm việc của hệ thống HireHub. "
            + "Hãy trả lời ngắn gọn, rõ ràng, thân thiện bằng tiếng Việt. "
            + "Ưu tiên hỗ trợ tìm việc, CV, ứng tuyển và giải đáp về hệ thống.";
}
package controller;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.Map;
import utils.ChatBotConfig;
import utils.ChatBotContextUtil;

@WebServlet(name = "ChatbotController", urlPatterns = {"/api/chatbot"})
public class ChatbotController extends HttpServlet {

    private static final Gson gson = new Gson();
    private final HttpClient httpClient = HttpClient.newHttpClient();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            JsonObject body = JsonParser.parseReader(request.getReader()).getAsJsonObject();
            String message = body != null && body.has("message")
                    ? body.get("message").getAsString().trim()
                    : "";

            if (message.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write(gson.toJson(Map.of("success", false, "message", "Tin nhắn không được để trống")));
                return;
            }

            if (ChatBotConfig.GEMINI_API_KEY.isEmpty()) {
                response.getWriter().write(gson.toJson(Map.of("success", false, "message", "Chưa cấu hình Gemini API Key (GEMINI_API_KEY).")));
                return;
            }

            // 1. Lấy ngữ cảnh từ Database thông qua Utility
            String dbContext = ChatBotContextUtil.buildDatabaseContext(request);

            // 2. Gọi Gemini với ngữ cảnh đầy đủ
            String aiReply = callGemini(message, dbContext);

            response.getWriter().write(gson.toJson(Map.of(
                    "success", true,
                    "reply", aiReply
            )));

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson(Map.of("success", false, "message", "Lỗi server khi gọi chatbot: " + e.getMessage())));
        }
    }

    private String callGemini(String userMessage, String dbContext) throws Exception {
        JsonObject body = new JsonObject();
        
        // System instruction kết hợp context
        JsonObject systemInstruction = new JsonObject();
        JsonArray sParts = new JsonArray();
        JsonObject sText = new JsonObject();
        sText.addProperty("text", ChatBotConfig.SYSTEM_PROMPT + "\n" + dbContext);
        sParts.add(sText);
        systemInstruction.add("parts", sParts);
        body.add("system_instruction", systemInstruction);

        // Contents
        JsonArray contents = new JsonArray();
        JsonObject userContent = new JsonObject();
        userContent.addProperty("role", "user");
        JsonArray uParts = new JsonArray();
        JsonObject uText = new JsonObject();
        uText.addProperty("text", userMessage);
        uParts.add(uText);
        userContent.add("parts", uParts);
        contents.add(userContent);
        body.add("contents", contents);

        String jsonPayload = gson.toJson(body);

        HttpRequest geminiRequest = HttpRequest.newBuilder()
                .uri(URI.create(ChatBotConfig.API_URL + ChatBotConfig.GEMINI_API_KEY))
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(jsonPayload, StandardCharsets.UTF_8))
                .build();

        HttpResponse<String> geminiResponse = httpClient.send(
                geminiRequest,
                HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8)
        );

        if (geminiResponse.statusCode() == 200) {
            JsonObject root = gson.fromJson(geminiResponse.body(), JsonObject.class);
            JsonArray candidates = root.getAsJsonArray("candidates");
            if (candidates != null && candidates.size() > 0) {
                return candidates.get(0).getAsJsonObject()
                        .getAsJsonObject("content")
                        .getAsJsonArray("parts")
                        .get(0).getAsJsonObject()
                        .get("text").getAsString();
            }
            return "Không nhận được phản hồi từ Gemini.";
        } else {
            throw new RuntimeException("Gemini API failed (" + geminiResponse.statusCode() + "): " + geminiResponse.body());
        }
    }
}
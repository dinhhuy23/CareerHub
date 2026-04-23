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

            if ("YOUR_OPENAI_API_KEY_HERE".equals(ChatBotConfig.OPENAI_API_KEY)) {
                response.getWriter().write(gson.toJson(Map.of("success", false, "message", "Chưa cấu hình API Key trong ChatBotConfig.java")));
                return;
            }

            String aiReply = callOpenAI(message);

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

    private String callOpenAI(String userMessage) throws Exception {
        JsonObject body = new JsonObject();
        body.addProperty("model", ChatBotConfig.MODEL);
        
        JsonArray messages = new JsonArray();
        
        // System prompt
        JsonObject systemMsg = new JsonObject();
        systemMsg.addProperty("role", "system");
        systemMsg.addProperty("content", ChatBotConfig.SYSTEM_PROMPT);
        messages.add(systemMsg);
        
        // User message
        JsonObject userMsg = new JsonObject();
        userMsg.addProperty("role", "user");
        userMsg.addProperty("content", userMessage);
        messages.add(userMsg);
        
        body.add("messages", messages);
        body.addProperty("temperature", 0.7);

        String jsonPayload = gson.toJson(body);

        HttpRequest openAiRequest = HttpRequest.newBuilder()
                .uri(URI.create(ChatBotConfig.API_URL))
                .header("Content-Type", "application/json")
                .header("Authorization", "Bearer " + ChatBotConfig.OPENAI_API_KEY)
                .POST(HttpRequest.BodyPublishers.ofString(jsonPayload, StandardCharsets.UTF_8))
                .build();

        HttpResponse<String> openAiResponse = httpClient.send(
                openAiRequest,
                HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8)
        );

        if (openAiResponse.statusCode() == 200) {
            JsonObject root = gson.fromJson(openAiResponse.body(), JsonObject.class);
            JsonArray choices = root.getAsJsonArray("choices");
            if (choices != null && choices.size() > 0) {
                return choices.get(0).getAsJsonObject()
                        .getAsJsonObject("message")
                        .get("content").getAsString();
            }
            return "Không nhận được phản hồi từ AI.";
        } else {
            throw new RuntimeException("OpenAI API failed: " + openAiResponse.body());
        }
    }
}
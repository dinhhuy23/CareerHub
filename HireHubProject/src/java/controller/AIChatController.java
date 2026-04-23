package controller;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
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
import java.time.Duration;
import java.util.Map;
import utils.ChatBotConfig;

@WebServlet(name = "AIChatController", urlPatterns = {"/ai-chat"})
public class AIChatController extends HttpServlet {

    private static final Gson gson = new Gson();

    private final HttpClient httpClient = HttpClient.newBuilder()
            .connectTimeout(Duration.ofSeconds(20))
            .build();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String userMessage = request.getParameter("message");

        if (userMessage == null || userMessage.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(gson.toJson(Map.of(
                    "error", "Tin nhắn không được để trống."
            )));
            return;
        }

        String apiKey = ChatBotConfig.OPENAI_API_KEY == null
                ? ""
                : ChatBotConfig.OPENAI_API_KEY.trim();

        // CHỈ check placeholder/rỗng.
        if (apiKey.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson(Map.of(
                    "error", "Hệ thống chưa được cấu hình API Key (OPENAI_API_KEY)."
            )));
            return;
        }

        System.out.println("AIChatController LOADED");
        System.out.println("DEBUG KEY PREFIX = " + apiKey.substring(0, Math.min(10, apiKey.length())));

        try {
            String aiReply = callOpenAI(userMessage.trim(), apiKey);

            response.getWriter().write(gson.toJson(Map.of(
                    "reply", aiReply
            )));
        } catch (Exception e) {
            e.printStackTrace();

            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson(Map.of(
                    "error", e.getMessage() != null ? e.getMessage() : "Dịch vụ AI đang gặp sự cố."
            )));
        }
    }

    private String callOpenAI(String userMessage, String apiKey) throws Exception {
        JsonObject requestBody = new JsonObject();
        requestBody.addProperty("model", ChatBotConfig.MODEL);
        requestBody.addProperty("temperature", 0.7);

        JsonArray messages = new JsonArray();

        JsonObject systemMsg = new JsonObject();
        systemMsg.addProperty("role", "system");
        systemMsg.addProperty("content", ChatBotConfig.SYSTEM_PROMPT);
        messages.add(systemMsg);

        JsonObject userMsg = new JsonObject();
        userMsg.addProperty("role", "user");
        userMsg.addProperty("content", userMessage);
        messages.add(userMsg);

        requestBody.add("messages", messages);

        String jsonPayload = gson.toJson(requestBody);

        HttpRequest openAiRequest = HttpRequest.newBuilder()
                .uri(URI.create(ChatBotConfig.API_URL))
                .timeout(Duration.ofSeconds(60))
                .header("Content-Type", "application/json; charset=UTF-8")
                .header("Authorization", "Bearer " + apiKey)
                .POST(HttpRequest.BodyPublishers.ofString(jsonPayload, StandardCharsets.UTF_8))
                .build();

        HttpResponse<String> openAiResponse = httpClient.send(
                openAiRequest,
                HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8)
        );

        int statusCode = openAiResponse.statusCode();
        String responseBody = openAiResponse.body();

        System.out.println("OpenAI status = " + statusCode);
        System.out.println("OpenAI body = " + responseBody);

        if (statusCode == 200) {
            JsonObject root = gson.fromJson(responseBody, JsonObject.class);
            JsonArray choices = root.getAsJsonArray("choices");

            if (choices != null && choices.size() > 0) {
                JsonObject firstChoice = choices.get(0).getAsJsonObject();
                JsonObject messageObj = firstChoice.getAsJsonObject("message");

                if (messageObj != null && messageObj.has("content")) {
                    return messageObj.get("content").getAsString().trim();
                }
            }

            return "Không nhận được phản hồi hợp lệ từ AI.";
        }

        String errorMessage = "OpenAI API lỗi, mã: " + statusCode;

        try {
            JsonObject errorRoot = gson.fromJson(responseBody, JsonObject.class);
            if (errorRoot != null && errorRoot.has("error")) {
                JsonObject errorObj = errorRoot.getAsJsonObject("error");
                if (errorObj != null && errorObj.has("message")) {
                    errorMessage = errorObj.get("message").getAsString();
                }
            }
        } catch (Exception ignore) {
        }

        throw new RuntimeException(errorMessage);
    }
}
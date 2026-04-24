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
import dal.ApplicationDAO;
import dal.CompanyDAO;
import dal.JobDAO;
import model.Application;
import model.Company;
import model.Job;
import model.User;
import java.util.List;
import java.util.Map;
import utils.ChatBotConfig;
import utils.ChatBotContextUtil;

@WebServlet(name = "AIChatController", urlPatterns = { "/ai-chat" })
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
                    "error", "Tin nhắn không được để trống.")));
            return;
        }

        String apiKey = ChatBotConfig.GEMINI_API_KEY;

        // CHỈ check placeholder/rỗng.
        if (apiKey.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson(Map.of(
                    "error", "Hệ thống chưa được cấu hình Gemini API Key (GEMINI_API_KEY)."
            )));
            return;
        }

        try {
            // 1. Lấy ngữ cảnh từ Database thông qua Utility
            String dbContext = ChatBotContextUtil.buildDatabaseContext(request);
            
            // 2. Gọi Gemini với ngữ cảnh đầy đủ
            String aiReply = callGemini(userMessage.trim(), apiKey, dbContext);

            response.getWriter().write(gson.toJson(Map.of(
                    "reply", aiReply
            )));
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson(Map.of(
                    "error", "Lỗi khi gọi Gemini: " + e.getMessage()
            )));
        }
    }

    private String callGemini(String userMessage, String apiKey, String dbContext) throws Exception {
        JsonObject requestBody = new JsonObject();
        
        // System Instruction kết hợp với Context từ DB
        JsonObject systemInstruction = new JsonObject();
        JsonArray systemParts = new JsonArray();
        JsonObject systemText = new JsonObject();
        systemText.addProperty("text", ChatBotConfig.SYSTEM_PROMPT + "\n" + dbContext);
        systemParts.add(systemText);
        systemInstruction.add("parts", systemParts);
        requestBody.add("system_instruction", systemInstruction);

        // Contents
        JsonArray contents = new JsonArray();
        JsonObject userContent = new JsonObject();
        userContent.addProperty("role", "user");
        JsonArray userParts = new JsonArray();
        JsonObject userText = new JsonObject();
        userText.addProperty("text", userMessage);
        userParts.add(userText);
        userContent.add("parts", userParts);
        contents.add(userContent);
        requestBody.add("contents", contents);

        String jsonPayload = gson.toJson(requestBody);

        HttpRequest geminiRequest = HttpRequest.newBuilder()
                .uri(URI.create(ChatBotConfig.API_URL + apiKey))
                .timeout(Duration.ofSeconds(60))
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(jsonPayload, StandardCharsets.UTF_8))
                .build();

        HttpResponse<String> geminiResponse = httpClient.send(
                geminiRequest,
                HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8)
        );

        int statusCode = geminiResponse.statusCode();
        String responseBody = geminiResponse.body();

        if (statusCode == 200) {
            JsonObject root = gson.fromJson(responseBody, JsonObject.class);
            JsonArray candidates = root.getAsJsonArray("candidates");

            if (candidates != null && candidates.size() > 0) {
                JsonObject firstCandidate = candidates.get(0).getAsJsonObject();
                JsonObject contentObj = firstCandidate.getAsJsonObject("content");
                if (contentObj != null) {
                    JsonArray parts = contentObj.getAsJsonArray("parts");
                    if (parts != null && parts.size() > 0) {
                        return parts.get(0).getAsJsonObject().get("text").getAsString().trim();
                    }
                }
            }
            return "Không nhận được phản hồi hợp lệ từ Gemini.";
        }

        throw new RuntimeException("Gemini API lỗi (" + statusCode + "): " + responseBody);
    }
}
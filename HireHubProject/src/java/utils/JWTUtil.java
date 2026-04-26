package utils;

import java.nio.charset.StandardCharsets;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import org.json.JSONObject;

/**
 * JWT utility class implementing manual JWT generation and validation
 * using HMAC-SHA256 algorithm.
 */
public class JWTUtil {

    // Secret key for signing tokens - in production, store this in environment variable
    private static final String SECRET_KEY = "HireHub_JWT_Secret_Key_2026_!@#$%^&*()_SuperSecure";
    private static final String ALGORITHM = "HmacSHA256";
    private static final long EXPIRATION_TIME = 24 * 60 * 60 * 1000; // 24 hours in ms

    /**
     * Generate a JWT token for a user.
     * @param userId User ID
     * @param email User email
     * @param fullName User full name
     * @param roleCode Role code (CANDIDATE, RECRUITER, ADMIN)
     * @return JWT token string
     */
    public static String generateToken(long userId, String email, String fullName, String roleCode) {
        try {
            // Header
            JSONObject header = new JSONObject();
            header.put("alg", "HS256");
            header.put("typ", "JWT");

            // Payload
            JSONObject payload = new JSONObject();
            payload.put("userId", userId);
            payload.put("email", email);
            payload.put("fullName", fullName);
            payload.put("role", roleCode);
            payload.put("iat", System.currentTimeMillis());
            payload.put("exp", System.currentTimeMillis() + EXPIRATION_TIME);

            // Encode header and payload
            String encodedHeader = base64UrlEncode(header.toString().getBytes(StandardCharsets.UTF_8));
            String encodedPayload = base64UrlEncode(payload.toString().getBytes(StandardCharsets.UTF_8));

            // Create signature
            String dataToSign = encodedHeader + "." + encodedPayload;
            String signature = sign(dataToSign);

            return dataToSign + "." + signature;

        } catch (Exception e) {
            throw new RuntimeException("Error generating JWT token", e);
        }
    }

    /**
     * Validate a JWT token and return the claims if valid.
     * @param token JWT token string
     * @return JSONObject with claims, or null if invalid
     */
    public static JSONObject validateToken(String token) {
        try {
            if (token == null || token.isEmpty()) {
                return null;
            }

            String[] parts = token.split("\\.");
            if (parts.length != 3) {
                return null;
            }

            // Verify signature
            String dataToVerify = parts[0] + "." + parts[1];
            String expectedSignature = sign(dataToVerify);

            if (!expectedSignature.equals(parts[2])) {
                return null; // Invalid signature
            }

            // Decode payload
String payloadJson = new String(base64UrlDecode(parts[1]), StandardCharsets.UTF_8);
            JSONObject payload = new JSONObject(payloadJson);

            // Check expiration
            long expiration = payload.getLong("exp");
            if (System.currentTimeMillis() > expiration) {
                return null; // Token expired
            }

            return payload;

        } catch (Exception e) {
            return null; // Any error means invalid token
        }
    }

    /**
     * Extract claims from token without validation (for display purposes only).
     * @param token JWT token
     * @return JSONObject with claims, or null
     */
    public static JSONObject extractClaims(String token) {
        try {
            String[] parts = token.split("\\.");
            if (parts.length != 3) return null;

            String payloadJson = new String(base64UrlDecode(parts[1]), StandardCharsets.UTF_8);
            return new JSONObject(payloadJson);
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * Check if a token is expired.
     * @param token JWT token
     * @return true if expired
     */
    public static boolean isTokenExpired(String token) {
        JSONObject claims = extractClaims(token);
        if (claims == null) return true;
        return System.currentTimeMillis() > claims.getLong("exp");
    }

    // --- Private helper methods ---

    private static String sign(String data) throws NoSuchAlgorithmException, InvalidKeyException {
        Mac mac = Mac.getInstance(ALGORITHM);
        SecretKeySpec secretKeySpec = new SecretKeySpec(
                SECRET_KEY.getBytes(StandardCharsets.UTF_8), ALGORITHM);
        mac.init(secretKeySpec);
        byte[] signatureBytes = mac.doFinal(data.getBytes(StandardCharsets.UTF_8));
        return base64UrlEncode(signatureBytes);
    }

    private static String base64UrlEncode(byte[] data) {
        return Base64.getUrlEncoder().withoutPadding().encodeToString(data);
    }

    private static byte[] base64UrlDecode(String data) {
        return Base64.getUrlDecoder().decode(data);
    }
}

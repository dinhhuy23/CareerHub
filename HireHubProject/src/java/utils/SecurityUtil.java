package utils;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Security utility class for password hashing and validation.
 * Uses BCrypt for secure password hashing.
 */
public class SecurityUtil {

    private static final int BCRYPT_ROUNDS = 12;

    /**
     * Hash a password using BCrypt.
     * @param plainPassword The plain text password
     * @return BCrypt hashed password
     */
    public static String hashPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(BCRYPT_ROUNDS));
    }

    /**
     * Verify a plain password against a BCrypt hash.
     * @param plainPassword The plain text password to check
     * @param hashedPassword The BCrypt hashed password from database
     * @return true if password matches
     */
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        try {
            return BCrypt.checkpw(plainPassword, hashedPassword);
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * Validate password strength.
     * Requirements: >= 8 characters, at least 1 uppercase, 1 lowercase, 1 digit.
     * @param password The password to validate
     * @return null if valid, error message if invalid
     */
    public static String validatePasswordStrength(String password) {
        if (password == null || password.isEmpty()) {
            return "Mật khẩu không được để trống";
        }
        if (password.length() < 8) {
            return "Mật khẩu phải có ít nhất 8 ký tự";
        }
        if (!password.matches(".*[A-Z].*")) {
            return "Mật khẩu phải có ít nhất 1 chữ hoa";
        }
        if (!password.matches(".*[a-z].*")) {
            return "Mật khẩu phải có ít nhất 1 chữ thường";
        }
        if (!password.matches(".*\\d.*")) {
            return "Mật khẩu phải có ít nhất 1 chữ số";
        }
        return null; // Password is valid
    }

    /**
     * Validate email format.
     * @param email The email to validate
     * @return true if valid email format
     */
    public static boolean isValidEmail(String email) {
        if (email == null || email.isEmpty()) return false;
        String emailRegex = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";
        return email.matches(emailRegex);
    }
}

package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.RefreshToken;

/**
 * Data Access Object for RefreshTokens table.
 */
public class RefreshTokenDAO {

    private static final Logger LOGGER = Logger.getLogger(RefreshTokenDAO.class.getName());
    private final DBContext dbContext = new DBContext();

    /**
     * Insert a new refresh token.
     */
    public long insertToken(long userId, String tokenValue, Timestamp expiredAt,
                            String userAgent, String ipAddress) {
        String sql = "INSERT INTO RefreshTokens (UserId, TokenValue, ExpiredAt, UserAgent, IpAddress) "
                   + "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setLong(1, userId);
            ps.setString(2, tokenValue);
            ps.setTimestamp(3, expiredAt);
            ps.setString(4, userAgent);
            ps.setString(5, ipAddress);

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        return keys.getLong(1);
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error inserting refresh token for user: " + userId, e);
        }

        return -1;
    }

    /**
     * Find an active refresh token by token value.
     */
    public RefreshToken findActiveToken(String tokenValue) {
        String sql = "SELECT TOP 1 * FROM RefreshTokens "
                   + "WHERE TokenValue = ? AND RevokedAt IS NULL AND ExpiredAt > SYSUTCDATETIME()";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, tokenValue);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToRefreshToken(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding active refresh token", e);
        }

        return null;
    }

    /**
     * Revoke a refresh token by ID.
     */
    public boolean revokeToken(long refreshTokenId) {
        String sql = "UPDATE RefreshTokens SET RevokedAt = SYSUTCDATETIME() "
                   + "WHERE RefreshTokenId = ? AND RevokedAt IS NULL";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, refreshTokenId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error revoking refresh token by id: " + refreshTokenId, e);
        }

        return false;
    }

    /**
     * Revoke a refresh token by token value.
     */
    public boolean revokeTokenByValue(String tokenValue) {
        String sql = "UPDATE RefreshTokens SET RevokedAt = SYSUTCDATETIME() "
                   + "WHERE TokenValue = ? AND RevokedAt IS NULL";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, tokenValue);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error revoking refresh token by value", e);
        }

        return false;
    }

    /**
     * Revoke all active refresh tokens of a user.
     */
    public void revokeAllActiveTokensByUser(long userId) {
        String sql = "UPDATE RefreshTokens SET RevokedAt = SYSUTCDATETIME() "
                   + "WHERE UserId = ? AND RevokedAt IS NULL";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error revoking all active tokens for user: " + userId, e);
        }
    }

    /**
     * Rotate refresh token in a transaction: revoke old token and create a new one.
     */
    public boolean rotateToken(long oldRefreshTokenId, long userId, String newTokenValue,
                               Timestamp newExpiredAt, String userAgent, String ipAddress) {
        String revokeSql = "UPDATE RefreshTokens SET RevokedAt = SYSUTCDATETIME() "
                         + "WHERE RefreshTokenId = ? AND RevokedAt IS NULL";
        String insertSql = "INSERT INTO RefreshTokens (UserId, TokenValue, ExpiredAt, UserAgent, IpAddress) "
                         + "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = dbContext.getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement revokePs = conn.prepareStatement(revokeSql);
                 PreparedStatement insertPs = conn.prepareStatement(insertSql)) {

                revokePs.setLong(1, oldRefreshTokenId);
                int revokedRows = revokePs.executeUpdate();

                if (revokedRows == 0) {
                    conn.rollback();
                    return false;
                }

                insertPs.setLong(1, userId);
                insertPs.setString(2, newTokenValue);
                insertPs.setTimestamp(3, newExpiredAt);
                insertPs.setString(4, userAgent);
                insertPs.setString(5, ipAddress);
                insertPs.executeUpdate();

                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                LOGGER.log(Level.SEVERE, "Error rotating refresh token for user: " + userId, e);
                return false;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error handling refresh token rotation transaction", e);
        }

        return false;
    }

    private RefreshToken mapResultSetToRefreshToken(ResultSet rs) throws SQLException {
        RefreshToken token = new RefreshToken();
        token.setRefreshTokenId(rs.getLong("RefreshTokenId"));
        token.setUserId(rs.getLong("UserId"));
        token.setTokenValue(rs.getString("TokenValue"));
        token.setExpiredAt(rs.getTimestamp("ExpiredAt"));
        token.setRevokedAt(rs.getTimestamp("RevokedAt"));
        token.setCreatedAt(rs.getTimestamp("CreatedAt"));
        token.setUserAgent(rs.getString("UserAgent"));
        token.setIpAddress(rs.getString("IpAddress"));
        return token;
    }
}
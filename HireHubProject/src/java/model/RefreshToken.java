package model;

import java.sql.Timestamp;

/**
 * Model for RefreshTokens table.
 */
public class RefreshToken {

    private long refreshTokenId;
    private long userId;
    private String tokenValue;
    private Timestamp expiredAt;
    private Timestamp revokedAt;
    private Timestamp createdAt;
    private String userAgent;
    private String ipAddress;

    public long getRefreshTokenId() {
        return refreshTokenId;
    }

    public void setRefreshTokenId(long refreshTokenId) {
        this.refreshTokenId = refreshTokenId;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public String getTokenValue() {
        return tokenValue;
    }

    public void setTokenValue(String tokenValue) {
        this.tokenValue = tokenValue;
    }

    public Timestamp getExpiredAt() {
        return expiredAt;
    }

    public void setExpiredAt(Timestamp expiredAt) {
        this.expiredAt = expiredAt;
    }

    public Timestamp getRevokedAt() {
        return revokedAt;
    }

    public void setRevokedAt(Timestamp revokedAt) {
        this.revokedAt = revokedAt;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getUserAgent() {
        return userAgent;
    }

    public void setUserAgent(String userAgent) {
        this.userAgent = userAgent;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }
}
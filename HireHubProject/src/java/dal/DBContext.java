package dal;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Database context class for connecting to SQL Server (HireHubDB).
 * Uses sqljdbc42 driver with sa/123456 credentials.
 */
public class DBContext {

    private static final String SERVER_NAME = getEnvOrDefault("DB_HOST", "localhost");
    private static final String DB_NAME = getEnvOrDefault("DB_NAME", "HireHubDB");
    private static final String PORT_NUMBER = getEnvOrDefault("DB_PORT", "1433");
    private static final String USER_ID = getEnvOrDefault("DB_USER", "sa");
        private static final String PASSWORD = getEnvOrDefault(
            "DB_PASSWORD",
            getEnvOrDefault("MSSQL_SA_PASSWORD", "YourStrong!Passw0rd")
        );
    private static final Logger LOGGER = Logger.getLogger(DBContext.class.getName());

    /**
     * Get a connection to the SQL Server database.
     * @return Connection object
     * @throws SQLException if connection fails
     */
    public Connection getConnection() throws SQLException {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException ex) {
            LOGGER.log(Level.SEVERE, "SQL Server JDBC Driver not found", ex);
            throw new SQLException("SQL Server JDBC Driver not found", ex);
        }

        String url = "jdbc:sqlserver://" + SERVER_NAME + ":" + PORT_NUMBER
                    + ";databaseName=" + DB_NAME
                    + ";encrypt=false;trustServerCertificate=true";

        Connection conn = DriverManager.getConnection(url, USER_ID, PASSWORD);
        LOGGER.log(Level.INFO, "Database connection established successfully");
        return conn;
    }

    /**
     * Close connection safely.
     * @param conn Connection to close
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException ex) {
                LOGGER.log(Level.WARNING, "Error closing connection", ex);
            }
        }
    }

    private static String getEnvOrDefault(String key, String defaultValue) {
        String value = System.getenv(key);
        return value == null || value.trim().isEmpty() ? defaultValue : value.trim();
    }
}

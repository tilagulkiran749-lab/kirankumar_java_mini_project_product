package product;

import java.sql.*;

public class DBConnection {

    public static Connection getCon() {
        Connection con = null;

        try {
            // Load MySQL Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Create Connection
            con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/product_db",
                "root",
                "root"
            );

            // Ensure table exists
            ensureTableExists(con);

        } catch (Exception e) {
            throw new RuntimeException("Database connection failed", e);
        }

        return con;
    }

    // Method to create table if not exists
    private static void ensureTableExists(Connection con) {
        String sql = "CREATE TABLE IF NOT EXISTS products ("
                   + "id INT AUTO_INCREMENT PRIMARY KEY, "
                   + "name VARCHAR(255) NOT NULL, "
                   + "price DOUBLE NOT NULL"
                   + ")";

        try (Statement stmt = con.createStatement()) {
            stmt.executeUpdate(sql);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
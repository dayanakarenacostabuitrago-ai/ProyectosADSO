package co.sena.cimm.adso.saludboyaca.model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {

    private static final String URL =
        System.getenv("DB_URL") != null
        ? System.getenv("DB_URL")
        : "jdbc:postgresql://localhost:5432/saludboyaca";

    private static final String USER =
        System.getenv("DB_USER") != null
        ? System.getenv("DB_USER")
        : "postgres";

    private static final String PASS =
        System.getenv("DB_PASS") != null
        ? System.getenv("DB_PASS")
        : "Sena2026";

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("org.postgresql.Driver");
            return DriverManager.getConnection(URL, USER, PASS);
        } catch (ClassNotFoundException ex) {
            throw new SQLException("Error al cargar el driver de PostgreSQL", ex);
        }
    }

    public static void closeConnection(Connection connection) {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (SQLException ex) {
            System.err.println("Error al cerrar la conexión: " + ex.getMessage());
        }
    }
}
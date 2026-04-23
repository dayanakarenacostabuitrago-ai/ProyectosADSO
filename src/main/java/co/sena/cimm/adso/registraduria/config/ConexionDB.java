package co.sena.cimm.adso.registraduria.config;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class ConexionDB {

    private static String URL;
    private static String USER;
    private static String PASSWORD;

    static {
        try {
            InputStream input = ConexionDB.class
                    .getClassLoader().getResourceAsStream("db.properties");

            if (input == null) {
                throw new RuntimeException(
                    "Archivo db.properties no encontrado en el classpath. " +
                    "Verifique que esté en src/main/resources/");
            }

            Properties props = new Properties();
            props.load(input);
            input.close();

            URL      = props.getProperty("sqlserver.url");
            USER     = props.getProperty("sqlserver.user");
            PASSWORD = props.getProperty("sqlserver.password");

            if (URL == null || URL.isBlank()) {
                throw new RuntimeException(
                    "La propiedad 'sqlserver.url' no está definida en db.properties");
            }

            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

        } catch (RuntimeException e) {
            throw e;
        } catch (Exception e) {
            throw new RuntimeException("Error al inicializar ConexionDB: " + e.getMessage(), e);
        }
    }

    public static Connection getConexion() throws SQLException {
        if (USER != null && !USER.isBlank()) {
            return DriverManager.getConnection(URL, USER, PASSWORD);
        }
        return DriverManager.getConnection(URL);
    }
}
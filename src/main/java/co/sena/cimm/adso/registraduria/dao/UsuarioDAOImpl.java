package co.sena.cimm.adso.registraduria.dao;

import co.sena.cimm.adso.registraduria.config.ConexionDB;
import co.sena.cimm.adso.registraduria.model.Usuario;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAOImpl implements UsuarioDAO {

    @Override
    public Usuario buscarPorUsername(String username) throws Exception {
        String sql = "SELECT * FROM usuarios WHERE username = ?";

        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapear(rs);
                }
            }
        }
        return null;
    }

    @Override
    public boolean validarCredenciales(String username, String password) throws Exception {
        Usuario usuario = buscarPorUsername(username);
        if (usuario == null)
            return false;
        if (!usuario.getActivo())
            return false;
        return BCrypt.checkpw(password, usuario.getPassword());
    }

    @Override
    public List<Usuario> listarTodos() throws Exception {
        String sql = "SELECT * FROM usuarios ORDER BY esSuperAdmin DESC, username";
        List<Usuario> lista = new ArrayList<>();

        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(mapear(rs));
            }
        }
        return lista;
    }

    @Override
    public Usuario buscarPorId(int id) throws Exception {
        String sql = "SELECT * FROM usuarios WHERE idUsuario = ?";

        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapear(rs);
                }
            }
        }
        return null;
    }

    @Override
    public boolean insertar(Usuario usuario) throws Exception {
        String sql = "INSERT INTO usuarios (username, password, nombreCompleto, email, activo, esSuperAdmin) " +
                "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, usuario.getUsername());
            ps.setString(2, usuario.getPassword());
            ps.setString(3, usuario.getNombreCompleto());
            ps.setString(4, usuario.getEmail());
            ps.setBoolean(5, usuario.getActivo() != null ? usuario.getActivo() : true);
            ps.setBoolean(6, usuario.getEsSuperAdmin() != null ? usuario.getEsSuperAdmin() : false);

            int filas = ps.executeUpdate();

            if (filas > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        usuario.setIdUsuario(rs.getInt(1));
                    }
                }
            }

            return filas > 0;
        }
    }

    @Override
    public boolean actualizar(Usuario usuario) throws Exception {
        String sql = "UPDATE usuarios SET username = ?, nombreCompleto = ?, email = ?, " +
                "activo = ?, esSuperAdmin = ? WHERE idUsuario = ?";

        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, usuario.getUsername());
            ps.setString(2, usuario.getNombreCompleto());
            ps.setString(3, usuario.getEmail());
            ps.setBoolean(4, usuario.getActivo() != null ? usuario.getActivo() : true);
            ps.setBoolean(5, usuario.getEsSuperAdmin() != null ? usuario.getEsSuperAdmin() : false);
            ps.setInt(6, usuario.getIdUsuario());

            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean eliminar(int id) throws Exception {
        // No eliminamos físicamente, solo desactivamos
        String sql = "UPDATE usuarios SET activo = 0 WHERE idUsuario = ?";

        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean existeUsername(String username) throws Exception {
        String sql = "SELECT COUNT(*) FROM usuarios WHERE username = ?";

        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    private Usuario mapear(ResultSet rs) throws SQLException {
        Usuario u = new Usuario();
        u.setIdUsuario(rs.getInt("idUsuario"));
        u.setUsername(rs.getString("username"));
        u.setPassword(rs.getString("password"));
        u.setNombreCompleto(rs.getString("nombreCompleto"));
        u.setEmail(rs.getString("email"));
        u.setActivo(rs.getBoolean("activo"));
        u.setEsSuperAdmin(rs.getBoolean("esSuperAdmin"));

        Timestamp ts = rs.getTimestamp("fechaCreacion");
        if (ts != null) {
            u.setFechaCreacion(ts.toLocalDateTime());
        }

        return u;
    }
}
package co.sena.cimm.adso.saludboyaca.dao;

import co.sena.cimm.adso.saludboyaca.dto.Usuario;
import co.sena.cimm.adso.saludboyaca.model.Conexion;

import java.sql.*;
import java.util.*;

public class UsuarioDAO {

    // ── VALIDAR LOGIN ─────────────────────────────────────────────
    public Usuario validarLogin(String username, String password) {
        String sql = "SELECT * FROM usuarios WHERE username = ? AND password = ? AND activo = 1";
        try (Connection con = Conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return mapear(rs);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ── BUSCAR POR ID ─────────────────────────────────────────────
    public Usuario buscarPorId(int id) {
        String sql = "SELECT * FROM usuarios WHERE \"idUsuario\" = ?";
        try (Connection con = Conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return mapear(rs);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ── LISTAR TODOS ──────────────────────────────────────────────
    public List<Usuario> listar() {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT * FROM usuarios ORDER BY rol, nombres";
        try (Connection con = Conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next())
                lista.add(mapear(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    // ── LISTAR MÉDICOS ────────────────────────────────────────────
    public List<Usuario> listarMedicos() {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT * FROM usuarios WHERE rol = 'MEDICO' AND activo = 1";
        try (Connection con = Conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next())
                lista.add(mapear(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    // ── LISTAR MÉDICOS POR ESPECIALIDAD ──────────────────────────
    public List<Usuario> listarMedicosPorEspecialidad(int idEspecialidad) {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT * FROM usuarios WHERE rol = 'MEDICO' AND \"idEspecialidad\" = ? AND activo = 1";
        try (Connection con = Conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idEspecialidad);
            ResultSet rs = ps.executeQuery();
            while (rs.next())
                lista.add(mapear(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    // ── INSERTAR ──────────────────────────────────────────────────
    public boolean insertar(Usuario u) {
        String sql = "INSERT INTO usuarios (nombres, apellidos, documento, email, username, password, rol, \"idEspecialidad\", \"langPreferido\", activo) VALUES (?,?,?,?,?,?,?,?,?,?)";
        try (Connection con = Conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, u.getNombres());
            ps.setString(2, u.getApellidos());
            ps.setString(3, u.getDocumento());
            ps.setString(4, u.getEmail());
            ps.setString(5, u.getUserName());
            ps.setString(6, u.getPassword());
            ps.setString(7, u.getRol());
            if (u.getIdEspecialidad() == null || u.getIdEspecialidad() == 0) {
                ps.setNull(8, Types.INTEGER);
            } else {
                ps.setInt(8, u.getIdEspecialidad());
            }
            ps.setString(9, u.getLangPreferido() != null ? u.getLangPreferido() : "es");
            ps.setInt(10, u.getActivo());
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ── ACTUALIZAR ────────────────────────────────────────────────
    public boolean actualizar(Usuario u) {
        String sql = "UPDATE usuarios SET nombres=?, apellidos=?, documento=?, email=?, username=?, rol=?, \"idEspecialidad\"=?, \"langPreferido\"=?, activo=? WHERE \"idUsuario\"=?";
        try (Connection con = Conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, u.getNombres());
            ps.setString(2, u.getApellidos());
            ps.setString(3, u.getDocumento());
            ps.setString(4, u.getEmail());
            ps.setString(5, u.getUserName());
            ps.setString(6, u.getRol());
            if (u.getIdEspecialidad() == null || u.getIdEspecialidad() == 0) {
                ps.setNull(7, Types.INTEGER);
            } else {
                ps.setInt(7, u.getIdEspecialidad());
            }
            ps.setString(8, u.getLangPreferido() != null ? u.getLangPreferido() : "es");
            ps.setInt(9, u.getActivo());
            ps.setInt(10, u.getIdUsuario());
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ── ACTUALIZAR CON CONTRASEÑA ─────────────────────────────────
    public boolean actualizarConPassword(Usuario u) {
        String sql = "UPDATE usuarios SET nombres=?, apellidos=?, documento=?, email=?, username=?, password=?, rol=?, \"idEspecialidad\"=?, \"langPreferido\"=?, activo=? WHERE \"idUsuario\"=?";
        try (Connection con = Conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, u.getNombres());
            ps.setString(2, u.getApellidos());
            ps.setString(3, u.getDocumento());
            ps.setString(4, u.getEmail());
            ps.setString(5, u.getUserName());
            ps.setString(6, u.getPassword());
            ps.setString(7, u.getRol());
            if (u.getIdEspecialidad() == null || u.getIdEspecialidad() == 0) {
                ps.setNull(8, Types.INTEGER);
            } else {
                ps.setInt(8, u.getIdEspecialidad());
            }
            ps.setString(9, u.getLangPreferido() != null ? u.getLangPreferido() : "es");
            ps.setInt(10, u.getActivo());
            ps.setInt(11, u.getIdUsuario());
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ── ELIMINAR ──────────────────────────────────────────────────
    public boolean eliminar(int id) {
        String sqlDelete = "DELETE FROM usuarios WHERE \"idUsuario\" = ?";
        try (Connection con = Conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(sqlDelete)) {
            ps.setInt(1, id);
            ps.executeUpdate();
            return true;
        } catch (SQLIntegrityConstraintViolationException fk) {
            return desactivar(id);
        } catch (SQLException sqle) {
            String msg = sqle.getMessage() != null ? sqle.getMessage().toUpperCase() : "";
            if (msg.contains("FK_") || msg.contains("FOREIGN KEY")
                    || msg.contains("REFERENCE") || msg.contains("CONSTRAINT")
                    || msg.contains("LLAVE FORÁNEA") || msg.contains("FOREIGN")) {
                return desactivar(id);
            }
            sqle.printStackTrace();
            throw new RuntimeException("ERROR_GENERAL: " + sqle.getMessage(), sqle);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("ERROR_GENERAL: " + e.getMessage(), e);
        }
    }

    // ── DESACTIVAR ────────────────────────────────────────────────
    public boolean desactivar(int id) {
        String sql = "UPDATE usuarios SET activo = 0 WHERE \"idUsuario\" = ?";
        try (Connection con = Conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ── ESTADÍSTICAS: usuarios por rol ────────────────────────────
    public Map<String, Integer> contarPorRol() {
        Map<String, Integer> mapa = new LinkedHashMap<>();
        String sql = "SELECT rol, COUNT(*) as total FROM usuarios GROUP BY rol ORDER BY rol";
        try (Connection con = Conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next())
                mapa.put(rs.getString("rol"), rs.getInt("total"));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return mapa;
    }

    // ── ESTADÍSTICAS: total usuarios activos ─────────────────────
    public int totalActivos() {
        String sql = "SELECT COUNT(*) FROM usuarios WHERE activo = 1";
        try (Connection con = Conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next())
                return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ── BUSCAR POR EMAIL ──────────────────────────────────────────
    public Usuario buscarPorEmail(String email) {
        String sql = "SELECT * FROM usuarios WHERE email = ? AND activo = 1";
        try (Connection con = Conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return mapear(rs);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ── ACTUALIZAR CONTRASEÑA ─────────────────────────────────────
    public boolean actualizarPassword(int idUsuario, String nuevaPassword) {
        String sql = "UPDATE usuarios SET password = ? WHERE \"idUsuario\" = ?";
        try (Connection con = Conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, nuevaPassword);
            ps.setInt(2, idUsuario);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ── MAPEAR ────────────────────────────────────────────────────
    private Usuario mapear(ResultSet rs) throws SQLException {
        Usuario u = new Usuario();
        u.setIdUsuario(rs.getInt("idUsuario"));
        u.setNombres(rs.getString("nombres"));
        u.setApellidos(rs.getString("apellidos"));
        u.setDocumento(rs.getString("documento"));
        u.setEmail(rs.getString("email"));
        u.setUserName(rs.getString("username"));
        u.setPassword(rs.getString("password"));
        u.setRol(rs.getString("rol"));
        int esp = rs.getInt("idEspecialidad");
        u.setIdEspecialidad(rs.wasNull() ? null : esp);
        u.setLangPreferido(rs.getString("langPreferido"));
        u.setActivo(rs.getInt("activo"));
        return u;
    }
}
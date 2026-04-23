package co.sena.cimm.adso.registraduria.dao;

import co.sena.cimm.adso.registraduria.config.ConexionDB;
import co.sena.cimm.adso.registraduria.model.SolicitudCiudadano;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class SolicitudDAOimpl implements SolicitudDAO {

    @Override
    public int guardar(SolicitudCiudadano s) throws Exception {
        String sql = "INSERT INTO solicitudes_ciudadano " +
                "(numero_documento, nombres, apellidos, correo, telefono, tipo_solicitud, descripcion, estado, fecha_solicitud) "
                +
                "VALUES (?, ?, ?, ?, ?, ?, ?, 'PENDIENTE', GETDATE())";

        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, s.getNumeroDocumento());
            ps.setString(2, s.getNombres());
            ps.setString(3, s.getApellidos());
            ps.setString(4, s.getCorreo());
            ps.setString(5, s.getTelefono());
            ps.setString(6, s.getTipoSolicitud());
            ps.setString(7, s.getDescripcion());
            ps.executeUpdate();

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next())
                    return keys.getInt(1);
            }
        }
        return -1;
    }

    @Override
    public List<SolicitudCiudadano> listarTodas() throws Exception {
        String sql = "SELECT * FROM solicitudes_ciudadano ORDER BY fecha_solicitud DESC";
        List<SolicitudCiudadano> lista = new ArrayList<>();

        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next())
                lista.add(mapear(rs));
        }
        return lista;
    }

    @Override
    public int contarPendientes() throws Exception {
        String sql = "SELECT COUNT(*) FROM solicitudes_ciudadano WHERE estado = 'PENDIENTE'";
        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next())
                return rs.getInt(1);
        }
        return 0;
    }

    @Override
    public void responder(int id, String estado, String respuesta, String adminNombre) throws Exception {
        String sql = "UPDATE solicitudes_ciudadano " +
                "SET estado = ?, respuesta_admin = ?, fecha_respuesta = GETDATE(), admin_respondio = ? " +
                "WHERE id = ?";

        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, estado);
            ps.setString(2, respuesta);
            ps.setString(3, adminNombre);
            ps.setInt(4, id);
            ps.executeUpdate();
        }
    }

    @Override
    public SolicitudCiudadano buscarPorId(int id) throws Exception {
        String sql = "SELECT * FROM solicitudes_ciudadano WHERE id = ?";
        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return mapear(rs);
            }
        }
        return null;
    }

    private SolicitudCiudadano mapear(ResultSet rs) throws SQLException {
        SolicitudCiudadano s = new SolicitudCiudadano();
        s.setId(rs.getInt("id"));
        s.setNumeroDocumento(rs.getString("numero_documento"));
        s.setNombres(rs.getString("nombres"));
        s.setApellidos(rs.getString("apellidos"));
        s.setCorreo(rs.getString("correo"));
        s.setTelefono(rs.getString("telefono"));
        s.setTipoSolicitud(rs.getString("tipo_solicitud"));
        s.setDescripcion(rs.getString("descripcion"));
        s.setEstado(rs.getString("estado"));
        s.setRespuestaAdmin(rs.getString("respuesta_admin"));
        s.setAdminRespondio(rs.getString("admin_respondio"));

        Timestamp fs = rs.getTimestamp("fecha_solicitud");
        if (fs != null)
            s.setFechaSolicitud(fs.toLocalDateTime());

        Timestamp fr = rs.getTimestamp("fecha_respuesta");
        if (fr != null)
            s.setFechaRespuesta(fr.toLocalDateTime());

        return s;
    }
}
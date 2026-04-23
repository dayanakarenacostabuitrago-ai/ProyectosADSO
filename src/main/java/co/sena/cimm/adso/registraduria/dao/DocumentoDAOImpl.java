package co.sena.cimm.adso.registraduria.dao;

import co.sena.cimm.adso.registraduria.config.ConexionDB;
import co.sena.cimm.adso.registraduria.model.DocumentoExpedido;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class DocumentoDAOImpl implements DocumentoDAO {

    @Override
    public List<DocumentoExpedido> listarTodos() throws Exception {
        String sql = "SELECT d.*, c.nombres, c.apellidos, c.numeroDocumento " +
                "FROM documentosExpedidos d " +
                "INNER JOIN ciudadanos c ON d.idCiudadanos = c.idCiudadanos " +
                "ORDER BY d.fechaExpedicion DESC";

        List<DocumentoExpedido> lista = new ArrayList<>();

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
    public DocumentoExpedido buscarPorId(int id) throws Exception {
        String sql = "SELECT d.*, c.nombres, c.apellidos, c.numeroDocumento " +
                "FROM documentosExpedidos d " +
                "INNER JOIN ciudadanos c ON d.idCiudadanos = c.idCiudadanos " +
                "WHERE d.idDocumentosExpedidos = ?";

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
    public List<DocumentoExpedido> buscarPorCiudadano(int idCiudadano) throws Exception {
        String sql = "SELECT d.*, c.nombres, c.apellidos, c.numeroDocumento " +
                "FROM documentosExpedidos d " +
                "INNER JOIN ciudadanos c ON d.idCiudadanos = c.idCiudadanos " +
                "WHERE d.idCiudadanos = ? " +
                "ORDER BY d.fechaExpedicion DESC";

        List<DocumentoExpedido> lista = new ArrayList<>();

        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idCiudadano);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapear(rs));
                }
            }
        }
        return lista;
    }

    @Override
    public List<DocumentoExpedido> buscarPorTipo(String tipoDocumento) throws Exception {
        String sql = "SELECT d.*, c.nombres, c.apellidos, c.numeroDocumento " +
                "FROM documentosExpedidos d " +
                "INNER JOIN ciudadanos c ON d.idCiudadanos = c.idCiudadanos " +
                "WHERE d.tipoDocumento = ? " +
                "ORDER BY d.fechaExpedicion DESC";

        List<DocumentoExpedido> lista = new ArrayList<>();

        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, tipoDocumento);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapear(rs));
                }
            }
        }
        return lista;
    }

    @Override
    public List<DocumentoExpedido> buscarPorEstado(String estado) throws Exception {
        String sql = "SELECT d.*, c.nombres, c.apellidos, c.numeroDocumento " +
                "FROM documentosExpedidos d " +
                "INNER JOIN ciudadanos c ON d.idCiudadanos = c.idCiudadanos " +
                "WHERE d.estado = ? " +
                "ORDER BY d.fechaExpedicion DESC";

        List<DocumentoExpedido> lista = new ArrayList<>();

        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, estado);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapear(rs));
                }
            }
        }
        return lista;
    }

    @Override
    public boolean insertar(DocumentoExpedido d) throws Exception {
        String sql = "INSERT INTO documentosExpedidos (idCiudadanos, tipoDocumento, numeroSerie, " +
                "fechaExpedicion, fechaVencimiento, estado, observaciones) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, d.getIdCiudadanos());
            ps.setString(2, d.getTipoDocumento());
            ps.setString(3, d.getNumeroSerie());
            ps.setDate(4, Date.valueOf(d.getFechaExpedicion()));

            if (d.getFechaVencimiento() != null) {
                ps.setDate(5, Date.valueOf(d.getFechaVencimiento()));
            } else {
                ps.setNull(5, Types.DATE);
            }

            ps.setString(6, d.getEstado());
            ps.setString(7, d.getObservaciones());

            int filas = ps.executeUpdate();

            if (filas > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        d.setIdDocumentosExpedidos(rs.getInt(1));
                    }
                }
            }

            return filas > 0;
        }
    }

    @Override
    public boolean actualizar(DocumentoExpedido d) throws Exception {
        String sql = "UPDATE documentosExpedidos SET idCiudadanos = ?, tipoDocumento = ?, " +
                "numeroSerie = ?, fechaExpedicion = ?, fechaVencimiento = ?, " +
                "estado = ?, observaciones = ? WHERE idDocumentosExpedidos = ?";

        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, d.getIdCiudadanos());
            ps.setString(2, d.getTipoDocumento());
            ps.setString(3, d.getNumeroSerie());
            ps.setDate(4, Date.valueOf(d.getFechaExpedicion()));

            if (d.getFechaVencimiento() != null) {
                ps.setDate(5, Date.valueOf(d.getFechaVencimiento()));
            } else {
                ps.setNull(5, Types.DATE);
            }

            ps.setString(6, d.getEstado());
            ps.setString(7, d.getObservaciones());
            ps.setInt(8, d.getIdDocumentosExpedidos());

            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean eliminar(int id) throws Exception {
        String sql = "DELETE FROM documentosExpedidos WHERE idDocumentosExpedidos = ?";

        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean existeNumeroSerie(String numeroSerie) throws Exception {
        String sql = "SELECT COUNT(*) FROM documentosExpedidos WHERE numeroSerie = ?";

        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, numeroSerie);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    @Override
    public List<DocumentoExpedido> buscarPorCriterio(String criterio) throws Exception {
        String sql = "SELECT d.*, c.nombres, c.apellidos, c.numeroDocumento " +
                "FROM documentosExpedidos d " +
                "INNER JOIN ciudadanos c ON d.idCiudadanos = c.idCiudadanos " +
                "WHERE c.nombres LIKE ? OR c.apellidos LIKE ? OR c.numeroDocumento LIKE ? " +
                "OR d.numeroSerie LIKE ? OR d.tipoDocumento LIKE ? " +
                "ORDER BY d.fechaExpedicion DESC";

        List<DocumentoExpedido> lista = new ArrayList<>();

        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con.prepareStatement(sql)) {

            String patron = "%" + criterio + "%";
            for (int i = 1; i <= 5; i++) {
                ps.setString(i, patron);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapear(rs));
                }
            }
        }
        return lista;
    }


    @Override
    public List<DocumentoExpedido> listarVencidos() throws Exception {
        String sql = "SELECT d.*, c.nombres, c.apellidos, c.numeroDocumento " +
                "FROM documentosExpedidos d " +
                "INNER JOIN ciudadanos c ON d.idCiudadanos = c.idCiudadanos " +
                "WHERE d.fechaVencimiento IS NOT NULL " +
                "AND d.fechaVencimiento < CAST(GETDATE() AS DATE) " +
                "AND d.estado <> 'cancelado' " +
                "ORDER BY d.fechaVencimiento ASC";
        List<DocumentoExpedido> lista = new ArrayList<>();
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                DocumentoExpedido d = mapear(rs);
                long dias = java.time.temporal.ChronoUnit.DAYS.between(
                        d.getFechaVencimiento(), java.time.LocalDate.now());
                d.setDiasRestantes(dias);
                lista.add(d);
            }
        }
        return lista;
    }

    @Override
    public List<DocumentoExpedido> listarProximosAVencer() throws Exception {
        String sql = "SELECT d.*, c.nombres, c.apellidos, c.numeroDocumento " +
                "FROM documentosExpedidos d " +
                "INNER JOIN ciudadanos c ON d.idCiudadanos = c.idCiudadanos " +
                "WHERE d.fechaVencimiento IS NOT NULL " +
                "AND d.fechaVencimiento >= CAST(GETDATE() AS DATE) " +
                "AND d.fechaVencimiento <= DATEADD(day, 30, CAST(GETDATE() AS DATE)) " +
                "AND d.estado <> 'cancelado' " +
                "ORDER BY d.fechaVencimiento ASC";
        List<DocumentoExpedido> lista = new ArrayList<>();
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                DocumentoExpedido d = mapear(rs);
                long dias = java.time.temporal.ChronoUnit.DAYS.between(
                        java.time.LocalDate.now(), d.getFechaVencimiento());
                d.setDiasRestantes(dias);
                lista.add(d);
            }
        }
        return lista;
    }

    private DocumentoExpedido mapear(ResultSet rs) throws SQLException {
        DocumentoExpedido d = new DocumentoExpedido();

        d.setIdDocumentosExpedidos(rs.getInt("idDocumentosExpedidos"));
        d.setIdCiudadanos(rs.getInt("idCiudadanos"));
        d.setTipoDocumento(rs.getString("tipoDocumento"));
        d.setNumeroSerie(rs.getString("numeroSerie"));

        Date fechaExp = rs.getDate("fechaExpedicion");
        if (fechaExp != null) {
            d.setFechaExpedicion(fechaExp.toLocalDate());
        }

        Date fechaVen = rs.getDate("fechaVencimiento");
        if (fechaVen != null) {
            d.setFechaVencimiento(fechaVen.toLocalDate());
        }

        d.setEstado(rs.getString("estado"));
        d.setObservaciones(rs.getString("observaciones"));

        // JOIN
        String nombres = rs.getString("nombres");
        String apellidos = rs.getString("apellidos");
        d.setCiudadanoNombre((nombres != null ? nombres : "") + " " + (apellidos != null ? apellidos : ""));
        d.setCiudadanoDocumento(rs.getString("numeroDocumento"));

        return d;
    }
}
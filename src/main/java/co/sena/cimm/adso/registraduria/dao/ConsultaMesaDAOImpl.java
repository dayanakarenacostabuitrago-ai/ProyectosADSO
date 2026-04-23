package co.sena.cimm.adso.registraduria.dao;

import co.sena.cimm.adso.registraduria.config.ConexionDB;
import co.sena.cimm.adso.registraduria.model.Ciudadano;

import java.sql.*;

public class ConsultaMesaDAOImpl implements ConsultaMesaDAO {

    @Override
    public Ciudadano consultarPorDocumento(String documento) throws Exception {
        String sql = "SELECT c.nombres, c.apellidos, c.numeroDocumento, c.idMesasVotacion, c.correo, " +
                "ci.nombre AS ciudad, ci.codigoDane, " +
                "z.nombreZona, z.puestoVotacion, z.direccion, " +
                "m.numeroMesa, m.capacidad " +
                "FROM ciudadanos c " +
                "LEFT JOIN mesasVotacion m ON c.idMesasVotacion = m.idMesasVotacion " +
                "LEFT JOIN zonasVotacion z ON m.idZonaVotacion = z.idZonaVotacion " +
                "LEFT JOIN ciudades ci ON z.idCiudades = ci.idCiudades " +
                "WHERE c.numeroDocumento = ?";

        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, documento);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapear(rs);
                }
            }
        }
        return null;
    }

    private Ciudadano mapear(ResultSet rs) throws SQLException {
        Ciudadano c = new Ciudadano();

        // Campos de ciudadano
        c.setNombres(rs.getString("nombres"));
        c.setApellidos(rs.getString("apellidos"));
        c.setNumeroDocumento(rs.getString("numeroDocumento"));
        c.setCorreo(rs.getString("correo"));

        // Verificar si tiene mesa asignada
        int idMesa = rs.getInt("idMesasVotacion");
        c.setIdMesasVotacion(rs.wasNull() ? null : idMesa);

        // Campos de ciudades (pueden ser null si no tiene mesa)
        c.setCiudadNombre(rs.getString("ciudad"));
        c.setCodigoDane(rs.getString("codigoDane"));

        // Campos de zonasVotacion (pueden ser null si no tiene mesa)
        c.setNombreZona(rs.getString("nombreZona"));
        c.setPuestoVotacion(rs.getString("puestoVotacion"));
        c.setDireccionZona(rs.getString("direccion"));

        // Campos de mesasVotacion (pueden ser null si no tiene mesa)
        int numeroMesa = rs.getInt("numeroMesa");
        c.setNumeroMesa(rs.wasNull() ? null : numeroMesa);

        int capacidad = rs.getInt("capacidad");
        c.setCapacidadMesa(rs.wasNull() ? null : capacidad);

        return c;
    }
}
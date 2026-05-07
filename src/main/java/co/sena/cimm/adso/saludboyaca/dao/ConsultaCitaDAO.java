package co.sena.cimm.adso.saludboyaca.dao;

import co.sena.cimm.adso.saludboyaca.dto.Cita;
import co.sena.cimm.adso.saludboyaca.model.Conexion;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

public class ConsultaCitaDAO {

    public Cita buscarPorIdCompleto(int idCita) throws Exception {

        String sql = "SELECT "
                + "c.\"idCita\", c.\"fechaCita\", c.\"horaCita\", c.estado, c.motivo, c.observaciones, "
                + "p.nombres  AS pacienteNombre, p.apellidos AS pacienteApellido, p.documento, "
                + "u.nombres  AS medicoNombre,   u.apellidos AS medicoApellido, "
                + "e.nombre   AS especialidad "
                + "FROM citas c "
                + "INNER JOIN pacientes p      ON c.\"idPaciente\"    = p.\"idPaciente\" "
                + "INNER JOIN usuarios u       ON c.\"idUsuario\"     = u.\"idUsuario\" "
                + "INNER JOIN especialidades e ON c.\"idEspecialidad\" = e.\"idEspecialidad\" "
                + "WHERE c.\"idCita\" = ?";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idCita);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapear(rs);
                }
            }
        }
        return null;
    }

    public List<Cita> consultarPorDocumento(String documento) throws Exception {

        List<Cita> lista = new ArrayList<>();

        String sql = "SELECT "
                + "c.\"idCita\", c.\"fechaCita\", c.\"horaCita\", c.estado, c.motivo, c.observaciones, "
                + "p.nombres  AS pacienteNombre, p.apellidos AS pacienteApellido, p.documento, "
                + "u.nombres  AS medicoNombre,   u.apellidos AS medicoApellido, "
                + "e.nombre   AS especialidad "
                + "FROM citas c "
                + "INNER JOIN pacientes p      ON c.\"idPaciente\"    = p.\"idPaciente\" "
                + "INNER JOIN usuarios u       ON c.\"idUsuario\"     = u.\"idUsuario\" "
                + "INNER JOIN especialidades e ON c.\"idEspecialidad\" = e.\"idEspecialidad\" "
                + "WHERE p.documento = ? AND u.rol = 'MEDICO'";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, documento);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapear(rs));
                }
            }
        }
        return lista;
    }

    private Cita mapear(ResultSet rs) throws SQLException {

        Cita c = new Cita();

        c.setIdCita(rs.getInt("idCita"));
        c.setFechaCita(rs.getDate("fechaCita"));
        c.setHoraCita(rs.getTime("horaCita").toLocalTime());
        c.setMotivo(rs.getString("motivo"));
        c.setEstado(rs.getString("estado"));
        c.setObservaciones(rs.getString("observaciones"));

        c.setPacienteNombre(rs.getString("pacienteNombre"));
        c.setPacienteApellido(rs.getString("pacienteApellido"));
        c.setDocumento(rs.getString("documento"));

        c.setMedicoNombre(rs.getString("medicoNombre"));
        c.setMedicoApellido(rs.getString("medicoApellido"));

        c.setEspecialidad(rs.getString("especialidad"));

        return c;
    }
}
package co.sena.cimm.adso.saludboyaca.dao;

import co.sena.cimm.adso.saludboyaca.model.Conexion;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class OTPTokenDAO {

    // ── INSERTAR OTP ──────────────────────────────────────────────
    public void insertar(int idUsuario, String codigo) {

        invalidarAnteriores(idUsuario);

        String sql = "INSERT INTO otptokens (\"idUsuario\", codigo, \"fechaGen\", \"expiraEn\", usado) " +
                "VALUES (?, ?, NOW(), NOW() + INTERVAL '5 minutes', 0)";

        try (Connection con = Conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);
            ps.setString(2, codigo);
            ps.executeUpdate();

        } catch (Exception e) {
            System.err.println("[OTPTokenDAO] Error insertando OTP: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // ── VALIDAR OTP ───────────────────────────────────────────────
    public boolean validar(int idUsuario, String codigo) {

        String sql = "SELECT \"idOtpToken\" FROM otptokens " +
                "WHERE \"idUsuario\" = ? " +
                "AND codigo = ? " +
                "AND usado = 0 " +
                "AND NOW() <= \"expiraEn\"";

        try (Connection con = Conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);
            ps.setString(2, codigo);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int idOtp = rs.getInt("idOtpToken");
                marcarComoUsado(idOtp);
                return true;
            }

        } catch (Exception e) {
            System.err.println("[OTPTokenDAO] Error validando OTP: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    // ── MARCAR COMO USADO ─────────────────────────────────────────
    private void marcarComoUsado(int idOtpToken) {

        String sql = "UPDATE otptokens SET usado = 1 WHERE \"idOtpToken\" = ?";

        try (Connection con = Conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idOtpToken);
            ps.executeUpdate();

        } catch (Exception e) {
            System.err.println("[OTPTokenDAO] Error marcando OTP como usado: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // ── INVALIDAR OTPS ANTERIORES ─────────────────────────────────
    private void invalidarAnteriores(int idUsuario) {

        String sql = "UPDATE otptokens SET usado = 1 WHERE \"idUsuario\" = ? AND usado = 0";

        try (Connection con = Conexion.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);
            ps.executeUpdate();

        } catch (Exception e) {
            System.err.println("[OTPTokenDAO] Error invalidando OTPs anteriores: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
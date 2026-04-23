package karen.adso.biblioteca.modelo;

import java.sql.Timestamp;

public class Reserva {

    private int idReserva;
    private int idLibro;
    private int idUsuario;
    private Timestamp fechaReserva;
    private String estado;

    // Campos extra del JOIN (solo lectura para vistas)
    private String tituloLibro;
    private String nombreUsuario;
    private String apellidoUsuario;
    private String emailUsuario;

    public Reserva() {
    }

    // ── Getters ───────────────────────────────────────────
    public int getIdReserva() {
        return idReserva;
    }

    public int getIdLibro() {
        return idLibro;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public Timestamp getFechaReserva() {
        return fechaReserva;
    }

    public String getEstado() {
        return estado;
    }

    public String getTituloLibro() {
        return tituloLibro;
    }

    public String getNombreUsuario() {
        return nombreUsuario;
    }

    public String getApellidoUsuario() {
        return apellidoUsuario;
    }

    public String getEmailUsuario() {
        return emailUsuario;
    }

    // ── Setters ───────────────────────────────────────────
    public void setIdReserva(int idReserva) {
        this.idReserva = idReserva;
    }

    public void setIdLibro(int idLibro) {
        this.idLibro = idLibro;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public void setFechaReserva(Timestamp fechaReserva) {
        this.fechaReserva = fechaReserva;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public void setTituloLibro(String tituloLibro) {
        this.tituloLibro = tituloLibro;
    }

    public void setNombreUsuario(String nombreUsuario) {
        this.nombreUsuario = nombreUsuario;
    }

    public void setApellidoUsuario(String a) {
        this.apellidoUsuario = a;
    }

    public void setEmailUsuario(String emailUsuario) {
        this.emailUsuario = emailUsuario;
    }
}

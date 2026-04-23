package karen.adso.biblioteca.modelo;

import java.sql.Timestamp;

public class Prestamo {

    private int idPrestamo;
    private int idLibro;
    private int idUsuario;
    private Timestamp fechaPrestamo;
    private Timestamp fechaDevolucion;
    private Timestamp fechaDevolucionReal;
    private String estado;
    private String imagen;

    // Campos de solo lectura para mostrar en la vista (vienen de JOINs)
    private String tituloLibro;
    private String nombreUsuario;
    private String apellidoUsuario;

    public Prestamo() {
    }

    // ── Getters ─────────────────────────────────────────────
    public int getIdPrestamo() {
        return idPrestamo;
    }

    public int getIdLibro() {
        return idLibro;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public Timestamp getFechaPrestamo() {
        return fechaPrestamo;
    }

    public Timestamp getFechaDevolucion() {
        return fechaDevolucion;
    }

    public Timestamp getFechaDevolucionReal() {
        return fechaDevolucionReal;
    }

    public String getEstado() {
        return estado;
    }

    public String getImagen() {
        return imagen;
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

    // ── Setters ─────────────────────────────────────────────
    public void setIdPrestamo(int idPrestamo) {
        this.idPrestamo = idPrestamo;
    }

    public void setIdLibro(int idLibro) {
        this.idLibro = idLibro;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public void setFechaPrestamo(Timestamp fechaPrestamo) {
        this.fechaPrestamo = fechaPrestamo;
    }

    public void setFechaDevolucion(Timestamp fechaDevolucion) {
        this.fechaDevolucion = fechaDevolucion;
    }

    public void setFechaDevolucionReal(Timestamp fechaDevolucionReal) {
        this.fechaDevolucionReal = fechaDevolucionReal;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public void setImagen(String imagen) {
        this.imagen = imagen;
    }

    public void setTituloLibro(String tituloLibro) {
        this.tituloLibro = tituloLibro;
    }

    public void setNombreUsuario(String nombreUsuario) {
        this.nombreUsuario = nombreUsuario;
    }

    public void setApellidoUsuario(String apellidoUsuario) {
        this.apellidoUsuario = apellidoUsuario;
    }
}

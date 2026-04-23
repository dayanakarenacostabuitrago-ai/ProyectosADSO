
package karen.adso.biblioteca.modelo;

import java.sql.Timestamp;


public class Multa {
    private int idMulta;
    private int idPrestamo;
    private double monto;
    private Timestamp fechaGeneracion;
    private Timestamp fechaPago;
    private String estado;

    // Campos de solo lectura (vienen de JOINs en MultaDAO)
    private String tituloLibro;
    private String nombreUsuario;
    private String apellidoUsuario;

    public Multa() {
    }

    public int getIdMulta() {
        return idMulta;
    }

    public int getIdPrestamo() {
        return idPrestamo;
    }

    public double getMonto() {
        return monto;
    }

    public Timestamp getFechaGeneracion() {
        return fechaGeneracion;
    }

    public Timestamp getFechaPago() {
        return fechaPago;
    }

    public String getEstado() {
        return estado;
    }

    public void setIdMulta(int idMulta) {
        this.idMulta = idMulta;
    }

    public void setIdPrestamo(int idPrestamo) {
        this.idPrestamo = idPrestamo;
    }

    public void setMonto(double monto) {
        this.monto = monto;
    }

    public void setFechaGeneracion(Timestamp fechaGeneracion) {
        this.fechaGeneracion = fechaGeneracion;
    }

    public void setFechaPago(Timestamp fechaPago) {
        this.fechaPago = fechaPago;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public String getTituloLibro() {
        return tituloLibro;
    }

    public void setTituloLibro(String tituloLibro) {
        this.tituloLibro = tituloLibro;
    }

    public String getNombreUsuario() {
        return nombreUsuario;
    }

    public void setNombreUsuario(String nombreUsuario) {
        this.nombreUsuario = nombreUsuario;
    }

    public String getApellidoUsuario() {
        return apellidoUsuario;
    }

    public void setApellidoUsuario(String apellidoUsuario) {
        this.apellidoUsuario = apellidoUsuario;
    }
    
}

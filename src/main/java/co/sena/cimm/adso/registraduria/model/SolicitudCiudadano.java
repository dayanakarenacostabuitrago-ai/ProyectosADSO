package co.sena.cimm.adso.registraduria.model;

import java.time.LocalDateTime;

public class SolicitudCiudadano {

    private Integer id;
    private String numeroDocumento;
    private String nombres;
    private String apellidos;
    private String correo;
    private String telefono;
    private String tipoSolicitud;
    private String descripcion;
    private String estado; // PENDIENTE | ACEPTADA | RECHAZADA
    private String respuestaAdmin;
    private LocalDateTime fechaSolicitud;
    private LocalDateTime fechaRespuesta;
    private String adminRespondio;

    // ── Getters & Setters ──────────────────────────────────────

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getNumeroDocumento() {
        return numeroDocumento;
    }

    public void setNumeroDocumento(String numeroDocumento) {
        this.numeroDocumento = numeroDocumento;
    }

    public String getNombres() {
        return nombres;
    }

    public void setNombres(String nombres) {
        this.nombres = nombres;
    }

    public String getApellidos() {
        return apellidos;
    }

    public void setApellidos(String apellidos) {
        this.apellidos = apellidos;
    }

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getTipoSolicitud() {
        return tipoSolicitud;
    }

    public void setTipoSolicitud(String tipoSolicitud) {
        this.tipoSolicitud = tipoSolicitud;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public String getRespuestaAdmin() {
        return respuestaAdmin;
    }

    public void setRespuestaAdmin(String respuestaAdmin) {
        this.respuestaAdmin = respuestaAdmin;
    }

    public LocalDateTime getFechaSolicitud() {
        return fechaSolicitud;
    }

    public void setFechaSolicitud(LocalDateTime fechaSolicitud) {
        this.fechaSolicitud = fechaSolicitud;
    }

    public LocalDateTime getFechaRespuesta() {
        return fechaRespuesta;
    }

    public void setFechaRespuesta(LocalDateTime fechaRespuesta) {
        this.fechaRespuesta = fechaRespuesta;
    }

    public String getAdminRespondio() {
        return adminRespondio;
    }

    public void setAdminRespondio(String adminRespondio) {
        this.adminRespondio = adminRespondio;
    }

    public String getNombreCompleto() {
        return (nombres != null ? nombres : "") + " " + (apellidos != null ? apellidos : "");
    }

    public String getFechaFormateada() {
        if (fechaSolicitud == null)
            return "";
        return String.format("%02d/%02d/%d %02d:%02d",
                fechaSolicitud.getDayOfMonth(),
                fechaSolicitud.getMonthValue(),
                fechaSolicitud.getYear(),
                fechaSolicitud.getHour(),
                fechaSolicitud.getMinute());
    }

    public String getIniciales() {
        String n = (nombres != null && !nombres.isEmpty()) ? nombres.substring(0, 1) : "?";
        String a = (apellidos != null && !apellidos.isEmpty()) ? apellidos.substring(0, 1) : "";
        return (n + a).toUpperCase();
    }
}

package co.sena.cimm.adso.registraduria.model;

import java.time.LocalDateTime;

public class Usuario {

    private Integer idUsuario;
    private String username;
    private String password;
    private String nombreCompleto;
    private String email;
    private Boolean activo;
    private Boolean esSuperAdmin;
    private LocalDateTime fechaCreacion;
    private LocalDateTime ultimoAcceso;

    // Constructor vacío
    public Usuario() {
    }

    // Constructor con campos básicos
    public Usuario(String username, String password, String nombreCompleto, String email) {
        this.username = username;
        this.password = password;
        this.nombreCompleto = nombreCompleto;
        this.email = email;
        this.activo = true;
        this.esSuperAdmin = false;
    }

    // Getters y Setters
    public Integer getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(Integer idUsuario) {
        this.idUsuario = idUsuario;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getNombreCompleto() {
        return nombreCompleto;
    }

    public void setNombreCompleto(String nombreCompleto) {
        this.nombreCompleto = nombreCompleto;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Boolean getActivo() {
        return activo;
    }

    public void setActivo(Boolean activo) {
        this.activo = activo;
    }

    public Boolean getEsSuperAdmin() {
        return esSuperAdmin;
    }

    public void setEsSuperAdmin(Boolean esSuperAdmin) {
        this.esSuperAdmin = esSuperAdmin;
    }

    public LocalDateTime getFechaCreacion() {
        return fechaCreacion;
    }

    public void setFechaCreacion(LocalDateTime fechaCreacion) {
        this.fechaCreacion = fechaCreacion;
    }

    public LocalDateTime getUltimoAcceso() {
        return ultimoAcceso;
    }

    public void setUltimoAcceso(LocalDateTime ultimoAcceso) {
        this.ultimoAcceso = ultimoAcceso;
    }

    // Métodos útiles
    public boolean isAdmin() {
        return true; // Todos los usuarios de esta tabla son administradores
    }

    public boolean isSuperAdmin() {
        return esSuperAdmin != null && esSuperAdmin;
    }

    public boolean isActivo() {
        return activo != null && activo;
    }

    public String getEstadoTexto() {
        return isActivo() ? "Activo" : "Inactivo";
    }

    public String getRolTexto() {
        return isSuperAdmin() ? "Super Administrador" : "Administrador";
    }
}
package co.sena.cimm.adso.saludboyaca.dto;

public class Usuario {
    private int idUsuario;
    private String nombres;
    private String apellidos;
    private String documento;
    private String email;
    private String userName;
    private String password;
    private String rol;
    private Integer idEspecialidad; // Integer para soportar NULL (rol ADMINISTRADOR)
    private String langPreferido;
    private int activo;

    public Usuario() {
    }

    public Usuario(int idUsuario, String nombres, String apellidos, String documento, String email, String userName,
            String password, String rol, Integer idEspecialidad, String langPreferido, int activo) {
        this.idUsuario = idUsuario;
        this.nombres = nombres;
        this.apellidos = apellidos;
        this.documento = documento;
        this.email = email;
        this.userName = userName;
        this.password = password;
        this.rol = rol;
        this.idEspecialidad = idEspecialidad;
        this.langPreferido = langPreferido;
        this.activo = activo;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
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

    public String getDocumento() {
        return documento;
    }

    public void setDocumento(String documento) {
        this.documento = documento;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRol() {
        return rol;
    }

    public void setRol(String rol) {
        this.rol = rol;
    }

    public Integer getIdEspecialidad() {
        return idEspecialidad;
    }

    public void setIdEspecialidad(Integer idEspecialidad) {
        this.idEspecialidad = idEspecialidad;
    }

    public String getLangPreferido() {
        return langPreferido;
    }

    public void setLangPreferido(String langPreferido) {
        this.langPreferido = langPreferido;
    }

    public int getActivo() {
        return activo;
    }

    public void setActivo(int activo) {
        this.activo = activo;
    }
}

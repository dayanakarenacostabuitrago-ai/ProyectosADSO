
package karen.adso.biblioteca.modelo;


public class Usuario {
   private int idUsuario;
   private String documento;
   private String nombres;
   private String apellidos;
   private String email;
   private String telefono;
   private String tipoUsuario;
   private String estado;

    public Usuario() {
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public String getDocumento() {
        return documento;
    }

    public String getNombres() {
        return nombres;
    }

    public String getApellidos() {
        return apellidos;
    }

    public String getEmail() {
        return email;
    }

    public String getTelefono() {
        return telefono;
    }

    public String getTipoUsuario() {
        return tipoUsuario;
    }

    public String getEstado() {
        return estado;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public void setDocumento(String documento) {
        this.documento = documento;
    }

    public void setNombres(String nombres) {
        this.nombres = nombres;
    }

    public void setApellidos(String apellidos) {
        this.apellidos = apellidos;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public void setTipoUsuario(String tipoUsuario) {
        this.tipoUsuario = tipoUsuario;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }
   
}

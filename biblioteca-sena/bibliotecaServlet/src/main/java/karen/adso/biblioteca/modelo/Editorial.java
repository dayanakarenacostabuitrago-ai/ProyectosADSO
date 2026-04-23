package karen.adso.biblioteca.modelo;

public class Editorial {

    private int id;
    private String nombre;
    private String pais;
    private String sitioWeb;

    public Editorial() {
    }

    public Editorial(int id, String nombre, String pais, String sitioWeb) {
        this.id = id;
        this.nombre = nombre;
        this.pais = pais;
        this.sitioWeb = sitioWeb;
    }

    public int getId() {
        return id;
    }

    public String getNombre() {
        return nombre;
    }

    public String getPais() {
        return pais;
    }

    public String getSitioWeb() {
        return sitioWeb;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public void setPais(String pais) {
        this.pais = pais;
    }

    public void setSitioWeb(String sitioWeb) {
        this.sitioWeb = sitioWeb;
    }

}

package karen.adso.biblioteca.modelo;

public class Libro {

    private int id;
    private String titulo;
    private String isbn;
    private int añoPublicacion;
    private String numPaginas;
    private int idEditorial;
    private int disponible;
    private int idCategoria;
    private String imagen; // nombre del archivo guardado en /imagenes/

    // Campos extra del JOIN (solo lectura para vistas)
    private String editorialNombre;
    private String categoriaNombre;

    public Libro() {
    }

    public Libro(int id, String titulo, String isbn, int añoPublicacion,
            String numPaginas, int idEditorial, int disponible, int idCategoria) {
        this.id = id;
        this.titulo = titulo;
        this.isbn = isbn;
        this.añoPublicacion = añoPublicacion;
        this.numPaginas = numPaginas;
        this.idEditorial = idEditorial;
        this.disponible = disponible;
        this.idCategoria = idCategoria;
    }

    public int getId() {
        return id;
    }

    public String getTitulo() {
        return titulo;
    }

    public String getIsbn() {
        return isbn;
    }

    public int getAñoPublicacion() {
        return añoPublicacion;
    }

    public String getNumPaginas() {
        return numPaginas;
    }

    public int getIdEditorial() {
        return idEditorial;
    }

    public int getDisponible() {
        return disponible;
    }

    public int getIdCategoria() {
        return idCategoria;
    }

    public String getImagen() {
        return imagen;
    }

    public String getEditorialNombre() {
        return editorialNombre;
    }

    public String getCategoriaNombre() {
        return categoriaNombre;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public void setIsbn(String isbn) {
        this.isbn = isbn;
    }

    public void setAñoPublicacion(int añoPublicacion) {
        this.añoPublicacion = añoPublicacion;
    }

    public void setNumPaginas(String numPaginas) {
        this.numPaginas = numPaginas;
    }

    public void setIdEditorial(int idEditorial) {
        this.idEditorial = idEditorial;
    }

    public void setDisponible(int disponible) {
        this.disponible = disponible;
    }

    public void setIdCategoria(int idCategoria) {
        this.idCategoria = idCategoria;
    }

    public void setImagen(String imagen) {
        this.imagen = imagen;
    }

    public void setEditorialNombre(String editorialNombre) {
        this.editorialNombre = editorialNombre;
    }

    public void setCategoriaNombre(String categoriaNombre) {
        this.categoriaNombre = categoriaNombre;
    }
}

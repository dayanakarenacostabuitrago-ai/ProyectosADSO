package karen.adso.biblioteca.servlet;

import java.io.File;
import java.io.IOException;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import karen.adso.biblioteca.modelo.Libro;
import karen.adso.biblioteca.dao.*;

@WebServlet("/LibroServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 10 * 1024 * 1024
)
public class LibroServlet extends HttpServlet {

    private final LibroDAO libroDAO = new LibroDAO();
    private final EditorialDAO editorialDAO = new EditorialDAO();
    private final CategoriaDAO categoriaDAO = new CategoriaDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String accion = req.getParameter("accion");
        if (accion == null) {
            accion = "listar";
        }
        switch (accion) {
            case "nuevo":
                mostrarFormularioNuevo(req, resp);
                break;
            case "editar":
                mostrarFormularioEditar(req, resp);
                break;
            case "eliminar":
                eliminarLibro(req, resp);
                break;
            default:
                listarLibros(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String accion = req.getParameter("accion");
        if (accion == null) {
            accion = "";
        }
        switch (accion) {
            case "insertar":
                insertarLibro(req, resp);
                break;
            case "actualizar":
                actualizarLibro(req, resp);
                break;
            default:
                listarLibros(req, resp);
        }
    }

    private void listarLibros(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("libros", libroDAO.listarTodos());
        req.getRequestDispatcher("/WEB-INF/vistas/libro.jsp").forward(req, resp);
    }

    private void mostrarFormularioNuevo(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("editoriales", editorialDAO.listarTodos());
        req.setAttribute("categorias", categoriaDAO.listarTodos());
        req.getRequestDispatcher("/WEB-INF/vistas/formularioLibro.jsp").forward(req, resp);
    }

    private void mostrarFormularioEditar(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            Libro libro = libroDAO.buscarPorId(id);
            if (libro == null) {
                req.getSession().setAttribute("mensaje", "Libro no encontrado.");
                req.getSession().setAttribute("tipoMensaje", "danger");
                resp.sendRedirect(req.getContextPath() + "/LibroServlet");
                return;
            }
            req.setAttribute("libro", libro);
            req.setAttribute("editoriales", editorialDAO.listarTodos());
            req.setAttribute("categorias", categoriaDAO.listarTodos());
            req.getRequestDispatcher("/WEB-INF/vistas/formularioLibro.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/LibroServlet");
        }
    }

    private void insertarLibro(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            Libro libro = construirLibro(req);
            String nombreImagen = guardarImagen(req);
            System.out.println("[LibroServlet] imagen guardada: " + nombreImagen);
            libro.setImagen(nombreImagen);
            boolean ok = libroDAO.insertar(libro);
            req.getSession().setAttribute("mensaje",
                    ok ? "Libro registrado exitosamente." : "Error al registrar el libro.");
            req.getSession().setAttribute("tipoMensaje", ok ? "success" : "danger");
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("mensaje", "Error: " + e.getMessage());
            req.getSession().setAttribute("tipoMensaje", "danger");
        }
        resp.sendRedirect(req.getContextPath() + "/LibroServlet");
    }

    private void actualizarLibro(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            Libro libro = construirLibro(req);
            libro.setId(Integer.parseInt(req.getParameter("id")));
            String nuevaImagen = guardarImagen(req);
            libro.setImagen(nuevaImagen != null ? nuevaImagen : req.getParameter("imagenActual"));
            boolean ok = libroDAO.actualizar(libro);
            req.getSession().setAttribute("mensaje",
                    ok ? "Libro actualizado exitosamente." : "Error al actualizar.");
            req.getSession().setAttribute("tipoMensaje", ok ? "success" : "danger");
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("mensaje", "Error: " + e.getMessage());
            req.getSession().setAttribute("tipoMensaje", "danger");
        }
        resp.sendRedirect(req.getContextPath() + "/LibroServlet");
    }

    private void eliminarLibro(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            boolean ok = libroDAO.eliminar(id);
            req.getSession().setAttribute("mensaje",
                    ok ? "Libro eliminado." : "Error al eliminar. Puede tener prestamos asociados.");
            req.getSession().setAttribute("tipoMensaje", ok ? "success" : "danger");
        } catch (Exception e) {
            req.getSession().setAttribute("mensaje", "Error: " + e.getMessage());
            req.getSession().setAttribute("tipoMensaje", "danger");
        }
        resp.sendRedirect(req.getContextPath() + "/LibroServlet");
    }

   
    private String guardarImagen(HttpServletRequest req) throws IOException, ServletException {
        Part filePart = req.getPart("imagen");
        System.out.println("[LibroServlet] Part: " + filePart
                + " size=" + (filePart != null ? filePart.getSize() : "N/A"));

        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }

        String nombreOriginal = filePart.getSubmittedFileName();
        if (nombreOriginal == null || nombreOriginal.trim().isEmpty()) {
            return null;
        }

        String ext = nombreOriginal.substring(
                nombreOriginal.lastIndexOf('.') + 1).toLowerCase();
        if (!ext.equals("jpg") && !ext.equals("jpeg")
                && !ext.equals("png") && !ext.equals("webp")) {
            throw new IllegalArgumentException("Solo se permiten imagenes JPG, PNG o WEBP.");
        }

        String nombreGuardado = System.currentTimeMillis() + "_"
                + nombreOriginal.replaceAll("[^a-zA-Z0-9._-]", "_");

        // Ruta dinámica dentro del contexto del servidor (sobrevive en cualquier OS)
        String rutaReal = getServletContext().getRealPath("/WEB-INF/imagenes");
        File carpeta = new File(rutaReal);
        if (!carpeta.exists()) {
            carpeta.mkdirs();
        }

        File destino = new File(carpeta, nombreGuardado);
        filePart.write(destino.getAbsolutePath());
        System.out.println("[LibroServlet] Guardado en: " + destino.getAbsolutePath());
        return nombreGuardado;
    }

    private Libro construirLibro(HttpServletRequest req) {
        Libro libro = new Libro();
        String titulo = req.getParameter("titulo");
        if (titulo == null || titulo.trim().isEmpty()) {
            throw new IllegalArgumentException("El titulo es obligatorio");
        }
        libro.setTitulo(titulo.trim());
        libro.setIsbn(req.getParameter("isbn"));
        String anio = req.getParameter("añoPublicacion");
        if (anio != null && !anio.trim().isEmpty()) {
            try {
                libro.setAñoPublicacion(Integer.parseInt(anio.trim()));
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException("Año invalido");
            }
        }
        libro.setNumPaginas(req.getParameter("numPaginas"));
        String idEd = req.getParameter("idEditorial");
        if (idEd == null || idEd.trim().isEmpty()) {
            throw new IllegalArgumentException("Debe seleccionar una editorial");
        }
        libro.setIdEditorial(Integer.parseInt(idEd.trim()));
        String idCat = req.getParameter("idCategoria");
        if (idCat == null || idCat.trim().isEmpty()) {
            throw new IllegalArgumentException("Debe seleccionar una categoria");
        }
        libro.setIdCategoria(Integer.parseInt(idCat.trim()));
        String disp = req.getParameter("disponible");
        libro.setDisponible(disp != null ? Integer.parseInt(disp) : 1);
        return libro;
    }
}

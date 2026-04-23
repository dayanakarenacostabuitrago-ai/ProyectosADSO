package karen.adso.biblioteca.servlet;

import java.io.File;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import karen.adso.biblioteca.dao.LibroDAO;
import karen.adso.biblioteca.dao.PrestamoDAO;
import karen.adso.biblioteca.dao.UsuarioDAO;
import karen.adso.biblioteca.modelo.Prestamo;
import karen.adso.biblioteca.modelo.Usuario;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 5,
        maxRequestSize = 1024 * 1024 * 10
)
@WebServlet("/PrestamoServlet")
public class PrestamoServlet extends HttpServlet {

    private final PrestamoDAO prestamoDAO = new PrestamoDAO();
    private final LibroDAO libroDAO = new LibroDAO();
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");
        if (accion == null) {
            accion = "listar";
        }

        switch (accion) {
            case "nuevo":
                mostrarFormularioNuevo(request, response);
                break;
            case "devolucion":
                mostrarFormularioDevolucion(request, response);
                break;
            case "eliminar":
                eliminarPrestamo(request, response);
                break;
            case "ver":
                verPrestamo(request, response);
                break;
            default:
                listarPrestamos(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");
        if (accion == null) {
            accion = "";
        }

        switch (accion) {
            case "insertar":
                insertarPrestamo(request, response);
                break;
            case "registrarDevolucion":
                registrarDevolucion(request, response);
                break;
            case "editarEstado":
                editarEstadoPrestamo(request, response);
                break;
            default:
                listarPrestamos(request, response);
        }
    }

    // ── LISTAR ───────────────────────────────────────────────
    private void listarPrestamos(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
        String tipoUsuario = (String) request.getSession().getAttribute("tipoUsuario");
        List<Prestamo> prestamos;
        if (usuario != null && "Estudiante".equals(tipoUsuario)) {
            prestamos = prestamoDAO.listarPorUsuario(usuario.getIdUsuario());
        } else {
            prestamos = prestamoDAO.listarTodos();
        }
        request.setAttribute("prestamos", prestamos);
        request.getRequestDispatcher("/WEB-INF/vistas/prestamo.jsp").forward(request, response);
    }

    // ── FORMULARIO NUEVO ─────────────────────────────────────
    private void mostrarFormularioNuevo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String tipoUsuario = (String) request.getSession().getAttribute("tipoUsuario");
        if ("Estudiante".equals(tipoUsuario)) {
            request.getSession().setAttribute("mensaje", "No tiene permisos para crear préstamos.");
            request.getSession().setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/PrestamoServlet");
            return;
        }
        request.setAttribute("libros", libroDAO.listarDisponibles());
        request.setAttribute("usuarios", usuarioDAO.listarActivos());
        request.getRequestDispatcher("/WEB-INF/vistas/formularioPrestamo.jsp").forward(request, response);
    }

    // ── INSERTAR ─────────────────────────────────────────────
    private void insertarPrestamo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String tipoUsuario = (String) request.getSession().getAttribute("tipoUsuario");
        if ("Estudiante".equals(tipoUsuario)) {
            request.getSession().setAttribute("mensaje", "No tiene permisos para esta acción.");
            request.getSession().setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/PrestamoServlet");
            return;
        }
        try {
            Prestamo p = new Prestamo();

            String idLibroStr = request.getParameter("idLibro");
            if (idLibroStr == null || idLibroStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Debe seleccionar un libro");
            }
            p.setIdLibro(Integer.parseInt(idLibroStr.trim()));

            String idUsuarioStr = request.getParameter("idUsuario");
            if (idUsuarioStr == null || idUsuarioStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Debe seleccionar un usuario");
            }
            p.setIdUsuario(Integer.parseInt(idUsuarioStr.trim()));

            String fechaPrestamoStr = request.getParameter("fechaPrestamo");
            if (fechaPrestamoStr != null && !fechaPrestamoStr.trim().isEmpty()) {
                p.setFechaPrestamo(Timestamp.valueOf(fechaPrestamoStr.trim() + " 00:00:00"));
            } else {
                p.setFechaPrestamo(new Timestamp(System.currentTimeMillis()));
            }

            String fechaDevStr = request.getParameter("fechaDevolucion");
            if (fechaDevStr == null || fechaDevStr.trim().isEmpty()) {
                throw new IllegalArgumentException("La fecha de devolución es obligatoria");
            }
            p.setFechaDevolucion(Timestamp.valueOf(fechaDevStr.trim() + " 00:00:00"));

            p.setEstado("En curso");

            boolean ok = prestamoDAO.insertarPrestamo(p);
            if (ok) {
                libroDAO.actualizarEstado(p.getIdLibro(), 0);
                guardarImagen(request);
                request.getSession().setAttribute("mensaje", "Préstamo registrado exitosamente.");
                request.getSession().setAttribute("tipoMensaje", "success");
            } else {
                request.getSession().setAttribute("mensaje", "Error al registrar el préstamo.");
                request.getSession().setAttribute("tipoMensaje", "danger");
            }
        } catch (IllegalArgumentException e) {
            request.getSession().setAttribute("mensaje", "Error: " + e.getMessage());
            request.getSession().setAttribute("tipoMensaje", "danger");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("mensaje", "Error inesperado: " + e.getMessage());
            request.getSession().setAttribute("tipoMensaje", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/PrestamoServlet");
    }

    // ── FORMULARIO DEVOLUCIÓN ─────────────────────────────────
    private void mostrarFormularioDevolucion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String tipoUsuario = (String) request.getSession().getAttribute("tipoUsuario");
        if ("Estudiante".equals(tipoUsuario)) {
            request.getSession().setAttribute("mensaje", "No tiene permisos para registrar devoluciones.");
            request.getSession().setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/PrestamoServlet");
            return;
        }
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Prestamo prestamo = prestamoDAO.buscarPorId(id);
            if (prestamo == null) {
                request.getSession().setAttribute("mensaje", "Préstamo no encontrado.");
                request.getSession().setAttribute("tipoMensaje", "danger");
                response.sendRedirect(request.getContextPath() + "/PrestamoServlet");
                return;
            }
            request.setAttribute("prestamo", prestamo);
            request.getRequestDispatcher("/WEB-INF/vistas/formularioPrestamo.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("mensaje", "ID de préstamo inválido.");
            request.getSession().setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/PrestamoServlet");
        }
    }

    // ── REGISTRAR DEVOLUCIÓN ──────────────────────────────────
    private void registrarDevolucion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String fechaDevolucionReal = request.getParameter("fechaDevolucionReal");
            if (fechaDevolucionReal == null || fechaDevolucionReal.trim().isEmpty()) {
                request.getSession().setAttribute("mensaje", "La fecha de devolución real es obligatoria.");
                request.getSession().setAttribute("tipoMensaje", "danger");
                response.sendRedirect(request.getContextPath() + "/PrestamoServlet");
                return;
            }
            Prestamo prestamo = prestamoDAO.buscarPorId(id);
            if (prestamo == null) {
                request.getSession().setAttribute("mensaje", "Préstamo no encontrado.");
                request.getSession().setAttribute("tipoMensaje", "danger");
                response.sendRedirect(request.getContextPath() + "/PrestamoServlet");
                return;
            }
            String imagenGuardada = guardarImagen(request);
            boolean ok = prestamoDAO.registrarDevolucion(id, fechaDevolucionReal.trim(), imagenGuardada);
            if (ok) {
                libroDAO.actualizarEstado(prestamo.getIdLibro(), 1);
                request.getSession().setAttribute("mensaje", "Devolución registrada exitosamente.");
                request.getSession().setAttribute("tipoMensaje", "success");
            } else {
                request.getSession().setAttribute("mensaje", "Error al registrar la devolución.");
                request.getSession().setAttribute("tipoMensaje", "danger");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("mensaje", "Error: " + e.getMessage());
            request.getSession().setAttribute("tipoMensaje", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/PrestamoServlet");
    }

    // ── EDITAR ESTADO (solo Administrativo) ──────────────────
    private void editarEstadoPrestamo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String tipoUsuario = (String) request.getSession().getAttribute("tipoUsuario");
        if (!"Administrativo".equals(tipoUsuario)) {
            request.getSession().setAttribute("mensaje", "No tiene permisos para esta acción.");
            request.getSession().setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/PrestamoServlet");
            return;
        }
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String nuevoEstado = request.getParameter("estado");
            if (nuevoEstado == null || nuevoEstado.trim().isEmpty()) {
                throw new IllegalArgumentException("Estado inválido");
            }
            boolean ok = prestamoDAO.actualizarEstadoAdmin(id, nuevoEstado.trim());
            request.getSession().setAttribute("mensaje", ok ? "Estado actualizado correctamente." : "Error al actualizar el estado.");
            request.getSession().setAttribute("tipoMensaje", ok ? "success" : "danger");
        } catch (Exception e) {
            request.getSession().setAttribute("mensaje", "Error: " + e.getMessage());
            request.getSession().setAttribute("tipoMensaje", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/PrestamoServlet");
    }

    // ── ELIMINAR ─────────────────────────────────────────────
    private void eliminarPrestamo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String tipoUsuario = (String) request.getSession().getAttribute("tipoUsuario");
        if (!"Administrativo".equals(tipoUsuario)) {
            request.getSession().setAttribute("mensaje", "No tiene permisos para eliminar préstamos.");
            request.getSession().setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/PrestamoServlet");
            return;
        }
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Prestamo prestamo = prestamoDAO.buscarPorId(id);
            boolean ok = prestamoDAO.eliminar(id);
            if (ok) {
                if (prestamo != null && ("En curso".equals(prestamo.getEstado()) || "Activo".equals(prestamo.getEstado()))) {
                    libroDAO.actualizarEstado(prestamo.getIdLibro(), 1);
                }
                request.getSession().setAttribute("mensaje", "Préstamo eliminado exitosamente.");
                request.getSession().setAttribute("tipoMensaje", "success");
            } else {
                request.getSession().setAttribute("mensaje", "Error al eliminar el préstamo.");
                request.getSession().setAttribute("tipoMensaje", "danger");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("mensaje", "Error: " + e.getMessage());
            request.getSession().setAttribute("tipoMensaje", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/PrestamoServlet");
    }

    // ── HELPER: guardar imagen ────────────────────────────────
    private String guardarImagen(HttpServletRequest request) {
        try {
            Part filePart = request.getPart("imagenLibro");
            if (filePart == null || filePart.getSize() == 0) {
                System.out.println("[PrestamoServlet] No se recibio imagen o esta vacia.");
                return null;
            }

            String nombreCompleto = filePart.getSubmittedFileName();
            if (nombreCompleto == null || nombreCompleto.trim().isEmpty()) {
                System.out.println("[PrestamoServlet] Nombre de archivo vacio.");
                return null;
            }

            // Extraer solo el nombre del archivo (fix rutas completas en Windows)
            String nombreArchivo = new File(nombreCompleto).getName();
            nombreArchivo = nombreArchivo.replaceAll("[^a-zA-Z0-9._-]", "_");
            if (nombreArchivo.isEmpty()) {
                nombreArchivo = "imagen";
            }

            // Obtener ruta de la carpeta WEB-INF/imagenes
            String carpetaPath = getServletContext().getRealPath("/WEB-INF/imagenes");

            // Si getRealPath devuelve null (WAR comprimido), usar catalina.home como fallback
            if (carpetaPath == null) {
                String base = System.getProperty("catalina.home");
                if (base == null) {
                    base = System.getProperty("user.home");
                }
                carpetaPath = base + File.separator + "bibliotecaImagenes";
                System.out.println("[PrestamoServlet] getRealPath=null, fallback: " + carpetaPath);
            }

            File carpeta = new File(carpetaPath);
            if (!carpeta.exists()) {
                boolean creada = carpeta.mkdirs();
                System.out.println("[PrestamoServlet] Carpeta creada=" + creada + " en: " + carpetaPath);
            }

            String nombreFinal = System.currentTimeMillis() + "_" + nombreArchivo;
            File destino = new File(carpeta, nombreFinal);
            filePart.write(destino.getAbsolutePath());
            System.out.println("[PrestamoServlet] Imagen guardada en: " + destino.getAbsolutePath());
            return nombreFinal;

        } catch (Exception e) {
            System.err.println("[PrestamoServlet] Error al guardar imagen: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    private void verPrestamo(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            int id = Integer.parseInt(req.getParameter("id"));

            // Puedes buscar el préstamo si quieres mostrar info
            // Prestamo p = prestamoDAO.buscarPorId(id);
            req.setAttribute("idPrestamo", id);

            req.getRequestDispatcher("/WEB-INF/vistas/verPrestamoQR.jsp")
                    .forward(req, resp);

        } catch (Exception e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Préstamo inválido");
        }
    }
}

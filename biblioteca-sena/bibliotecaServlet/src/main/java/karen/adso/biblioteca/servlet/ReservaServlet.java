package karen.adso.biblioteca.servlet;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import karen.adso.biblioteca.dao.LibroDAO;
import karen.adso.biblioteca.dao.ReservaDAO;
import karen.adso.biblioteca.dao.UsuarioDAO;
import karen.adso.biblioteca.modelo.Libro;
import karen.adso.biblioteca.modelo.Reserva;
import karen.adso.biblioteca.modelo.Usuario;
import karen.adso.biblioteca.util.EmailService;

@WebServlet("/ReservaServlet")
public class ReservaServlet extends HttpServlet {

    private final ReservaDAO reservaDAO = new ReservaDAO();
    private final LibroDAO libroDAO = new LibroDAO();
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    // ── GET ───────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String accion = req.getParameter("accion");
        if (accion == null) {
            accion = "listar"; // Default: listado
        }
        switch (accion) {
            case "listar":
                listar(req, resp);
                break;
            case "formulario":
                mostrarFormulario(req, resp);
                break;
            case "editar":
                mostrarEditar(req, resp);
                break;
            case "cancelar":
                cancelar(req, resp);
                break;
            default:
                listar(req, resp);
        }
    }

    // ── POST ──────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String accion = req.getParameter("accion");

        if ("guardar".equals(accion)) {
            guardar(req, resp);
        } else if ("actualizar".equals(accion)) {
            actualizar(req, resp);
        } else {
            listar(req, resp);
        }
    }

    // ── LISTAR ────────────────────────────────────────────
    private void listar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/loginServlet");
            return;
        }

        String tipoUsuario = (String) session.getAttribute("tipoUsuario");
        Integer usuarioId = (Integer) session.getAttribute("usuarioId");

        try {
            List<Reserva> reservas;

            // 🔹 ADMIN Y BIBLIOTECARIO → ven TODAS
            if ("Administrativo".equals(tipoUsuario) || "Bibliotecario".equals(tipoUsuario)) {

                reservas = reservaDAO.listarTodas();

                request.setAttribute("reservas", reservas);
                request.setAttribute("modo", "listar");

                // 👉 IMPORTANTE: FORWARD (NO REDIRECT)
                request.getRequestDispatcher("/WEB-INF/vistas/formularioReserva.jsp")
                        .forward(request, response);
            } // 🔹 ESTUDIANTE → solo sus reservas
            else {

                if (usuarioId == null) {
                    response.sendRedirect(request.getContextPath() + "/loginServlet");
                    return;
                }

                reservas = reservaDAO.listarPorUsuario(usuarioId);

                request.setAttribute("reservas", reservas);
                request.setAttribute("modo", "listar");

                // 👉 MISMA VISTA, PERO FILTRADA
                request.getRequestDispatcher("/WEB-INF/vistas/misReservas.jsp")
                        .forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error al listar reservas");
            request.getRequestDispatcher("/WEB-INF/vistas/reserva.jsp")
                    .forward(request, response);
        }
    }

    // ── MOSTRAR FORMULARIO NUEVA RESERVA ─────────────────
    private void mostrarFormulario(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setAttribute("libros", libroDAO.listarTodos());
        req.setAttribute("usuarios", usuarioDAO.listarActivos());
        req.setAttribute("modo", "formulario");
        req.getRequestDispatcher("/WEB-INF/vistas/formularioReserva.jsp").forward(req, resp);
    }

    // ── MOSTRAR FORMULARIO EDITAR ESTADO ─────────────────
    private void mostrarEditar(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            int id = Integer.parseInt(req.getParameter("id"));
            String filtro = req.getParameter("filtro");
            if (filtro == null) {
                filtro = "todas";
            }

            Reserva r = reservaDAO.buscarPorId(id);

            if (r == null) {
                req.getSession().setAttribute("mensaje", "Reserva no encontrada.");
                req.getSession().setAttribute("tipoMensaje", "danger");
                resp.sendRedirect(req.getContextPath() + "/ReservaServlet?accion=listar&filtro=" + filtro);
                return;
            }

            req.setAttribute("reservaEditar", r);
            req.setAttribute("modo", "editar");
            req.setAttribute("filtro", filtro);
            req.setAttribute("libros", libroDAO.listarTodos());
            req.setAttribute("usuarios", usuarioDAO.listarActivos());
            req.setAttribute("reservas", reservaDAO.listarTodas());

            req.getRequestDispatcher("/WEB-INF/vistas/formularioReserva.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("mensaje", "Error al cargar reserva: " + e.getMessage());
            req.getSession().setAttribute("tipoMensaje", "danger");
            resp.sendRedirect(req.getContextPath() + "/ReservaServlet?accion=listar");
        }
    }

    // ── GUARDAR NUEVA RESERVA ─────────────────────────────
    private void guardar(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            int idLibro = Integer.parseInt(req.getParameter("idLibro"));
            int idUsuario = Integer.parseInt(req.getParameter("idUsuario"));

            if (reservaDAO.existeReservaPendiente(idLibro, idUsuario)) {
                req.setAttribute("error", "Este usuario ya tiene una reserva pendiente para ese libro.");
                mostrarFormulario(req, resp);
                return;
            }

            Reserva r = new Reserva();
            r.setIdLibro(idLibro);
            r.setIdUsuario(idUsuario);

            int idGenerado = reservaDAO.insertar(r);

            if (idGenerado > 0) {
                try {
                    Usuario u = usuarioDAO.buscarPorId(idUsuario);
                    if (u != null && u.getEmail() != null && !u.getEmail().isEmpty()) {
                        String tituloLibro = obtenerTituloLibro(idLibro);
                        String nombre = u.getNombres() + " " + u.getApellidos();
                        EmailService.enviarConfirmacionReserva(u.getEmail(), nombre, tituloLibro, idGenerado);
                    }
                } catch (Exception mailEx) {
                    System.err.println("Aviso: correo reserva #" + idGenerado + " fallido: " + mailEx.getMessage());
                }
                req.getSession().setAttribute("mensaje", "Reserva registrada correctamente.");
                req.getSession().setAttribute("tipoMensaje", "success");
                resp.sendRedirect(req.getContextPath() + "/ReservaServlet?accion=listar");
            } else {
                req.setAttribute("error", "No se pudo registrar la reserva. Intenta de nuevo.");
                mostrarFormulario(req, resp);
            }

        } catch (NumberFormatException e) {
            req.setAttribute("error", "Datos inválidos. Por favor verifica el formulario.");
            mostrarFormulario(req, resp);
        }
    }

    // ── ACTUALIZAR ESTADO ─────────────────────────────────
    private void actualizar(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            int idReserva = Integer.parseInt(req.getParameter("idReserva"));
            String estado = req.getParameter("estado");
            String filtro = req.getParameter("filtro");
            if (filtro == null) {
                filtro = "todas";
            }

            boolean ok = reservaDAO.actualizarEstado(idReserva, estado);

            req.getSession().setAttribute("mensaje", ok ? "Estado actualizado a '" + estado + "'" : "Error al actualizar el estado.");
            req.getSession().setAttribute("tipoMensaje", ok ? "success" : "danger");
            resp.sendRedirect(req.getContextPath() + "/ReservaServlet?accion=listar&filtro=" + filtro);

        } catch (Exception e) {
            req.getSession().setAttribute("mensaje", "Error: " + e.getMessage());
            req.getSession().setAttribute("tipoMensaje", "danger");
            resp.sendRedirect(req.getContextPath() + "/ReservaServlet?accion=listar");
        }
    }

    // ── CANCELAR (ELIMINAR) ────────────────────────────────
    private void cancelar(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            int idReserva = Integer.parseInt(req.getParameter("id"));
            reservaDAO.cancelar(idReserva);
        } catch (NumberFormatException ignored) {
        }
        resp.sendRedirect(req.getContextPath() + "/ReservaServlet?accion=listar");
    }

    // ── Helper ────────────────────────────────────────────
    private String obtenerTituloLibro(int idLibro) {
        try {
            Libro libro = libroDAO.buscarPorId(idLibro);
            return libro != null ? libro.getTitulo() : "Libro #" + idLibro;
        } catch (Exception e) {
            return "Libro #" + idLibro;
        }
    }
}

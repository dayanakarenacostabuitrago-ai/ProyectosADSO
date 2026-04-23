package karen.adso.biblioteca.servlet;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import karen.adso.biblioteca.dao.MultaDAO;
import karen.adso.biblioteca.dao.PrestamoDAO;
import karen.adso.biblioteca.modelo.Multa;
import karen.adso.biblioteca.modelo.Prestamo;
import karen.adso.biblioteca.modelo.Usuario;

@WebServlet("/MultaServlet")
public class MultaServlet extends HttpServlet {

    private final MultaDAO multaDAO = new MultaDAO();
    private final PrestamoDAO prestamoDAO = new PrestamoDAO();

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
            case "pagar":
                mostrarFormularioPago(request, response);
                break;
            case "editar":
                mostrarFormularioEditar(request, response);
                break;
            case "eliminar":
                eliminarMulta(request, response);
                break;
            default:
                listarMultas(request, response);
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
                insertarMulta(request, response);
                break;
            case "registrarPago":
                registrarPago(request, response);
                break;
            case "actualizar":
                actualizarMulta(request, response);
                break;
            default:
                listarMultas(request, response);
        }
    }

    // ── LISTAR ───────────────────────────────────────────────
    private void listarMultas(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
        String tipoUsuario = (String) request.getSession().getAttribute("tipoUsuario");
        List<Multa> multas;
        if (usuario != null && "Estudiante".equals(tipoUsuario)) {
            multas = multaDAO.listarPorUsuario(usuario.getIdUsuario());
        } else {
            multas = multaDAO.listarTodos();
        }
        request.setAttribute("multas", multas);
        request.getRequestDispatcher("/WEB-INF/vistas/Multa.jsp").forward(request, response);
    }

    // ── FORMULARIO NUEVA MULTA ────────────────────────────────
    private void mostrarFormularioNuevo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String tipoUsuario = (String) request.getSession().getAttribute("tipoUsuario");
        if (!"Administrativo".equals(tipoUsuario) && !"Bibliotecario".equals(tipoUsuario)) {
            request.getSession().setAttribute("mensaje", "No tiene permisos para crear multas.");
            request.getSession().setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/MultaServlet");
            return;
        }
        request.setAttribute("prestamos", prestamoDAO.listarActivos());
        request.getRequestDispatcher("/WEB-INF/vistas/formularioMulta.jsp").forward(request, response);
    }

    // ── FORMULARIO PAGO ───────────────────────────────────────
    private void mostrarFormularioPago(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Multa multa = multaDAO.buscarPorId(id);
            if (multa == null) {
                request.getSession().setAttribute("mensaje", "Multa no encontrada.");
                request.getSession().setAttribute("tipoMensaje", "danger");
                response.sendRedirect(request.getContextPath() + "/MultaServlet");
                return;
            }
            Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
            String tipoUsuario = (String) request.getSession().getAttribute("tipoUsuario");
            if ("Estudiante".equals(tipoUsuario)) {
                Prestamo prestamo = prestamoDAO.buscarPorId(multa.getIdPrestamo());
                if (prestamo == null || prestamo.getIdUsuario() != usuario.getIdUsuario()) {
                    request.getSession().setAttribute("mensaje", "No puede pagar una multa que no es suya.");
                    request.getSession().setAttribute("tipoMensaje", "danger");
                    response.sendRedirect(request.getContextPath() + "/MultaServlet");
                    return;
                }
            }
            request.setAttribute("multa", multa);
            request.getRequestDispatcher("/WEB-INF/vistas/formularioMulta.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("mensaje", "ID de multa inválido.");
            request.getSession().setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/MultaServlet");
        }
    }

    // ── FORMULARIO EDITAR ─────────────────────────────────────
    private void mostrarFormularioEditar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String tipoUsuario = (String) request.getSession().getAttribute("tipoUsuario");
        if (!"Administrativo".equals(tipoUsuario) && !"Bibliotecario".equals(tipoUsuario)) {
            request.getSession().setAttribute("mensaje", "No tiene permisos para editar multas.");
            request.getSession().setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/MultaServlet");
            return;
        }
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Multa multa = multaDAO.buscarPorId(id);
            if (multa == null) {
                request.getSession().setAttribute("mensaje", "Multa no encontrada.");
                request.getSession().setAttribute("tipoMensaje", "danger");
                response.sendRedirect(request.getContextPath() + "/MultaServlet");
                return;
            }
            request.setAttribute("multa", multa);
            request.setAttribute("modoEditar", true);
            request.getRequestDispatcher("/WEB-INF/vistas/formularioMulta.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("mensaje", "ID inválido.");
            request.getSession().setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/MultaServlet");
        }
    }

    // ── INSERTAR ─────────────────────────────────────────────
    private void insertarMulta(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String tipoUsuario = (String) request.getSession().getAttribute("tipoUsuario");
        if (!"Administrativo".equals(tipoUsuario) && !"Bibliotecario".equals(tipoUsuario)) {
            request.getSession().setAttribute("mensaje", "No tiene permisos para esta acción.");
            request.getSession().setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/MultaServlet");
            return;
        }
        try {
            Multa m = new Multa();
            String idPrestamoStr = request.getParameter("idPrestamo");
            if (idPrestamoStr == null || idPrestamoStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Debe seleccionar un préstamo");
            }
            m.setIdPrestamo(Integer.parseInt(idPrestamoStr.trim()));

            String montoStr = request.getParameter("monto");
            if (montoStr == null || montoStr.trim().isEmpty()) {
                throw new IllegalArgumentException("El monto es obligatorio");
            }
            m.setMonto(Double.parseDouble(montoStr.trim()));

            m.setEstado("Pendiente");

            boolean ok = multaDAO.insertar(m);
            request.getSession().setAttribute("mensaje", ok ? "Multa registrada exitosamente." : "Error al registrar la multa.");
            request.getSession().setAttribute("tipoMensaje", ok ? "success" : "danger");
        } catch (IllegalArgumentException e) {
            request.getSession().setAttribute("mensaje", "Error: " + e.getMessage());
            request.getSession().setAttribute("tipoMensaje", "danger");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("mensaje", "Error inesperado: " + e.getMessage());
            request.getSession().setAttribute("tipoMensaje", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/MultaServlet");
    }

    // ── ACTUALIZAR (editar monto y estado) ────────────────────
    private void actualizarMulta(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String tipoUsuario = (String) request.getSession().getAttribute("tipoUsuario");
        if (!"Administrativo".equals(tipoUsuario) && !"Bibliotecario".equals(tipoUsuario)) {
            request.getSession().setAttribute("mensaje", "No tiene permisos para esta acción.");
            request.getSession().setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/MultaServlet");
            return;
        }
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String montoStr = request.getParameter("monto");
            String estado = request.getParameter("estado");
            if (montoStr == null || montoStr.trim().isEmpty()) {
                throw new IllegalArgumentException("El monto es obligatorio");
            }
            if (estado == null || estado.trim().isEmpty()) {
                throw new IllegalArgumentException("El estado es obligatorio");
            }

            Multa m = new Multa();
            m.setIdMulta(id);
            m.setMonto(Double.parseDouble(montoStr.trim()));
            m.setEstado(estado.trim());

            boolean ok = multaDAO.actualizar(m);
            request.getSession().setAttribute("mensaje", ok ? "Multa actualizada exitosamente." : "Error al actualizar la multa.");
            request.getSession().setAttribute("tipoMensaje", ok ? "success" : "danger");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("mensaje", "Error: " + e.getMessage());
            request.getSession().setAttribute("tipoMensaje", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/MultaServlet");
    }

    // ── REGISTRAR PAGO ────────────────────────────────────────
    private void registrarPago(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String fechaPago = request.getParameter("fechaPago");
            if (fechaPago == null || fechaPago.trim().isEmpty()) {
                request.getSession().setAttribute("mensaje", "La fecha de pago es obligatoria.");
                request.getSession().setAttribute("tipoMensaje", "danger");
                response.sendRedirect(request.getContextPath() + "/MultaServlet");
                return;
            }
            Multa multa = multaDAO.buscarPorId(id);
            if (multa == null) {
                request.getSession().setAttribute("mensaje", "Multa no encontrada.");
                request.getSession().setAttribute("tipoMensaje", "danger");
                response.sendRedirect(request.getContextPath() + "/MultaServlet");
                return;
            }
            Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
            String tipoUsuario = (String) request.getSession().getAttribute("tipoUsuario");
            if ("Estudiante".equals(tipoUsuario)) {
                Prestamo prestamo = prestamoDAO.buscarPorId(multa.getIdPrestamo());
                if (prestamo == null || prestamo.getIdUsuario() != usuario.getIdUsuario()) {
                    request.getSession().setAttribute("mensaje", "No puede pagar una multa que no es suya.");
                    request.getSession().setAttribute("tipoMensaje", "danger");
                    response.sendRedirect(request.getContextPath() + "/MultaServlet");
                    return;
                }
            }
            boolean ok = multaDAO.registrarPago(id, fechaPago);
            request.getSession().setAttribute("mensaje", ok ? "Pago registrado exitosamente." : "Error al registrar el pago.");
            request.getSession().setAttribute("tipoMensaje", ok ? "success" : "danger");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("mensaje", "Error: " + e.getMessage());
            request.getSession().setAttribute("tipoMensaje", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/MultaServlet");
    }

    // ── ELIMINAR ─────────────────────────────────────────────
    private void eliminarMulta(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String tipoUsuario = (String) request.getSession().getAttribute("tipoUsuario");
        if (!"Administrativo".equals(tipoUsuario)) {
            request.getSession().setAttribute("mensaje", "No tiene permisos para esta acción.");
            request.getSession().setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/MultaServlet");
            return;
        }
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean ok = multaDAO.eliminar(id);
            request.getSession().setAttribute("mensaje", ok ? "Multa eliminada exitosamente." : "Error al eliminar la multa.");
            request.getSession().setAttribute("tipoMensaje", ok ? "success" : "danger");
        } catch (Exception e) {
            request.getSession().setAttribute("mensaje", "Error: " + e.getMessage());
            request.getSession().setAttribute("tipoMensaje", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/MultaServlet");
    }
}

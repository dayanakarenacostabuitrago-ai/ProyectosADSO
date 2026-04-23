package karen.adso.biblioteca.servlet;

import java.io.IOException;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import karen.adso.biblioteca.dao.UsuarioDAO;
import karen.adso.biblioteca.modelo.Usuario;

@WebServlet("/UsuarioServlet")
public class UsuarioServlet extends HttpServlet {

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
            case "editar":
                mostrarFormularioEditar(request, response);
                break;
            case "eliminar":
                eliminarUsuario(request, response);
                break;
            case "cambiarEstado":
                cambiarEstado(request, response);
                break;
            default:
                listarUsuarios(request, response);
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
                insertarUsuario(request, response);
                break;
            case "actualizar":
                actualizarUsuario(request, response);
                break;
            default:
                listarUsuarios(request, response);
        }
    }

    // ── LISTAR ───────────────────────────────────────────────
    private void listarUsuarios(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Usuario> usuarios = usuarioDAO.listarTodos();
        request.setAttribute("usuarios", usuarios);
        request.getRequestDispatcher("/WEB-INF/vistas/usuario.jsp").forward(request, response);
    }

    // ── FORMULARIO NUEVO ─────────────────────────────────────
    private void mostrarFormularioNuevo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        soloAdmin(request, response);
        if (!soloAdmin(request, response)) {
            return;
        }
        request.getRequestDispatcher("/WEB-INF/vistas/formularioUsuario.jsp").forward(request, response);
    }

    // ── FORMULARIO EDITAR ────────────────────────────────────
    private void mostrarFormularioEditar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Usuario usuario = usuarioDAO.buscarPorId(id);

            if (usuario == null) {
                request.getSession().setAttribute("mensaje", "Usuario no encontrado.");
                request.getSession().setAttribute("tipoMensaje", "danger");
                response.sendRedirect(request.getContextPath() + "/UsuarioServlet");
                return;
            }

            request.setAttribute("usuario", usuario);
            request.getRequestDispatcher("/WEB-INF/vistas/formularioUsuario.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("mensaje", "ID de usuario inválido.");
            request.getSession().setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/UsuarioServlet");
        }
    }

    // ── INSERTAR ─────────────────────────────────────────────
    private void insertarUsuario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Usuario u = construirUsuario(request);
            boolean ok = usuarioDAO.insertar(u);
            request.getSession().setAttribute("mensaje", ok ? "Usuario registrado exitosamente." : "Error al registrar el usuario.");
            request.getSession().setAttribute("tipoMensaje", ok ? "success" : "danger");
        } catch (IllegalArgumentException e) {
            request.getSession().setAttribute("mensaje", "Error: " + e.getMessage());
            request.getSession().setAttribute("tipoMensaje", "danger");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("mensaje", "Error inesperado: " + e.getMessage());
            request.getSession().setAttribute("tipoMensaje", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/UsuarioServlet");
    }

    // ── ACTUALIZAR ───────────────────────────────────────────
    private void actualizarUsuario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Usuario u = construirUsuario(request);
            u.setIdUsuario(Integer.parseInt(request.getParameter("id")));
            boolean ok = usuarioDAO.actualizar(u);
            request.getSession().setAttribute("mensaje", ok ? "Usuario actualizado exitosamente." : "Error al actualizar el usuario.");
            request.getSession().setAttribute("tipoMensaje", ok ? "success" : "danger");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("mensaje", "Error: " + e.getMessage());
            request.getSession().setAttribute("tipoMensaje", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/UsuarioServlet");
    }

    // ── ELIMINAR ─────────────────────────────────────────────
    private void eliminarUsuario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean ok = usuarioDAO.eliminar(id);
            request.getSession().setAttribute("mensaje", ok ? "Usuario eliminado exitosamente." : "Error al eliminar el usuario.");
            request.getSession().setAttribute("tipoMensaje", ok ? "success" : "danger");
        } catch (Exception e) {
            request.getSession().setAttribute("mensaje", "Error: " + e.getMessage());
            request.getSession().setAttribute("tipoMensaje", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/UsuarioServlet");
    }

    // ── CAMBIAR ESTADO (Activo/Inactivo) ─────────────────────
    private void cambiarEstado(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String estado = request.getParameter("estado"); // "Activo" o "Inactivo"

            if (estado == null || (!estado.equals("Activo") && !estado.equals("Inactivo"))) {
                throw new IllegalArgumentException("Estado inválido");
            }

            boolean ok = usuarioDAO.actualizarEstado(id, estado);
            request.getSession().setAttribute("mensaje", ok ? "Estado actualizado." : "Error al cambiar el estado.");
            request.getSession().setAttribute("tipoMensaje", ok ? "success" : "danger");

        } catch (Exception e) {
            request.getSession().setAttribute("mensaje", "Error: " + e.getMessage());
            request.getSession().setAttribute("tipoMensaje", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/UsuarioServlet");
    }

    // ── HELPER: construir usuario desde el form ───────────────
    private Usuario construirUsuario(HttpServletRequest request) {
        String documento = request.getParameter("documento");
        if (documento == null || documento.trim().isEmpty()) {
            throw new IllegalArgumentException("El documento es obligatorio");
        }

        String nombres = request.getParameter("nombres");
        if (nombres == null || nombres.trim().isEmpty()) {
            throw new IllegalArgumentException("Los nombres son obligatorios");
        }

        Usuario u = new Usuario();
        u.setDocumento(documento.trim());
        u.setNombres(nombres.trim());
        u.setApellidos(request.getParameter("apellidos"));
        u.setEmail(request.getParameter("email"));
        u.setTelefono(request.getParameter("telefono"));
        u.setTipoUsuario(request.getParameter("tipoUsuario"));

        String estado = request.getParameter("estado");
        u.setEstado(estado != null ? estado : "Activo");

        return u;
    }

    // ── HELPER: verificar que sea admin ──────────────────────
    private boolean soloAdmin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String tipo = (String) request.getSession().getAttribute("tipoUsuario");
        if (!"Administrativo".equals(tipo)) {
            request.getSession().setAttribute("mensaje", "No tiene permisos para esta acción.");
            request.getSession().setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/UsuarioServlet");
            return false;
        }
        return true;
    }
}

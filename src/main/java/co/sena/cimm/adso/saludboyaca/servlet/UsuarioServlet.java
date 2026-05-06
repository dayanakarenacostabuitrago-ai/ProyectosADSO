package co.sena.cimm.adso.saludboyaca.servlet;

import co.sena.cimm.adso.saludboyaca.dao.EspecialidadDAO;
import co.sena.cimm.adso.saludboyaca.dao.UsuarioDAO;
import co.sena.cimm.adso.saludboyaca.dto.Especialidad;
import co.sena.cimm.adso.saludboyaca.dto.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = { "/usuario", "/usuarios" })
public class UsuarioServlet extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();
    private final EspecialidadDAO especialidadDAO = new EspecialidadDAO();

    // ── GET ───────────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Usuario admin = validarAdmin(request, response);
        if (admin == null)
            return;

        String accion = request.getParameter("accion");
        if (accion == null)
            accion = "listar";

        switch (accion) {
            case "listar":
                listar(request, response);
                break;
            case "nuevo":
                mostrarFormulario(request, response, null);
                break;
            case "editar":
                editar(request, response);
                break;
            case "eliminar":
                eliminar(request, response);
                break;
            default:
                listar(request, response);
        }
    }

    // ── POST ──────────────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Usuario admin = validarAdmin(request, response);
        if (admin == null)
            return;

        String accion = request.getParameter("accion");

        if ("crear".equals(accion)) {
            crear(request, response);
        } else if ("actualizar".equals(accion)) {
            actualizar(request, response);
        }
    }

    // ── LISTAR ────────────────────────────────────────────────────
    private void listar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Usuario> usuarios = usuarioDAO.listar();
        List<Especialidad> especialidades = especialidadDAO.listar();

        request.setAttribute("usuarios", usuarios);
        request.setAttribute("especialidades", especialidades);
        request.setAttribute("activePage", "usuarios");
        request.getRequestDispatcher("/views/usuarios/lista.jsp").forward(request, response);
    }

    // ── MOSTRAR FORMULARIO ────────────────────────────────────────
    private void mostrarFormulario(HttpServletRequest request, HttpServletResponse response, Usuario u)
            throws ServletException, IOException {

        List<Especialidad> especialidades = especialidadDAO.listar();
        request.setAttribute("especialidades", especialidades);
        request.setAttribute("usuarioEditar", u);
        request.setAttribute("activePage", "usuarios");
        request.getRequestDispatcher("/views/usuarios/formulario.jsp").forward(request, response);
    }

    // ── EDITAR ────────────────────────────────────────────────────
    private void editar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        Usuario u = usuarioDAO.buscarPorId(id);

        if (u == null) {
            response.sendRedirect(request.getContextPath() + "/usuarios");
            return;
        }
        mostrarFormulario(request, response, u);
    }

    // ── ELIMINAR ──────────────────────────────────────────────────
    private void eliminar(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        // Protección: no eliminar al mismo admin activo
        Usuario adminSesion = (Usuario) request.getSession().getAttribute("usuario");
        if (adminSesion != null && adminSesion.getIdUsuario() == id) {
            response.sendRedirect(request.getContextPath() + "/usuarios?error=no_auto_eliminar");
            return;
        }

        try {
            boolean ok = usuarioDAO.eliminar(id);
            if (ok) {
                response.sendRedirect(request.getContextPath() + "/usuarios?msg=eliminado");
            } else {
                // eliminar() retornó false solo si desactivar() falló tras FK violation
                response.sendRedirect(request.getContextPath() + "/usuarios?error=fk_constraint");
            }
        } catch (RuntimeException e) {
            // Error general de BD (conexión, columna inexistente, etc.)
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/usuarios?error=error_general");
        }
    }

    // ── CREAR ─────────────────────────────────────────────────────
    private void crear(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Usuario u = construirUsuario(request);
        String password = request.getParameter("password");
        u.setPassword(password);

        boolean ok = usuarioDAO.insertar(u);

        if (ok) {
            response.sendRedirect(request.getContextPath() + "/usuarios?msg=creado");
        } else {
            request.setAttribute("error", "Error al crear el usuario. Verifica los datos.");
            mostrarFormulario(request, response, u);
        }
    }

    // ── ACTUALIZAR ────────────────────────────────────────────────
    private void actualizar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Usuario u = construirUsuario(request);
        u.setIdUsuario(Integer.parseInt(request.getParameter("idUsuario")));

        String nuevaPass = request.getParameter("password");
        boolean ok;

        if (nuevaPass != null && !nuevaPass.trim().isEmpty()) {
            u.setPassword(nuevaPass.trim());
            ok = usuarioDAO.actualizarConPassword(u);
        } else {
            ok = usuarioDAO.actualizar(u);
        }

        if (ok) {
            response.sendRedirect(request.getContextPath() + "/usuarios?msg=actualizado");
        } else {
            request.setAttribute("error", "Error al actualizar el usuario.");
            mostrarFormulario(request, response, u);
        }
    }

    // ── CONSTRUIR USUARIO DESDE REQUEST ──────────────────────────
    private Usuario construirUsuario(HttpServletRequest request) {
        Usuario u = new Usuario();
        u.setNombres(request.getParameter("nombres").trim());
        u.setApellidos(request.getParameter("apellidos").trim());
        u.setDocumento(request.getParameter("documento").trim());
        u.setEmail(request.getParameter("email").trim());
        u.setUserName(request.getParameter("userName").trim());
        u.setRol(request.getParameter("rol").trim().toUpperCase());
        u.setLangPreferido(
                request.getParameter("langPreferido") != null ? request.getParameter("langPreferido") : "es");
        u.setActivo("1".equals(request.getParameter("activo")) ? 1 : 0);

        String espParam = request.getParameter("idEspecialidad");
        if ("ADMINISTRADOR".equals(u.getRol()) || espParam == null || espParam.trim().isEmpty()
                || "0".equals(espParam.trim())) {
            u.setIdEspecialidad(null);
        } else {
            try {
                u.setIdEspecialidad(Integer.parseInt(espParam.trim()));
            } catch (NumberFormatException e) {
                u.setIdEspecialidad(null);
            }
        }

        return u;
    }

    // ── VALIDAR ADMINISTRADOR ─────────────────────────────────────
    private Usuario validarAdmin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return null;
        }
        Usuario u = (Usuario) session.getAttribute("usuario");
        if (u == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return null;
        }
        String rol = u.getRol() != null ? u.getRol().toUpperCase().trim() : "";
        if (!"ADMINISTRADOR".equals(rol)) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return null;
        }
        return u;
    }
}
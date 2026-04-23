package co.sena.cimm.adso.registraduria.servlet;

import co.sena.cimm.adso.registraduria.dao.UsuarioDAO;
import co.sena.cimm.adso.registraduria.dao.UsuarioDAOImpl;
import co.sena.cimm.adso.registraduria.model.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UsuarioDAO usuarioDAO;

    @Override
    public void init() {
        usuarioDAO = new UsuarioDAOImpl();
    }

    /** GET /login → muestra el formulario (o redirige si ya hay sesión activa) */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("usuario") != null) {
            // Ya autenticado → redirigir según rol
            String rol = (String) session.getAttribute("rol");
            if ("admin".equals(rol)) {
                resp.sendRedirect(req.getContextPath() + "/ciudadanos");
            } else {
                resp.sendRedirect(req.getContextPath() + "/consultaMesa");
            }
            return;
        }

        req.getRequestDispatcher("/WEB-INF/vistas/login.jsp").forward(req, resp);
    }

    /** POST /login → valida credenciales y crea sesión */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String username = req.getParameter("usuario");
        String password = req.getParameter("password");

        // Validación básica de campos vacíos
        if (username == null || username.isBlank() || password == null || password.isBlank()) {
            req.setAttribute("error", "Usuario y contraseña son obligatorios.");
            req.getRequestDispatcher("/WEB-INF/vistas/login.jsp").forward(req, resp);
            return;
        }

        try {
            boolean credencialesOk = usuarioDAO.validarCredenciales(username.trim(), password);

            if (!credencialesOk) {
                Usuario u = usuarioDAO.buscarPorUsername(username.trim());
                if (u != null && !u.isActivo()) {
                    req.setAttribute("error", "Tu cuenta está desactivada. Contacta al administrador.");
                } else {
                    req.setAttribute("error", "Usuario o contraseña incorrectos.");
                }
                req.getRequestDispatcher("/WEB-INF/vistas/login.jsp").forward(req, resp);
                return;
            }

            // Credenciales correctas → cargar usuario completo
            Usuario usuario = usuarioDAO.buscarPorUsername(username.trim());

            HttpSession session = req.getSession(true);
            session.setAttribute("usuario", usuario);
            session.setMaxInactiveInterval(60 * 60); // 1 hora

            // ── CORRECCIÓN: determinar rol según esSuperAdmin ──────────────────
            boolean esAdmin = Boolean.TRUE.equals(usuario.getEsSuperAdmin());
            session.setAttribute("rol", esAdmin ? "admin" : "ciudadano");
            // ───────────────────────────────────────────────────────────────────

            // Actualizar ultimoAcceso en BD
            actualizarUltimoAcceso(usuario.getIdUsuario());

            // Redirigir según rol
            if (esAdmin) {
                resp.sendRedirect(req.getContextPath() + "/ciudadanos");
            } else {
                // Los ciudadanos (no superAdmin) van directo a consultaMesa
                resp.sendRedirect(req.getContextPath() + "/consultaMesa");
            }

        } catch (Exception e) {
            req.setAttribute("error", "Error al conectar con la base de datos: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/vistas/login.jsp").forward(req, resp);
        }
    }

    private void actualizarUltimoAcceso(int idUsuario) {
        try {
            java.sql.Connection con = co.sena.cimm.adso.registraduria.config.ConexionDB.getConexion();
            java.sql.PreparedStatement ps = con.prepareStatement(
                    "UPDATE usuarios SET ultimoAcceso = GETDATE() WHERE idUsuario = ?");
            ps.setInt(1, idUsuario);
            ps.executeUpdate();
            ps.close();
            con.close();
        } catch (Exception ignored) {
            /* no crítico */
        }
    }
}

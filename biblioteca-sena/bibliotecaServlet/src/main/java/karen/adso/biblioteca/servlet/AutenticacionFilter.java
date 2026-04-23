package karen.adso.biblioteca.servlet;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@WebFilter(urlPatterns = {
    "/LibroServlet",
    "/UsuarioServlet",
    "/PrestamoServlet",
    "/MultaServlet",
    "/AutorServlet",
    "/CategoriaServlet",
    "/EditorialServlet"
})
public class AutenticacionFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  httpRequest  = (HttpServletRequest)  request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        HttpSession session     = httpRequest.getSession(false);
        boolean     autenticado = (session != null && session.getAttribute("usuario") != null);

        // 1. Si no está autenticado → redirigir al login
        if (!autenticado) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/loginServlet");
            return;
        }

        // 2. Verificar autorización por rol
        String tipo        = (String) session.getAttribute("tipoUsuario");
        String servletPath = httpRequest.getServletPath();

        if (!tieneAcceso(tipo, servletPath)) {
            // Redirigir al catálogo de libros con mensaje de acceso denegado
            session.setAttribute("mensaje",     "No tienes permiso para acceder a esa sección.");
            session.setAttribute("tipoMensaje", "error");
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/LibroServlet");
            return;
        }

        // 3. Acceso permitido → continuar
        chain.doFilter(request, response);
    }

    /**
     * Determina si el tipo de usuario tiene acceso al servlet solicitado.
     */
    private boolean tieneAcceso(String tipoUsuario, String servletPath) {
        if (tipoUsuario == null) return false;

        switch (tipoUsuario) {

            case "Administrativo":
                // Acceso total a todos los módulos
                return true;

            case "Bibliotecario":
                // Acceso a todo excepto gestión de usuarios
                return !servletPath.contains("UsuarioServlet");

            case "Estudiante":
                // Solo puede ver libros, sus préstamos y sus multas
                return servletPath.contains("LibroServlet")
                    || servletPath.contains("PrestamoServlet")
                    || servletPath.contains("MultaServlet");

            default:
                return false;
        }
    }

    @Override
    public void destroy() {}
}

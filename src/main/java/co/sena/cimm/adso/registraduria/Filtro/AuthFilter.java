package co.sena.cimm.adso.registraduria.Filtro;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * Filtro de autenticacion.
 * Protege todas las rutas administrativas.
 * Las rutas publicas (/login, /logout, /consultaMesa) quedan libres.
 */
@WebFilter("/*")
public class AuthFilter implements Filter {

    private static final String[] RUTAS_PUBLICAS = {
            "/login",
            "/logout",
            "/consulta-mesa",
            "/consultaMesa",
            "/solicitud",
            "/index.jsp",
            "/"
    };

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String uri = req.getRequestURI();
        String ctx = req.getContextPath();
        String ruta = uri.substring(ctx.length());

        // Ruta raíz vacía también es pública
        if (ruta.isEmpty())
            ruta = "/";

        // Rutas publicas o recursos estaticos: dejar pasar siempre
        if (esPublica(ruta)) {
            chain.doFilter(request, response);
            return;
        }

        // Verificar sesion activa
        HttpSession session = req.getSession(false);
        boolean autenticado = (session != null && session.getAttribute("usuario") != null);

        if (autenticado) {
            resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            resp.setHeader("Pragma", "no-cache");
            resp.setDateHeader("Expires", 0);
            chain.doFilter(request, response);
        } else {
            resp.sendRedirect(ctx + "/login");
        }
    }

    private boolean esPublica(String ruta) {
        if (ruta.endsWith(".css") || ruta.endsWith(".js") ||
                ruta.endsWith(".png") || ruta.endsWith(".jpg") ||
                ruta.endsWith(".ico") || ruta.endsWith(".woff") ||
                ruta.endsWith(".woff2") || ruta.startsWith("/static/")) {
            return true;
        }
        for (String pub : RUTAS_PUBLICAS) {
            if (ruta.equals(pub) || ruta.startsWith(pub + "?") || ruta.startsWith(pub + "/")) {
                return true;
            }
        }
        return false;
    }

    @Override
    public void init(FilterConfig fc) {
    }

    @Override
    public void destroy() {
    }
}

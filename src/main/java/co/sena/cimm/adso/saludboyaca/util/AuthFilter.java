package co.sena.cimm.adso.saludboyaca.util;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * AuthFilter — solo intercepta REQUEST (no FORWARD ni INCLUDE).
 * Así los forwards internos a /views/*.jsp no vuelven a pasar por aquí.
 */
@WebFilter(urlPatterns = "/*", dispatcherTypes = { DispatcherType.REQUEST } // ← clave: solo requests externas
)
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        resp.setHeader("X-Frame-Options", "DENY");
        // Evitar que el navegador sirva páginas protegidas desde caché
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        resp.setHeader("Pragma", "no-cache");
        resp.setDateHeader("Expires", 0);

        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();
        String path = uri.substring(contextPath.length());

        // ── 0. Bloquear acceso directo a JSPs ────────────────────────────────
        // Los forwards internos del servlet son DispatcherType.FORWARD, no llegan aquí.
        // Solo requests externas directas a /views/* llegan y deben bloquearse.
        if (path.startsWith("/views/")) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        // Normalizar trailing slash
        if (path.length() > 1 && path.endsWith("/")) {
            path = path.substring(0, path.length() - 1);
        }

        // ── 1. Recursos estáticos: siempre libres ────────────────────────────────
        if (path.endsWith(".css") || path.endsWith(".js")
                || path.endsWith(".png") || path.endsWith(".jpg")
                || path.endsWith(".ico") || path.endsWith(".gif")
                || path.endsWith(".woff") || path.endsWith(".woff2")
                || path.endsWith(".map") || path.endsWith(".svg")) {
            chain.doFilter(request, response);
            return;
        }

        // ── 2. Rutas públicas: login, raíz, consulta pública ─────────────────
        if (path.isEmpty()
                || path.equals("/")
                || path.startsWith("/login")
                || path.startsWith("/recuperar")
                || path.startsWith("/consulta_cita")
                || path.startsWith("/error")) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);

        // ── 3. /otp: requiere haber pasado por login (usuarioTemp en sesión) ─
        if (path.startsWith("/otp")) {
            boolean yaAutenticado = session != null
                    && session.getAttribute("usuario") != null
                    && Boolean.TRUE.equals(session.getAttribute("otpVerificado"));

            if (yaAutenticado) {
                resp.sendRedirect(contextPath + "/dashboard");
                return;
            }

            boolean tieneTemp = session != null
                    && session.getAttribute("usuarioTemp") != null;

            if (!tieneTemp) {
                resp.sendRedirect(contextPath + "/login");
                return;
            }

            chain.doFilter(request, response);
            return;
        }

        // ── 4. Todo lo demás: requiere autenticación completa ────────────────
        boolean autenticado = session != null
                && session.getAttribute("usuario") != null
                && Boolean.TRUE.equals(session.getAttribute("otpVerificado"));

        // SI YA ESTÁ AUTENTICADO → dejar pasar
        if (autenticado) {
            chain.doFilter(request, response);
            return;
        }

        // Si NO está autenticado → bloquear
        resp.sendRedirect(contextPath + "/login");
    }
}

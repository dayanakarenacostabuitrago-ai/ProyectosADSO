package co.sena.cimm.adso.saludboyaca.util;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.Locale;

@WebFilter(urlPatterns = "/*", dispatcherTypes = { DispatcherType.REQUEST } // ← solo requests externas
)
public class LocaleFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        String lang = req.getParameter("lang");

        // Obtener sesión: crearla solo si viene ?lang=, no en recursos estáticos
        HttpSession session = lang != null
                ? req.getSession(true)
                : req.getSession(false);

        if (session != null) {
            if (lang != null) {
                Locale locale;
                switch (lang) {
                    case "en":
                        locale = new Locale("en", "US");
                        break;
                    case "it":
                        locale = new Locale("it", "IT");
                        break;
                    default:
                        lang = "es";
                        locale = new Locale("es", "ES");
                        break;
                }
                session.setAttribute("locale", locale);
                session.setAttribute("lang", lang);
            }

            // Inicializar por defecto si la sesión no tiene idioma aún
            if (session.getAttribute("locale") == null) {
                session.setAttribute("locale", new Locale("es", "ES"));
                session.setAttribute("lang", "es");
            }

            request.setAttribute("locale", session.getAttribute("locale"));
        }

        chain.doFilter(request, response);
    }
}

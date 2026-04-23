package karen.adso.biblioteca.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Locale;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import karen.adso.biblioteca.dao.MultaDAO;
import karen.adso.biblioteca.modelo.Multa;
import karen.adso.biblioteca.modelo.Usuario;

/**
 * Genera un recibo HTML imprimible para una multa. URL: /recibo?idMulta=123
 *
 * Nota: la multa trae tituloLibro y nombreUsuario del JOIN en MultaDAO. Si esos
 * campos no están en el modelo Multa, se muestran los IDs.
 */
@WebServlet("/recibo")
public class ReciboServlet extends HttpServlet {

    private final MultaDAO multaDAO = new MultaDAO();
    private static final SimpleDateFormat SDF = new SimpleDateFormat("dd/MM/yyyy HH:mm", new Locale("es", "CO"));
    private static final NumberFormat NF = NumberFormat.getCurrencyInstance(new Locale("es", "CO"));

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Verificar sesión
        HttpSession sesion = req.getSession(false);
        Usuario usuario = (sesion == null) ? null : (Usuario) sesion.getAttribute("usuario");
        if (usuario == null) {
            resp.sendRedirect(req.getContextPath() + "/loginServlet");
            return;
        }

        String idStr = req.getParameter("idMulta");
        if (idStr == null || idStr.trim().isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Parámetro idMulta requerido.");
            return;
        }

        int idMulta;
        try {
            idMulta = Integer.parseInt(idStr.trim());
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "idMulta debe ser un número.");
            return;
        }

        Multa m = multaDAO.buscarPorId(idMulta);
        if (m == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Multa #" + idMulta + " no encontrada.");
            return;
        }

        String tituloLibro = m.getTituloLibro() != null ? m.getTituloLibro() : "Préstamo #" + m.getIdPrestamo();
        String nombreUsuario = m.getNombreUsuario() != null ? m.getNombreUsuario() : "—";
        String apellido = m.getApellidoUsuario() != null ? m.getApellidoUsuario() : "";
        String estadoBadge = "Pagada".equals(m.getEstado()) || "Pagado".equals(m.getEstado())
                ? "<span style='color:#4ade80'>✔ Pagada</span>"
                : "<span style='color:#f87171'>⚠ Pendiente</span>";

        String fechaGen = m.getFechaGeneracion() != null ? SDF.format(m.getFechaGeneracion()) : "—";
        String fechaPago = m.getFechaPago() != null ? SDF.format(m.getFechaPago()) : "—";
        String monto = NF.format(m.getMonto());
        String fechaHoy = SDF.format(new java.util.Date());

        resp.setContentType("text/html; charset=UTF-8");
        PrintWriter out = resp.getWriter();

        out.println("<!DOCTYPE html>");
        out.println("<html lang='es'><head>");
        out.println("<meta charset='UTF-8'>");
        out.println("<meta name='viewport' content='width=device-width, initial-scale=1'>");
        out.println("<title>Recibo Multa #" + idMulta + " — Biblioteca SENA</title>");
        out.println("<link href='https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=Lato:wght@300;400;700&display=swap' rel='stylesheet'>");
        out.println("<style>");
        out.println("*{margin:0;padding:0;box-sizing:border-box}");
        out.println("body{font-family:'Lato',sans-serif;background:#f0f4f8;display:flex;justify-content:center;padding:2rem 1rem;min-height:100vh}");
        out.println(".recibo{background:#fff;width:100%;max-width:560px;border-radius:16px;box-shadow:0 8px 40px rgba(0,0,0,.12);overflow:hidden}");
        out.println(".recibo-header{background:linear-gradient(135deg,#0D2855,#1565C0);color:#fff;padding:1.8rem 2rem 1.4rem;text-align:center}");
        out.println(".recibo-header h1{font-family:'Playfair Display',serif;font-size:1.5rem;margin-bottom:.3rem}");
        out.println(".recibo-header p{font-size:.82rem;opacity:.7}");
        out.println(".recibo-body{padding:1.8rem 2rem}");
        out.println(".recibo-num{text-align:center;margin-bottom:1.4rem}");
        out.println(".recibo-num span{display:inline-block;background:#f0f4f8;border-radius:50px;padding:.4rem 1.4rem;font-size:.85rem;color:#555;letter-spacing:.04em}");
        out.println(".recibo-row{display:flex;justify-content:space-between;align-items:flex-start;padding:.65rem 0;border-bottom:1px solid #f0f4f8;font-size:.88rem}");
        out.println(".recibo-row:last-child{border-bottom:none}");
        out.println(".recibo-row .lbl{color:#888;flex-shrink:0;margin-right:1rem}");
        out.println(".recibo-row .val{font-weight:700;color:#1a2540;text-align:right}");
        out.println(".monto-row{background:#f8fbff;border-radius:10px;padding:1rem 1.2rem;margin:1.2rem 0;display:flex;justify-content:space-between;align-items:center}");
        out.println(".monto-row .lbl{font-size:.82rem;color:#555}");
        out.println(".monto-row .val{font-size:1.5rem;font-weight:900;color:#1565C0;font-family:'Playfair Display',serif}");
        out.println(".recibo-footer{background:#f8fbff;padding:1rem 2rem;text-align:center;font-size:.78rem;color:#aaa;border-top:1px solid #f0f4f8}");
        out.println(".btn-print{display:block;width:100%;padding:.75rem;background:linear-gradient(135deg,#1565C0,#42A5F5);color:#fff;border:none;border-radius:10px;font-size:.95rem;font-weight:700;cursor:pointer;margin:1.2rem 0 .2rem;font-family:'Lato',sans-serif}");
        out.println(".btn-print:hover{opacity:.9}");
        out.println(".sello{width:70px;height:70px;border-radius:50%;background:"
                + ("Pagada".equals(m.getEstado()) || "Pagado".equals(m.getEstado())
                ? "rgba(76,175,80,.12);border:2px solid #4caf50;color:#4caf50"
                : "rgba(239,83,80,.1);border:2px dashed #ef5350;color:#ef5350")
                + ";display:flex;align-items:center;justify-content:center;font-size:1.5rem;margin:0 auto 1rem}");
        out.println("@media print{.btn-print,.btn-back{display:none!important}body{background:#fff;padding:0}.recibo{box-shadow:none;border-radius:0}}");
        out.println("</style></head><body>");

        out.println("<div class='recibo'>");

        // Header
        out.println("<div class='recibo-header'>");
        out.println("  <h1>📚 Biblioteca SENA</h1>");
        out.println("  <p>Recibo de Multa</p>");
        out.println("</div>");

        // Body
        out.println("<div class='recibo-body'>");

        // Sello de estado
        out.println("<div class='sello'>");
        if ("Pagada".equals(m.getEstado()) || "Pagado".equals(m.getEstado())) {
            out.println("✔");
        } else {
            out.println("⚠");
        }
        out.println("</div>");

        // Número de recibo
        out.println("<div class='recibo-num'><span>Multa #" + idMulta + " · " + m.getEstado() + "</span></div>");

        // Filas de datos
        out.println("<div class='recibo-row'><span class='lbl'>Libro</span><span class='val'>" + escHtml(tituloLibro) + "</span></div>");
        out.println("<div class='recibo-row'><span class='lbl'>Usuario</span><span class='val'>" + escHtml(nombreUsuario + " " + apellido) + "</span></div>");
        out.println("<div class='recibo-row'><span class='lbl'>Préstamo ID</span><span class='val'>#" + m.getIdPrestamo() + "</span></div>");
        out.println("<div class='recibo-row'><span class='lbl'>F. Generación</span><span class='val'>" + fechaGen + "</span></div>");
        out.println("<div class='recibo-row'><span class='lbl'>F. Pago</span><span class='val'>" + fechaPago + "</span></div>");
        out.println("<div class='recibo-row'><span class='lbl'>Estado</span><span class='val'>" + estadoBadge + "</span></div>");

        // Monto destacado
        out.println("<div class='monto-row'>");
        out.println("  <span class='lbl'>Total multa</span>");
        out.println("  <span class='val'>" + escHtml(monto) + "</span>");
        out.println("</div>");

        // Botón imprimir
        out.println("<button class='btn-print' onclick='window.print()'><i>🖨</i> Imprimir recibo</button>");
        out.println("<button class='btn-back' onclick='window.close()' style='display:block;width:100%;padding:.55rem;background:transparent;border:1px solid #ddd;border-radius:10px;font-size:.85rem;cursor:pointer;color:#555;font-family:Lato,sans-serif'>Cerrar</button>");

        out.println("</div>"); // recibo-body

        // Footer
        out.println("<div class='recibo-footer'>");
        out.println("  Generado el " + fechaHoy + " · Sistema de Gestión Bibliotecaria SENA<br>");
        out.println("  Este documento es un comprobante oficial.");
        out.println("</div>");

        out.println("</div></body></html>");
    }

    private String escHtml(String s) {
        if (s == null) {
            return "";
        }
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;");
    }
}

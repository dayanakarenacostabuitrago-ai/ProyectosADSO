package karen.adso.biblioteca.util;

import javax.mail.*;
import javax.mail.internet.*;
import java.util.Properties;

/**
 * Servicio centralizado de correo electrónico.
 *
 * CONFIGURACIÓN (antes de usar): 1. Crea una "Contraseña de aplicación" en tu
 * cuenta Gmail: Cuenta Google → Seguridad → Verificación en dos pasos →
 * Contraseñas de aplicaciones → "Correo" + "Otro (nombre personalizado)" 2.
 * Reemplaza REMITENTE y APP_PASSWORD con tus valores reales.
 */
public class EmailService {

    // ── CAMBIA ESTOS DOS VALORES ──────────────────────────
    private static final String REMITENTE = "dayanakarenacostabuitrago@gmail.com";
    private static final String APP_PASSWORD = "mmnvqkhhoymxlcgq"; // contraseña de aplicación Gmail
    // ─────────────────────────────────────────────────────

    private static Session crearSesion() {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");

        return Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(REMITENTE, APP_PASSWORD);
            }
        });
    }

    /**
     * Envía un correo HTML.
     *
     * @param destinatario Email del receptor
     * @param asunto Asunto del correo
     * @param cuerpoHtml Contenido HTML del correo
     */
    public static void enviar(String destinatario, String asunto, String cuerpoHtml) {
        if (destinatario == null || destinatario.trim().isEmpty()) {
            System.err.println("EmailService: destinatario vacío, se omite envío.");
            return;
        }
        try {
            Session session = crearSesion();
            MimeMessage mensaje = new MimeMessage(session);
            mensaje.setFrom(new InternetAddress(REMITENTE, "Biblioteca SENA"));
            mensaje.setRecipient(Message.RecipientType.TO, new InternetAddress(destinatario));
            mensaje.setSubject(asunto, "UTF-8");
            mensaje.setContent(cuerpoHtml, "text/html; charset=UTF-8");
            Transport.send(mensaje);
            System.out.println("Email enviado a: " + destinatario + " | Asunto: " + asunto);
        } catch (Exception e) {
            System.err.println("EmailService ERROR al enviar a " + destinatario + ": " + e.getMessage());
        }
    }

    // ── Plantillas de correo ──────────────────────────────
    /**
     * Confirmación de reserva creada exitosamente.
     */
    public static void enviarConfirmacionReserva(String email, String nombre, String tituloLibro, int idReserva) {
        String asunto = "✅ Reserva #" + idReserva + " confirmada – Biblioteca SENA";
        String cuerpo = plantillaBase(
                "¡Reserva confirmada!",
                "Hola <strong>" + nombre + "</strong>,<br><br>"
                + "Tu reserva para el libro <strong>\"" + tituloLibro + "\"</strong> ha sido registrada exitosamente.<br><br>"
                + "<table style='border-collapse:collapse;'>"
                + "  <tr><td style='padding:4px 12px 4px 0;color:#555;'>N° de reserva:</td><td><strong>#" + idReserva + "</strong></td></tr>"
                + "  <tr><td style='padding:4px 12px 4px 0;color:#555;'>Estado:</td><td><strong style='color:#1a7f37;'>Pendiente</strong></td></tr>"
                + "</table><br>"
                + "Cuando el libro esté disponible, recibirás otro correo para retirarlo.",
                "Ver mis reservas",
                "#"
        );
        enviar(email, asunto, cuerpo);
    }

    /**
     * Notifica al usuario que el libro ya está disponible para retirar.
     */
    public static void enviarLibroDisponible(String email, String nombre, String tituloLibro) {
        String asunto = "📚 ¡Tu libro ya está disponible! – Biblioteca SENA";
        String cuerpo = plantillaBase(
                "¡Tu libro está listo!",
                "Hola <strong>" + nombre + "</strong>,<br><br>"
                + "El libro <strong>\"" + tituloLibro + "\"</strong> que reservaste está ahora disponible.<br><br>"
                + "Tienes <strong>48 horas</strong> para retirarlo en la biblioteca antes de que la reserva sea cancelada.",
                "Ver mis reservas",
                "#"
        );
        enviar(email, asunto, cuerpo);
    }

    /**
     * Recordatorio de devolución (se envía el día anterior al vencimiento).
     */
    public static void enviarRecordatorioDevo(String email, String nombre, String tituloLibro, String fechaDevolucion) {
        String asunto = "⏰ Recuerda devolver tu libro mañana – Biblioteca SENA";
        String cuerpo = plantillaBase(
                "Recordatorio de devolución",
                "Hola <strong>" + nombre + "</strong>,<br><br>"
                + "Este es un recordatorio amistoso: el préstamo del libro "
                + "<strong>\"" + tituloLibro + "\"</strong> vence <strong>mañana " + fechaDevolucion + "</strong>.<br><br>"
                + "Por favor, devuélvelo a tiempo para evitar multas.",
                "Ver mis préstamos",
                "#"
        );
        enviar(email, asunto, cuerpo);
    }

    /**
     * Notificación cuando se registra una multa.
     */
    public static void enviarNotificacionMulta(String email, String nombre, String tituloLibro, double valorMulta) {
        String asunto = "⚠️ Se ha generado una multa – Biblioteca SENA";
        String cuerpo = plantillaBase(
                "Multa generada",
                "Hola <strong>" + nombre + "</strong>,<br><br>"
                + "Se ha generado una multa por la devolución tardía del libro "
                + "<strong>\"" + tituloLibro + "\"</strong>.<br><br>"
                + "<table style='border-collapse:collapse;'>"
                + "  <tr><td style='padding:4px 12px 4px 0;color:#555;'>Valor de la multa:</td>"
                + "  <td><strong style='color:#d73a4a;'>$" + String.format("%.0f", valorMulta) + " COP</strong></td></tr>"
                + "</table><br>"
                + "Acércate a la biblioteca para regularizar tu situación.",
                "Ver mis multas",
                "#"
        );
        enviar(email, asunto, cuerpo);
    }

    // ── Plantilla HTML base ───────────────────────────────
    private static String plantillaBase(String titulo, String contenido, String btnTexto, String btnUrl) {
        return "<!DOCTYPE html><html><head><meta charset='UTF-8'></head><body "
                + "style='margin:0;padding:0;background:#f4f4f4;font-family:Arial,sans-serif;'>"
                + "<table width='100%' cellpadding='0' cellspacing='0'><tr><td align='center' style='padding:30px 0;'>"
                + "<table width='580' cellpadding='0' cellspacing='0' style='background:#fff;border-radius:8px;"
                + "overflow:hidden;box-shadow:0 2px 8px rgba(0,0,0,.08);'>"
                + // Header
                "<tr><td style='background:#1a3e5c;padding:24px 32px;'>"
                + "<h1 style='margin:0;color:#fff;font-size:20px;'>📚 Biblioteca SENA</h1></td></tr>"
                + // Titulo
                "<tr><td style='padding:28px 32px 0;'>"
                + "<h2 style='margin:0 0 16px;color:#1a3e5c;font-size:18px;'>" + titulo + "</h2>"
                + // Contenido
                "<p style='margin:0;color:#333;font-size:14px;line-height:1.7;'>" + contenido + "</p></td></tr>"
                + // Botón
                "<tr><td style='padding:24px 32px;'>"
                + "<a href='" + btnUrl + "' style='display:inline-block;background:#1a3e5c;color:#fff;"
                + "padding:10px 24px;border-radius:4px;text-decoration:none;font-size:14px;'>" + btnTexto + "</a></td></tr>"
                + // Footer
                "<tr><td style='background:#f0f4f8;padding:14px 32px;border-top:1px solid #e0e0e0;'>"
                + "<p style='margin:0;color:#888;font-size:12px;'>Biblioteca SENA &bull; Este correo es automático.</p>"
                + "</td></tr>"
                + "</table></td></tr></table></body></html>";
    }
}

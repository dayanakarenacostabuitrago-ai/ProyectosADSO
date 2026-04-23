package co.sena.cimm.adso.registraduria.service;

import co.sena.cimm.adso.registraduria.model.Ciudadano;

import com.itextpdf.kernel.colors.ColorConstants;
import com.itextpdf.kernel.colors.DeviceRgb;
import com.itextpdf.kernel.pdf.EncryptionConstants;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.kernel.pdf.WriterProperties;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.Cell;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.properties.TextAlignment;
import com.itextpdf.layout.properties.UnitValue;
import com.itextpdf.layout.borders.SolidBorder;

import jakarta.activation.DataHandler;
import jakarta.mail.*;
import jakarta.mail.internet.*;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Properties;

/**
 * Servicio compartido para generación de PDF y envío de correo.
 * Utilizado por ConsultaMesaServlet y ExportarPDFServlet.
 *
 * ─── CONFIGURACIÓN SMTP ───────────────────────────────────────────────────
 * Cambia las cuatro constantes de abajo con los datos reales de tu cuenta:
 * SMTP_USER → tu correo Gmail (ej: registraduria.nobsa@gmail.com)
 * SMTP_PASSWORD → App Password de Gmail (16 caracteres, sin espacios)
 * Ve a: myaccount.google.com → Seguridad → Contraseñas de aplicación
 * SMTP_FROM → nombre y correo que verá el destinatario
 * ──────────────────────────────────────────────────────────────────────────
 */
public class PDFCorreoService {

        // ── CONFIGURACIÓN SMTP ── (MODIFICA ESTOS VALORES) ──────────────────────
        private static final String SMTP_HOST = "smtp.gmail.com";
        private static final String SMTP_PORT = "587";
        private static final String SMTP_USER = "dayanakarenacostabuitrago@gmail.com"; // ← CAMBIAR
        private static final String SMTP_PASSWORD = "ngvz vqno kjis zinc"; // ← CAMBIAR (App Password)
        private static final String SMTP_FROM = "Registraduria Nobsa <dayanakarenacostabuitrago@gmail.com>"; // ←
                                                                                                             // CAMBIAR
        // ────────────────────────────────────────────────────────────────────────

        /**
         * Genera el PDF protegido con el número de documento como contraseña.
         */
        public static byte[] generarPDFBytes(Ciudadano c) throws Exception {
                String password = c.getNumeroDocumento();

                ByteArrayOutputStream baos = new ByteArrayOutputStream();

                WriterProperties writerProps = new WriterProperties()
                                .setStandardEncryption(
                                                password.getBytes("UTF-8"),
                                                "RegistraduriaNobsa2026".getBytes("UTF-8"),
                                                EncryptionConstants.ALLOW_PRINTING,
                                                EncryptionConstants.ENCRYPTION_AES_256);

                PdfWriter writer = new PdfWriter(baos, writerProps);
                PdfDocument pdfDoc = new PdfDocument(writer);
                Document doc = new Document(pdfDoc);

                DeviceRgb azul = new DeviceRgb(26, 46, 74);
                DeviceRgb oro = new DeviceRgb(200, 168, 75);

                doc.add(new Paragraph("REGISTRADURIA MUNICIPAL DE NOBSA")
                                .setFontSize(16).setBold().setFontColor(azul)
                                .setTextAlignment(TextAlignment.CENTER).setMarginBottom(2));

                doc.add(new Paragraph("Comprobante de Asignación de Mesa de Votación")
                                .setFontSize(12).setFontColor(azul)
                                .setTextAlignment(TextAlignment.CENTER).setMarginBottom(4));

                doc.add(new Paragraph("_".repeat(72))
                                .setFontSize(8).setFontColor(oro)
                                .setTextAlignment(TextAlignment.CENTER).setMarginBottom(16));

                float[] colWidths = { 2, 3 };
                Table table = new Table(UnitValue.createPercentArray(colWidths))
                                .setWidth(UnitValue.createPercentValue(100)).setMarginBottom(16);

                addRow(table, "Nombres", c.getNombres(), azul, oro);
                addRow(table, "Apellidos", c.getApellidos(), azul, oro);
                addRow(table, "Número de Documento", c.getNumeroDocumento(), azul, oro);
                addRow(table, "Ciudad", c.getCiudadNombre(), azul, oro);
                addRow(table, "Código DANE", c.getCodigoDane(), azul, oro);
                addRow(table, "Zona de Votación", c.getNombreZona(), azul, oro);
                addRow(table, "Puesto de Votación", c.getPuestoVotacion(), azul, oro);
                addRow(table, "Dirección del Puesto", c.getDireccionZona(), azul, oro);
                addRow(table, "Mesa Asignada", "Mesa " + c.getNumeroMesa(), azul, oro);
                addRow(table, "Capacidad de Mesa",
                                (c.getCapacidadMesa() != null ? c.getCapacidadMesa() + " votantes" : "N/A"), azul, oro);
                doc.add(table);

                String fechaActual = new SimpleDateFormat("dd/MM/yyyy HH:mm").format(new Date());

                doc.add(new Paragraph(
                                "Este comprobante es generado automaticamente. Presentar en el puesto de votacion.\n"
                                                + "Fecha de consulta: " + fechaActual)
                                .setFontSize(9).setTextAlignment(TextAlignment.CENTER)
                                .setFontColor(ColorConstants.GRAY).setMarginTop(4));

                doc.close();
                return baos.toByteArray();
        }

        private static void addRow(Table table, String label, String value,
                        DeviceRgb azul, DeviceRgb oro) {
                Cell labelCell = new Cell()
                                .add(new Paragraph(label).setBold().setFontSize(11))
                                .setBackgroundColor(azul).setFontColor(ColorConstants.WHITE)
                                .setPadding(8).setBorder(new SolidBorder(oro, 0.5f));

                String val = (value != null && !value.isBlank()) ? value : "No registrado";
                Cell valueCell = new Cell()
                                .add(new Paragraph(val).setFontSize(11))
                                .setPadding(8).setBorder(new SolidBorder(new DeviceRgb(225, 230, 238), 0.5f));

                table.addCell(labelCell);
                table.addCell(valueCell);
        }

        /**
         * Envía el PDF por correo al destinatario indicado.
         */
        public static void enviarCorreoConPDF(String destinatario, Ciudadano c, byte[] pdfBytes)
                        throws Exception {

                Properties props = new Properties();
                props.put("mail.smtp.auth", "true");
                props.put("mail.smtp.starttls.enable", "true");
                props.put("mail.smtp.host", SMTP_HOST);
                props.put("mail.smtp.port", SMTP_PORT);
                props.put("mail.smtp.ssl.trust", SMTP_HOST);

                Session session = Session.getInstance(props, new Authenticator() {
                        @Override
                        protected PasswordAuthentication getPasswordAuthentication() {
                                return new PasswordAuthentication(SMTP_USER, SMTP_PASSWORD);
                        }
                });

                MimeMessage message = new MimeMessage(session);
                message.setFrom(new InternetAddress(SMTP_FROM));
                message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(destinatario));
                message.setSubject("Comprobante de Mesa de Votacion - Registraduria Municipal de Nobsa");

                // Solo el PDF adjunto, sin cuerpo HTML
                MimeMultipart multipart = new MimeMultipart();

                /* ===== MENSAJE HTML ===== */
                MimeBodyPart htmlPart = new MimeBodyPart();

                String html = """
                                <html>
                                <body style="font-family: Arial, sans-serif; background:#f4f6f8; padding:20px;">
                                  <div style="max-width:600px; margin:auto; background:white; border-radius:12px; padding:30px; box-shadow:0 10px 30px rgba(0,0,0,0.1);">

                                    <h2 style="color:#1a2e4a; text-align:center;">Registraduría Municipal de Nobsa</h2>

                                    <p style="font-size:14px; color:#333;">
                                       Hola <b>"""
                                + c.getNombres()
                                + """
                                                       </b>,
                                                    </p>

                                                    <p style="font-size:14px; color:#333;">
                                                      Tu comprobante de asignación de mesa de votación ha sido generado exitosamente.
                                                    </p>

                                                    <div style="background:#f9fafb; border-left:4px solid #d4af37; padding:15px; margin:20px 0;">
                                                      <p style="margin:0; font-size:14px;">
                                                        🔐 <b>Contraseña del PDF:</b> Tu número de documento
                                                      </p>
                                                    </div>

                                                    <p style="font-size:14px; color:#333;">
                                                      Por favor descarga el archivo adjunto y preséntalo el día de la votación.
                                                    </p>

                                                    <p style="font-size:13px; color:#777; margin-top:30px;">
                                                      Este es un mensaje automático. No responder a este correo.
                                                    </p>

                                                  </div>
                                                </body>
                                                </html>
                                                """;

                htmlPart.setContent(html, "text/html; charset=UTF-8");
                multipart.addBodyPart(htmlPart);

                /* ===== PDF ===== */
                MimeBodyPart pdfPart = new MimeBodyPart();
                pdfPart.setDataHandler(new DataHandler(new ByteArrayDataSource(pdfBytes, "application/pdf")));
                pdfPart.setFileName("comprobante_mesa_" + c.getNumeroDocumento() + ".pdf");

                multipart.addBodyPart(pdfPart);

                message.setContent(multipart);
                Transport.send(message);
        }

        // ── Correo: solicitud recibida (al ciudadano) ────────────────────────────
        public static void enviarCorreoSolicitudRecibida(String destinatario,
                        co.sena.cimm.adso.registraduria.model.SolicitudCiudadano s)
                        throws Exception {

                Session session = crearSesionSMTP();
                MimeMessage message = new MimeMessage(session);
                message.setFrom(new InternetAddress(SMTP_FROM));
                message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(destinatario));
                message.setSubject("Solicitud recibida N°" + s.getId() + " — Registraduría de Nobsa");

                String html = "<html><body style=\"font-family:Arial,sans-serif;background:#f4f6f8;padding:20px;\">"
                                + "<div style=\"max-width:600px;margin:auto;background:#fff;border-radius:12px;padding:30px;box-shadow:0 10px 30px rgba(0,0,0,.1);\">"
                                + "<div style=\"text-align:center;margin-bottom:24px;\">"
                                + "<div style=\"display:inline-block;background:#0b2346;padding:14px 22px;border-radius:10px;\">"
                                + "<span style=\"color:#c8a84b;font-size:20px;font-weight:800;letter-spacing:.5px;\">REGISTRADURÍA</span>"
                                + "<div style=\"color:#8fa8c8;font-size:11px;margin-top:2px;\">Municipal de Nobsa</div></div></div>"
                                + "<h2 style=\"color:#0b2346;text-align:center;margin-bottom:6px;\">Solicitud Recibida ✅</h2>"
                                + "<p style=\"color:#555;font-size:14px;text-align:center;margin-bottom:24px;\">Tu solicitud ha sido registrada y está en revisión.</p>"
                                + "<div style=\"background:#f0f4ff;border-left:4px solid #0b2346;border-radius:6px;padding:16px;margin-bottom:20px;\">"
                                + "<p style=\"margin:0 0 6px;font-size:13px;color:#333;\"><b>N° de solicitud:</b> #"
                                + s.getId() + "</p>"
                                + "<p style=\"margin:0 0 6px;font-size:13px;color:#333;\"><b>Ciudadano:</b> "
                                + s.getNombreCompleto() + "</p>"
                                + "<p style=\"margin:0 0 6px;font-size:13px;color:#333;\"><b>Documento:</b> "
                                + s.getNumeroDocumento() + "</p>"
                                + "<p style=\"margin:0 0 6px;font-size:13px;color:#333;\"><b>Tipo:</b> "
                                + s.getTipoSolicitud() + "</p>"
                                + "<p style=\"margin:0;font-size:13px;color:#333;\"><b>Descripción:</b> "
                                + s.getDescripcion() + "</p></div>"
                                + "<div style=\"background:#fffbea;border:1px solid #f0c040;border-radius:8px;padding:14px;margin-bottom:20px;\">"
                                + "<p style=\"margin:0;font-size:13px;color:#7a5c00;\">⏳ Un administrador revisará tu solicitud y recibirás otro correo con la respuesta.</p></div>"
                                + "<p style=\"font-size:12px;color:#aaa;text-align:center;margin-top:24px;\">Este es un mensaje automático. No respondas a este correo.<br>"
                                + "Registraduría Municipal de Nobsa · (608) 770 0000</p></div></body></html>";

                message.setContent(html, "text/html; charset=UTF-8");
                Transport.send(message);
        }

        // ── Correo: respuesta del admin al ciudadano ─────────────────────────────
        public static void enviarCorreoRespuestaSolicitud(String destinatario,
                        co.sena.cimm.adso.registraduria.model.SolicitudCiudadano s)
                        throws Exception {

                boolean aceptada = "ACEPTADA".equals(s.getEstado());
                String colorEstado = aceptada ? "#0f7a3d" : "#b91c1c";
                String iconoEstado = aceptada ? "✅" : "❌";
                String textoEstado = aceptada ? "ACEPTADA" : "RECHAZADA";
                String bgEstado = aceptada ? "#edfaf3" : "#fef2f2";
                String borderEstado = aceptada ? "#0f7a3d" : "#b91c1c";

                Session session = crearSesionSMTP();
                MimeMessage message = new MimeMessage(session);
                message.setFrom(new InternetAddress(SMTP_FROM));
                message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(destinatario));
                message.setSubject(
                                iconoEstado + " Respuesta a tu solicitud N°" + s.getId() + " — Registraduría de Nobsa");

                String html = "<html><body style=\"font-family:Arial,sans-serif;background:#f4f6f8;padding:20px;\">"
                                + "<div style=\"max-width:600px;margin:auto;background:#fff;border-radius:12px;padding:30px;box-shadow:0 10px 30px rgba(0,0,0,.1);\">"
                                + "<div style=\"text-align:center;margin-bottom:24px;\">"
                                + "<div style=\"display:inline-block;background:#0b2346;padding:14px 22px;border-radius:10px;\">"
                                + "<span style=\"color:#c8a84b;font-size:20px;font-weight:800;letter-spacing:.5px;\">REGISTRADURÍA</span>"
                                + "<div style=\"color:#8fa8c8;font-size:11px;margin-top:2px;\">Municipal de Nobsa</div></div></div>"
                                + "<h2 style=\"color:#0b2346;text-align:center;margin-bottom:6px;\">Respuesta a tu Solicitud</h2>"
                                + "<div style=\"background:" + bgEstado + ";border:2px solid " + borderEstado
                                + ";border-radius:10px;padding:18px;text-align:center;margin-bottom:24px;\">"
                                + "<span style=\"font-size:26px;\">" + iconoEstado + "</span>"
                                + "<div style=\"font-size:20px;font-weight:800;color:" + colorEstado
                                + ";margin-top:4px;\">SOLICITUD " + textoEstado + "</div></div>"
                                + "<div style=\"background:#f7f9fc;border-radius:8px;padding:16px;margin-bottom:20px;\">"
                                + "<p style=\"margin:0 0 6px;font-size:13px;color:#333;\"><b>N° de solicitud:</b> #"
                                + s.getId() + "</p>"
                                + "<p style=\"margin:0 0 6px;font-size:13px;color:#333;\"><b>Ciudadano:</b> "
                                + s.getNombreCompleto() + "</p>"
                                + "<p style=\"margin:0 0 6px;font-size:13px;color:#333;\"><b>Tipo:</b> "
                                + s.getTipoSolicitud() + "</p>"
                                + "<p style=\"margin:0;font-size:13px;color:#333;\"><b>Solicitud original:</b> "
                                + s.getDescripcion() + "</p></div>"
                                + "<div style=\"background:#f0f4ff;border-left:4px solid #0b2346;border-radius:6px;padding:16px;margin-bottom:20px;\">"
                                + "<p style=\"margin:0 0 4px;font-size:12px;color:#6b7c93;font-weight:700;letter-spacing:.05em;text-transform:uppercase;\">Respuesta del administrador</p>"
                                + "<p style=\"margin:0;font-size:14px;color:#1a2535;\">"
                                + (s.getRespuestaAdmin() != null && !s.getRespuestaAdmin().isBlank()
                                                ? s.getRespuestaAdmin()
                                                : "Sin comentarios adicionales.")
                                + "</p>"
                                + (s.getAdminRespondio() != null
                                                ? "<p style=\"margin:6px 0 0;font-size:11px;color:#aaa;\">— "
                                                                + s.getAdminRespondio() + "</p>"
                                                : "")
                                + "</div>"
                                + "<p style=\"font-size:12px;color:#aaa;text-align:center;margin-top:24px;\">Este es un mensaje automático. No respondas a este correo.<br>"
                                + "Registraduría Municipal de Nobsa · (608) 770 0000</p></div></body></html>";

                message.setContent(html, "text/html; charset=UTF-8");
                Transport.send(message);
        }

        // ── Helper compartido SMTP ───────────────────────────────────────────────
        private static Session crearSesionSMTP() {
                Properties props = new Properties();
                props.put("mail.smtp.auth", "true");
                props.put("mail.smtp.starttls.enable", "true");
                props.put("mail.smtp.host", SMTP_HOST);
                props.put("mail.smtp.port", SMTP_PORT);
                props.put("mail.smtp.ssl.trust", SMTP_HOST);
                return Session.getInstance(props, new Authenticator() {
                        @Override
                        protected PasswordAuthentication getPasswordAuthentication() {
                                return new PasswordAuthentication(SMTP_USER, SMTP_PASSWORD);
                        }
                });
        }

        // ── Helper: DataSource desde byte[] ──────────────────────────────────────
        private static class ByteArrayDataSource implements jakarta.activation.DataSource {
                private final byte[] data;
                private final String type;

                ByteArrayDataSource(byte[] data, String type) {
                        this.data = data;
                        this.type = type;
                }

                public InputStream getInputStream() throws IOException {
                        return new ByteArrayInputStream(data);
                }

                public OutputStream getOutputStream() throws IOException {
                        throw new IOException("No output");
                }

                public String getContentType() {
                        return type;
                }

                public String getName() {
                        return "pdf";
                }
        }
}

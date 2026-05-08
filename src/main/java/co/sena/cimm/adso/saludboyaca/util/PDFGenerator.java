package co.sena.cimm.adso.saludboyaca.util;

import com.itextpdf.kernel.colors.ColorConstants;
import com.itextpdf.kernel.colors.DeviceRgb;
import com.itextpdf.kernel.geom.PageSize;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.borders.Border;
import com.itextpdf.layout.borders.RoundDotsBorder;
import com.itextpdf.layout.borders.SolidBorder;
import com.itextpdf.layout.element.*;
import com.itextpdf.layout.properties.HorizontalAlignment;
import com.itextpdf.layout.properties.TextAlignment;
import com.itextpdf.layout.properties.UnitValue;

import co.sena.cimm.adso.saludboyaca.dao.EspecialidadDAO;
import co.sena.cimm.adso.saludboyaca.dao.PacienteDAO;
import co.sena.cimm.adso.saludboyaca.dao.UsuarioDAO;
import co.sena.cimm.adso.saludboyaca.dto.Cita;
import co.sena.cimm.adso.saludboyaca.dto.Especialidad;
import co.sena.cimm.adso.saludboyaca.dto.Paciente;
import co.sena.cimm.adso.saludboyaca.dto.Usuario;

import java.io.OutputStream;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

public class PDFGenerator {

    // ── Paleta SaludBoyacá ──────────────────────────────────────
    private static final DeviceRgb VERDE_OSCURO  = new DeviceRgb(45,  90,  71);
    private static final DeviceRgb VERDE_MEDIO   = new DeviceRgb(77, 122, 104);
    private static final DeviceRgb VERDE_CLARO   = new DeviceRgb(106,158,138);
    private static final DeviceRgb VERDE_PALIDO  = new DeviceRgb(232,242,238);
    private static final DeviceRgb VERDE_BORDE   = new DeviceRgb(192,221,210);
    private static final DeviceRgb TEXTO_OSCURO  = new DeviceRgb(26,  46,  38);
    private static final DeviceRgb TEXTO_MEDIO   = new DeviceRgb(74,  98,  88);
    private static final DeviceRgb TEXTO_CLARO   = new DeviceRgb(122,154,142);
    private static final DeviceRgb BLANCO        = new DeviceRgb(255,255,255);
    private static final DeviceRgb GRIS_ROW      = new DeviceRgb(248,252,250);
    private static final DeviceRgb ACENTO_AZUL   = new DeviceRgb(52, 144, 220);
    private static final DeviceRgb ACENTO_NARANJA= new DeviceRgb(230,126, 34);
    private static final DeviceRgb ACENTO_ROJO   = new DeviceRgb(192, 57, 43);

    // ════════════════════════════════════════════════════════════
    // LISTA DE CITAS
    // ════════════════════════════════════════════════════════════
    public static void generarListaCitas(List<Cita> citas, String titulo,
            PacienteDAO pacienteDAO, UsuarioDAO usuarioDAO,
            EspecialidadDAO especialidadDAO, OutputStream out) {
        try {
            PdfWriter writer = new PdfWriter(out);
            PdfDocument pdf  = new PdfDocument(writer);
            Document doc     = new Document(pdf, PageSize.A4.rotate()); // apaisado para más columnas
            doc.setMargins(28, 28, 28, 28);

            // ── Cabecera principal ───────────────────────────────
            Table hdrTbl = new Table(UnitValue.createPercentArray(new float[]{1})).useAllAvailableWidth();
            Cell hdrCell = new Cell()
                    .setBackgroundColor(VERDE_OSCURO)
                    .setBorder(Border.NO_BORDER)
                    .setPadding(0);

            // Franja decorativa superior
            Table topStripe = new Table(UnitValue.createPercentArray(new float[]{3,1,1})).useAllAvailableWidth();
            topStripe.addCell(new Cell().setBackgroundColor(VERDE_OSCURO).setBorder(Border.NO_BORDER).setHeight(4));
            topStripe.addCell(new Cell().setBackgroundColor(VERDE_CLARO).setBorder(Border.NO_BORDER).setHeight(4));
            topStripe.addCell(new Cell().setBackgroundColor(new DeviceRgb(200,230,215)).setBorder(Border.NO_BORDER).setHeight(4));
            hdrCell.add(topStripe);

            // Contenido cabecera
            Table hdrContent = new Table(UnitValue.createPercentArray(new float[]{1,1})).useAllAvailableWidth();
            // Izquierda: nombre sistema
            Cell hdrLeft = new Cell().setBorder(Border.NO_BORDER).setBackgroundColor(VERDE_OSCURO).setPadding(16);
            hdrLeft.add(new Paragraph("SaludBoyacá")
                    .setFontColor(BLANCO).setBold().setFontSize(20).setMarginBottom(2));
            hdrLeft.add(new Paragraph("Sistema de Gestión Médica")
                    .setFontColor(VERDE_CLARO).setFontSize(8).setMarginBottom(0));
            hdrContent.addCell(hdrLeft);
            // Derecha: título del reporte
            Cell hdrRight = new Cell().setBorder(Border.NO_BORDER)
                    .setBackgroundColor(VERDE_MEDIO).setPadding(16)
                    .setTextAlignment(TextAlignment.RIGHT);
            hdrRight.add(new Paragraph(titulo).setFontColor(BLANCO).setBold().setFontSize(13).setMarginBottom(3));
            hdrRight.add(new Paragraph("Generado: " +
                    LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")))
                    .setFontColor(VERDE_PALIDO).setFontSize(7.5f));
            hdrRight.add(new Paragraph("Total registros: " + citas.size())
                    .setFontColor(VERDE_PALIDO).setFontSize(7.5f));
            hdrContent.addCell(hdrRight);
            hdrCell.add(hdrContent);
            hdrTbl.addCell(hdrCell);
            doc.add(hdrTbl);
            doc.add(new Paragraph(" ").setFontSize(4));

            if (citas.isEmpty()) {
                doc.add(new Paragraph("No hay citas para mostrar.")
                        .setFontSize(11).setFontColor(TEXTO_CLARO)
                        .setTextAlignment(TextAlignment.CENTER).setMarginTop(40));
                doc.close();
                return;
            }

            // ── Tabla de datos ───────────────────────────────────
            float[] colWidths = {5, 10, 8, 20, 20, 16, 11};
            Table tabla = new Table(UnitValue.createPercentArray(colWidths)).useAllAvailableWidth().setFontSize(7.5f);

            String[] cabeceras = {"#", "Fecha", "Hora", "Paciente", "Médico", "Especialidad", "Estado"};
            DeviceRgb[] accentColors = {VERDE_OSCURO, VERDE_OSCURO, VERDE_OSCURO, VERDE_OSCURO, VERDE_OSCURO, VERDE_OSCURO, VERDE_OSCURO};

            for (int i = 0; i < cabeceras.length; i++) {
                tabla.addHeaderCell(new Cell()
                        .setBackgroundColor(VERDE_OSCURO)
                        .setBorder(new SolidBorder(VERDE_MEDIO, 0.5f))
                        .setPaddingTop(7).setPaddingBottom(7).setPaddingLeft(6).setPaddingRight(6)
                        .add(new Paragraph(cabeceras[i])
                                .setBold().setFontColor(BLANCO).setFontSize(7)
                                .setTextAlignment(TextAlignment.CENTER)));
            }

            boolean alt = false;
            for (Cita c : citas) {
                String nomPac = "-";
                try {
                    Paciente p = pacienteDAO.buscarPorId(c.getIdPaciente());
                    if (p != null) nomPac = p.getNombres() + " " + p.getApellidos();
                } catch (Exception ignored) {}

                String nomMed = "-";
                try {
                    Usuario m = usuarioDAO.buscarPorId(c.getIdUsuario());
                    if (m != null) nomMed = "Dr. " + m.getNombres() + " " + m.getApellidos();
                } catch (Exception ignored) {}

                String nomEsp = "-";
                try {
                    Especialidad e = especialidadDAO.buscarPorId(c.getIdEspecialidad());
                    if (e != null) nomEsp = e.getNombre();
                } catch (Exception ignored) {}

                DeviceRgb bgRow = alt ? GRIS_ROW : BLANCO;
                alt = !alt;

                // Color de estado
                String estado = c.getEstado() != null ? c.getEstado() : "-";
                DeviceRgb estadoColor = VERDE_MEDIO;
                if ("CANCELADA".equals(estado))   estadoColor = ACENTO_ROJO;
                else if ("CONFIRMADA".equals(estado)) estadoColor = new DeviceRgb(26,102,64);
                else if ("ATENDIDA".equals(estado))   estadoColor = VERDE_OSCURO;

                String[] valores = {
                    String.valueOf(c.getIdCita()),
                    c.getFechaCita() != null ? c.getFechaCita().toString() : "-",
                    c.getHoraCita() != null  ? c.getHoraCita().toString()  : "-",
                    nomPac, nomMed, nomEsp, estado
                };

                for (int i = 0; i < valores.length; i++) {
                    Cell cell = new Cell()
                            .setBackgroundColor(bgRow)
                            .setBorderLeft(Border.NO_BORDER).setBorderRight(Border.NO_BORDER)
                            .setBorderTop(new SolidBorder(VERDE_BORDE, 0.3f))
                            .setBorderBottom(new SolidBorder(VERDE_BORDE, 0.3f))
                            .setPadding(5);
                    Paragraph p = new Paragraph(valores[i]).setFontSize(7.5f);
                    if (i == 6) { // estado con color
                        p.setFontColor(estadoColor).setBold();
                    } else {
                        p.setFontColor(TEXTO_OSCURO);
                    }
                    cell.add(p);
                    tabla.addCell(cell);
                }
            }
            doc.add(tabla);

            // ── Pie de página ────────────────────────────────────
            doc.add(new Paragraph(" ").setFontSize(5));
            Table footer = new Table(UnitValue.createPercentArray(new float[]{1,1})).useAllAvailableWidth();
            footer.addCell(new Cell().setBorder(Border.NO_BORDER)
                    .add(new Paragraph("© 2025 SaludBoyacá — Documento generado automáticamente")
                            .setFontSize(6.5f).setFontColor(TEXTO_CLARO)));
            footer.addCell(new Cell().setBorder(Border.NO_BORDER)
                    .add(new Paragraph("Información confidencial — Uso interno")
                            .setFontSize(6.5f).setFontColor(TEXTO_CLARO)
                            .setTextAlignment(TextAlignment.RIGHT)));
            doc.add(footer);

            doc.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ════════════════════════════════════════════════════════════
    // COMPROBANTE DE CITA
    // ════════════════════════════════════════════════════════════
    public static void generarComprobante(Cita cita, OutputStream out) {
        try {
            PdfWriter writer = new PdfWriter(out);
            PdfDocument pdf  = new PdfDocument(writer);
            Document doc     = new Document(pdf, PageSize.A5);
            doc.setMargins(0, 0, 28, 0);

            // ── Cabecera con gradiente simulado ─────────────────
            Table hdrTbl = new Table(UnitValue.createPercentArray(new float[]{1})).useAllAvailableWidth();
            Cell hdrCell = new Cell().setBackgroundColor(VERDE_OSCURO).setBorder(Border.NO_BORDER).setPadding(0);

            // Franjas de color
            Table stripes = new Table(UnitValue.createPercentArray(new float[]{4,1,1})).useAllAvailableWidth();
            stripes.addCell(new Cell().setBackgroundColor(VERDE_OSCURO).setBorder(Border.NO_BORDER).setHeight(5));
            stripes.addCell(new Cell().setBackgroundColor(VERDE_CLARO).setBorder(Border.NO_BORDER).setHeight(5));
            stripes.addCell(new Cell().setBackgroundColor(VERDE_PALIDO).setBorder(Border.NO_BORDER).setHeight(5));
            hdrCell.add(stripes);

            Cell hdrBody = new Cell().setBackgroundColor(VERDE_OSCURO).setBorder(Border.NO_BORDER)
                    .setPaddingLeft(24).setPaddingRight(24).setPaddingTop(18).setPaddingBottom(18);
            hdrBody.add(new Paragraph("SaludBoyacá").setFontColor(BLANCO).setBold().setFontSize(18).setMarginBottom(2));
            hdrBody.add(new Paragraph("COMPROBANTE DE CITA MÉDICA")
                    .setFontColor(VERDE_PALIDO).setFontSize(9).setBold().setMarginBottom(3));
            hdrBody.add(new Paragraph("Generado: " + LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")))
                    .setFontColor(VERDE_CLARO).setFontSize(7.5f));
            hdrCell.add(hdrBody);
            hdrTbl.addCell(hdrCell);
            doc.add(hdrTbl);

            // ── Cuerpo del comprobante ───────────────────────────
            Table body = new Table(UnitValue.createPercentArray(new float[]{1})).useAllAvailableWidth();
            Cell bodyCell = new Cell().setBorder(Border.NO_BORDER)
                    .setBackgroundColor(BLANCO)
                    .setPaddingLeft(24).setPaddingRight(24).setPaddingTop(20).setPaddingBottom(20);

            // Sección: Datos de la cita
            bodyCell.add(new Paragraph("INFORMACIÓN DE LA CITA")
                    .setFontSize(7).setBold().setFontColor(TEXTO_CLARO)
                    .setCharacterSpacing(1f).setMarginBottom(10));

            agregarFila(bodyCell, "ID de Cita",     "#" + cita.getIdCita());
            agregarFila(bodyCell, "Fecha",           cita.getFechaCita()  != null ? cita.getFechaCita().toString() : "-");
            agregarFila(bodyCell, "Hora",            cita.getHoraCita()   != null ? cita.getHoraCita().toString()  : "-");
            agregarFila(bodyCell, "Estado",          cita.getEstado()     != null ? cita.getEstado()               : "-");

            if (cita.getPacienteNombre() != null && !cita.getPacienteNombre().isEmpty()) {
                bodyCell.add(new Paragraph(" ").setFontSize(6));
                bodyCell.add(new Paragraph("PERSONAS INVOLUCRADAS")
                        .setFontSize(7).setBold().setFontColor(TEXTO_CLARO)
                        .setCharacterSpacing(1f).setMarginBottom(10));
                agregarFila(bodyCell, "Paciente", cita.getPacienteNombre() + " " +
                        (cita.getPacienteApellido() != null ? cita.getPacienteApellido() : ""));
            }
            if (cita.getMedicoNombre() != null && !cita.getMedicoNombre().isEmpty()) {
                agregarFila(bodyCell, "Médico", "Dr. " + cita.getMedicoNombre() + " " +
                        (cita.getMedicoApellido() != null ? cita.getMedicoApellido() : ""));
            }
            if (cita.getEspecialidad() != null && !cita.getEspecialidad().isEmpty()) {
                agregarFila(bodyCell, "Especialidad", cita.getEspecialidad());
            }

            if (cita.getMotivo() != null && !cita.getMotivo().isEmpty()) {
                bodyCell.add(new Paragraph(" ").setFontSize(6));
                bodyCell.add(new Paragraph("MOTIVO DE LA CONSULTA")
                        .setFontSize(7).setBold().setFontColor(TEXTO_CLARO)
                        .setCharacterSpacing(1f).setMarginBottom(8));
                bodyCell.add(new Paragraph(cita.getMotivo())
                        .setFontSize(9).setFontColor(TEXTO_OSCURO)
                        .setBackgroundColor(VERDE_PALIDO)
                        .setBorderLeft(new SolidBorder(VERDE_CLARO, 3))
                        .setPaddingLeft(10).setPaddingTop(6).setPaddingBottom(6).setPaddingRight(8)
                        .setMarginBottom(0));
            }

            // Nota al pie del cuerpo
            bodyCell.add(new Paragraph(" ").setFontSize(8));
            bodyCell.add(new Paragraph("Por favor llegue 15 minutos antes de su cita. Traiga su documento de identidad.")
                    .setFontSize(7.5f).setFontColor(TEXTO_CLARO)
                    .setTextAlignment(TextAlignment.CENTER)
                    .setBorder(new SolidBorder(VERDE_BORDE, 0.5f))
                    .setPadding(8).setMarginBottom(0));

            body.addCell(bodyCell);
            doc.add(body);

            // ── Pie ──────────────────────────────────────────────
            Table pie = new Table(UnitValue.createPercentArray(new float[]{1})).useAllAvailableWidth();
            Cell pieCell = new Cell().setBackgroundColor(VERDE_PALIDO)
                    .setBorder(Border.NO_BORDER)
                    .setPadding(10).setTextAlignment(TextAlignment.CENTER);
            pieCell.add(new Paragraph("© 2025 SaludBoyacá — Este es un documento oficial. Consérvelo.")
                    .setFontSize(6.5f).setFontColor(TEXTO_CLARO));
            pie.addCell(pieCell);
            doc.add(pie);

            doc.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ── Helper fila en comprobante ──────────────────────────────
    private static void agregarFila(Cell container, String etiqueta, String valor) {
        Table row = new Table(UnitValue.createPercentArray(new float[]{32, 68})).useAllAvailableWidth()
                .setMarginBottom(4);
        row.addCell(new Cell()
                .setBackgroundColor(VERDE_PALIDO)
                .setBorder(new SolidBorder(VERDE_BORDE, 0.5f))
                .setPaddingLeft(8).setPaddingRight(6).setPaddingTop(6).setPaddingBottom(6)
                .add(new Paragraph(etiqueta).setBold().setFontSize(7.5f).setFontColor(TEXTO_MEDIO)));
        row.addCell(new Cell()
                .setBackgroundColor(BLANCO)
                .setBorder(new SolidBorder(VERDE_BORDE, 0.5f))
                .setPaddingLeft(8).setPaddingRight(6).setPaddingTop(6).setPaddingBottom(6)
                .add(new Paragraph(valor).setFontSize(8.5f).setFontColor(TEXTO_OSCURO)));
        container.add(row);
    }
}

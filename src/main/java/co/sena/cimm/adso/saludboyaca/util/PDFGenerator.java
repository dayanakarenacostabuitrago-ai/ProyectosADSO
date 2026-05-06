package co.sena.cimm.adso.saludboyaca.util;

import com.itextpdf.kernel.colors.ColorConstants;
import com.itextpdf.kernel.colors.DeviceRgb;
import com.itextpdf.kernel.geom.PageSize;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.borders.SolidBorder;
import com.itextpdf.layout.element.*;
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

        private static final DeviceRgb AZUL_OSCURO = new DeviceRgb(26, 82, 118);
        private static final DeviceRgb AZUL_MEDIO = new DeviceRgb(46, 134, 193);
        private static final DeviceRgb GRIS_FONDO = new DeviceRgb(235, 245, 251);
        private static final DeviceRgb GRIS_TEXTO = new DeviceRgb(127, 140, 141);

        public static void generarListaCitas(List<Cita> citas, String titulo,
                        PacienteDAO pacienteDAO, UsuarioDAO usuarioDAO,
                        EspecialidadDAO especialidadDAO, OutputStream out) {

                try {
                        PdfWriter writer = new PdfWriter(out);
                        PdfDocument pdf = new PdfDocument(writer);
                        Document doc = new Document(pdf, PageSize.A4);
                        doc.setMargins(36, 36, 36, 36);

                        Table header = new Table(UnitValue.createPercentArray(new float[] { 1 }))
                                        .useAllAvailableWidth();
                        Cell headerCell = new Cell().setBackgroundColor(AZUL_OSCURO)
                                        .setBorder(new SolidBorder(AZUL_OSCURO, 0)).setPadding(18);
                        headerCell.add(new Paragraph("SaludBoyaca").setFontColor(ColorConstants.WHITE).setBold()
                                        .setFontSize(18).setMarginBottom(2));
                        headerCell.add(new Paragraph(titulo).setFontColor(new DeviceRgb(174, 214, 241)).setFontSize(10)
                                        .setMarginBottom(0));
                        headerCell.add(new Paragraph("Generado: "
                                        + LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")))
                                        .setFontColor(new DeviceRgb(174, 214, 241)).setFontSize(8));
                        header.addCell(headerCell);
                        doc.add(header);
                        doc.add(new Paragraph(" ").setFontSize(6));

                        doc.add(new Paragraph("Total de citas: " + citas.size()).setFontSize(9).setFontColor(GRIS_TEXTO)
                                        .setMarginBottom(8));

                        if (citas.isEmpty()) {
                                doc.add(new Paragraph("No hay citas para mostrar.").setFontSize(10)
                                                .setFontColor(GRIS_TEXTO)
                                                .setTextAlignment(TextAlignment.CENTER).setMarginTop(40));
                                doc.close();
                                return;
                        }

                        Table tabla = new Table(UnitValue.createPercentArray(new float[] { 6, 12, 9, 22, 22, 17, 12 }))
                                        .useAllAvailableWidth().setFontSize(8);

                        String[] cabeceras = { "#", "Fecha", "Hora", "Paciente", "Medico", "Especialidad", "Estado" };
                        for (String cab : cabeceras) {
                                tabla.addHeaderCell(new Cell().setBackgroundColor(AZUL_MEDIO)
                                                .setBorder(new SolidBorder(AZUL_MEDIO, 0)).setPadding(5)
                                                .add(new Paragraph(cab).setBold().setFontColor(ColorConstants.WHITE)
                                                                .setFontSize(7)));
                        }

                        boolean alt = false;
                        for (Cita c : citas) {
                                String nombrePaciente = "-";
                                try {
                                        Paciente p = pacienteDAO.buscarPorId(c.getIdPaciente());
                                        if (p != null)
                                                nombrePaciente = p.getNombres() + " " + p.getApellidos();
                                } catch (Exception ignored) {
                                }

                                String nombreMedico = "-";
                                try {
                                        Usuario m = usuarioDAO.buscarPorId(c.getIdUsuario());
                                        if (m != null)
                                                nombreMedico = "Dr. " + m.getNombres() + " " + m.getApellidos();
                                } catch (Exception ignored) {
                                }

                                String nombreEsp = "-";
                                try {
                                        Especialidad e = especialidadDAO.buscarPorId(c.getIdEspecialidad());
                                        if (e != null)
                                                nombreEsp = e.getNombre();
                                } catch (Exception ignored) {
                                }

                                DeviceRgb bgRow = alt ? GRIS_FONDO : new DeviceRgb(255, 255, 255);
                                alt = !alt;

                                String[] valores = {
                                                String.valueOf(c.getIdCita()),
                                                c.getFechaCita() != null ? c.getFechaCita().toString() : "-",
                                                c.getHoraCita() != null ? c.getHoraCita().toString() : "-",
                                                nombrePaciente, nombreMedico, nombreEsp,
                                                c.getEstado() != null ? c.getEstado() : "-"
                                };
                                for (String val : valores) {
                                        tabla.addCell(new Cell().setBackgroundColor(bgRow)
                                                        .setBorder(new SolidBorder(new DeviceRgb(220, 230, 240), 0.5f))
                                                        .setPadding(4)
                                                        .add(new Paragraph(val).setFontSize(7)));
                                }
                        }
                        doc.add(tabla);
                        doc.add(new Paragraph(" ").setFontSize(6));
                        doc.add(new Paragraph("-- Sistema SaludBoyaca - Documento generado automaticamente --")
                                        .setFontSize(7).setFontColor(GRIS_TEXTO)
                                        .setTextAlignment(TextAlignment.CENTER));
                        doc.close();
                } catch (Exception e) {
                        e.printStackTrace();
                }
        }

        public static void generarComprobante(Cita cita, OutputStream out) {
                try {
                        PdfWriter writer = new PdfWriter(out);
                        PdfDocument pdf = new PdfDocument(writer);
                        Document doc = new Document(pdf, PageSize.A5);
                        doc.setMargins(36, 36, 36, 36);

                        Table header = new Table(UnitValue.createPercentArray(new float[] { 1 }))
                                        .useAllAvailableWidth();
                        Cell hc = new Cell().setBackgroundColor(AZUL_OSCURO).setBorder(new SolidBorder(AZUL_OSCURO, 0))
                                        .setPadding(14);
                        hc.add(new Paragraph("SaludBoyaca").setFontColor(ColorConstants.WHITE).setBold()
                                        .setFontSize(14));
                        hc.add(new Paragraph("Comprobante de Cita").setFontColor(new DeviceRgb(174, 214, 241))
                                        .setFontSize(9));
                        header.addCell(hc);
                        doc.add(header);
                        doc.add(new Paragraph(" ").setFontSize(6));

                        agregar(doc, "ID de cita", String.valueOf(cita.getIdCita()));
                        agregar(doc, "Fecha", cita.getFechaCita() != null ? cita.getFechaCita().toString() : "-");
                        agregar(doc, "Hora", cita.getHoraCita() != null ? cita.getHoraCita().toString() : "-");
                        agregar(doc, "Estado", cita.getEstado() != null ? cita.getEstado() : "-");
                        agregar(doc, "Motivo", cita.getMotivo() != null ? cita.getMotivo() : "-");
                        doc.close();
                } catch (Exception e) {
                        e.printStackTrace();
                }
        }

        private static void agregar(Document doc, String etiqueta, String valor) {
                Table row = new Table(UnitValue.createPercentArray(new float[] { 35, 65 })).useAllAvailableWidth()
                                .setMarginBottom(2);
                row.addCell(new Cell().setBorder(new SolidBorder(new DeviceRgb(220, 230, 240), 0.5f))
                                .setBackgroundColor(GRIS_FONDO).setPadding(5)
                                .add(new Paragraph(etiqueta).setBold().setFontSize(8).setFontColor(GRIS_TEXTO)));
                row.addCell(new Cell().setBorder(new SolidBorder(new DeviceRgb(220, 230, 240), 0.5f)).setPadding(5)
                                .add(new Paragraph(valor).setFontSize(8)));
                doc.add(row);
        }
}

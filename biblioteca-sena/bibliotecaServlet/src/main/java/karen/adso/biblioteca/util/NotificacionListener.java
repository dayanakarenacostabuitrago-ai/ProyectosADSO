package karen.adso.biblioteca.util;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import karen.adso.biblioteca.dao.ReservaDAO;
import karen.adso.biblioteca.modelo.Prestamo;

@WebListener
public class NotificacionListener implements ServletContextListener {

    private ScheduledExecutorService scheduler;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        scheduler = Executors.newSingleThreadScheduledExecutor();

        scheduler.scheduleAtFixedRate(
            this::enviarRecordatorios,
            30,          // delay inicial (segundos)
            86400,       // período (24 h en segundos)
            TimeUnit.SECONDS
        );

        System.out.println("[NotificacionListener] Job de recordatorios iniciado correctamente.");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (scheduler != null && !scheduler.isShutdown()) {
            scheduler.shutdownNow();
        }
        System.out.println("[NotificacionListener] Job de recordatorios detenido.");
    }

    // ─────────────────────────────────────────────────────
    private void enviarRecordatorios() {
        try {
            ReservaDAO dao = new ReservaDAO();
            List<Prestamo> porVencer = dao.prestamosPorVencer();

            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");

            for (Prestamo p : porVencer) {
                String email = p.getImagen(); // reutilizamos campo imagen para el email (ver ReservaDAO)
                if (email == null || email.isEmpty()) continue;

                String nombre = p.getNombreUsuario() + " " + p.getApellidoUsuario();
                String titulo = p.getTituloLibro();
                Timestamp ts  = p.getFechaDevolucion();
                String fecha  = ts != null ? sdf.format(ts) : "mañana";

                EmailService.enviarRecordatorioDevo(email, nombre, titulo, fecha);
            }

            System.out.println("[NotificacionListener] Recordatorios enviados: " + porVencer.size());
        } catch (Exception e) {
            System.err.println("[NotificacionListener] ERROR en job: " + e.getMessage());
            e.printStackTrace();
        }
    }
}

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, karen.adso.biblioteca.modelo.Multa, karen.adso.biblioteca.modelo.Usuario"%>
<%
    Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");
    String tipoUsuario = (String) session.getAttribute("tipoUsuario");
    if (usuarioSesion == null) {
        response.sendRedirect(request.getContextPath() + "/loginServlet");
        return;
    }
    List<Multa> multas = (List<Multa>) request.getAttribute("multas");
    String mensaje = (String) session.getAttribute("mensaje");
    String tipoMensaje = (String) session.getAttribute("tipoMensaje");
    session.removeAttribute("mensaje");
    session.removeAttribute("tipoMensaje");
    boolean esAdmin = "Administrativo".equals(tipoUsuario) || "Bibliotecario".equals(tipoUsuario);
    double totalPendiente = 0, totalPagado = 0;
    int ctPend = 0, ctPag = 0;
    if (multas != null)
        for (Multa m : multas) {
            if ("Pendiente".equals(m.getEstado())) {
                totalPendiente += m.getMonto();
                ctPend++;
            } else {
                totalPagado += m.getMonto();
                ctPag++;
            }
        }
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Multas — Biblioteca SENA</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700;900&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Estilos.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/panel.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/extras.css">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>
        <style>
            :root{
                --bg:#080E1A;
                --bg2:#0C1424;
                --card:#101C30;
                --hover:#162034;
                --border:rgba(66,165,245,.1);
                --border2:rgba(66,165,245,.22);
                --b1:#0D47A1;
                --b2:#1565C0;
                --b3:#1976D2;
                --b4:#42A5F5;
                --b5:#90CAF9;
                --cyan:#00BCD4;
                --violet:#7C3AED;
                --indigo:#4F46E5;
                --green:#10B981;
                --amber:#F59E0B;
                --red:#EF4444;
                --txt:#EDF5FF;
                --txt2:#5E7A96;
                --txt3:#324558;
                --gB:0 0 35px rgba(66,165,245,.14);
                --gR:0 0 35px rgba(239,68,68,.18);
                --r:16px;
                --r2:10px;
                --r3:7px;
                --s1:0 2px 16px rgba(0,0,0,.4);
                --s2:0 6px 36px rgba(0,0,0,.5);
                --dur:.28s;
                --ease:cubic-bezier(.4,0,.2,1);
            }

            /* ─── SIDEBAR DEL DASHBOARD ─── */
            .sb{
                position:fixed;
                left:0;
                top:0;
                bottom:0;
                width:78px;
                background:var(--bg2);
                border-right:1px solid var(--border);
                display:flex;
                flex-direction:column;
                align-items:center;
                padding:1.4rem 0 1.2rem;
                gap:.18rem;
                z-index:200
            }
            .sb-logo{
                width:42px;
                height:42px;
                border-radius:13px;
                background:linear-gradient(135deg,var(--b2),var(--b4));
                display:flex;
                align-items:center;
                justify-content:center;
                color:#fff;
                font-size:1.1rem;
                margin-bottom:1.6rem;
                box-shadow:var(--gB);
                animation:pop .5s var(--ease) both
            }
            @keyframes pop{
                from{opacity:0;transform:scale(.6)}
                to{opacity:1;transform:scale(1)}
            }
            .ni{
                width:52px;
                height:52px;
                border-radius:13px;
                display:flex;
                flex-direction:column;
                align-items:center;
                justify-content:center;
                gap:3px;
                text-decoration:none;
                color:var(--txt2);
                font-size:.51rem;
                font-weight:700;
                text-transform:uppercase;
                letter-spacing:.04em;
                transition:all var(--dur) var(--ease);
                border:1px solid transparent;
                position:relative;
                cursor:pointer
            }
            .ni i{font-size:.92rem;transition:transform var(--dur) var(--ease)}
            .ni:hover{
                background:rgba(66,165,245,.08);
                color:var(--b5);
                border-color:var(--border)
            }
            .ni:hover i{transform:scale(1.18) translateY(-1px)}
            .ni.act{
                background:linear-gradient(135deg,rgba(21,101,192,.45),rgba(66,165,245,.22));
                color:var(--b4);
                border-color:rgba(66,165,245,.3);
                box-shadow:var(--gB)
            }
            .ni.act::before{
                content:'';
                position:absolute;
                left:-1px;
                top:50%;
                transform:translateY(-50%);
                width:3px;
                height:62%;
                background:var(--b4);
                border-radius:0 3px 3px 0
            }
            .sb-sep{
                width:30px;
                height:1px;
                background:var(--border);
                margin:.55rem 0
            }
            .sb-bot{
                margin-top:auto;
                display:flex;
                flex-direction:column;
                align-items:center;
                gap:.45rem
            }
            .sb-av{
                width:38px;
                height:38px;
                border-radius:50%;
                background:linear-gradient(135deg,var(--b4),var(--violet));
                display:flex;
                align-items:center;
                justify-content:center;
                color:#fff;
                font-weight:700;
                font-size:.88rem;
                border:2px solid rgba(66,165,245,.3);
                cursor:pointer;
                transition:all var(--dur) var(--ease)
            }
            .sb-av:hover{transform:scale(1.08);box-shadow:var(--gB)}

            /* ─── AJUSTE MAIN CONTENT ─── */
            .main-content {
                margin-left: 78px !important;
                min-height: 100vh;
                background: var(--bg);
            }

            /* ─── SELECT PERSONALIZADO (sin flechas nativas) ─── */
            .select-wrapper {
                position: relative;
                display: inline-block;
            }
            .select-wrapper::after {
                content: '\f107';
                font-family: 'Font Awesome 6 Free';
                font-weight: 900;
                position: absolute;
                right: 12px;
                top: 50%;
                transform: translateY(-50%);
                color: var(--b4);
                font-size: 0.8rem;
                pointer-events: none;
            }
            select.form-select {
                background-color: rgba(66,165,245,.07);
                border: 1px solid rgba(66,165,245,.25);
                color: var(--txt);
                appearance: none;
                -webkit-appearance: none;
                -moz-appearance: none;
                background-image: none !important;
                padding-right: 35px;
                font-size: 0.85rem;
            }
            select.form-select:focus {
                background-color: rgba(66,165,245,.12);
                border-color: var(--b4);
                box-shadow: 0 0 0 0.2rem rgba(66,165,245,.15);
                color: var(--txt);
            }
            select.form-select option {
                background-color: var(--bg2);
                color: var(--txt);
            }

            .monto-pend {color:#f87171;font-weight:700;font-size:.95rem;}
            .monto-pag  {color:#4ade80;font-weight:700;font-size:.95rem;}
            .warn-banner {
                display:flex;
                align-items:center;
                gap:1rem;
                padding:1rem 1.4rem;
                background:rgba(248,113,113,.08);
                border:1px solid rgba(248,113,113,.2);
                border-radius:14px;
                margin-bottom:1.8rem;
            }
            .warn-banner i{color:#f87171;font-size:1.2rem;flex-shrink:0;}
            .warn-banner p{margin:0;font-size:.84rem;color:rgba(255,255,255,.55);}
            .warn-banner strong{color:#f87171;}
            .btn-pay{background:rgba(74,222,128,.12);color:#4ade80;}
            .btn-pay:hover{background:rgba(74,222,128,.3);color:#4ade80;}
            .btn-recibo {
                background:rgba(255,213,79,.1);
                border:1px solid rgba(255,213,79,.3) !important;
                color:#FFD54F !important;
            }
            .btn-recibo:hover{background:rgba(255,213,79,.25);}

            @media(max-width:576px){
                .sb{width:58px}
                .main-content{margin-left:58px!important}
                .ni{width:44px;height:44px}
                .ni span{display:none}
            }
            @media print{
                .no-print{display:none!important}
                .sb{display:none!important}
                .main-content{margin-left:0!important}
            }
        </style>
    </head>
    <body class="panel-body" style="background:var(--bg)">

        <!-- ═══ SIDEBAR DEL DASHBOARD ═══════════════════════════════════ -->
        <aside class="sb">
            <div class="sb-logo"><i class="fas fa-book-open"></i></div>
            <a href="${pageContext.request.contextPath}/DashboardServlet" class="ni" title="Inicio"><i class="fas fa-chart-pie"></i><span>Inicio</span></a>
            <a href="${pageContext.request.contextPath}/LibroServlet" class="ni" title="Libros"><i class="fas fa-book"></i><span>Libros</span></a>
            <a href="${pageContext.request.contextPath}/PrestamoServlet" class="ni" title="Préstamos"><i class="fas fa-hand-holding-heart"></i><span>Préstamos</span></a>
            <a href="${pageContext.request.contextPath}/ReservaServlet" class="ni" title="Reservas"><i class="fas fa-calendar-check"></i><span>Reservas</span></a>
            <a href="${pageContext.request.contextPath}/MultaServlet" class="ni act" title="Multas"><i class="fas fa-file-invoice-dollar"></i><span>Multas</span></a>
            <% if (esAdmin) { %><div class="sb-sep"></div>
            <a href="${pageContext.request.contextPath}/UsuarioServlet" class="ni" title="Usuarios"><i class="fas fa-users"></i><span>Usuarios</span></a>
                    <% if ("Administrativo".equals(tipoUsuario)) { %>
            <a href="${pageContext.request.contextPath}/AutorServlet" class="ni" title="Autores"><i class="fas fa-feather-alt"></i><span>Autores</span></a>
            <a href="${pageContext.request.contextPath}/CategoriaServlet" class="ni" title="Categorías"><i class="fas fa-tags"></i><span>Categ.</span></a>
                    <% } %><% }%>
            <div class="sb-bot">
                <div class="ni" onclick="location.href='${pageContext.request.contextPath}/loginServlet?accion=logout'" title="Salir" style="color:rgba(248,113,113,.7)">
                    <i class="fas fa-sign-out-alt"></i><span>Salir</span>
                </div>
                <div class="sb-av" title="<%=usuarioSesion.getNombres()%> <%=usuarioSesion.getApellidos()%>">
                    <%=usuarioSesion.getNombres().charAt(0)%>
                </div>
            </div>
        </aside>

        <!-- CONTENIDO -->
        <main class="main-content">

            <% if (mensaje != null) {%>
            <div class="<%= "success".equals(tipoMensaje) ? "flash-success" : "flash-danger"%>">
                <i class="fas fa-<%= "success".equals(tipoMensaje) ? "check-circle" : "exclamation-circle"%>"></i> <%=mensaje%>
            </div>
            <% }%>

            <div class="page-header">
                <div>
                    <div class="page-title">Control de <span>Multas</span></div>
                    <div class="page-subtitle"><%=esAdmin ? "Gestión de multas · Recibos imprimibles" : "Tus multas pendientes de pago"%></div>
                </div>
                <div class="d-flex gap-2 align-items-center flex-wrap">
                    <div class="export-bar no-print">
                        <button class="btn-export btn-export-pdf" onclick="exportarPDF()"><i class="fas fa-file-pdf"></i> PDF</button>
                        <button class="btn-export btn-export-excel" onclick="exportarExcel()"><i class="fas fa-file-excel"></i> Excel</button>
                        <button class="btn-export btn-export-print" onclick="window.print()"><i class="fas fa-print"></i> Imprimir</button>
                    </div>
                    <% if (esAdmin) { %>
                    <a href="${pageContext.request.contextPath}/MultaServlet?accion=nuevo" class="btn-panel-gold no-print">
                        <i class="fas fa-plus"></i> Nueva Multa
                    </a>
                    <% } %>
                </div>
            </div>

            <% if (ctPend > 0) {%>
            <div class="warn-banner no-print">
                <i class="fas fa-exclamation-triangle"></i>
                <p>Hay <strong><%=ctPend%> multa<%=ctPend > 1 ? "s" : ""%> pendiente<%=ctPend > 1 ? "s" : ""%></strong>
                    por un total de <strong>$<%=String.format("%.2f", totalPendiente)%></strong>.
                    Regulariza los pagos para habilitar nuevos préstamos.</p>
            </div>
            <% }%>

            <!-- Stats -->
            <div class="row g-3 mb-4">
                <div class="col-sm-6 col-lg-3">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:rgba(66,165,245,.15)"><i class="fas fa-list" style="color:var(--b4)"></i></div>
                        <div class="stat-value"><%=multas != null ? multas.size() : 0%></div>
                        <div class="stat-label">Total de Multas</div>
                    </div>
                </div>
                <div class="col-sm-6 col-lg-3">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:rgba(248,113,113,.12)"><i class="fas fa-clock" style="color:#f87171"></i></div>
                        <div class="stat-value" style="color:#f87171"><%=ctPend%></div>
                        <div class="stat-label">Pendientes</div>
                        <div style="font-size:.72rem;margin-top:.4rem;font-weight:700;color:#f87171">$<%=String.format("%.2f", totalPendiente)%></div>
                    </div>
                </div>
                <div class="col-sm-6 col-lg-3">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:rgba(74,222,128,.12)"><i class="fas fa-check-circle" style="color:#4ade80"></i></div>
                        <div class="stat-value" style="color:#4ade80"><%=ctPag%></div>
                        <div class="stat-label">Pagadas</div>
                        <div style="font-size:.72rem;margin-top:.4rem;font-weight:700;color:#4ade80">$<%=String.format("%.2f", totalPagado)%></div>
                    </div>
                </div>
                <div class="col-sm-6 col-lg-3">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:rgba(255,213,79,.1)"><i class="fas fa-coins" style="color:var(--dorado)"></i></div>
                        <div class="stat-value" style="color:var(--dorado)">$<%=String.format("%.2f", totalPendiente + totalPagado)%></div>
                        <div class="stat-label">Total Acumulado</div>
                    </div>
                </div>
            </div>

            <!-- Tabla -->
            <div class="panel-card">
                <div class="d-flex align-items-center justify-content-between mb-3 flex-wrap gap-2 no-print">
                    <h6 class="mb-0" style="color:var(--b4);font-weight:700"><i class="fas fa-file-invoice-dollar me-2"></i>Registro de Multas</h6>
                    <div class="d-flex gap-2 flex-wrap align-items-center">
                        <div class="select-wrapper" style="width:170px">
                            <select id="filtroEst" class="form-select">
                                <option value="">Todos los estados</option>
                                <option value="pendiente">Pendiente</option>
                                <option value="pagado">Pagado</option>
                            </select>
                        </div>
                        <div class="search-box" style="width:240px">
                            <i class="fas fa-search"></i>
                            <input type="text" id="buscar" placeholder="Buscar multa...">
                        </div>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table-panel" id="tablaMultas">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Préstamo ID</th>
                                <th>Monto</th>
                                <th>F. Generación</th>
                                <th>F. Pago</th>
                                <th>Estado</th>
                                <th class="no-print">Recibo</th>
                                <th style="text-align:center" class="no-print">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (multas != null && !multas.isEmpty()) {
                                    for (Multa m : multas) {%>
                            <tr>
                                <td><span style="color:rgba(255,255,255,.35);font-size:.8rem"><%=m.getIdMulta()%></span></td>
                                <td>
                                    <span style="background:rgba(66,165,245,.12);color:var(--b4);border-radius:6px;padding:.2em .7em;font-size:.82rem;font-weight:700">
                                        #<%=m.getIdPrestamo()%>
                                    </span>
                                </td>
                                <td>
                                    <span class="<%= "Pendiente".equals(m.getEstado()) ? "monto-pend" : "monto-pag"%>">
                                        <i class="fas fa-dollar-sign me-1" style="font-size:.8rem"></i><%=String.format("%.2f", m.getMonto())%>
                                    </span>
                                </td>
                                <td style="color:rgba(255,255,255,.6);font-size:.83rem">
                                    <i class="fas fa-calendar me-1" style="color:#f87171;font-size:.75rem"></i>
                                    <%=m.getFechaGeneracion() != null ? m.getFechaGeneracion().toString().substring(0, 10) : "—"%>
                                </td>
                                <td style="color:rgba(255,255,255,.6);font-size:.83rem">
                                    <%=m.getFechaPago() != null
                                            ? "<i class='fas fa-check me-1' style='color:#4ade80;font-size:.75rem'></i>" + m.getFechaPago().toString().substring(0, 10)
                                            : "<span style='color:rgba(255,255,255,.25)'>Sin pago</span>"%>
                                </td>
                                <td>
                                    <span class="<%= "Pendiente".equals(m.getEstado()) ? "badge-pendiente" : "badge-pagada"%>">
                                        <%=m.getEstado()%>
                                    </span>
                                </td>
                                <td style="text-align:center" class="no-print">
                                    <a href="${pageContext.request.contextPath}/recibo?idMulta=<%=m.getIdMulta()%>"
                                       target="_blank"
                                       class="btn-sm-action btn-recibo"
                                       title="Ver recibo de esta multa">
                                        <i class="fas fa-receipt"></i>
                                    </a>
                                </td>
                                <td style="text-align:center" class="no-print">
                                    <div class="d-flex gap-1 justify-content-center">
                                        <% if ("Pendiente".equals(m.getEstado())) {%>
                                        <a href="${pageContext.request.contextPath}/MultaServlet?accion=pagar&id=<%=m.getIdMulta()%>"
                                           class="btn-sm-action btn-pay" title="Registrar Pago">
                                            <i class="fas fa-money-bill-wave"></i>
                                        </a>
                                        <% } %>
                                        <% if (esAdmin) {%>
                                        <a href="${pageContext.request.contextPath}/MultaServlet?accion=editar&id=<%=m.getIdMulta()%>"
                                           class="btn-sm-action btn-edit" title="Editar multa">
                                            <i class="fas fa-pen"></i>
                                        </a>
                                        <% } %>
                                        <% if ("Administrativo".equals(tipoUsuario)) {%>
                                        <a href="${pageContext.request.contextPath}/MultaServlet?accion=eliminar&id=<%=m.getIdMulta()%>"
                                           class="btn-sm-action btn-delete" title="Eliminar"
                                           onclick="return confirm('¿Eliminar multa #<%=m.getIdMulta()%>?')">
                                            <i class="fas fa-trash"></i>
                                        </a>
                                        <% } %>
                                    </div>
                                </td>
                            </tr>
                            <% }
                            } else { %>
                            <tr><td colspan="7">
                                    <div class="empty-state">
                                        <i class="fas fa-check-double"></i>
                                        <p>¡Sin multas registradas! Todo al día.</p>
                                    </div>
                                </td></tr>
                                <% }%>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.8.2/jspdf.plugin.autotable.min.js"></script>
        <script>
            function filtrar() {
                const txt = document.getElementById('buscar').value.toLowerCase();
                const est = document.getElementById('filtroEst').value.toLowerCase();
                document.querySelectorAll('#tablaMultas tbody tr').forEach(r => {
                    const t = r.textContent.toLowerCase();
                    r.style.display = t.includes(txt) && (est === '' || t.includes(est)) ? '' : 'none';
                });
            }
            document.getElementById('buscar').addEventListener('input', filtrar);
            document.getElementById('filtroEst').addEventListener('change', filtrar);

            function exportarPDF() {
                const {jsPDF} = window.jspdf;
                const doc = new jsPDF({orientation: 'landscape'});
                doc.setFontSize(16);
                doc.setTextColor(13, 40, 85);
                doc.text('Control de Multas — Biblioteca SENA', 14, 18);
                doc.setFontSize(9);
                doc.setTextColor(120, 120, 120);
                doc.text('Generado: ' + new Date().toLocaleString('es-CO'), 14, 24);
                const filas = [];
                document.querySelectorAll('#tablaMultas tbody tr').forEach(r => {
                    if (r.style.display === 'none') return;
                    const c = r.querySelectorAll('td');
                    if (c.length < 6) return;
                    filas.push([c[0].textContent.trim(), c[1].textContent.trim(),
                        c[2].textContent.trim(), c[3].textContent.trim(),
                        c[4].textContent.trim(), c[5].textContent.trim()]);
                });
                doc.autoTable({startY: 28, head: [['#', 'Préstamo', 'Monto', 'F. Generación', 'F. Pago', 'Estado']],
                    body: filas, styles: {fontSize: 9, cellPadding: 3},
                    headStyles: {fillColor: [21, 101, 192], textColor: 255, fontStyle: 'bold'},
                    alternateRowStyles: {fillColor: [245, 248, 255]}});
                doc.save('multas_biblioteca.pdf');
            }

            function exportarExcel() {
                const filas = [['ID', 'Préstamo ID', 'Monto', 'F. Generación', 'F. Pago', 'Estado']];
                document.querySelectorAll('#tablaMultas tbody tr').forEach(r => {
                    if (r.style.display === 'none') return;
                    const c = r.querySelectorAll('td');
                    if (c.length < 6) return;
                    filas.push([c[0].textContent.trim(), c[1].textContent.trim(),
                        c[2].textContent.trim(), c[3].textContent.trim(),
                        c[4].textContent.trim(), c[5].textContent.trim()]);
                });
                const wb = XLSX.utils.book_new();
                const ws = XLSX.utils.aoa_to_sheet(filas);
                ws['!cols'] = [{wch: 6}, {wch: 12}, {wch: 12}, {wch: 15}, {wch: 15}, {wch: 12}];
                XLSX.utils.book_append_sheet(wb, ws, 'Multas');
                XLSX.writeFile(wb, 'multas_biblioteca.xlsx');
            }

            (function () {
                if (localStorage.getItem('modoClaro') === '1') {
                    document.body.classList.add('light-mode');
                    var ico = document.getElementById('icoModo');
                    if (ico) ico.className = 'fas fa-moon';
                }
            })();
            function toggleModo() {
                var isLight = document.body.classList.toggle('light-mode');
                document.getElementById('icoModo').className = isLight ? 'fas fa-moon' : 'fas fa-sun';
                localStorage.setItem('modoClaro', isLight ? '1' : '0');
            }
        </script>
        <%@ include file="/WEB-INF/vistas/Chatbot.jsp" %>
        <button class="btn-modo" id="btnModo" title="Cambiar tema" onclick="toggleModo()">
            <i class="fas fa-sun" id="icoModo"></i>
        </button>
    </body>
</html>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, karen.adso.biblioteca.modelo.Editorial, karen.adso.biblioteca.modelo.Usuario"%>
<%
    Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");
    String tipoUsuario = (String) session.getAttribute("tipoUsuario");
    if (usuarioSesion == null) {
        response.sendRedirect(request.getContextPath() + "/loginServlet");
        return;
    }
    List<Editorial> editoriales = (List<Editorial>) request.getAttribute("editoriales");
    String mensaje = (String) session.getAttribute("mensaje");
    String tipoMensaje = (String) session.getAttribute("tipoMensaje");
    session.removeAttribute("mensaje");
    session.removeAttribute("tipoMensaje");
    boolean esAdmin = "Administrativo".equals(tipoUsuario) || "Bibliotecario".equals(tipoUsuario);
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Editoriales — Biblioteca SENA</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700;900&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Estilos.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/panel.css">
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
            <a href="${pageContext.request.contextPath}/MultaServlet" class="ni" title="Multas"><i class="fas fa-file-invoice-dollar"></i><span>Multas</span></a>
            <% if (esAdmin) { %><div class="sb-sep"></div>
            <a href="${pageContext.request.contextPath}/UsuarioServlet" class="ni" title="Usuarios"><i class="fas fa-users"></i><span>Usuarios</span></a>
                    <% if ("Administrativo".equals(tipoUsuario)) { %>
            <a href="${pageContext.request.contextPath}/AutorServlet" class="ni" title="Autores"><i class="fas fa-feather-alt"></i><span>Autores</span></a>
            <a href="${pageContext.request.contextPath}/CategoriaServlet" class="ni" title="Categorías"><i class="fas fa-tags"></i><span>Categ.</span></a>
            <a href="${pageContext.request.contextPath}/EditorialServlet" class="ni act" title="Editoriales"><i class="fas fa-building"></i><span>Edit.</span></a>
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

        <main class="main-content">

            <% if (mensaje != null) {%>
            <div class="<%= "success".equals(tipoMensaje) ? "flash-success" : "flash-danger"%>">
                <i class="fas fa-<%= "success".equals(tipoMensaje) ? "check-circle" : "exclamation-circle"%>"></i> <%=mensaje%>
            </div>
            <% } %>

            <div class="page-header">
                <div>
                    <div class="page-title"><span>Editoriales</span> Registradas</div>
                    <div class="page-subtitle">Gestión de casas editoriales del catálogo</div>
                </div>
                <div class="d-flex gap-2 align-items-center flex-wrap">
                    <div class="export-bar no-print">
                        <button class="btn-export btn-export-pdf" onclick="exportarPDF()"><i class="fas fa-file-pdf"></i> PDF</button>
                        <button class="btn-export btn-export-excel" onclick="exportarExcel()"><i class="fas fa-file-excel"></i> Excel</button>
                        <button class="btn-export btn-export-print" onclick="window.print()"><i class="fas fa-print"></i> Imprimir</button>
                    </div>
                    <% if (esAdmin) { %>
                    <a href="${pageContext.request.contextPath}/EditorialServlet?accion=nuevo" class="btn-panel-gold no-print">
                        <i class="fas fa-plus"></i> Nueva Editorial
                    </a>
                    <% }%>
                </div>
            </div>

            <div class="row g-3 mb-4">
                <div class="col-sm-4">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:rgba(255,213,79,.12)"><i class="fas fa-building" style="color:var(--dorado)"></i></div>
                        <div class="stat-value" style="color:var(--dorado)"><%=editoriales != null ? editoriales.size() : 0%></div>
                        <div class="stat-label">Total de Editoriales</div>
                    </div>
                </div>
            </div>

            <div class="panel-card">
                <div class="d-flex align-items-center justify-content-between mb-3 flex-wrap gap-2 no-print">
                    <h6 class="mb-0" style="color:var(--b4);font-weight:700"><i class="fas fa-building me-2"></i>Lista de Editoriales</h6>
                    <div class="search-box" style="width:260px">
                        <i class="fas fa-search"></i>
                        <input type="text" id="searchInput" placeholder="Buscar editorial...">
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table-panel" id="tablaEditoriales">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Nombre</th>
                                <th>País</th>
                                <th>Sitio Web</th>
                                <% if (esAdmin) { %><th style="text-align:center" class="no-print">Acciones</th><% } %>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (editoriales != null && !editoriales.isEmpty()) {
                                    for (Editorial e : editoriales) {%>
                            <tr>
                                <td><span style="color:rgba(255,255,255,.35);font-size:.8rem"><%=e.getId()%></span></td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div style="width:34px;height:34px;border-radius:10px;background:linear-gradient(135deg,rgba(255,213,79,.2),rgba(21,101,192,.3));display:flex;align-items:center;justify-content:center;color:var(--dorado);flex-shrink:0">
                                            <i class="fas fa-building" style="font-size:.8rem"></i>
                                        </div>
                                        <span style="font-weight:600"><%=e.getNombre()%></span>
                                    </div>
                                </td>
                                <td style="color:rgba(255,255,255,.6)"><%=e.getPais() != null ? e.getPais() : "—"%></td>
                                <td>
                                    <% if (e.getSitioWeb() != null && !e.getSitioWeb().isEmpty()) {%>
                                    <a href="<%=e.getSitioWeb()%>" target="_blank" style="color:var(--b4);font-size:.85rem">
                                        <i class="fas fa-external-link-alt me-1"></i>Ver sitio
                                    </a>
                                    <% } else { %>
                                    <span style="color:rgba(255,255,255,.3)">—</span>
                                    <% } %>
                                </td>
                                <% if (esAdmin) {%>
                                <td style="text-align:center" class="no-print">
                                    <div class="d-flex gap-2 justify-content-center">
                                        <a href="${pageContext.request.contextPath}/EditorialServlet?accion=editar&id=<%=e.getId()%>"
                                           class="btn-sm-action btn-edit" title="Editar"><i class="fas fa-pen"></i></a>
                                        <a href="${pageContext.request.contextPath}/EditorialServlet?accion=eliminar&id=<%=e.getId()%>"
                                           class="btn-sm-action btn-delete" title="Eliminar"
                                           onclick="return confirm('¿Eliminar la editorial <%=e.getNombre()%>?')">
                                            <i class="fas fa-trash"></i></a>
                                    </div>
                                </td>
                                <% } %>
                            </tr>
                            <% }
                            } else { %>
                            <tr><td colspan="5">
                                    <div class="empty-state">
                                        <i class="fas fa-building"></i>
                                        <p>No hay editoriales registradas.</p>
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
            document.getElementById('searchInput').addEventListener('input', function () {
                const val = this.value.toLowerCase();
                document.querySelectorAll('#tablaEditoriales tbody tr').forEach(r => {
                    r.style.display = r.textContent.toLowerCase().includes(val) ? '' : 'none';
                });
            });

            function exportarPDF() {
                const {jsPDF} = window.jspdf;
                const doc = new jsPDF({orientation: 'landscape'});
                doc.setFontSize(16);
                doc.setTextColor(13, 40, 85);
                doc.text('Editoriales — Biblioteca SENA', 14, 18);
                doc.setFontSize(9);
                doc.setTextColor(120, 120, 120);
                doc.text('Generado: ' + new Date().toLocaleString('es-CO'), 14, 24);
                const filas = [];
                document.querySelectorAll('#tablaEditoriales tbody tr').forEach(r => {
                    if (r.style.display === 'none') return;
                    const c = r.querySelectorAll('td');
                    if (c.length < 4) return;
                    filas.push([c[0].textContent.trim(), c[1].textContent.trim(),
                        c[2].textContent.trim(), c[3].textContent.trim()]);
                });
                doc.autoTable({
                    startY: 28,
                    head: [['#', 'Nombre', 'País', 'Sitio Web']],
                    body: filas,
                    styles: {fontSize: 9, cellPadding: 3},
                    headStyles: {fillColor: [21, 101, 192], textColor: 255, fontStyle: 'bold'},
                    alternateRowStyles: {fillColor: [245, 248, 255]}
                });
                doc.save('editoriales_biblioteca.pdf');
            }

            function exportarExcel() {
                const filas = [['ID', 'Nombre', 'País', 'Sitio Web']];
                document.querySelectorAll('#tablaEditoriales tbody tr').forEach(r => {
                    if (r.style.display === 'none') return;
                    const c = r.querySelectorAll('td');
                    if (c.length < 4) return;
                    filas.push([c[0].textContent.trim(), c[1].textContent.trim(),
                        c[2].textContent.trim(), c[3].textContent.trim()]);
                });
                const wb = XLSX.utils.book_new();
                const ws = XLSX.utils.aoa_to_sheet(filas);
                ws['!cols'] = [{wch: 6}, {wch: 35}, {wch: 18}, {wch: 35}];
                XLSX.utils.book_append_sheet(wb, ws, 'Editoriales');
                XLSX.writeFile(wb, 'editoriales_biblioteca.xlsx');
            }
        </script>
        <%@ include file="/WEB-INF/vistas/Chatbot.jsp" %>
    </body>
</html>
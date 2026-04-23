<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, karen.adso.biblioteca.modelo.Usuario"%>
<%
    Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");
    String tipoUsuario = (String) session.getAttribute("tipoUsuario");
    boolean esAdmin = "Administrativo".equals(tipoUsuario) || "Bibliotecario".equals(tipoUsuario);
    if (usuarioSesion == null) {
        response.sendRedirect(request.getContextPath() + "/loginServlet");
        return;
    }
    if (!"Administrativo".equals(tipoUsuario)) {
        response.sendRedirect(request.getContextPath() + "/LibroServlet");
        return;
    }
    List<Usuario> usuarios = (List<Usuario>) request.getAttribute("usuarios");
    String mensaje = (String) session.getAttribute("mensaje");
    String tipoMensaje = (String) session.getAttribute("tipoMensaje");
    session.removeAttribute("mensaje");
    session.removeAttribute("tipoMensaje");
    int activos = 0, inactivos = 0;
    if (usuarios != null)
        for (Usuario u : usuarios) {
            if ("Activo".equals(u.getEstado())) {
                activos++;
            } else {
                inactivos++;
            }
        }
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Usuarios — Biblioteca SENA</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700;900&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Estilos.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/panel.css">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>
        <style>

            /* ─── SIDEBAR DASHBOARD ─── */
            .sb{
                position:fixed;
                left:0;
                top:0;
                bottom:0;
                width:78px;
                background:#0C1424;
                border-right:1px solid rgba(66,165,245,.1);
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
                background:linear-gradient(135deg,#1565C0,#42A5F5);
                display:flex;
                align-items:center;
                justify-content:center;
                color:#fff;
                font-size:1.1rem;
                margin-bottom:1.6rem;
                box-shadow:0 0 35px rgba(66,165,245,.14)
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
                color:#5E7A96;
                font-size:.51rem;
                font-weight:700;
                text-transform:uppercase;
                letter-spacing:.04em;
                transition:all .28s cubic-bezier(.4,0,.2,1);
                border:1px solid transparent;
                position:relative;
                cursor:pointer
            }
            .ni i{
                font-size:.92rem;
                transition:transform .28s cubic-bezier(.4,0,.2,1)
            }
            .ni:hover{
                background:rgba(66,165,245,.08);
                color:#90CAF9;
                border-color:rgba(66,165,245,.1)
            }
            .ni:hover i{
                transform:scale(1.18) translateY(-1px)
            }
            .ni.act{
                background:linear-gradient(135deg,rgba(21,101,192,.45),rgba(66,165,245,.22));
                color:#42A5F5;
                border-color:rgba(66,165,245,.3);
                box-shadow:0 0 35px rgba(66,165,245,.14)
            }
            .ni.act::before{
                content:'';
                position:absolute;
                left:-1px;
                top:50%;
                transform:translateY(-50%);
                width:3px;
                height:62%;
                background:#42A5F5;
                border-radius:0 3px 3px 0
            }
            .sb-sep{
                width:30px;
                height:1px;
                background:rgba(66,165,245,.1);
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
                background:linear-gradient(135deg,#42A5F5,#7C3AED);
                display:flex;
                align-items:center;
                justify-content:center;
                color:#fff;
                font-weight:700;
                font-size:.88rem;
                border:2px solid rgba(66,165,245,.3);
                cursor:pointer;
                transition:all .28s cubic-bezier(.4,0,.2,1)
            }
            .sb-av:hover{
                transform:scale(1.08);
                box-shadow:0 0 35px rgba(66,165,245,.14)
            }
            .main-content{
                margin-left:78px!important
            }
            @media print{
                .sb{
                    display:none!important
                }
                .main-content{
                    margin-left:0!important
                }
            }
            .form-select{
                appearance:none !important;
                -webkit-appearance:none !important;
                -moz-appearance:none !important;
                background-image:none !important;
            }

            .form-select:focus{
                box-shadow:none !important;
                outline:none !important;
            }
        </style>
    </head>

    <body class="panel-body">

        <aside class="sb">
            <div class="sb-logo"><i class="fas fa-book-open"></i></div>
            <a href="${pageContext.request.contextPath}/DashboardServlet" class="ni" title="Inicio"><i class="fas fa-chart-pie"></i><span>Inicio</span></a>
            <a href="${pageContext.request.contextPath}/LibroServlet" class="ni" title="Libros"><i class="fas fa-book"></i><span>Libros</span></a>
            <a href="${pageContext.request.contextPath}/PrestamoServlet" class="ni" title="Préstamos"><i class="fas fa-hand-holding-heart"></i><span>Préstamos</span></a>
            <a href="${pageContext.request.contextPath}/ReservaServlet" class="ni" title="Reservas"><i class="fas fa-calendar-check"></i><span>Reservas</span></a>
            <a href="${pageContext.request.contextPath}/MultaServlet" class="ni" title="Multas"><i class="fas fa-file-invoice-dollar"></i><span>Multas</span></a>
            <% if ("Administrativo".equals(tipoUsuario) || "Bibliotecario".equals(tipoUsuario)) { %><div class="sb-sep"></div>
            <a href="${pageContext.request.contextPath}/UsuarioServlet" class="ni act" title="Usuarios"><i class="fas fa-users"></i><span>Usuarios</span></a>
                    <% if ("Administrativo".equals(tipoUsuario)) { %>
            <a href="${pageContext.request.contextPath}/AutorServlet" class="ni" title="Autores"><i class="fas fa-feather-alt"></i><span>Autores</span></a>
            <a href="${pageContext.request.contextPath}/CategoriaServlet" class="ni" title="Categ."><i class="fas fa-tags"></i><span>Categ.</span></a>
            <a href="${pageContext.request.contextPath}/EditorialServlet" class="ni" title="Edit."><i class="fas fa-building"></i><span>Edit.</span></a>
                    <% } %><% }%>
            <div class="sb-bot">
                <div class="ni" onclick="location.href = '${pageContext.request.contextPath}/loginServlet?accion=logout'" title="Salir" style="color:rgba(248,113,113,.7)"><i class="fas fa-sign-out-alt"></i><span>Salir</span></div>
                <div class="sb-av" title="<%=usuarioSesion.getNombres()%> <%=usuarioSesion.getApellidos()%>"><%=usuarioSesion.getNombres().charAt(0)%></div>
            </div>
        </aside>

        <main class="main-content">

            <% if (mensaje != null) {%>
            <div class="<%= "success".equals(tipoMensaje) ? "flash-success" : "flash-danger"%>">
                <i class="fas fa-<%= "success".equals(tipoMensaje) ? "check-circle" : "exclamation-circle"%>"></i> <%=mensaje%>
            </div>
            <% }%>

            <div class="page-header">
                <div>
                    <div class="page-title">Gestión de <span>Usuarios</span></div>
                    <div class="page-subtitle">Administración de cuentas de estudiantes y personal</div>
                </div>
                <div class="d-flex gap-2 align-items-center flex-wrap">
                    <div class="export-bar no-print">
                        <button class="btn-export btn-export-pdf"   onclick="exportarPDF()"><i class="fas fa-file-pdf"></i> PDF</button>
                        <button class="btn-export btn-export-excel" onclick="exportarExcel()"><i class="fas fa-file-excel"></i> Excel</button>
                        <button class="btn-export btn-export-print" onclick="window.print()"><i class="fas fa-print"></i> Imprimir</button>
                    </div>
                    <a href="${pageContext.request.contextPath}/UsuarioServlet?accion=nuevo" class="btn-panel-gold no-print">
                        <i class="fas fa-plus"></i> Nuevo Usuario
                    </a>
                </div>
            </div>

            <div class="row g-3 mb-4">
                <div class="col-sm-4">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:rgba(66,165,245,.15)"><i class="fas fa-users" style="color:var(--azul-claro)"></i></div>
                        <div class="stat-value"><%=usuarios != null ? usuarios.size() : 0%></div>
                        <div class="stat-label">Total Usuarios</div>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:rgba(74,222,128,.12)"><i class="fas fa-user-check" style="color:#4ade80"></i></div>
                        <div class="stat-value" style="color:#4ade80"><%=activos%></div>
                        <div class="stat-label">Activos</div>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="stat-card">
                        <div class="stat-icon" style="background:rgba(248,113,113,.12)"><i class="fas fa-user-times" style="color:#f87171"></i></div>
                        <div class="stat-value" style="color:#f87171"><%=inactivos%></div>
                        <div class="stat-label">Inactivos</div>
                    </div>
                </div>
            </div>

            <div class="panel-card">
                <div class="d-flex align-items-center justify-content-between mb-3 flex-wrap gap-2 no-print">
                    <h6 class="mb-0" style="color:var(--azul-claro);font-weight:700"><i class="fas fa-users me-2"></i>Listado de Usuarios</h6>
                    <div class="d-flex gap-2 align-items-center flex-wrap">
                        <select id="filtroTipo" class="form-select" style="width:160px">
                            <option value="">Todos los roles</option>
                            <option value="administrativo">Administrativo</option>
                            <option value="bibliotecario">Bibliotecario</option>
                            <option value="estudiante">Estudiante</option>
                        </select>
                        <select id="filtroEstado" class="form-select" style="width:140px">
                            <option value="">Todos los estados</option>
                            <option value="activo">Activo</option>
                            <option value="inactivo">Inactivo</option>
                        </select>
                        <div class="search-box" style="width:240px">
                            <i class="fas fa-search"></i>
                            <input type="text" id="searchInput" placeholder="Buscar usuario...">
                        </div>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table-panel" id="tablaUsuarios">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Nombre</th>
                                <th>Documento</th>
                                <th>Email</th>
                                <th>Teléfono</th>
                                <th>Tipo</th>
                                <th>Estado</th>
                                <th style="text-align:center" class="no-print">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (usuarios != null && !usuarios.isEmpty()) {
                                    for (Usuario u : usuarios) {%>
                            <tr>
                                <td><span style="color:rgba(255,255,255,.35);font-size:.8rem"><%=u.getIdUsuario()%></span></td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="user-avatar" style="width:32px;height:32px;font-size:.75rem">
                                            <%=u.getNombres().charAt(0)%>
                                        </div>
                                        <span style="font-weight:600"><%=u.getNombres()%> <%=u.getApellidos()%></span>
                                    </div>
                                </td>
                                <td><code style="color:var(--azul-claro);font-size:.82rem"><%=u.getDocumento()%></code></td>
                                <td style="color:rgba(255,255,255,.65);font-size:.83rem"><%=u.getEmail() != null ? u.getEmail() : "—"%></td>
                                <td style="color:rgba(255,255,255,.65);font-size:.83rem"><%=u.getTelefono() != null ? u.getTelefono() : "—"%></td>
                                <td>
                                    <span style="background:rgba(192,132,252,.12);color:#c084fc;border:1px solid rgba(192,132,252,.22);border-radius:50px;padding:.28em .85em;font-size:.74rem;font-weight:700">
                                        <%=u.getTipoUsuario()%>
                                    </span>
                                </td>
                                <td>
                                    <span class="<%= "Activo".equals(u.getEstado()) ? "badge-disponible" : "badge-no-disponible"%>">
                                        <%=u.getEstado()%>
                                    </span>
                                </td>
                                <td style="text-align:center" class="no-print">
                                    <div class="d-flex gap-2 justify-content-center">
                                        <a href="${pageContext.request.contextPath}/UsuarioServlet?accion=editar&id=<%=u.getIdUsuario()%>"
                                           class="btn-sm-action btn-edit" title="Editar"><i class="fas fa-pen"></i></a>
                                        <a href="${pageContext.request.contextPath}/UsuarioServlet?accion=eliminar&id=<%=u.getIdUsuario()%>"
                                           class="btn-sm-action btn-delete" title="Eliminar"
                                           onclick="return confirm('¿Eliminar al usuario <%=u.getNombres()%>?')">
                                            <i class="fas fa-trash"></i></a>
                                    </div>
                                </td>
                            </tr>
                            <% }
                            } else { %>
                            <tr><td colspan="8">
                                    <div class="empty-state">
                                        <i class="fas fa-users"></i>
                                        <p>No hay usuarios registrados.</p>
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
                                                   const txt = document.getElementById('searchInput').value.toLowerCase();
                                                   const tipo = document.getElementById('filtroTipo').value.toLowerCase();
                                                   const estado = document.getElementById('filtroEstado').value.toLowerCase();
                                                   document.querySelectorAll('#tablaUsuarios tbody tr').forEach(r => {
                                                       const t = r.textContent.toLowerCase();
                                                       r.style.display = t.includes(txt) && (tipo === '' || t.includes(tipo)) && (estado === '' || t.includes(estado)) ? '' : 'none';
                                                   });
                                               }
                                               document.getElementById('searchInput').addEventListener('input', filtrar);
                                               document.getElementById('filtroTipo').addEventListener('change', filtrar);
                                               document.getElementById('filtroEstado').addEventListener('change', filtrar);

                                               function exportarPDF() {
                                                   const {jsPDF} = window.jspdf;
                                                   const doc = new jsPDF({orientation: 'landscape'});
                                                   doc.setFontSize(16);
                                                   doc.setTextColor(13, 40, 85);
                                                   doc.text('Gestión de Usuarios — Biblioteca SENA', 14, 18);
                                                   doc.setFontSize(9);
                                                   doc.setTextColor(120, 120, 120);
                                                   doc.text('Generado: ' + new Date().toLocaleString('es-CO'), 14, 24);
                                                   const filas = [];
                                                   document.querySelectorAll('#tablaUsuarios tbody tr').forEach(r => {
                                                       if (r.style.display === 'none')
                                                           return;
                                                       const c = r.querySelectorAll('td');
                                                       if (c.length < 7)
                                                           return;
                                                       filas.push([c[0].textContent.trim(), c[1].textContent.trim(),
                                                           c[2].textContent.trim(), c[3].textContent.trim(),
                                                           c[4].textContent.trim(), c[5].textContent.trim(),
                                                           c[6].textContent.trim()]);
                                                   });
                                                   doc.autoTable({
                                                       startY: 28,
                                                       head: [['#', 'Nombre', 'Documento', 'Email', 'Teléfono', 'Tipo', 'Estado']],
                                                       body: filas,
                                                       styles: {fontSize: 8, cellPadding: 3},
                                                       headStyles: {fillColor: [21, 101, 192], textColor: 255, fontStyle: 'bold'},
                                                       alternateRowStyles: {fillColor: [245, 248, 255]}
                                                   });
                                                   doc.save('usuarios_biblioteca.pdf');
                                               }

                                               function exportarExcel() {
                                                   const filas = [['ID', 'Nombre', 'Documento', 'Email', 'Teléfono', 'Tipo', 'Estado']];
                                                   document.querySelectorAll('#tablaUsuarios tbody tr').forEach(r => {
                                                       if (r.style.display === 'none')
                                                           return;
                                                       const c = r.querySelectorAll('td');
                                                       if (c.length < 7)
                                                           return;
                                                       filas.push([c[0].textContent.trim(), c[1].textContent.trim(),
                                                           c[2].textContent.trim(), c[3].textContent.trim(),
                                                           c[4].textContent.trim(), c[5].textContent.trim(),
                                                           c[6].textContent.trim()]);
                                                   });
                                                   const wb = XLSX.utils.book_new();
                                                   const ws = XLSX.utils.aoa_to_sheet(filas);
                                                   ws['!cols'] = [{wch: 6}, {wch: 30}, {wch: 15}, {wch: 28}, {wch: 14}, {wch: 16}, {wch: 10}];
                                                   XLSX.utils.book_append_sheet(wb, ws, 'Usuarios');
                                                   XLSX.writeFile(wb, 'usuarios_biblioteca.xlsx');
                                               }
        </script>
        <style>
            @media print {
                .no-print{
                    display:none!important
                }
                .sidebar{
                    display:none!important
                }
                .main-content{
                    margin-left:0!important
                }
            }
        </style>
        <%@ include file="/WEB-INF/vistas/Chatbot.jsp" %>

        <!-- Botón modo claro/oscuro -->
        <button class="btn-modo" id="btnModo" title="Cambiar tema" onclick="toggleModo()">
            <i class="fas fa-sun" id="icoModo"></i>
        </button>
        <script>
            (function () {
                if (localStorage.getItem('modoClaro') === '1') {
                    document.body.classList.add('light-mode');
                    document.getElementById('icoModo').className = 'fas fa-moon';
                }
            })();
            function toggleModo() {
                var isLight = document.body.classList.toggle('light-mode');
                document.getElementById('icoModo').className = isLight ? 'fas fa-moon' : 'fas fa-sun';
                localStorage.setItem('modoClaro', isLight ? '1' : '0');
            }
        </script>

    </body>
</html>

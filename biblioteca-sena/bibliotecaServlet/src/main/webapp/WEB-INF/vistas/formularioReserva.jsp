<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, karen.adso.biblioteca.modelo.Libro, karen.adso.biblioteca.modelo.Usuario, karen.adso.biblioteca.modelo.Reserva"%>
<%
    Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");
    String tipoUsuario = (String) session.getAttribute("tipoUsuario");
    if (usuarioSesion == null) {
        response.sendRedirect(request.getContextPath() + "/loginServlet");
        return;
    }
    boolean esAdmin = "Administrativo".equals(tipoUsuario) || "Bibliotecario".equals(tipoUsuario);
    if (!esAdmin) {
        response.sendRedirect(request.getContextPath() + "/ReservaServlet");
        return;
    }

    List<Libro> libros = (List<Libro>) request.getAttribute("libros");
    List<Usuario> usuarios = (List<Usuario>) request.getAttribute("usuarios");
    List<Reserva> reservas = (List<Reserva>) request.getAttribute("reservas");

    String modo = (String) request.getAttribute("modo");
    if (modo == null) {
        modo = "listar";
    }

    // OBTENER FILTRO DE PARAMETRO (no de atributo)
    String filtro = request.getParameter("filtro");
    if (filtro == null || filtro.isEmpty()) {
        filtro = "todas";
    }

    Reserva reservaEditar = (Reserva) request.getAttribute("reservaEditar");
    if (reservaEditar != null) {
        modo = "editar";
    }

    // Para mostrar QR
    String mostrarQR = request.getParameter("mostrarQR");

    String error = (String) request.getAttribute("error");
    String mensaje = (String) session.getAttribute("mensaje");
    String tipoMensaje = (String) session.getAttribute("tipoMensaje");
    if (mensaje != null) {
        session.removeAttribute("mensaje");
        session.removeAttribute("tipoMensaje");
    }
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Gestión de Reservas — Biblioteca SENA</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Estilos.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/panel.css">
        <style>
            .select-custom {
                -webkit-appearance: none;
                -moz-appearance: none;
                appearance: none;
                background-image: none !important;
                padding-right: 2.5rem !important;
            }
            .select-wrapper {
                position: relative;
            }
            .select-wrapper::after {
                content: '\f078';
                font-family: 'Font Awesome 6 Free';
                font-weight: 900;
                position: absolute;
                right: 1rem;
                top: 50%;
                transform: translateY(-50%);
                color: #42A5F5;
                font-size: 0.8rem;
                pointer-events: none;
            }
            .form-select option {
                background: #0d2855;
                color: #fff;
            }
            .reserva-card {
                background: linear-gradient(145deg, rgba(13,40,85,.8), rgba(10,22,40,.95));
                border: 1px solid rgba(66,165,245,.12);
                border-radius: 16px;
                padding: 1.2rem 1.5rem;
                margin-bottom: 1rem;
            }
            .reserva-id {
                font-family: 'Playfair Display', serif;
                font-size: 1.1rem;
                color: #FFD54F;
                font-weight: 700;
            }
            .reserva-estado {
                display: inline-flex;
                align-items: center;
                gap: .35rem;
                padding: .25em .8em;
                border-radius: 50px;
                font-size: .75rem;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: .5px;
            }
            .estado-pendiente {
                background: rgba(255,193,7,.15);
                color: #FFC107;
                border: 1px solid rgba(255,193,7,.3);
            }
            .estado-lista {
                background: rgba(76,175,80,.15);
                color: #4CAF50;
                border: 1px solid rgba(76,175,80,.3);
            }
            .estado-cancelada {
                background: rgba(244,67,54,.15);
                color: #F44336;
                border: 1px solid rgba(244,67,54,.3);
            }
            .reserva-info {
                color: rgba(248,251,255,.7);
                font-size: .9rem;
            }
            .reserva-info strong {
                color: rgba(248,251,255,.9);
            }
            .reserva-acciones {
                display: flex;
                gap: .5rem;
                margin-top: 1rem;
                padding-top: 1rem;
                border-top: 1px solid rgba(66,165,245,.1);
            }
            .btn-accion {
                display: inline-flex;
                align-items: center;
                gap: .4rem;
                padding: .5rem 1rem;
                border-radius: 8px;
                font-size: .85rem;
                font-weight: 600;
                text-decoration: none;
                transition: all .2s;
                border: none;
                cursor: pointer;
            }
            .btn-editar {
                background: rgba(255,193,7,.15);
                color: #FFC107;
                border: 1px solid rgba(255,193,7,.25);
            }
            .btn-editar:hover {
                background: rgba(255,193,7,.25);
                color: #FFD54F;
            }
            .btn-qr {
                background: rgba(66,165,245,.15);
                color: #42A5F5;
                border: 1px solid rgba(66,165,245,.25);
            }
            .btn-qr:hover {
                background: rgba(66,165,245,.25);
                color: #64B5F6;
            }
            .btn-nueva {
                display: inline-flex;
                align-items: center;
                gap: .6rem;
                padding: .7rem 1.6rem;
                background: linear-gradient(135deg, #e6a500, #FFD54F);
                color: #0A1628;
                border-radius: 50px;
                font-weight: 700;
                font-size: .9rem;
                text-decoration: none;
                transition: all .25s;
                box-shadow: 0 6px 20px rgba(255,213,79,.28);
            }
            .btn-nueva:hover {
                transform: translateY(-2px);
                box-shadow: 0 10px 28px rgba(255,213,79,.4);
                color: #0A1628;
            }
            .empty-state {
                text-align: center;
                padding: 3rem 2rem;
                color: rgba(248,251,255,.5);
            }
            .flash-success {
                background: rgba(76,175,80,.15);
                border: 1px solid rgba(76,175,80,.3);
                color: #4CAF50;
                padding: 1rem 1.2rem;
                border-radius: 12px;
                margin-bottom: 1.5rem;
            }
            .flash-danger {
                background: rgba(244,67,54,.15);
                border: 1px solid rgba(244,67,54,.3);
                color: #F44336;
                padding: 1rem 1.2rem;
                border-radius: 12px;
                margin-bottom: 1.5rem;
            }
            .tabs {
                display: flex;
                gap: .5rem;
                margin-bottom: 1.5rem;
                border-bottom: 1px solid rgba(66,165,245,.15);
                padding-bottom: .5rem;
            }
            .tab {
                padding: .6rem 1.2rem;
                border-radius: 8px;
                color: rgba(248,251,255,.6);
                font-size: .9rem;
                font-weight: 600;
                text-decoration: none;
                transition: all .2s;
            }
            .tab:hover {
                background: rgba(66,165,245,.1);
                color: rgba(248,251,255,.9);
            }
            .tab.active {
                background: linear-gradient(135deg, rgba(21,101,192,.4), rgba(66,165,245,.15));
                color: #FFD54F;
            }

            /* QR expandido */
            .qr-container {
                background: white;
                border-radius: 12px;
                padding: 1.5rem;
                margin-top: 1rem;
                text-align: center;
                min-height: 200px;
            }
            .qr-container img {
                max-width: 180px;
                height: auto;
                border-radius: 8px;
            }
            .qr-error {
                color: #666;
                padding: 2rem;
            }
        </style>
        <style>
            /* ─── SIDEBAR DASHBOARD ─── */
            .sb{position:fixed;left:0;top:0;bottom:0;width:78px;
                background:#0C1424;border-right:1px solid rgba(66,165,245,.1);
                display:flex;flex-direction:column;align-items:center;
                padding:1.4rem 0 1.2rem;gap:.18rem;z-index:200}
            .sb-logo{width:42px;height:42px;border-radius:13px;
                background:linear-gradient(135deg,#1565C0,#42A5F5);
                display:flex;align-items:center;justify-content:center;
                color:#fff;font-size:1.1rem;margin-bottom:1.6rem;
                box-shadow:0 0 35px rgba(66,165,245,.14)}
            .ni{width:52px;height:52px;border-radius:13px;display:flex;
                flex-direction:column;align-items:center;justify-content:center;
                gap:3px;text-decoration:none;color:#5E7A96;font-size:.51rem;
                font-weight:700;text-transform:uppercase;letter-spacing:.04em;
                transition:all .28s cubic-bezier(.4,0,.2,1);
                border:1px solid transparent;position:relative;cursor:pointer}
            .ni i{font-size:.92rem;transition:transform .28s cubic-bezier(.4,0,.2,1)}
            .ni:hover{background:rgba(66,165,245,.08);color:#90CAF9;
                border-color:rgba(66,165,245,.1)}
            .ni:hover i{transform:scale(1.18) translateY(-1px)}
            .ni.act{background:linear-gradient(135deg,rgba(21,101,192,.45),rgba(66,165,245,.22));
                color:#42A5F5;border-color:rgba(66,165,245,.3);
                box-shadow:0 0 35px rgba(66,165,245,.14)}
            .ni.act::before{content:'';position:absolute;left:-1px;top:50%;
                transform:translateY(-50%);width:3px;height:62%;
                background:#42A5F5;border-radius:0 3px 3px 0}
            .sb-sep{width:30px;height:1px;background:rgba(66,165,245,.1);margin:.55rem 0}
            .sb-bot{margin-top:auto;display:flex;flex-direction:column;
                align-items:center;gap:.45rem}
            .sb-av{width:38px;height:38px;border-radius:50%;
                background:linear-gradient(135deg,#42A5F5,#7C3AED);
                display:flex;align-items:center;justify-content:center;
                color:#fff;font-weight:700;font-size:.88rem;
                border:2px solid rgba(66,165,245,.3);cursor:pointer;
                transition:all .28s cubic-bezier(.4,0,.2,1)}
            .sb-av:hover{transform:scale(1.08);box-shadow:0 0 35px rgba(66,165,245,.14)}
            .main-content{margin-left:78px!important}
        </style>
        </head>
    <body class="panel-body">

                <aside class="sb">
            <div class="sb-logo"><i class="fas fa-book-open"></i></div>
            <a href="${pageContext.request.contextPath}/DashboardServlet" class="ni" title="Inicio"><i class="fas fa-chart-pie"></i><span>Inicio</span></a>
            <a href="${pageContext.request.contextPath}/LibroServlet" class="ni" title="Libros"><i class="fas fa-book"></i><span>Libros</span></a>
            <a href="${pageContext.request.contextPath}/PrestamoServlet" class="ni" title="Préstamos"><i class="fas fa-hand-holding-heart"></i><span>Préstamos</span></a>
            <a href="${pageContext.request.contextPath}/ReservaServlet" class="ni act" title="Reservas"><i class="fas fa-calendar-check"></i><span>Reservas</span></a>
            <a href="${pageContext.request.contextPath}/MultaServlet" class="ni" title="Multas"><i class="fas fa-file-invoice-dollar"></i><span>Multas</span></a>
            <% if ("Administrativo".equals(tipoUsuario) || "Bibliotecario".equals(tipoUsuario)) { %><div class="sb-sep"></div>
            <a href="${pageContext.request.contextPath}/UsuarioServlet" class="ni" title="Usuarios"><i class="fas fa-users"></i><span>Usuarios</span></a>
            <% if ("Administrativo".equals(tipoUsuario)) { %>
            <a href="${pageContext.request.contextPath}/AutorServlet" class="ni" title="Autores"><i class="fas fa-feather-alt"></i><span>Autores</span></a>
            <a href="${pageContext.request.contextPath}/CategoriaServlet" class="ni" title="Categ."><i class="fas fa-tags"></i><span>Categ.</span></a>
            <a href="${pageContext.request.contextPath}/EditorialServlet" class="ni" title="Edit."><i class="fas fa-building"></i><span>Edit.</span></a>
            <% } %><% } %>
            <div class="sb-bot">
                <div class="ni" onclick="location.href='${pageContext.request.contextPath}/loginServlet?accion=logout'" title="Salir" style="color:rgba(248,113,113,.7)"><i class="fas fa-sign-out-alt"></i><span>Salir</span></div>
                <div class="sb-av" title="<%=usuarioSesion.getNombres()%> <%=usuarioSesion.getApellidos()%>"><%=usuarioSesion.getNombres().charAt(0)%></div>
            </div>
        </aside>

        <main class="main-content">
            <div class="page-header">
                <div>
                    <div class="page-title">Gestión de <span>Reservas</span></div>
                    <div class="page-subtitle">Administra las reservas de libros</div>
                </div>
                <% if ("listar".equals(modo)) { %>
                <a href="${pageContext.request.contextPath}/ReservaServlet?accion=formulario" class="btn-nueva"><i class="fas fa-plus"></i> Nueva Reserva</a>
                <% } else {%>
                <a href="${pageContext.request.contextPath}/ReservaServlet?accion=listar&filtro=<%=filtro%>" class="btn btn-outline-light btn-sm"><i class="fas fa-arrow-left me-1"></i> Volver al listado</a>
                <% } %>
            </div>

            <% if (mensaje != null) {%>
            <div class="flash-<%=tipoMensaje%>"><i class="fas fa-<%=tipoMensaje.equals("success") ? "check-circle" : "exclamation-circle"%>"></i> <%=mensaje%></div>
            <% } %>
            <% if (error != null) {%>
            <div class="flash-danger"><i class="fas fa-exclamation-circle"></i> <%=error%></div>
            <% } %>

            <%-- MODO LISTAR --%>
            <% if ("listar".equals(modo)) {%>

            <%-- TABS DE FILTRO - AHORA FUNCIONALES --%>
            <div class="tabs">
                <a href="${pageContext.request.contextPath}/ReservaServlet?accion=listar&filtro=todas" class="tab <%= "todas".equals(filtro) ? "active" : ""%>">Todas</a>
                <a href="${pageContext.request.contextPath}/ReservaServlet?accion=listar&filtro=Pendiente" class="tab <%= "Pendiente".equals(filtro) ? "active" : ""%>">Pendientes</a>
                <a href="${pageContext.request.contextPath}/ReservaServlet?accion=listar&filtro=Lista" class="tab <%= "Lista".equals(filtro) ? "active" : ""%>">En lista</a>
                <a href="${pageContext.request.contextPath}/ReservaServlet?accion=listar&filtro=Cancelada" class="tab <%= "Cancelada".equals(filtro) ? "active" : ""%>">Canceladas</a>
            </div>

            <div class="panel-card">
                <%
                    // FILTRAR RESERVAS
                    java.util.List<Reserva> reservasFiltradas = new java.util.ArrayList<Reserva>();
                    if (reservas != null) {
                        for (Reserva r : reservas) {
                            if ("todas".equals(filtro) || filtro.equals(r.getEstado())) {
                                reservasFiltradas.add(r);
                            }
                        }
                    }

                    if (!reservasFiltradas.isEmpty()) {
                        for (Reserva r : reservasFiltradas) {
                            String claseEstado = "estado-pendiente";
                            String iconoEstado = "clock";
                            if ("Lista".equals(r.getEstado())) {
                                claseEstado = "estado-lista";
                                iconoEstado = "list";
                            } else if ("Cancelada".equals(r.getEstado())) {
                                claseEstado = "estado-cancelada";
                                iconoEstado = "times-circle";
                            }

                            boolean esReservaQR = (mostrarQR != null && mostrarQR.equals(String.valueOf(r.getIdReserva())));
                %>
                <div class="reserva-card">
                    <div style="display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:.8rem;">
                        <div>
                            <div class="reserva-id">Reserva #<%=r.getIdReserva()%></div>
                            <div style="color:rgba(248,251,255,.5);font-size:.8rem;"><i class="far fa-calendar-alt me-1"></i> <%=r.getFechaReserva()%></div>
                        </div>
                        <span class="reserva-estado <%=claseEstado%>"><i class="fas fa-<%=iconoEstado%>"></i> <%=r.getEstado()%></span>
                    </div>
                    <div class="reserva-info">
                        <div><i class="fas fa-book me-2" style="color:#42A5F5;"></i><strong>Libro:</strong> <%=r.getTituloLibro() != null ? r.getTituloLibro() : "Libro #" + r.getIdLibro()%></div>
                        <div><i class="fas fa-user me-2" style="color:#42A5F5;"></i><strong>Usuario:</strong> <%=r.getNombreUsuario() != null ? r.getNombreUsuario() + " " + r.getApellidoUsuario() : "Usuario #" + r.getIdUsuario()%></div>
                    </div>
                    <div class="reserva-acciones">
                        <%-- BOTÓN QR --%>
                        <a href="${pageContext.request.contextPath}/ReservaServlet?accion=listar&filtro=<%=filtro%><%= esReservaQR ? "" : "&mostrarQR=" + r.getIdReserva()%>" 
                           class="btn-accion btn-qr">
                            <i class="fas fa-<%= esReservaQR ? "times" : "qrcode"%>"></i> <%= esReservaQR ? "Ocultar QR" : "Ver QR"%>
                        </a>
                        <%-- BOTÓN EDITAR ESTADO --%>
                        <a href="${pageContext.request.contextPath}/ReservaServlet?accion=editar&id=<%=r.getIdReserva()%>&filtro=<%=filtro%>" class="btn-accion btn-editar"><i class="fas fa-edit"></i> Editar Estado</a>
                    </div>

                    <%-- QR CON URL CORREGIDA --%>
                    <% if (esReservaQR) {%>
                    <div class="qr-container">
                        <img src="${pageContext.request.contextPath}/QRServlet?idReserva=<%=r.getIdReserva()%>" 
                             alt="QR Reserva #<%=r.getIdReserva()%>"
                             onerror="this.parentNode.innerHTML='<div class=\'qr-error\'><i class=\'fas fa-exclamation-triangle\' style=\'color:#F44336;font-size:2rem;\'></i><br><br>Error al cargar QR<br>Verifica que QRServlet esté configurado</div>'"/>
                        <p style="color:#333;margin-top:1rem;"><strong>Reserva #<%=r.getIdReserva()%></strong><br><span style="font-size:.85rem;">Escanea para verificar</span></p>
                    </div>
                    <% } %>
                </div>
                <% }
                } else {%>
                <div class="empty-state"><i class="fas fa-calendar-times" style="font-size:3rem;color:rgba(66,165,245,.3);"></i><h4 style="color:rgba(248,251,255,.7);">No hay reservas <%= !"todas".equals(filtro) ? "con estado '" + filtro + "'" : ""%></h4></div>
                        <% } %>
            </div>

            <%-- MODO FORMULARIO --%>
            <% } else if ("formulario".equals(modo)) { %>

            <div class="panel-card" style="max-width:600px;">
                <form action="${pageContext.request.contextPath}/ReservaServlet" method="post">
                    <input type="hidden" name="accion" value="guardar">
                    <div class="mb-4">
                        <label class="form-label" style="color:rgba(255,255,255,.75);font-size:.85rem;font-weight:600;"><i class="fas fa-book me-1"></i> Libro</label>
                        <div class="select-wrapper">
                            <select name="idLibro" class="form-select select-custom" required style="background:rgba(255,255,255,.06);border:1px solid rgba(255,255,255,.15);color:#fff;border-radius:10px;padding:.65rem 1rem;">
                                <option value="">— Selecciona un libro —</option>
                                <% if (libros != null) {
                                        for (Libro l : libros) {%><option value="<%=l.getId()%>" style="background:#0d2855;"><%=l.getTitulo()%> <%=l.getDisponible() == 0 ? "(No disponible)" : "(Disponible)"%></option><% }
                                            } %>
                            </select>
                        </div>
                    </div>
                    <div class="mb-4">
                        <label class="form-label" style="color:rgba(255,255,255,.75);font-size:.85rem;font-weight:600;"><i class="fas fa-user me-1"></i> Usuario</label>
                        <div class="select-wrapper">
                            <select name="idUsuario" class="form-select select-custom" required style="background:rgba(255,255,255,.06);border:1px solid rgba(255,255,255,.15);color:#fff;border-radius:10px;padding:.65rem 1rem;">
                                <option value="">— Selecciona un usuario —</option>
                                <% if (usuarios != null) {
                                        for (Usuario u : usuarios) {%><option value="<%=u.getIdUsuario()%>" style="background:#0d2855;"><%=u.getNombres()%> <%=u.getApellidos()%> — Doc: <%=u.getDocumento()%></option><% }
                                            }%>
                            </select>
                        </div>
                    </div>
                    <div class="d-flex gap-2">
                        <button type="submit" class="btn-panel-gold"><i class="fas fa-save me-1"></i> Guardar</button>
                        <a href="${pageContext.request.contextPath}/ReservaServlet?accion=listar&filtro=<%=filtro%>" class="btn btn-outline-secondary">Cancelar</a>
                    </div>
                </form>
            </div>

            <%-- MODO EDITAR: Solo cambiar ESTADO (no libro, no usuario) --%>
            <% } else if ("editar".equals(modo) && reservaEditar != null) {%>

            <div class="panel-card" style="max-width:500px;">
                <h4 style="color:#FFD54F;margin-bottom:1.5rem;">
                    <i class="fas fa-edit me-2"></i>Editar Estado - Reserva #<%=reservaEditar.getIdReserva()%>
                </h4>

                <%-- Info de la reserva (solo lectura) --%>
                <div style="background:rgba(255,255,255,.05);border-radius:10px;padding:1rem;margin-bottom:1.5rem;">
                    <div style="color:rgba(248,251,255,.7);font-size:.9rem;margin-bottom:.5rem;">
                        <i class="fas fa-book me-2" style="color:#42A5F5;"></i>
                        <strong>Libro:</strong> <%=reservaEditar.getTituloLibro() != null ? reservaEditar.getTituloLibro() : "Libro #" + reservaEditar.getIdLibro()%>
                    </div>
                    <div style="color:rgba(248,251,255,.7);font-size:.9rem;margin-bottom:.5rem;">
                        <i class="fas fa-user me-2" style="color:#42A5F5;"></i>
                        <strong>Usuario:</strong> <%=reservaEditar.getNombreUsuario() != null ? reservaEditar.getNombreUsuario() + " " + reservaEditar.getApellidoUsuario() : "Usuario #" + reservaEditar.getIdUsuario()%>
                    </div>
                    <div style="color:rgba(248,251,255,.7);font-size:.9rem;">
                        <i class="fas fa-tag me-2" style="color:#42A5F5;"></i>
                        <strong>Estado actual:</strong> 
                        <span style="color:<%= "Pendiente".equals(reservaEditar.getEstado()) ? "#FFC107" : ("Lista".equals(reservaEditar.getEstado()) ? "#4CAF50" : "#F44336")%>;">
                            <%=reservaEditar.getEstado()%>
                        </span>
                    </div>
                </div>

                <%-- FORMULARIO SOLO PARA ESTADO --%>
                <form action="${pageContext.request.contextPath}/ReservaServlet" method="post">
                    <input type="hidden" name="accion" value="actualizar">
                    <input type="hidden" name="idReserva" value="<%=reservaEditar.getIdReserva()%>">
                    <input type="hidden" name="filtro" value="<%=filtro%>">

                    <div class="mb-4">
                        <label class="form-label" style="color:rgba(255,255,255,.75);font-size:.85rem;font-weight:600;">
                            <i class="fas fa-toggle-on me-1"></i> Nuevo Estado
                        </label>
                        <div class="select-wrapper">
                            <select name="estado" class="form-select select-custom" required 
                                    style="background:rgba(255,255,255,.06);border:1px solid rgba(255,255,255,.15);color:#fff;border-radius:10px;padding:.65rem 1rem;">
                                <option value="Pendiente" <%= "Pendiente".equals(reservaEditar.getEstado()) ? "selected" : ""%> style="background:#0d2855;">
                                    🟡 Pendiente
                                </option>
                                <option value="Lista" <%= "Lista".equals(reservaEditar.getEstado()) ? "selected" : ""%> style="background:#0d2855;">
                                    🟢 En lista de espera
                                </option>
                                <option value="Cancelada" <%= "Cancelada".equals(reservaEditar.getEstado()) ? "selected" : ""%> style="background:#0d2855;">
                                    🔴 Cancelada
                                </option>
                            </select>
                        </div>
                    </div>

                    <div class="d-flex gap-2">
                        <button type="submit" class="btn-panel-gold">
                            <i class="fas fa-save me-1"></i> Guardar Estado
                        </button>
                        <a href="${pageContext.request.contextPath}/ReservaServlet?accion=listar&filtro=<%=filtro%>" class="btn btn-outline-secondary">
                            Cancelar
                        </a>
                    </div>
                </form>
            </div>

            <%-- Si modo es editar pero no hay reservaEditar, mostrar error --%>
            <% } else if ("editar".equals(modo) && reservaEditar == null) { %>
            <div class="panel-card">
                <div class="flash-danger">
                    <i class="fas fa-exclamation-circle"></i> Error: No se pudo cargar la reserva para editar.
                </div>
                <a href="${pageContext.request.contextPath}/ReservaServlet?accion=listar" class="btn btn-outline-light">
                    <i class="fas fa-arrow-left me-1"></i> Volver al listado
                </a>
            </div>
            <% }%>
        </main>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
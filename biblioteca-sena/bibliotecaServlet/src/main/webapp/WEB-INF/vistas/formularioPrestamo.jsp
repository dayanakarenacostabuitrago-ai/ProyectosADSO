<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, karen.adso.biblioteca.modelo.*, karen.adso.biblioteca.modelo.Usuario"%>
<%
    Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");
    String tipoUsuario = (String) session.getAttribute("tipoUsuario");
    if (usuarioSesion == null) {
        response.sendRedirect(request.getContextPath() + "/loginServlet");
        return;
    }
    Prestamo prestamo = (Prestamo) request.getAttribute("prestamo");
    boolean esDevolucion = (prestamo != null);
    boolean puedeVerValoracion = esDevolucion
            && ("Administrativo".equals(tipoUsuario) || "Bibliotecario".equals(tipoUsuario));

    List<Libro> libros = (List<Libro>) request.getAttribute("libros");
    List<Usuario> usuarios = (List<Usuario>) request.getAttribute("usuarios");
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title><%= esDevolucion ? "Registrar Devolución" : "Nuevo Préstamo"%> — Biblioteca SENA</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700;900&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Estilos.css">
        <style>
            :root{
                --azul-oscuro:#0A1628;
                --azul-marino:#0D2855;
                --azul-primario:#1565C0;
                --azul-medio:#1976D2;
                --azul-claro:#42A5F5;
                --dorado:#FFD54F;
                --blanco:#F8FBFF;
                
                
                
                
                
            }
            .panel-body{
                font-family:'Lato',sans-serif;
                background:var(--azul-oscuro);
                color:var(--blanco);
                min-height:100vh;
                display:flex
            }
            
            
            
            .sb-brand 
            
            
            
            
            
            
            
            
            
            .btn-logout:hover{
                background:rgba(248,81,73,0.1);
            }
            /* Ajuste main content */
            .main-c,.main-content{
                margin-left:76px;
            }
            .main-content{
                margin-left:76px;
                flex:1;
                padding:2.5rem 3rem
            }
            .pg-header{
                display:flex;
                align-items:center;
                justify-content:space-between;
                flex-wrap:wrap;
                gap:1rem;
                margin-bottom:2.5rem;
                padding-bottom:1.25rem;
                border-bottom:1px solid rgba(66,165,245,.1)
            }
            .pg-title{
                font-family:'Playfair Display',serif;
                font-size:2rem;
                font-weight:800
            }
            .pg-title span{
                color:var(--dorado)
            }
            .pg-sub{
                color:rgba(255,255,255,.45);
                font-size:.88rem;
                margin-top:.2rem
            }
            .btn-back{
                display:inline-flex;
                align-items:center;
                gap:.5rem;
                padding:.55rem 1.4rem;
                border-radius:50px;
                background:rgba(66,165,245,.1);
                border:1px solid rgba(66,165,245,.25);
                color:var(--azul-claro);
                font-size:.875rem;
                font-weight:700;
                text-decoration:none;
                transition:all .2s
            }
            .btn-back:hover{
                background:rgba(66,165,245,.2);
                color:var(--azul-claro);
                transform:translateX(-3px)
            }
            .form-card{
                max-width:900px;
                background:linear-gradient(145deg,rgba(13,40,85,.85),rgba(10,22,40,.95));
                border:1px solid rgba(66,165,245,.13);
                border-radius:24px;
                padding:2.5rem;
                box-shadow:0 20px 60px rgba(0,0,0,.35);
                backdrop-filter:blur(12px);
                position:relative;
                overflow:hidden
            }
            .form-card::before{
                content:'';
                position:absolute;
                top:-100px;
                right:-100px;
                width:260px;
                height:260px;
                background:radial-gradient(circle,rgba(255,213,79,.05) 0%,transparent 70%);
                pointer-events:none
            }
            .sec-title{
                font-family:'Playfair Display',serif;
                font-size:1rem;
                color:var(--azul-claro);
                border-bottom:1px solid rgba(66,165,245,.2);
                padding-bottom:.55rem;
                margin-bottom:1.4rem;
                margin-top:2rem;
                display:flex;
                align-items:center;
                gap:.5rem
            }
            .sec-title i{
                font-size:.9rem
            }
            .sec-title:first-of-type{
                margin-top:0
            }
            .flabel{
                display:block;
                color:rgba(255,255,255,.75);
                font-size:.83rem;
                font-weight:700;
                margin-bottom:.45rem;
                letter-spacing:.3px
            }
            .flabel .req{
                color:#f87171;
                margin-left:2px
            }
            .iwrap{
                position:relative
            }
            .iico{
                position:absolute;
                left:1rem;
                top:50%;
                transform:translateY(-50%);
                color:var(--azul-claro);
                font-size:.9rem;
                pointer-events:none;
                z-index:1
            }
            .finput{
                width:100%;
                background:rgba(255,255,255,.05)!important;
                border:1.5px solid rgba(66,165,245,.18)!important;
                color:var(--blanco)!important;
                border-radius:12px!important;
                padding:.8rem 1rem .8rem 2.8rem!important;
                font-size:.92rem!important;
                transition:border-color .25s,box-shadow .25s!important
            }
            .finput:focus{
                outline:none!important;
                border-color:var(--dorado)!important;
                box-shadow:0 0 0 4px rgba(255,213,79,.1)!important;
                background:rgba(255,255,255,.08)!important
            }
            .finput::placeholder{
                color:rgba(255,255,255,.22)!important
            }
            .finput-select{
                width:100%;
                background:rgba(255,255,255,.05)!important;
                border:1.5px solid rgba(66,165,245,.18)!important;
                color:var(--blanco)!important;
                border-radius:12px!important;
                padding:.8rem 1rem .8rem 2.8rem!important;
                font-size:.92rem!important;
                transition:border-color .25s,box-shadow .25s!important;
                appearance:none;
                cursor:pointer
            }
            .finput-select:focus{
                outline:none!important;
                border-color:var(--dorado)!important;
                box-shadow:0 0 0 4px rgba(255,213,79,.1)!important;
                background:rgba(255,255,255,.08)!important
            }
            .finput-select option{
                background:#0D2855;
                color:var(--blanco)
            }
            .field-hint{
                color:rgba(255,255,255,.3);
                font-size:.78rem;
                margin-top:.35rem
            }
            .loan-info{
                background:rgba(255,213,79,.06);
                border:1px solid rgba(255,213,79,.15);
                border-radius:16px;
                padding:1.25rem 1.5rem;
                margin-bottom:2rem;
                display:flex;
                align-items:center;
                gap:1.25rem;
                flex-wrap:wrap
            }
            .loan-info-icon{
                width:52px;
                height:52px;
                border-radius:14px;
                background:rgba(255,213,79,.12);
                border:1px solid rgba(255,213,79,.2);
                display:flex;
                align-items:center;
                justify-content:center;
                font-size:1.4rem;
                flex-shrink:0
            }
            .loan-info-text{
                flex:1
            }
            .loan-info-text h6{
                color:var(--dorado);
                font-weight:800;
                margin:0 0 .25rem;
                font-size:1rem
            }
            .loan-info-text p{
                color:rgba(255,255,255,.5);
                font-size:.85rem;
                margin:0
            }
            .loan-badge{
                background:rgba(255,213,79,.12);
                color:var(--dorado);
                border:1px solid rgba(255,213,79,.25);
                border-radius:8px;
                padding:.25em .75em;
                font-size:.8rem;
                font-weight:700
            }
            /* Zona upload */
            .upload-section{
                margin-top:.5rem
            }
            .upload-zone{
                position:relative;
                border:2px dashed rgba(66,165,245,.3);
                border-radius:18px;
                padding:2.5rem 1.5rem;
                text-align:center;
                cursor:pointer;
                background:rgba(66,165,245,.03);
                transition:all .3s;
                overflow:hidden
            }
            .upload-zone:hover,.upload-zone.drag-over{
                border-color:var(--azul-claro);
                background:rgba(66,165,245,.08);
                transform:translateY(-2px)
            }
            .upload-zone input[type="file"]{
                position:absolute;
                inset:0;
                opacity:0;
                cursor:pointer;
                width:100%;
                height:100%;
                z-index:2
            }
            .upload-icon-wrap{
                width:64px;
                height:64px;
                border-radius:50%;
                background:linear-gradient(135deg,rgba(21,101,192,.3),rgba(66,165,245,.2));
                border:1px solid rgba(66,165,245,.25);
                display:flex;
                align-items:center;
                justify-content:center;
                font-size:1.5rem;
                color:var(--azul-claro);
                margin:0 auto 1rem;
                transition:all .3s
            }
            .upload-zone:hover .upload-icon-wrap{
                background:linear-gradient(135deg,rgba(21,101,192,.5),rgba(66,165,245,.35));
                transform:scale(1.08)
            }
            .upload-title{
                color:var(--blanco);
                font-weight:700;
                font-size:1rem;
                margin-bottom:.3rem
            }
            .upload-sub{
                color:rgba(255,255,255,.4);
                font-size:.82rem;
                line-height:1.5
            }
            .upload-sub strong{
                color:var(--azul-claro)
            }
            .img-preview-wrap{
                display:none;
                margin-top:1.25rem;
                background:rgba(10,22,40,.6);
                border:1px solid rgba(66,165,245,.2);
                border-radius:14px;
                overflow:hidden;
                position:relative
            }
            .img-preview-wrap img{
                width:100%;
                max-height:260px;
                object-fit:cover;
                display:block
            }
            .img-preview-overlay{
                position:absolute;
                bottom:0;
                left:0;
                right:0;
                background:linear-gradient(transparent,rgba(10,22,40,.85));
                padding:.75rem 1rem;
                display:flex;
                align-items:center;
                justify-content:space-between
            }
            .img-preview-name{
                color:rgba(255,255,255,.7);
                font-size:.8rem;
                font-weight:600
            }
            .btn-remove-img{
                background:rgba(239,68,68,.15);
                border:1px solid rgba(239,68,68,.25);
                color:#f87171;
                border-radius:8px;
                padding:.3em .75em;
                font-size:.78rem;
                font-weight:700;
                cursor:pointer;
                transition:all .2s;
                z-index:3;
                position:relative
            }
            .btn-remove-img:hover{
                background:rgba(239,68,68,.3)
            }
            /* Estrellas */
            .resena-wrap{
                margin-top:1.5rem
            }
            .textarea-resena{
                width:100%;
                background:rgba(255,255,255,.05)!important;
                border:1.5px solid rgba(66,165,245,.18)!important;
                color:var(--blanco)!important;
                border-radius:12px!important;
                padding:1rem!important;
                font-size:.92rem!important;
                transition:border-color .25s,box-shadow .25s!important;
                resize:vertical;
                min-height:120px;
                font-family:'Lato',sans-serif
            }
            .textarea-resena:focus{
                outline:none!important;
                border-color:var(--dorado)!important;
                box-shadow:0 0 0 4px rgba(255,213,79,.1)!important;
                background:rgba(255,255,255,.08)!important
            }
            .textarea-resena::placeholder{
                color:rgba(255,255,255,.22)!important
            }
            .char-count{
                font-size:.75rem;
                color:rgba(255,255,255,.3);
                text-align:right;
                margin-top:.35rem
            }
            .char-count b{
                color:var(--azul-claro)
            }
            .star-rating{
                display:flex;
                gap:.4rem;
                margin-top:.5rem
            }
            .star-btn{
                font-size:1.5rem;
                cursor:pointer;
                color:rgba(255,255,255,.2);
                transition:all .2s;
                background:none;
                border:none;
                padding:0;
                line-height:1
            }
            .star-btn:hover,.star-btn.on{
                color:var(--dorado);
                transform:scale(1.15)
            }
            .rating-label{
                font-size:.8rem;
                color:rgba(255,255,255,.4);
                margin-left:.5rem;
                align-self:center
            }
            /* Botones */
            .btn-gold{
                display:inline-flex;
                align-items:center;
                gap:.6rem;
                padding:.8rem 2.2rem;
                border-radius:50px;
                border:none;
                background:linear-gradient(135deg,#e6a800,var(--dorado));
                color:#0A1628;
                font-size:.95rem;
                font-weight:800;
                cursor:pointer;
                transition:all .25s;
                letter-spacing:.3px
            }
            .btn-gold:hover{
                transform:translateY(-3px);
                box-shadow:0 8px 28px rgba(255,213,79,.35)
            }
            .btn-cancel2{
                display:inline-flex;
                align-items:center;
                gap:.6rem;
                padding:.8rem 1.6rem;
                border-radius:50px;
                background:transparent;
                border:1.5px solid rgba(255,255,255,.12);
                color:rgba(255,255,255,.55);
                font-size:.9rem;
                font-weight:600;
                text-decoration:none;
                transition:all .2s
            }
            .btn-cancel2:hover{
                border-color:rgba(255,255,255,.3);
                color:rgba(255,255,255,.85)
            }
            .tip-box{
                background:rgba(66,165,245,.06);
                border:1px solid rgba(66,165,245,.14);
                border-radius:12px;
                padding:1rem 1.2rem;
                margin-top:2rem;
                display:flex;
                gap:.75rem;
                align-items:flex-start
            }
            .tip-box i{
                color:var(--azul-claro);
                font-size:1rem;
                flex-shrink:0;
                margin-top:.1rem
            }
            .tip-box p{
                color:rgba(255,255,255,.45);
                font-size:.82rem;
                margin:0;
                line-height:1.55
            }
            @media(max-width:768px){
                
                .main-content{
                    margin-left:0;
                    padding:1.5rem 1rem
                }
            }

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
            <a href="${pageContext.request.contextPath}/PrestamoServlet" class="ni act" title="Préstamos"><i class="fas fa-hand-holding-heart"></i><span>Préstamos</span></a>
            <a href="${pageContext.request.contextPath}/ReservaServlet" class="ni" title="Reservas"><i class="fas fa-calendar-check"></i><span>Reservas</span></a>
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
            <div class="pg-header">
                <div>
                    <div class="pg-title">
                        <% if (esDevolucion) { %>
                        <i class="fas fa-undo-alt me-2" style="color:var(--dorado);font-size:1.5rem;vertical-align:middle"></i>
                        Registrar <span>Devolución</span>
                        <% } else { %>
                        <i class="fas fa-hand-holding-heart me-2" style="color:var(--dorado);font-size:1.5rem;vertical-align:middle"></i>
                        Nuevo <span>Préstamo</span>
                        <% }%>
                    </div>
                    <div class="pg-sub">
                        <%= esDevolucion ? "Registra la devolución del libro" : "Registra un nuevo préstamo de libro"%>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/PrestamoServlet" class="btn-back">
                    <i class="fas fa-arrow-left"></i> Volver a Préstamos
                </a>
            </div>

            <div class="form-card">

                <% if (esDevolucion) {%>
                <div class="loan-info">
                    <div class="loan-info-icon"><i class="fas fa-book-open" style="color:var(--dorado)"></i></div>
                    <div class="loan-info-text">
                        <h6>Préstamo #<%=prestamo.getIdPrestamo()%></h6>
                        <p>
                            Libro: <strong style="color:var(--blanco)"><%=prestamo.getTituloLibro() != null ? prestamo.getTituloLibro() : "ID: " + prestamo.getIdLibro()%></strong>
                            &nbsp;·&nbsp; Usuario: <strong style="color:var(--blanco)"><%=prestamo.getNombreUsuario() != null ? prestamo.getNombreUsuario() : "ID: " + prestamo.getIdUsuario()%></strong>
                            &nbsp;·&nbsp; Vencía: <strong style="color:var(--blanco)"><%=prestamo.getFechaDevolucion() != null ? prestamo.getFechaDevolucion().toString().substring(0, 10) : "—"%></strong>
                        </p>
                    </div>
                    <span class="loan-badge"><i class="fas fa-clock me-1"></i><%=prestamo.getEstado()%></span>
                </div>
                <% } %>

                <form action="${pageContext.request.contextPath}/PrestamoServlet"
                      method="post"
                      enctype="multipart/form-data"
                      id="frmPrestamo"
                      novalidate>

                    <% if (esDevolucion) {%>
                    <input type="hidden" name="accion" value="registrarDevolucion">
                    <input type="hidden" name="id"     value="<%=prestamo.getIdPrestamo()%>">
                    <% } else { %>
                    <input type="hidden" name="accion" value="insertar">
                    <% } %>

                    <!-- SECCIÓN 1: Datos del préstamo (solo modo nuevo) -->
                    <% if (!esDevolucion) { %>
                    <div class="sec-title"><i class="fas fa-book"></i> Información del Préstamo</div>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="flabel" for="idLibro">Libro <span class="req">*</span></label>
                            <div class="iwrap">
                                <i class="fas fa-book iico"></i>
                                <select id="idLibro" name="idLibro" class="form-select finput-select" required>
                                    <option value="">— Selecciona un libro —</option>
                                    <% if (libros != null) {
                                            for (Libro l : libros) {%>
                                    <option value="<%=l.getId()%>"><%=l.getTitulo()%></option>
                                    <% }
                                        } %>
                                </select>
                            </div>
                            <div class="field-hint"><i class="fas fa-info-circle me-1"></i>Solo libros disponibles.</div>
                        </div>
                        <div class="col-md-6">
                            <label class="flabel" for="idUsuario">Usuario <span class="req">*</span></label>
                            <div class="iwrap">
                                <i class="fas fa-user-graduate iico"></i>
                                <select id="idUsuario" name="idUsuario" class="form-select finput-select" required>
                                    <option value="">— Selecciona un usuario —</option>
                                    <% if (usuarios != null) {
                                            for (Usuario u : usuarios) {%>
                                    <option value="<%=u.getIdUsuario()%>"><%=u.getNombres()%> <%=u.getApellidos()%> (<%=u.getDocumento()%>)</option>
                                    <% }
                                        }%>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="flabel" for="fechaPrestamo">Fecha de Préstamo <span class="req">*</span></label>
                            <div class="iwrap">
                                <i class="fas fa-calendar-plus iico"></i>
                                <input type="date" id="fechaPrestamo" name="fechaPrestamo"
                                       class="form-control finput"
                                       value="<%= java.time.LocalDate.now().toString()%>" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="flabel" for="fechaDevolucion">Fecha de Devolución <span class="req">*</span></label>
                            <div class="iwrap">
                                <i class="fas fa-calendar-check iico"></i>
                                <input type="date" id="fechaDevolucion" name="fechaDevolucion"
                                       class="form-control finput"
                                       value="<%= java.time.LocalDate.now().plusDays(15).toString()%>" required>
                            </div>
                            <div class="field-hint"><i class="fas fa-info-circle me-1"></i>Plazo estándar: 15 días.</div>
                        </div>
                    </div>
                    <% } else {%>
                    <!-- Modo devolución: solo fecha real -->
                    <div class="sec-title"><i class="fas fa-undo-alt"></i> Fecha de Devolución</div>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="flabel" for="fechaDevolucionReal">Fecha Real de Devolución <span class="req">*</span></label>
                            <div class="iwrap">
                                <i class="fas fa-calendar-check iico"></i>
                                <input type="date" id="fechaDevolucionReal" name="fechaDevolucionReal"
                                       class="form-control finput"
                                       value="<%= java.time.LocalDate.now().toString()%>" required>
                            </div>
                        </div>
                    </div>
                    <% } %>

                    <hr style="border:none;border-top:1px solid rgba(66,165,245,.1);margin:2rem 0">

                    <!-- SECCIÓN 2: Foto y reseña — SOLO en devolución y para admin/bibliotecario -->
                    <% if (puedeVerValoracion) { %>
                    <div class="sec-title" style="margin-top:0">
                        <i class="fas fa-camera"></i>
                        Foto &amp; Reseña del Libro
                        <span style="background:rgba(255,213,79,.1);color:var(--dorado);border:1px solid rgba(255,213,79,.2);border-radius:50px;padding:.15em .75em;font-size:.72rem;font-weight:700;margin-left:.5rem">Opcional</span>
                    </div>
                    <p style="color:rgba(255,255,255,.45);font-size:.85rem;margin-bottom:1.5rem;line-height:1.6">
                        <i class="fas fa-info-circle me-1" style="color:var(--azul-claro)"></i>
                        Adjunta una foto de la portada del libro y escribe una pequeña reseña.
                        La imagen se guarda en <code style="color:var(--azul-claro)">WEB-INF/imagenes/</code>.
                    </p>

                    <div class="upload-section">
                        <div class="upload-zone" id="uploadZone">
                            <input type="file" id="imagenLibro" name="imagenLibro"
                                   accept="image/jpeg,image/png,image/webp,image/gif"
                                   onchange="previewImage(this)">
                            <div class="upload-icon-wrap" id="uploadIcon">
                                <i class="fas fa-cloud-upload-alt"></i>
                            </div>
                            <div class="upload-title" id="uploadTitle">Arrastra la foto aquí o haz clic</div>
                            <div class="upload-sub">Formatos: <strong>JPG, PNG, WEBP</strong> · Máximo <strong>5 MB</strong></div>
                        </div>
                        <div class="img-preview-wrap" id="previewWrap">
                            <img id="previewImg" src="" alt="Vista previa">
                            <div class="img-preview-overlay">
                                <span class="img-preview-name" id="previewName"></span>
                                <button type="button" class="btn-remove-img" onclick="removeImage()">
                                    <i class="fas fa-times me-1"></i>Quitar
                                </button>
                            </div>
                        </div>
                    </div>

                    <div class="resena-wrap">
                        <div class="mb-3">
                            <label class="flabel">Valoración del Libro</label>
                            <div class="d-flex align-items-center">
                                <div class="star-rating" id="starRating">
                                    <button type="button" class="star-btn" data-val="1" onclick="setRating(1)" title="Muy malo">★</button>
                                    <button type="button" class="star-btn" data-val="2" onclick="setRating(2)" title="Malo">★</button>
                                    <button type="button" class="star-btn" data-val="3" onclick="setRating(3)" title="Regular">★</button>
                                    <button type="button" class="star-btn" data-val="4" onclick="setRating(4)" title="Bueno">★</button>
                                    <button type="button" class="star-btn" data-val="5" onclick="setRating(5)" title="Excelente">★</button>
                                </div>
                                <span class="rating-label" id="ratingLabel">Sin valorar</span>
                            </div>
                            <input type="hidden" name="valoracion" id="valoracionInput" value="0">
                        </div>
                        <label class="flabel" for="resena">Reseña del libro</label>
                        <textarea id="resena" name="resena" class="form-control textarea-resena"
                                  placeholder="¿Qué te pareció el libro? ¿Lo recomendarías?..."
                                  maxlength="500"
                                  oninput="document.getElementById('resCnt').textContent=this.value.length"></textarea>
                        <div class="char-count"><b id="resCnt">0</b> / 500 caracteres</div>
                    </div>

                    <hr style="border:none;border-top:1px solid rgba(66,165,245,.1);margin:2rem 0">
                    <% } %>

                    <!-- Acciones -->
                    <div class="d-flex gap-3 align-items-center flex-wrap">
                        <% if (esDevolucion) { %>
                        <button type="submit" class="btn-gold">
                            <i class="fas fa-undo-alt"></i> Confirmar Devolución
                        </button>
                        <% } else { %>
                        <button type="submit" class="btn-gold">
                            <i class="fas fa-hand-holding-heart"></i> Registrar Préstamo
                        </button>
                        <% } %>
                        <a href="${pageContext.request.contextPath}/PrestamoServlet" class="btn-cancel2">
                            <i class="fas fa-times"></i> Cancelar
                        </a>
                    </div>
                </form>

                <% if (!esDevolucion) { %>
                <div class="tip-box">
                    <i class="fas fa-lightbulb"></i>
                    <p>El préstamo se registrará con estado <strong style="color:var(--azul-claro)">En curso</strong> y el libro quedará marcado como no disponible.</p>
                </div>
                <% } %>
            </div>
        </main>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                        function previewImage(input) {
                                            if (!input.files || !input.files[0])
                                                return;
                                            const file = input.files[0];
                                            if (file.size > 5 * 1024 * 1024) {
                                                alert('⚠️ La imagen supera los 5 MB.');
                                                input.value = '';
                                                return;
                                            }
                                            const reader = new FileReader();
                                            reader.onload = function (e) {
                                                document.getElementById('previewImg').src = e.target.result;
                                                document.getElementById('previewName').textContent = file.name;
                                                document.getElementById('previewWrap').style.display = 'block';
                                                document.getElementById('uploadIcon').style.display = 'none';
                                                document.getElementById('uploadTitle').textContent = '✅ Imagen seleccionada.';
                                            };
                                            reader.readAsDataURL(file);
                                        }
                                        function removeImage() {
                                            document.getElementById('imagenLibro').value = '';
                                            document.getElementById('previewWrap').style.display = 'none';
                                            document.getElementById('previewImg').src = '';
                                            document.getElementById('uploadIcon').style.display = 'flex';
                                            document.getElementById('uploadTitle').textContent = 'Arrastra la foto aquí o haz clic';
                                        }
                                        const zone = document.getElementById('uploadZone');
                                        if (zone) {
                                            zone.addEventListener('dragover', e => {
                                                e.preventDefault();
                                                zone.classList.add('drag-over');
                                            });
                                            zone.addEventListener('dragleave', () => zone.classList.remove('drag-over'));
                                            zone.addEventListener('drop', e => {
                                                e.preventDefault();
                                                zone.classList.remove('drag-over');
                                                const dt = e.dataTransfer;
                                                if (dt.files && dt.files[0]) {
                                                    document.getElementById('imagenLibro').files = dt.files;
                                                    previewImage(document.getElementById('imagenLibro'));
                                                }
                                            });
                                        }
                                        const labels = ['', 'Muy malo 😞', 'Malo 😐', 'Regular 🙂', 'Bueno 😊', '¡Excelente! 🌟'];
                                        function setRating(val) {
                                            document.getElementById('valoracionInput').value = val;
                                            document.getElementById('ratingLabel').textContent = labels[val];
                                            document.querySelectorAll('.star-btn').forEach(s => s.classList.toggle('on', parseInt(s.dataset.val) <= val));
                                        }
                                        document.querySelectorAll('.star-btn').forEach(s => {
                                            s.addEventListener('mouseenter', () => {
                                                const v = parseInt(s.dataset.val);
                                                document.querySelectorAll('.star-btn').forEach(b => b.style.color = parseInt(b.dataset.val) <= v ? 'var(--dorado)' : '');
                                            });
                                            s.addEventListener('mouseleave', () => {
                                                const cur = parseInt(document.getElementById('valoracionInput').value) || 0;
                                                document.querySelectorAll('.star-btn').forEach(b => b.style.color = parseInt(b.dataset.val) <= cur ? 'var(--dorado)' : '');
                                            });
                                        });

                                        document.getElementById('frmPrestamo').addEventListener('submit', function (e) {
            <% if (!esDevolucion) { %>
                                            let ok = true;
                                            const libro = document.getElementById('idLibro');
                                            const usuario = document.getElementById('idUsuario');
                                            const fdev = document.getElementById('fechaDevolucion');
                                            [libro, usuario, fdev].forEach(f => {
                                                if (!f.value) {
                                                    f.style.borderColor = '#f87171';
                                                    f.style.boxShadow = '0 0 0 4px rgba(248,113,113,.15)';
                                                    if (ok)
                                                        f.focus();
                                                    ok = false;
                                                }
                                            });
                                            if (!ok) {
                                                e.preventDefault();
                                                return;
                                            }
                                            const fp = new Date(document.getElementById('fechaPrestamo').value);
                                            const fd = new Date(fdev.value);
                                            if (fp && fd && fd <= fp) {
                                                e.preventDefault();
                                                fdev.style.borderColor = '#f87171';
                                                alert('⚠️ La fecha de devolución debe ser posterior a la fecha de préstamo.');
                                            }
            <% } else { %>
                                            const fdr = document.getElementById('fechaDevolucionReal');
                                            if (!fdr.value) {
                                                e.preventDefault();
                                                fdr.style.borderColor = '#f87171';
                                                fdr.style.boxShadow = '0 0 0 4px rgba(248,113,113,.15)';
                                                fdr.focus();
                                            }
            <% }%>
                                        });
        </script>
               <%@ include file="/WEB-INF/vistas/Chatbot.jsp" %>

    </body>
</html>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="karen.adso.biblioteca.modelo.Usuario"%>
<%
    Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");
    String tipoUsuario = (String) session.getAttribute("tipoUsuario");
    if (usuarioSesion == null) {
        response.sendRedirect(request.getContextPath() + "/loginServlet");
        return;
    }
    Usuario usuario = (Usuario) request.getAttribute("usuario");
    boolean esEdicion = (usuario != null);
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title><%=esEdicion ? "Editar" : "Nuevo"%> Usuario — Biblioteca SENA</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700;900&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Estilos.css">
        <style>
            :root{
                --ao:#0A1628;
                --am:#0D2855;
                --ap:#1565C0;
                --ac:#42A5F5;
                --dor:#FFD54F;
                --bl:#F8FBFF;
            }
            .panel-body{
                display:flex;
                min-height:100vh;
                background:var(--ao);
            }

            .sb-brand{
                padding:1.4rem 1.4rem .9rem;
                border-bottom:1px solid rgba(255,255,255,.07);
            }
            .sb-brand h5{
                font-family:'Playfair Display',serif;
                font-size:1.08rem;
                color:var(--bl);
                margin:0;
            }
            .sb-brand i{
                color:var(--dor);
                font-size:1.3rem;
            }
            .sb-user{
                padding:.7rem 1.4rem .95rem;
                border-bottom:1px solid rgba(255,255,255,.05);
            }
            .sb-av{
                width:36px;
                height:36px;
                border-radius:50%;
                flex-shrink:0;
                background:linear-gradient(135deg,var(--ap),var(--ac));
                display:flex;
                align-items:center;
                justify-content:center;
                font-weight:700;
                font-size:.84rem;
                color:#fff;
            }
            .sb-nm{
                font-size:.81rem;
                font-weight:700;
                color:var(--bl);
                line-height:1.2;
            }
            .sb-rl{
                font-size:.69rem;
                color:var(--ac);
                text-transform:uppercase;
                letter-spacing:.5px;
            }
            .sb-nav{
                padding:.4rem .65rem;
                flex:1;
            }
            .sb-sec{
                font-size:.66rem;
                text-transform:uppercase;
                letter-spacing:1px;
                color:rgba(255,255,255,.28);
                padding:.65rem .7rem .2rem;
                font-weight:700;
            }





            .sb-foot{
                padding:.85rem 1.15rem 1.4rem;
                border-top:1px solid rgba(255,255,255,.05);
                margin-top:auto;
            }
            .btn-out{
                display:flex;
                align-items:center;
                gap:.5rem;
                width:100%;
                padding:.52rem .78rem;
                background:rgba(220,53,69,.1);
                border:1px solid rgba(220,53,69,.2);
                border-radius:9px;
                color:#fc8181;
                font-size:.845rem;
                font-weight:600;
                text-decoration:none;
                transition:all .2s;
            }
            .btn-out:hover{
                background:rgba(220,53,69,.2);
                color:#fc8181;
            }
            .main-c{
                margin-left: 78px;
                flex:1;
                padding:2.8rem 3.2rem;
            }
            .ph{
                display:flex;
                align-items:flex-start;
                justify-content:space-between;
                flex-wrap:wrap;
                gap:1rem;
                margin-bottom:2.4rem;
                padding-bottom:1.2rem;
                border-bottom:1px solid rgba(66,165,245,.1);
            }
            .ph-title{
                font-family:'Playfair Display',serif;
                font-size:2rem;
                font-weight:800;
                color:var(--bl);
            }
            .ph-title span{
                color:var(--dor);
            }
            .ph-sub{
                color:rgba(248,251,255,.42);
                font-size:.87rem;
                margin-top:.18rem;
            }
            .btn-back{
                display:inline-flex;
                align-items:center;
                gap:.5rem;
                padding:.55rem 1.35rem;
                background:rgba(21,101,192,.18);
                border:1px solid rgba(66,165,245,.22);
                border-radius:50px;
                color:var(--ac);
                font-size:.87rem;
                font-weight:700;
                text-decoration:none;
                transition:all .2s;
            }
            .btn-back:hover{
                background:rgba(66,165,245,.18);
                color:var(--ac);
                transform:translateX(-3px);
            }
            .f-card{
                background:linear-gradient(150deg,rgba(13,40,85,.72),rgba(10,22,40,.92));
                border:1px solid rgba(66,165,245,.14);
                border-radius:24px;
                padding:2.4rem 2.6rem;
                backdrop-filter:blur(16px);
                box-shadow:0 24px 64px rgba(0,0,0,.38);
                max-width:840px;
                animation:fup .5s ease both;
            }
            @keyframes fup{
                from{
                    opacity:0;
                    transform:translateY(26px)
                }
                to{
                    opacity:1;
                    transform:translateY(0)
                }
            }
            /* USER PREVIEW */
            .user-prev{
                display:flex;
                align-items:center;
                gap:1.3rem;
                padding:1.3rem 1.5rem;
                background:rgba(21,101,192,.08);
                border:1px solid rgba(66,165,245,.14);
                border-radius:18px;
                margin-bottom:2rem;
            }
            .u-av{
                width:62px;
                height:62px;
                border-radius:50%;
                flex-shrink:0;
                background:linear-gradient(135deg,var(--ap),var(--ac));
                display:flex;
                align-items:center;
                justify-content:center;
                font-family:'Playfair Display',serif;
                font-size:1.8rem;
                font-weight:800;
                color:#fff;
                box-shadow:0 8px 22px rgba(21,101,192,.4);
                transition:all .3s;
            }
            .u-name{
                font-family:'Playfair Display',serif;
                font-size:1.15rem;
                font-weight:700;
                color:var(--bl);
            }
            .u-doc{
                font-size:.82rem;
                color:rgba(255,255,255,.38);
                margin-top:.15rem;
            }
            .u-role-badge{
                display:inline-flex;
                align-items:center;
                gap:.35rem;
                padding:.22em .75em;
                border-radius:50px;
                font-size:.73rem;
                font-weight:700;
                margin-top:.4rem;
                background:rgba(66,165,245,.12);
                color:var(--ac);
                border:1px solid rgba(66,165,245,.22);
            }
            .u-state-badge{
                display:inline-flex;
                align-items:center;
                gap:.35rem;
                padding:.22em .75em;
                border-radius:50px;
                font-size:.73rem;
                font-weight:700;
                margin-top:.4rem;
                margin-left:.4rem;
            }
            .u-activo{
                background:rgba(74,222,128,.12);
                color:#4ade80;
                border:1px solid rgba(74,222,128,.25);
            }
            .u-inactivo{
                background:rgba(248,113,113,.1);
                color:#f87171;
                border:1px solid rgba(248,113,113,.2);
            }
            .pb{
                margin-left:auto;
                font-size:.7rem;
                color:rgba(255,255,255,.2);
                white-space:nowrap;
            }
            /* ROL SELECTOR */
            .rol-grid{
                display:grid;
                grid-template-columns:repeat(3,1fr);
                gap:.7rem;
                margin-top:.5rem;
            }
            .rol-opt{
                padding:.75rem 1rem;
                border-radius:12px;
                text-align:center;
                cursor:pointer;
                border:1.5px solid rgba(255,255,255,.1);
                background:rgba(255,255,255,.04);
                color:rgba(255,255,255,.45);
                font-size:.84rem;
                font-weight:600;
                transition:all .2s;
            }
            .rol-opt:hover{
                border-color:rgba(66,165,245,.35);
                color:var(--ac);
            }
            .rol-opt.sel-admin{
                border-color:var(--dor);
                background:rgba(255,213,79,.1);
                color:var(--dor);
            }
            .rol-opt.sel-bib{
                border-color:var(--ac);
                background:rgba(66,165,245,.1);
                color:var(--ac);
            }
            .rol-opt.sel-est{
                border-color:#c084fc;
                background:rgba(192,132,252,.1);
                color:#c084fc;
            }
            .rol-opt i{
                display:block;
                font-size:1.3rem;
                margin-bottom:.4rem;
            }
            input[name="tipoUsuario"]{
                display:none;
            }
            /* FIELDS */
            .f-sec{
                display:flex;
                align-items:center;
                gap:.55rem;
                font-size:.79rem;
                text-transform:uppercase;
                letter-spacing:1px;
                font-weight:700;
                color:var(--ac);
                margin-bottom:1.1rem;
                margin-top:1.6rem;
            }
            .f-sec:first-child{
                margin-top:0;
            }
            .f-sec::after{
                content:'';
                flex:1;
                height:1px;
                background:rgba(66,165,245,.14);
            }
            .fg{
                margin-bottom:1.25rem;
            }
            .fl{
                display:block;
                color:rgba(248,251,255,.72);
                font-size:.84rem;
                font-weight:700;
                margin-bottom:.42rem;
            }
            .fl .r{
                color:#f87171;
            }
            .fi,.fs{
                width:100%;
                background:rgba(6,14,28,.65)!important;
                border:1.5px solid rgba(66,165,245,.17)!important;
                color:var(--bl)!important;
                border-radius:12px!important;
                padding:.75rem 1.05rem!important;
                font-size:.9rem!important;
                font-family:'Lato',sans-serif;
                transition:border-color .25s,box-shadow .25s!important;
                outline:none;

                /* 🔥 SOLUCIÓN A LAS LÍNEAS AZULES */
                appearance:none;
                -webkit-appearance:none;
                -moz-appearance:none;
                background-image:none !important;
            }


            .fs:focus{
                box-shadow:none !important;
            }
            .fi:focus,.fs:focus{
                border-color:var(--ac)!important;
                box-shadow:0 0 0 3.5px rgba(66,165,245,.17)!important;
            }
            .fi::placeholder{
                color:rgba(255,255,255,.2)!important;
            }
            .fs option{
                background:var(--am);
            }
            .fh{
                font-size:.75rem;
                color:rgba(255,255,255,.27);
                margin-top:.3rem;
            }
            /* PASSWORD TOGGLE */
            .pw-wrap{
                position:relative;
            }
            .pw-wrap .fi{
                padding-right:2.8rem!important;
            }
            .pw-eye{
                position:absolute;
                right:.9rem;
                top:50%;
                transform:translateY(-50%);
                background:none;
                border:none;
                color:rgba(255,255,255,.3);
                cursor:pointer;
                font-size:.9rem;
                padding:0;
                transition:color .2s;
            }
            .pw-eye:hover{
                color:var(--ac);
            }
            .f-hr{
                border:none;
                border-top:1px solid rgba(66,165,245,.1);
                margin:1.8rem 0;
            }
            .btn-go{
                display:inline-flex;
                align-items:center;
                gap:.6rem;
                padding:.72rem 2.1rem;
                border:none;
                border-radius:50px;
                background:linear-gradient(135deg,#e6a500,var(--dor));
                color:var(--ao);
                font-weight:800;
                font-size:.95rem;
                cursor:pointer;
                transition:all .25s;
                box-shadow:0 6px 22px rgba(255,213,79,.28);
            }
            .btn-go:hover{
                transform:translateY(-3px);
                box-shadow:0 12px 34px rgba(255,213,79,.4);
            }
            .btn-cx{
                display:inline-flex;
                align-items:center;
                gap:.5rem;
                padding:.72rem 1.6rem;
                border-radius:50px;
                border:1.5px solid rgba(255,255,255,.13);
                color:rgba(255,255,255,.5);
                font-size:.9rem;
                font-weight:600;
                text-decoration:none;
                transition:all .2s;
            }
            .btn-cx:hover{
                border-color:rgba(255,255,255,.28);
                color:rgba(255,255,255,.78);
            }
            .tip{
                font-size:.77rem;
                color:rgba(255,255,255,.27);
                margin-bottom:1.4rem;
            }
            .tip .r{
                color:#f87171;
            }

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
        <main class="main-c">
            <div class="ph">
                <div>
                    <div class="ph-title"><%if (esEdicion) {%><span>Editar</span> Usuario<%} else {%><span>Nuevo</span> Usuario<%}%></div>
                    <div class="ph-sub"><%if (esEdicion) {%>Modifica los datos del miembro del sistema<%} else {%>Registra un nuevo usuario de la Biblioteca SENA<%}%></div>
                </div>
                <a href="${pageContext.request.contextPath}/UsuarioServlet" class="btn-back"><i class="fas fa-arrow-left"></i> Volver a Usuarios</a>
            </div>

            <div class="f-card">
                <!-- User Preview -->
                <div class="user-prev">
                    <div class="u-av" id="pAv"><%if (esEdicion) {%><%=usuario.getNombres().charAt(0)%><%} else {%><i class="fas fa-user" style="font-size:1.5rem"></i><%}%></div>
                    <div>
                        <div class="u-name" id="pName"><%=esEdicion ? usuario.getNombres() + " " + usuario.getApellidos() : "Nombre del Usuario"%></div>
                        <div class="u-doc"  id="pDoc">Doc: <%=esEdicion ? usuario.getDocumento() : "..."%></div>
                        <span class="u-role-badge" id="pRol"><i class="fas fa-shield-alt me-1"></i><span id="pRolTxt"><%=esEdicion ? usuario.getTipoUsuario() : "Rol"%></span></span>
                        <span class="u-state-badge <%=esEdicion && "Inactivo".equals(usuario.getEstado()) ? "u-inactivo" : "u-activo"%>" id="pState">
                            <i class="fas fa-circle" style="font-size:.55rem"></i><span id="pStateTxt"><%=esEdicion ? usuario.getEstado() : "Activo"%></span>
                        </span>
                    </div>
                    <div class="pb"><i class="fas fa-sync-alt me-1"></i>Vista previa</div>
                </div>

                <form action="${pageContext.request.contextPath}/UsuarioServlet" method="post">
                    <input type="hidden" name="accion" value="<%=esEdicion ? "actualizar" : "insertar"%>">
                    <%if (esEdicion) {%><input type="hidden" name="id" value="<%=usuario.getIdUsuario()%>"><%}%>
                    <input type="hidden" name="tipoUsuario" id="rolVal" value="<%=esEdicion ? usuario.getTipoUsuario() : "Estudiante"%>">

                    <p class="tip"><span class="r">*</span> Campos obligatorios</p>

                    <div class="f-sec"><i class="fas fa-id-card"></i> Datos Personales</div>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <div class="fg"><label class="fl" for="nombres">Nombres <span class="r">*</span></label>
                                <input type="text" id="nombres" name="nombres" class="fi" placeholder="Ej: Carlos Andrés"
                                       value="<%=esEdicion ? usuario.getNombres() : ""%>" required maxlength="80" autocomplete="off"></div>
                        </div>
                        <div class="col-md-6">
                            <div class="fg"><label class="fl" for="apellidos">Apellidos <span class="r">*</span></label>
                                <input type="text" id="apellidos" name="apellidos" class="fi" placeholder="Ej: Martínez López"
                                       value="<%=esEdicion ? usuario.getApellidos() : ""%>" required maxlength="80" autocomplete="off"></div>
                        </div>
                        <div class="col-md-4">
                            <div class="fg"><label class="fl" for="documento">Documento <span class="r">*</span></label>
                                <input type="text" id="documento" name="documento" class="fi" placeholder="Número de cédula"
                                       value="<%=esEdicion ? usuario.getDocumento() : ""%>" required maxlength="20" autocomplete="off"></div>
                        </div>
                        <div class="col-md-4">
                            <div class="fg"><label class="fl" for="email">Email</label>
                                <input type="email" id="email" name="email" class="fi" placeholder="correo@sena.edu.co"
                                       value="<%=esEdicion && usuario.getEmail() != null ? usuario.getEmail() : ""%>"></div>
                        </div>
                        <div class="col-md-4">
                            <div class="fg"><label class="fl" for="telefono">Teléfono</label>
                                <input type="tel" id="telefono" name="telefono" class="fi" placeholder="3001234567"
                                       value="<%=esEdicion && usuario.getTelefono() != null ? usuario.getTelefono() : ""%>"></div>
                        </div>
                    </div>

                    <div class="f-sec"><i class="fas fa-shield-alt"></i> Rol en el Sistema</div>
                    <div class="rol-grid">
                        <div class="rol-opt <%=(!esEdicion || "Administrativo".equals(usuario.getTipoUsuario())) && !esEdicion && false ? "" : ""%> <%=esEdicion && "Administrativo".equals(usuario.getTipoUsuario()) ? "sel-admin" : ""%>" id="rAdmin" onclick="setRol('Administrativo', 'sel-admin')">
                            <i class="fas fa-crown"></i>Administrativo
                        </div>
                        <div class="rol-opt <%=esEdicion && "Bibliotecario".equals(usuario.getTipoUsuario()) ? "sel-bib" : ""%>" id="rBib" onclick="setRol('Bibliotecario', 'sel-bib')">
                            <i class="fas fa-book-reader"></i>Bibliotecario
                        </div>
                        <div class="rol-opt <%=(!esEdicion || "Estudiante".equals(usuario.getTipoUsuario())) ? "sel-est" : ""%>" id="rEst" onclick="setRol('Estudiante', 'sel-est')">
                            <i class="fas fa-user-graduate"></i>Estudiante
                        </div>
                    </div>

                    <div class="f-sec"><i class="fas fa-toggle-on"></i> Estado y Acceso</div>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <div class="fg">
                                <label class="fl" for="estado">Estado de la cuenta</label>
                                <select id="estado" name="estado" class="fs">
                                    <option value="Activo"   <%=!esEdicion || "Activo".equals(usuario.getEstado()) ? "selected" : ""%>>✅ Activo</option>
                                    <option value="Inactivo" <%=esEdicion && "Inactivo".equals(usuario.getEstado()) ? "selected" : ""%>>❌ Inactivo</option>
                                </select>
                            </div>
                        </div>
                        <%if (!esEdicion) {%>
                        <div class="col-md-6">
                            <div class="fg">
                                <label class="fl" for="password">Contraseña <span class="r">*</span></label>
                                <div class="pw-wrap">
                                    <input type="password" id="password" name="password" class="fi" placeholder="Mínimo 6 caracteres" required minlength="6">
                                    <button type="button" class="pw-eye" onclick="togglePw()"><i class="fas fa-eye" id="pwIcon"></i></button>
                                </div>
                                <p class="fh">Mínimo 6 caracteres</p>
                            </div>
                        </div>
                        <%}%>
                    </div>

                    <hr class="f-hr">
                    <div class="d-flex gap-3 flex-wrap align-items-center">
                        <button type="submit" class="btn-go"><i class="fas fa-<%=esEdicion ? "save" : "user-plus"%>"></i><%=esEdicion ? "Guardar Cambios" : "Registrar Usuario"%></button>
                        <a href="${pageContext.request.contextPath}/UsuarioServlet" class="btn-cx"><i class="fas fa-times"></i> Cancelar</a>
                    </div>
                </form>
            </div>
        </main>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                        const iNom = document.getElementById('nombres'), iApe = document.getElementById('apellidos'), iDoc = document.getElementById('documento');
                                        const pAv = document.getElementById('pAv'), pName = document.getElementById('pName'), pDoc = document.getElementById('pDoc');
                                        const pRolTxt = document.getElementById('pRolTxt');
                                        function upd() {
                                            const n = iNom.value.trim(), a = iApe.value.trim(), d = iDoc.value.trim();
                                            pAv.innerHTML = n ? n.charAt(0).toUpperCase() : '<i class="fas fa-user" style="font-size:1.5rem"></i>';
                                            pAv.style.fontSize = n ? '1.8rem' : '';
                                            pName.textContent = (n + ' ' + a).trim() || 'Nombre del Usuario';
                                            pDoc.textContent = 'Doc: ' + (d || '...');
                                        }
                                        [iNom, iApe, iDoc].forEach(e => e.addEventListener('input', upd));

                                        // Estado change
                                        document.getElementById('estado').addEventListener('change', function () {
                                            const s = document.getElementById('pState'), t = document.getElementById('pStateTxt');
                                            t.textContent = this.value;
                                            s.className = 'u-state-badge ' + (this.value === 'Inactivo' ? 'u-inactivo' : 'u-activo');
                                        });

                                        // Rol selector
                                        const rolClasses = {Administrativo: 'sel-admin', Bibliotecario: 'sel-bib', Estudiante: 'sel-est'};
                                        const rolIds = {Administrativo: 'rAdmin', Bibliotecario: 'rBib', Estudiante: 'rEst'};
                                        function setRol(rol, cls) {
                                            document.getElementById('rolVal').value = rol;
                                            pRolTxt.textContent = rol;
                                            Object.values(rolIds).forEach(id => {
                                                const el = document.getElementById(id);
                                                el.className = 'rol-opt';
                                            });
                                            document.getElementById(rolIds[rol]).classList.add(cls);
                                        }

                                        // Password toggle
                                        function togglePw() {
                                            const inp = document.getElementById('password'), ico = document.getElementById('pwIcon');
                                            if (!inp)
                                                return;
                                            inp.type = inp.type === 'password' ? 'text' : 'password';
                                            ico.className = inp.type === 'password' ? 'fas fa-eye' : 'fas fa-eye-slash';
                                        }
        </script>
        <%@ include file="/WEB-INF/vistas/Chatbot.jsp" %>

    </body>
</html>

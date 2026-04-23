<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="karen.adso.biblioteca.modelo.Autor, karen.adso.biblioteca.modelo.Usuario"%>
<%
    Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");
    String tipoUsuario = (String) session.getAttribute("tipoUsuario");
    if (usuarioSesion == null) {
        response.sendRedirect(request.getContextPath() + "/loginServlet");
        return;
    }
    Autor autor = (Autor) request.getAttribute("autor");
    boolean esEdicion = (autor != null);
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title><%= esEdicion ? "Editar" : "Nuevo"%> Autor — Biblioteca SENA</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700;900&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Estilos.css">
        <style>
            :root{
                --azul-oscuro:#0A1628;
                --azul-marino:#0D2855;
                --azul-primario:#1565C0;
                --azul-claro:#42A5F5;
                --dorado:#FFD54F;
                --blanco:#F8FBFF;
                
                
                
                
                
            }
            .panel-body{
                display:flex;
                min-height:100vh;
                background:var(--azul-oscuro);
            }
            
            
            
            .sb-brand 
            
            
            
            
            
            
            
            
            
            .btn-logout:hover{
                background:rgba(248,81,73,0.1);
            }
            /* Ajuste main content */
            .main-c,.main-content{
                margin-left:76px;
            }
            /* MAIN */
            .main-c{
                margin-left:76px;
                flex:1;
                padding:2.8rem 3.2rem;
            }
            /* PAGE HEADER */
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
                color:var(--blanco);
            }
            .ph-title span{
                color:var(--dorado);
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
                color:var(--azul-claro);
                font-size:.87rem;
                font-weight:700;
                text-decoration:none;
                transition:all .2s;
            }
            .btn-back:hover{
                background:rgba(66,165,245,.18);
                color:var(--azul-claro);
                transform:translateX(-3px);
            }
            /* CARD */
            .f-card{
                background:linear-gradient(150deg,rgba(13,40,85,.72),rgba(10,22,40,.92));
                border:1px solid rgba(66,165,245,.14);
                border-radius:24px;
                padding:2.4rem 2.6rem;
                backdrop-filter:blur(16px);
                box-shadow:0 24px 64px rgba(0,0,0,.38);
                max-width:760px;
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
            /* AUTHOR PREVIEW */
            .author-preview{
                display:flex;
                align-items:center;
                gap:1.4rem;
                padding:1.4rem 1.6rem;
                background:radial-gradient(ellipse at 0% 50%,rgba(21,101,192,.18) 0%,transparent 70%),rgba(13,40,85,.6);
                border:1px solid rgba(66,165,245,.15);
                border-radius:18px;
                margin-bottom:2rem;
                position:relative;
                overflow:hidden;
            }
            .author-av{
                width:68px;
                height:68px;
                border-radius:50%;
                flex-shrink:0;
                background:linear-gradient(135deg,var(--azul-primario),var(--azul-claro));
                display:flex;
                align-items:center;
                justify-content:center;
                font-family:'Playfair Display',serif;
                font-size:2rem;
                font-weight:800;
                color:#fff;
                box-shadow:0 8px 24px rgba(21,101,192,.45);
                transition:all .3s;
            }
            .author-full{
                font-family:'Playfair Display',serif;
                font-size:1.25rem;
                font-weight:700;
                color:var(--blanco);
            }
            .author-nat{
                font-size:.82rem;
                color:var(--azul-claro);
                margin-top:.18rem;
            }
            .author-dob{
                font-size:.78rem;
                color:rgba(255,255,255,.35);
                margin-top:.12rem;
            }
            .prev-badge{
                margin-left:auto;
                font-size:.72rem;
                color:rgba(255,255,255,.22);
                display:flex;
                align-items:center;
                gap:.35rem;
            }
            /* SECTION */
            .f-sec{
                display:flex;
                align-items:center;
                gap:.55rem;
                font-size:.79rem;
                text-transform:uppercase;
                letter-spacing:1px;
                font-weight:700;
                color:var(--azul-claro);
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
            /* INPUTS */
            .f-group{
                margin-bottom:1.3rem;
            }
            .f-lbl{
                display:block;
                color:rgba(248,251,255,.72);
                font-size:.84rem;
                font-weight:700;
                margin-bottom:.42rem;
            }
            .f-lbl .req{
                color:#f87171;
            }
            .f-inp,.f-sel{
                width:100%;
                background:rgba(6,14,28,.65)!important;
                border:1.5px solid rgba(66,165,245,.17)!important;
                color:var(--blanco)!important;
                border-radius:12px!important;
                padding:.75rem 1.05rem!important;
                font-size:.9rem!important;
                font-family:'Lato',sans-serif;
                transition:border-color .25s,box-shadow .25s!important;
                outline:none;
            }
            .f-inp:focus,.f-sel:focus{
                border-color:var(--azul-claro)!important;
                box-shadow:0 0 0 3.5px rgba(66,165,245,.17)!important;
            }
            .f-inp::placeholder{
                color:rgba(255,255,255,.2)!important;
            }
            .f-hint{
                font-size:.76rem;
                color:rgba(255,255,255,.28);
                margin-top:.3rem;
            }
            input[type="date"]::-webkit-calendar-picker-indicator{
                filter:invert(.6);
                cursor:pointer;
            }
            /* NATIONALITY CHIPS */
            .nat-chips{
                display:flex;
                flex-wrap:wrap;
                gap:.42rem;
                margin-top:.6rem;
            }
            .nat-chip{
                padding:.26rem .85rem;
                border-radius:50px;
                font-size:.77rem;
                cursor:pointer;
                background:rgba(255,255,255,.05);
                border:1px solid rgba(255,255,255,.1);
                color:rgba(255,255,255,.52);
                transition:all .18s;
            }
            .nat-chip:hover{
                background:rgba(66,165,245,.12);
                border-color:rgba(66,165,245,.35);
                color:var(--azul-claro);
            }
            .nat-chip.sel{
                background:rgba(66,165,245,.15);
                border-color:var(--azul-claro);
                color:var(--azul-claro);
                font-weight:700;
            }
            /* DIVIDER */
            .f-hr{
                border:none;
                border-top:1px solid rgba(66,165,245,.1);
                margin:1.8rem 0;
            }
            /* BUTTONS */
            .btn-go{
                display:inline-flex;
                align-items:center;
                gap:.6rem;
                padding:.72rem 2.1rem;
                border:none;
                border-radius:50px;
                background:linear-gradient(135deg,#e6a500,var(--dorado));
                color:var(--azul-oscuro);
                font-weight:800;
                font-size:.95rem;
                cursor:pointer;
                transition:all .25s;
                box-shadow:0 6px 22px rgba(255,213,79,.28);
                letter-spacing:.2px;
            }
            .btn-go:hover{
                transform:translateY(-3px);
                box-shadow:0 12px 34px rgba(255,213,79,.4);
            }
            .btn-go:active{
                transform:translateY(0);
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
            .tip .req{
                color:#f87171;
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
            .main-c{margin-left:78px!important}
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
            <a href="${pageContext.request.contextPath}/UsuarioServlet" class="ni" title="Usuarios"><i class="fas fa-users"></i><span>Usuarios</span></a>
            <% if ("Administrativo".equals(tipoUsuario)) { %>
            <a href="${pageContext.request.contextPath}/AutorServlet" class="ni act" title="Autores"><i class="fas fa-feather-alt"></i><span>Autores</span></a>
            <a href="${pageContext.request.contextPath}/CategoriaServlet" class="ni" title="Categ."><i class="fas fa-tags"></i><span>Categ.</span></a>
            <a href="${pageContext.request.contextPath}/EditorialServlet" class="ni" title="Edit."><i class="fas fa-building"></i><span>Edit.</span></a>
            <% } %><% } %>
            <div class="sb-bot">
                <div class="ni" onclick="location.href='${pageContext.request.contextPath}/loginServlet?accion=logout'" title="Salir" style="color:rgba(248,113,113,.7)"><i class="fas fa-sign-out-alt"></i><span>Salir</span></div>
                <div class="sb-av" title="<%=usuarioSesion.getNombres()%> <%=usuarioSesion.getApellidos()%>"><%=usuarioSesion.getNombres().charAt(0)%></div>
            </div>
        </aside>

        <main class="main-c">

            <div class="ph">
                <div>
                    <div class="ph-title">
                        <% if (esEdicion) {%><span>Editar</span> Autor<%} else {%><span>Nuevo</span> Autor<%}%>
                    </div>
                    <div class="ph-sub">
                        <%if (esEdicion) {%>Actualiza los datos del autor en el catálogo bibliográfico<%} else {%>Registra un nuevo autor para asociarlo a los libros del catálogo<%}%>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/AutorServlet" class="btn-back">
                    <i class="fas fa-arrow-left"></i> Volver a Autores
                </a>
            </div>

            <div class="f-card">

                <!-- Live Preview -->
                <div class="author-preview">
                    <div class="author-av" id="prevAv">
                        <%if (esEdicion) {%><%=autor.getNombre().charAt(0)%><%} else {%><i class="fas fa-user" style="font-size:1.5rem"></i><%}%>
                    </div>
                    <div>
                        <div class="author-full" id="prevFull"><%=esEdicion ? autor.getNombre() + " " + autor.getApellido() : "Nombre del Autor"%></div>
                        <div class="author-nat"  id="prevNat">
                            <i class="fas fa-globe-americas me-1"></i>
                            <span id="prevNatTxt"><%=esEdicion && autor.getNacionalidad() != null ? autor.getNacionalidad() : "Nacionalidad"%></span>
                        </div>
                        <div class="author-dob"  id="prevDob">
                            <i class="fas fa-birthday-cake me-1"></i>
                            <span id="prevDobTxt"><%=esEdicion && autor.getFechaNacimiento() != null ? autor.getFechaNacimiento().toString() : "Fecha de nacimiento"%></span>
                        </div>
                    </div>
                    <div class="prev-badge"><i class="fas fa-sync-alt"></i> Vista previa en vivo</div>
                </div>

                <form action="${pageContext.request.contextPath}/AutorServlet" method="post">
                    <input type="hidden" name="accion" value="<%=esEdicion ? "actualizar" : "insertar"%>">
                    <%if (esEdicion) {%><input type="hidden" name="id" value="<%=autor.getId()%>"><%}%>

                    <p class="tip"><span class="req">*</span> Campos obligatorios</p>

                    <div class="f-sec"><i class="fas fa-id-card"></i> Datos Personales</div>

                    <div class="row g-3">
                        <div class="col-md-6">
                            <div class="f-group">
                                <label class="f-lbl" for="nombre">Nombre(s) <span class="req">*</span></label>
                                <input type="text" id="nombre" name="nombre" class="f-inp"
                                       placeholder="Ej: Gabriel José"
                                       value="<%=esEdicion ? autor.getNombre() : ""%>"
                                       required autocomplete="off" maxlength="80">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="f-group">
                                <label class="f-lbl" for="apellido">Apellido(s) <span class="req">*</span></label>
                                <input type="text" id="apellido" name="apellido" class="f-inp"
                                       placeholder="Ej: García Márquez"
                                       value="<%=esEdicion ? autor.getApellido() : ""%>"
                                       required autocomplete="off" maxlength="80">
                            </div>
                        </div>
                    </div>

                    <div class="f-sec"><i class="fas fa-globe-americas"></i> Origen y Nacimiento</div>

                    <div class="row g-3">
                        <div class="col-md-6">
                            <div class="f-group">
                                <label class="f-lbl" for="nacionalidad">Nacionalidad</label>
                                <input type="text" id="nacionalidad" name="nacionalidad" class="f-inp"
                                       placeholder="Ej: Colombiana, Española…"
                                       value="<%=esEdicion && autor.getNacionalidad() != null ? autor.getNacionalidad() : ""%>"
                                       autocomplete="off" maxlength="60">
                                <p class="f-hint">O selecciona rápidamente:</p>
                                <div class="nat-chips">
                                    <span class="nat-chip" data-nat="Colombiana">🇨🇴 Colombia</span>
                                    <span class="nat-chip" data-nat="Española">🇪🇸 España</span>
                                    <span class="nat-chip" data-nat="Mexicana">🇲🇽 México</span>
                                    <span class="nat-chip" data-nat="Argentina">🇦🇷 Argentina</span>
                                    <span class="nat-chip" data-nat="Chilena">🇨🇱 Chile</span>
                                    <span class="nat-chip" data-nat="Estadounidense">🇺🇸 EE.UU.</span>
                                    <span class="nat-chip" data-nat="Inglesa">🇬🇧 Inglaterra</span>
                                    <span class="nat-chip" data-nat="Francesa">🇫🇷 Francia</span>
                                    <span class="nat-chip" data-nat="Peruana">🇵🇪 Perú</span>
                                    <span class="nat-chip" data-nat="Venezolana">🇻🇪 Venezuela</span>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="f-group">
                                <label class="f-lbl" for="fechaNacimiento">Fecha de Nacimiento</label>
                                <input type="date" id="fechaNacimiento" name="fechaNacimiento" class="f-inp"
                                       value="<%=esEdicion && autor.getFechaNacimiento() != null ? autor.getFechaNacimiento().toString() : ""%>">
                                <p class="f-hint"><i class="fas fa-info-circle me-1"></i>Formato: día/mes/año</p>
                            </div>
                        </div>
                    </div>

                    <hr class="f-hr">

                    <div class="d-flex align-items-center gap-3 flex-wrap">
                        <button type="submit" class="btn-go">
                            <i class="fas fa-<%=esEdicion ? "save" : "feather-alt"%>"></i>
                            <%=esEdicion ? "Guardar Cambios" : "Registrar Autor"%>
                        </button>
                        <a href="${pageContext.request.contextPath}/AutorServlet" class="btn-cx">
                            <i class="fas fa-times"></i> Cancelar
                        </a>
                    </div>
                </form>
            </div>
        </main>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            const iNom = document.getElementById('nombre');
            const iApe = document.getElementById('apellido');
            const iNac = document.getElementById('nacionalidad');
            const iDob = document.getElementById('fechaNacimiento');
            const pAv = document.getElementById('prevAv');
            const pFull = document.getElementById('prevFull');
            const pNatT = document.getElementById('prevNatTxt');
            const pDobT = document.getElementById('prevDobTxt');

            function refresh() {
                const n = iNom.value.trim(), a = iApe.value.trim();
                pAv.innerHTML = n ? n.charAt(0).toUpperCase() : '<i class="fas fa-user" style="font-size:1.5rem"></i>';
                pAv.style.fontSize = n ? '2rem' : '';
                pFull.textContent = (n + ' ' + a).trim() || 'Nombre del Autor';
                pNatT.textContent = iNac.value.trim() || 'Nacionalidad';
                pDobT.textContent = iDob.value || 'Fecha de nacimiento';
            }
            [iNom, iApe, iNac, iDob].forEach(el => el.addEventListener('input', refresh));

            // Chips
            document.querySelectorAll('.nat-chip').forEach(c => {
                c.addEventListener('click', function () {
                    document.querySelectorAll('.nat-chip').forEach(x => x.classList.remove('sel'));
                    this.classList.add('sel');
                    iNac.value = this.dataset.nat;
                    refresh();
                });
            });
            // Pre-select chip on edit
            const cv = iNac.value.trim();
            if (cv)
                document.querySelectorAll('.nat-chip').forEach(c => {
                    if (c.dataset.nat === cv)
                        c.classList.add('sel');
                });
        </script>
               <%@ include file="/WEB-INF/vistas/Chatbot.jsp" %>

    </body>
</html>
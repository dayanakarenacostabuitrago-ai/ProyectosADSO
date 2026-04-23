<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="karen.adso.biblioteca.modelo.Editorial, karen.adso.biblioteca.modelo.Usuario"%>
<%
    Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");
    String tipoUsuario = (String) session.getAttribute("tipoUsuario");
    if (usuarioSesion == null) {
        response.sendRedirect(request.getContextPath() + "/loginServlet");
        return;
    }
    Editorial editorial = (Editorial) request.getAttribute("editorial");
    boolean esEdicion = (editorial != null);
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title><%= esEdicion ? "Editar" : "Nueva"%> Editorial — Biblioteca SENA</title>
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
            
            
            
            .sb-brand 
            
            
            
            
            
            
            
            
            
            .btn-logout:hover{
                background:rgba(248,81,73,0.1);
            }
            /* Ajuste main content */
            .main-c,.main-content{
                margin-left:76px;
            }
            .main-c{
                margin-left:76px;
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
                max-width:700px;
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
            /* PREVIEW */
            .ed-prev{
                display:flex;
                align-items:center;
                gap:1.2rem;
                padding:1.3rem 1.5rem;
                background:rgba(255,213,79,.05);
                border:1px solid rgba(255,213,79,.14);
                border-radius:18px;
                margin-bottom:2rem;
            }
            .ed-logo{
                width:58px;
                height:58px;
                border-radius:14px;
                flex-shrink:0;
                background:linear-gradient(135deg,rgba(255,213,79,.18),rgba(21,101,192,.2));
                display:flex;
                align-items:center;
                justify-content:center;
                font-family:'Playfair Display',serif;
                font-size:1.7rem;
                font-weight:900;
                color:var(--dor);
                border:1px solid rgba(255,213,79,.18);
            }
            .ed-name{
                font-family:'Playfair Display',serif;
                font-size:1.2rem;
                font-weight:700;
                color:var(--bl);
            }
            .ed-loc{
                font-size:.82rem;
                color:rgba(255,255,255,.38);
                margin-top:.18rem;
            }
            .ed-url{
                font-size:.79rem;
                color:var(--ac);
                margin-top:.14rem;
                word-break:break-all;
            }
            .pb{
                margin-left:auto;
                font-size:.7rem;
                color:rgba(255,255,255,.2);
                white-space:nowrap;
            }
            /* CHIPS */
            .chips{
                display:flex;
                flex-wrap:wrap;
                gap:.4rem;
                margin-top:.55rem;
            }
            .chip{
                padding:.26rem .82rem;
                border-radius:50px;
                font-size:.77rem;
                cursor:pointer;
                background:rgba(255,255,255,.05);
                border:1px solid rgba(255,255,255,.1);
                color:rgba(255,255,255,.5);
                transition:all .18s;
            }
            .chip:hover{
                background:rgba(255,213,79,.1);
                border-color:rgba(255,213,79,.28);
                color:var(--dor);
            }
            .chip.sel{
                background:rgba(255,213,79,.12);
                border-color:var(--dor);
                color:var(--dor);
                font-weight:700;
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
                margin-bottom:1.3rem;
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
            .fi{
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
            }
            .fi:focus{
                border-color:var(--ac)!important;
                box-shadow:0 0 0 3.5px rgba(66,165,245,.17)!important;
            }
            .fi::placeholder{
                color:rgba(255,255,255,.2)!important;
            }
            .fi-ico{
                position:relative;
            }
            .fi-ico i{
                position:absolute;
                left:1rem;
                top:50%;
                transform:translateY(-50%);
                color:rgba(255,255,255,.28);
                font-size:.88rem;
            }
            .fi-ico .fi{
                padding-left:2.6rem!important;
            }
            .fh{
                font-size:.75rem;
                color:rgba(255,255,255,.27);
                margin-top:.3rem;
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
            <a href="${pageContext.request.contextPath}/AutorServlet" class="ni" title="Autores"><i class="fas fa-feather-alt"></i><span>Autores</span></a>
            <a href="${pageContext.request.contextPath}/CategoriaServlet" class="ni" title="Categ."><i class="fas fa-tags"></i><span>Categ.</span></a>
            <a href="${pageContext.request.contextPath}/EditorialServlet" class="ni act" title="Edit."><i class="fas fa-building"></i><span>Edit.</span></a>
            <% } %><% } %>
            <div class="sb-bot">
                <div class="ni" onclick="location.href='${pageContext.request.contextPath}/loginServlet?accion=logout'" title="Salir" style="color:rgba(248,113,113,.7)"><i class="fas fa-sign-out-alt"></i><span>Salir</span></div>
                <div class="sb-av" title="<%=usuarioSesion.getNombres()%> <%=usuarioSesion.getApellidos()%>"><%=usuarioSesion.getNombres().charAt(0)%></div>
            </div>
        </aside>
        <main class="main-c">
            <div class="ph">
                <div>
                    <div class="ph-title"><%if (esEdicion) {%><span>Editar</span> Editorial<%} else {%><span>Nueva</span> Editorial<%}%></div>
                    <div class="ph-sub"><%if (esEdicion) {%>Actualiza la información de la editorial<%} else {%>Registra una nueva casa editorial en el catálogo<%}%></div>
                </div>
                <a href="${pageContext.request.contextPath}/EditorialServlet" class="btn-back"><i class="fas fa-arrow-left"></i> Volver</a>
            </div>
            <div class="f-card">
                <!-- Live Preview -->
                <div class="ed-prev">
                    <div class="ed-logo" id="pLogo"><%=esEdicion ? String.valueOf(editorial.getNombre().charAt(0)) : "E"%></div>
                    <div style="flex:1;min-width:0">
                        <div class="ed-name" id="pName"><%=esEdicion ? editorial.getNombre() : "Nueva Editorial"%></div>
                        <div class="ed-loc"  id="pLoc"><i class="fas fa-map-marker-alt me-1"></i><span id="pLocTxt"><%=esEdicion && editorial.getPais() != null ? editorial.getPais() : "País"%></span></div>
                        <div class="ed-url"  id="pUrl"><%=esEdicion && editorial.getSitioWeb() != null ? editorial.getSitioWeb() : "https://..."%></div>
                    </div>
                    <div class="pb"><i class="fas fa-sync-alt me-1"></i>Vista previa</div>
                </div>

                <form action="${pageContext.request.contextPath}/EditorialServlet" method="post">
                    <input type="hidden" name="accion" value="<%=esEdicion ? "actualizar" : "insertar"%>">
                    <%if (esEdicion) {%><input type="hidden" name="id" value="<%=editorial.getId()%>"><%}%>
                    <p class="tip"><span class="r">*</span> Campos obligatorios</p>

                    <div class="f-sec"><i class="fas fa-building"></i> Nombre</div>
                    <div class="fg">
                        <label class="fl" for="nombre">Nombre de la editorial <span class="r">*</span></label>
                        <input type="text" id="nombre" name="nombre" class="fi"
                               placeholder="Ej: Penguin Random House, Planeta, Norma…"
                               value="<%=esEdicion ? editorial.getNombre() : ""%>" required maxlength="100" autocomplete="off">
                    </div>

                    <div class="f-sec"><i class="fas fa-globe"></i> Origen y Sitio Web</div>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <div class="fg">
                                <label class="fl" for="pais">País de origen</label>
                                <input type="text" id="pais" name="pais" class="fi"
                                       placeholder="Ej: Colombia, España…"
                                       value="<%=esEdicion && editorial.getPais() != null ? editorial.getPais() : ""%>" maxlength="60" autocomplete="off">
                                <p class="fh">O selecciona:</p>
                                <div class="chips">
                                    <span class="chip" data-p="Colombia">🇨🇴 Colombia</span>
                                    <span class="chip" data-p="España">🇪🇸 España</span>
                                    <span class="chip" data-p="México">🇲🇽 México</span>
                                    <span class="chip" data-p="Argentina">🇦🇷 Argentina</span>
                                    <span class="chip" data-p="Estados Unidos">🇺🇸 EE.UU.</span>
                                    <span class="chip" data-p="Reino Unido">🇬🇧 UK</span>
                                    <span class="chip" data-p="Francia">🇫🇷 Francia</span>
                                    <span class="chip" data-p="Alemania">🇩🇪 Alemania</span>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="fg">
                                <label class="fl" for="sitioWeb">Sitio Web</label>
                                <div class="fi-ico"><i class="fas fa-globe"></i>
                                    <input type="url" id="sitioWeb" name="sitioWeb" class="fi"
                                           placeholder="https://www.editorial.com"
                                           value="<%=esEdicion && editorial.getSitioWeb() != null ? editorial.getSitioWeb() : ""%>">
                                </div>
                                <p class="fh">Incluye https:// al inicio</p>
                            </div>
                        </div>
                    </div>

                    <hr class="f-hr">
                    <div class="d-flex gap-3 flex-wrap align-items-center">
                        <button type="submit" class="btn-go"><i class="fas fa-<%=esEdicion ? "save" : "plus-circle"%>"></i><%=esEdicion ? "Guardar Cambios" : "Registrar Editorial"%></button>
                        <a href="${pageContext.request.contextPath}/EditorialServlet" class="btn-cx"><i class="fas fa-times"></i> Cancelar</a>
                    </div>
                </form>
            </div>
        </main>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            const iN = document.getElementById('nombre'), iP = document.getElementById('pais'), iW = document.getElementById('sitioWeb');
            const pL = document.getElementById('pLogo'), pNm = document.getElementById('pName'), pLT = document.getElementById('pLocTxt'), pU = document.getElementById('pUrl');
            function upd() {
                pL.textContent = iN.value.trim().charAt(0).toUpperCase() || 'E';
                pNm.textContent = iN.value.trim() || 'Nueva Editorial';
                pLT.textContent = iP.value.trim() || 'País';
                pU.textContent = iW.value.trim() || 'https://...';
            }
            [iN, iP, iW].forEach(e => e.addEventListener('input', upd));
            document.querySelectorAll('.chip').forEach(c => {
                c.addEventListener('click', function () {
                    document.querySelectorAll('.chip').forEach(x => x.classList.remove('sel'));
                    this.classList.add('sel');
                    iP.value = this.dataset.p;
                    upd();
                });
            });
            const cv = iP.value.trim();
            if (cv)
                document.querySelectorAll('.chip').forEach(c => {
                    if (c.dataset.p === cv)
                        c.classList.add('sel');
                });
        </script>
               <%@ include file="/WEB-INF/vistas/Chatbot.jsp" %>

    </body>
</html>
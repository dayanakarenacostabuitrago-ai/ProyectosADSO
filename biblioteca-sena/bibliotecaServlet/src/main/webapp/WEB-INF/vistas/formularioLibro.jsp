<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, karen.adso.biblioteca.modelo.*"%>
<%
    karen.adso.biblioteca.modelo.Usuario usuarioSesion = (karen.adso.biblioteca.modelo.Usuario) session.getAttribute("usuario");
    String tipoUsuario = (String) session.getAttribute("tipoUsuario");
    if (usuarioSesion == null) {
        response.sendRedirect(request.getContextPath() + "/loginServlet");
        return;
    }
    Libro libro = (Libro) request.getAttribute("libro");
    boolean esEdicion = (libro != null);
    List<Editorial> editoriales = (List<Editorial>) request.getAttribute("editoriales");
    List<Categoria> categorias = (List<Categoria>) request.getAttribute("categorias");
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title><%=esEdicion ? "Editar" : "Nuevo"%> Libro — Biblioteca SENA</title>
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
                max-width:860px;
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
            /* BOOK PREVIEW */
            .book-prev{
                display:flex;
                align-items:stretch;
                gap:1.5rem;
                padding:1.4rem 1.6rem;
                background:rgba(21,101,192,.08);
                border:1px solid rgba(66,165,245,.15);
                border-radius:18px;
                margin-bottom:2rem;
            }
            .book-spine{
                width:14px;
                border-radius:4px 0 0 4px;
                background:linear-gradient(180deg,var(--ap),#0a2a6e);
                flex-shrink:0;
                min-height:90px;
            }
            .book-cover-prev{
                width:70px;
                background:linear-gradient(160deg,var(--ap) 0%,#0a2a6e 100%);
                border-radius:0 6px 6px 0;
                display:flex;
                align-items:center;
                justify-content:center;
                flex-shrink:0;
            }
            .book-cover-prev i{
                color:rgba(255,255,255,.4);
                font-size:1.6rem;
            }
            .book-info{
                flex:1;
            }
            .book-prev-title{
                font-family:'Playfair Display',serif;
                font-size:1.15rem;
                font-weight:700;
                color:var(--bl);
                margin-bottom:.3rem;
            }
            .book-prev-meta{
                font-size:.8rem;
                color:rgba(255,255,255,.4);
            }
            .book-prev-badge{
                display:inline-flex;
                align-items:center;
                gap:.35rem;
                padding:.22em .7em;
                border-radius:50px;
                font-size:.73rem;
                font-weight:700;
                margin-top:.5rem;
            }
            .disp{
                background:rgba(74,222,128,.12);
                color:#4ade80;
                border:1px solid rgba(74,222,128,.25);
            }
            .nodisp{
                background:rgba(248,113,113,.1);
                color:#f87171;
                border:1px solid rgba(248,113,113,.2);
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
                color:var(--bl);
            }
            .fh{
                font-size:.75rem;
                color:rgba(255,255,255,.27);
                margin-top:.3rem;
            }
            input[type="number"]::-webkit-inner-spin-button{
                filter:invert(.5);
            }
            /* DISPONIBILIDAD TOGGLE */
            .disp-toggle{
                display:flex;
                gap:.6rem;
            }
            .disp-opt{
                flex:1;
                padding:.65rem;
                border-radius:12px;
                text-align:center;
                cursor:pointer;
                border:1.5px solid rgba(255,255,255,.1);
                background:rgba(255,255,255,.04);
                color:rgba(255,255,255,.45);
                font-size:.85rem;
                font-weight:600;
                transition:all .2s;
            }
            .disp-opt.on{
                border-color:#4ade80;
                background:rgba(74,222,128,.1);
                color:#4ade80;
            }
            .disp-opt.off{
                border-color:#f87171;
                background:rgba(248,113,113,.08);
                color:#f87171;
            }
            .disp-opt:hover{
                border-color:rgba(255,255,255,.25);
            }
            input[name="disponible"]{
                display:none;
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
            .main-c{
                margin-left:78px!important
            }
        </style>
    </head>
    <body class="panel-body">
        <aside class="sb">
            <div class="sb-logo"><i class="fas fa-book-open"></i></div>
            <a href="${pageContext.request.contextPath}/DashboardServlet" class="ni" title="Inicio"><i class="fas fa-chart-pie"></i><span>Inicio</span></a>
            <a href="${pageContext.request.contextPath}/LibroServlet" class="ni act" title="Libros"><i class="fas fa-book"></i><span>Libros</span></a>
            <a href="${pageContext.request.contextPath}/PrestamoServlet" class="ni" title="Préstamos"><i class="fas fa-hand-holding-heart"></i><span>Préstamos</span></a>
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
                <div class="ni" onclick="location.href = '${pageContext.request.contextPath}/loginServlet?accion=logout'" title="Salir" style="color:rgba(248,113,113,.7)"><i class="fas fa-sign-out-alt"></i><span>Salir</span></div>
                <div class="sb-av" title="<%=usuarioSesion.getNombres()%> <%=usuarioSesion.getApellidos()%>"><%=usuarioSesion.getNombres().charAt(0)%></div>
            </div>
        </aside>
        <main class="main-c">
            <div class="ph">
                <div>
                    <div class="ph-title"><%if (esEdicion) {%><span>Editar</span> Libro<%} else {%><span>Nuevo</span> Libro<%}%></div>
                    <div class="ph-sub"><%if (esEdicion) {%>Actualiza los datos del libro en el catálogo<%} else {%>Agrega un nuevo título al inventario bibliográfico<%}%></div>
                </div>
                <a href="${pageContext.request.contextPath}/LibroServlet" class="btn-back"><i class="fas fa-arrow-left"></i> Volver al Catálogo</a>
            </div>

            <div class="f-card">
                <!-- Book Preview -->
                <div class="book-prev">
                    <div class="book-spine"></div>
                    <div class="book-cover-prev"><i class="fas fa-book-open"></i></div>
                    <div class="book-info">
                        <div class="book-prev-title" id="pTitulo"><%=esEdicion ? libro.getTitulo() : "Título del libro"%></div>
                        <div class="book-prev-meta">
                            <span id="pIsbn"><%=esEdicion && libro.getIsbn() != null ? "ISBN: " + libro.getIsbn() : "ISBN"%></span>
                            &nbsp;·&nbsp; <span id="pAnio"><%=esEdicion ? libro.getAñoPublicacion() + "" : "Año"%></span>
                            &nbsp;·&nbsp; <span id="pPag"><%=esEdicion && libro.getNumPaginas() != null ? libro.getNumPaginas() + " pág." : "Páginas"%></span>
                        </div>
                        <div class="book-prev-badge <%=esEdicion && libro.getDisponible() == 0 ? "nodisp" : "disp"%>" id="pDisp">
                            <i class="fas fa-<%=esEdicion && libro.getDisponible() == 0 ? "lock" : "check-circle"%>"></i>
                            <%=esEdicion && libro.getDisponible() == 0 ? "No disponible" : "Disponible"%>
                        </div>
                    </div>
                    <div style="margin-left:auto;font-size:.7rem;color:rgba(255,255,255,.18);align-self:center"><i class="fas fa-sync-alt me-1"></i>Vista previa</div>
                </div>

                <form action="${pageContext.request.contextPath}/LibroServlet" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="accion" value="<%=esEdicion ? "actualizar" : "insertar"%>">
                    <%if (esEdicion) {%><input type="hidden" name="id" value="<%=libro.getId()%>"><%}%>
                    <input type="hidden" name="disponible" id="dispVal" value="<%=esEdicion ? libro.getDisponible() : 1%>">

                    <p class="tip"><span class="r">*</span> Campos obligatorios</p>

                    <div class="f-sec"><i class="fas fa-book"></i> Información del Libro</div>
                    <div class="fg">
                        <label class="fl" for="titulo">Título <span class="r">*</span></label>
                        <input type="text" id="titulo" name="titulo" class="fi"
                               placeholder="Ej: Cien años de soledad, El Quijote, 1984…"
                               value="<%=esEdicion ? libro.getTitulo() : ""%>" required maxlength="200" autocomplete="off">
                    </div>
                    <div class="row g-3">
                        <div class="col-md-4">
                            <div class="fg">
                                <label class="fl" for="isbn">ISBN</label>
                                <input type="text" id="isbn" name="isbn" class="fi"
                                       placeholder="978-xxxx-xxx"
                                       value="<%=esEdicion && libro.getIsbn() != null ? libro.getIsbn() : ""%>" maxlength="20">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="fg">
                                <label class="fl" for="anio">Año de Publicación</label>
                                <input type="number" id="anio" name="añoPublicacion" class="fi"
                                       placeholder="2024" min="1000" max="2099"
                                       value="<%=esEdicion ? libro.getAñoPublicacion() : ""%>">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="fg">
                                <label class="fl" for="paginas">Número de Páginas</label>
                                <input type="number" id="paginas" name="numPaginas" class="fi"
                                       placeholder="350" min="1"
                                       value="<%=esEdicion && libro.getNumPaginas() != null ? libro.getNumPaginas() : ""%>">
                            </div>
                        </div>
                    </div>

                    <div class="f-sec"><i class="fas fa-sitemap"></i> Clasificación</div>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <div class="fg">
                                <label class="fl" for="editorial">Editorial <span class="r">*</span></label>
                                <select id="editorial" name="idEditorial" class="fs" required>
                                    <option value="">— Selecciona editorial —</option>
                                    <%if (editoriales != null) {
                                            for (Editorial ed : editoriales) {
                                                boolean s = esEdicion && libro.getIdEditorial() == ed.getId();%>
                                    <option value="<%=ed.getId()%>"<%=s ? " selected" : ""%>><%=ed.getNombre()%></option>
                                    <%}
                                        }%>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="fg">
                                <label class="fl" for="categoria">Categoría <span class="r">*</span></label>
                                <select id="categoria" name="idCategoria" class="fs" required>
                                    <option value="">— Selecciona categoría —</option>
                                    <%if (categorias != null) {
                                            for (Categoria cat : categorias) {
                                                boolean s = esEdicion && libro.getIdCategoria() == cat.getId();%>
                                    <option value="<%=cat.getId()%>"<%=s ? " selected" : ""%>><%=cat.getNombre()%></option>
                                    <%}
                                        }%>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="f-sec"><i class="fas fa-toggle-on"></i> Disponibilidad</div>
                    <div class="fg">
                        <label class="fl">Estado del libro <span class="r">*</span></label>
                        <div class="disp-toggle">
                            <div class="disp-opt <%=!esEdicion || libro.getDisponible() == 1 ? "on" : ""%>" id="btnDisp1" onclick="setDisp(1)">
                                <i class="fas fa-check-circle me-2"></i>Disponible para préstamo
                            </div>
                            <div class="disp-opt <%=esEdicion && libro.getDisponible() == 0 ? "off" : ""%>" id="btnDisp0" onclick="setDisp(0)">
                                <i class="fas fa-lock me-2"></i>No disponible / En préstamo
                            </div>
                        </div>
                    </div>


                    <div class="f-sec"><i class="fas fa-image"></i> Portada del Libro</div>
                    <div class="fg">
                        <%if (esEdicion && libro.getImagen() != null && !libro.getImagen().isEmpty()) {%>
                        <div class="mb-2">
                            <img src="${pageContext.request.contextPath}/imagen?f=<%=libro.getImagen()%>"
                                 alt="Portada actual" style="height:120px;border-radius:8px;object-fit:cover;border:1px solid #dde3ec;">
                            <p class="text-muted mt-1" style="font-size:.82rem;">Portada actual. Sube una nueva para reemplazarla.</p>
                        </div>
                        <input type="hidden" name="imagenActual" value="<%=libro.getImagen()%>">
                        <%} else if (esEdicion) {%>
                        <input type="hidden" name="imagenActual" value="">
                        <%}%>
                        <label class="fl" for="imagen"><%=esEdicion ? "Nueva portada (opcional)" : "Portada (opcional)"%></label>
                        <input type="file" id="imagen" name="imagen" class="fi"
                               accept="image/jpeg,image/png,image/webp"
                               style="padding:.45rem .75rem;"
                               onchange="previewImagen(this)">
                        <p class="text-muted mt-1" style="font-size:.8rem;">Formatos: JPG, PNG, WEBP. Max 5 MB.</p>
                        <div id="previewBox" style="display:none;margin-top:.5rem;">
                            <img id="previewImg" src="" alt="Vista previa"
                                 style="height:130px;border-radius:8px;object-fit:cover;border:1px solid #dde3ec;">
                        </div>
                    </div>

                    <hr class="f-hr">
                    <div class="d-flex gap-3 flex-wrap align-items-center">
                        <button type="submit" class="btn-go"><i class="fas fa-<%=esEdicion ? "save" : "plus-circle"%>"></i><%=esEdicion ? "Guardar Cambios" : "Registrar Libro"%></button>
                        <a href="${pageContext.request.contextPath}/LibroServlet" class="btn-cx"><i class="fas fa-times"></i> Cancelar</a>
                    </div>
                </form>
            </div>
        </main>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                   // Live preview
                                   document.getElementById('titulo').addEventListener('input', function () {
                                       document.getElementById('pTitulo').textContent = this.value || 'Título del libro';
                                   });
                                   document.getElementById('isbn').addEventListener('input', function () {
                                       document.getElementById('pIsbn').textContent = this.value ? 'ISBN: ' + this.value : 'ISBN';
                                   });
                                   document.getElementById('anio').addEventListener('input', function () {
                                       document.getElementById('pAnio').textContent = this.value || 'Año';
                                   });
                                   document.getElementById('paginas').addEventListener('input', function () {
                                       document.getElementById('pPag').textContent = this.value ? this.value + ' pág.' : 'Páginas';
                                   });

                                   // Disponibilidad toggle
                                   function setDisp(v) {
                                       document.getElementById('dispVal').value = v;
                                       const d1 = document.getElementById('btnDisp1'), d0 = document.getElementById('btnDisp0');
                                       const pD = document.getElementById('pDisp');
                                       d1.className = 'disp-opt ' + (v === 1 ? 'on' : '');
                                       d0.className = 'disp-opt ' + (v === 0 ? 'off' : '');
                                       pD.className = 'book-prev-badge ' + (v === 1 ? 'disp' : 'nodisp');
                                       pD.innerHTML = v === 1 ? '<i class="fas fa-check-circle"></i> Disponible' : '<i class="fas fa-lock"></i> No disponible';
                                   }

                                   function previewImagen(input) {
                                       var box = document.getElementById('previewBox');
                                       var img = document.getElementById('previewImg');
                                       var coverPrev = document.querySelector('.book-cover-prev');
                                       if (input.files && input.files[0]) {
                                           var reader = new FileReader();
                                           reader.onload = function (e) {
                                               img.src = e.target.result;
                                               box.style.display = 'block';
                                               // Actualizar portada en el book-preview superior
                                               coverPrev.innerHTML = '<img src="' + e.target.result + '" style="width:100%;height:100%;object-fit:cover;border-radius:0 6px 6px 0;">';
                                           };
                                           reader.readAsDataURL(input.files[0]);
                                       } else {
                                           box.style.display = 'none';
                                           coverPrev.innerHTML = '<i class=\"fas fa-book-open\"></i>';
                                       }
                                   }
        </script>
        <%@ include file="/WEB-INF/vistas/Chatbot.jsp" %>

    </body>
</html>
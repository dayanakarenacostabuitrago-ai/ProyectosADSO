<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<fmt:setLocale value="${not empty sessionScope.lang ? sessionScope.lang : 'es'}" />
<fmt:setBundle basename="messages" />
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${msg["consulta.title"]} — SaludBoyacá</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">

    <style>
        /* ══ TOKENS (mismos que index.jsp) ══════════════════════════════ */
        :root {
            --green:       #6a9e8a;
            --green-dark:  #4d7a68;
            --green-light: #8fbdaa;
            --green-pale:  #e8f2ee;
            --text-dark:   #1a2e26;
            --text-mid:    #4a6258;
            --text-light:  #7a9a8e;
            --white:       #ffffff;
            --gray-bg:     #f7f9f8;
            --border:      #dce9e4;
            --shadow:      0 4px 24px rgba(74,120,100,0.10);
            --shadow-lg:   0 12px 48px rgba(74,120,100,0.16);
            --radius:      18px;
            --radius-sm:   12px;
        }
        * { margin:0; padding:0; box-sizing:border-box; }
        html { scroll-behavior:smooth; }
        body {
            font-family: 'Inter', sans-serif;
            background: var(--gray-bg);
            color: var(--text-dark);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* ══ URGENCY BAR ══════════════════════════════════════════════ */
        .urgency-bar {
            background: #fff8f0;
            border-bottom: 1px solid #fde8c8;
            padding: .45rem 2rem;
            text-align: center;
            font-size: .8rem;
            color: #c26a10;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: .5rem;
        }
        .urgency-bar i { color:#e07a20; }
        .urgency-bar a { color:#c26a10; font-weight:600; text-decoration:none; }
        .urgency-bar a:hover { text-decoration:underline; }

        /* ══ NAVBAR ═══════════════════════════════════════════════════ */
        .navbar-main {
            background: var(--white);
            border-bottom: 1px solid var(--border);
            padding: 0 3rem;
            height: 64px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: sticky;
            top: 0;
            z-index: 100;
        }
        .nav-brand {
            font-size: 1.15rem;
            font-weight: 800;
            color: var(--text-dark);
            text-decoration: none;
            letter-spacing: -.02em;
        }
        .nav-links { display:flex; align-items:center; gap:2rem; }
        .nav-links a {
            font-size: .88rem;
            font-weight: 500;
            color: var(--text-mid);
            text-decoration: none;
            transition: color .2s;
        }
        .nav-links a:hover, .nav-links a.active { color:var(--green-dark); }
        .nav-actions { display:flex; align-items:center; gap:.8rem; }
        .btn-ghost {
            background: transparent;
            border: 1.5px solid var(--border);
            color: var(--text-dark);
            font-size: .82rem;
            font-weight: 600;
            padding: .45rem 1.1rem;
            border-radius: 50px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: .4rem;
            transition: all .2s;
        }
        .btn-ghost:hover { border-color:var(--green); color:var(--green-dark); }
        .btn-primary-nav {
            background: var(--green);
            color: var(--white);
            font-size: .82rem;
            font-weight: 600;
            padding: .5rem 1.2rem;
            border-radius: 50px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: .4rem;
            transition: all .2s;
        }
        .btn-primary-nav:hover { background:var(--green-dark); color:var(--white); }

        /* ══ PAGE HERO STRIP ═══════════════════════════════════════════ */
        .page-hero {
            background: linear-gradient(135deg, var(--green-dark) 0%, var(--green) 100%);
            padding: 3rem 3rem 2.5rem;
            position: relative;
            overflow: hidden;
        }
        .page-hero::after {
            content: '';
            position: absolute;
            right: -60px; top: -60px;
            width: 320px; height: 320px;
            background: rgba(255,255,255,.07);
            border-radius: 50%;
        }
        .page-hero-inner {
            max-width: 900px;
            margin: 0 auto;
            position: relative;
            z-index: 1;
        }
        .page-hero .breadcrumb-row {
            display: flex;
            align-items: center;
            gap: .5rem;
            margin-bottom: 1rem;
            font-size: .75rem;
            color: rgba(255,255,255,.65);
        }
        .page-hero .breadcrumb-row a { color:rgba(255,255,255,.65); text-decoration:none; }
        .page-hero .breadcrumb-row a:hover { color:#fff; }
        .page-hero .breadcrumb-row i { font-size: .6rem; }
        .page-hero h1 {
            font-size: clamp(1.6rem,3.5vw,2.4rem);
            font-weight: 800;
            color: #fff;
            margin-bottom: .5rem;
            letter-spacing: -.03em;
        }
        .page-hero p {
            color: rgba(255,255,255,.8);
            font-size: .92rem;
            max-width: 520px;
            line-height: 1.6;
        }

        /* ══ MAIN CONTENT ═════════════════════════════════════════════ */
        .page-body {
            flex: 1;
            padding: 2.5rem 3rem 4rem;
        }
        .content-wrap {
            max-width: 900px;
            margin: 0 auto;
        }

        /* ══ SEARCH CARD ══════════════════════════════════════════════ */
        .search-card {
            background: var(--white);
            border-radius: var(--radius);
            border: 1px solid var(--border);
            box-shadow: var(--shadow);
            padding: 2rem 2.5rem;
            margin-bottom: 2rem;
        }
        .search-card .card-label {
            font-size: .72rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: .1em;
            color: var(--text-light);
            margin-bottom: .5rem;
        }
        .search-card h2 {
            font-size: 1.2rem;
            font-weight: 800;
            color: var(--text-dark);
            margin-bottom: 1.4rem;
            letter-spacing: -.02em;
        }
        .search-form-row {
            display: flex;
            gap: .8rem;
            align-items: flex-end;
        }
        .search-field-wrap {
            flex: 1;
        }
        .search-field-wrap label {
            display: block;
            font-size: .73rem;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: .4rem;
            text-transform: uppercase;
            letter-spacing: .03em;
        }
        .search-input-group {
            position: relative;
        }
        .search-input-group i {
            position: absolute;
            left: .9rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-light);
            font-size: .85rem;
            pointer-events: none;
        }
        .search-input {
            width: 100%;
            padding: .7rem .9rem .7rem 2.4rem;
            border: 1.5px solid var(--border);
            border-radius: var(--radius-sm);
            font-family: 'Inter', sans-serif;
            font-size: .9rem;
            background: var(--gray-bg);
            color: var(--text-dark);
            transition: all .2s;
            outline: none;
        }
        .search-input:focus {
            border-color: var(--green);
            box-shadow: 0 0 0 3px rgba(106,158,138,.12);
            background: #fff;
        }
        .search-input::placeholder { color: var(--text-light); }
        .btn-buscar {
            display: inline-flex;
            align-items: center;
            gap: .55rem;
            background: var(--green-dark);
            color: #fff;
            font-size: .88rem;
            font-weight: 700;
            padding: .72rem 1.6rem;
            border-radius: var(--radius-sm);
            border: none;
            cursor: pointer;
            transition: all .2s;
            white-space: nowrap;
        }
        .btn-buscar:hover {
            background: var(--text-dark);
            transform: translateY(-1px);
            box-shadow: 0 6px 18px rgba(26,46,38,.2);
        }
        .search-hint {
            margin-top: .8rem;
            font-size: .78rem;
            color: var(--text-light);
            display: flex;
            align-items: center;
            gap: .4rem;
        }

        /* ══ ESTADO BADGES ════════════════════════════════════════════ */
        .badge-estado {
            display: inline-flex;
            align-items: center;
            gap: .35rem;
            font-size: .72rem;
            font-weight: 700;
            padding: .28rem .75rem;
            border-radius: 50px;
            text-transform: uppercase;
            letter-spacing: .04em;
        }
        .badge-estado::before {
            content: '';
            width: 6px; height: 6px;
            border-radius: 50%;
        }
        .estado-PENDIENTE  { background:#fffbeb; color:#92400e; border:1px solid #fde68a; }
        .estado-PENDIENTE::before  { background:#f59e0b; }
        .estado-CONFIRMADA { background:#ecfdf5; color:#065f46; border:1px solid #6ee7b7; }
        .estado-CONFIRMADA::before { background:#10b981; }
        .estado-ATENDIDA   { background:#eff6ff; color:#1e40af; border:1px solid #93c5fd; }
        .estado-ATENDIDA::before   { background:#3b82f6; }
        .estado-CANCELADA  { background:#fef2f2; color:#991b1b; border:1px solid #fca5a5; }
        .estado-CANCELADA::before  { background:#ef4444; }

        /* ══ RESULTADO — PACIENTE INFO ════════════════════════════════ */
        .result-section { animation: fadeSlide .35s ease both; }
        @keyframes fadeSlide {
            from { opacity:0; transform:translateY(12px); }
            to   { opacity:1; transform:translateY(0); }
        }
        .result-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 1.2rem;
        }
        .result-header h3 {
            font-size: 1rem;
            font-weight: 700;
            color: var(--text-dark);
            display: flex;
            align-items: center;
            gap: .5rem;
        }
        .result-header .count-badge {
            background: var(--green-pale);
            color: var(--green-dark);
            font-size: .72rem;
            font-weight: 700;
            padding: .2rem .6rem;
            border-radius: 50px;
        }

        /* Tarjeta paciente */
        .paciente-card {
            background: var(--white);
            border-radius: var(--radius);
            border: 1px solid var(--border);
            padding: 1.3rem 1.6rem;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 1.2rem;
            box-shadow: var(--shadow);
        }
        .pac-avatar {
            width: 52px; height: 52px;
            background: linear-gradient(135deg, var(--green-dark), var(--green));
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-size: 1.3rem;
            flex-shrink: 0;
        }
        .pac-info h4 {
            font-size: 1rem;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: .2rem;
        }
        .pac-meta {
            display: flex;
            align-items: center;
            gap: 1.2rem;
            flex-wrap: wrap;
        }
        .pac-meta span {
            font-size: .78rem;
            color: var(--text-mid);
            display: flex;
            align-items: center;
            gap: .3rem;
        }
        .pac-meta i { color: var(--text-light); font-size: .72rem; }

        /* ══ CITAS GRID ════════════════════════════════════════════════ */
        .citas-grid {
            display: grid;
            grid-template-columns: 1fr;
            gap: 1rem;
        }
        .cita-card {
            background: var(--white);
            border-radius: var(--radius);
            border: 1px solid var(--border);
            box-shadow: var(--shadow);
            overflow: hidden;
            transition: all .25s;
        }
        .cita-card:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-lg);
            border-color: var(--green-light);
        }
        .cita-card-inner {
            display: grid;
            grid-template-columns: 90px 1fr auto;
            gap: 0;
        }

        /* Fecha columna */
        .cita-fecha-col {
            background: var(--green-pale);
            border-right: 1px solid var(--border);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 1.2rem .8rem;
            text-align: center;
        }
        .cita-fecha-col .cf-mes {
            font-size: .65rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: .1em;
            color: var(--green-dark);
            margin-bottom: .1rem;
        }
        .cita-fecha-col .cf-dia {
            font-size: 2rem;
            font-weight: 800;
            color: var(--text-dark);
            line-height: 1;
            letter-spacing: -.03em;
        }
        .cita-fecha-col .cf-hora {
            font-size: .7rem;
            font-weight: 600;
            color: var(--text-mid);
            margin-top: .3rem;
            background: rgba(106,158,138,.15);
            padding: .1rem .4rem;
            border-radius: 50px;
        }

        /* Info columna */
        .cita-info-col {
            padding: 1.1rem 1.3rem;
        }
        .cita-info-col .ci-esp {
            font-size: .78rem;
            font-weight: 600;
            color: var(--green-dark);
            text-transform: uppercase;
            letter-spacing: .06em;
            margin-bottom: .35rem;
        }
        .cita-info-col h4 {
            font-size: .95rem;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: .5rem;
        }
        .cita-detail-row {
            display: flex;
            align-items: center;
            gap: 1.2rem;
            flex-wrap: wrap;
        }
        .cita-detail-row .cd-item {
            font-size: .78rem;
            color: var(--text-mid);
            display: flex;
            align-items: center;
            gap: .3rem;
        }
        .cita-detail-row .cd-item i { color:var(--text-light); font-size:.7rem; }

        /* Acciones columna */
        .cita-actions-col {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            justify-content: space-between;
            padding: 1.1rem 1.3rem;
            border-left: 1px solid var(--border);
            gap: .6rem;
            min-width: 120px;
        }
        .btn-pdf-cita {
            display: inline-flex;
            align-items: center;
            gap: .35rem;
            font-size: .75rem;
            font-weight: 600;
            color: var(--green-dark);
            border: 1.5px solid var(--green);
            background: transparent;
            padding: .35rem .8rem;
            border-radius: 50px;
            text-decoration: none;
            transition: all .2s;
            white-space: nowrap;
        }
        .btn-pdf-cita:hover { background:var(--green); color:#fff; }
        .cita-id {
            font-size: .68rem;
            color: var(--text-light);
            font-weight: 500;
        }

        /* ══ ESTADO VACÍO / ERROR ══════════════════════════════════════ */
        .state-card {
            background: var(--white);
            border-radius: var(--radius);
            border: 1px solid var(--border);
            box-shadow: var(--shadow);
            padding: 3rem 2rem;
            text-align: center;
            animation: fadeSlide .35s ease both;
        }
        .state-icon {
            width: 72px; height: 72px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
            margin: 0 auto 1.2rem;
        }
        .state-icon.warn  { background:#fff8f0; color:#e07a20; }
        .state-icon.info  { background:var(--green-pale); color:var(--green-dark); }
        .state-icon.error { background:#fef2f2; color:#dc2626; }
        .state-card h3 {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: .5rem;
        }
        .state-card p {
            font-size: .88rem;
            color: var(--text-mid);
            line-height: 1.6;
            max-width: 440px;
            margin: 0 auto 1.5rem;
        }
        .state-contact-box {
            display: inline-flex;
            align-items: center;
            gap: .9rem;
            background: var(--gray-bg);
            border: 1px solid var(--border);
            border-radius: var(--radius-sm);
            padding: .8rem 1.4rem;
            margin-top: .5rem;
        }
        .state-contact-box .sc-icon {
            width: 36px; height: 36px;
            background: var(--green-pale);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--green-dark);
            font-size: .9rem;
            flex-shrink: 0;
        }
        .state-contact-box .sc-text strong {
            display: block;
            font-size: .82rem;
            font-weight: 700;
            color: var(--text-dark);
        }
        .state-contact-box .sc-text small { font-size: .75rem; color: var(--text-light); }
        .btn-volver {
            display: inline-flex;
            align-items: center;
            gap: .5rem;
            background: var(--green);
            color: #fff;
            font-size: .85rem;
            font-weight: 700;
            padding: .65rem 1.4rem;
            border-radius: 50px;
            text-decoration: none;
            transition: all .2s;
            border: none;
            cursor: pointer;
        }
        .btn-volver:hover { background:var(--green-dark); color:#fff; }
        .btn-nueva-busqueda {
            display: inline-flex;
            align-items: center;
            gap: .5rem;
            background: transparent;
            color: var(--green-dark);
            font-size: .85rem;
            font-weight: 600;
            padding: .65rem 1.4rem;
            border-radius: 50px;
            text-decoration: none;
            border: 1.5px solid var(--green);
            cursor: pointer;
            transition: all .2s;
        }
        .btn-nueva-busqueda:hover { background: var(--green-pale); }

        /* ══ FOOTER ════════════════════════════════════════════════════ */
        footer {
            background: var(--white);
            border-top: 1px solid var(--border);
            padding: 1.2rem 3rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        footer small { font-size:.75rem; color:var(--text-light); }
        .footer-links { display:flex; gap:1.2rem; }
        .footer-links a { font-size:.75rem; color:var(--text-light); text-decoration:none; }
        .footer-links a:hover { color:var(--green-dark); }

        /* ══ RESPONSIVE ════════════════════════════════════════════════ */
        @media (max-width: 768px) {
            .navbar-main  { padding: 0 1.2rem; }
            .nav-links    { display: none; }
            .page-hero    { padding: 2rem 1.2rem; }
            .page-body    { padding: 1.5rem 1.2rem 3rem; }
            .search-card  { padding: 1.4rem; }
            .search-form-row { flex-direction: column; gap: .8rem; }
            .btn-buscar   { width: 100%; justify-content: center; }
            .cita-card-inner {
                grid-template-columns: 72px 1fr;
            }
            .cita-actions-col {
                grid-column: 1 / -1;
                flex-direction: row;
                border-left: none;
                border-top: 1px solid var(--border);
                padding: .8rem 1rem;
                align-items: center;
            }
            footer { flex-direction: column; gap: .6rem; text-align: center; }
        }
    </style>
</head>

<body>

<!-- ═══ URGENCY BAR ═══ -->
<div class="urgency-bar">
    <i class="fas fa-exclamation-circle"></i>
    <strong><fmt:message key="consulta.urgency"/></strong>
    <fmt:message key="consulta.urgency.detail"/> <a href="tel:8001234567">800-123-4567</a> <fmt:message key="consulta.urgency.suffix"/>
</div>

<!-- ═══ NAVBAR ═══ -->
<nav class="navbar-main">
    <a class="nav-brand" href="${pageContext.request.contextPath}/">SaludBoyacá</a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/#especialidades"><fmt:message key="consulta.specialties"/></a>
        <a href="${pageContext.request.contextPath}/#medicos"><fmt:message key="consulta.our.team"/></a>
        <a href="#"><fmt:message key="consulta.articles"/></a>
        <a href="#"><fmt:message key="consulta.contact"/></a>
    </div>
    <div class="nav-actions">
        <a href="${pageContext.request.contextPath}/" class="btn-primary-nav">
            <i class="fas fa-home"></i> <fmt:message key="consulta.home.link"/>
        </a>
        <a href="${pageContext.request.contextPath}/login" class="btn-ghost">
            <i class="fas fa-user"></i> <fmt:message key="consulta.login"/>
        </a>
        <c:if test="${not empty citas}">
            <button onclick="window.print()" class="btn-ghost" title="<fmt:message key='nav.export.pdf'/>">
                <i class="fas fa-file-pdf"></i> <fmt:message key="nav.export.pdf"/>
            </button>
        </c:if>
    </div>
</nav>

<!-- ═══ PAGE HERO ═══ -->
<div class="page-hero">
    <div class="page-hero-inner">
        <div class="breadcrumb-row">
            <a href="${pageContext.request.contextPath}/"><i class="fas fa-home"></i> <fmt:message key="consulta.breadcrumb.home"/></a>
            <i class="fas fa-chevron-right"></i>
            <span><fmt:message key="consulta.breadcrumb"/></span>
        </div>
        <h1><i class="fas fa-calendar-search" style="font-size:.85em;margin-right:.4rem;opacity:.85"></i><fmt:message key="consulta.title"/></h1>
        <p><fmt:message key="consulta.subtitle"/></p>
    </div>
</div>

<!-- ═══ CONTENIDO PRINCIPAL ═══ -->
<div class="page-body">
    <div class="content-wrap">

        <!-- ─── FORMULARIO DE BÚSQUEDA ─── -->
        <div class="search-card">
            <div class="card-label"><fmt:message key="consulta.portal"/></div>
            <h2><fmt:message key="consulta.search.title"/></h2>

            <form action="${pageContext.request.contextPath}/consulta_cita" method="POST">
                <div class="search-form-row">
                    <div class="search-field-wrap">
                        <label for="documento"><i class="fas fa-id-card" style="margin-right:.3rem;color:var(--text-light)"></i><fmt:message key="consulta.doc.label"/></label>
                        <div class="search-input-group">
                            <i class="fas fa-fingerprint"></i>
                            <input
                                type="text"
                                id="documento"
                                name="documento"
                                class="search-input"
                                placeholder="<fmt:message key='consulta.doc.placeholder'/>"
                                value="${param.documento}"
                                required
                                autocomplete="off"
                                inputmode="numeric"
                                pattern="[0-9]+"
                                maxlength="20"
                            >
                        </div>
                    <div class="g-recaptcha" data-sitekey="6LezKbssAAAAAPstG5OjqTLI-BZvU4cZQydrApDm" style="margin-top:.5rem;"></div>
                    <button type="submit" class="btn-buscar">
                        <i class="fas fa-search"></i> <fmt:message key="consulta.btn.search"/>
                    </button>
                    </div>
                    
                </div>
                <div class="search-hint">
                    <i class="fas fa-lock"></i>
                    <fmt:message key="consulta.security.hint"/>
                </div>
            </form>
        </div><!-- /search-card -->


        <%-- ════════════════════════════════════════════════════════════
             CASO 1: El paciente NO está registrado en el sistema
             El servlet pone attribute "noRegistrado" = true
        ═══════════════════════════════════════════════════════════════ --%>
        <c:if test="${noRegistrado == true}">
            <div class="state-card result-section">
                <div class="state-icon error">
                    <i class="fas fa-user-times"></i>
                </div>
                <h3><fmt:message key="consulta.not.found.title"/></h3>
                <p>
                    <fmt:message key="consulta.not.registered.doc">
                        <fmt:param><strong>${param.documento}</strong></fmt:param>
                    </fmt:message>
                </p>
                <div class="state-contact-box">
                    <div class="sc-icon"><i class="fas fa-map-marker-alt"></i></div>
                    <div class="sc-text">
                        <strong><fmt:message key="consulta.register.in.person"/></strong>
                        <small><fmt:message key="consulta.register.address"/></small>
                    </div>
                </div>
                <div style="margin-top:1.5rem; display:flex; gap:.8rem; justify-content:center; flex-wrap:wrap;">
                    <a href="${pageContext.request.contextPath}/consulta_cita" class="btn-nueva-busqueda">
                        <i class="fas fa-redo"></i> <fmt:message key="consulta.new.search"/>
                    </a>
                    <a href="${pageContext.request.contextPath}/" class="btn-volver">
                        <i class="fas fa-home"></i> <fmt:message key="consulta.back.home"/>
                    </a>
                </div>
            </div>
        </c:if>


        <%-- ════════════════════════════════════════════════════════════
             CASO 2: Paciente registrado, pero SIN citas agendadas
             El servlet pone attribute "sinCitas" = true  y  "paciente"
        ═══════════════════════════════════════════════════════════════ --%>
        <c:if test="${sinCitas == true}">
            <div class="result-section">
                <!-- Tarjeta del paciente: datos enviados por el servlet -->
                <div class="paciente-card">
                    <div class="pac-avatar">
                        <i class="fas fa-user-circle"></i>
                    </div>
                    <div class="pac-info">
                        <h4>${pacienteNombre} ${pacienteApellido}</h4>
                        <div class="pac-meta">
                            <span><i class="fas fa-id-card"></i> Doc. ${documentoBuscado}</span>
                        </div>
                    </div>
                </div>

                <!-- Sin citas -->
                <div class="state-card">
                    <div class="state-icon info">
                        <i class="fas fa-calendar-times"></i>
                    </div>
                    <h3><fmt:message key="consulta.no.appointments.title"/></h3>
                    <p>
                        ${msg["consulta.no.appointments.msg"]}
                    </p>
                    <div class="state-contact-box">
                        <div class="sc-icon"><i class="fas fa-phone-alt"></i></div>
                        <div class="sc-text">
                            <strong><fmt:message key="consulta.schedule.by.phone"/></strong>
                            <small><fmt:message key="consulta.phone.hours"/></small>
                        </div>
                    </div>
                    <div style="margin-top:1.5rem; display:flex; gap:.8rem; justify-content:center; flex-wrap:wrap;">
                        <a href="${pageContext.request.contextPath}/consulta_cita" class="btn-nueva-busqueda">
                            <i class="fas fa-redo"></i> ${msg["consulta.new.search.btn"]}
                        </a>
                        <a href="${pageContext.request.contextPath}/" class="btn-volver">
                            <i class="fas fa-home"></i> Volver al inicio
                        </a>
                    </div>
                </div>
            </div>
        </c:if>


        <%-- ════════════════════════════════════════════════════════════
             CASO 3: Paciente registrado, CON citas
             El servlet pone "citas" (List<Cita>) y "paciente" (Paciente)
        ═══════════════════════════════════════════════════════════════ --%>
        <c:if test="${not empty citas}">
            <div class="result-section">

                <!-- Tarjeta paciente: datos tomados de la primera cita -->
                <c:set var="c0" value="${citas[0]}" />
                <div class="paciente-card">
                    <div class="pac-avatar">
                        <i class="fas fa-user-circle"></i>
                    </div>
                    <div class="pac-info">
                        <h4>${c0.pacienteNombre} ${c0.pacienteApellido}</h4>
                        <div class="pac-meta">
                            <span><i class="fas fa-id-card"></i> Doc. ${c0.documento}</span>
                        </div>
                    </div>
                </div>

                <!-- Encabezado lista -->
                <div class="result-header">
                    <h3>
                        <i class="fas fa-calendar-alt" style="color:var(--green)"></i>
                        <fmt:message key="consulta.your.appointments"/>
                    </h3>
                    <span class="count-badge">${fn:length(citas)} cita(s) encontrada(s)</span>
                </div>

                <!-- Grid de citas -->
                <div class="citas-grid">
                    <c:forEach var="cita" items="${citas}">
                        <div class="cita-card">
                            <div class="cita-card-inner">

                                <!-- Columna fecha -->
                                <div class="cita-fecha-col">
                                    <fmt:formatDate var="mes"  value="${cita.fechaCita}" pattern="MMM"  />
                                    <fmt:formatDate var="dia"  value="${cita.fechaCita}" pattern="dd"   />
                                    <div class="cf-mes">${mes}</div>
                                    <div class="cf-dia">${dia}</div>
                                    <div class="cf-hora">
                                        ${cita.horaCita}
                                    </div>
                                </div>

                                <!-- Columna info -->
                                <div class="cita-info-col">
    <div class="ci-esp">
        <i class="fas fa-stethoscope"></i>
        ${cita.especialidad}
    </div>

    <h4>${not empty cita.motivo ? cita.motivo : msg['consulta.default.reason']}</h4>

    <div class="cita-detail-row">

        <span class="cd-item">
            <i class="fas fa-user-md"></i>
            Dr. ${cita.medicoNombre} ${cita.medicoApellido}
        </span>

        <c:if test="${not empty cita.observaciones}">
            <span class="cd-item">
                <i class="fas fa-sticky-note"></i>
                ${cita.observaciones}
            </span>
        </c:if>



    </div>
</div>

                                <!-- Columna acciones -->
                                <div class="cita-actions-col">
                                    <span class="badge-estado estado-${cita.estado}">
                                        ${cita.estado}
                                    </span>
                                    <a href="${pageContext.request.contextPath}/consulta_cita?accion=pdf&id=${cita.idCita}"
                                       class="btn-pdf-cita" title="Descargar comprobante PDF">
                                        <i class="fas fa-file-pdf"></i> <fmt:message key="consulta.voucher"/>
                                    </a>
                                    <span class="cita-id">Cita #${cita.idCita}</span>
                                </div>

                            </div>
                        </div>
                    </c:forEach>
                </div><!-- /citas-grid -->

                <!-- Botones inferiores -->
                <div style="margin-top:1.8rem; display:flex; gap:.8rem; flex-wrap:wrap;">
                    <a href="${pageContext.request.contextPath}/consulta_cita" class="btn-nueva-busqueda">
                        <i class="fas fa-redo"></i> <fmt:message key="consulta.new.search"/>
                    </a>
                    <a href="${pageContext.request.contextPath}/" class="btn-volver">
                        <i class="fas fa-home"></i> <fmt:message key="consulta.back.home"/>
                    </a>
                </div>

            </div>
        </c:if>


        <%-- ════════════════════════════════════════════════════════════
             Error de captcha u otro error genérico del servlet
        ═══════════════════════════════════════════════════════════════ --%>
        <c:if test="${not empty error and noRegistrado != true and sinCitas != true and empty citas}">
            <div class="state-card result-section">
                <div class="state-icon warn">
                    <i class="fas fa-exclamation-triangle"></i>
                </div>
                <h3><fmt:message key="consulta.attention"/></h3>
                <p>${error}</p>
                <a href="${pageContext.request.contextPath}/consulta_cita" class="btn-nueva-busqueda">
                    <i class="fas fa-redo"></i> <fmt:message key="consulta.try.again"/>
                </a>
            </div>
        </c:if>

    </div><!-- /content-wrap -->
</div><!-- /page-body -->

<!-- ═══ FOOTER ═══ -->
<footer>
    <small><fmt:message key="consulta.footer"/></small>
    <div class="footer-links">
        <a href="#"><fmt:message key="consulta.privacy"/></a>
        <a href="#"><fmt:message key="consulta.terms"/></a>
        <a href="${pageContext.request.contextPath}/#especialidades"><fmt:message key="consulta.specialties"/></a>
    </div>
</footer>
<script src="https://www.google.com/recaptcha/api.js" async defer></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    /* Solo permitir dígitos en el campo documento */
    document.getElementById('documento').addEventListener('input', function () {
        this.value = this.value.replace(/\D/g, '');
    });
</script>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="${not empty sessionScope.lang ? sessionScope.lang : 'es'}"/>
<fmt:setBundle basename="messages"/>

<%-- ── IMPORTAR OVERRIDES GLOBALES (una sola vez, en el header) ── --%>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">

<style>
  /* ── Reset & base ── */
  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
  body {
    font-family: 'Plus Jakarta Sans', 'Segoe UI', sans-serif !important;
    background: #f0f7f4 !important;
    -webkit-font-smoothing: antialiased;
  }

  /* ══ TOP HEADER — verde oscuro exacto como imagen ══ */
  .top-header {
    background: #2d5a47;
    height: 56px;
    display: flex;
    align-items: center;
    padding: 0 1.25rem;
    gap: 1rem;
    position: sticky;
    top: 0;
    z-index: 1100;
    box-shadow: 0 2px 8px rgba(0,0,0,.18);
  }

  /* Brand */
  .th-brand {
    display: flex; align-items: center; gap: .5rem;
    text-decoration: none; flex-shrink: 0;
  }
  .th-brand-icon { color: #fff; font-size: 1rem; }
  .th-brand-name { font-size: .93rem; font-weight: 800; color: #fff; letter-spacing: -.01em; }

  /* Nav links */
  .th-nav { display: flex; align-items: center; gap: .1rem; margin-left: 1.25rem; flex: 1; }
  .th-nav-item {
    display: flex; align-items: center; gap: .38rem;
    padding: .35rem .82rem;
    color: rgba(255,255,255,.78);
    font-size: .81rem; font-weight: 500;
    text-decoration: none; border-radius: 7px;
    transition: background .15s, color .15s;
    white-space: nowrap;
  }
  .th-nav-item:hover  { background: rgba(255,255,255,.10); color: #fff; }
  .th-nav-item.active { background: rgba(255,255,255,.15); color: #fff; font-weight: 700; }
  .th-nav-item i { font-size: .76rem; }

  /* Right side */
  .th-right { display: flex; align-items: center; gap: .55rem; margin-left: auto; }

  /* Language */
  .th-lang-wrapper { position: relative; }
  .th-lang-btn {
    display: flex; align-items: center; gap: .3rem;
    padding: .28rem .65rem;
    background: rgba(255,255,255,.10); border: 1px solid rgba(255,255,255,.2);
    border-radius: 7px; color: #fff; font-size: .76rem; font-weight: 500;
    cursor: pointer; font-family: inherit;
  }
  .th-lang-btn:hover { background: rgba(255,255,255,.18); }
  .th-lang-dropdown {
    position: absolute; top: calc(100% + 6px); right: 0;
    background: #fff; border-radius: 10px;
    box-shadow: 0 8px 24px rgba(0,0,0,.15);
    padding: .4rem; min-width: 128px; display: none; z-index: 9999;
  }
  .th-lang-dropdown.open { display: block; }
  .th-lang-opt {
    display: block; padding: .38rem .65rem; border-radius: 7px;
    font-size: .78rem; color: #2d5a47; text-decoration: none; font-weight: 500;
  }
  .th-lang-opt:hover { background: #e8f2ee; }

  /* User info */
  .th-user { display: flex; align-items: center; gap: .45rem; }
  .th-user-name { font-size: .8rem; font-weight: 700; color: #fff; line-height: 1.1; }
  .th-user-role {
    font-size: .6rem; font-weight: 700; color: #2d5a47; background: #d4edda;
    padding: .1em .5em; border-radius: 20px; text-transform: uppercase;
    letter-spacing: .04em; display: block; margin-top: .08rem;
  }
  .th-user-avatar {
    width: 30px; height: 30px; border-radius: 7px;
    background: rgba(255,255,255,.18); border: 2px solid rgba(255,255,255,.28);
    display: flex; align-items: center; justify-content: center;
    color: #fff; font-size: .82rem; flex-shrink: 0;
  }
  .th-logout {
    display: flex; align-items: center; justify-content: center;
    width: 30px; height: 30px;
    background: rgba(255,255,255,.10); border: 1px solid rgba(255,255,255,.2);
    border-radius: 7px; color: rgba(255,255,255,.78); text-decoration: none;
    font-size: .82rem; transition: all .15s;
  }
  .th-logout:hover { background: rgba(255,80,80,.28); color: #fff; }

  /* ══ OVERRIDES — neutralizar amarillos/naranjas/negros ══ */

  /* Formularios */
  .form-label {
    color: #4a6258 !important;
    font-weight: 600 !important;
    font-size: .82rem !important;
  }
  .form-control, .form-select {
    border-color: #dce9e4 !important;
    border-radius: 10px !important;
    color: #1a2e26 !important;
    background: #fafcfa !important;
    font-size: .9rem;
  }
  .form-control:focus, .form-select:focus {
    border-color: #6a9e8a !important;
    box-shadow: 0 0 0 .2rem rgba(106,158,138,.18) !important;
    background: #fff !important;
  }
  .form-control::placeholder { color: #7a9a8e !important; }
  textarea.form-control { min-height: 80px; resize: vertical; }

  /* Botones — eliminar amarillo */
  .btn-warning, .btn-warning.rounded-pill {
    background: #4d7a68 !important;
    border-color: #4d7a68 !important;
    color: #fff !important;
  }
  .btn-warning:hover {
    background: #6a9e8a !important;
    border-color: #6a9e8a !important;
  }
  .btn-success {
    background: linear-gradient(135deg, #4d7a68, #6a9e8a) !important;
    border: none !important;
    color: #fff !important;
    box-shadow: 0 4px 12px rgba(74,120,100,.25) !important;
    transition: all .25s !important;
  }
  .btn-success:hover {
    transform: translateY(-2px) !important;
    box-shadow: 0 8px 20px rgba(74,120,100,.35) !important;
  }
  .btn-outline-secondary {
    color: #4a6258 !important;
    border-color: #dce9e4 !important;
  }
  .btn-outline-secondary:hover {
    background: #e8f2ee !important;
    border-color: #6a9e8a !important;
    color: #4d7a68 !important;
  }

  /* Headers de páginas — eliminar amarillo/naranja */
  .form-header, .page-header {
    background: linear-gradient(135deg, #4d7a68, #6a9e8a) !important;
    color: #fff !important;
  }

  /* Tabla */
  .table thead.table-light th {
    background: #e8f2ee !important;
    color: #4a6258 !important;
    border-bottom: 2px solid #dce9e4 !important;
    font-size: .71rem; font-weight: 700;
    text-transform: uppercase; letter-spacing: .06em;
  }
  .table-hover tbody tr:hover td { background: rgba(232,242,238,.5) !important; }
  .table td { color: #1a2e26 !important; }

  /* Cards */
  .page-card, .form-card, .detail-card { border: 1px solid #dce9e4 !important; }

  /* Badges estado */
  .badge-estado.estado-PROGRAMADA { background: #eef8f0 !important; color: #2d7a4a !important; border: 1px solid #b3ddc0 !important; }
  .badge-estado.estado-CONFIRMADA { background: #e0f5eb !important; color: #1a6640 !important; border: 1px solid #89d4a8 !important; }
  .badge-estado.estado-CANCELADA  { background: #fef0f0 !important; color: #9a2020 !important; border: 1px solid #f5b8b8 !important; }
  .badge-estado.estado-ATENDIDA,
  .badge-estado.estado-COMPLETADA { background: #e8f2ee !important; color: #4d7a68 !important; border: 1px solid #8fbdaa !important; }
  .badge-estado.estado-PENDIENTE  { background: #fff8e1 !important; color: #9a7200 !important; border: 1px solid #f0d080 !important; }

  /* Sidebar — eliminar amarillos */
  .sb-icon[style*="fef9e7"], .sb-icon[style*="b7950b"],
  .sb-icon[style*="fdebd0"], .sb-icon[style*="ca6f1e"],
  .sb-icon[style*="f3eefa"], .sb-icon[style*="6c3483"] {
    background: #e8f2ee !important;
    color: #4d7a68 !important;
  }

  /* Alert warning → verde */
  .alert-warning {
    background: #e8f2ee !important;
    border-color: #8fbdaa !important;
    color: #4d7a68 !important;
  }

  /* Scrollbar */
  ::-webkit-scrollbar { width: 5px; height: 5px; }
  ::-webkit-scrollbar-track { background: transparent; }
  ::-webkit-scrollbar-thumb { background: #e8f2ee; border-radius: 3px; }
  ::-webkit-scrollbar-thumb:hover { background: #6a9e8a; }

  /* Botones acción en citas */
  .btn-accion.btn-editar    { background: linear-gradient(135deg, #4d7a68, #6a9e8a) !important; }
  .btn-accion.btn-confirmar { background: linear-gradient(135deg, #1a6640, #2d9e60) !important; }
  .btn-accion.btn-completar { background: linear-gradient(135deg, #155228, #1e7a40) !important; }

  /* Día badges horarios */
  .dia-badge { background: #e8f2ee !important; color: #4d7a68 !important; }
  .time-range { color: #4d7a68 !important; }

  @media (max-width: 768px) {
    .th-nav { display: none; }
    .th-user-name, .th-user-role { display: none; }
  }
</style>

<header class="top-header">
  <a href="${pageContext.request.contextPath}/dashboard" class="th-brand">
    <i class="fas fa-heartbeat th-brand-icon"></i>
    <span class="th-brand-name">SaludBoyacá</span>
  </a>

  <nav class="th-nav">
    <a href="${pageContext.request.contextPath}/dashboard"
       class="th-nav-item ${activePage == 'dashboard' ? 'active' : ''}">
      <i class="fas fa-th-large"></i> <fmt:message key="header.home"/>
    </a>
    <c:if test="${sessionScope.usuarioRol == 'MEDICO' || sessionScope.usuarioRol == 'RECEPCIONISTA'}">
      <a href="${pageContext.request.contextPath}/pacientes"
         class="th-nav-item ${activePage == 'pacientes' ? 'active' : ''}">
        <i class="fas fa-user-injured"></i> <fmt:message key="header.patients"/>
      </a>
    </c:if>
    <a href="${pageContext.request.contextPath}/citas"
       class="th-nav-item ${activePage == 'citas' ? 'active' : ''}">
      <i class="fas fa-calendar-check"></i> Citas
    </a>
    <c:if test="${sessionScope.usuarioRol == 'MEDICO' || sessionScope.usuarioRol == 'RECEPCIONISTA'}">
      <a href="${pageContext.request.contextPath}/horarios"
         class="th-nav-item ${activePage == 'horarios' ? 'active' : ''}">
        <i class="fas fa-clock"></i> <fmt:message key="header.schedules"/>
      </a>
    </c:if>
  </nav>

  <div class="th-right">
    <div class="th-lang-wrapper">
      <button class="th-lang-btn" id="langToggle">
        <i class="fas fa-globe"></i>
        <c:choose>
          <c:when test="${sessionScope.lang == 'en'}">EN</c:when>
          <c:when test="${sessionScope.lang == 'it'}">IT</c:when>
          <c:otherwise>ES</c:otherwise>
        </c:choose>
        <i class="fas fa-chevron-down" style="font-size:.58rem;"></i>
      </button>
      <div class="th-lang-dropdown" id="langDropdown">
        <a class="th-lang-opt" href="${pageContext.request.contextPath}/dashboard?lang=es">🇨🇴 Español</a>
        <a class="th-lang-opt" href="${pageContext.request.contextPath}/dashboard?lang=en">🇺🇸 English</a>
        <a class="th-lang-opt" href="${pageContext.request.contextPath}/dashboard?lang=it">🇮🇹 Italiano</a>
      </div>
    </div>

    <div class="th-user">
      <div>
        <div class="th-user-name">${sessionScope.usuarioNombre}</div>
        <span class="th-user-role">${sessionScope.usuarioRol}</span>
      </div>
      <div class="th-user-avatar">
        <c:choose>
          <c:when test="${sessionScope.usuarioRol == 'MEDICO'}"><i class="fas fa-user-md"></i></c:when>
          <c:when test="${sessionScope.usuarioRol == 'RECEPCIONISTA'}"><i class="fas fa-concierge-bell"></i></c:when>
          <c:otherwise><i class="fas fa-user-nurse"></i></c:otherwise>
        </c:choose>
      </div>
    </div>

    <a href="${pageContext.request.contextPath}/logout" class="th-logout" title="<fmt:message key='dashboard.logout'/>">
      <i class="fas fa-sign-out-alt"></i>
    </a>
  </div>
</header>

<script>
  document.getElementById('langToggle').addEventListener('click', function(e) {
    e.stopPropagation();
    document.getElementById('langDropdown').classList.toggle('open');
  });
  document.addEventListener('click', function() {
    document.getElementById('langDropdown').classList.remove('open');
  });
</script>

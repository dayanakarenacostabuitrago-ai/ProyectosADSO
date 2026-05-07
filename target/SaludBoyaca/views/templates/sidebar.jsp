<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="${not empty sessionScope.lang ? sessionScope.lang : 'es'}"/>
<fmt:setBundle basename="messages"/>

<style>
  :root {
    --sb-width:      220px;
    --sb-green:      #4d7a68;
    --sb-green-dark: #2d5a47;
    --sb-green-pale: #e8f2ee;
    --sb-green-bg:   #f0f7f4;
    --sb-text:       #1a2e26;
    --sb-text-mid:   #4a6258;
    --sb-text-lt:    #7a9a8e;
    --sb-border:     #dce9e4;
  }

  .sb-layout {
    display: flex;
    min-height: calc(100vh - 56px);
  }

  /* ══ Sidebar ══ */
  .sidebar {
    width: var(--sb-width);
    min-width: var(--sb-width);
    background: #ffffff;
    border-right: 1px solid var(--sb-border);
    display: flex;
    flex-direction: column;
    padding-bottom: 1.5rem;
    position: sticky;
    top: 56px;
    height: calc(100vh - 56px);
    overflow-y: auto;
    scrollbar-width: thin;
    scrollbar-color: var(--sb-border) transparent;
  }
  .sidebar::-webkit-scrollbar { width: 3px; }
  .sidebar::-webkit-scrollbar-thumb { background: var(--sb-border); border-radius: 4px; }

  /* Labels de sección */
  .sb-label {
    font-size: .63rem; font-weight: 800;
    color: var(--sb-text-lt);
    text-transform: uppercase; letter-spacing: .1em;
    padding: 1rem 1rem .28rem; margin: 0;
  }

  /* Links */
  .sb-link {
    display: flex; align-items: center; gap: .55rem;
    padding: .46rem .72rem;
    margin: .04rem .45rem;
    color: var(--sb-text-mid);
    font-size: .83rem; font-weight: 500;
    text-decoration: none;
    border-radius: 9px;
    transition: background .13s, color .13s;
  }
  .sb-link:hover  { background: var(--sb-green-pale); color: var(--sb-green-dark); }
  .sb-link.active { background: var(--sb-green-pale); color: var(--sb-green-dark); font-weight: 700; }

  /* Icono — SIEMPRE verde, sin excepción */
  .sb-icon {
    width: 27px; height: 27px; border-radius: 7px;
    display: flex; align-items: center; justify-content: center;
    font-size: .77rem; flex-shrink: 0;
    background: var(--sb-green-pale) !important;
    color: var(--sb-green-dark) !important;
  }
  /* Icono activo — un toque más oscuro */
  .sb-link.active .sb-icon {
    background: #d4ece2 !important;
    color: var(--sb-green-dark) !important;
  }

  /* Divider */
  .sb-divider { border: none; border-top: 1px solid var(--sb-border); margin: .35rem .55rem; }

  /* Aviso enfermero */
  .sb-readonly-notice {
    margin: .7rem .6rem 0;
    padding: .6rem .75rem;
    border-radius: 9px;
    background: var(--sb-green-pale);
    border-left: 3px solid var(--sb-green);
    font-size: .71rem;
    color: var(--sb-green-dark);
    line-height: 1.45;
  }

  /* ══ Main content ══ */
  .sb-main {
    flex: 1; min-width: 0;
    background: var(--sb-green-bg);
    padding: 1.5rem 2rem;
  }
  @media (max-width: 768px) {
    .sb-main { padding: 1rem; }
  }

  /* ══ Responsive ══ */
  @media (max-width: 768px) {
    .sidebar { display: none; }
    .sidebar.show {
      display: flex; position: fixed;
      top: 56px; left: 0; z-index: 1000;
      height: calc(100vh - 56px);
    }
    .sb-main { padding: 1rem .75rem; }
    .sb-toggle-btn { display: flex !important; }
    .sb-overlay {
      display: none; position: fixed; inset: 0;
      background: rgba(0,0,0,.4); z-index: 999;
    }
    .sb-overlay.show { display: block; }
  }
  @media (min-width: 769px) { .sb-toggle-btn { display: none !important; } }

  /* ══ Action Buttons — compact fan ══ */
  .btn-fan {
    position: relative;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 2rem;
    height: 2rem;
  }
  .btn-fan .fan-btn {
    position: absolute;
    width: 1.9rem;
    height: 1.9rem;
    border-radius: 6px;
    border: 2px solid rgba(0,0,0,0.25);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: .72rem;
    color: #fff;
    cursor: pointer;
    text-decoration: none;
    transition: transform 0.25s cubic-bezier(.34,1.56,.64,1), opacity 0.2s;
    transform: translate(0,0) rotate(0deg);
    opacity: 0.9;
    box-shadow: 0 2px 6px rgba(0,0,0,0.2);
    z-index: 1;
  }
  .btn-fan .fan-btn:hover {
    opacity: 1;
    filter: brightness(1.1);
    z-index: 10;
  }
  .btn-fan .fan-btn.fan-edit   { background: #ff7f50; }
  .btn-fan .fan-btn.fan-delete { background: #ffd700; color: #333; }
  .btn-fan .fan-btn.fan-view   { background: #019b98; }

  /* Expanded state on row hover */
  tr:hover .btn-fan .fan-btn.fan-edit   { transform: translate(-2.1rem, 0) rotate(0deg); }
  tr:hover .btn-fan .fan-btn.fan-delete { transform: translate(0, 0)       rotate(0deg); }
  tr:hover .btn-fan .fan-btn.fan-view   { transform: translate(2.1rem, 0)  rotate(0deg); }

  /* th/td alignment for actions column */
  .th-actions, .td-actions {
    text-align: center;
    width: 120px;
    min-width: 120px;
  }
  }

</style>

<button class="sb-toggle-btn btn btn-sm d-none" id="sidebarToggle"
  style="position:fixed;top:10px;left:60px;z-index:2000;background:#2d5a47;color:#fff;border:none;border-radius:7px;">
  <i class="fas fa-bars"></i>
</button>

<div class="sb-overlay" id="sbOverlay"></div>

<div class="sb-layout">
  <nav class="sidebar" id="mainSidebar">

    <%-- Dashboard (todos los roles) --%>
    <p class="sb-label"><fmt:message key="nav.principal"/></p>
    <a class="sb-link ${activePage == 'dashboard' ? 'active' : ''}"
       href="${pageContext.request.contextPath}/dashboard">
      <span class="sb-icon"><i class="fas fa-th-large"></i></span>
      <fmt:message key="nav.dashboard"/>
    </a>

    <%-- ══ MÉDICO ══ --%>
    <c:if test="${sessionScope.usuarioRol == 'MEDICO'}">
      <hr class="sb-divider">
      <p class="sb-label"><fmt:message key="nav.medical.management"/></p>

      <a class="sb-link ${activePage == 'citas' ? 'active' : ''}"
         href="${pageContext.request.contextPath}/citas">
        <span class="sb-icon"><i class="fas fa-calendar-check"></i></span>
        <fmt:message key="nav.appointments.label"/>
      </a>

      <a class="sb-link ${activePage == 'pacientes' ? 'active' : ''}"
         href="${pageContext.request.contextPath}/pacientes">
        <span class="sb-icon"><i class="fas fa-users"></i></span>
        <fmt:message key="nav.patients.label"/>
      </a>

      <hr class="sb-divider">
      <p class="sb-label"><fmt:message key="nav.my.agenda"/></p>

      <a class="sb-link ${activePage == 'horarios' ? 'active' : ''}"
         href="${pageContext.request.contextPath}/horarios">
        <span class="sb-icon"><i class="fas fa-clock"></i></span>
        <fmt:message key="nav.my.schedule"/>
      </a>

      <hr class="sb-divider">
      <p class="sb-label"><fmt:message key="nav.export"/></p>

      <a class="sb-link" href="${pageContext.request.contextPath}/citas?accion=exportarPDF" target="_blank">
        <span class="sb-icon"><i class="fas fa-file-pdf"></i></span>
        <fmt:message key="nav.export.pdf"/>
      </a>
    </c:if>

    <%-- ══ RECEPCIONISTA ══ --%>
    <c:if test="${sessionScope.usuarioRol == 'RECEPCIONISTA'}">
      <hr class="sb-divider">
      <p class="sb-label"><fmt:message key="nav.patients"/></p>

      <a class="sb-link ${activePage == 'pacientes' ? 'active' : ''}"
         href="${pageContext.request.contextPath}/pacientes">
        <span class="sb-icon"><i class="fas fa-users"></i></span>
        <fmt:message key="nav.view.patients"/>
      </a>

      <a class="sb-link ${activePage == 'pacientes-nuevo' ? 'active' : ''}"
         href="${pageContext.request.contextPath}/pacientes?accion=nuevo">
        <span class="sb-icon"><i class="fas fa-user-plus"></i></span>
        <fmt:message key="nav.new.patient"/>
      </a>

      <hr class="sb-divider">
      <p class="sb-label"><fmt:message key="nav.appointments"/></p>

      <a class="sb-link ${activePage == 'citas' ? 'active' : ''}"
         href="${pageContext.request.contextPath}/citas">
        <span class="sb-icon"><i class="fas fa-list-alt"></i></span>
        <fmt:message key="nav.view.appointments"/>
      </a>

      <a class="sb-link ${activePage == 'citas-nueva' ? 'active' : ''}"
         href="${pageContext.request.contextPath}/citas?accion=nuevo">
        <span class="sb-icon"><i class="fas fa-calendar-plus"></i></span>
        <fmt:message key="cita.crear"/>
      </a>

      <hr class="sb-divider">
      <p class="sb-label"><fmt:message key="nav.schedules"/></p>

      <a class="sb-link ${activePage == 'horarios' ? 'active' : ''}"
         href="${pageContext.request.contextPath}/horarios">
        <span class="sb-icon"><i class="fas fa-clock"></i></span>
        <fmt:message key="nav.medical.schedules"/>
      </a>

      <hr class="sb-divider">
      <p class="sb-label"><fmt:message key="nav.export"/></p>

      <a class="sb-link" href="${pageContext.request.contextPath}/citas?accion=exportarPDF" target="_blank">
        <span class="sb-icon"><i class="fas fa-file-pdf"></i></span>
        <fmt:message key="nav.export.pdf"/>
      </a>

      <hr class="sb-divider">
      <p class="sb-label"><fmt:message key="nav.system"/></p>

      <a class="sb-link" href="${pageContext.request.contextPath}/logout">
        <span class="sb-icon"><i class="fas fa-sign-out-alt"></i></span>
        <fmt:message key="nav.logout"/>
      </a>
    </c:if>

    <%-- ══ ENFERMERO ══ --%>
    <c:if test="${sessionScope.usuarioRol == 'ENFERMERO'}">
      <hr class="sb-divider">
      <p class="sb-label"><fmt:message key="nav.consultation"/></p>

      <a class="sb-link ${activePage == 'citas' ? 'active' : ''}"
         href="${pageContext.request.contextPath}/citas">
        <span class="sb-icon"><i class="fas fa-calendar-check"></i></span>
        <fmt:message key="nav.view.appointments"/>
      </a>

      <a class="sb-link ${activePage == 'pacientes' ? 'active' : ''}"
         href="${pageContext.request.contextPath}/pacientes">
        <span class="sb-icon"><i class="fas fa-users"></i></span>
        <fmt:message key="nav.view.patients"/>
      </a>

      <div class="sb-readonly-notice">
        <i class="fas fa-lock me-1"></i><strong><fmt:message key="nav.readonly"/></strong><br>
        <fmt:message key="nav.readonly.detail"/>
      </div>
    </c:if>


    <%-- ══ ADMINISTRADOR ══ --%>
    <c:if test="${sessionScope.usuarioRol == 'ADMINISTRADOR'}">
      <hr class="sb-divider">
      <p class="sb-label"><fmt:message key="nav.admin"/></p>

      <a class="sb-link ${activePage == 'usuarios' ? 'active' : ''}"
         href="${pageContext.request.contextPath}/usuarios">
        <span class="sb-icon"><i class="fas fa-users-cog"></i></span>
        <fmt:message key="nav.gestion.usuarios"/>
      </a>

      <a class="sb-link ${activePage == 'pacientes' ? 'active' : ''}"
         href="${pageContext.request.contextPath}/pacientes">
        <span class="sb-icon"><i class="fas fa-user-injured"></i></span>
        <fmt:message key="nav.patients.label"/>
      </a>

      <a class="sb-link ${activePage == 'citas' ? 'active' : ''}"
         href="${pageContext.request.contextPath}/citas">
        <span class="sb-icon"><i class="fas fa-calendar-check"></i></span>
        <fmt:message key="nav.appointments.label"/>
      </a>

      <a class="sb-link ${activePage == 'horarios' ? 'active' : ''}"
         href="${pageContext.request.contextPath}/horarios">
        <span class="sb-icon"><i class="fas fa-clock"></i></span>
        <fmt:message key="nav.medical.schedules"/>
      </a>

      <hr class="sb-divider">
      <p class="sb-label"><fmt:message key="nav.system"/></p>

      <a class="sb-link" href="${pageContext.request.contextPath}/logout">
        <span class="sb-icon"><i class="fas fa-sign-out-alt"></i></span>
        <fmt:message key="nav.logout"/>
      </a>
    </c:if>

  </nav>

  <script>
    (function() {
      var toggle  = document.getElementById('sidebarToggle');
      var sidebar = document.getElementById('mainSidebar');
      var overlay = document.getElementById('sbOverlay');
      if (toggle) {
        toggle.addEventListener('click', function() {
          sidebar.classList.toggle('show');
          overlay.classList.toggle('show');
        });
        overlay.addEventListener('click', function() {
          sidebar.classList.remove('show');
          overlay.classList.remove('show');
        });
      }
    })();
  </script>




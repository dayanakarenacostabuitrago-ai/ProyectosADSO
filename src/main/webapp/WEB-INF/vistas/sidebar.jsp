<%-- sidebar.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<%-- Contar solicitudes pendientes para badge --%>
<%@ page import="co.sena.cimm.adso.registraduria.dao.SolicitudDAOimpl" %>
<%
  int pendientesCount = 0;
  try { pendientesCount = new SolicitudDAOimpl().contarPendientes(); } catch (Exception ignored) {}
  request.setAttribute("sidebarPendientes", pendientesCount);
%>

<aside class="sidebar">

  <div class="sidebar-logo">
    <div class="logo-icon"><i class="fas fa-landmark"></i></div>
    <div>
      <div class="logo-title">Registradur&#237;a</div>
      <div class="logo-sub">Municipal de Nobsa</div>
    </div>
  </div>

  <nav class="sidebar-nav">

    <div class="nav-section"><i class="fas fa-users nav-section-icon"></i> Personas</div>
    <a href="${pageContext.request.contextPath}/ciudadanos"
       class="nav-item ${currentPage == 'ciudadanos' ? 'active' : ''}">
      <i class="fas fa-user-circle"></i><span>Ciudadanos</span>
    </a>
    <a href="${pageContext.request.contextPath}/documentos"
       class="nav-item ${currentPage == 'documentos' ? 'active' : ''}">
      <i class="fas fa-id-card"></i><span>Documentos</span>
    </a>

    <div class="nav-section" style="margin-top:6px;"><i class="fas fa-chair nav-section-icon"></i> Mesas</div>
    <a href="${pageContext.request.contextPath}/mesas"
       class="nav-item ${currentPage == 'mesas' ? 'active' : ''}">
      <i class="fas fa-vote-yea"></i><span>Gesti&#243;n de Mesas</span>
    </a>

    <div class="nav-section" style="margin-top:6px;"><i class="fas fa-map-marked-alt nav-section-icon"></i> Zonas</div>
    <a href="${pageContext.request.contextPath}/zonas"
       class="nav-item ${currentPage == 'zonas' ? 'active' : ''}">
      <i class="fas fa-layer-group"></i><span>Gesti&#243;n de Zonas</span>
    </a>

    <div class="nav-section" style="margin-top:6px;"><i class="fas fa-chart-bar nav-section-icon"></i> Reportes</div>
    <a href="${pageContext.request.contextPath}/reportes"
       class="nav-item ${currentPage == 'vencidos' ? 'active' : ''}">
      <i class="fas fa-triangle-exclamation"></i><span>Docs. por Vencer</span>
    </a>

    <div class="nav-section" style="margin-top:6px;"><i class="fas fa-bell nav-section-icon"></i> Solicitudes</div>
    <a href="${pageContext.request.contextPath}/notificaciones"
       class="nav-item ${currentPage == 'notificaciones' ? 'active' : ''}"
       style="position:relative;">
      <i class="fas fa-bell"></i><span>Notificaciones</span>
      <c:if test="${sidebarPendientes > 0}">
        <span style="position:absolute;right:12px;top:50%;transform:translateY(-50%);background:#c8a84b;color:#0b2346;font-size:10px;font-weight:800;min-width:18px;height:18px;border-radius:9px;padding:0 5px;display:inline-flex;align-items:center;justify-content:center;">${sidebarPendientes}</span>
      </c:if>
    </a>

  </nav>

  <div class="sidebar-footer">
    <c:if test="${sessionScope.usuario.esSuperAdmin}">
      <div class="admin-panel-btn-wrap">
        <a href="${pageContext.request.contextPath}/usuarios"
           class="btn-admin-icon ${currentPage == 'usuarios' ? 'btn-admin-icon-active' : ''}"
           title="Panel de Administradores">
          <span class="admin-icon-ring"><i class="fas fa-shield-halved"></i></span>
          <span class="admin-icon-label">Admin Panel</span>
        </a>
      </div>
    </c:if>
    <div class="user-info">
      <i class="fas fa-user-shield"></i>
      <div>
        <div class="user-name">${not empty sessionScope.usuario.nombreCompleto ? sessionScope.usuario.nombreCompleto : sessionScope.usuario.username}</div>
        <div class="user-role">${sessionScope.usuario.esSuperAdmin ? 'Super Administrador' : 'Administrador'}</div>
      </div>
    </div>
    <a href="${pageContext.request.contextPath}/logout" class="btn-logout">
      <i class="fas fa-right-from-bracket"></i><span>Cerrar sesi&#243;n</span>
    </a>
  </div>

</aside>

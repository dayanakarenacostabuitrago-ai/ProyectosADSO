<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="currentPage" value="zonas" scope="request"/>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Zonas - Registraduría de Nobsa</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
  <style>
    /* Estilos específicos para zonas */
    .badge-blue {
      background: rgba(30,85,155,0.12);
      color: var(--info);
      padding: 3px 10px;
      border-radius: 20px;
      font-size: 11px;
      font-weight: 600;
      display: inline-flex;
      align-items: center;
      gap: 5px;
      border: 1px solid rgba(100,160,230,0.2);
    }
    .direccion-text {
      font-size: 12px;
      color: var(--text-muted);
      max-width: 200px;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }
  </style>
</head>
<body>

<jsp:include page="/WEB-INF/vistas/sidebar.jsp"/>

<main class="main">
  <div class="topbar">
    <h1><i class="fas fa-map-marked-alt topbar-icon"></i> Gestión de Zonas de Votación</h1>
    <a href="${pageContext.request.contextPath}/zonas?accion=nuevo" class="btn-primary">
      <i class="fas fa-plus"></i> Nueva Zona
    </a>
  </div>

  <div class="content">
    <!-- Mensajes de éxito/error -->
    <c:if test="${param.msg == 'creada'}">
      <div class="alert-c alert-success"><i class="fas fa-check-circle"></i> Zona creada exitosamente.</div>
    </c:if>
    <c:if test="${param.msg == 'actualizada'}">
      <div class="alert-c alert-success"><i class="fas fa-check-circle"></i> Zona actualizada exitosamente.</div>
    </c:if>
    <c:if test="${param.msg == 'eliminada'}">
      <div class="alert-c alert-success"><i class="fas fa-check-circle"></i> Zona eliminada correctamente.</div>
    </c:if>
    <c:if test="${param.error == 'tiene_mesas'}">
      <div class="alert-c alert-danger"><i class="fas fa-exclamation-circle"></i> No se puede eliminar: la zona tiene mesas de votación asignadas.</div>
    </c:if>
    <c:if test="${not empty error}">
      <div class="alert-c alert-danger"><i class="fas fa-exclamation-circle"></i> ${error}</div>
    </c:if>

    <!-- Barra de filtros -->
    <div class="filter-bar">
      <i class="fas fa-filter filter-icon"></i>
      <span class="filter-label">Ciudad:</span>
      <form action="${pageContext.request.contextPath}/zonas" method="get"
            style="display:flex; gap:8px; align-items:center; flex:1; flex-wrap:wrap;">
        <select class="filter-select" name="idCiudad" onchange="this.form.submit()">
          <option value="">Todas las ciudades</option>
          <c:forEach var="cd" items="${ciudades}">
            <option value="${cd[0]}" ${ciudadFiltroId != null and ciudadFiltroId == cd[0] ? 'selected' : ''}>${cd[1]}</option>
          </c:forEach>
        </select>
        <div class="filter-divider"></div>
        <input class="filter-input" type="text" name="buscar"
               placeholder="Buscar por zona, puesto o dirección..." 
               value="${buscar}" style="min-width:220px;">
        <button type="submit" class="btn-navy"><i class="fas fa-search"></i></button>
        <c:if test="${not empty buscar or not empty ciudadFiltroId}">
          <a href="${pageContext.request.contextPath}/zonas" class="btn-icon-clear" title="Limpiar">
            <i class="fas fa-xmark"></i>
          </a>
        </c:if>
      </form>
    </div>

    <!-- Tabla de zonas -->
    <div class="card-table">
      <div class="card-table-wrap">
        <table>
          <thead>
            <tr>
              <th style="width:50px;">#</th>
              <th>Zona</th>
              <th>Puesto de Votación</th>
              <th>Dirección</th>
              <th>Ciudad</th>
              <th style="width:80px;">Mesas</th>
              <th style="width:100px; text-align:center;">Acciones</th>
            </tr>
          </thead>
          <tbody>
            <c:choose>
              <c:when test="${empty zonas}">
                <tr>
                  <td colspan="7" class="sin-datos">
                    <i class="fas fa-map-marked-alt"></i>
                    <c:choose>
                      <c:when test="${not empty buscar}">
                        No se encontraron zonas con "<strong>${buscar}</strong>".
                      </c:when>
                      <c:when test="${not empty ciudadFiltroId}">
                        No hay zonas en la ciudad seleccionada.
                      </c:when>
                      <c:otherwise>
                        No hay zonas registradas.
                      </c:otherwise>
                    </c:choose>
                  </td>
                </tr>
              </c:when>
              <c:otherwise>
                <c:forEach var="z" items="${zonas}" varStatus="st">
                  <tr>
                    <td><span class="badge-navy">${st.count}</span></td>
                    <td><strong>${z.nombreZona}</strong></td>
                    <td style="font-size:12.5px;">${z.puestoVotacion}</td>
                    <td class="direccion-text" title="${z.direccion}">${z.direccion}</td>
                    <td>
                      <c:choose>
                        <c:when test="${not empty z.ciudadNombre}">
                          <span class="badge-gold">
                            <i class="fas fa-city" style="font-size:10px;"></i> ${z.ciudadNombre}
                          </span>
                        </c:when>
                        <c:otherwise>
                          <span style="color:rgba(100,140,185,0.4); font-size:12px;">—</span>
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <td>
                      <span class="badge-blue">
                        <i class="fas fa-chair" style="font-size:10px;"></i> 
                        ${z.totalMesas != null ? z.totalMesas : 0}
                      </span>
                    </td>
                    <td style="text-align:center;">
                      <div style="display:flex; gap:6px; justify-content:center;">
                        <a href="${pageContext.request.contextPath}/zonas?accion=editar&id=${z.idZonaVotacion}"
                           class="btn-icon btn-icon-edit" title="Editar zona">
                          <i class="fas fa-pen"></i>
                        </a>
                        <button class="btn-icon btn-icon-del" title="Eliminar zona"
                          onclick="confirmarEliminarZona('${z.idZonaVotacion}','${z.nombreZona}',${z.totalMesas != null ? z.totalMesas : 0})">
                          <i class="fas fa-trash"></i>
                        </button>
                      </div>
                    </td>
                  </tr>
                </c:forEach>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>
      </div>
      <c:if test="${not empty zonas}">
        <div class="table-footer">
          <span><strong>${zonas.size()}</strong> zona(s) encontradas</span>
        </div>
      </c:if>
    </div>
  </div>
</main>

<!-- ============================================= -->
<!-- MODAL ELIMINAR ZONA                           -->
<!-- ============================================= -->
<div class="modal fade" id="modalEliminarZona" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header modal-header-dark">
        <h5 class="modal-title"><i class="fas fa-trash me-2"></i> Eliminar Zona</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body text-center">
        <div class="modal-icon-wrap modal-icon-warn">
          <i class="fas fa-map-marked-alt"></i>
        </div>
        <div id="zonaElimNombre" style="font-size:16px; font-weight:700; color:var(--text-primary);"></div>
        <div id="zonaElimWarning" class="modal-warn-box mt-3 text-start"></div>
      </div>
      <div class="modal-footer" style="justify-content:center; gap:10px;">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
        <a id="btnConfElimZona" href="#" class="btn btn-danger"><i class="fas fa-trash me-1"></i> Sí, eliminar</a>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
  // Confirmar eliminación de zona
  function confirmarEliminarZona(id, nombre, totalMesas) {
    document.getElementById('zonaElimNombre').textContent = nombre;
    const warning = document.getElementById('zonaElimWarning');
    const btn = document.getElementById('btnConfElimZona');
    
    if (totalMesas > 0) {
      warning.innerHTML = '<i class="fas fa-exclamation-triangle me-1"></i> Esta zona tiene <strong>' + totalMesas + ' mesa(s)</strong> asignada(s). Elimina las mesas primero.';
      btn.style.display = 'none';
    } else {
      warning.innerHTML = '<i class="fas fa-exclamation-triangle me-1"></i> Esta acción es <strong>irreversible</strong>. ¿Deseas continuar?';
      btn.style.display = 'inline-flex';
      btn.href = '${pageContext.request.contextPath}/zonas?accion=eliminar&id=' + id;
    }
    new bootstrap.Modal(document.getElementById('modalEliminarZona')).show();
  }
  
  // Auto-cerrar alertas después de 4.5 segundos
  setTimeout(() => {
    document.querySelectorAll('.alert-c').forEach(alert => {
      alert.style.transition = 'opacity 0.5s';
      alert.style.opacity = '0';
      setTimeout(() => alert.remove(), 500);
    });
  }, 4500);
</script>

</body>
</html>
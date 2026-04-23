<%@ page contentType="text/html;charset=UTF-8" %>
  <%@ taglib uri="jakarta.tags.core" prefix="c" %>
    <c:set var="currentPage" value="mesas" scope="request" />
    <!DOCTYPE html>
    <html lang="es">

    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Mesas - Registraduría de Nobsa</title>
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
      <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
      <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
      <style>
        /* ── Barras de capacidad ── */
        .capacity-bar {
          height: 8px;
          border-radius: 20px;
          background: rgba(79, 156, 232, 0.18);
          border: 1px solid rgba(79, 156, 232, 0.28);
          overflow: hidden;
          margin-top: 6px;
          min-width: 90px;
        }

        .capacity-fill {
          height: 100%;
          border-radius: 20px;
          transition: width 0.6s cubic-bezier(.4, 0, .2, 1);
          box-shadow: 0 1px 4px rgba(0, 0, 0, .12);
        }

        .capacity-stats {
          font-size: 12.5px;
          font-weight: 700;
          display: flex;
          align-items: baseline;
          gap: 2px;
        }

        .capacity-current {
          color: #1a3a5c;
          font-weight: 800;
        }

        .capacity-max {
          color: #5a80a8;
          font-size: 11px;
        }

        .badge-blue {
          background: rgba(13, 110, 253, 0.10);
          color: #0d4fa8;
          padding: 4px 11px;
          border-radius: 20px;
          font-size: 11px;
          font-weight: 600;
          display: inline-flex;
          align-items: center;
          gap: 5px;
          border: 1px solid rgba(13, 110, 253, 0.22);
        }
      </style>
    </head>

    <body>

      <jsp:include page="/WEB-INF/vistas/sidebar.jsp" />

      <main class="main">
        <div class="topbar">
          <h1><i class="fas fa-chair topbar-icon"></i> Gestión de Mesas de Votación</h1>
          <button class="btn-primary" data-bs-toggle="modal" data-bs-target="#modalMesa" onclick="abrirNueva()">
            <i class="fas fa-plus"></i> Nueva Mesa
          </button>
        </div>

        <div class="content">
          <!-- Mensajes de éxito/error -->
          <c:if test="${param.msg == 'creada'}">
            <div class="alert-c alert-success"><i class="fas fa-check-circle"></i> Mesa creada exitosamente.</div>
          </c:if>
          <c:if test="${param.msg == 'actualizada'}">
            <div class="alert-c alert-success"><i class="fas fa-check-circle"></i> Mesa actualizada exitosamente.</div>
          </c:if>
          <c:if test="${param.msg == 'eliminada'}">
            <div class="alert-c alert-success"><i class="fas fa-check-circle"></i> Mesa eliminada correctamente.</div>
          </c:if>
          <c:if test="${param.error == 'tiene_ciudadanos'}">
            <div class="alert-c alert-danger"><i class="fas fa-exclamation-circle"></i> No se puede eliminar: la mesa
              tiene ciudadanos asignados.</div>
          </c:if>
          <c:if test="${not empty error}">
            <div class="alert-c alert-danger"><i class="fas fa-exclamation-circle"></i> ${error}</div>
          </c:if>

          <!-- Barra de filtros -->
          <div class="filter-bar">
            <i class="fas fa-filter filter-icon"></i>
            <span class="filter-label">Zona:</span>
            <form action="${pageContext.request.contextPath}/mesas" method="get"
              style="display:flex; gap:8px; align-items:center; flex:1; flex-wrap:wrap;">
              <select class="filter-select" name="idZona" onchange="this.form.submit()">
                <option value="">Todas las zonas</option>
                <c:forEach var="z" items="${zonas}">
                  <option value="${z[0]}" ${zonaFiltroId !=null and zonaFiltroId==z[0] ? 'selected' : '' }>${z[1]}
                  </option>
                </c:forEach>
              </select>
              <div class="filter-divider"></div>
              <input class="filter-input" type="text" name="buscar" placeholder="Buscar por zona o número de mesa..."
                value="${buscar}" style="min-width:220px;">
              <button type="submit" class="btn-navy"><i class="fas fa-search"></i></button>
              <c:if test="${not empty buscar or not empty zonaFiltroId}">
                <a href="${pageContext.request.contextPath}/mesas" class="btn-icon-clear" title="Limpiar">
                  <i class="fas fa-xmark"></i>
                </a>
              </c:if>
            </form>
          </div>

          <!-- Tabla de mesas -->
          <div class="card-table">
            <div class="card-table-wrap">
              <table>
                <thead>
                  <tr>
                    <th style="width:50px;">#</th>
                    <th>Mesa</th>
                    <th>Zona</th>
                    <th style="width:100px;">Capacidad</th>
                    <th style="width:140px;">Ocupación</th>
                    <th style="width:100px; text-align:center;">Acciones</th>
                  </tr>
                </thead>
                <tbody>
                  <c:choose>
                    <c:when test="${empty mesas}">
                      <tr>
                        <td colspan="6" class="sin-datos">
                          <i class="fas fa-chair"></i>
                          <c:choose>
                            <c:when test="${not empty buscar}">
                              No se encontraron mesas con "<strong>${buscar}</strong>".
                            </c:when>
                            <c:when test="${not empty zonaFiltroId}">
                              No hay mesas en la zona seleccionada.
                            </c:when>
                            <c:otherwise>
                              No hay mesas registradas.
                            </c:otherwise>
                          </c:choose>
                        </td>
                      </tr>
                    </c:when>
                    <c:otherwise>
                      <c:forEach var="m" items="${mesas}" varStatus="st">
                        <c:set var="porcentaje"
                          value="${m.capacidad > 0 ? (m.totalCiudadanos * 100 / m.capacidad) : 0}" />
                        <c:set var="barColor">
                          <c:choose>
                            <c:when test="${porcentaje >= 100}">#dc2626</c:when>
                            <c:when test="${porcentaje > 80}">#d97706</c:when>
                            <c:otherwise>#0d6efd</c:otherwise>
                          </c:choose>
                        </c:set>
                        <tr>
                          <td><span class="badge-navy">${st.count}</span></td>
                          <td><strong>Mesa ${m.numeroMesa}</strong></td>
                          <td>
                            <span class="badge-blue">
                              <i class="fas fa-map-marker-alt" style="font-size:10px;"></i>
                              ${not empty m.nombreZona ? m.nombreZona : '—'}
                            </span>
                          </td>
                          <td>${m.capacidad}</td>
                          <td>
                            <div class="capacity-stats">
                              <span class="capacity-current">${m.totalCiudadanos}</span>
                              <span class="capacity-max">/ ${m.capacidad}</span>
                            </div>
                            <div class="capacity-bar">
                              <div class="capacity-fill" style="width: ${porcentaje}%; background: ${barColor};"></div>
                            </div>
                          </td>
                          <td style="text-align:center;">
                            <div style="display:flex; gap:6px; justify-content:center;">
                              <button class="btn-icon btn-icon-edit" title="Editar"
                                onclick="abrirEditar(${m.idMesasVotacion}, ${m.idZonaVotacion}, ${m.numeroMesa}, ${m.capacidad})"
                                data-bs-toggle="modal" data-bs-target="#modalMesa">
                                <i class="fas fa-pen"></i>
                              </button>
                              <button class="btn-icon btn-icon-del" title="Eliminar"
                                onclick="confirmarEliminar(${m.idMesasVotacion}, ${m.numeroMesa}, '${m.nombreZona}', ${m.totalCiudadanos})">
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
            <c:if test="${not empty mesas}">
              <div class="table-footer">
                <span><strong>${mesas.size()}</strong> mesa(s) encontradas</span>
              </div>
            </c:if>
          </div>
        </div>
      </main>

      <!-- ============================================= -->
      <!-- MODAL CREAR / EDITAR MESA                     -->
      <!-- ============================================= -->
      <div class="modal fade" id="modalMesa" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
          <div class="modal-content">
            <div class="modal-header modal-header-dark">
              <h5 class="modal-title" id="modalMesaTitulo"><i class="fas fa-chair me-2"></i> Nueva Mesa</h5>
              <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/mesas" id="formMesa">
              <div class="modal-body">
                <input type="hidden" name="accion" id="modalAccion" value="crear">
                <input type="hidden" name="idMesasVotacion" id="modalIdMesa" value="">

                <div class="mb-3">
                  <label class="form-label">Zona de Votación *</label>
                  <select name="idZonaVotacion" id="modalIdZona" class="form-select" required>
                    <option value="">Seleccionar zona...</option>
                    <c:forEach var="z" items="${zonas}">
                      <option value="${z[0]}">${z[1]}</option>
                    </c:forEach>
                  </select>
                </div>

                <div class="mb-3">
                  <label class="form-label">Número de Mesa *</label>
                  <input type="number" name="numeroMesa" id="modalNumeroMesa" class="form-control" min="1" required
                    placeholder="Ej: 1">
                </div>

                <div class="mb-3">
                  <label class="form-label">Capacidad</label>
                  <input type="number" name="capacidad" id="modalCapacidad" class="form-control" min="1"
                    placeholder="Default: 200" value="200">
                  <small class="text-muted" style="font-size:11px; color:var(--text-muted);">Número máximo de ciudadanos
                    que puede atender esta mesa</small>
                </div>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                <button type="submit" class="btn-primary" id="modalBtnGuardar">
                  <i class="fas fa-plus me-1"></i> Crear Mesa
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>

      <!-- ============================================= -->
      <!-- MODAL ELIMINAR MESA                           -->
      <!-- ============================================= -->
      <div class="modal fade" id="modalEliminar" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
          <div class="modal-content">
            <div class="modal-header modal-header-dark">
              <h5 class="modal-title"><i class="fas fa-trash me-2"></i> Eliminar Mesa</h5>
              <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body text-center">
              <div class="modal-icon-wrap modal-icon-warn">
                <i class="fas fa-chair"></i>
              </div>
              <div id="modalEliminarNombre" class="fw-bold mb-2" style="font-size:16px; color:var(--text-primary);">
              </div>
              <div id="modalEliminarWarning" class="modal-warn-box mt-3 text-start"></div>
            </div>
            <div class="modal-footer" style="justify-content:center; gap:10px;">
              <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
              <a id="btnConfirmarEliminar" href="#" class="btn btn-danger"><i class="fas fa-trash me-1"></i> Sí,
                eliminar</a>
            </div>
          </div>
        </div>
      </div>

      <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
      <script>
        // Abrir modal para nueva mesa
        function abrirNueva() {
          document.getElementById('modalMesaTitulo').innerHTML = '<i class="fas fa-chair me-2"></i> Nueva Mesa';
          document.getElementById('modalAccion').value = 'crear';
          document.getElementById('modalIdMesa').value = '';
          document.getElementById('modalIdZona').value = '';
          document.getElementById('modalNumeroMesa').value = '';
          document.getElementById('modalCapacidad').value = '200';
          document.getElementById('modalBtnGuardar').innerHTML = '<i class="fas fa-plus me-1"></i> Crear Mesa';
        }

        // Abrir modal para editar mesa
        function abrirEditar(id, idZona, numeroMesa, capacidad) {
          document.getElementById('modalMesaTitulo').innerHTML = '<i class="fas fa-pen me-2"></i> Editar Mesa';
          document.getElementById('modalAccion').value = 'actualizar';
          document.getElementById('modalIdMesa').value = id;
          document.getElementById('modalIdZona').value = idZona;
          document.getElementById('modalNumeroMesa').value = numeroMesa;
          document.getElementById('modalCapacidad').value = capacidad;
          document.getElementById('modalBtnGuardar').innerHTML = '<i class="fas fa-save me-1"></i> Guardar Cambios';
        }

        // Confirmar eliminación de mesa
        function confirmarEliminar(id, numero, zona, totalCiudadanos) {
          document.getElementById('modalEliminarNombre').innerHTML = 'Mesa ' + numero + ' — ' + zona;
          const warning = document.getElementById('modalEliminarWarning');
          const btn = document.getElementById('btnConfirmarEliminar');

          if (totalCiudadanos > 0) {
            warning.innerHTML = '<i class="fas fa-exclamation-triangle me-1"></i> Esta mesa tiene <strong>' + totalCiudadanos + ' ciudadano(s)</strong> asignado(s). Reasígnalos antes de eliminar.';
            btn.style.display = 'none';
          } else {
            warning.innerHTML = '<i class="fas fa-exclamation-triangle me-1"></i> Esta acción es <strong>irreversible</strong>. ¿Deseas continuar?';
            btn.style.display = 'inline-flex';
            btn.href = '${pageContext.request.contextPath}/mesas?accion=eliminar&id=' + id;
          }
          new bootstrap.Modal(document.getElementById('modalEliminar')).show();
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
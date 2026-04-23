<%@ page contentType="text/html;charset=UTF-8" %>
  <%@ taglib uri="jakarta.tags.core" prefix="c" %>
    <c:set var="currentPage" value="documentos" scope="request" />
    <!DOCTYPE html>
    <html lang="es">

    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Documentos - Registraduría de Nobsa</title>
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
      <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
      <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
      <style>
        /* Estilos específicos para filtros tipo chip */
        .filter-chips-group {
          display: flex;
          gap: 6px;
          align-items: center;
          flex-wrap: wrap;
        }

        .filter-chip {
          display: inline-flex;
          align-items: center;
          gap: 6px;
          padding: 5px 14px;
          border-radius: 50px;
          font-size: 12px;
          font-weight: 600;
          cursor: pointer;
          border: 1.5px solid rgba(100, 160, 220, .35);
          background: linear-gradient(135deg, rgb(218, 232, 247) 0%, rgb(214, 229, 247) 100%);
          color: #3a72b0;
          transition: all 0.2s;
          white-space: nowrap;
          text-decoration: none;
          box-shadow: inset 0 1px 2px rgba(255, 255, 255, .7);
        }

        .filter-chip:hover {
          border-color: rgba(13, 110, 253, .5);
          color: #0d6efd;
          background: linear-gradient(135deg, rgb(225, 238, 255) 0%, rgb(210, 228, 252) 100%);
          box-shadow: 0 2px 8px rgba(13, 110, 253, .2), inset 0 1px 2px rgba(255, 255, 255, .8);
        }

        .filter-chip.active {
          border-color: rgba(13, 110, 253, .6);
          background: linear-gradient(135deg, rgb(13, 110, 253) 0%, rgb(10, 88, 202) 100%);
          color: #ffffff;
          box-shadow: 0 3px 10px rgba(13, 110, 253, .35);
        }

        .filter-label {
          font-size: 11px;
          color: #2a5a9a;
          font-weight: 700;
          text-transform: uppercase;
          letter-spacing: 0.05em;
        }

        .badge-muted {
          background: rgba(255, 255, 255, 0.05);
          color: var(--text-muted);
          padding: 3px 10px;
          border-radius: 20px;
          font-size: 11px;
          font-weight: 600;
        }

        /* Badge azul para número de documento y serie */
        .badge-doc {
          display: inline-block;
          background: #dbeafe;
          color: #1e40af;
          border: 1px solid #bfdbfe;
          padding: 3px 10px;
          border-radius: 20px;
          font-size: 11px;
          font-weight: 700;
          font-family: monospace;
          letter-spacing: 0.03em;
          white-space: nowrap;
        }

        code {
          background: rgba(0, 0, 0, 0.3);
          padding: 2px 6px;
          border-radius: 4px;
          color: #2979e8;
          font-size: 12px;
        }

        .nombre-ciudadano {
          font-weight: 600;
          color: var(--text-primary);
        }
      </style>
    </head>

    <body>

      <jsp:include page="/WEB-INF/vistas/sidebar.jsp" />

      <main class="main">
        <div class="topbar">
          <h1><i class="fas fa-id-card topbar-icon"></i> Documentos Expedidos</h1>
          <button class="btn-primary" onclick="abrirModalNuevoDoc()">
            <i class="fas fa-plus"></i> Nuevo Documento
          </button>
        </div>

        <div class="content">
          <!-- Mensajes de éxito/error -->
          <c:if test="${not empty param.mensaje}">
            <div class="alert-c alert-success">
              <i class="fas fa-circle-check"></i> ${param.mensaje}
            </div>
          </c:if>
          <c:if test="${not empty param.error}">
            <div class="alert-c alert-danger">
              <i class="fas fa-circle-exclamation"></i> ${param.error}
            </div>
          </c:if>

          <!-- Barra de filtros y búsqueda -->
          <div class="filter-bar">
            <i class="fas fa-filter filter-icon"></i>

            <!-- Filtro por Estado -->
            <div class="filter-chips-group">
              <span class="filter-label">Estado:</span>
              <a href="${pageContext.request.contextPath}/documentos"
                class="filter-chip ${empty filtroActivo and empty criterioBusqueda ? 'active' : ''}">Todos</a>
              <a href="${pageContext.request.contextPath}/documentos?action=filter&filtro=estado&valor=vigente"
                class="filter-chip ${filtroActivo=='estado' and valorFiltro=='vigente' ? 'active' : ''}">
                <i class="fas fa-circle" style="font-size:7px; color:var(--success);"></i> Vigente
              </a>
              <a href="${pageContext.request.contextPath}/documentos?action=filter&filtro=estado&valor=vencido"
                class="filter-chip ${filtroActivo=='estado' and valorFiltro=='vencido' ? 'active' : ''}">
                <i class="fas fa-circle" style="font-size:7px; color:var(--danger);"></i> Vencido
              </a>
              <a href="${pageContext.request.contextPath}/documentos?action=filter&filtro=estado&valor=cancelado"
                class="filter-chip ${filtroActivo=='estado' and valorFiltro=='cancelado' ? 'active' : ''}">
                <i class="fas fa-circle" style="font-size:7px; color:var(--text-muted);"></i> Cancelado
              </a>
            </div>

            <div class="filter-divider"></div>

            <!-- Filtro por Tipo -->
            <div class="filter-chips-group">
              <span class="filter-label">Tipo:</span>
              <a href="${pageContext.request.contextPath}/documentos?action=filter&filtro=tipo&valor=Cedula de Ciudadania"
                class="filter-chip ${filtroActivo=='tipo' and valorFiltro=='Cedula de Ciudadania' ? 'active' : ''}">C.C.</a>
              <a href="${pageContext.request.contextPath}/documentos?action=filter&filtro=tipo&valor=Tarjeta de Identidad"
                class="filter-chip ${filtroActivo=='tipo' and valorFiltro=='Tarjeta de Identidad' ? 'active' : ''}">T.I.</a>
              <a href="${pageContext.request.contextPath}/documentos?action=filter&filtro=tipo&valor=Registro Civil"
                class="filter-chip ${filtroActivo=='tipo' and valorFiltro=='Registro Civil' ? 'active' : ''}">Reg.
                Civil</a>
              <a href="${pageContext.request.contextPath}/documentos?action=filter&filtro=tipo&valor=Contrasenha"
                class="filter-chip ${filtroActivo=='tipo' and valorFiltro=='Contrasenha' ? 'active' : ''}">Contraseña</a>
            </div>

            <div class="filter-divider"></div>

            <!-- Búsqueda -->
            <form action="${pageContext.request.contextPath}/documentos" method="get"
              style="display:flex; gap:6px; align-items:center; margin-left:auto;">
              <input type="hidden" name="action" value="search">
              <input class="filter-input" type="text" name="criterio" placeholder="Buscar cédula, nombre, serie..."
                value="${criterioBusqueda}" style="min-width:220px;">
              <button type="submit" class="btn-navy" title="Buscar"><i class="fas fa-search"></i></button>
              <c:if test="${not empty criterioBusqueda or not empty filtroActivo}">
                <a href="${pageContext.request.contextPath}/documentos" class="btn-icon-clear" title="Limpiar">
                  <i class="fas fa-xmark"></i>
                </a>
              </c:if>
            </form>
          </div>

          <!-- Tabla de documentos -->
          <div class="card-table">
            <div class="card-table-wrap">
              <table>
                <thead>
                  <tr>
                    <th>Ciudadano</th>
                    <th>Cédula</th>
                    <th>Tipo</th>
                    <th>N° Serie</th>
                    <th>Expedición</th>
                    <th>Vencimiento</th>
                    <th>Estado</th>
                    <th style="text-align:center;">Acciones</th>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach items="${documentos}" var="d">
                    <tr>
                      <td class="nombre-ciudadano">${d.ciudadanoNombre}</td>
                      <td><span class="badge-doc">${d.ciudadanoDocumento}</span></td>
                      <td>
                        <span class="badge-muted">
                          <c:choose>
                            <c:when test="${d.tipoDocumento == 'Cedula de Ciudadania'}">C.C.</c:when>
                            <c:when test="${d.tipoDocumento == 'Tarjeta de Identidad'}">T.I.</c:when>
                            <c:when test="${d.tipoDocumento == 'Registro Civil'}">Reg. Civil</c:when>
                            <c:otherwise>${d.tipoDocumento}</c:otherwise>
                          </c:choose>
                        </span>
                      </td>
                      <td><span class="badge-doc">${d.numeroSerie}</span></td>
                      <td>${d.fechaExpedicion}</td>
                      <td>${not empty d.fechaVencimiento ? d.fechaVencimiento : '—'}</td>
                      <td><span class="estado-badge estado-${d.estado}">${d.estado}</span></td>
                      <td style="text-align:center;">
                        <div style="display:flex; gap:6px; justify-content:center;">
                          <button class="btn-icon btn-icon-edit" title="Editar" onclick="abrirModalEditarDoc(
                        '${d.idDocumentosExpedidos}',
                        '${d.ciudadanoDocumento}',
                        '${d.tipoDocumento}',
                        '${d.numeroSerie}',
                        '${d.fechaExpedicion}',
                        '${d.fechaVencimiento}',
                        '${d.estado}'
                      )">
                            <i class="fas fa-pen"></i>
                          </button>
                          <button class="btn-icon btn-icon-del" title="Eliminar"
                            onclick="confirmarEliminarDoc('${d.idDocumentosExpedidos}','${d.ciudadanoNombre}','${d.numeroSerie}')">
                            <i class="fas fa-trash"></i>
                          </button>
                        </div>
                      </td>
                    </tr>
                  </c:forEach>
                  <c:if test="${empty documentos}">
                    <tr>
                      <td colspan="8" class="sin-datos">
                        <i class="fas fa-id-card"></i> No hay documentos que coincidan
                      </td>
                    </tr>
                  </c:if>
                </tbody>
              </table>
            </div>
            <c:if test="${not empty documentos}">
              <div class="table-footer">
                <span><strong>${documentos.size()}</strong> registros encontrados</span>
                <div class="pag-btns" id="paginacionDoc"></div>
              </div>
            </c:if>
          </div>
        </div>
      </main>

      <!-- ============================================= -->
      <!-- MODAL ELIMINAR DOCUMENTO                      -->
      <!-- ============================================= -->
      <div class="modal fade" id="modalEliminarDoc" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
          <div class="modal-content">
            <div class="modal-header modal-header-dark">
              <h5 class="modal-title"><i class="fas fa-triangle-exclamation me-2"></i> Confirmar eliminación</h5>
              <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body text-center">
              <div class="modal-icon-wrap modal-icon-warn">
                <i class="fas fa-file-circle-xmark"></i>
              </div>
              <div style="font-size:16px; font-weight:700; color:var(--text-primary);" id="docElimCiudadano"></div>
              <div style="font-size:12.5px; color:var(--text-muted); margin-top:4px;">
                Serie: <code id="docElimSerie"></code>
              </div>
              <div class="modal-warn-box">
                <i class="fas fa-exclamation-circle me-1"></i>
                Esta acción <strong>no se puede deshacer</strong>.
              </div>
            </div>
            <div class="modal-footer" style="justify-content:center; gap:10px;">
              <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
              <form id="formEliminarDoc" action="${pageContext.request.contextPath}/documentos" method="get"
                style="margin:0;">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="id" id="docElimId">
                <button type="submit" class="btn btn-danger"><i class="fas fa-trash me-1"></i> Sí, eliminar</button>
              </form>
            </div>
          </div>
        </div>
      </div>

      <!-- ============================================= -->
      <!-- MODAL NUEVO DOCUMENTO                         -->
      <!-- ============================================= -->
      <div class="modal fade" id="modalNuevoDoc" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered modal-lg">
          <div class="modal-content">
            <div class="modal-header modal-header-dark">
              <h5 class="modal-title"><i class="fas fa-file-plus me-2"></i> Nuevo Documento</h5>
              <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/documentos" method="post">
              <input type="hidden" name="action" value="create">
              <div class="modal-body">
                <div class="row g-3">
                  <div class="col-12">
                    <label class="form-label">Documento del Ciudadano *</label>
                    <input type="text" name="ciudadanoDocumento" class="form-control" required
                      placeholder="Número de cédula del ciudadano">
                    <small class="text-muted" style="font-size:11px; color:var(--text-muted);">El ciudadano debe estar
                      registrado previamente</small>
                  </div>
                  <div class="col-md-6">
                    <label class="form-label">Tipo de Documento *</label>
                    <select name="tipoDocumento" class="form-select" required>
                      <option value="">Seleccionar...</option>
                      <option>Cédula de Ciudadanía</option>
                      <option>Tarjeta de Identidad</option>
                      <option>Registro Civil</option>
                      <option>Contraseña</option>
                    </select>
                  </div>
                  <div class="col-md-6">
                    <label class="form-label">Número de Serie *</label>
                    <input type="text" name="numeroSerie" class="form-control" required placeholder="Ej: ABC-123456">
                  </div>
                  <div class="col-md-6">
                    <label class="form-label">Fecha Expedición *</label>
                    <input type="date" name="fechaExpedicion" class="form-control" required>
                  </div>
                  <div class="col-md-6">
                    <label class="form-label">Fecha Vencimiento</label>
                    <input type="date" name="fechaVencimiento" class="form-control">
                    <small class="text-muted" style="font-size:11px;">Opcional para documentos con vigencia</small>
                  </div>
                  <div class="col-md-6">
                    <label class="form-label">Estado *</label>
                    <select name="estado" class="form-select" required>
                      <option value="vigente">Vigente</option>
                      <option value="vencido">Vencido</option>
                      <option value="cancelado">Cancelado</option>
                    </select>
                  </div>
                </div>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                <button type="submit" class="btn-primary"><i class="fas fa-save me-1"></i> Guardar</button>
              </div>
            </form>
          </div>
        </div>
      </div>

      <!-- ============================================= -->
      <!-- MODAL EDITAR DOCUMENTO                        -->
      <!-- ============================================= -->
      <div class="modal fade" id="modalEditarDoc" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered modal-lg">
          <div class="modal-content">
            <div class="modal-header modal-header-dark">
              <h5 class="modal-title"><i class="fas fa-file-pen me-2"></i> Editar Documento</h5>
              <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/documentos" method="post">
              <input type="hidden" name="action" value="update">
              <input type="hidden" name="id" id="editDocId">
              <div class="modal-body">
                <div class="row g-3">
                  <div class="col-12">
                    <label class="form-label">Documento del Ciudadano</label>
                    <input type="text" name="ciudadanoDocumento" id="editDocCiud" class="form-control" readonly>
                  </div>
                  <div class="col-md-6">
                    <label class="form-label">Tipo de Documento *</label>
                    <select name="tipoDocumento" id="editDocTipo" class="form-select" required>
                      <option>Cédula de Ciudadanía</option>
                      <option>Tarjeta de Identidad</option>
                      <option>Registro Civil</option>
                      <option>Contraseña</option>
                    </select>
                  </div>
                  <div class="col-md-6">
                    <label class="form-label">Número de Serie *</label>
                    <input type="text" name="numeroSerie" id="editDocSerie" class="form-control" required>
                  </div>
                  <div class="col-md-6">
                    <label class="form-label">Fecha Expedición *</label>
                    <input type="date" name="fechaExpedicion" id="editDocExp" class="form-control" required>
                  </div>
                  <div class="col-md-6">
                    <label class="form-label">Fecha Vencimiento</label>
                    <input type="date" name="fechaVencimiento" id="editDocVenc" class="form-control">
                  </div>
                  <div class="col-md-6">
                    <label class="form-label">Estado *</label>
                    <select name="estado" id="editDocEstado" class="form-select" required>
                      <option value="vigente">Vigente</option>
                      <option value="vencido">Vencido</option>
                      <option value="cancelado">Cancelado</option>
                    </select>
                  </div>
                </div>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                <button type="submit" class="btn-primary"><i class="fas fa-floppy-disk me-1"></i> Actualizar</button>
              </div>
            </form>
          </div>
        </div>
      </div>

      <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
      <script>
        // Función para confirmar eliminación de documento
        function confirmarEliminarDoc(id, ciudadano, serie) {
          document.getElementById('docElimId').value = id;
          document.getElementById('docElimCiudadano').textContent = ciudadano;
          document.getElementById('docElimSerie').textContent = serie;
          new bootstrap.Modal(document.getElementById('modalEliminarDoc')).show();
        }

        // Abrir modal nuevo documento
        function abrirModalNuevoDoc() {
          new bootstrap.Modal(document.getElementById('modalNuevoDoc')).show();
        }

        // Abrir modal editar documento
        function abrirModalEditarDoc(id, ciud, tipo, serie, exp, venc, estado) {
          document.getElementById('editDocId').value = id;
          document.getElementById('editDocCiud').value = ciud;
          document.getElementById('editDocTipo').value = tipo;
          document.getElementById('editDocSerie').value = serie;
          document.getElementById('editDocExp').value = exp;
          document.getElementById('editDocVenc').value = (venc && venc !== 'null') ? venc : '';
          document.getElementById('editDocEstado').value = estado;
          new bootstrap.Modal(document.getElementById('modalEditarDoc')).show();
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
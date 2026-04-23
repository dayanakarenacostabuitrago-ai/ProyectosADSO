<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="currentPage" value="ciudadanos" scope="request"/>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Ciudadanos - Registraduría de Nobsa</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
  <style>
    /* Ajustes específicos para este JSP si son necesarios */
    .sin-asignar {
      color: #7aa3c8;
      font-size: 12px;
      font-style: italic;
    }
    code {
      background: rgba(41,121,232,0.10);
      padding: 2px 8px;
      border-radius: 6px;
      color: #0d4fa8;
      font-size: 12px;
      font-weight: 600;
      border: 1px solid rgba(41,121,232,0.18);
    }
  </style>
</head>
<body>

<jsp:include page="/WEB-INF/vistas/sidebar.jsp"/>

<main class="main">
  <div class="topbar">
    <h1><i class="fas fa-users topbar-icon"></i> Gestión de Ciudadanos</h1>
    <button class="btn-primary" onclick="abrirModalNuevoCiudadano()">
      <i class="fas fa-plus"></i> Nuevo Ciudadano
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
      <c:choose>
        <c:when test="${param.error == 'tiene_documentos'}">
          <script>
            window.addEventListener('DOMContentLoaded', function() {
              new bootstrap.Modal(document.getElementById('modalTieneDocumentos')).show();
            });
          </script>
        </c:when>
        <c:otherwise>
          <div class="alert-c alert-danger">
            <i class="fas fa-circle-exclamation"></i> ${param.error}
          </div>
        </c:otherwise>
      </c:choose>
    </c:if>

    <!-- Barra de búsqueda y filtros -->
    <div class="filter-bar">
      <i class="fas fa-search filter-icon"></i>
      <input class="filter-input" type="text" id="filtroBusqueda"
             placeholder="Buscar por nombre, apellido o documento..."
             value="${criterioBusqueda}" style="flex:1;" oninput="filtrarTabla()">
      <div class="filter-divider"></div>
      <select class="filter-select" id="filtroZona" onchange="filtrarTabla()">
        <option value="">Todas las veredas</option>
      </select>
      <div class="filter-divider"></div>
      <select class="filter-select" id="filtroMesa" onchange="filtrarTabla()">
        <option value="">Todas las mesas</option>
        <option value="sin">Sin asignar</option>
        <c:forEach var="mesa" items="${mesas}">
          <option value="Mesa ${mesa.numeroMesa}">Mesa ${mesa.numeroMesa}</option>
        </c:forEach>
      </select>
      <div class="filter-divider"></div>
      <button class="btn-icon-clear" onclick="limpiarFiltros()" title="Limpiar filtros">
        <i class="fas fa-xmark"></i>
      </button>
    </div>

    <!-- Tabla de ciudadanos -->
    <div class="card-table">
      <div class="card-table-wrap">
        <table>
          <thead>
            <tr>
              <th>Documento</th>
              <th>Nombres</th>
              <th>Apellidos</th>
              <th>Fecha Nac.</th>
              <th>Vereda/Barrio</th>
              <th>Mesa</th>
              <th style="text-align:center;">Acciones</th>
            </tr>
          </thead>
          <tbody id="tablaBody">
            <c:forEach items="${ciudadanos}" var="c">
              <tr data-nombre="${c.nombres} ${c.apellidos}"
                  data-doc="${c.numeroDocumento}"
                  data-zona="${c.veredaBarrio}"
                  data-mesa="${not empty c.numeroMesa ? 'Mesa '.concat(c.numeroMesa) : 'sin'}">
                <td><code>${c.numeroDocumento}</code></td>
                <td>${c.nombres}</td>
                <td>${c.apellidos}</td>
                <td>${c.fechaNacimiento}</td>
                <td>${c.veredaBarrio}</td>
                <td>
                  <c:choose>
                    <c:when test="${not empty c.numeroMesa}">
                      <span class="badge-navy">Mesa ${c.numeroMesa}</span>
                    </c:when>
                    <c:otherwise>
                      <span class="sin-asignar">Sin asignar</span>
                    </c:otherwise>
                  </c:choose>
                </td>
                <td style="text-align:center;">
                  <div style="display:flex; gap:6px; justify-content:center;">
                    <button class="btn-icon btn-icon-edit" title="Editar"
                      onclick="abrirModalEditarCiudadano(
                        '${c.idCiudadanos}',
                        '${c.numeroDocumento}',
                        '${c.nombres}',
                        '${c.apellidos}',
                        '${c.fechaNacimiento}',
                        '${c.veredaBarrio}',
                        '${c.telefono}',
                        '${c.correo}',
                        '${c.idMesasVotacion}'
                      )">
                      <i class="fas fa-pen"></i>
                    </button>
                    <button class="btn-icon btn-icon-del" title="Eliminar"
                      onclick="confirmarEliminarCiudadano(
                        '${c.idCiudadanos}',
                        '${c.nombres} ${c.apellidos}',
                        '${c.numeroDocumento}'
                      )">
                      <i class="fas fa-trash"></i>
                    </button>
                  </div>
                </td>
              </tr>
            </c:forEach>
            <c:if test="${empty ciudadanos}">
              <tr id="filaSinDatos">
                <td colspan="7" class="sin-datos">
                  <i class="fas fa-users"></i> No hay ciudadanos registrados
                </td>
              </tr>
            </c:if>
          </tbody>
        </table>
      </div>
      <c:if test="${not empty ciudadanos}">
        <div class="table-footer">
          <span><strong id="contadorRegistros">${ciudadanos.size()}</strong> registros encontrados</span>
          <div class="pag-btns" id="paginacion"></div>
        </div>
      </c:if>
    </div>
  </div>
</main>

<!-- ============================================= -->
<!-- MODAL ELIMINAR CIUDADANO                       -->
<!-- ============================================= -->
<div class="modal fade" id="modalEliminar" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header modal-header-dark">
        <h5 class="modal-title"><i class="fas fa-triangle-exclamation me-2"></i> Confirmar eliminación</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body text-center">
        <div class="modal-icon-wrap modal-icon-warn">
          <i class="fas fa-user-xmark"></i>
        </div>
        <div style="font-size:16px; font-weight:700; color:var(--text-primary);" id="elimNombre"></div>
        <div style="font-size:12.5px; color:var(--text-muted); margin-top:4px;">
          Documento: <code id="elimDoc"></code>
        </div>
        <div class="modal-warn-box">
          <i class="fas fa-exclamation-circle me-1"></i> 
          Esta acción es <strong>irreversible</strong>. El ciudadano y sus datos serán eliminados.
        </div>
      </div>
      <div class="modal-footer" style="justify-content:center; gap:10px;">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
        <form id="formEliminar" action="${pageContext.request.contextPath}/ciudadanos" method="get" style="margin:0;">
          <input type="hidden" name="action" value="delete">
          <input type="hidden" name="id" id="elimId">
          <button type="submit" class="btn btn-danger"><i class="fas fa-trash me-1"></i> Sí, eliminar</button>
        </form>
      </div>
    </div>
  </div>
</div>

<!-- ============================================= -->
<!-- MODAL NUEVO CIUDADANO                         -->
<!-- ============================================= -->
<div class="modal fade" id="modalNuevoCiudadano" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered modal-lg">
    <div class="modal-content">
      <div class="modal-header modal-header-dark">
        <h5 class="modal-title"><i class="fas fa-user-plus me-2"></i> Nuevo Ciudadano</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <form action="${pageContext.request.contextPath}/ciudadanos" method="post">
        <input type="hidden" name="action" value="create">
        <div class="modal-body">
          <div class="row g-3">
            <div class="col-12">
              <label class="form-label">Número de Documento *</label>
              <input type="text" name="numeroDocumento" class="form-control" required placeholder="Ej: 1000000001">
            </div>
            <div class="col-md-6">
              <label class="form-label">Nombres *</label>
              <input type="text" name="nombres" class="form-control" required>
            </div>
            <div class="col-md-6">
              <label class="form-label">Apellidos *</label>
              <input type="text" name="apellidos" class="form-control" required>
            </div>
            <div class="col-md-6">
              <label class="form-label">Fecha de Nacimiento *</label>
              <input type="date" name="fechaNacimiento" class="form-control" required>
            </div>
            <div class="col-md-6">
              <label class="form-label">Vereda / Barrio *</label>
              <input type="text" name="veredaBarrio" class="form-control" required>
            </div>
            <div class="col-md-6">
              <label class="form-label">Teléfono</label>
              <input type="tel" name="telefono" class="form-control">
            </div>
            <div class="col-md-6">
              <label class="form-label">Correo Electrónico</label>
              <input type="email" name="correo" class="form-control">
            </div>
            <div class="col-12">
              <label class="form-label">
                <i class="fas fa-chair" style="color:var(--gold); margin-right:4px;"></i> Mesa de Votación
              </label>
              <select name="idMesasVotacion" class="form-select">
                <option value="">-- Sin mesa asignada --</option>
                <c:forEach var="mesa" items="${mesas}">
                  <option value="${mesa.idMesasVotacion}">
                    Mesa ${mesa.numeroMesa} — ${mesa.nombreZona} (${mesa.totalCiudadanos}/${mesa.capacidad})
                  </option>
                </c:forEach>
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
<!-- MODAL EDITAR CIUDADANO                        -->
<!-- ============================================= -->
<div class="modal fade" id="modalEditarCiudadano" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered modal-lg">
    <div class="modal-content">
      <div class="modal-header modal-header-dark">
        <h5 class="modal-title"><i class="fas fa-user-pen me-2"></i> Editar Ciudadano</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <form action="${pageContext.request.contextPath}/ciudadanos" method="post">
        <input type="hidden" name="action" value="update">
        <input type="hidden" name="id" id="editCiudId">
        <div class="modal-body">
          <div class="row g-3">
            <div class="col-12">
              <label class="form-label">Número de Documento</label>
              <input type="text" name="numeroDocumento" id="editCiudDoc" class="form-control" readonly>
            </div>
            <div class="col-md-6">
              <label class="form-label">Nombres *</label>
              <input type="text" name="nombres" id="editCiudNombres" class="form-control" required>
            </div>
            <div class="col-md-6">
              <label class="form-label">Apellidos *</label>
              <input type="text" name="apellidos" id="editCiudApellidos" class="form-control" required>
            </div>
            <div class="col-md-6">
              <label class="form-label">Fecha de Nacimiento *</label>
              <input type="date" name="fechaNacimiento" id="editCiudFecha" class="form-control" required>
            </div>
            <div class="col-md-6">
              <label class="form-label">Vereda / Barrio *</label>
              <input type="text" name="veredaBarrio" id="editCiudVereda" class="form-control" required>
            </div>
            <div class="col-md-6">
              <label class="form-label">Teléfono</label>
              <input type="tel" name="telefono" id="editCiudTel" class="form-control">
            </div>
            <div class="col-md-6">
              <label class="form-label">Correo Electrónico</label>
              <input type="email" name="correo" id="editCiudCorreo" class="form-control">
            </div>
            <div class="col-12">
              <label class="form-label">
                <i class="fas fa-chair" style="color:var(--gold); margin-right:4px;"></i> Mesa de Votación
              </label>
              <select name="idMesasVotacion" id="editCiudMesa" class="form-select">
                <option value="">-- Sin mesa asignada --</option>
                <c:forEach var="mesa" items="${mesas}">
                  <option value="${mesa.idMesasVotacion}">
                    Mesa ${mesa.numeroMesa} — ${mesa.nombreZona} (${mesa.totalCiudadanos}/${mesa.capacidad})
                  </option>
                </c:forEach>
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

<!-- ============================================= -->
<!-- MODAL TIENE DOCUMENTOS (error)                -->
<!-- ============================================= -->
<div class="modal fade" id="modalTieneDocumentos" tabindex="-1" data-bs-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content" style="border:none;">
      <div class="modal-header" style="background:linear-gradient(135deg,#7a1a10,#c0392b); border:none;">
        <h5 class="modal-title" style="color:#fff; font-weight:700;">
          <i class="fas fa-triangle-exclamation"></i> No se puede eliminar
        </h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" style="filter:invert(1);"></button>
      </div>
      <div class="modal-body text-center">
        <div class="modal-icon-wrap modal-icon-danger" style="margin:0 auto 20px;">
          <i class="fas fa-id-card"></i>
        </div>
        <div style="font-size:18px; font-weight:800; color:var(--text-primary); margin-bottom:10px;">
          Ciudadano con documentos activos
        </div>
        <div style="font-size:13.5px; color:var(--text-muted); line-height:1.6; margin-bottom:20px;">
          Este ciudadano tiene <strong style="color:var(--danger);">documentos expedidos</strong> asociados.<br>
          Para eliminarlo, primero debes <strong>eliminar o reasignar</strong> todos sus documentos.
        </div>
        <div class="modal-warn-box" style="text-align:left;">
          <i class="fas fa-lightbulb me-2"></i>
          <span>Ve a <strong>Documentos</strong> → busca por el número de documento → elimina o cancela sus registros → regresa aquí para eliminarlo.</span>
        </div>
      </div>
      <div class="modal-footer" style="justify-content:center; gap:12px;">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
          <i class="fas fa-xmark me-1"></i> Cerrar
        </button>
        <a href="${pageContext.request.contextPath}/documentos" class="btn-primary" style="text-decoration:none;">
          <i class="fas fa-id-card me-1"></i> Ir a Documentos
        </a>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
  // Funciones para modales
  function confirmarEliminarCiudadano(id, nombre, doc) {
    document.getElementById('elimId').value = id;
    document.getElementById('elimNombre').textContent = nombre;
    document.getElementById('elimDoc').textContent = doc;
    new bootstrap.Modal(document.getElementById('modalEliminar')).show();
  }
  
  function abrirModalNuevoCiudadano() {
    new bootstrap.Modal(document.getElementById('modalNuevoCiudadano')).show();
  }
  
  function abrirModalEditarCiudadano(id, doc, nombres, apellidos, fecha, vereda, tel, correo, idMesa) {
    document.getElementById('editCiudId').value = id;
    document.getElementById('editCiudDoc').value = doc;
    document.getElementById('editCiudNombres').value = nombres;
    document.getElementById('editCiudApellidos').value = apellidos;
    document.getElementById('editCiudFecha').value = fecha;
    document.getElementById('editCiudVereda').value = vereda;
    document.getElementById('editCiudTel').value = tel || '';
    document.getElementById('editCiudCorreo').value = correo || '';
    document.getElementById('editCiudMesa').value = idMesa || '';
    new bootstrap.Modal(document.getElementById('modalEditarCiudadano')).show();
  }
  
  // Auto-cerrar alertas después de 4.5 segundos
  setTimeout(() => {
    document.querySelectorAll('.alert-c').forEach(alert => {
      alert.style.transition = 'opacity 0.5s';
      alert.style.opacity = '0';
      setTimeout(() => alert.remove(), 500);
    });
  }, 4500);

  // ── Filtrado en tiempo real ──────────────────────────────────────────────
  (function poblarZonas() {
    const zonas = new Set();
    document.querySelectorAll('#tablaBody tr[data-zona]').forEach(tr => {
      const z = tr.dataset.zona;
      if (z) zonas.add(z);
    });
    const sel = document.getElementById('filtroZona');
    [...zonas].sort().forEach(z => {
      const opt = document.createElement('option');
      opt.value = z;
      opt.textContent = z;
      sel.appendChild(opt);
    });
  })();

  function filtrarTabla() {
    const texto  = (document.getElementById('filtroBusqueda').value || '').toLowerCase().trim();
    const zona   = (document.getElementById('filtroZona').value  || '').toLowerCase().trim();
    const mesa   = (document.getElementById('filtroMesa').value  || '').toLowerCase().trim();

    let visibles = 0;
    document.querySelectorAll('#tablaBody tr[data-nombre]').forEach(tr => {
      const nombre = (tr.dataset.nombre || '').toLowerCase();
      const doc    = (tr.dataset.doc    || '').toLowerCase();
      const tZona  = (tr.dataset.zona   || '').toLowerCase();
      const tMesa  = (tr.dataset.mesa   || '').toLowerCase();

      const okTexto = !texto || nombre.includes(texto) || doc.includes(texto);
      const okZona  = !zona  || tZona === zona;
      const okMesa  = !mesa  || tMesa === mesa;

      if (okTexto && okZona && okMesa) {
        tr.style.display = '';
        visibles++;
      } else {
        tr.style.display = 'none';
      }
    });

    // Mostrar/ocultar fila vacía
    const sinDatos = document.getElementById('filaSinDatos');
    if (sinDatos) sinDatos.style.display = visibles === 0 ? '' : 'none';

    // Actualizar contador
    const contador = document.getElementById('contadorRegistros');
    if (contador) contador.textContent = visibles;
  }

  function limpiarFiltros() {
    document.getElementById('filtroBusqueda').value = '';
    document.getElementById('filtroZona').value = '';
    document.getElementById('filtroMesa').value = '';
    filtrarTabla();
  }
</script>

</body>
</html>
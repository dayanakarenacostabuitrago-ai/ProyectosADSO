<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
      <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
        <fmt:setLocale value="${not empty sessionScope.lang ? sessionScope.lang : 'es'}" />
        <fmt:setBundle basename="messages" />
        <!DOCTYPE html>
        <html lang="${not empty sessionScope.lang ? sessionScope.lang : 'es'}">

        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1">
          <title>Gestión de Usuarios — SaludBoyacá</title>
          <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
          <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
          <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap"
            rel="stylesheet">
          <style>
            :root {
              --g: #4d7a68;
              --g-dark: #2d5a47;
              --g-pale: #e8f2ee;
              --g-bg: #f0f7f4;
              --text: #1a2e26;
              --text-mid: #4a6258;
              --text-lt: #7a9a8e;
              --border: #dce9e4;
              --white: #fff;
              --radius: 14px;
              --shadow: 0 2px 14px rgba(45, 90, 71, .09);
            }

            *,
            *::before,
            *::after {
              box-sizing: border-box;
            }

            body {
              font-family: 'Plus Jakarta Sans', 'Segoe UI', sans-serif;
              background: var(--g-bg);
              color: var(--text);
            }

            /* Page header */
            .page-hdr {
              display: flex;
              align-items: center;
              justify-content: space-between;
              margin-bottom: 1.2rem;
              gap: 1rem;
              flex-wrap: wrap;
            }

            .page-hdr-left h5 {
              font-size: 1.1rem;
              font-weight: 800;
              margin: 0;
              color: var(--text);
            }

            .page-hdr-left p {
              font-size: .78rem;
              color: var(--text-lt);
              margin: .2rem 0 0;
            }

            .breadcrumb-bar {
              font-size: .73rem;
              color: var(--text-lt);
              margin-bottom: .3rem;
            }

            .breadcrumb-bar a {
              color: var(--g);
              text-decoration: none;
              font-weight: 600;
            }

            .btn-new {
              display: inline-flex;
              align-items: center;
              gap: .45rem;
              background: var(--g-dark);
              color: #fff;
              font-size: .82rem;
              font-weight: 700;
              padding: .55rem 1.2rem;
              border-radius: 10px;
              text-decoration: none;
              border: none;
              cursor: pointer;
              transition: background .18s;
            }

            .btn-new:hover {
              background: var(--g);
              color: #fff;
            }

            /* Stats bar */
            .stats-bar {
              display: flex;
              gap: .75rem;
              margin-bottom: 1.3rem;
              flex-wrap: wrap;
            }

            .sbar-item {
              background: var(--white);
              border-radius: 10px;
              border: 1px solid var(--border);
              padding: .55rem 1rem;
              display: flex;
              align-items: center;
              gap: .6rem;
              font-size: .8rem;
              font-weight: 600;
              color: var(--text-mid);
            }

            .sbar-icon {
              width: 28px;
              height: 28px;
              border-radius: 7px;
              display: flex;
              align-items: center;
              justify-content: center;
              font-size: .75rem;
            }

            /* Table card */
            .table-card {
              background: var(--white);
              border-radius: var(--radius);
              border: 1px solid var(--border);
              box-shadow: var(--shadow);
              overflow: hidden;
            }

            .table-toolbar {
              display: flex;
              align-items: center;
              gap: .75rem;
              padding: .85rem 1.2rem;
              border-bottom: 1px solid var(--border);
              flex-wrap: wrap;
            }

            .search-box {
              display: flex;
              align-items: center;
              gap: .4rem;
              background: var(--g-bg);
              border: 1px solid var(--border);
              border-radius: 9px;
              padding: .38rem .85rem;
              flex: 1;
              min-width: 200px;
              max-width: 340px;
            }

            .search-box input {
              border: none;
              background: transparent;
              outline: none;
              font-size: .82rem;
              font-family: inherit;
              color: var(--text);
              width: 100%;
            }

            .search-box i {
              color: var(--text-lt);
              font-size: .78rem;
            }

            .filter-sel {
              border: 1px solid var(--border);
              border-radius: 9px;
              padding: .38rem .8rem;
              font-size: .8rem;
              font-family: inherit;
              color: var(--text-mid);
              background: var(--g-bg);
              outline: none;
              cursor: pointer;
            }

            .usr-table {
              width: 100%;
              border-collapse: collapse;
              font-size: .82rem;
            }

            .usr-table th {
              font-size: .68rem;
              font-weight: 700;
              color: var(--text-lt);
              text-transform: uppercase;
              letter-spacing: .09em;
              padding: .6rem 1rem;
              background: #f8fcfb;
              border-bottom: 1px solid var(--border);
            }

            .usr-table td {
              padding: .7rem 1rem;
              border-bottom: 1px solid #f0f5f3;
              vertical-align: middle;
            }

            .usr-table tr:last-child td {
              border-bottom: none;
            }

            .usr-table tr:hover td {
              background: #f8fcfb;
            }

            .user-avatar {
              width: 34px;
              height: 34px;
              border-radius: 10px;
              flex-shrink: 0;
              display: flex;
              align-items: center;
              justify-content: center;
              font-size: .8rem;
              font-weight: 700;
              color: #fff;
            }

            .user-info {
              display: flex;
              align-items: center;
              gap: .65rem;
            }

            .user-name {
              font-weight: 700;
              font-size: .84rem;
            }

            .user-email {
              font-size: .72rem;
              color: var(--text-lt);
            }

            .rol-badge {
              display: inline-flex;
              align-items: center;
              gap: .3rem;
              font-size: .67rem;
              font-weight: 700;
              padding: .22rem .65rem;
              border-radius: 20px;
              text-transform: uppercase;
              letter-spacing: .05em;
            }

            .rol-MEDICO {
              background: #e0f4f4;
              color: #0c7e7e;
            }

            .rol-RECEPCIONISTA {
              background: #fff8e8;
              color: #b77a00;
            }

            .rol-ENFERMERO {
              background: #e8f0ff;
              color: #2353c4;
            }

            .rol-ADMINISTRADOR {
              background: #f3ecff;
              color: #6e23c4;
            }

            .status-pill {
              display: inline-flex;
              align-items: center;
              gap: .3rem;
              font-size: .7rem;
              font-weight: 600;
              padding: .18rem .55rem;
              border-radius: 20px;
            }

            .status-on {
              background: #dcfce7;
              color: #166534;
            }

            .status-off {
              background: #f1f5f9;
              color: #64748b;
            }

            .dot {
              width: 6px;
              height: 6px;
              border-radius: 50%;
            }

            .dot-on {
              background: #22c55e;
            }

            .dot-off {
              background: #94a3b8;
            }

            .act-wrap {
              display: flex;
              align-items: center;
              gap: .45rem;
            }

            .act-btn {
              width: 30px;
              height: 30px;
              border-radius: 8px;
              border: none;
              display: flex;
              align-items: center;
              justify-content: center;
              font-size: .75rem;
              cursor: pointer;
              text-decoration: none;
              transition: filter .15s;
            }

            .act-btn:hover {
              filter: brightness(.88);
            }

            .act-edit {
              background: #e8f2ee;
              color: #2d5a47;
            }

            .act-delete {
              background: #ffeef2;
              color: #c4234f;
            }

            /* Empty */
            .empty-state {
              text-align: center;
              padding: 3rem 1rem;
              color: var(--text-lt);
            }

            .empty-state i {
              font-size: 2.5rem;
              margin-bottom: .75rem;
            }

            /* Toast */
            .toast-success {
              background: #2d5a47;
              color: #fff;
              border-radius: 10px;
              padding: .75rem 1.2rem;
              font-size: .83rem;
              font-weight: 600;
              box-shadow: 0 6px 20px rgba(0, 0, 0, .2);
            }

            .toast-error {
              background: #c4234f;
              color: #fff;
              border-radius: 10px;
              padding: .75rem 1.2rem;
              font-size: .83rem;
              font-weight: 600;
              box-shadow: 0 6px 20px rgba(0, 0, 0, .2);
            }

            /* Modal confirm */
            .confirm-modal .modal-content {
              border-radius: 16px;
              border: none;
              box-shadow: 0 12px 40px rgba(0, 0, 0, .18);
            }

            .confirm-modal .modal-header {
              border-bottom: none;
              padding: 1.5rem 1.5rem .5rem;
            }

            .confirm-modal .modal-body {
              padding: .75rem 1.5rem;
              font-size: .88rem;
              color: var(--text-mid);
            }

            .confirm-modal .modal-footer {
              border-top: none;
              padding: .75rem 1.5rem 1.5rem;
            }

            .btn-confirm-del {
              background: #c4234f;
              color: #fff;
              border: none;
              border-radius: 9px;
              padding: .5rem 1.2rem;
              font-weight: 700;
              font-size: .83rem;
              cursor: pointer;
            }

            .btn-cancel-del {
              background: var(--g-pale);
              color: var(--text-mid);
              border: 1px solid var(--border);
              border-radius: 9px;
              padding: .5rem 1.2rem;
              font-weight: 600;
              font-size: .83rem;
              cursor: pointer;
            }

            /* Pagination */
            .pag-wrap {
              display: flex;
              align-items: center;
              justify-content: space-between;
              padding: .85rem 1.2rem;
              border-top: 1px solid var(--border);
              flex-wrap: wrap;
              gap: .5rem;
            }

            .pag-info {
              font-size: .75rem;
              color: var(--text-lt);
            }

            .pag-btns {
              display: flex;
              gap: .4rem;
            }

            .pag-btn {
              width: 32px;
              height: 32px;
              border-radius: 8px;
              border: 1px solid var(--border);
              background: var(--white);
              color: var(--text-mid);
              font-size: .78rem;
              display: flex;
              align-items: center;
              justify-content: center;
              cursor: pointer;
              transition: background .15s;
            }

            .pag-btn:hover {
              background: var(--g-pale);
              color: var(--g-dark);
            }

            .pag-btn.active {
              background: var(--g-dark);
              color: #fff;
              border-color: var(--g-dark);
            }
          </style>
        </head>

        <body>

          <jsp:include page="/views/templates/header.jsp" />
          <jsp:include page="/views/templates/sidebar.jsp" />

          <div class="sb-main">
            <%-- Toast --%>
              <c:if test="${not empty param.msg}">
                <div id="toast" class="toast-success"
                  style="position:fixed;top:70px;right:1.2rem;z-index:9999;display:none;">
                  <c:choose>
                    <c:when test="${param.msg == 'creado'}"><i class="fas fa-check-circle me-2"></i> Usuario creado
                      correctamente</c:when>
                    <c:when test="${param.msg == 'actualizado'}"><i class="fas fa-check-circle me-2"></i> Usuario
                      actualizado</c:when>
                    <c:when test="${param.msg == 'eliminado'}"><i class="fas fa-check-circle me-2"></i> Usuario
                      eliminado</c:when>
                  </c:choose>
                </div>
              </c:if>
              <c:if test="${not empty param.error}">
                <div id="toast" class="toast-error"
                  style="position:fixed;top:70px;right:1.2rem;z-index:9999;display:none;">
                  <i class="fas fa-exclamation-circle me-2"></i>
                  <c:if test="${param.error == 'no_auto_eliminar'}">No puedes eliminarte a ti mismo</c:if>
                  <c:if test="${param.error == 'fk_constraint'}">No se puede eliminar: el usuario tiene citas asociadas.
                    Fue desactivado.</c:if>
                  <c:if test="${param.error == 'error_general'}">Error interno al eliminar el usuario. Revisa los logs
                    del servidor.</c:if>
                </div>
              </c:if>

              <%-- Header --%>
                <div class="page-hdr">
                  <div class="page-hdr-left">
                    <div class="breadcrumb-bar">
                      <a href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
                      <span style="margin:0 .4rem;">›</span> Usuarios
                    </div>
                    <h5><i class="fas fa-users-cog" style="color:var(--g);margin-right:.5rem;"></i>Gestión de Usuarios
                    </h5>
                    <p>Administración completa del personal del sistema</p>
                  </div>
                  <a href="${pageContext.request.contextPath}/usuarios?accion=nuevo" class="btn-new">
                    <i class="fas fa-plus"></i> Nuevo Usuario
                  </a>
                </div>

                <%-- Stats bar --%>
                  <div class="stats-bar">
                    <div class="sbar-item">
                      <div class="sbar-icon" style="background:#f3ecff;color:#6e23c4;"><i class="fas fa-users"></i>
                      </div>
                      <span id="stat-total">0</span> total
                    </div>
                    <div class="sbar-item">
                      <div class="sbar-icon" style="background:#e0f4f4;color:#0c7e7e;"><i
                          class="fas fa-stethoscope"></i></div>
                      <span id="stat-medico">0</span> médicos
                    </div>
                    <div class="sbar-item">
                      <div class="sbar-icon" style="background:#fff8e8;color:#b77a00;"><i
                          class="fas fa-concierge-bell"></i></div>
                      <span id="stat-rec">0</span> recepcionistas
                    </div>
                    <div class="sbar-item">
                      <div class="sbar-icon" style="background:#e8f0ff;color:#2353c4;"><i class="fas fa-user-nurse"></i>
                      </div>
                      <span id="stat-enf">0</span> enfermeros
                    </div>
                    <div class="sbar-item">
                      <div class="sbar-icon" style="background:#dcfce7;color:#166534;"><i class="fas fa-circle"></i>
                      </div>
                      <span id="stat-activos">0</span> activos
                    </div>
                  </div>

                  <%-- Table --%>
                    <div class="table-card">
                      <div class="table-toolbar">
                        <div class="search-box">
                          <i class="fas fa-search"></i>
                          <input type="text" id="searchInput" placeholder="Buscar por nombre, usuario, documento..."
                            oninput="filtrar()">
                        </div>
                        <select class="filter-sel" id="filterRol" onchange="filtrar()">
                          <option value="" selected>Todos los roles</option>
                          <option value="MEDICO">Médico</option>
                          <option value="RECEPCIONISTA">Recepcionista</option>
                          <option value="ENFERMERO">Enfermero</option>
                          <option value="ADMINISTRADOR">Administrador</option>
                        </select>
                        <select class="filter-sel" id="filterEstado" onchange="filtrar()">
                          <option value="">Todos</option>
                          <option value="1">Activos</option>
                          <option value="0">Inactivos</option>
                        </select>
                      </div>

                      <div style="overflow-x:auto;">
                        <table class="usr-table" id="usrTable">
                          <thead>
                            <tr>
                              <th>Usuario</th>
                              <th>Documento</th>
                              <th>Email</th>
                              <th>Rol</th>
                              <th>Estado</th>
                              <th>Acciones</th>
                            </tr>
                          </thead>
                          <tbody id="usrBody">
                            <c:forEach var="u" items="${usuarios}">
                              <c:set var="activoVal" value="0"/>
                              <c:if test="${u.activo == 1}"><c:set var="activoVal" value="1"/></c:if>
                              <tr data-rol="${u.rol}"
                                data-activo="${activoVal}"
                                data-search="${u.nombres} ${u.apellidos} ${u.userName} ${u.documento}">
                                <td>
                                  <div class="user-info">
                                    <div class="user-avatar"
                                      style="background:${u.rol == 'MEDICO' ? '#4d7a68' : u.rol == 'RECEPCIONISTA' ? '#f59e0b' : u.rol == 'ENFERMERO' ? '#3b82f6' : '#8b5cf6'}">
                                      ${fn:substring(u.nombres, 0, 1)}${fn:substring(u.apellidos, 0, 1)}
                                    </div>
                                    <div>
                                      <div class="user-name">${u.nombres} ${u.apellidos}</div>
                                      <div class="user-email">@${u.userName}</div>
                                    </div>
                                  </div>
                                </td>
                                <td style="color:var(--text-mid);">${u.documento}</td>
                                <td style="color:var(--text-mid);font-size:.78rem;">${u.email}</td>
                                <td>
                                  <span class="rol-badge rol-${u.rol}">${u.rol}</span>
                                </td>
                                <td>
                                  <span class="status-pill ${u.activo == 1 ? 'status-on' : 'status-off'}">
                                    <span class="dot ${u.activo == 1 ? 'dot-on' : 'dot-off'}"></span>
                                    ${u.activo == 1 ? 'Activo' : 'Inactivo'}
                                  </span>
                                </td>
                                <td>
                                  <div class="act-wrap">
                                    <a href="${pageContext.request.contextPath}/usuarios?accion=editar&id=${u.idUsuario}"
                                      class="act-btn act-edit" title="Editar">
                                      <i class="fas fa-pen"></i>
                                    </a>
                                    <button class="act-btn act-delete" title="Eliminar"
                                      onclick="confirmarEliminar(${u.idUsuario}, '${u.nombres} ${u.apellidos}')">
                                      <i class="fas fa-trash-alt"></i>
                                    </button>
                                  </div>
                                </td>
                              </tr>
                            </c:forEach>
                          </tbody>
                        </table>
                      </div>

                      <%-- Empty state --%>
                        <c:if test="${empty usuarios}">
                          <div class="empty-state">
                            <i class="fas fa-users-slash"></i>
                            <p>No hay usuarios registrados</p>
                            <a href="${pageContext.request.contextPath}/usuarios?accion=nuevo" class="btn-new"
                              style="margin-top:.5rem;">
                              <i class="fas fa-plus"></i> Crear primer usuario
                            </a>
                          </div>
                        </c:if>

                        <%-- Pagination --%>
                          <div class="pag-wrap">
                            <span class="pag-info" id="pagInfo"></span>
                            <div class="pag-btns" id="pagBtns"></div>
                          </div>
                    </div>

          </div><%-- /sb-layout --%>

            <%-- Modal Eliminar --%>
              <div class="modal fade confirm-modal" id="modalEliminar" tabindex="-1">
                <div class="modal-dialog modal-dialog-centered">
                  <div class="modal-content">
                    <div class="modal-header">
                      <div style="display:flex;align-items:center;gap:.7rem;">
                        <div
                          style="width:42px;height:42px;border-radius:12px;background:#ffeef2;display:flex;align-items:center;justify-content:center;color:#c4234f;">
                          <i class="fas fa-trash-alt"></i>
                        </div>
                        <div>
                          <h6 style="font-weight:800;margin:0;font-size:.95rem;">Eliminar usuario</h6>
                          <p style="margin:0;font-size:.75rem;color:var(--text-lt);">Esta acción no se puede deshacer
                          </p>
                        </div>
                      </div>
                    </div>
                    <div class="modal-body">
                      ¿Estás seguro de que deseas eliminar a <strong id="deleteNombre"></strong>?
                    </div>
                    <div class="modal-footer" style="gap:.5rem;">
                      <button class="btn-cancel-del"
                        onclick="bootstrap.Modal.getInstance(document.getElementById('modalEliminar')).hide()">
                        Cancelar
                      </button>
                      <button id="deleteLink" class="btn-confirm-del" onclick="ejecutarEliminar()">Eliminar</button>
                    </div>
                  </div>
                </div>
              </div>

              <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
              <script>
                // CTX: context path inyectado directamente desde JSP (no depende de elemento DOM)
                var CTX = '${pageContext.request.contextPath}';

                // ── Toast ──────────────────────────────────────────────────────────
                var toast = document.getElementById('toast');
                if (toast) {
                  toast.style.display = 'block';
                  setTimeout(function(){ toast.style.opacity = '0'; }, 3000);
                  setTimeout(function(){ if(toast.parentNode) toast.parentNode.removeChild(toast); }, 3500);
                }

                // ── Stats ──────────────────────────────────────────────────────────
                var rows = Array.from(document.querySelectorAll('#usrBody tr'));
                function calcStats(visible) {
                  var tot=0, med=0, rec=0, enf=0, act=0;
                  visible.forEach(function(r){
                    tot++;
                    var rol = r.dataset.rol;
                    if (rol === 'MEDICO')        med++;
                    if (rol === 'RECEPCIONISTA') rec++;
                    if (rol === 'ENFERMERO')     enf++;
                    if (r.dataset.activo === '1') act++;
                  });
                  document.getElementById('stat-total').textContent   = tot;
                  document.getElementById('stat-medico').textContent  = med;
                  document.getElementById('stat-rec').textContent     = rec;
                  document.getElementById('stat-enf').textContent     = enf;
                  document.getElementById('stat-activos').textContent = act;
                }
                calcStats(rows);

                // ── Filtro + búsqueda ──────────────────────────────────────────────
                var currentPage = 1;
                var pageSize = 10;

                function filtrar() {
                  var q      = document.getElementById('searchInput').value.toLowerCase();
                  var rol    = document.getElementById('filterRol').value;
                  var estado = document.getElementById('filterEstado').value;
                  var visible = rows.filter(function(r){
                    var matchQ = r.dataset.search.toLowerCase().includes(q);
                    var matchR = !rol    || r.dataset.rol    === rol;
                    var matchE = !estado || r.dataset.activo === estado;
                    return matchQ && matchR && matchE;
                  });
                  currentPage = 1;
                  calcStats(visible);
                  renderPage(visible);
                }

                function renderPage(visible) {
                  var total = visible.length;
                  var pages = Math.max(1, Math.ceil(total / pageSize));
                  var start = (currentPage - 1) * pageSize;
                  var end   = start + pageSize;

                  rows.forEach(function(r){ r.style.display = 'none'; });
                  visible.slice(start, end).forEach(function(r){ r.style.display = ''; });

                  var showing = total === 0
                    ? 'Sin resultados'
                    : 'Mostrando ' + Math.min(start+1,total) + '–' + Math.min(end,total) + ' de ' + total;
                  document.getElementById('pagInfo').textContent = showing;

                  var pb = document.getElementById('pagBtns');
                  pb.innerHTML = '';
                  for (var i = 1; i <= pages; i++) {
                    (function(page){
                      var b = document.createElement('button');
                      b.className = 'pag-btn' + (page === currentPage ? ' active' : '');
                      b.textContent = page;
                      b.onclick = function(){ currentPage = page; renderPage(visible); };
                      pb.appendChild(b);
                    })(i);
                  }
                }
                filtrar();

                // ── Modal Eliminar ─────────────────────────────────────────────────
                var _deleteId = 0;

                function confirmarEliminar(id, nombre) {
                  _deleteId = id;
                  document.getElementById('deleteNombre').textContent = nombre;
                  var modal = bootstrap.Modal.getOrCreateInstance(document.getElementById('modalEliminar'));
                  modal.show();
                }

                function ejecutarEliminar() {
                  if (_deleteId > 0) {
                    window.location.href = CTX + '/usuarios?accion=eliminar&id=' + _deleteId;
                  }
                }
              </script>
</body>

        </html>
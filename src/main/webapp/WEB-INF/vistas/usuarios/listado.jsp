<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="currentPage" value="usuarios" scope="request"/>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Panel de Administradores - Registraduria de Nobsa</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css"/>
<style>
/* ─── Hero Banner — misma paleta azul del proyecto ─── */
.admin-hero {
  background: linear-gradient(135deg, #0d1826 0%, #1a2e4a 45%, #243d5c 100%);
  border-radius: 16px;
  padding: 36px 40px;
  margin-bottom: 28px;
  position: relative;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 24px;
  box-shadow: rgba(79,156,232,.5) 3px 3px 10px 0px, rgba(79,156,232,.3) 5px 5px 28px 0px;
  border: 1.5px solid rgba(79,156,232,.35);
}
.admin-hero::before {
  content:'';
  position:absolute;
  top:-60px; right:-60px;
  width:240px; height:240px;
  border-radius:50%;
  background: rgba(41,121,232,.08);
  pointer-events:none;
}
.admin-hero::after {
  content:'';
  position:absolute;
  bottom:-80px; left:200px;
  width:300px; height:300px;
  border-radius:50%;
  background: rgba(255,255,255,.03);
  pointer-events:none;
}
.hero-icon-wrap {
  width: 72px; height: 72px;
  border-radius: 18px;
  background: linear-gradient(135deg, #1a5fcc 0%, #5b9cf6 60%, #2979e8 100%);
  display: flex; align-items: center; justify-content: center;
  font-size: 30px; color: #fff;
  flex-shrink: 0;
  box-shadow: 0 6px 20px rgba(41,121,232,.55);
}
.hero-title {
  font-size: 24px; font-weight: 800;
  color: #fff; letter-spacing: -.01em; margin-bottom: 4px;
}
.hero-sub { font-size: 13.5px; color: #8aa0b8; }
.hero-sub span { color: #5b9cf6; font-weight: 600; }
.hero-stat {
  text-align: center; padding: 18px 28px;
  background: rgba(41,121,232,.1);
  border-radius: 12px;
  border: 1px solid rgba(41,121,232,.25);
  flex-shrink: 0;
  backdrop-filter: blur(4px);
  min-width: 110px;
}
.hero-stat-num  { font-size: 32px; font-weight: 800; color: #5b9cf6; line-height:1; }
.hero-stat-lbl  { font-size: 11px; color: #8aa0b8; margin-top: 4px; text-transform: uppercase; letter-spacing: .06em; }

/* ─── Table overrides — hereda card-table del sistema ─── */
.admin-table thead th {
  background: linear-gradient(180deg, #0d6efd 0%, #0a58ca 100%);
  color: #fff; font-size: 11px; font-weight: 700;
  letter-spacing: .06em; text-transform: uppercase;
  padding: 14px 18px;
}
.admin-table tbody td { padding: 14px 18px; vertical-align: middle; color: #1a3a5c; }
.admin-table tbody tr:nth-child(even) td { background: rgba(164,202,248,.25); }
.admin-table tbody tr:nth-child(odd)  td { background: rgba(255,255,255,.45); }
.admin-table tbody tr:hover td { background: rgba(13,110,253,.12) !important; }
.admin-table tbody tr:hover td:first-child { box-shadow: inset 3px 0 0 #0d6efd; }

/* Avatar circle */
.user-avatar {
  width:38px; height:38px; border-radius:50%;
  background: linear-gradient(135deg, #1a2e4a, #243d5c);
  color: #5b9cf6; font-weight:700; font-size:14px;
  display:inline-flex; align-items:center; justify-content:center;
  flex-shrink:0; text-transform:uppercase;
  box-shadow: 0 2px 8px rgba(26,46,74,.2);
}
.user-avatar-super {
  background: linear-gradient(135deg, #1a5fcc, #2979e8);
  color: #fff;
}

/* Role badge */
.role-super {
  background: linear-gradient(135deg, rgba(41,121,232,.18), rgba(41,121,232,.10));
  color: #0d4fa8; border: 1px solid rgba(41,121,232,.4);
  padding: 4px 12px; border-radius: 20px;
  font-size: 11.5px; font-weight: 700;
  display: inline-flex; align-items: center; gap: 5px;
}
.role-admin {
  background: rgba(26,46,74,.08); color: #1a2e4a;
  border: 1px solid rgba(26,46,74,.22);
  padding: 4px 12px; border-radius: 20px;
  font-size: 11.5px; font-weight: 700;
  display: inline-flex; align-items: center; gap: 5px;
}

/* Status pill */
.status-activo {
  background: #e8f8f1; color: #1a7a4a;
  border: 1px solid #a3d9be;
  padding: 4px 12px; border-radius: 20px; font-size: 11.5px; font-weight: 700;
  display: inline-flex; align-items: center; gap: 5px;
}
.status-activo::before {
  content:''; width:6px; height:6px; border-radius:50%;
  background:#1a7a4a; display:inline-block;
  box-shadow: 0 0 0 2px rgba(26,122,74,.2);
  animation: pulse-green 2s infinite;
}
@keyframes pulse-green {
  0%,100%{ box-shadow:0 0 0 2px rgba(26,122,74,.2); }
  50%    { box-shadow:0 0 0 5px rgba(26,122,74,.05); }
}
.status-inactivo {
  background: #fdf0f0; color: #c0392b;
  border: 1px solid #f5c6c6;
  padding: 4px 12px; border-radius: 20px; font-size: 11.5px; font-weight: 700;
  display: inline-flex; align-items: center; gap: 5px;
}
.status-inactivo::before {
  content:''; width:6px; height:6px; border-radius:50%;
  background:#c0392b; display:inline-block;
}

/* Current user row */
.tr-current td { background: rgba(41,121,232,.06) !important; }
.current-tag {
  font-size:10px; background: rgba(41,121,232,.15); color:#0d4fa8;
  border:1px solid rgba(41,121,232,.3); padding:2px 8px; border-radius:10px; margin-left:6px;
  vertical-align: middle;
}

/* Username chip */
.username-chip {
  font-family: monospace; font-size:13px; font-weight:600;
  background: rgba(41,121,232,.10); padding:3px 10px;
  border-radius:6px; color:#0d4fa8;
  border: 1px solid rgba(41,121,232,.2);
}

/* Form labels in modals */
.flabel {
  font-size:10.5px; text-transform:uppercase; letter-spacing:.06em;
  color:var(--muted); font-weight:700; margin-bottom:5px; display:block;
}
.modal-tab {
  display:flex; gap:4px; margin-bottom:20px;
  background: rgba(164,202,248,.3); padding:4px; border-radius:8px;
  border: 1px solid rgba(79,156,232,.2);
}
.modal-tab-btn {
  flex:1; padding:8px; border:none; background:transparent;
  border-radius:6px; font-size:12px; font-weight:600; color:var(--muted);
  cursor:pointer; transition:all .2s;
}
.modal-tab-btn.active {
  background: linear-gradient(135deg, #0d6efd, #0a58ca);
  color: #fff;
  box-shadow: 0 2px 8px rgba(13,110,253,.35);
}
</style>
</head>
<body>

<jsp:include page="/WEB-INF/vistas/sidebar.jsp"/>

<div class="main">
  <div class="topbar">
    <h1><i class="fas fa-shield-halved topbar-icon"></i> Panel de Administradores</h1>
    <button class="btn-primary" onclick="abrirModalNuevo()">
      <i class="fas fa-user-plus"></i> Nuevo Administrador
    </button>
  </div>

  <div class="content">

    <c:if test="${not empty param.mensaje}">
      <div class="alert-c alert-success"><i class="fas fa-circle-check"></i> ${param.mensaje}</div>
    </c:if>
    <c:if test="${not empty param.error}">
      <div class="alert-c alert-danger"><i class="fas fa-circle-exclamation"></i> ${param.error}</div>
    </c:if>

    <%-- ═══ HERO BANNER ═══ --%>
    <div class="admin-hero">
      <div style="display:flex;align-items:center;gap:20px;z-index:1;">
        <div class="hero-icon-wrap"><i class="fas fa-shield-halved"></i></div>
        <div>
          <div class="hero-title">Panel de Control de Acceso</div>
          <div class="hero-sub">
            Gestiona los administradores del sistema.<br>
            <span style="color:#5b9cf6;font-weight:600;">Solo los Super Administradores</span>
            pueden acceder a este panel.
          </div>
        </div>
      </div>
      <div style="display:flex;gap:12px;z-index:1;flex-wrap:wrap;">
        <div class="hero-stat">
          <div class="hero-stat-num">${usuarios.size()}</div>
          <div class="hero-stat-lbl">Total usuarios</div>
        </div>
        <div class="hero-stat">
          <div class="hero-stat-num">
            <c:set var="superCount" value="0"/>
            <c:forEach var="u" items="${usuarios}">
              <c:if test="${u.esSuperAdmin}"><c:set var="superCount" value="${superCount + 1}"/></c:if>
            </c:forEach>
            ${superCount}
          </div>
          <div class="hero-stat-lbl">SuperAdmins</div>
        </div>
        <div class="hero-stat">
          <div class="hero-stat-num">
            <c:set var="activoCount" value="0"/>
            <c:forEach var="u" items="${usuarios}">
              <c:if test="${u.activo}"><c:set var="activoCount" value="${activoCount + 1}"/></c:if>
            </c:forEach>
            ${activoCount}
          </div>
          <div class="hero-stat-lbl">Activos</div>
        </div>
      </div>
    </div>

    <%-- ═══ TABLA ═══ --%>
    <div class="card-table">
      <div class="card-table-wrap">
        <table class="admin-table" style="width:100%;border-collapse:collapse;font-size:13px;">
          <thead>
            <tr>
              <th>Administrador</th>
              <th>Usuario</th>
              <th>Email</th>
              <th>Rol</th>
              <th>Estado</th>
              <th style="text-align:center;">Acciones</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach items="${usuarios}" var="u">
              <tr class="${u.idUsuario == sessionScope.usuario.idUsuario ? 'tr-current' : ''}">
                <td>
                  <div style="display:flex;align-items:center;gap:12px;">
                    <div class="user-avatar ${u.esSuperAdmin ? 'user-avatar-super' : ''}">
                      ${u.nombreCompleto.substring(0,1)}
                    </div>
                    <div>
                      <div style="font-weight:700;color:var(--navy);">
                        ${u.nombreCompleto}
                        <c:if test="${u.idUsuario == sessionScope.usuario.idUsuario}">
                          <span class="current-tag"><i class="fas fa-circle-dot" style="font-size:8px;"></i> Tu</span>
                        </c:if>
                      </div>
                      
                    </div>
                  </div>
                </td>
                <td>
                  <span class="username-chip">@${u.username}</span>
                </td>
                <td style="font-size:12.5px;color:var(--muted);">
                  <i class="fas fa-envelope" style="font-size:11px;margin-right:5px;color:var(--faint);"></i>
                  ${not empty u.email ? u.email : '&mdash;'}
                </td>
                <td>
                  <c:choose>
                    <c:when test="${u.esSuperAdmin}">
                      <span class="role-super">
                        <i class="fas fa-crown" style="font-size:10px;"></i> SuperAdmin
                      </span>
                    </c:when>
                    <c:otherwise>
                      <span class="role-admin">
                        <i class="fas fa-user-tie" style="font-size:10px;"></i> Administrador
                      </span>
                    </c:otherwise>
                  </c:choose>
                </td>
                <td>
                  <c:choose>
                    <c:when test="${u.activo}">
                      <span class="status-activo">Activo</span>
                    </c:when>
                    <c:otherwise>
                      <span class="status-inactivo"><i class="fas fa-ban" style="font-size:9px;"></i> Inactivo</span>
                    </c:otherwise>
                  </c:choose>
                </td>
                <td>
                  <div style="display:flex;gap:6px;justify-content:center;">
                    <button class="btn-icon btn-icon-edit" title="Editar administrador"
                      onclick="abrirModalEditar(${u.idUsuario},'${u.username}','${u.nombreCompleto}','${u.email}',${u.activo},${u.esSuperAdmin})">
                      <i class="fas fa-pen"></i>
                    </button>
                    <c:if test="${u.idUsuario ne sessionScope.usuario.idUsuario}">
                      <button class="btn-icon btn-icon-del" title="Desactivar cuenta"
                        onclick="confirmarDesactivar('${u.idUsuario}','${u.nombreCompleto}',${u.activo})">
                        <i class="fas fa-ban"></i>
                      </button>
                    </c:if>
                  </div>
                </td>
              </tr>
            </c:forEach>
            <c:if test="${empty usuarios}">
              <tr><td colspan="6" class="sin-datos"><i class="fas fa-users"></i> No hay administradores registrados.</td></tr>
            </c:if>
          </tbody>
        </table>
      </div>
      <c:if test="${not empty usuarios}">
        <div class="table-footer">
          <span><strong>${usuarios.size()}</strong> administrador(es) registrado(s)</span>
          <span style="font-size:11.5px;color:var(--faint);">
            <i class="fas fa-lock" style="margin-right:4px;"></i> Area restringida
          </span>
        </div>
      </c:if>
    </div>
  </div>
</div>

<%-- ═══ MODAL DESACTIVAR ═══ --%>
<div class="modal fade" id="modalDesactivar" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content" style="border-radius:14px;overflow:hidden;border:none;box-shadow:var(--shadow-lg);">
      <div class="modal-header modal-header-dark">
        <h5 class="modal-title"><i class="fas fa-user-slash me-2"></i> <span id="desacTituloModal">Desactivar cuenta</span></h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" style="filter:invert(1);"></button>
      </div>
      <div class="modal-body text-center" style="padding:36px 28px;">
        <div class="modal-icon-wrap modal-icon-warn" style="width:78px;height:78px;">
          <i id="desacIcono" class="fas fa-user-slash" style="font-size:32px;color:#2979e8;"></i>
        </div>
        <div style="font-size:17px;font-weight:800;color:var(--navy);margin-bottom:6px;" id="desacNombre"></div>
        <div id="desacMensaje" class="modal-warn-box" style="text-align:left;"></div>
      </div>
      <div class="modal-footer" style="border-top:1px solid var(--border);justify-content:center;gap:12px;">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
        <a id="desacLink" href="#" class="btn btn-danger"><i class="fas fa-ban me-1"></i> <span id="desacBtnTxt">Desactivar</span></a>
      </div>
    </div>
  </div>
</div>

<%-- ═══ MODAL NUEVO ═══ --%>
<div class="modal fade" id="modalNuevo" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content" style="border-radius:14px;overflow:hidden;border:none;box-shadow:var(--shadow-lg);">
      <div class="modal-header modal-header-dark">
        <h5 class="modal-title"><i class="fas fa-user-plus me-2"></i> Nuevo Administrador</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" style="filter:invert(1);"></button>
      </div>
      <form action="${pageContext.request.contextPath}/usuarios" method="post">
        <input type="hidden" name="action" value="create"/>
        <div class="modal-body" style="padding:28px;">

          <%-- Selector de rol visual --%>
          <label class="flabel">Tipo de cuenta</label>
          <div class="modal-tab mb-3" id="rolTabNuevo">
            <button type="button" class="modal-tab-btn active" onclick="setRol(false,'nuevo')" id="tabAdmNuevo">
              <i class="fas fa-user-tie me-1"></i> Administrador
            </button>
            <button type="button" class="modal-tab-btn" onclick="setRol(true,'nuevo')" id="tabSuperNuevo">
              <i class="fas fa-crown me-1"></i> Super Admin
            </button>
          </div>
          <input type="hidden" name="esSuperAdmin" id="hiddenSuperNuevo" value="false"/>

          <div class="row g-3">
            <div class="col-12">
              <label class="flabel">Usuario *</label>
              <input type="text" name="username" class="form-control" required maxlength="50" placeholder="Ej: jperez"/>
            </div>
            <div class="col-12">
              <label class="flabel">Contraseña *</label>
              <div style="position:relative;">
                <input type="password" name="password" id="pwdNuevo" class="form-control" required minlength="6" placeholder="Minimo 6 caracteres" style="padding-right:40px;"/>
                <button type="button" onclick="togglePwd('pwdNuevo','eyeNuevo')"
                  style="position:absolute;right:10px;top:50%;transform:translateY(-50%);background:none;border:none;color:var(--muted);cursor:pointer;">
                  <i class="fas fa-eye" id="eyeNuevo"></i>
                </button>
              </div>
            </div>
            <div class="col-12">
              <label class="flabel">Nombre Completo *</label>
              <input type="text" name="nombreCompleto" class="form-control" required maxlength="100"/>
            </div>
            <div class="col-12">
              <label class="flabel">Email</label>
              <input type="email" name="email" class="form-control" maxlength="100" placeholder="usuario@registraduria.gov.co"/>
            </div>
          </div>
        </div>
        <div class="modal-footer" style="border-top:1px solid var(--border);">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
          <button type="submit" class="btn-primary"><i class="fas fa-floppy-disk me-1"></i> Guardar</button>
        </div>
      </form>
    </div>
  </div>
</div>

<%-- ═══ MODAL EDITAR ═══ --%>
<div class="modal fade" id="modalEditar" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content" style="border-radius:14px;overflow:hidden;border:none;box-shadow:var(--shadow-lg);">
      <div class="modal-header modal-header-dark">
        <h5 class="modal-title"><i class="fas fa-pen me-2"></i> Editar Administrador</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" style="filter:invert(1);"></button>
      </div>
      <form action="${pageContext.request.contextPath}/usuarios" method="post">
        <input type="hidden" name="action" value="update"/>
        <input type="hidden" name="id" id="editId"/>
        <div class="modal-body" style="padding:28px;">

          <label class="flabel">Tipo de cuenta</label>
          <div class="modal-tab mb-3">
            <button type="button" class="modal-tab-btn" onclick="setRol(false,'edit')" id="tabAdmEdit">
              <i class="fas fa-user-tie me-1"></i> Administrador
            </button>
            <button type="button" class="modal-tab-btn" onclick="setRol(true,'edit')" id="tabSuperEdit">
              <i class="fas fa-crown me-1"></i> Super Admin
            </button>
          </div>
          <input type="hidden" name="esSuperAdmin" id="hiddenSuperEdit" value="false"/>

          <div class="row g-3">
            <div class="col-12">
              <label class="flabel">Usuario *</label>
              <input type="text" name="username" id="editUsername" class="form-control" required maxlength="50"/>
            </div>
            <div class="col-12">
              <label class="flabel">Nombre Completo *</label>
              <input type="text" name="nombreCompleto" id="editNombre" class="form-control" required maxlength="100"/>
            </div>
            <div class="col-12">
              <label class="flabel">Email</label>
              <input type="email" name="email" id="editEmail" class="form-control" maxlength="100"/>
            </div>
            <div class="col-12">
              <label class="flabel">Estado de la cuenta</label>
              <div style="display:flex;gap:10px;">
                <label style="flex:1;cursor:pointer;">
                  <input type="radio" name="activo" value="on" id="editActivoSi" style="display:none;">
                  <div class="estado-toggle" id="toggleActivoSi"
                    style="border:2px solid var(--border);border-radius:10px;padding:10px 14px;
                           display:flex;align-items:center;gap:8px;font-size:13px;font-weight:600;
                           transition:all .2s;color:var(--muted);">
                    <i class="fas fa-circle-check" style="font-size:16px;"></i> Activo
                  </div>
                </label>
                <label style="flex:1;cursor:pointer;">
                  <input type="radio" name="activo" value="off" id="editActivoNo" style="display:none;">
                  <div class="estado-toggle" id="toggleActivoNo"
                    style="border:2px solid var(--border);border-radius:10px;padding:10px 14px;
                           display:flex;align-items:center;gap:8px;font-size:13px;font-weight:600;
                           transition:all .2s;color:var(--muted);">
                    <i class="fas fa-ban" style="font-size:16px;"></i> Inactivo
                  </div>
                </label>
              </div>
            </div>
          </div>
        </div>
        <div class="modal-footer" style="border-top:1px solid var(--border);">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
          <button type="submit" class="btn-primary"><i class="fas fa-floppy-disk me-1"></i> Actualizar</button>
        </div>
      </form>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
// ── Helpers ────────────────────────────────────────────────────────────
function togglePwd(inputId, eyeId) {
  const inp = document.getElementById(inputId);
  const eye = document.getElementById(eyeId);
  if (inp.type === 'password') {
    inp.type = 'text';
    eye.className = 'fas fa-eye-slash';
  } else {
    inp.type = 'password';
    eye.className = 'fas fa-eye';
  }
}

function setRol(isSuper, ctx) {
  const tabAdm   = document.getElementById('tabAdm'   + (ctx==='nuevo' ? 'Nuevo' : 'Edit'));
  const tabSuper = document.getElementById('tabSuper' + (ctx==='nuevo' ? 'Nuevo' : 'Edit'));
  const hidden   = document.getElementById('hiddenSuper' + (ctx==='nuevo' ? 'Nuevo' : 'Edit'));
  if (isSuper) {
    tabSuper.classList.add('active');
    tabAdm.classList.remove('active');
    hidden.value = 'on';
  } else {
    tabAdm.classList.add('active');
    tabSuper.classList.remove('active');
    hidden.value = 'false';
  }
}

function setEstadoToggle(activo) {
  const si  = document.getElementById('toggleActivoSi');
  const no  = document.getElementById('toggleActivoNo');
  const rSi = document.getElementById('editActivoSi');
  const rNo = document.getElementById('editActivoNo');
  if (activo) {
    si.style.borderColor='#1a7a4a'; si.style.background='#e8f8f1'; si.style.color='#1a7a4a';
    no.style.borderColor='var(--border)'; no.style.background=''; no.style.color='var(--muted)';
    rSi.checked = true;
  } else {
    no.style.borderColor='#c0392b'; no.style.background='#fdf0f0'; no.style.color='#c0392b';
    si.style.borderColor='var(--border)'; si.style.background=''; si.style.color='var(--muted)';
    rNo.checked = true;
  }
}

// Click on toggle divs
document.getElementById('toggleActivoSi').addEventListener('click', () => setEstadoToggle(true));
document.getElementById('toggleActivoNo').addEventListener('click', () => setEstadoToggle(false));

// ── Modal openers ──────────────────────────────────────────────────────
function abrirModalNuevo() {
  new bootstrap.Modal(document.getElementById('modalNuevo')).show();
}

function abrirModalEditar(id, username, nombre, email, activo, superAdmin) {
  document.getElementById('editId').value       = id;
  document.getElementById('editUsername').value = username;
  document.getElementById('editNombre').value   = nombre;
  document.getElementById('editEmail').value    = email || '';
  setRol(superAdmin, 'edit');
  setEstadoToggle(activo);
  new bootstrap.Modal(document.getElementById('modalEditar')).show();
}

function confirmarDesactivar(id, nombre, activo) {
  const titulo = document.getElementById('desacTituloModal');
  const icono  = document.getElementById('desacIcono');
  const msg    = document.getElementById('desacMensaje');
  const btn    = document.getElementById('desacBtnTxt');
  const link   = document.getElementById('desacLink');
  document.getElementById('desacNombre').textContent = nombre;

  if (activo) {
    titulo.textContent = 'Desactivar cuenta';
    icono.className    = 'fas fa-user-slash';
    icono.style.color  = '#2979e8';
    msg.innerHTML      = '<i class="fas fa-info-circle me-1"></i> Al desactivar esta cuenta, el administrador <strong>no podra iniciar sesion</strong> hasta que la reactives desde el boton de editar.';
    btn.textContent    = 'Desactivar';
    link.className     = 'btn btn-danger';
  } else {
    titulo.textContent = 'Reactivar cuenta';
    icono.className    = 'fas fa-user-check';
    icono.style.color  = '#1a7a4a';
    msg.innerHTML      = '<i class="fas fa-info-circle me-1"></i> Al reactivar esta cuenta, el administrador <strong>podra volver a iniciar sesion</strong> con sus credenciales.';
    btn.textContent    = 'Reactivar';
    link.className     = 'btn btn-success';
  }
  link.href = '${pageContext.request.contextPath}/usuarios?action=delete&id=' + id;
  new bootstrap.Modal(document.getElementById('modalDesactivar')).show();
}

// Auto-dismiss alerts
setTimeout(() => {
  document.querySelectorAll('.alert-c').forEach(a => {
    a.style.transition = 'opacity .5s'; a.style.opacity = '0';
    setTimeout(() => a.remove(), 500);
  });
}, 4500);
</script>
</body>
</html>

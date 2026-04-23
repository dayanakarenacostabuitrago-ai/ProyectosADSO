<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core"      prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt"       prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<c:set var="currentPage" value="notificaciones" scope="request"/>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Notificaciones — Registraduría de Nobsa</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css"/>
<style>
/* ── Hero ── */
.notif-hero {
  background: linear-gradient(135deg, #0d1826 0%, #1a2e4a 45%, #243d5c 100%);
  border-radius: 16px; padding: 32px 36px; margin-bottom: 24px;
  position: relative; overflow: hidden; display: flex;
  align-items: center; justify-content: space-between; gap: 20px;
  box-shadow: rgba(200,168,75,.35) 3px 3px 10px 0, rgba(200,168,75,.2) 5px 5px 28px 0;
  border: 1.5px solid rgba(200,168,75,.25);
}
.notif-hero::before{content:'';position:absolute;top:-50px;right:-50px;width:200px;height:200px;border-radius:50%;background:rgba(200,168,75,.06);pointer-events:none;}
.notif-hero-icon{width:66px;height:66px;border-radius:16px;background:linear-gradient(135deg,#8a6a1a 0%,#c8a84b 60%,#e6c96a 100%);display:flex;align-items:center;justify-content:center;font-size:28px;color:#0b2346;flex-shrink:0;box-shadow:0 6px 20px rgba(200,168,75,.45);}
.notif-hero-title{font-size:22px;font-weight:800;color:#fff;margin-bottom:4px;}
.notif-hero-sub{font-size:13px;color:#8aa0b8;}
.notif-hero-sub span{color:#c8a84b;font-weight:600;}
.stat-box{text-align:center;padding:16px 22px;background:rgba(200,168,75,.1);border-radius:12px;border:1px solid rgba(200,168,75,.22);flex-shrink:0;min-width:100px;}
.stat-num{font-size:28px;font-weight:800;color:#c8a84b;line-height:1;}
.stat-lbl{font-size:10px;color:#8aa0b8;margin-top:4px;text-transform:uppercase;letter-spacing:.06em;}

/* ── Filtros ── */
.filtros-bar{display:flex;gap:8px;flex-wrap:wrap;margin-bottom:18px;}
.filtro-btn{padding:7px 16px;border-radius:20px;border:1.5px solid #dce3ef;background:#fff;font-size:12px;font-weight:600;cursor:pointer;transition:all .2s;display:inline-flex;align-items:center;gap:6px;color:#6b7c93;}
.filtro-btn:hover{border-color:#163a6b;color:#163a6b;}
.filtro-btn.active{background:#0b2346;border-color:#0b2346;color:#fff;}
.filtro-btn .badge-count{background:rgba(255,255,255,.2);padding:2px 7px;border-radius:10px;font-size:11px;}
.filtro-btn.active .badge-count{background:rgba(255,255,255,.25);}

/* ── Tarjetas de solicitud ── */
.solicitud-card{background:#fff;border-radius:14px;box-shadow:0 2px 12px rgba(11,35,70,.08);border:1.5px solid #e8eef6;margin-bottom:14px;overflow:hidden;transition:box-shadow .2s,transform .15s;}
.solicitud-card:hover{box-shadow:0 6px 24px rgba(11,35,70,.14);transform:translateY(-1px);}
.solicitud-card.pendiente{border-left:4px solid #c8a84b;}
.solicitud-card.aceptada{border-left:4px solid #0f7a3d;}
.solicitud-card.rechazada{border-left:4px solid #b91c1c;}

.sc-header{padding:18px 22px 12px;display:flex;align-items:flex-start;justify-content:space-between;gap:12px;}
.sc-avatar{width:44px;height:44px;border-radius:50%;background:linear-gradient(135deg,#0b2346,#1e4d8c);color:#c8a84b;font-weight:800;font-size:15px;display:flex;align-items:center;justify-content:center;flex-shrink:0;text-transform:uppercase;}
.sc-nombre{font-size:15px;font-weight:700;color:#0b2346;margin-bottom:2px;}
.sc-doc{font-size:12px;color:#6b7c93;}
.sc-meta{font-size:11px;color:#9ab;margin-top:2px;}

.estado-badge{display:inline-flex;align-items:center;gap:5px;padding:5px 12px;border-radius:20px;font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:.06em;flex-shrink:0;}
.estado-PENDIENTE{background:#fffbea;color:#92400e;border:1px solid #fcd34d;}
.estado-ACEPTADA {background:#f0fdf4;color:#166534;border:1px solid #86efac;}
.estado-RECHAZADA{background:#fef2f2;color:#991b1b;border:1px solid #fca5a5;}

.sc-body{padding:0 22px 16px;}
.tipo-chip{display:inline-flex;align-items:center;gap:6px;background:#f0f4ff;color:#1e4d8c;border-radius:8px;padding:5px 12px;font-size:12px;font-weight:600;margin-bottom:10px;}
.sc-desc{font-size:13px;color:#374151;line-height:1.6;background:#f8fafc;border-radius:8px;padding:12px 14px;}

.sc-respuesta{margin:12px 22px 0;padding:12px 14px;background:#f0f4ff;border-left:3px solid #0b2346;border-radius:6px;}
.sc-respuesta-lbl{font-size:10px;font-weight:700;color:#6b7c93;letter-spacing:.08em;text-transform:uppercase;margin-bottom:4px;}
.sc-respuesta-text{font-size:13px;color:#1a2535;}
.sc-respuesta-admin{font-size:11px;color:#9ab;margin-top:4px;}

.sc-footer{padding:12px 22px 16px;display:flex;gap:8px;flex-wrap:wrap;}
.btn-aceptar{background:linear-gradient(135deg,#0f7a3d,#16a34a);color:#fff;border:none;padding:9px 20px;border-radius:9px;font-size:12px;font-weight:700;cursor:pointer;display:inline-flex;align-items:center;gap:6px;transition:all .2s;}
.btn-aceptar:hover{transform:translateY(-1px);box-shadow:0 4px 14px rgba(15,122,61,.35);}
.btn-rechazar{background:linear-gradient(135deg,#b91c1c,#dc2626);color:#fff;border:none;padding:9px 20px;border-radius:9px;font-size:12px;font-weight:700;cursor:pointer;display:inline-flex;align-items:center;gap:6px;transition:all .2s;}
.btn-rechazar:hover{transform:translateY(-1px);box-shadow:0 4px 14px rgba(185,28,28,.35);}

/* ── Empty state ── */
.empty-state{text-align:center;padding:60px 20px;color:#9ab;}
.empty-state i{font-size:48px;margin-bottom:16px;display:block;opacity:.4;}
.empty-state p{font-size:14px;}

/* ── Modal de respuesta ── */
.modal-resp .modal-header{background:linear-gradient(135deg,#0d1826,#1a2e4a);color:#fff;border:none;}
.modal-resp .modal-title{color:#fff;font-weight:700;}
.modal-resp .btn-close{filter:invert(1);}
.resp-textarea{width:100%;border:2px solid #dce3ef;border-radius:10px;padding:12px 14px;font-family:inherit;font-size:14px;outline:none;resize:vertical;min-height:90px;transition:border-color .2s;}
.resp-textarea:focus{border-color:#163a6b;box-shadow:0 0 0 4px rgba(22,58,107,.10);}

/* ── Alert ── */
.alert-c{display:flex;align-items:center;gap:10px;padding:13px 18px;border-radius:10px;font-size:14px;margin-bottom:16px;}
.alert-success-c{background:#f0fdf4;border:1px solid #86efac;color:#166534;}
.alert-danger-c {background:#fef2f2;border:1px solid #fca5a5;color:#991b1b;}
</style>
</head>
<body>

<jsp:include page="/WEB-INF/vistas/sidebar.jsp"/>

<div class="main">
  <div class="topbar">
    <h1><i class="fas fa-bell topbar-icon"></i> Notificaciones y Solicitudes</h1>
  </div>

  <div class="content">

    <!-- Alertas de acción -->
    <c:if test="${param.ok eq 'aceptada'}">
      <div class="alert-c alert-success-c"><i class="fas fa-circle-check"></i> Solicitud <strong>aceptada</strong> correctamente. El ciudadano fue notificado por correo.</div>
    </c:if>
    <c:if test="${param.ok eq 'rechazada'}">
      <div class="alert-c alert-success-c"><i class="fas fa-circle-check"></i> Solicitud <strong>rechazada</strong>. El ciudadano fue notificado por correo.</div>
    </c:if>
    <c:if test="${not empty param.error}">
      <div class="alert-c alert-danger-c"><i class="fas fa-circle-exclamation"></i> Ocurrió un error al procesar la solicitud. Inténtalo de nuevo.</div>
    </c:if>
    <c:if test="${not empty errorCarga}">
      <div class="alert-c alert-danger-c"><i class="fas fa-circle-exclamation"></i> ${errorCarga}</div>
    </c:if>

    <!-- Hero con stats -->
    <div class="notif-hero">
      <div style="display:flex;align-items:center;gap:18px;">
        <div class="notif-hero-icon"><i class="fas fa-bell"></i></div>
        <div>
          <div class="notif-hero-title">Centro de Notificaciones</div>
          <div class="notif-hero-sub">
            Solicitudes ciudadanas ·
            <span>${totalPendientes} pendiente${totalPendientes != 1 ? 's' : ''}</span>
          </div>
        </div>
      </div>
      <div style="display:flex;gap:12px;flex-wrap:wrap;">
        <div class="stat-box">
          <div class="stat-num">${solicitudes.size()}</div>
          <div class="stat-lbl">Total</div>
        </div>
        <div class="stat-box">
          <div class="stat-num" style="color:#e6c96a;">${totalPendientes}</div>
          <div class="stat-lbl">Pendientes</div>
        </div>
        <div class="stat-box">
          <c:set var="countAcept" value="0"/>
          <c:forEach var="s" items="${solicitudes}">
            <c:if test="${s.estado eq 'ACEPTADA'}"><c:set var="countAcept" value="${countAcept + 1}"/></c:if>
          </c:forEach>
          <div class="stat-num" style="color:#4ade80;">${countAcept}</div>
          <div class="stat-lbl">Aceptadas</div>
        </div>
      </div>
    </div>

    <!-- Filtros -->
    <div class="filtros-bar">
      <button class="filtro-btn active" onclick="filtrar('todas',this)">
        <i class="fas fa-list"></i> Todas <span class="badge-count">${solicitudes.size()}</span>
      </button>
      <button class="filtro-btn" onclick="filtrar('PENDIENTE',this)">
        <i class="fas fa-clock"></i> Pendientes <span class="badge-count">${totalPendientes}</span>
      </button>
      <button class="filtro-btn" onclick="filtrar('ACEPTADA',this)">
        <i class="fas fa-check-circle"></i> Aceptadas
      </button>
      <button class="filtro-btn" onclick="filtrar('RECHAZADA',this)">
        <i class="fas fa-times-circle"></i> Rechazadas
      </button>
    </div>

    <!-- Lista de solicitudes -->
    <c:choose>
      <c:when test="${empty solicitudes}">
        <div class="empty-state">
          <i class="fas fa-inbox"></i>
          <p><strong>No hay solicitudes aún</strong><br>Las solicitudes enviadas por los ciudadanos aparecerán aquí.</p>
        </div>
      </c:when>
      <c:otherwise>
        <div id="lista-solicitudes">
          <c:forEach var="s" items="${solicitudes}">
            <%-- estado en minúscula para clase CSS --%>
            <c:choose>
              <c:when test="${s.estado eq 'ACEPTADA'}"><c:set var="estadoLower" value="aceptada"/></c:when>
              <c:when test="${s.estado eq 'RECHAZADA'}"><c:set var="estadoLower" value="rechazada"/></c:when>
              <c:otherwise><c:set var="estadoLower" value="pendiente"/></c:otherwise>
            </c:choose>
            <div class="solicitud-card ${estadoLower}" data-estado="${s.estado}">

              <div class="sc-header">
                <div style="display:flex;align-items:center;gap:12px;flex:1;">
                  <div class="sc-avatar">${s.iniciales}</div>
                  <div>
                    <div class="sc-nombre">${s.nombres} ${s.apellidos}</div>
                    <div class="sc-doc"><i class="fas fa-id-card" style="margin-right:4px;"></i>${s.numeroDocumento}
                      <c:if test="${not empty s.telefono}"> &nbsp;·&nbsp; <i class="fas fa-phone" style="margin-right:3px;"></i>${s.telefono}</c:if>
                    </div>
                    <div class="sc-meta">
                      <i class="fas fa-envelope" style="margin-right:3px;"></i>${s.correo} &nbsp;·&nbsp;
                      <i class="fas fa-calendar" style="margin-right:3px;"></i>${s.fechaFormateada}
                      &nbsp;·&nbsp; #${s.id}
                    </div>
                  </div>
                </div>
                <span class="estado-badge estado-${s.estado}">
                  <c:choose>
                    <c:when test="${s.estado eq 'PENDIENTE'}"><i class="fas fa-clock"></i></c:when>
                    <c:when test="${s.estado eq 'ACEPTADA'}"><i class="fas fa-check"></i></c:when>
                    <c:otherwise><i class="fas fa-times"></i></c:otherwise>
                  </c:choose>
                  ${s.estado}
                </span>
              </div>

              <div class="sc-body">
                <div class="tipo-chip">
                  <i class="fas fa-tag"></i> ${s.tipoSolicitud}
                </div>
                <div class="sc-desc">${s.descripcion}</div>
              </div>

              <c:if test="${not empty s.respuestaAdmin}">
                <div class="sc-respuesta">
                  <div class="sc-respuesta-lbl">Respuesta del administrador</div>
                  <div class="sc-respuesta-text">${s.respuestaAdmin}</div>
                  <c:if test="${not empty s.adminRespondio}">
                    <div class="sc-respuesta-admin">— ${s.adminRespondio}</div>
                  </c:if>
                </div>
              </c:if>

              <c:if test="${s.estado eq 'PENDIENTE'}">
                <div class="sc-footer">
                  <button class="btn-aceptar" onclick="abrirModal(${s.id}, '${s.nombres} ${s.apellidos}', 'ACEPTADA')">
                    <i class="fas fa-check"></i> Aceptar
                  </button>
                  <button class="btn-rechazar" onclick="abrirModal(${s.id}, '${s.nombres} ${s.apellidos}', 'RECHAZADA')">
                    <i class="fas fa-times"></i> Rechazar
                  </button>
                </div>
              </c:if>

            </div>
          </c:forEach>
        </div>
      </c:otherwise>
    </c:choose>

  </div><!-- /content -->
</div><!-- /main -->

<!-- ── Modal de respuesta ── -->
<div class="modal fade" id="modalRespuesta" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered modal-resp">
    <div class="modal-content" style="border-radius:14px;overflow:hidden;border:none;">
      <div class="modal-header">
        <h5 class="modal-title" id="modal-titulo"><i class="fas fa-reply" style="margin-right:8px;"></i>Responder solicitud</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body" style="padding:24px;">
        <p id="modal-desc" style="font-size:13px;color:#555;margin-bottom:16px;"></p>
        <label style="font-size:12px;font-weight:700;color:#6b7c93;letter-spacing:.07em;text-transform:uppercase;display:block;margin-bottom:8px;">
          Mensaje al ciudadano <span style="color:#b91c1c;">*</span>
        </label>
        <textarea class="resp-textarea" id="resp-texto"
                  placeholder="Escribe aquí la respuesta que recibirá el ciudadano por correo electrónico..."
                  maxlength="800"></textarea>
        <div style="font-size:11px;color:#9ab;margin-top:4px;">El ciudadano recibirá un correo con esta respuesta.</div>
      </div>
      <div class="modal-footer" style="border:none;padding:16px 24px;gap:10px;">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
        <button type="button" class="btn" id="btn-confirmar-resp" onclick="confirmarRespuesta()" style="font-weight:700;">
          Confirmar
        </button>
      </div>
    </div>
  </div>
</div>

<!-- Form oculto para POST -->
<form id="form-resp" method="post" action="${pageContext.request.contextPath}/notificaciones" style="display:none;">
  <input type="hidden" name="id"        id="resp-id">
  <input type="hidden" name="accion"    id="resp-accion">
  <input type="hidden" name="respuesta" id="resp-final">
</form>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
let modalAccion = '';

function abrirModal(id, nombre, accion) {
  modalAccion = accion;
  document.getElementById('resp-id').value = id;
  document.getElementById('resp-accion').value = accion;
  document.getElementById('resp-texto').value = '';

  const esCiudadano = nombre;
  const isAcept = accion === 'ACEPTADA';

  document.getElementById('modal-titulo').innerHTML =
    (isAcept ? '<i class="fas fa-check-circle" style="color:#4ade80;margin-right:8px;"></i>Aceptar solicitud'
             : '<i class="fas fa-times-circle" style="color:#f87171;margin-right:8px;"></i>Rechazar solicitud');

  document.getElementById('modal-desc').textContent =
    'Ciudadano: ' + nombre + ' · La respuesta se enviará inmediatamente por correo electrónico.';

  const btnConf = document.getElementById('btn-confirmar-resp');
  if (isAcept) {
    btnConf.style.background = '#16a34a'; btnConf.style.color = '#fff'; btnConf.style.border = 'none';
    btnConf.textContent = '✓ Confirmar aceptación';
  } else {
    btnConf.style.background = '#dc2626'; btnConf.style.color = '#fff'; btnConf.style.border = 'none';
    btnConf.textContent = '✗ Confirmar rechazo';
  }

  new bootstrap.Modal(document.getElementById('modalRespuesta')).show();
}

function confirmarRespuesta() {
  const texto = document.getElementById('resp-texto').value.trim();
  if (!texto) { alert('Por favor escribe una respuesta para el ciudadano.'); return; }
  document.getElementById('resp-final').value = texto;
  document.getElementById('form-resp').submit();
}

function filtrar(estado, btn) {
  document.querySelectorAll('.filtro-btn').forEach(b => b.classList.remove('active'));
  btn.classList.add('active');
  document.querySelectorAll('.solicitud-card').forEach(card => {
    card.style.display = (estado === 'todas' || card.dataset.estado === estado) ? '' : 'none';
  });
}
</script>
</body>
</html>

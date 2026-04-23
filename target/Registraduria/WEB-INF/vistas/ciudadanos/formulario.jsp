<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${accion == 'create' ? 'Nuevo' : 'Editar'} Ciudadano - Registraduria de Nobsa</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
<style>
  body { font-family: 'Segoe UI', Arial, sans-serif; background: #f0f2f5; display: flex; min-height: 100vh; }
  .sidebar { width: 240px; background: #1a2e4a; display: flex; flex-direction: column; flex-shrink: 0; position: fixed; top: 0; left: 0; height: 100vh; overflow-y: auto; z-index: 100; }
  .sidebar-logo { display: flex; align-items: center; gap: 12px; padding: 24px 20px; border-bottom: 1px solid rgba(255,255,255,.1); }
  .logo-icon { width: 40px; height: 40px; background: #c8a84b; border-radius: 8px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
  .logo-icon i { color: #1a2e4a; font-size: 18px; }
  .logo-title { color: #fff; font-size: 14px; font-weight: 700; }
  .logo-sub { color: #a0b4c8; font-size: 11px; }
  .sidebar-nav { flex: 1; padding: 16px 0; }
  .nav-section { color: #4a7a9b; font-size: 10px; font-weight: 700; letter-spacing: .08em; text-transform: uppercase; padding: 8px 20px 6px; display: flex; align-items: center; gap: 6px; }
  .nav-section-icon { font-size: 10px; color: #c8a84b; }
  .nav-item { display: flex; align-items: center; gap: 10px; padding: 10px 20px; color: #a0b4c8; text-decoration: none; font-size: 14px; border-left: 3px solid transparent; transition: all .15s; }
  .nav-item:hover { background: rgba(255,255,255,.06); color: #fff; text-decoration: none; }
  .nav-item.active { background: rgba(200,168,75,.12); color: #c8a84b; border-left-color: #c8a84b; }
  .nav-badge { background: #2d4f6e; color: #a0b4c8; font-size: 10px; padding: 2px 7px; border-radius: 10px; margin-left: auto; }
  .sidebar-footer { padding: 16px 20px; border-top: 1px solid rgba(255,255,255,.1); }
  .user-info { display: flex; align-items: center; gap: 10px; color: #a0b4c8; margin-bottom: 12px; }
  .user-info i { font-size: 20px; color: #c8a84b; }
  .btn-logout { display: flex; align-items: center; gap: 8px; color: #a0b4c8; text-decoration: none; font-size: 13px; padding: 8px 10px; border-radius: 6px; transition: background .15s; }
  .btn-logout:hover { background: rgba(255,255,255,.08); color: #fff; }
  .admin-panel-btn-wrap { text-align: center; margin-bottom: 14px; }
  .btn-admin-icon { display: inline-flex; flex-direction: column; align-items: center; gap: 4px; text-decoration: none; color: #a0b4c8; transition: all .2s; padding: 6px 12px; border-radius: 8px; }
  .btn-admin-icon:hover { color: #c8a84b; background: rgba(200,168,75,.1); }
  .admin-icon-ring { width: 36px; height: 36px; border-radius: 50%; border: 2px solid #c8a84b44; background: rgba(200,168,75,.1); display: flex; align-items: center; justify-content: center; font-size: 16px; }
  .admin-icon-label { font-size: 10px; font-weight: 600; letter-spacing: .04em; text-transform: uppercase; }
  .main { margin-left: 240px; flex: 1; display: flex; flex-direction: column; min-height: 100vh; }
  .topbar { background: #fff; border-bottom: 1px solid #e2e8ee; padding: 16px 28px; display: flex; align-items: center; gap: 14px; }
  .topbar a.back { color: #5a6a7a; font-size: 13px; text-decoration: none; display: flex; align-items: center; gap: 6px; }
  .topbar a.back:hover { color: #1a2e4a; }
  .topbar h1 { font-size: 18px; font-weight: 700; color: #1a2e4a; display: flex; align-items: center; gap: 10px; margin: 0; }
  .content { padding: 28px; flex: 1; }
  .form-card { background: #fff; border-radius: 8px; box-shadow: 0 1px 6px rgba(0,0,0,.08); max-width: 700px; overflow: hidden; }
  .form-card-header { background: #1a2e4a; color: #fff; padding: 18px 24px; display: flex; align-items: center; gap: 10px; }
  .form-card-header i { color: #c8a84b; font-size: 18px; }
  .form-card-header h2 { font-size: 16px; font-weight: 600; margin: 0; }
  .form-card-body { padding: 28px 24px; }
</style>
</head>
<body>

<aside class="sidebar">
  <div class="sidebar-logo">
    <div class="logo-icon"><i class="fas fa-landmark"></i></div>
    <div><div class="logo-title">Registraduria</div><div class="logo-sub">Municipal de Nobsa</div></div>
  </div>
  <nav class="sidebar-nav">
    <div class="nav-section"><i class="fas fa-users nav-section-icon"></i> Personas</div>
    <a href="${pageContext.request.contextPath}/ciudadanos" class="nav-item active"><i class="fas fa-user-circle"></i> Ciudadanos</a>
    <a href="${pageContext.request.contextPath}/documentos" class="nav-item"><i class="fas fa-id-card"></i> Documentos</a>
    <div class="nav-section" style="margin-top:12px;"><i class="fas fa-chair nav-section-icon"></i> Mesas</div>
    <a href="${pageContext.request.contextPath}/consultaMesa" class="nav-item"><i class="fas fa-vote-yea"></i> Consulta de Mesa <span class="nav-badge">Publico</span></a>
    <div class="nav-section" style="margin-top:12px;"><i class="fas fa-map-marked-alt nav-section-icon"></i> Zonas</div>
    <a href="${pageContext.request.contextPath}/ciudadanos?filtro=zona" class="nav-item"><i class="fas fa-layer-group"></i> Gestion de Zonas</a>
  </nav>
  <div class="sidebar-footer">
    <c:if test="${sessionScope.usuario.esSuperAdmin}">
      <div class="admin-panel-btn-wrap">
        <a href="${pageContext.request.contextPath}/usuarios" class="btn-admin-icon" title="Panel de Administradores">
          <span class="admin-icon-ring"><i class="fas fa-shield-halved"></i></span>
          <span class="admin-icon-label">Admin Panel</span>
        </a>
      </div>
    </c:if>
    <div class="user-info">
      <i class="fas fa-user-shield"></i>
      <div>
        <div style="font-size:13px;font-weight:600;color:#fff;">${sessionScope.usuario.nombreCompleto}</div>
        <div style="font-size:11px;color:#a0b4c8;">${sessionScope.usuario.esSuperAdmin ? 'Super Administrador' : 'Administrador'}</div>
      </div>
    </div>
    <a href="${pageContext.request.contextPath}/logout" class="btn-logout"><i class="fas fa-right-from-bracket"></i> Cerrar sesion</a>
  </div>
</aside>

<div class="main">
  <div class="topbar">
    <a class="back" href="${pageContext.request.contextPath}/ciudadanos"><i class="fas fa-arrow-left"></i> Volver al listado</a>
    <span style="color:#d1dbe4;">|</span>
    <h1>
      <i class="fas ${accion == 'create' ? 'fa-user-plus' : 'fa-user-pen'}" style="color:#c8a84b;"></i>
      ${accion == 'create' ? 'Nuevo Ciudadano' : 'Editar Ciudadano'}
    </h1>
  </div>

  <div class="content">
    <div class="form-card">
      <div class="form-card-header">
        <i class="fas ${accion == 'create' ? 'fa-user-plus' : 'fa-user-pen'}"></i>
        <h2>${accion == 'create' ? 'Registrar nuevo ciudadano' : 'Actualizar datos del ciudadano'}</h2>
      </div>
      <div class="form-card-body">
        <c:if test="${not empty error}">
          <div class="alert alert-danger"><i class="fas fa-circle-exclamation me-2"></i> ${error}</div>
        </c:if>
        <form action="${pageContext.request.contextPath}/ciudadanos" method="post">
          <input type="hidden" name="action" value="${accion}">
          <c:if test="${accion == 'update'}">
            <input type="hidden" name="id" value="${ciudadano.idCiudadanos}">
          </c:if>
          <div class="mb-3">
            <label class="form-label fw-semibold" style="font-size:12px;text-transform:uppercase;color:#5a6a7a;"><i class="fas fa-id-card me-1" style="color:#c8a84b;"></i> Numero de Documento *</label>
            <input type="text" name="numeroDocumento" class="form-control" value="${ciudadano.numeroDocumento}" required ${accion == 'update' ? 'readonly' : ''} style="${accion == 'update' ? 'background:#f7f9fc;color:#888;' : ''}">
          </div>
          <div class="row g-3 mb-3">
            <div class="col-md-6">
              <label class="form-label fw-semibold" style="font-size:12px;text-transform:uppercase;color:#5a6a7a;">Nombres *</label>
              <input type="text" name="nombres" class="form-control" value="${ciudadano.nombres}" required>
            </div>
            <div class="col-md-6">
              <label class="form-label fw-semibold" style="font-size:12px;text-transform:uppercase;color:#5a6a7a;">Apellidos *</label>
              <input type="text" name="apellidos" class="form-control" value="${ciudadano.apellidos}" required>
            </div>
          </div>
          <div class="mb-3">
            <label class="form-label fw-semibold" style="font-size:12px;text-transform:uppercase;color:#5a6a7a;">Fecha de Nacimiento *</label>
            <input type="date" name="fechaNacimiento" class="form-control" value="${ciudadano.fechaNacimiento}" required>
          </div>
          <div class="mb-3">
            <label class="form-label fw-semibold" style="font-size:12px;text-transform:uppercase;color:#5a6a7a;">Vereda / Barrio *</label>
            <input type="text" name="veredaBarrio" class="form-control" value="${ciudadano.veredaBarrio}" required>
          </div>
          <div class="row g-3 mb-4">
            <div class="col-md-6">
              <label class="form-label fw-semibold" style="font-size:12px;text-transform:uppercase;color:#5a6a7a;">Telefono</label>
              <input type="tel" name="telefono" class="form-control" value="${ciudadano.telefono}">
            </div>
            <div class="col-md-6">
              <label class="form-label fw-semibold" style="font-size:12px;text-transform:uppercase;color:#5a6a7a;">Correo Electronico</label>
              <input type="email" name="correo" class="form-control" value="${ciudadano.correo}">
            </div>
          </div>
          <%-- ── CAMPO MESA DE VOTACION ──────────────────────────────── --%>
          <div class="mb-4">
            <label class="form-label fw-semibold" style="font-size:12px;text-transform:uppercase;color:#5a6a7a;">
              <i class="fas fa-chair" style="color:#c8a84b;margin-right:4px;"></i> Mesa de Votacion
            </label>
            <select name="idMesasVotacion" class="form-control" style="height:42px;">
              <option value="">-- Sin mesa asignada --</option>
              <c:forEach var="mesa" items="${mesas}">
                <option value="${mesa.idMesasVotacion}"
                  ${ciudadano.idMesasVotacion == mesa.idMesasVotacion ? 'selected' : ''}>
                  Mesa ${mesa.numeroMesa} &mdash; ${mesa.nombreZona}
                  (${mesa.totalCiudadanos}/${mesa.capacidad} ciudadanos)
                </option>
              </c:forEach>
            </select>
            <small style="color:#8fa3b1;font-size:11px;">
              <i class="fas fa-circle-info" style="color:#c8a84b;"></i>
              Entre parentesis se muestra: ciudadanos actuales / capacidad total de la mesa.
            </small>
          </div>

          <div style="display:flex;gap:12px;padding-top:20px;border-top:1px solid #e2e8ee;">
            <button type="submit" class="btn" style="background:#1a2e4a;color:#fff;padding:10px 22px;">
              <i class="fas fa-save me-1"></i> ${accion == 'create' ? 'Guardar ciudadano' : 'Actualizar datos'}
            </button>
            <a href="${pageContext.request.contextPath}/ciudadanos" class="btn btn-secondary" style="padding:10px 22px;">
              <i class="fas fa-xmark me-1"></i> Cancelar
            </a>
          </div>
        </form>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

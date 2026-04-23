<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:set var="currentPage" value="zonas" scope="request"/>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${empty zona ? 'Nueva Zona' : 'Editar Zona'} - Registraduría de Nobsa</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
<style>
  body { font-family: 'Segoe UI', Arial, sans-serif; background: #f0f2f5; display: flex; min-height: 100vh; }

  /* SIDEBAR */
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
  .btn-admin-icon-active { color: #c8a84b !important; background: rgba(200,168,75,.15) !important; }
  .admin-icon-ring { width: 36px; height: 36px; border-radius: 50%; border: 2px solid #c8a84b44; background: rgba(200,168,75,.1); display: flex; align-items: center; justify-content: center; font-size: 16px; transition: all .2s; }
  .btn-admin-icon:hover .admin-icon-ring { border-color: #c8a84b; background: rgba(200,168,75,.2); }
  .admin-icon-label { font-size: 10px; font-weight: 600; letter-spacing: .04em; text-transform: uppercase; }

  /* MAIN */
  .main { margin-left: 240px; flex: 1; display: flex; flex-direction: column; min-height: 100vh; }
  .topbar { background: #fff; border-bottom: 1px solid #e2e8ee; padding: 16px 28px; display: flex; align-items: center; gap: 14px; }
  .topbar h1 { font-size: 18px; font-weight: 700; color: #1a2e4a; display: flex; align-items: center; gap: 10px; margin: 0; }
  .content { padding: 28px; flex: 1; }

  /* Form card */
  .form-card { background: #fff; border-radius: 8px; box-shadow: 0 1px 6px rgba(0,0,0,.08); padding: 30px 36px; max-width: 680px; }
  .form-label { font-size: 13px; font-weight: 600; color: #1a2e4a; margin-bottom: 5px; }
  .form-control, .form-select { border: 1.5px solid #d1dbe4; border-radius: 6px; font-size: 14px; padding: 9px 12px; transition: border-color .15s; }
  .form-control:focus, .form-select:focus { border-color: #1a2e4a; box-shadow: 0 0 0 3px rgba(26,46,74,.08); }
  .required-mark { color: #c0392b; }
  .section-divider { border-top: 1px solid #e2e8ee; margin: 24px 0; }
  .alert-custom { border-radius: 6px; padding: 12px 16px; font-size: 13px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; }
  .alert-error-custom { background: #fdf0f0; border: 1px solid #f5c6c6; color: #c0392b; }

  /* Buttons */
  .btn-gold { background: #c8a84b; color: #1a2e4a !important; border: none; padding: 10px 22px; border-radius: 6px; font-size: 14px; font-weight: 600; cursor: pointer; text-decoration: none; display: inline-flex; align-items: center; gap: 7px; transition: all .15s; }
  .btn-gold:hover { background: #b8943e; }
  .btn-cancel { background: #f0f2f5; color: #5a6a7a !important; border: 1.5px solid #d1dbe4; padding: 10px 22px; border-radius: 6px; font-size: 14px; text-decoration: none; display: inline-flex; align-items: center; gap: 7px; transition: all .15s; }
  .btn-cancel:hover { background: #e2e8ee; color: #1a2e4a !important; }
</style>
</head>
<body>

<%-- SIDEBAR --%>
<jsp:include page="/WEB-INF/vistas/sidebar.jsp"/>

<div class="main">
  <div class="topbar">
    <a href="${pageContext.request.contextPath}/zonas" style="color:#5a6a7a;font-size:20px;text-decoration:none;">
      <i class="fas fa-arrow-left"></i>
    </a>
    <h1>
      <i class="fas fa-map-marked-alt" style="color:#c8a84b;"></i>
      ${empty zona ? 'Nueva Zona de Votación' : 'Editar Zona: '.concat(zona.nombreZona)}
    </h1>
  </div>

  <div class="content">

    <c:if test="${not empty error}">
      <div class="alert-custom alert-error-custom" style="max-width:680px;">
        <i class="fas fa-exclamation-circle"></i> ${error}
      </div>
    </c:if>

    <div class="form-card">
      <form method="post" action="${pageContext.request.contextPath}/zonas">
        <input type="hidden" name="accion" value="${empty zona ? 'crear' : 'actualizar'}"/>
        <c:if test="${not empty zona}">
          <input type="hidden" name="idZonaVotacion" value="${zona.idZonaVotacion}"/>
        </c:if>

        <%-- Nombre de zona --%>
        <div class="mb-3">
          <label class="form-label">Nombre de Zona <span class="required-mark">*</span></label>
          <input type="text" name="nombreZona" class="form-control" required maxlength="120"
                 placeholder="Ej: Zona Norte, Zona Rural Centro…"
                 value="${not empty zona ? zona.nombreZona : ''}"/>
        </div>

        <%-- Puesto de votación --%>
        <div class="mb-3">
          <label class="form-label">Puesto de Votación <span class="required-mark">*</span></label>
          <input type="text" name="puestoVotacion" class="form-control" required maxlength="150"
                 placeholder="Ej: Institución Educativa Municipal…"
                 value="${not empty zona ? zona.puestoVotacion : ''}"/>
        </div>

        <%-- Dirección --%>
        <div class="mb-3">
          <label class="form-label">Dirección</label>
          <input type="text" name="direccion" class="form-control" maxlength="200"
                 placeholder="Ej: Calle 5 # 10-20, Nobsa"
                 value="${not empty zona ? zona.direccion : ''}"/>
        </div>

        <%-- Ciudad --%>
        <div class="mb-4">
          <label class="form-label">Ciudad</label>
          <select name="idCiudades" class="form-select">
            <option value="">— Sin ciudad asignada —</option>
            <c:forEach var="c" items="${ciudades}">
              <option value="${c[0]}"
                <c:if test="${not empty zona and zona.idCiudades == c[0]}">selected</c:if>>
                ${c[1]}
              </option>
            </c:forEach>
          </select>
        </div>

        <div class="section-divider"></div>

        <div class="d-flex gap-3">
          <button type="submit" class="btn-gold">
            <i class="fas ${empty zona ? 'fa-plus' : 'fa-save'}"></i>
            ${empty zona ? 'Crear Zona' : 'Guardar Cambios'}
          </button>
          <a href="${pageContext.request.contextPath}/zonas" class="btn-cancel">
            <i class="fas fa-times"></i> Cancelar
          </a>
        </div>

      </form>
    </div>

  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

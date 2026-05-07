<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="${not empty sessionScope.lang ? sessionScope.lang : 'es'}"/>
<fmt:setBundle basename="messages"/>
<fmt:message key="usuario.activo"    var="activeLabel"/>
<fmt:message key="usuario.inactivo"  var="inactiveLabel"/>
<fmt:message key="usuario.new"       var="createLabel"/>
<fmt:message key="btn.guardar"       var="saveLabel"/>
<fmt:message key="form.required.fields" var="msgRequired"/>
<fmt:message key="form.pass.required"   var="msgPassRequired"/>

<!DOCTYPE html>
<html lang="${not empty sessionScope.lang ? sessionScope.lang : 'es'}">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${empty usuarioEditar ? msg["usuario.new"] : msg["usuario.edit"]} — SaludBoyacá</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  <style>
    :root {
      --g:#4d7a68; --g-dark:#2d5a47; --g-pale:#e8f2ee; --g-bg:#f0f7f4;
      --text:#1a2e26; --text-mid:#4a6258; --text-lt:#7a9a8e;
      --border:#dce9e4; --white:#fff;
      --radius:14px; --shadow:0 2px 14px rgba(45,90,71,.09);
    }
    *, *::before, *::after { box-sizing: border-box; }
    body { font-family: 'Plus Jakarta Sans','Segoe UI',sans-serif; background: var(--g-bg); color: var(--text); }

    .form-wrap { max-width: 760px; margin: 0 auto; }

    .page-hdr {
      display: flex; align-items: center; justify-content: space-between;
      margin-bottom: 1.3rem; gap: 1rem; flex-wrap: wrap;
    }
    .page-hdr-left h5 { font-size: 1.05rem; font-weight: 800; margin: 0; }
    .page-hdr-left p  { font-size: .78rem; color: var(--text-lt); margin: .2rem 0 0; }
    .breadcrumb-bar { font-size: .73rem; color: var(--text-lt); margin-bottom: .3rem; }
    .breadcrumb-bar a { color: var(--g); text-decoration: none; font-weight: 600; }

    .form-card {
      background: var(--white); border-radius: var(--radius);
      border: 1px solid var(--border); box-shadow: var(--shadow); overflow: hidden;
      margin-bottom: 1.2rem;
    }
    .form-section-hdr {
      display: flex; align-items: center; gap: .6rem;
      padding: .9rem 1.4rem; border-bottom: 1px solid var(--border);
      background: #f8fcfb;
    }
    .form-section-hdr .sec-icon {
      width: 32px; height: 32px; border-radius: 9px;
      background: var(--g-pale); color: var(--g-dark);
      display: flex; align-items: center; justify-content: center; font-size: .82rem;
    }
    .form-section-hdr h6 { font-size: .88rem; font-weight: 800; margin: 0; color: var(--text); }
    .form-section-hdr p  { font-size: .72rem; color: var(--text-lt); margin: 0; }
    .form-body { padding: 1.4rem; }

    .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-bottom: 1rem; }
    @media (max-width:600px) { .form-row { grid-template-columns: 1fr; } }
    .form-row-1 { grid-template-columns: 1fr; }

    .fld label {
      display: block; font-size: .74rem; font-weight: 700;
      color: var(--text-mid); text-transform: uppercase; letter-spacing: .06em;
      margin-bottom: .38rem;
    }
    .fld label .req { color: #ef4444; margin-left: .15rem; }
    .fld input, .fld select, .fld textarea {
      width: 100%; padding: .55rem .9rem;
      border: 1.5px solid var(--border); border-radius: 9px;
      font-size: .85rem; font-family: inherit; color: var(--text);
      background: var(--white); outline: none;
      transition: border-color .18s, box-shadow .18s;
    }
    .fld input:focus, .fld select:focus {
      border-color: var(--g); box-shadow: 0 0 0 3px rgba(77,122,104,.12);
    }
    .fld .hint { font-size: .7rem; color: var(--text-lt); margin-top: .3rem; }

    /* Role selector */
    .role-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: .65rem; }
    @media (min-width: 500px) { .role-grid { grid-template-columns: repeat(4, 1fr); } }
    .role-opt { display: none; }
    .role-lbl {
      display: flex; flex-direction: column; align-items: center; justify-content: center;
      gap: .35rem; padding: .75rem .5rem; border: 2px solid var(--border);
      border-radius: 11px; cursor: pointer; font-size: .72rem; font-weight: 700;
      text-transform: uppercase; letter-spacing: .06em; color: var(--text-mid);
      text-align: center; transition: border-color .15s, background .15s;
    }
    .role-lbl i { font-size: 1.2rem; }
    .role-opt:checked + .role-lbl {
      border-color: var(--g-dark); background: var(--g-pale); color: var(--g-dark);
    }

    /* Password toggle */
    .pass-wrap { position: relative; }
    .pass-wrap input { padding-right: 2.5rem; }
    .pass-toggle {
      position: absolute; right: .75rem; top: 50%; transform: translateY(-50%);
      background: none; border: none; cursor: pointer; color: var(--text-lt); font-size: .85rem;
    }

    /* Switch activo */
    .switch-wrap { display: flex; align-items: center; gap: .75rem; }
    .switch { position: relative; width: 42px; height: 24px; }
    .switch input { opacity: 0; width: 0; height: 0; }
    .slider {
      position: absolute; inset: 0; background: #dce9e4; border-radius: 24px;
      cursor: pointer; transition: background .2s;
    }
    .slider:before {
      content: ''; position: absolute; width: 18px; height: 18px; border-radius: 50%;
      background: #fff; left: 3px; top: 3px; transition: transform .2s;
      box-shadow: 0 1px 4px rgba(0,0,0,.18);
    }
    .switch input:checked + .slider { background: #4d7a68; }
    .switch input:checked + .slider:before { transform: translateX(18px); }
    .switch-label { font-size: .83rem; font-weight: 600; color: var(--text-mid); }

    /* Action buttons */
    .form-actions {
      display: flex; align-items: center; justify-content: flex-end; gap: .75rem;
      padding: 1.1rem 1.4rem; border-top: 1px solid var(--border); background: #f8fcfb;
    }
    .btn-cancel {
      display: inline-flex; align-items: center; gap: .4rem;
      background: var(--white); color: var(--text-mid); border: 1.5px solid var(--border);
      font-size: .83rem; font-weight: 700; padding: .55rem 1.2rem;
      border-radius: 10px; text-decoration: none; transition: background .18s;
    }
    .btn-cancel:hover { background: var(--g-pale); color: var(--g-dark); }
    .btn-save {
      display: inline-flex; align-items: center; gap: .4rem;
      background: var(--g-dark); color: #fff; border: none;
      font-size: .83rem; font-weight: 700; padding: .55rem 1.4rem;
      border-radius: 10px; cursor: pointer; transition: background .18s;
    }
    .btn-save:hover { background: var(--g); }

    /* Error alert */
    .alert-err {
      background: #ffeef2; border: 1px solid #ffc4d3; border-radius: 10px;
      padding: .75rem 1.1rem; font-size: .83rem; color: #c4234f; margin-bottom: 1.2rem;
      display: flex; align-items: center; gap: .55rem;
    }
  </style>
</head>
<body>

<jsp:include page="/views/templates/header.jsp"/>
<jsp:include page="/views/templates/sidebar.jsp"/>

<div class="sb-main">
  <div class="form-wrap">

    <%-- Header --%>
    <div class="page-hdr">
      <div class="page-hdr-left">
        <div class="breadcrumb-bar">
          <a href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
          <span style="margin:0 .4rem;">›</span>
          <a href="${pageContext.request.contextPath}/usuarios"><fmt:message key="usuario.title"/></a>
          <span style="margin:0 .4rem;">›</span>
          <span>${empty usuarioEditar ? 'Nuevo' : 'Editar'}</span>
        </div>
        <h5>
          <i class="fas ${empty usuarioEditar ? 'fa-user-plus' : 'fa-user-edit'}" style="color:var(--g);margin-right:.5rem;"></i>
          ${empty usuarioEditar ? 'Crear nuevo usuario' : 'Editar usuario'}
        </h5>
        <p>${empty usuarioEditar ? 'Completa los datos para registrar un nuevo usuario' : 'Modifica los datos del usuario'}</p>
      </div>
    </div>

    <%-- Error --%>
    <c:if test="${not empty error}">
      <div class="alert-err"><i class="fas fa-exclamation-circle"></i> ${error}</div>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/usuarios" id="userForm" novalidate>
      <input type="hidden" name="accion" value="${empty usuarioEditar ? 'crear' : 'actualizar'}">
      <c:if test="${not empty usuarioEditar}">
        <input type="hidden" name="idUsuario" value="${usuarioEditar.idUsuario}">
      </c:if>

      <%-- Sección: Datos personales --%>
      <div class="form-card">
        <div class="form-section-hdr">
          <div class="sec-icon"><i class="fas fa-id-card"></i></div>
          <div>
            <h6><fmt:message key="usuario.personal.data"/></h6>
            <p><fmt:message key="usuario.id.info"/></p>
          </div>
        </div>
        <div class="form-body">
          <div class="form-row">
            <div class="fld">
              <label><fmt:message key="usuario.nombres.label"/> <span class="req">*</span></label>
              <input type="text" name="nombres" required placeholder="Ej: Juan"
                     value="${not empty usuarioEditar ? usuarioEditar.nombres : ''}">
            </div>
            <div class="fld">
              <label><fmt:message key="usuario.apellidos.label"/> <span class="req">*</span></label>
              <input type="text" name="apellidos" required placeholder="${msg['paciente.placeholder.apellidos']}"
                     value="${not empty usuarioEditar ? usuarioEditar.apellidos : ''}">
            </div>
          </div>
          <div class="form-row">
            <div class="fld">
              <label><fmt:message key="usuario.documento"/> <span class="req">*</span></label>
              <input type="text" name="documento" required placeholder="<fmt:message key="usuario.doc.placeholder"/>"
                     value="${not empty usuarioEditar ? usuarioEditar.documento : ''}">
            </div>
            <div class="fld">
              <label><fmt:message key="usuario.email.label"/> <span class="req">*</span></label>
              <input type="email" name="email" required placeholder="correo@ejemplo.com"
                     value="${not empty usuarioEditar ? usuarioEditar.email : ''}">
            </div>
          </div>
        </div>
      </div>

      <%-- Sección: Acceso al sistema --%>
      <div class="form-card">
        <div class="form-section-hdr">
          <div class="sec-icon"><i class="fas fa-key"></i></div>
          <div>
            <h6><fmt:message key="usuario.access.section"/></h6>
            <p><fmt:message key="usuario.credentials.desc"/></p>
          </div>
        </div>
        <div class="form-body">
          <div class="form-row">
            <div class="fld">
              <label><fmt:message key="usuario.username.label"/> <span class="req">*</span></label>
              <input type="text" name="userName" required placeholder="Ej: jgomez"
                     value="${not empty usuarioEditar ? usuarioEditar.userName : ''}">
            </div>
            <div class="fld">
              <label>
                <fmt:message key="usuario.password"/>
                <c:if test="${empty usuarioEditar}"><span class="req">*</span></c:if>
              </label>
              <div class="pass-wrap">
                <input type="password" name="password" id="passField"
                       placeholder="<fmt:message key="${empty usuarioEditar ? 'usuario.pass.placeholder.new' : 'usuario.pass.placeholder.edit'}"/>">
                <button type="button" class="pass-toggle" onclick="togglePass()">
                  <i class="fas fa-eye" id="eyeIcon"></i>
                </button>
              </div>
              <c:if test="${not empty usuarioEditar}">
                <div class="hint"><i class="fas fa-info-circle"></i> <fmt:message key="usuario.pass.hint"/></div>
              </c:if>
            </div>
          </div>
          <div class="form-row">
            <div class="fld">
              <label><fmt:message key="usuario.lang.label"/></label>
              <select name="langPreferido">
                <option value="es" ${(empty usuarioEditar || usuarioEditar.langPreferido == 'es') ? 'selected' : ''}>🇨🇴 Español</option>
                <option value="en" ${not empty usuarioEditar && usuarioEditar.langPreferido == 'en' ? 'selected' : ''}>🇺🇸 English</option>
                <option value="it" ${not empty usuarioEditar && usuarioEditar.langPreferido == 'it' ? 'selected' : ''}>🇮🇹 Italiano</option>
              </select>
            </div>
            <div class="fld">
              <label><fmt:message key="usuario.status.label"/></label>
              <div class="switch-wrap" style="margin-top:.6rem;">
                <label class="switch">
                  <input type="checkbox" name="activo" value="1" id="activoSwitch"
                         ${(empty usuarioEditar || usuarioEditar.activo == 1) ? 'checked' : ''}>
                  <span class="slider"></span>
                </label>
                <span class="switch-label" id="activoLabel">
                  ${(empty usuarioEditar || usuarioEditar.activo == 1) ? activeLabel : inactiveLabel}
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <%-- Sección: Rol --%>
      <div class="form-card">
        <div class="form-section-hdr">
          <div class="sec-icon"><i class="fas fa-user-tag"></i></div>
          <div>
            <h6><fmt:message key="usuario.role.section"/></h6>
            <p><fmt:message key="usuario.role.desc"/></p>
          </div>
        </div>
        <div class="form-body">
          <div class="role-grid">
            <c:forEach var="rolOpt" items="${['MEDICO','RECEPCIONISTA','ENFERMERO','ADMINISTRADOR']}">
              <c:set var="isChecked" value="${not empty usuarioEditar && usuarioEditar.rol == rolOpt}"/>
              <input type="radio" name="rol" id="rol_${rolOpt}" value="${rolOpt}" class="role-opt"
                     ${isChecked ? 'checked' : (empty usuarioEditar && rolOpt == 'MEDICO' ? 'checked' : '')}
                     onchange="onRolChange(this.value)">
              <label for="rol_${rolOpt}" class="role-lbl">
                <c:choose>
                  <c:when test="${rolOpt == 'MEDICO'}"><i class="fas fa-stethoscope" style="color:#4d7a68;"></i></c:when>
                  <c:when test="${rolOpt == 'RECEPCIONISTA'}"><i class="fas fa-concierge-bell" style="color:#f59e0b;"></i></c:when>
                  <c:when test="${rolOpt == 'ENFERMERO'}"><i class="fas fa-user-nurse" style="color:#3b82f6;"></i></c:when>
                  <c:when test="${rolOpt == 'ADMINISTRADOR'}"><i class="fas fa-shield-alt" style="color:#8b5cf6;"></i></c:when>
                </c:choose>
                ${rolOpt}
              </label>
            </c:forEach>
          </div>

          <%-- Especialidad (solo para MÉDICO) --%>
          <div id="espSection" style="margin-top:1rem;display:none;">
            <div class="fld">
              <label><fmt:message key="usuario.specialty.label"/></label>
              <select name="idEspecialidad" id="idEspecialidad">
                <option value="0"><fmt:message key="usuario.specialty.select"/></option>
                <c:forEach var="esp" items="${especialidades}">
                  <option value="${esp.idEspecialidad}"
                    ${not empty usuarioEditar && usuarioEditar.idEspecialidad == esp.idEspecialidad ? 'selected' : ''}>
                    ${esp.nombre}
                  </option>
                </c:forEach>
              </select>
              <div class="hint"><fmt:message key="usuario.specialty.hint"/></div>
            </div>
          </div>

          <%-- Info administrador --%>
          <div id="adminInfo" style="margin-top:1rem;display:none;">
            <div style="background:#f3ecff;border:1px solid #d8caff;border-radius:10px;padding:.75rem 1rem;font-size:.8rem;color:#6e23c4;">
              <i class="fas fa-info-circle me-1"></i>
              <fmt:message key="usuario.admin.info"/>
            </div>
          </div>
        </div>
      </div>

      <div class="form-actions">
        <a href="${pageContext.request.contextPath}/usuarios" class="btn-cancel">
          <i class="fas fa-times"></i> <fmt:message key="btn.cancelar"/>
        </a>
        <button type="submit" class="btn-save">
          <i class="fas ${empty usuarioEditar ? 'fa-user-plus' : 'fa-save'}"></i>
          ${empty usuarioEditar ? createLabel : saveLabel}
        </button>
      </div>
    </form>

  </div>
</div><%-- /sb-main --%>
</div><%-- /sb-layout --%>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
function onRolChange(rol) {
  const espSec   = document.getElementById('espSection');
  const adminInf = document.getElementById('adminInfo');
  espSec.style.display   = (rol === 'MEDICO')         ? 'block' : 'none';
  adminInf.style.display = (rol === 'ADMINISTRADOR')  ? 'block' : 'none';
}

// Init
const checkedRol = document.querySelector('input[name="rol"]:checked');
if (checkedRol) onRolChange(checkedRol.value);

// Toggle password
function togglePass() {
  const inp = document.getElementById('passField');
  const ico = document.getElementById('eyeIcon');
  if (inp.type === 'password') { inp.type = 'text'; ico.className = 'fas fa-eye-slash'; }
  else { inp.type = 'password'; ico.className = 'fas fa-eye'; }
}

// Toggle label activo
document.getElementById('activoSwitch').addEventListener('change', function() {
  document.getElementById('activoLabel').textContent = this.checked ? '${activeLabel}' : '${inactiveLabel}';
});

// Form validation
document.getElementById('userForm').addEventListener('submit', function(e) {
  const nombres  = document.querySelector('[name=nombres]').value.trim();
  const apellidos= document.querySelector('[name=apellidos]').value.trim();
  const doc      = document.querySelector('[name=documento]').value.trim();
  const email    = document.querySelector('[name=email]').value.trim();
  const uname    = document.querySelector('[name=userName]').value.trim();
  const isNew    = '${empty usuarioEditar}' === 'true';
  const pass     = document.getElementById('passField').value;

  if (!nombres || !apellidos || !doc || !email || !uname) {
    e.preventDefault(); alert(msgRequired); return;
  }
  if (isNew && !pass) {
    e.preventDefault(); alert(msgPassRequired); return;
  }
});
</script>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core"      prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Solicitudes Ciudadanas — Registraduría de Nobsa</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
<style>
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
:root{
  --azul:#0b2346;--azul-med:#163a6b;--azul-suave:#1e4d8c;
  --oro:#c8a84b;--oro-claro:#e6c96a;
  --fondo:#f3f5f9;--blanco:#ffffff;--texto:#1a2535;
  --gris:#6b7c93;--borde:#dce3ef;
  --exito:#0f7a3d;--error:#b91c1c;--warning:#b45309;
}
body{font-family:'DM Sans',sans-serif;background:var(--fondo);min-height:100vh;display:flex;flex-direction:column;color:var(--texto);}
.banda-gov{height:6px;background:linear-gradient(90deg,#ffd900 33.33%,#003087 33.33% 66.66%,#ce1126 66.66%);}
.top-bar{background:var(--azul);padding:10px 40px;display:flex;align-items:center;justify-content:space-between;gap:16px;}
.top-bar-brand{display:flex;align-items:center;gap:12px;}
.escudo{width:36px;height:36px;background:var(--oro);border-radius:50%;display:flex;align-items:center;justify-content:center;flex-shrink:0;}
.escudo i{color:var(--azul);font-size:16px;}
.top-bar-brand span{color:#fff;font-size:13px;font-weight:500;}
.btn-volver-inicio{color:var(--oro);text-decoration:none;font-size:12px;font-weight:600;padding:7px 16px;border:1.5px solid rgba(200,168,75,.5);border-radius:20px;display:inline-flex;align-items:center;gap:6px;transition:all .2s;}
.btn-volver-inicio:hover{background:rgba(200,168,75,.15);border-color:var(--oro);}
.hero{background:linear-gradient(135deg,var(--azul) 0%,var(--azul-med) 60%,var(--azul-suave) 100%);padding:52px 40px 80px;text-align:center;position:relative;overflow:hidden;}
.hero::before{content:'';position:absolute;inset:0;background:radial-gradient(ellipse 60% 50% at 80% 120%,rgba(200,168,75,.18) 0%,transparent 70%),radial-gradient(ellipse 40% 60% at -10% 30%,rgba(200,168,75,.10) 0%,transparent 60%);}
.hero::after{content:'';position:absolute;bottom:-2px;left:0;right:0;height:52px;background:var(--fondo);clip-path:ellipse(58% 100% at 50% 100%);}
.hero-tag{display:inline-flex;align-items:center;gap:7px;background:rgba(200,168,75,.18);border:1px solid rgba(200,168,75,.4);color:var(--oro-claro);font-size:11px;font-weight:600;letter-spacing:.1em;text-transform:uppercase;padding:5px 14px;border-radius:20px;margin-bottom:18px;position:relative;}
.hero h1{font-family:'Playfair Display',Georgia,serif;font-size:clamp(24px,4vw,38px);font-weight:900;color:#fff;line-height:1.15;position:relative;margin-bottom:10px;}
.hero h1 span{color:var(--oro);}
.hero p{color:rgba(255,255,255,.72);font-size:15px;position:relative;max-width:440px;margin:0 auto;}
.main{flex:1;max-width:720px;width:100%;margin:-30px auto 48px;padding:0 20px;position:relative;z-index:2;}
.card{background:var(--blanco);border-radius:16px;box-shadow:0 4px 24px rgba(11,35,70,.10),0 1px 4px rgba(11,35,70,.06);overflow:hidden;margin-bottom:16px;animation:fadeUp .4s ease both;}
@keyframes fadeUp{from{opacity:0;transform:translateY(18px)}to{opacity:1;transform:translateY(0)}}
.card-pad{padding:32px;}
.buscar-label{display:block;font-size:12px;font-weight:700;letter-spacing:.07em;text-transform:uppercase;color:var(--gris);margin-bottom:8px;}
.buscar-row{display:flex;gap:10px;}
.input-wrap{position:relative;flex:1;}
.input-wrap i{position:absolute;left:15px;top:50%;transform:translateY(-50%);color:var(--gris);font-size:15px;pointer-events:none;}
.input-doc{width:100%;padding:13px 14px 13px 42px;border:2px solid var(--borde);border-radius:10px;font-family:'DM Sans',sans-serif;font-size:15px;font-weight:500;color:var(--texto);outline:none;transition:border-color .2s,box-shadow .2s;background:#fafbfd;}
.input-doc:focus{border-color:var(--azul-suave);box-shadow:0 0 0 4px rgba(30,77,140,.10);background:#fff;}
.input-doc::placeholder{color:#b0bbc9;font-weight:400;}
.btn-buscar{background:var(--azul);color:#fff;border:none;padding:13px 22px;border-radius:10px;font-family:'DM Sans',sans-serif;font-size:14px;font-weight:600;cursor:pointer;display:inline-flex;align-items:center;gap:8px;transition:all .2s;box-shadow:0 4px 14px rgba(11,35,70,.22);white-space:nowrap;}
.btn-buscar:hover{background:var(--azul-suave);transform:translateY(-1px);}
.ciudadano-card{background:linear-gradient(135deg,#f0f4ff 0%,#e8f0fe 100%);border:1.5px solid #c5d5f5;border-radius:12px;padding:20px 24px;margin-bottom:22px;display:flex;align-items:center;gap:16px;}
.ciudadano-avatar{width:52px;height:52px;border-radius:50%;background:linear-gradient(135deg,var(--azul),var(--azul-suave));color:#fff;font-weight:800;font-size:18px;display:flex;align-items:center;justify-content:center;flex-shrink:0;text-transform:uppercase;}
.ciudadano-info-nombre{font-size:16px;font-weight:700;color:var(--azul);}
.ciudadano-info-doc{font-size:13px;color:var(--gris);margin-top:2px;}
.ciudadano-badge{font-size:11px;font-weight:700;background:rgba(11,35,70,.1);color:var(--azul);padding:3px 10px;border-radius:20px;margin-top:4px;display:inline-block;}
.form-group{margin-bottom:20px;}
.form-label{display:block;font-size:12px;font-weight:700;letter-spacing:.07em;text-transform:uppercase;color:var(--gris);margin-bottom:8px;}
.form-label .req{color:var(--error);}
.form-input,.form-select,.form-textarea{width:100%;padding:12px 16px;border:2px solid var(--borde);border-radius:10px;font-family:'DM Sans',sans-serif;font-size:14px;color:var(--texto);outline:none;transition:border-color .2s,box-shadow .2s;background:#fafbfd;}
.form-input:focus,.form-select:focus,.form-textarea:focus{border-color:var(--azul-suave);box-shadow:0 0 0 4px rgba(30,77,140,.10);background:#fff;}
.form-textarea{resize:vertical;min-height:110px;}
.form-row{display:grid;grid-template-columns:1fr 1fr;gap:16px;}
@media(max-width:540px){.form-row{grid-template-columns:1fr;}.buscar-row{flex-direction:column;}}
.btn-enviar{width:100%;background:linear-gradient(135deg,var(--azul) 0%,var(--azul-suave) 100%);color:#fff;border:none;padding:16px 28px;border-radius:12px;font-family:'DM Sans',sans-serif;font-size:16px;font-weight:700;cursor:pointer;display:flex;align-items:center;justify-content:center;gap:10px;transition:all .2s;box-shadow:0 6px 20px rgba(11,35,70,.28);margin-top:8px;}
.btn-enviar:hover{transform:translateY(-2px);box-shadow:0 8px 28px rgba(11,35,70,.38);}
.tipos-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(200px,1fr));gap:10px;margin-top:6px;}
.tipo-item{border:2px solid var(--borde);border-radius:10px;padding:12px 14px;cursor:pointer;transition:all .2s;display:flex;align-items:center;gap:10px;background:#fafbfd;}
.tipo-item:hover{border-color:var(--azul-suave);background:#f0f4ff;}
.tipo-item.selected{border-color:var(--azul);background:#eef2fb;}
.tipo-item input[type=radio]{display:none;}
.tipo-item i{font-size:18px;color:var(--azul);width:22px;text-align:center;flex-shrink:0;}
.tipo-item span{font-size:13px;font-weight:500;color:var(--texto);}
.alert{display:flex;align-items:flex-start;gap:12px;padding:14px 18px;border-radius:10px;font-size:14px;margin-bottom:16px;animation:fadeUp .3s ease both;}
.alert-error{background:#fef2f2;border:1px solid #fecaca;color:var(--error);}
.alert-success{background:#f0fdf4;border:1px solid #bbf7d0;color:var(--exito);}
.alert-info{background:#eff6ff;border:1px solid #bfdbfe;color:#1e40af;}
.alert i{margin-top:1px;flex-shrink:0;}
.success-wrap{text-align:center;padding:40px 20px;}
.success-icon-big{width:72px;height:72px;background:linear-gradient(135deg,#0f7a3d,#16a34a);border-radius:50%;display:flex;align-items:center;justify-content:center;margin:0 auto 20px;box-shadow:0 8px 24px rgba(15,122,61,.3);}
.success-icon-big i{color:#fff;font-size:32px;}
.success-title{font-family:'Playfair Display',serif;font-size:26px;font-weight:700;color:var(--azul);margin-bottom:10px;}
.success-sub{color:var(--gris);font-size:15px;max-width:380px;margin:0 auto 24px;}
.success-id{display:inline-block;background:#f0f4ff;border:1.5px solid #c5d5f5;border-radius:10px;padding:8px 20px;font-size:14px;color:var(--azul);font-weight:600;margin-bottom:24px;}
.btn-nueva{display:inline-flex;align-items:center;gap:8px;background:var(--azul);color:#fff;text-decoration:none;padding:12px 24px;border-radius:10px;font-weight:600;font-size:14px;transition:all .2s;}
.btn-nueva:hover{background:var(--azul-suave);}
.info-section{background:linear-gradient(135deg,#f8fafc,#f0f4ff);border:1px solid #dce8f8;border-radius:12px;padding:20px 24px;margin-bottom:16px;}
.info-title{font-size:13px;font-weight:700;color:var(--azul);margin-bottom:12px;display:flex;align-items:center;gap:8px;}
.info-list{list-style:none;display:grid;grid-template-columns:1fr 1fr;gap:6px;}
.info-list li{font-size:12px;color:var(--gris);display:flex;align-items:center;gap:6px;}
.info-list li i{color:var(--oro);font-size:11px;}
@media(max-width:480px){.info-list{grid-template-columns:1fr;}}
</style>
</head>
<body>
<div class="banda-gov"></div>

<div class="top-bar">
  <div class="top-bar-brand">
    <div class="escudo"><i class="fas fa-landmark"></i></div>
    <span>Registraduría Municipal de Nobsa</span>
  </div>
  <a href="${pageContext.request.contextPath}/consultaMesa" class="btn-volver-inicio">
    <i class="fas fa-arrow-left"></i> Consultar Mesa
  </a>
</div>

<div class="hero">
  <div class="hero-tag"><i class="fas fa-paper-plane"></i> Portal Ciudadano</div>
  <h1>Solicitudes<br><span>Ciudadanas</span></h1>
  <p>Envía tu solicitud ingresando tu número de documento. Te notificaremos por correo electrónico.</p>
</div>

<div class="main">

  <!-- ── ÉXITO ── -->
  <c:if test="${solicitudEnviada}">
    <div class="card">
      <div class="success-wrap">
        <div class="success-icon-big"><i class="fas fa-check"></i></div>
        <div class="success-title">¡Solicitud enviada!</div>
        <p class="success-sub">Tu solicitud ha sido registrada exitosamente. Recibirás un correo en <strong>${correoConfirmacion}</strong> con la confirmación.</p>
        <div class="success-id"><i class="fas fa-hashtag"></i> Número de solicitud: #${solicitudId}</div>
        <br>
        <a href="${pageContext.request.contextPath}/solicitud" class="btn-nueva">
          <i class="fas fa-plus"></i> Nueva solicitud
        </a>
      </div>
    </div>
  </c:if>

  <!-- ── FORMULARIO ── -->
  <c:if test="${!solicitudEnviada}">

    <!-- Paso 1: Buscar ciudadano -->
    <div class="card">
      <div class="card-pad">
        <label class="buscar-label"><i class="fas fa-search" style="margin-right:6px;"></i> Paso 1 — Busca tu información</label>
        <p style="font-size:13px;color:var(--gris);margin-bottom:14px;">Ingresa tu número de documento para cargar tus datos automáticamente.</p>

        <form method="get" action="${pageContext.request.contextPath}/solicitud">
          <div class="buscar-row">
            <div class="input-wrap">
              <i class="fas fa-id-card"></i>
              <input type="text" name="doc" class="input-doc"
                     placeholder="Número de cédula o documento"
                     value="${not empty docBuscado ? docBuscado : ''}"
                     pattern="[0-9]{4,12}" title="Solo números, entre 4 y 12 dígitos"
                     maxlength="12" required>
            </div>
            <button type="submit" class="btn-buscar">
              <i class="fas fa-search"></i> Buscar
            </button>
          </div>
        </form>

        <c:if test="${not empty errorBusqueda}">
          <div class="alert alert-error" style="margin-top:14px;">
            <i class="fas fa-exclamation-circle"></i>
            <span>${errorBusqueda}</span>
          </div>
        </c:if>
      </div>
    </div>

    <!-- Paso 2: Solicitud (solo si ciudadano encontrado) -->
    <c:if test="${not empty ciudadano}">

      <div class="card" style="animation-delay:.05s">
        <div class="card-pad">
          <div class="ciudadano-card">
            <div class="ciudadano-avatar">${ciudadano.iniciales}</div>
            <div>
              <div class="ciudadano-info-nombre">${ciudadano.nombres} ${ciudadano.apellidos}</div>
              <div class="ciudadano-info-doc"><i class="fas fa-id-card" style="margin-right:5px;"></i>${ciudadano.numeroDocumento}</div>
              <span class="ciudadano-badge"><i class="fas fa-check-circle" style="margin-right:4px;"></i>Ciudadano verificado</span>
            </div>
          </div>

          <c:if test="${not empty errorEnvio}">
            <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i><span>${errorEnvio}</span></div>
          </c:if>

          <label class="buscar-label" style="margin-bottom:16px;"><i class="fas fa-file-alt" style="margin-right:6px;"></i> Paso 2 — Completa tu solicitud</label>

          <%-- ✅ El form solo tiene campos con nombres únicos.
               Los radios tienen name="tipoRadio" (solo para la UI).
               El hidden con name="tipoSolicitud" es el que realmente se envía al servlet. --%>
          <form id="formSolicitud" method="post" action="${pageContext.request.contextPath}/solicitud">
            <input type="hidden" name="numeroDocumento" value="${ciudadano.numeroDocumento}">
            <input type="hidden" name="nombres"         value="${ciudadano.nombres}">
            <input type="hidden" name="apellidos"       value="${ciudadano.apellidos}">
            <%-- ✅ CLAVE: este hidden es el ÚNICO campo llamado "tipoSolicitud" que llega al servlet --%>
            <input type="hidden" id="tipoSolicitudHidden" name="tipoSolicitud" value="">

            <!-- Correo y teléfono -->
            <div class="form-row">
              <div class="form-group">
                <label class="form-label">Correo electrónico <span class="req">*</span></label>
                <input type="email" name="correo" class="form-input"
                       value="${not empty ciudadano.correo ? ciudadano.correo : ''}"
                       placeholder="tucorreo@ejemplo.com" required>
              </div>
              <div class="form-group">
                <label class="form-label">Teléfono de contacto</label>
                <input type="tel" name="telefono" class="form-input"
                       value="${not empty ciudadano.telefono ? ciudadano.telefono : ''}"
                       placeholder="3XX XXX XXXX">
              </div>
            </div>

            <!-- Tipo de solicitud -->
            <div class="form-group">
              <label class="form-label">Tipo de solicitud <span class="req">*</span></label>
              <%-- ✅ Los radios usan name="tipoRadio" — no compiten con el hidden --%>
              <div class="tipos-grid" id="tipos-grid">
                <label class="tipo-item" onclick="selectTipo(this,'Cambio de documento')">
                  <input type="radio" name="tipoRadio" value="Cambio de documento">
                  <i class="fas fa-id-card"></i><span>Cambio de documento</span>
                </label>
                <label class="tipo-item" onclick="selectTipo(this,'Actualización de datos')">
                  <input type="radio" name="tipoRadio" value="Actualización de datos">
                  <i class="fas fa-user-edit"></i><span>Actualización de datos</span>
                </label>
                <label class="tipo-item" onclick="selectTipo(this,'Corrección de nombre')">
                  <input type="radio" name="tipoRadio" value="Corrección de nombre">
                  <i class="fas fa-spell-check"></i><span>Corrección de nombre</span>
                </label>
                <label class="tipo-item" onclick="selectTipo(this,'Cambio de mesa de votación')">
                  <input type="radio" name="tipoRadio" value="Cambio de mesa de votación">
                  <i class="fas fa-vote-yea"></i><span>Cambio de mesa</span>
                </label>
                <label class="tipo-item" onclick="selectTipo(this,'Corrección de correo electrónico')">
                  <input type="radio" name="tipoRadio" value="Corrección de correo electrónico">
                  <i class="fas fa-envelope"></i><span>Corrección de correo</span>
                </label>
                <label class="tipo-item" onclick="selectTipo(this,'Corrección de teléfono')">
                  <input type="radio" name="tipoRadio" value="Corrección de teléfono">
                  <i class="fas fa-phone"></i><span>Corrección de teléfono</span>
                </label>
                <label class="tipo-item" onclick="selectTipo(this,'Inscripción de cédula')">
                  <input type="radio" name="tipoRadio" value="Inscripción de cédula">
                  <i class="fas fa-user-plus"></i><span>Inscripción de cédula</span>
                </label>
                <label class="tipo-item" onclick="selectTipo(this,'Otra solicitud')">
                  <input type="radio" name="tipoRadio" value="Otra solicitud">
                  <i class="fas fa-ellipsis-h"></i><span>Otra solicitud</span>
                </label>
              </div>
            </div>

            <!-- Descripción -->
            <div class="form-group">
              <label class="form-label">Descripción de la solicitud <span class="req">*</span></label>
              <textarea name="descripcion" class="form-textarea" required
                        placeholder="Describe con detalle lo que necesitas. Ejemplo: necesito actualizar mi número de teléfono de 3001234567 a 3009876543..."
                        maxlength="1000">${not empty param.descripcion ? param.descripcion : ''}</textarea>
              <div style="font-size:11px;color:var(--gris);margin-top:4px;">Máximo 1000 caracteres</div>
            </div>

            <button type="submit" class="btn-enviar" id="btn-enviar">
              <i class="fas fa-paper-plane"></i> Enviar solicitud
            </button>
          </form>
        </div>
      </div>

    </c:if>

    <!-- Info general si no hay búsqueda aún -->
    <c:if test="${empty ciudadano && empty docBuscado}">
      <div class="info-section">
        <div class="info-title"><i class="fas fa-info-circle" style="color:var(--azul);"></i> Tipos de solicitudes disponibles</div>
        <ul class="info-list">
          <li><i class="fas fa-dot-circle"></i> Cambio de documento</li>
          <li><i class="fas fa-dot-circle"></i> Actualización de datos</li>
          <li><i class="fas fa-dot-circle"></i> Corrección de nombre</li>
          <li><i class="fas fa-dot-circle"></i> Cambio de mesa de votación</li>
          <li><i class="fas fa-dot-circle"></i> Corrección de correo</li>
          <li><i class="fas fa-dot-circle"></i> Inscripción de cédula</li>
          <li><i class="fas fa-dot-circle"></i> Corrección de teléfono</li>
          <li><i class="fas fa-dot-circle"></i> Otra solicitud</li>
        </ul>
      </div>
      <div class="alert alert-info">
        <i class="fas fa-envelope"></i>
        <span>Recibirás un <strong>correo de confirmación</strong> al enviar tu solicitud y otro cuando sea revisada por el administrador.</span>
      </div>
    </c:if>

  </c:if>

</div>

<!-- ── Footer ── -->
<footer style="background:var(--azul);padding:24px 40px;text-align:center;">
  <p style="color:rgba(255,255,255,.5);font-size:12px;">
    Registraduría Municipal de Nobsa · Boyacá, Colombia · (608) 770 0000
    <br>registraduria@nobsa-boyaca.gov.co
  </p>
</footer>

<script>
// ✅ Marca visualmente el tipo seleccionado y actualiza el hidden
function selectTipo(label, valor) {
  document.querySelectorAll('.tipo-item').forEach(el => el.classList.remove('selected'));
  label.classList.add('selected');
  label.querySelector('input[type=radio]').checked = true;
  document.getElementById('tipoSolicitudHidden').value = valor;
}

// ✅ UN solo listener, dentro de DOMContentLoaded, sin duplicados
document.addEventListener('DOMContentLoaded', function() {
  const form = document.getElementById('formSolicitud');
  if (!form) return;

  form.addEventListener('submit', function(e) {
    const tipoHidden = document.getElementById('tipoSolicitudHidden');

    // Verificar que se haya seleccionado un tipo
    if (!tipoHidden || tipoHidden.value.trim() === '') {
      e.preventDefault();
      alert('Por favor selecciona un tipo de solicitud.');
      return;
    }
  });
});
</script>
</body>
</html>

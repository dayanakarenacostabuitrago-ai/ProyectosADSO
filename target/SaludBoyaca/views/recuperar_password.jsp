<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="${not empty sessionScope.lang ? sessionScope.lang : 'es'}"/>
<fmt:setBundle basename="messages"/>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Recuperar contraseña — SaludBoyacá</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">

  <style>
    :root {
      --green:       #6a9e8a;
      --green-dark:  #2d5a47;
      --green-mid:   #4d7a68;
      --green-pale:  #e8f2ee;
      --text-dark:   #1a2e26;
      --text-mid:    #4a6258;
      --text-lt:     #7a9a8e;
      --border:      #dce9e4;
      --white:       #ffffff;
      --gray-bg:     #f7f9f8;
      --radius:      24px;
      --radius-sm:   12px;
      --shadow-lg:   0 32px 80px rgba(26,46,38,.18);
      --shadow-card: 0 8px 28px rgba(45,90,71,.12);
    }

    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    body {
      font-family: 'Inter', sans-serif;
      min-height: 100vh;
      background: #b8cfc7;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 1.5rem;
    }

    /* ── Card ── */
    .rec-wrap   { width: 100%; max-width: 420px; }
    .auth-card  {
      background: var(--white);
      border-radius: var(--radius);
      box-shadow: var(--shadow-lg);
      padding: 2rem 2rem 1.75rem;
      animation: fadeUp .4s ease both;
    }
    @keyframes fadeUp { from{opacity:0;transform:translateY(16px)} to{opacity:1;transform:translateY(0)} }

    /* ── Progress steps ── */
    .steps-bar {
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 0;
      margin-bottom: 1.75rem;
    }
    .step {
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: .28rem;
      position: relative;
      z-index: 1;
    }
    .step-circle {
      width: 34px; height: 34px;
      border-radius: 50%;
      display: flex; align-items: center; justify-content: center;
      font-size: .78rem; font-weight: 800;
      border: 2px solid var(--border);
      background: var(--white);
      color: var(--text-lt);
      transition: all .3s;
    }
    .step.done .step-circle  { background: var(--green-mid); border-color: var(--green-mid); color: #fff; }
    .step.active .step-circle{ background: var(--green-dark); border-color: var(--green-dark); color: #fff; box-shadow: 0 0 0 4px rgba(45,90,71,.15); }
    .step-label {
      font-size: .6rem; font-weight: 700; text-transform: uppercase;
      letter-spacing: .06em; color: var(--text-lt); white-space: nowrap;
    }
    .step.active .step-label { color: var(--green-dark); }
    .step.done  .step-label  { color: var(--green-mid); }
    .step-line {
      flex: 1; height: 2px;
      background: var(--border);
      margin: 0 .4rem;
      margin-bottom: 1.35rem; /* align with circles */
      transition: background .3s;
      min-width: 36px;
    }
    .step-line.done { background: var(--green-mid); }

    /* ── Header area ── */
    .rec-icon {
      width: 60px; height: 60px;
      border-radius: 50%;
      background: var(--green-pale);
      display: flex; align-items: center; justify-content: center;
      margin: 0 auto .9rem;
      font-size: 1.5rem;
      color: var(--green-dark);
    }
    .rec-title { font-size: 1.15rem; font-weight: 800; color: var(--text-dark); text-align: center; margin-bottom: .25rem; }
    .rec-sub   { font-size: .8rem; color: var(--text-lt); text-align: center; margin-bottom: 1.4rem; line-height: 1.5; }
    .rec-sub strong { color: var(--green-dark); }

    /* ── Alerts ── */
    .alert-err {
      display: flex; align-items: flex-start; gap: .55rem;
      background: #fff0f0; border: 1px solid #ffc4c4;
      border-radius: 10px; padding: .75rem 1rem;
      font-size: .82rem; color: #c0392b;
      margin-bottom: 1.1rem;
    }
    .alert-info {
      display: flex; align-items: flex-start; gap: .55rem;
      background: var(--green-pale); border: 1px solid #c2ddd4;
      border-radius: 10px; padding: .75rem 1rem;
      font-size: .82rem; color: var(--green-dark);
      margin-bottom: 1.1rem;
    }
    .alert-err i, .alert-info i { margin-top: .05rem; flex-shrink: 0; font-size: .88rem; }

    /* ── Field ── */
    .field-group { margin-bottom: 1rem; }
    .field-group label {
      display: block; font-size: .78rem; font-weight: 600;
      color: var(--text-dark); margin-bottom: .4rem;
    }
    .field-wrap  { position: relative; }
    .field-icon  {
      position: absolute; left: .85rem; top: 50%;
      transform: translateY(-50%);
      color: var(--text-lt); font-size: .78rem; pointer-events: none;
    }
    .field-input {
      width: 100%;
      padding: .72rem .9rem .72rem 2.2rem;
      border: 1.5px solid var(--border);
      border-radius: var(--radius-sm);
      font-family: 'Inter', sans-serif; font-size: .9rem;
      background: var(--gray-bg); color: var(--text-dark);
      outline: none; transition: all .2s;
    }
    .field-input::placeholder { color: #aab8b3; }
    .field-input:focus {
      border-color: var(--green-mid);
      box-shadow: 0 0 0 3px rgba(77,122,104,.13);
      background: var(--white);
    }
    .field-hint { font-size: .72rem; color: var(--text-lt); margin-top: .3rem; }

    /* Password toggle */
    .pass-toggle {
      position: absolute; right: .85rem; top: 50%;
      transform: translateY(-50%);
      background: none; border: none; cursor: pointer;
      color: var(--text-lt); font-size: .82rem; padding: .2rem;
    }

    /* Password strength */
    .strength-bar { display: flex; gap: .2rem; margin-top: .5rem; }
    .strength-seg {
      height: 4px; flex: 1; border-radius: 4px;
      background: var(--border); transition: background .3s;
    }
    .strength-label { font-size: .68rem; color: var(--text-lt); margin-top: .25rem; text-align: right; }

    /* ── OTP boxes ── */
    .otp-grid {
      display: flex;
      justify-content: center;
      gap: .55rem;
      margin: .2rem 0 1.2rem;
    }
    .otp-box {
      width: 48px; height: 56px;
      border: 2px solid var(--border);
      border-radius: 12px;
      text-align: center;
      font-size: 1.3rem; font-weight: 800;
      color: var(--text-dark);
      background: var(--gray-bg);
      outline: none;
      transition: border-color .2s, background .2s, box-shadow .2s;
      caret-color: transparent;
    }
    .otp-box:focus {
      border-color: var(--green-dark);
      background: var(--white);
      box-shadow: 0 0 0 3px rgba(45,90,71,.13);
    }
    .otp-box.filled { border-color: var(--green-mid); background: var(--green-pale); }
    /* Hidden real field for form submit */
    #codigoHidden { display: none; }

    /* ── Timer / reenviar ── */
    .timer-wrap { text-align: center; margin-top: -.5rem; margin-bottom: 1.1rem; }
    .timer-text  { font-size: .78rem; color: var(--text-lt); }
    .timer-num   { font-weight: 800; color: var(--green-dark); }
    .resend-link {
      font-size: .78rem; font-weight: 700; color: var(--green-dark);
      background: none; border: none; cursor: pointer; font-family: inherit;
      text-decoration: underline; display: none;
    }

    /* ── Buttons ── */
    .btn-main {
      width: 100%;
      padding: .8rem;
      background: linear-gradient(135deg, var(--green-dark), var(--green));
      color: #fff; border: none;
      border-radius: var(--radius-sm);
      font-family: 'Inter', sans-serif;
      font-size: .92rem; font-weight: 700;
      cursor: pointer;
      display: flex; align-items: center; justify-content: center; gap: .5rem;
      box-shadow: 0 4px 14px rgba(45,90,71,.25);
      transition: all .2s;
      margin-bottom: 1rem;
    }
    .btn-main:hover { transform: translateY(-1px); box-shadow: 0 8px 22px rgba(45,90,71,.35); }
    .btn-main:disabled { background: #cbd5e0; box-shadow: none; cursor: not-allowed; transform: none; }

    .btn-back {
      display: flex; align-items: center; justify-content: center; gap: .4rem;
      width: 100%; padding: .65rem;
      background: var(--green-pale); color: var(--text-mid);
      border: 1.5px solid var(--border);
      border-radius: var(--radius-sm);
      font-family: 'Inter', sans-serif; font-size: .85rem; font-weight: 600;
      text-decoration: none; cursor: pointer;
      transition: background .2s;
    }
    .btn-back:hover { background: #d4ece2; color: var(--green-dark); }

    /* ── Footer ── */
    .rec-footer {
      text-align: center; margin-top: 1.3rem;
      font-size: .76rem; color: var(--text-lt);
    }
    .rec-footer a { color: var(--green-dark); font-weight: 700; text-decoration: none; }
    .rec-footer a:hover { text-decoration: underline; }

    /* ── Success state ── */
    .success-anim {
      text-align: center; padding: 1.5rem 0 .5rem;
      animation: fadeUp .4s ease both;
    }
    .success-check {
      width: 72px; height: 72px; border-radius: 50%;
      background: #dcfce7;
      display: flex; align-items: center; justify-content: center;
      margin: 0 auto 1rem;
      font-size: 2rem; color: #16a34a;
      animation: popIn .4s cubic-bezier(.34,1.56,.64,1) both;
    }
    @keyframes popIn { from{transform:scale(.4);opacity:0} to{transform:scale(1);opacity:1} }
  </style>
</head>
<body>

<div class="rec-wrap">
  <div class="auth-card">

    <%-- ── Progress steps ── --%>
    <div class="steps-bar">
      <div class="step ${paso == 'solicitar' ? 'active' : 'done'}">
        <div class="step-circle">
          <c:choose>
            <c:when test="${paso != 'solicitar'}"><i class="fas fa-check"></i></c:when>
            <c:otherwise>1</c:otherwise>
          </c:choose>
        </div>
        <div class="step-label">Correo</div>
      </div>

      <div class="step-line ${paso != 'solicitar' ? 'done' : ''}"></div>

      <div class="step ${paso == 'verificar' ? 'active' : (paso == 'nueva' ? 'done' : '')}">
        <div class="step-circle">
          <c:choose>
            <c:when test="${paso == 'nueva'}"><i class="fas fa-check"></i></c:when>
            <c:otherwise>2</c:otherwise>
          </c:choose>
        </div>
        <div class="step-label">Código</div>
      </div>

      <div class="step-line ${paso == 'nueva' ? 'done' : ''}"></div>

      <div class="step ${paso == 'nueva' ? 'active' : ''}">
        <div class="step-circle">3</div>
        <div class="step-label">Nueva clave</div>
      </div>
    </div>

    <%-- ════════════════════════════════════════ --%>
    <%-- PASO 1 — Solicitar correo               --%>
    <%-- ════════════════════════════════════════ --%>
    <c:if test="${paso == 'solicitar'}">

      <div class="rec-icon"><i class="fas fa-lock-open"></i></div>
      <div class="rec-title">Recuperar contraseña</div>
      <div class="rec-sub">Ingresa tu correo registrado y te enviaremos un código de verificación</div>

      <c:if test="${not empty errorMsg}">
        <div class="alert-err"><i class="fas fa-exclamation-circle"></i> ${errorMsg}</div>
      </c:if>
      <c:if test="${not empty infoMsg}">
        <div class="alert-info"><i class="fas fa-check-circle"></i> ${infoMsg}</div>
      </c:if>

      <form method="post" action="${pageContext.request.contextPath}/recuperar" id="frmSolicitar">
        <input type="hidden" name="paso" value="solicitar">
        <div class="field-group">
          <label for="email">Correo electrónico</label>
          <div class="field-wrap">
            <span class="field-icon"><i class="fas fa-envelope"></i></span>
            <input type="email" name="email" id="email" class="field-input"
                   placeholder="tu@correo.com" required autocomplete="email"
                   autofocus>
          </div>
        </div>
        <button type="submit" class="btn-main" id="btnSolicitar">
          <i class="fas fa-paper-plane"></i> Enviar código
        </button>
      </form>

      <a href="${pageContext.request.contextPath}/login" class="btn-back">
        <i class="fas fa-arrow-left"></i> Volver al inicio de sesión
      </a>

    </c:if>

    <%-- ════════════════════════════════════════ --%>
    <%-- PASO 2 — Verificar código OTP           --%>
    <%-- ════════════════════════════════════════ --%>
    <c:if test="${paso == 'verificar'}">

      <div class="rec-icon"><i class="fas fa-shield-alt"></i></div>
      <div class="rec-title">Verificar código</div>
      <div class="rec-sub">
        Ingresa el código de 6 dígitos enviado a
        <c:choose>
          <c:when test="${not empty emailMasked}"><strong>${emailMasked}</strong></c:when>
          <c:otherwise><strong>tu correo</strong></c:otherwise>
        </c:choose>
      </div>

      <c:if test="${not empty errorMsg}">
        <div class="alert-err"><i class="fas fa-exclamation-circle"></i> ${errorMsg}</div>
      </c:if>
      <c:if test="${not empty infoMsg}">
        <div class="alert-info"><i class="fas fa-check-circle"></i> ${infoMsg}</div>
      </c:if>

      <form method="post" action="${pageContext.request.contextPath}/recuperar" id="frmVerificar">
        <input type="hidden" name="paso"   value="verificar">
        <input type="hidden" name="codigo" id="codigoHidden">

        <%-- 6 cajas individuales --%>
        <div class="otp-grid" id="otpGrid">
          <input class="otp-box" type="text" inputmode="numeric" maxlength="1" autocomplete="off">
          <input class="otp-box" type="text" inputmode="numeric" maxlength="1" autocomplete="off">
          <input class="otp-box" type="text" inputmode="numeric" maxlength="1" autocomplete="off">
          <input class="otp-box" type="text" inputmode="numeric" maxlength="1" autocomplete="off">
          <input class="otp-box" type="text" inputmode="numeric" maxlength="1" autocomplete="off">
          <input class="otp-box" type="text" inputmode="numeric" maxlength="1" autocomplete="off">
        </div>

        <%-- Timer + reenviar --%>
        <div class="timer-wrap">
          <span class="timer-text" id="timerText">
            Reenviar código en <span class="timer-num" id="timerNum">5:00</span>
          </span>
          <button type="button" class="resend-link" id="resendBtn" onclick="reenviarCodigo()">
            <i class="fas fa-redo"></i> Reenviar código
          </button>
        </div>

        <button type="submit" class="btn-main" id="btnVerificar" disabled>
          <i class="fas fa-check-circle"></i> Verificar código
        </button>
      </form>

      <a href="${pageContext.request.contextPath}/recuperar?paso=solicitar" class="btn-back">
        <i class="fas fa-arrow-left"></i> Cambiar correo
      </a>

    </c:if>

    <%-- ════════════════════════════════════════ --%>
    <%-- PASO 3 — Nueva contraseña               --%>
    <%-- ════════════════════════════════════════ --%>
    <c:if test="${paso == 'nueva'}">

      <div class="rec-icon"><i class="fas fa-key"></i></div>
      <div class="rec-title">Nueva contraseña</div>
      <div class="rec-sub">Elige una contraseña segura para tu cuenta</div>

      <c:if test="${not empty errorMsg}">
        <div class="alert-err"><i class="fas fa-exclamation-circle"></i> ${errorMsg}</div>
      </c:if>

      <form method="post" action="${pageContext.request.contextPath}/recuperar" id="frmNueva" novalidate>
        <input type="hidden" name="paso" value="nueva">

        <div class="field-group">
          <label for="password">Nueva contraseña</label>
          <div class="field-wrap">
            <span class="field-icon"><i class="fas fa-lock"></i></span>
            <input type="password" name="password" id="password" class="field-input"
                   placeholder="Mínimo 6 caracteres" required autocomplete="new-password"
                   oninput="updateStrength(this.value)" autofocus>
            <button type="button" class="pass-toggle" onclick="togglePass('password','eyePass')">
              <i class="fas fa-eye" id="eyePass"></i>
            </button>
          </div>
          <div class="strength-bar" id="strengthBar">
            <div class="strength-seg" id="s1"></div>
            <div class="strength-seg" id="s2"></div>
            <div class="strength-seg" id="s3"></div>
            <div class="strength-seg" id="s4"></div>
          </div>
          <div class="strength-label" id="strengthLabel"></div>
        </div>

        <div class="field-group">
          <label for="confirmar">Confirmar contraseña</label>
          <div class="field-wrap">
            <span class="field-icon"><i class="fas fa-lock"></i></span>
            <input type="password" name="confirmar" id="confirmar" class="field-input"
                   placeholder="Repite la contraseña" required autocomplete="new-password"
                   oninput="checkMatch()">
            <button type="button" class="pass-toggle" onclick="togglePass('confirmar','eyeConf')">
              <i class="fas fa-eye" id="eyeConf"></i>
            </button>
          </div>
          <div class="field-hint" id="matchHint"></div>
        </div>

        <button type="submit" class="btn-main" id="btnNueva">
          <i class="fas fa-save"></i> Guardar contraseña
        </button>
      </form>

    </c:if>

    <%-- Footer --%>
    <div class="rec-footer">
      <i class="fas fa-shield-alt" style="color:var(--green-mid);margin-right:.3rem;"></i>
      ¿Recuerdas tu contraseña?
      <a href="${pageContext.request.contextPath}/login">Inicia sesión</a>
    </div>

  </div>
</div>

<script>
// ── OTP Boxes ─────────────────────────────────────────────────────────────
(function() {
  const boxes   = Array.from(document.querySelectorAll('.otp-box'));
  const hidden  = document.getElementById('codigoHidden');
  const btnVer  = document.getElementById('btnVerificar');
  if (!boxes.length) return;

  function updateHidden() {
    const val = boxes.map(b => b.value).join('');
    if (hidden) hidden.value = val;
    boxes.forEach(b => b.classList.toggle('filled', b.value !== ''));
    if (btnVer) btnVer.disabled = val.length < 6;
  }

  boxes.forEach((box, i) => {
    box.addEventListener('input', e => {
      // Accept only digits
      box.value = box.value.replace(/\D/g, '').slice(-1);
      if (box.value && i < boxes.length - 1) boxes[i + 1].focus();
      updateHidden();
    });

    box.addEventListener('keydown', e => {
      if (e.key === 'Backspace' && !box.value && i > 0) {
        boxes[i - 1].focus();
        boxes[i - 1].value = '';
        updateHidden();
      }
    });

    box.addEventListener('paste', e => {
      e.preventDefault();
      const pasted = (e.clipboardData || window.clipboardData).getData('text').replace(/\D/g,'').slice(0,6);
      pasted.split('').forEach((ch, j) => { if (boxes[j]) boxes[j].value = ch; });
      updateHidden();
      const nextEmpty = boxes.findIndex(b => !b.value);
      (boxes[nextEmpty] || boxes[boxes.length-1]).focus();
    });
  });

  // Auto-focus first box
  if (boxes[0]) boxes[0].focus();
})();

// ── Timer ─────────────────────────────────────────────────────────────────
(function() {
  const numEl   = document.getElementById('timerNum');
  const textEl  = document.getElementById('timerText');
  const resend  = document.getElementById('resendBtn');
  if (!numEl) return;

  let secs = 300; // 5 min
  const interval = setInterval(() => {
    secs--;
    const m = Math.floor(secs / 60);
    const s = secs % 60;
    numEl.textContent = m + ':' + String(s).padStart(2,'0');
    if (secs <= 0) {
      clearInterval(interval);
      textEl.style.display = 'none';
      if (resend) resend.style.display = 'inline';
    }
  }, 1000);
})();

function reenviarCodigo() {
  window.location.href = '${pageContext.request.contextPath}/recuperar?paso=solicitar';
}

// ── Password strength ─────────────────────────────────────────────────────
function updateStrength(val) {
  const segs  = ['s1','s2','s3','s4'].map(id => document.getElementById(id));
  const label = document.getElementById('strengthLabel');
  if (!segs[0] || !label) return;

  let score = 0;
  if (val.length >= 6)  score++;
  if (val.length >= 10) score++;
  if (/[A-Z]/.test(val) && /[a-z]/.test(val)) score++;
  if (/[0-9]/.test(val) && /[\W_]/.test(val)) score++;

  const colors  = ['#ef4444','#f97316','#eab308','#22c55e'];
  const labels  = ['Muy débil','Débil','Aceptable','Fuerte'];
  segs.forEach((s, i) => s.style.background = i < score ? colors[score - 1] : 'var(--border)');
  label.textContent  = val.length ? labels[score - 1] || labels[0] : '';
  label.style.color  = score > 0 ? colors[score - 1] : 'var(--text-lt)';
}

function checkMatch() {
  const p = document.getElementById('password');
  const c = document.getElementById('confirmar');
  const h = document.getElementById('matchHint');
  if (!p || !c || !h) return;
  if (!c.value) { h.textContent = ''; return; }
  if (p.value === c.value) {
    h.textContent = '✓ Las contraseñas coinciden';
    h.style.color = '#16a34a';
  } else {
    h.textContent = '✗ Las contraseñas no coinciden';
    h.style.color = '#ef4444';
  }
}

// ── Toggle password ───────────────────────────────────────────────────────
function togglePass(inputId, iconId) {
  const inp = document.getElementById(inputId);
  const ico = document.getElementById(iconId);
  if (!inp || !ico) return;
  if (inp.type === 'password') { inp.type = 'text'; ico.className = 'fas fa-eye-slash'; }
  else { inp.type = 'password'; ico.className = 'fas fa-eye'; }
}

// ── Form validation ───────────────────────────────────────────────────────
const frmNueva = document.getElementById('frmNueva');
if (frmNueva) {
  frmNueva.addEventListener('submit', function(e) {
    const p = document.getElementById('password').value;
    const c = document.getElementById('confirmar').value;
    if (p.length < 6) {
      e.preventDefault();
      alert('La contraseña debe tener al menos 6 caracteres.');
      return;
    }
    if (p !== c) {
      e.preventDefault();
      alert('Las contraseñas no coinciden.');
    }
  });
}

// ── Loading spinner on submit ─────────────────────────────────────────────
document.querySelectorAll('form').forEach(form => {
  form.addEventListener('submit', function() {
    const btn = this.querySelector('button[type=submit]');
    if (btn) {
      btn.disabled = true;
      btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Procesando...';
    }
  });
});
</script>
</body>
</html>

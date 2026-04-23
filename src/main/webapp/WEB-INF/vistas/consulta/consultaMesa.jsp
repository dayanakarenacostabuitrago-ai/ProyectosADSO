<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib uri="jakarta.tags.core" prefix="c" %>
    <!DOCTYPE html>
    <html lang="es">

    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <script src="https://www.google.com/recaptcha/api.js" async defer></script>
      <title>Consulta de Mesa &#8212; Registradur&#237;a de Nobsa</title>
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
      <link
        href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=DM+Sans:wght@300;400;500;600&display=swap"
        rel="stylesheet">

      <style>
        *,
        *::before,
        *::after {
          box-sizing: border-box;
          margin: 0;
          padding: 0;
        }

        :root {
          --azul: #0b2346;
          --azul-med: #163a6b;
          --azul-suave: #1e4d8c;
          --oro: #c8a84b;
          --oro-claro: #e6c96a;
          --fondo: #f3f5f9;
          --blanco: #ffffff;
          --texto: #1a2535;
          --gris: #6b7c93;
          --borde: #dce3ef;
          --exito: #0f7a3d;
          --error: #b91c1c;
        }

        body {
          font-family: 'DM Sans', sans-serif;
          background: var(--fondo);
          min-height: 100vh;
          display: flex;
          flex-direction: column;
          color: var(--texto);
        }

        .banda-gov {
          height: 6px;
          background: linear-gradient(90deg, #ffd900 33.33%, #003087 33.33% 66.66%, #ce1126 66.66%);
        }

        .top-bar {
          background: var(--azul);
          padding: 10px 40px;
          display: flex;
          align-items: center;
          justify-content: space-between;
          gap: 16px;
        }

        .top-bar-brand {
          display: flex;
          align-items: center;
          gap: 12px;
        }

        .escudo {
          width: 36px;
          height: 36px;
          background: var(--oro);
          border-radius: 50%;
          display: flex;
          align-items: center;
          justify-content: center;
          flex-shrink: 0;
        }

        .escudo i {
          color: var(--azul);
          font-size: 16px;
        }

        .top-bar-brand span {
          color: #fff;
          font-size: 13px;
          font-weight: 500;
          letter-spacing: .01em;
        }

        .btn-admin {
          color: var(--oro);
          text-decoration: none;
          font-size: 12px;
          font-weight: 500;
          padding: 6px 14px;
          border: 1px solid rgba(200, 168, 75, .4);
          border-radius: 20px;
          display: inline-flex;
          align-items: center;
          gap: 6px;
          transition: all .2s;
        }

        .btn-admin:hover {
          background: rgba(200, 168, 75, .12);
        }

        .hero {
          background: linear-gradient(135deg, var(--azul) 0%, var(--azul-med) 60%, var(--azul-suave) 100%);
          padding: 52px 40px 80px;
          text-align: center;
          position: relative;
          overflow: hidden;
        }

        .hero::before {
          content: '';
          position: absolute;
          inset: 0;
          background:
            radial-gradient(ellipse 60% 50% at 80% 120%, rgba(200, 168, 75, .18) 0%, transparent 70%),
            radial-gradient(ellipse 40% 60% at -10% 30%, rgba(200, 168, 75, .10) 0%, transparent 60%);
        }

        .hero::after {
          content: '';
          position: absolute;
          bottom: -2px;
          left: 0;
          right: 0;
          height: 52px;
          background: var(--fondo);
          clip-path: ellipse(58% 100% at 50% 100%);
        }

        .hero-tag {
          display: inline-flex;
          align-items: center;
          gap: 7px;
          background: rgba(200, 168, 75, .18);
          border: 1px solid rgba(200, 168, 75, .4);
          color: var(--oro-claro);
          font-size: 11px;
          font-weight: 600;
          letter-spacing: .1em;
          text-transform: uppercase;
          padding: 5px 14px;
          border-radius: 20px;
          margin-bottom: 18px;
          position: relative;
        }

        .hero h1 {
          font-family: 'Playfair Display', Georgia, serif;
          font-size: clamp(26px, 4vw, 40px);
          font-weight: 900;
          color: #fff;
          line-height: 1.15;
          position: relative;
          margin-bottom: 10px;
        }

        .hero h1 span {
          color: var(--oro);
        }

        .hero p {
          color: rgba(255, 255, 255, .72);
          font-size: 15px;
          position: relative;
          max-width: 420px;
          margin: 0 auto;
        }

        .main {
          flex: 1;
          max-width: 700px;
          width: 100%;
          margin: -30px auto 48px;
          padding: 0 20px;
          position: relative;
          z-index: 2;
        }

        .card {
          background: var(--blanco);
          border-radius: 16px;
          box-shadow: 0 4px 24px rgba(11, 35, 70, .10), 0 1px 4px rgba(11, 35, 70, .06);
          overflow: hidden;
          margin-bottom: 16px;
          animation: fadeUp .4s ease both;
        }

        @keyframes fadeUp {
          from {
            opacity: 0;
            transform: translateY(18px)
          }

          to {
            opacity: 1;
            transform: translateY(0)
          }
        }

        .form-card {
          padding: 36px;
        }

        .form-label {
          display: block;
          font-size: 12px;
          font-weight: 600;
          letter-spacing: .07em;
          text-transform: uppercase;
          color: var(--gris);
          margin-bottom: 8px;
        }

        .input-wrap {
          position: relative;
        }

        .input-wrap i {
          position: absolute;
          left: 16px;
          top: 50%;
          transform: translateY(-50%);
          color: var(--gris);
          font-size: 15px;
          pointer-events: none;
        }

        .input-doc {
          width: 100%;
          padding: 14px 16px 14px 44px;
          border: 2px solid var(--borde);
          border-radius: 10px;
          font-family: 'DM Sans', sans-serif;
          font-size: 16px;
          font-weight: 500;
          color: var(--texto);
          outline: none;
          transition: border-color .2s, box-shadow .2s;
          background: #fafbfd;
        }

        .input-doc:focus {
          border-color: var(--azul-suave);
          box-shadow: 0 0 0 4px rgba(30, 77, 140, .10);
          background: #fff;
        }

        .input-doc::placeholder {
          color: #b0bbc9;
          font-weight: 400;
        }

        .form-hint {
          font-size: 12px;
          color: var(--gris);
          margin-top: 6px;
        }

        .recaptcha-wrap {
          margin: 20px 0;
        }

        .btn-consultar {
          width: 100%;
          background: var(--azul);
          color: #fff;
          border: none;
          padding: 15px 28px;
          border-radius: 10px;
          font-family: 'DM Sans', sans-serif;
          font-size: 15px;
          font-weight: 600;
          cursor: pointer;
          display: flex;
          align-items: center;
          justify-content: center;
          gap: 10px;
          transition: background .2s, transform .15s, box-shadow .2s;
          box-shadow: 0 4px 14px rgba(11, 35, 70, .22);
        }

        .btn-consultar:hover {
          background: var(--azul-suave);
          transform: translateY(-1px);
          box-shadow: 0 6px 20px rgba(11, 35, 70, .28);
        }

        .btn-consultar:active {
          transform: translateY(0);
        }

        .btn-consultar i {
          font-size: 16px;
        }

        .alert {
          display: flex;
          align-items: flex-start;
          gap: 12px;
          padding: 14px 18px;
          border-radius: 10px;
          font-size: 14px;
          margin-bottom: 16px;
          animation: fadeUp .3s ease both;
        }

        .alert i {
          font-size: 18px;
          flex-shrink: 0;
          margin-top: 1px;
        }

        .alert-error {
          background: #fff1f1;
          border: 1px solid #fecaca;
          color: var(--error);
        }

        .alert-ok {
          background: #f0faf5;
          border: 1px solid #a7f3d0;
          color: var(--exito);
        }

        .alert-warn {
          background: #fffbeb;
          border: 1px solid #fde68a;
          color: #92400e;
        }

        .res-header {
          background: linear-gradient(120deg, var(--azul) 0%, var(--azul-med) 100%);
          padding: 28px 32px;
          display: flex;
          align-items: center;
          gap: 20px;
        }

        .res-avatar {
          width: 56px;
          height: 56px;
          background: rgba(200, 168, 75, .18);
          border: 2px solid rgba(200, 168, 75, .5);
          border-radius: 50%;
          display: flex;
          align-items: center;
          justify-content: center;
          flex-shrink: 0;
        }

        .res-avatar i {
          color: var(--oro);
          font-size: 24px;
        }

        .res-header-info small {
          display: block;
          color: rgba(255, 255, 255, .55);
          font-size: 11px;
          font-weight: 600;
          letter-spacing: .1em;
          text-transform: uppercase;
          margin-bottom: 4px;
        }

        .res-nombre {
          font-family: 'Playfair Display', serif;
          font-size: 22px;
          font-weight: 700;
          color: var(--oro);
          line-height: 1.2;
        }

        .datos-grid {
          display: grid;
          grid-template-columns: 1fr 1fr;
          gap: 0;
        }

        .dato-cell {
          padding: 16px 24px;
          border-bottom: 1px solid var(--borde);
          border-right: 1px solid var(--borde);
          transition: background .15s;
        }

        .dato-cell:nth-child(even) {
          border-right: none;
        }

        .dato-cell:nth-last-child(-n+2) {
          border-bottom: none;
        }

        .dato-cell.full {
          grid-column: 1 / -1;
          border-right: none;
        }

        .dato-cell:hover {
          background: #fafbfd;
        }

        .dato-icon-label {
          display: flex;
          align-items: center;
          gap: 7px;
          font-size: 11px;
          font-weight: 600;
          letter-spacing: .06em;
          text-transform: uppercase;
          color: var(--gris);
          margin-bottom: 5px;
        }

        .dato-icon-label i {
          color: var(--azul-suave);
          font-size: 12px;
        }

        .dato-val {
          font-size: 14px;
          font-weight: 500;
          color: var(--texto);
        }

        .mesa-highlight {
          background: linear-gradient(120deg, var(--azul) 0%, var(--azul-med) 100%);
          padding: 20px 32px;
          display: flex;
          align-items: center;
          justify-content: space-between;
          gap: 16px;
        }

        .mesa-label-txt {
          display: flex;
          align-items: center;
          gap: 10px;
          color: rgba(255, 255, 255, .7);
          font-size: 13px;
          font-weight: 500;
        }

        .mesa-label-txt i {
          color: var(--oro);
          font-size: 18px;
        }

        .mesa-numero {
          background: var(--oro);
          color: var(--azul);
          font-family: 'Playfair Display', serif;
          font-size: 22px;
          font-weight: 900;
          padding: 8px 24px;
          border-radius: 40px;
          letter-spacing: .03em;
          box-shadow: 0 4px 14px rgba(200, 168, 75, .4);
        }

        .correo-status {
          padding: 16px 24px;
          border-top: 1px solid var(--borde);
        }

        .acciones {
          display: flex;
          gap: 10px;
          justify-content: flex-end;
          padding: 14px 24px;
          border-top: 1px solid var(--borde);
          background: #fafbfd;
        }

        .btn-accion {
          display: inline-flex;
          align-items: center;
          gap: 7px;
          padding: 9px 18px;
          border-radius: 8px;
          font-family: 'DM Sans', sans-serif;
          font-size: 13px;
          font-weight: 600;
          cursor: pointer;
          border: none;
          text-decoration: none;
          transition: all .2s;
        }

        .btn-nueva {
          background: transparent;
          color: var(--azul);
          border: 1.5px solid var(--borde);
        }

        .btn-nueva:hover {
          background: var(--fondo);
          border-color: var(--azul-suave);
        }

        .btn-imprimir {
          --color: 211deg 40% 52%;
          --color-has: 211deg 100% 60%;
          background: rgba(11, 35, 70, .05);
          color: hsl(var(--color));
          border: 1px solid hsl(var(--color));
          box-shadow: none;
        }

        .btn-imprimir:hover {
          background: rgba(13, 110, 253, .1);
          border-color: hsl(var(--color-has));
          color: hsl(var(--color-has));
          box-shadow: 0 4px 14px rgba(13, 110, 253, .22);
          transform: translateY(-1px);
        }

        .btn-imprimir svg {
          overflow: visible;
          height: 16px;
          width: 16px;
          --ease: cubic-bezier(0.5, 0, 0.25, 1);
          --zoom-from: 1.75;
          --zoom-via: 0.75;
          --zoom-to: 1;
          --duration: 0.9s;
        }

        .btn-imprimir:hover path[data-path="box"] {
          animation: cm-saved var(--duration) var(--ease) forwards;
          fill: hsl(211deg 100% 60% / 0.25);
        }

        .btn-imprimir:hover path[data-path="line-top"] {
          animation: cm-saved-top var(--duration) var(--ease) forwards;
        }

        .btn-imprimir:hover path[data-path="line-bottom"] {
          animation: cm-saved-bottom var(--duration) var(--ease) forwards,
            cm-saved-bottom-2 calc(var(--duration) * 1) var(--ease) calc(var(--duration) * 0.75);
        }

        @keyframes cm-saved {
          33% {
            transform: scale(var(--zoom-from));
          }

          66% {
            transform: scale(var(--zoom-via));
          }

          100% {
            transform: scale(var(--zoom-to));
          }
        }

        @keyframes cm-saved-top {
          33% {
            transform: translate(1px, 2px) scale(var(--zoom-from));
            d: path("M 3 5 L 3 8 L 3 8");
          }

          66% {
            transform: rotate(20deg) translate(2px, -2px) scale(var(--zoom-via));
          }

          100% {
            transform: scale(var(--zoom-to));
          }
        }

        @keyframes cm-saved-bottom {
          33% {
            d: path("M 17 20 L 17 13 L 7 13 L 7 20");
          }

          100% {
            d: path("M 17 21 L 17 21 L 7 21 L 7 21");
          }
        }

        @keyframes cm-saved-bottom-2 {
          from {
            d: path("M 17 21 L 17 21 L 7 21 L 7 21");
          }

          to {
            d: path("M 17 20 L 17 13 L 7 13 L 7 20");
          }
        }

        .sin-mesa {
          background: var(--blanco);
          border-radius: 16px;
          padding: 52px 36px;
          text-align: center;
          box-shadow: 0 4px 24px rgba(11, 35, 70, .10);
          animation: fadeUp .4s ease both;
          width: 100%;
          max-width: 600px;
          margin: 0 auto;
        }

        .sin-mesa-icono {
          width: 80px;
          height: 80px;
          background: #fef3e2;
          border-radius: 50%;
          display: flex;
          align-items: center;
          justify-content: center;
          margin: 0 auto 20px;
          animation: pulse 2.5s infinite;
        }

        .sin-mesa-icono i {
          font-size: 36px;
          color: var(--oro);
        }

        @keyframes pulse {

          0%,
          100% {
            box-shadow: 0 0 0 0 rgba(200, 168, 75, .3)
          }

          50% {
            box-shadow: 0 0 0 14px rgba(200, 168, 75, 0)
          }
        }

        .sin-mesa h2 {
          font-family: 'Playfair Display', serif;
          font-size: 22px;
          color: var(--azul);
          margin-bottom: 10px;
        }

        .sin-mesa p {
          color: var(--gris);
          font-size: 14px;
          line-height: 1.6;
          margin-bottom: 24px;
        }

        .sin-mesa-info {
          background: var(--fondo);
          border-radius: 10px;
          padding: 16px 24px;
          text-align: left;
          margin-bottom: 24px;
        }

        .sin-mesa-info p {
          color: var(--texto);
          font-size: 13px;
          margin-bottom: 6px;
        }

        .sin-mesa-info p:last-child {
          margin-bottom: 0;
        }

        .sin-mesa-info i {
          color: var(--oro);
          margin-right: 8px;
          width: 14px;
        }

        /* Botones centrados y alineados */
        .sin-mesa-buttons {
          display: flex;
          justify-content: center;
          gap: 12px;
          margin-top: 8px;
        }

        .btn-volver {
          display: inline-flex;
          align-items: center;
          justify-content: center;
          gap: 8px;
          padding: 12px 28px;
          background: var(--azul);
          color: #fff;
          border-radius: 10px;
          text-decoration: none;
          font-size: 14px;
          font-weight: 600;
          transition: background .2s;
          flex: 0 1 auto;
        }

        .btn-volver:hover {
          background: var(--azul-suave);
        }

        .btn-solicitud {
          background: var(--azul-suave);
        }

        .btn-solicitud:hover {
          background: var(--azul-med);
        }

        .footer {
          background: var(--azul);
          color: rgba(255, 255, 255, .45);
          text-align: center;
          padding: 16px;
          font-size: 12px;
          margin-top: auto;
          border-top: 3px solid var(--oro);
        }

        .footer span {
          color: var(--oro);
        }

        /* ══════════════════════════════════════════════════
   CHATBOT — Versión mejorada y limpia
══════════════════════════════════════════════════ */

        /* Contenedor principal esquina inferior derecha */
        #chatbot-container {
          position: fixed;
          bottom: 24px;
          right: 24px;
          z-index: 9999;
          display: flex;
          flex-direction: column;
          align-items: flex-end;
          gap: 0;
        }

        /* Burbuja de diálogo */
        #robot-bubble {
          background: linear-gradient(135deg, #fff 0%, #fef8e8 100%);
          border-radius: 20px 20px 8px 20px;
          padding: 10px 18px;
          box-shadow: 0 8px 20px rgba(11, 35, 70, .12);
          border: 1px solid rgba(200, 168, 75, .4);
          font-family: 'DM Sans', sans-serif;
          font-size: 12px;
          font-weight: 500;
          color: #0b2346;
          max-width: 200px;
          line-height: 1.4;
          text-align: center;
          cursor: pointer;
          transition: all .2s ease;
          position: relative;
          margin-bottom: 8px;
        }

        #robot-bubble:hover {
          transform: translateY(-2px);
          box-shadow: 0 12px 24px rgba(11, 35, 70, .18);
          border-color: #c8a84b;
        }

        #robot-bubble::after {
          content: '';
          position: absolute;
          bottom: -8px;
          right: 30px;
          width: 0;
          height: 0;
          border-left: 8px solid transparent;
          border-right: 8px solid transparent;
          border-top: 10px solid #fef8e8;
          filter: drop-shadow(2px 4px 4px rgba(0, 0, 0, .05));
        }

        #bubble-close {
          position: absolute;
          top: 5px;
          right: 8px;
          background: none;
          border: none;
          color: #b0b8c4;
          font-size: 12px;
          cursor: pointer;
          padding: 2px;
        }

        #bubble-close:hover {
          color: #0b2346;
        }

        /* Robot SVG clickeable */
        #robot-trigger {
          cursor: pointer;
          width: 100px;
          height: 120px;
          display: block;
          filter: drop-shadow(0 6px 12px rgba(11, 35, 70, .2));
          transition: transform .2s;
        }

        #robot-trigger:hover {
          transform: scale(1.05);
        }

        /* Notif badge */
        #chat-notif {
          position: absolute;
          top: -5px;
          right: -5px;
          width: 18px;
          height: 18px;
          background: #e53935;
          border-radius: 50%;
          font-size: 10px;
          font-weight: 700;
          color: #fff;
          display: flex;
          align-items: center;
          justify-content: center;
          border: 2px solid #fff;
          animation: bounceIn .4s;
        }

        @keyframes bounceIn {
          0% {
            transform: scale(0)
          }

          70% {
            transform: scale(1.2)
          }

          100% {
            transform: scale(1)
          }
        }

        /* Ventana del chat */
        #chat-window {
          position: fixed;
          bottom: 24px;
          right: 24px;
          width: 380px;
          max-height: 560px;
          background: #fff;
          border-radius: 24px;
          box-shadow: 0 20px 40px rgba(0, 0, 0, .25);
          display: none;
          flex-direction: column;
          z-index: 10000;
          overflow: hidden;
          border: 1px solid rgba(200, 168, 75, .2);
        }

        #chat-window.open {
          display: flex;
          animation: slideUp .25s ease;
        }

        @keyframes slideUp {
          from {
            transform: translateY(20px);
            opacity: 0
          }

          to {
            transform: translateY(0);
            opacity: 1
          }
        }

        .chat-header {
          background: linear-gradient(135deg, var(--azul) 0%, var(--azul-med) 100%);
          padding: 14px 18px;
          display: flex;
          align-items: center;
          gap: 12px;
          border-bottom: 2px solid var(--oro);
        }

        .chat-avatar-svg {
          width: 42px;
          height: 52px;
          flex-shrink: 0;
        }

        .chat-header-info {
          flex: 1;
        }

        .chat-header-name {
          color: #fff;
          font-size: 14px;
          font-weight: 700;
        }

        .chat-header-status {
          color: var(--oro);
          font-size: 10px;
          display: flex;
          align-items: center;
          gap: 5px;
          margin-top: 2px;
        }

        .status-dot {
          width: 6px;
          height: 6px;
          background: #4cff88;
          border-radius: 50%;
          animation: blink-dot 2s infinite;
        }

        @keyframes blink-dot {

          0%,
          100% {
            opacity: 1
          }

          50% {
            opacity: .3
          }
        }

        #chat-close {
          background: none;
          border: none;
          color: rgba(255, 255, 255, .5);
          cursor: pointer;
          font-size: 18px;
          padding: 4px;
          line-height: 1;
          transition: color .2s;
        }

        #chat-close:hover {
          color: #fff;
        }

        .chat-messages {
          flex: 1;
          overflow-y: auto;
          padding: 16px;
          display: flex;
          flex-direction: column;
          gap: 10px;
          background: #f8fafd;
          max-height: 320px;
        }

        .chat-messages::-webkit-scrollbar {
          width: 4px;
        }

        .chat-messages::-webkit-scrollbar-track {
          background: #e2e8f0;
          border-radius: 4px;
        }

        .chat-messages::-webkit-scrollbar-thumb {
          background: #c8a84b;
          border-radius: 4px;
        }

        .msg-wrap {
          display: flex;
          flex-direction: column;
          margin-bottom: 4px;
        }

        .msg-wrap.user {
          align-items: flex-end;
        }

        .msg-wrap.bot {
          align-items: flex-start;
        }

        .msg {
          max-width: 85%;
          padding: 10px 14px;
          border-radius: 16px;
          font-size: 13px;
          line-height: 1.45;
          word-break: break-word;
        }

        .msg-bot {
          background: #fff;
          color: var(--texto);
          border: 1px solid #e2e8ee;
          border-radius: 4px 16px 16px 16px;
          box-shadow: 0 1px 3px rgba(0, 0, 0, .05);
        }

        .msg-user {
          background: linear-gradient(135deg, var(--azul), var(--azul-med));
          color: #fff;
          border-radius: 16px 4px 16px 16px;
        }

        .msg-time {
          font-size: 9px;
          color: #94a3b8;
          margin-top: 4px;
          margin-left: 6px;
          margin-right: 6px;
        }

        .msg-typing {
          background: #fff;
          border: 1px solid #e2e8ee;
          border-radius: 4px 16px 16px 16px;
          padding: 12px 16px;
          display: inline-flex;
          gap: 4px;
        }

        .typing-dot {
          width: 7px;
          height: 7px;
          background: var(--oro);
          border-radius: 50%;
          animation: typing .9s infinite;
        }

        .typing-dot:nth-child(2) {
          animation-delay: .18s
        }

        .typing-dot:nth-child(3) {
          animation-delay: .36s
        }

        @keyframes typing {

          0%,
          60%,
          100% {
            transform: translateY(0)
          }

          30% {
            transform: translateY(-6px)
          }
        }

        /* Preguntas rápidas - estilo mejorado */
        .chat-chips {
          padding: 12px;
          display: flex;
          flex-wrap: wrap;
          gap: 8px;
          background: #fff;
          border-top: 1px solid #eef2f6;
          max-height: 140px;
          overflow-y: auto;
        }

        .chip {
          background: #f1f5f9;
          border: none;
          color: var(--azul);
          font-size: 11px;
          padding: 6px 12px;
          border-radius: 20px;
          cursor: pointer;
          transition: all .2s;
          font-weight: 500;
          white-space: nowrap;
          display: inline-flex;
          align-items: center;
          gap: 5px;
        }

        .chip:hover {
          background: var(--oro);
          color: #0b2346;
          transform: translateY(-1px);
          box-shadow: 0 2px 6px rgba(200, 168, 75, .3);
        }

        .chip i {
          font-size: 11px;
        }

        .chat-input-row {
          display: flex;
          gap: 8px;
          padding: 12px;
          border-top: 1px solid #eef2f6;
          background: #fff;
        }

        #chat-input {
          flex: 1;
          padding: 10px 14px;
          border: 1.5px solid #e2e8f0;
          border-radius: 24px;
          font-family: 'DM Sans', sans-serif;
          font-size: 13px;
          outline: none;
          transition: all .2s;
        }

        #chat-input:focus {
          border-color: var(--oro);
          box-shadow: 0 0 0 2px rgba(200, 168, 75, .2);
        }

        #chat-send {
          background: var(--oro);
          border: none;
          border-radius: 50%;
          width: 38px;
          height: 38px;
          cursor: pointer;
          display: flex;
          align-items: center;
          justify-content: center;
          transition: all .2s;
        }

        #chat-send:hover {
          background: #b8943e;
          transform: scale(1.05);
        }

        #chat-send i {
          color: var(--azul);
          font-size: 14px;
        }

        /* Animaciones robot SVG */
        @keyframes robot-float {

          0%,
          100% {
            transform: translateY(0)
          }

          50% {
            transform: translateY(-8px)
          }
        }

        @keyframes robot-wave {

          0%,
          100% {
            transform: rotate(0deg)
          }

          15% {
            transform: rotate(22deg)
          }

          30% {
            transform: rotate(-6deg)
          }

          50% {
            transform: rotate(18deg)
          }

          70% {
            transform: rotate(-4deg)
          }

          85% {
            transform: rotate(12deg)
          }
        }

        @keyframes robot-blink {

          0%,
          88%,
          100% {
            transform: scaleY(1)
          }

          92%,
          96% {
            transform: scaleY(0.07)
          }
        }

        @keyframes ant-pulse {

          0%,
          100% {
            opacity: 1;
            r: 4px
          }

          50% {
            opacity: .55;
            r: 7px
          }
        }

        @keyframes scan-move {
          0% {
            transform: translateY(0)
          }

          100% {
            transform: translateY(50px)
          }
        }

        .rb-all {
          animation: robot-float 3.4s ease-in-out infinite;
          transform-origin: 55px 75px;
        }

        .rb-arm {
          animation: robot-wave 2.3s ease-in-out infinite;
          transform-origin: 22px 55px;
        }

        .rb-el {
          animation: robot-blink 5s ease-in-out infinite;
          transform-origin: 38px 40px;
        }

        .rb-er {
          animation: robot-blink 5s ease-in-out .2s infinite;
          transform-origin: 60px 40px;
        }

        .rb-ant {
          animation: ant-pulse 1.7s ease-in-out infinite;
        }

        .rb-scan {
          animation: scan-move 2s linear infinite;
        }

        @media print {

          .top-bar,
          .hero,
          .acciones,
          .footer,
          form,
          .alert,
          .correo-status,
          .sin-mesa,
          #chatbot-container,
          #chat-window,
          .banda-gov {
            display: none !important;
          }

          body {
            background: white !important;
          }

          .main {
            margin: 0 !important;
            padding: 0 !important;
            max-width: 100% !important;
          }

          .card {
            box-shadow: none !important;
            border-radius: 0 !important;
          }

          .res-header {
            -webkit-print-color-adjust: exact;
            print-color-adjust: exact;
          }

          .mesa-highlight {
            -webkit-print-color-adjust: exact;
            print-color-adjust: exact;
          }
        }

        @media (max-width:560px) {
          .datos-grid {
            grid-template-columns: 1fr;
          }

          .dato-cell {
            border-right: none;
          }

          .dato-cell:nth-last-child(-n+2) {
            border-bottom: 1px solid var(--borde);
          }

          .dato-cell:last-child {
            border-bottom: none;
          }

          .hero {
            padding: 40px 20px 72px;
          }

          .top-bar {
            padding: 10px 20px;
          }

          .main {
            margin-top: -24px;
          }

          #chat-window {
            width: calc(100vw - 20px);
            right: 10px;
            bottom: 10px;
            left: auto;
          }

          #chatbot-container {
            right: 12px;
            bottom: 12px;
          }

          .chip {
            white-space: normal;
            font-size: 10px;
          }

          .sin-mesa {
            padding: 32px 20px;
          }

          .sin-mesa-buttons {
            flex-direction: column;
            align-items: center;
          }

          .btn-volver {
            width: 100%;
            justify-content: center;
          }
        }
      </style>
    </head>

    <body>

      <div class="banda-gov"></div>

      <div class="top-bar">
        <div class="top-bar-brand">
          <div class="escudo"><i class="fas fa-landmark"></i></div>
          <span>Registradur&#237;a Municipal de Nobsa &mdash; Boyac&#225;</span>
        </div>
        <div style="display:flex;align-items:center;gap:10px;">
          <a href="${pageContext.request.contextPath}/solicitud" class="btn-admin"
            style="color:#c8a84b;text-decoration:none;font-size:12px;font-weight:600;padding:7px 16px;border:1.5px solid rgba(200,168,75,.5);border-radius:20px;display:inline-flex;align-items:center;gap:6px;transition:all .2s;">
            <i class="fas fa-paper-plane"></i> Enviar solicitud
          </a>
          <a href="${pageContext.request.contextPath}/index.jsp"
            style="color:#fff;text-decoration:none;font-size:12px;font-weight:600;padding:7px 16px;border:1.5px solid rgba(255,255,255,.35);border-radius:20px;display:inline-flex;align-items:center;gap:6px;transition:all .2s;background:rgba(255,255,255,.08);">
            <i class="fas fa-arrow-left"></i> Inicio
          </a>
        </div>
      </div>

      <div class="hero">
        <div class="hero-tag"><i class="fas fa-vote-yea"></i> Elecciones 2026</div>
        <h1>Consulta tu <span>Mesa</span><br>de Votaci&#243;n</h1>
        <p>Ingresa tu n&#250;mero de documento y conoce tu puesto, zona y mesa asignada.</p>
      </div>

      <div class="main">

        <c:if test="${not empty error}">
          <div class="alert alert-error">
            <i class="fas fa-circle-exclamation"></i>
            <span>${error}</span>
          </div>
        </c:if>

        <c:if test="${empty resultado}">
          <div class="card form-card">
            <label class="form-label" for="numeroDocumento">
              <i class="fas fa-id-card" style="color:var(--azul-suave);margin-right:5px;"></i>
              N&#250;mero de documento
            </label>
            <form action="${pageContext.request.contextPath}/consultaMesa" method="post">
              <div class="input-wrap" style="margin-bottom:16px;">
                <i class="fas fa-id-card"></i>
                <input class="input-doc" type="text" id="numeroDocumento" name="numeroDocumento"
                  value="${documentoBuscado}" placeholder="Ej: 1000000001" required autocomplete="off" />
              </div>
              <p class="form-hint" style="margin-bottom:20px;">
                <i class="fas fa-lock" style="color:var(--oro);margin-right:4px;"></i>
                Tu informaci&#243;n es tratada de forma segura y confidencial.
              </p>
              <div class="recaptcha-wrap">
                <div class="g-recaptcha" data-sitekey="6LezKbssAAAAAPstG5OjqTLI-BZvU4cZQydrApDm"></div>
              </div>
              <button type="submit" class="btn-consultar">
                <i class="fas fa-magnifying-glass"></i> Consultar mi mesa
              </button>
            </form>
          </div>
        </c:if>

        <c:if test="${not empty resultado and resultado.numeroMesa != null}">
          <div class="card">
            <div class="res-header">
              <div class="res-avatar"><i class="fas fa-user"></i></div>
              <div class="res-header-info">
                <small>Ciudadano registrado</small>
                <div class="res-nombre">${resultado.nombres} ${resultado.apellidos}</div>
              </div>
            </div>
            <div class="datos-grid">
              <div class="dato-cell">
                <div class="dato-icon-label"><i class="fas fa-id-card"></i> Documento</div>
                <div class="dato-val">${resultado.numeroDocumento}</div>
              </div>
              <div class="dato-cell">
                <div class="dato-icon-label"><i class="fas fa-city"></i> Ciudad</div>
                <div class="dato-val">${resultado.ciudadNombre}</div>
              </div>
              <div class="dato-cell">
                <div class="dato-icon-label"><i class="fas fa-layer-group"></i> Zona</div>
                <div class="dato-val">${resultado.nombreZona}</div>
              </div>
              <div class="dato-cell">
                <div class="dato-icon-label"><i class="fas fa-building"></i> Puesto</div>
                <div class="dato-val">${resultado.puestoVotacion}</div>
              </div>
              <div class="dato-cell full">
                <div class="dato-icon-label"><i class="fas fa-location-dot"></i> Direcci&#243;n del puesto</div>
                <div class="dato-val">${resultado.direccionZona}</div>
              </div>
            </div>
            <div class="mesa-highlight">
              <div class="mesa-label-txt"><i class="fas fa-chair"></i><span>Tu mesa de votaci&#243;n asignada</span>
              </div>
              <div class="mesa-numero">Mesa ${resultado.numeroMesa}</div>
            </div>
            <div class="correo-status">
              <c:choose>
                <c:when test="${not empty mensajeCorreo}">
                  <div class="alert alert-ok" style="margin:0;"><i
                      class="fas fa-circle-check"></i><span>${mensajeCorreo}</span></div>
                </c:when>
                <c:when test="${not empty errorCorreo}">
                  <div class="alert alert-error" style="margin:0;"><i
                      class="fas fa-triangle-exclamation"></i><span>${errorCorreo}</span></div>
                </c:when>
                <c:when test="${sinCorreoRegistrado}">
                  <div class="alert alert-warn" style="margin:0;"><i
                      class="fas fa-envelope-open-text"></i><span><strong>Sin correo registrado.</strong> Acude a la
                      Registradur&#237;a para actualizar tus datos de contacto.</span></div>
                </c:when>
              </c:choose>
            </div>
            <div class="acciones">
              <a href="${pageContext.request.contextPath}/consultaMesa" class="btn-accion btn-nueva"><i
                  class="fas fa-rotate-left"></i> Nueva consulta</a>
              <button onclick="window.print()" class="btn-accion btn-imprimir has_saved">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"
                  stroke-linejoin="round">
                  <path data-path="box" d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" />
                  <path data-path="line-top" d="M7 10 L12 15 L17 10" />
                  <path data-path="line-bottom" d="M12 15 L12 3" />
                </svg>
                Imprimir
              </button>
            </div>
          </div>
        </c:if>

        <c:if test="${not empty resultado and resultado.numeroMesa == null}">
          <div class="sin-mesa">
            <div class="sin-mesa-icono"><i class="fas fa-building-circle-xmark"></i></div>
            <h2>Sin mesa asignada</h2>
            <p>Estimado(a) <strong>${resultado.nombres} ${resultado.apellidos}</strong>,<br>actualmente no tienes una
              mesa de votaci&#243;n asignada en nuestro sistema.</p>
            <div class="sin-mesa-info">
              <p><i class="fas fa-phone-alt"></i> Ll&#225;manos: (608) 770 0000</p>
              <p><i class="fas fa-envelope"></i> registraduria@nobsa-boyaca.gov.co</p>
              <p><i class="fas fa-clock"></i> Lunes a Viernes, 8:00 AM &ndash; 4:00 PM</p>
            </div>
            <div class="sin-mesa-buttons">
              <a href="${pageContext.request.contextPath}/consultaMesa" class="btn-volver"><i
                  class="fas fa-arrow-left"></i> Realizar nueva consulta</a>
              <a href="${pageContext.request.contextPath}/solicitud" class="btn-volver btn-solicitud"><i
                  class="fas fa-paper-plane"></i> Enviar solicitud</a>
            </div>
          </div>
        </c:if>

      </div>

      <div class="footer">
        Registradur&#237;a Municipal de Nobsa &middot; <span>Boyac&#225;, Colombia</span> &middot; 2026
      </div>

      <!-- ════════════════════════════════════════════════
     CHATBOT: Robot flotante mejorado
════════════════════════════════════════════════ -->
      <div id="chatbot-container">

        <!-- Burbuja de diálogo encima del robot -->
        <div id="robot-bubble" onclick="toggleChat()">
          <button id="bubble-close" onclick="event.stopPropagation();closeBubble()" title="Cerrar">&#x2715;</button>
          <i class="fas fa-robot" style="color:#c8a84b; margin-right:4px;"></i>
          ¿Tienes dudas?<br>Estoy aquí para ayudarte
        </div>

        <!-- Robot SVG completo, clickeable -->
        <div style="position:relative;display:inline-block;">
          <span id="chat-notif">3</span>
          <svg id="robot-trigger" onclick="toggleChat()" viewBox="0 0 110 140" fill="none"
            xmlns="http://www.w3.org/2000/svg">
            <defs>
              <radialGradient id="rHG" cx="38%" cy="32%" r="65%">
                <stop offset="0%" stop-color="#f8fbff" />
                <stop offset="55%" stop-color="#dde8f4" />
                <stop offset="100%" stop-color="#aec4da" />
              </radialGradient>
              <radialGradient id="rBG" cx="38%" cy="28%" r="68%">
                <stop offset="0%" stop-color="#eef4fc" />
                <stop offset="60%" stop-color="#cddaea" />
                <stop offset="100%" stop-color="#9ab4cc" />
              </radialGradient>
              <radialGradient id="rEG" cx="32%" cy="28%" r="68%">
                <stop offset="0%" stop-color="#a8eaff" />
                <stop offset="45%" stop-color="#1e90ff" />
                <stop offset="100%" stop-color="#003fa8" />
              </radialGradient>
              <radialGradient id="rGD" cx="35%" cy="28%" r="68%">
                <stop offset="0%" stop-color="#fff5a0" />
                <stop offset="55%" stop-color="#f5c842" />
                <stop offset="100%" stop-color="#b87800" />
              </radialGradient>
              <radialGradient id="rLG" cx="30%" cy="25%" r="72%">
                <stop offset="0%" stop-color="#eaf2fc" />
                <stop offset="100%" stop-color="#a0bcd4" />
              </radialGradient>
              <radialGradient id="rST" cx="50%" cy="0%" r="100%">
                <stop offset="0%" stop-color="#3d9aff" />
                <stop offset="100%" stop-color="#0a4aaa" />
              </radialGradient>
              <filter id="rSD">
                <feDropShadow dx="0" dy="3" stdDeviation="4" flood-color="#0b1e3c" flood-opacity="0.2" />
              </filter>
              <filter id="rEF">
                <feGaussianBlur stdDeviation="2.5" result="b" />
                <feMerge>
                  <feMergeNode in="b" />
                  <feMergeNode in="SourceGraphic" />
                </feMerge>
              </filter>
            </defs>

            <g class="rb-all">
              <!-- Antena -->
              <rect x="53" y="12" width="5" height="20" rx="2.5" fill="#b8ccd8" />
              <circle cx="55" cy="11" r="8" fill="url(#rGD)" filter="url(#rSD)" />
              <circle cx="55" cy="11" r="4.5" fill="#fff8c0" opacity=".88" class="rb-ant" />
              <circle cx="52" cy="8" r="2" fill="#fff" opacity=".7" />

              <!-- Cabeza grande redondeada -->
              <ellipse cx="55" cy="46" rx="34" ry="32" fill="url(#rHG)" filter="url(#rSD)" />
              <ellipse cx="44" cy="30" rx="16" ry="9" fill="#fff" opacity=".35" />

              <!-- Orejas -->
              <ellipse cx="22" cy="48" rx="6" ry="10" fill="url(#rLG)" stroke="#b0c8e0" stroke-width=".8" />
              <ellipse cx="22" cy="48" rx="3" ry="6" fill="#90aac4" />
              <ellipse cx="88" cy="48" rx="6" ry="10" fill="url(#rLG)" stroke="#b0c8e0" stroke-width=".8" />
              <ellipse cx="88" cy="48" rx="3" ry="6" fill="#90aac4" />

              <!-- Ojos -->
              <circle cx="42" cy="48" r="12" fill="#0a1828" />
              <circle cx="42" cy="48" r="9.5" fill="url(#rEG)" filter="url(#rEF)" class="rb-el" />
              <circle cx="42" cy="48" r="4" fill="#002580" opacity=".5" />
              <ellipse cx="37" cy="43" rx="3.2" ry="2.8" fill="#fff" opacity=".92" />
              <circle cx="47" cy="53" r="1.5" fill="#cceeff" opacity=".6" />

              <circle cx="68" cy="48" r="12" fill="#0a1828" />
              <circle cx="68" cy="48" r="9.5" fill="url(#rEG)" filter="url(#rEF)" class="rb-er" />
              <circle cx="68" cy="48" r="4" fill="#002580" opacity=".5" />
              <ellipse cx="63" cy="43" rx="3.2" ry="2.8" fill="#fff" opacity=".92" />
              <circle cx="73" cy="53" r="1.5" fill="#cceeff" opacity=".6" />

              <!-- Nariz -->
              <ellipse cx="55" cy="61" rx="3" ry="2" fill="#a0b8cc" />

              <!-- Boca sonriente -->
              <path d="M44 66 Q55 75 66 66" stroke="#7090aa" stroke-width="2.2" fill="none" stroke-linecap="round" />
              <rect x="48" y="67" width="14" height="5" rx="2.5" fill="#fff" opacity=".68" />

              <!-- Cuello -->
              <rect x="47" y="76" width="16" height="9" rx="4.5" fill="#b0c4d8" />
              <rect x="50" y="78" width="10" height="5" rx="2.5" fill="#98b0c8" />

              <!-- Cuerpo -->
              <rect x="30" y="84" width="50" height="42" rx="12" fill="url(#rBG)" filter="url(#rSD)" />
              <ellipse cx="55" cy="89" rx="20" ry="5" fill="#fff" opacity=".38" />

              <!-- Panel pecho -->
              <rect x="36" y="90" width="38" height="30" rx="6" fill="#07152e" />
              <rect x="38" y="92" width="5" height="25" rx="2.5" fill="url(#rST)" />
              <rect x="45" y="92" width="5" height="25" rx="2.5" fill="url(#rST)" />
              <rect x="52" y="92" width="5" height="25" rx="2.5" fill="url(#rST)" />
              <rect x="59" y="92" width="5" height="25" rx="2.5" fill="url(#rST)" />
              <rect x="66" y="92" width="5" height="25" rx="2.5" fill="url(#rST)" />
              <rect x="36" y="92" width="38" height="3" rx="1.5" fill="#7dd8ff" opacity=".45" class="rb-scan" />

              <!-- Brazo izquierdo levantado -->
              <g class="rb-arm">
                <ellipse cx="23" cy="90" rx="7" ry="16" fill="url(#rLG)" stroke="#b0c8e0" stroke-width=".8"
                  transform="rotate(-40 23 90)" />
                <ellipse cx="12" cy="75" rx="6" ry="13" fill="url(#rLG)" stroke="#b0c8e0" stroke-width=".8"
                  transform="rotate(-18 12 75)" />
                <ellipse cx="7" cy="61" rx="7" ry="6" fill="#c8daea" transform="rotate(-10 7 61)" />
                <rect x="1" y="50" width="4" height="12" rx="2" fill="#c0d2e6" transform="rotate(-28 3 56)" />
                <rect x="6" y="47" width="4" height="13" rx="2" fill="#c8daf0" transform="rotate(-15 8 54)" />
                <rect x="11" y="46" width="4" height="13" rx="2" fill="#c8daf0" transform="rotate(-3 13 52)" />
                <rect x="15" y="47" width="4" height="12" rx="2" fill="#c0d2e6" transform="rotate(10 17 53)" />
                <rect x="-2" y="57" width="4" height="10" rx="2" fill="#b8cce0" transform="rotate(-42 0 62)" />
              </g>

              <!-- Brazo derecho -->
              <ellipse cx="87" cy="96" rx="7" ry="18" fill="url(#rLG)" stroke="#b0c8e0" stroke-width=".8" />
              <ellipse cx="87" cy="115" rx="7" ry="5" fill="#c0d4e8" />

              <!-- Piernas -->
              <rect x="37" y="124" width="14" height="20" rx="7" fill="url(#rLG)" stroke="#b0c8e0" stroke-width=".8" />
              <rect x="59" y="124" width="14" height="20" rx="7" fill="url(#rLG)" stroke="#b0c8e0" stroke-width=".8" />
              <ellipse cx="44" cy="144" rx="12" ry="6" fill="#b8cce0" stroke="#a0b8d0" stroke-width=".8" />
              <ellipse cx="66" cy="144" rx="12" ry="6" fill="#b8cce0" stroke="#a0b8d0" stroke-width=".8" />
              <ellipse cx="40" cy="142" rx="5" ry="2.5" fill="#fff" opacity=".32" />
              <ellipse cx="62" cy="142" rx="5" ry="2.5" fill="#fff" opacity=".32" />
            </g>
          </svg>
        </div>
      </div>

      <!-- Ventana del chat mejorada -->
      <div id="chat-window">
        <div class="chat-header">
          <svg class="chat-avatar-svg" viewBox="0 0 52 64" fill="none" xmlns="http://www.w3.org/2000/svg">
            <defs>
              <radialGradient id="aHG" cx="38%" cy="32%" r="65%">
                <stop offset="0%" stop-color="#f8fbff" />
                <stop offset="100%" stop-color="#bfcfe0" />
              </radialGradient>
              <radialGradient id="aEG" cx="32%" cy="28%" r="68%">
                <stop offset="0%" stop-color="#a8eaff" />
                <stop offset="45%" stop-color="#1e90ff" />
                <stop offset="100%" stop-color="#003fa8" />
              </radialGradient>
              <radialGradient id="aGD" cx="35%" cy="28%" r="68%">
                <stop offset="0%" stop-color="#fff5a0" />
                <stop offset="100%" stop-color="#b87800" />
              </radialGradient>
              <radialGradient id="aLG" cx="30%" cy="25%" r="72%">
                <stop offset="0%" stop-color="#eaf2fc" />
                <stop offset="100%" stop-color="#a0bcd4" />
              </radialGradient>
              <radialGradient id="aST" cx="50%" cy="0%" r="100%">
                <stop offset="0%" stop-color="#3d9aff" />
                <stop offset="100%" stop-color="#0a4aaa" />
              </radialGradient>
              <filter id="aEF">
                <feGaussianBlur stdDeviation="1.5" result="b" />
                <feMerge>
                  <feMergeNode in="b" />
                  <feMergeNode in="SourceGraphic" />
                </feMerge>
              </filter>
            </defs>
            <g class="rb-all">
              <rect x="24" y="2" width="4" height="10" rx="2" fill="#8aaac0" />
              <circle cx="26" cy="2" r="5" fill="url(#aGD)" />
              <circle cx="26" cy="2" r="2.5" fill="#fff8c0" opacity=".85" class="rb-ant" />
              <ellipse cx="26" cy="18" rx="16" ry="15" fill="url(#aHG)" />
              <ellipse cx="19" cy="11" rx="8" ry="4" fill="#fff" opacity=".32" />
              <ellipse cx="11" cy="19" rx="3" ry="5" fill="url(#aLG)" stroke="#b0c8e0" stroke-width=".7" />
              <ellipse cx="41" cy="19" rx="3" ry="5" fill="url(#aLG)" stroke="#b0c8e0" stroke-width=".7" />
              <circle cx="19" cy="19" r="6" fill="#0a1828" />
              <circle cx="19" cy="19" r="4.8" fill="url(#aEG)" filter="url(#aEF)" class="rb-el" />
              <ellipse cx="16.5" cy="16.5" rx="1.8" ry="1.5" fill="#fff" opacity=".9" />
              <circle cx="33" cy="19" r="6" fill="#0a1828" />
              <circle cx="33" cy="19" r="4.8" fill="url(#aEG)" filter="url(#aEF)" class="rb-er" />
              <ellipse cx="30.5" cy="16.5" rx="1.8" ry="1.5" fill="#fff" opacity=".9" />
              <path d="M20 28 Q26 33 32 28" stroke="#6080a0" stroke-width="1.6" fill="none" stroke-linecap="round" />
              <rect x="22" y="29" width="8" height="3.5" rx="1.75" fill="#fff" opacity=".6" />
              <rect x="19" y="34" width="3.5" height="7" rx="1.75" fill="#8aaac0" />
              <rect x="29.5" y="34" width="3.5" height="7" rx="1.75" fill="#8aaac0" />
              <rect x="13" y="40" width="26" height="19" rx="7" fill="url(#aLG)" />
              <rect x="16" y="42" width="20" height="13" rx="4" fill="#07152e" />
              <rect x="17.5" y="43.5" width="3.2" height="9" rx="1.6" fill="url(#aST)" />
              <rect x="22" y="43.5" width="3.2" height="9" rx="1.6" fill="url(#aST)" />
              <rect x="26.5" y="43.5" width="3.2" height="9" rx="1.6" fill="url(#aST)" />
              <rect x="31" y="43.5" width="3.2" height="9" rx="1.6" fill="url(#aST)" />
              <g class="rb-arm">
                <ellipse cx="7" cy="46" rx="4" ry="10" fill="url(#aLG)" stroke="#b0c8e0" stroke-width=".7"
                  transform="rotate(-36 7 46)" />
                <ellipse cx="2" cy="36" rx="3.5" ry="8" fill="url(#aLG)" transform="rotate(-18 2 36)" />
                <ellipse cx="0" cy="28" rx="4" ry="3.5" fill="#c8daea" transform="rotate(-10 0 28)" />
                <rect x="-5" y="20" width="3" height="9" rx="1.5" fill="#b8cce0" transform="rotate(-28 -3 25)" />
                <rect x="-1" y="18" width="3" height="9.5" rx="1.5" fill="#c0d2e6" transform="rotate(-15 1 23)" />
                <rect x="3" y="17" width="3" height="9.5" rx="1.5" fill="#c0d2e6" transform="rotate(-3  5 22)" />
                <rect x="7" y="18" width="3" height="9" rx="1.5" fill="#b8cce0" transform="rotate(10  8 23)" />
              </g>
              <ellipse cx="46" cy="49" rx="4" ry="10" fill="url(#aLG)" stroke="#b0c8e0" stroke-width=".7" />
              <rect x="17" y="59" width="8" height="4" rx="2" fill="#a0bcd0" />
              <rect x="27" y="59" width="8" height="4" rx="2" fill="#a0bcd0" />
            </g>
          </svg>
          <div class="chat-header-info">
            <div class="chat-header-name">Asistente Registraduría</div>
            <div class="chat-header-status"><span class="status-dot"></span> En línea · Nobsa, Boyacá</div>
          </div>
          <button id="chat-close" onclick="toggleChat()">&#x2715;</button>
        </div>

        <div class="chat-messages" id="chat-messages"></div>

        <!-- Preguntas rápidas con íconos -->
        <div class="chat-chips" id="chat-chips">
          <span class="chip" onclick="askChip(this)"><i class="fas fa-search"></i> ¿Cómo consulto mi mesa?</span>
          <span class="chip" onclick="askChip(this)"><i class="fas fa-id-card"></i> ¿Qué documento necesito?</span>
          <span class="chip" onclick="askChip(this)"><i class="fas fa-map-pin"></i> ¿Dónde es mi puesto?</span>
          <span class="chip" onclick="askChip(this)"><i class="fas fa-envelope"></i> ¿Por qué me llega un correo?</span>
          <span class="chip" onclick="askChip(this)"><i class="fas fa-clock"></i> Horarios de atención</span>
          <span class="chip" onclick="askChip(this)"><i class="fas fa-user-slash"></i> No aparezco en el sistema</span>
          <span class="chip" onclick="askChip(this)"><i class="fas fa-shield-alt"></i> ¿Es segura mi información?</span>
          <span class="chip" onclick="askChip(this)"><i class="fas fa-file-pdf"></i> ¿Qué es el PDF del
            comprobante?</span>
          <span class="chip" onclick="askChip(this)"><i class="fas fa-layer-group"></i> ¿Qué es una zona de
            votación?</span>
          <span class="chip" onclick="askChip(this)"><i class="fas fa-building"></i> ¿Dónde está la
            Registraduría?</span>
          <span class="chip" onclick="askChip(this)"><i class="fas fa-exchange-alt"></i> ¿Puedo cambiar mi mesa?</span>
          <span class="chip" onclick="askChip(this)"><i class="fas fa-phone-alt"></i> ¿Cómo contactarlos?</span>
        </div>

        <div class="chat-input-row">
          <input type="text" id="chat-input" placeholder="Escribe tu pregunta..."
            onkeydown="if(event.key==='Enter')sendMessage()" />
          <button id="chat-send" onclick="sendMessage()"><i class="fas fa-paper-plane"></i></button>
        </div>
      </div>

      <script>
        const CONTEXT_PATH = '${pageContext.request.contextPath}';

        const KB = [
          {
            keys: ['consultar', 'mesa', 'c\u00f3mo', 'buscar', 'encontrar', 'ver'],
            answer: '&#128203; <strong>Para consultar tu mesa es muy f\u00e1cil:</strong><br><br>1\uFE0F\u20E3 Escribe tu <strong>n\u00famero de c\u00e9dula</strong> en el campo de b\u00fasqueda.<br>2\uFE0F\u20E3 Completa el captcha de seguridad.<br>3\uFE0F\u20E3 Haz clic en <strong>"Consultar mi mesa"</strong>.<br><br>Ver\u00e1s tu <strong>zona, puesto y n\u00famero de mesa</strong>. \u00a1Tambi\u00e9n te enviaremos el comprobante a tu correo!'
          },
          {
            keys: ['documento', 'necesito', 'llevar', 'presentar', 'c\u00e9dula', 'tarjeta', 'votar'],
            answer: '&#128266; <strong>Documentos para votar:</strong><br><br>\u2705 <strong>C\u00e9dula de Ciudadan\u00eda</strong> vigente (mayores de 18 a\u00f1os).<br>\u2705 <strong>Tarjeta de Identidad</strong> (j\u00f3venes entre 14 y 17 a\u00f1os).<br><br>\u26A0\uFE0F Solo se acepta el <strong>documento original</strong>, no copias.<br><br>Recuerda llegar con tiempo suficiente a tu puesto de votaci\u00f3n.'
          },
          {
            keys: ['puesto', 'd\u00f3nde', 'ubicaci\u00f3n', 'lugar', 'direcci\u00f3n', 'llegar', 'mapa'],
            answer: '&#128508; <strong>Tu puesto de votaci\u00f3n</strong> aparece en el resultado de la consulta con:<br><br>&#128205; <strong>Nombre del puesto</strong> (instituci\u00f3n educativa o lugar)<br>&#128205; <strong>Direcci\u00f3n exacta</strong><br>&#128205; <strong>Zona y n\u00famero de mesa</strong><br><br>&#128222; Dudas: <strong>(608) 770 0000</strong><br>&#128231; registraduria@nobsa-boyaca.gov.co'
          },
          {
            keys: ['correo', 'email', 'pdf', 'llega', 'envia', 'enviaron', 'recibi'],
            answer: '&#128140; <strong>\u00bfPor qu\u00e9 recibes un correo?</strong><br><br>Al consultar, el sistema genera <strong>autom\u00e1ticamente</strong> un comprobante PDF y lo env\u00eda a tu correo registrado.<br><br>&#128196; El PDF contiene:<br>\u2022 Tu nombre y documento<br>\u2022 Zona y puesto de votaci\u00f3n<br>\u2022 N\u00famero de mesa<br><br>&#128273; La <strong>clave del PDF</strong> es tu n\u00famero de documento.'
          },
          {
            keys: ['horario', 'horarios', 'atenci\u00f3n', 'abierto', 'cerrado', 'hora', 'oficina'],
            answer: '&#8987; <strong>Horarios de atenci\u00f3n:</strong><br><br>&#128197; <strong>Lunes a Viernes</strong><br>&#8987; 8:00 AM \u2013 4:00 PM<br><br>&#128222; <strong>Tel\u00e9fono:</strong> (608) 770 0000<br>&#128231; registraduria@nobsa-boyaca.gov.co<br><br>\u26A0\uFE0F D\u00edas de elecciones: horario extendido seg\u00fan normativa nacional.'
          },
          {
            keys: ['no aparece', 'no encuentro', 'no me encuentra', 'no sale', 'problema', 'error', 'falla'],
            answer: '&#10060; <strong>\u00bfNo apareces en el sistema?</strong><br><br>Esto puede ocurrir porque:<br><br>&#128269; <strong>Verifica que:</strong><br>\u2022 Tu n\u00famero de documento sea correcto (sin puntos ni espacios)<br>\u2022 Est\u00e9s inscrito en Nobsa, Boyac\u00e1<br>\u2022 Tu c\u00e9dula est\u00e9 vigente<br><br>&#128222; Si el problema persiste:<br><strong>(608) 770 0000</strong><br>&#128231; registraduria@nobsa-boyaca.gov.co'
          },
          {
            keys: ['segura', 'seguro', 'informaci\u00f3n', 'privacidad', 'datos', 'protege'],
            answer: '&#128274; <strong>Tu informaci\u00f3n est\u00e1 completamente segura.</strong><br><br>\u2705 Cifrado <strong>HTTPS</strong><br>\u2705 Verificaci\u00f3n con <strong>reCAPTCHA</strong> de Google<br>\u2705 Solo lectura, <strong>no se modifican tus datos</strong><br>\u2705 Cumplimos con la <strong>Ley 1581</strong> de Protecci\u00f3n de Datos<br><br>Tu informaci\u00f3n electoral es confidencial.'
          },
          {
            keys: ['comprobante', 'imprimir', 'guardar', 'descargar', 'pdf'],
            answer: '&#128196; <strong>Comprobante de mesa:</strong><br><br>Despu\u00e9s de consultar puedes:<br><br>&#128438; <strong>Imprimir</strong> desde el bot\u00f3n "Imprimir" en la p\u00e1gina<br>&#128231; <strong>Recibir el PDF</strong> en tu correo autom\u00e1ticamente<br><br>&#128273; Si el PDF pide contrase\u00f1a, usa tu <strong>n\u00famero de documento</strong>.<br><br>Lleva el comprobante el d\u00eda de las elecciones.'
          },
          {
            keys: ['zona', 'votaci\u00f3n', 'significa', 'qu\u00e9 es', 'diferencia', 'concepto'],
            answer: '&#128379; <strong>\u00bfQu\u00e9 significan los t\u00e9rminos?</strong><br><br>&#127960;&#65039; <strong>Zona:</strong> Sector geogr\u00e1fico del municipio.<br>&#127979; <strong>Puesto:</strong> La instituci\u00f3n (colegio, alcald\u00eda, etc.).<br>&#128186; <strong>Mesa:</strong> La cabina espec\u00edfica dentro del puesto.<br><br>Ejemplo: <em>Zona Centro \u2192 Colegio Boyac\u00e1 \u2192 Mesa 5</em>'
          },
          {
            keys: ['registradur\u00eda', 'nobsa', 'd\u00f3nde queda', 'direcci\u00f3n', 'oficina', 'sede'],
            answer: '&#128205; <strong>Registradur\u00eda Municipal de Nobsa</strong><br><br>&#128204; Nobsa, Boyac\u00e1, Colombia<br>&#128222; (608) 770 0000<br>&#128231; registraduria@nobsa-boyaca.gov.co<br><br>&#8987; Lunes a Viernes, 8:00 AM \u2013 4:00 PM'
          },
          {
            keys: ['cambiar', 'trasladar', 'mover', 'inscribir', 'inscripci\u00f3n', 'otro municipio'],
            answer: '&#128260; <strong>\u00bfQuieres cambiar tu mesa o municipio?</strong><br><br>1\uFE0F\u20E3 Acude <strong>personalmente</strong> a la Registradur\u00eda<br>2\uFE0F\u20E3 Presenta tu <strong>c\u00e9dula de ciudadan\u00eda</strong><br>3\uFE0F\u20E3 Solicita el traslado en los <strong>per\u00edodos habilitados</strong><br><br>\u26A0\uFE0F Los traslados tienen fechas l\u00edmite.<br>&#128222; (608) 770 0000'
          },
          {
            keys: ['contactar', 'contacto', 'tel\u00e9fono', 'llamar', 'escribir', 'comunicar'],
            answer: '&#128222; <strong>Medios de contacto:</strong><br><br>&#128222; <strong>Tel\u00e9fono:</strong> (608) 770 0000<br>&#128231; <strong>Correo:</strong> registraduria@nobsa-boyaca.gov.co<br>&#128337; <strong>Atenci\u00f3n:</strong> Lunes a Viernes, 8AM \u2013 4PM<br><br>Tambi\u00e9n puedes visitarnos en <strong>Nobsa, Boyac\u00e1</strong>.'
          },
          {
            keys: ['hola', 'buenos', 'buenas', 'saludos', 'hey'],
            answer: '&#128075; \u00a1Hola! Bienvenido(a) al asistente de la <strong>Registradur\u00eda de Nobsa</strong>.<br><br>Puedo ayudarte con:<br>\u2022 &#128379; Consulta de mesa de votaci\u00f3n<br>\u2022 &#128266; Documentos para votar<br>\u2022 &#128205; Ubicaci\u00f3n de puestos<br>\u2022 &#128140; Comprobantes y correos<br>\u2022 &#8987; Horarios y contacto<br><br>\u00bfEn qu\u00e9 te ayudo hoy?'
          },
          {
            keys: ['gracias', 'ok', 'listo', 'perfecto', 'excelente', 'bien'],
            answer: '&#128522; \u00a1Con mucho gusto! Recuerda el d\u00eda de elecciones llevar tu <strong>documento original</strong> y el comprobante de mesa. \u00bfHay algo m\u00e1s en lo que pueda ayudarte?'
          },
          {
            keys: ['elecciones', 'cuando', 'fecha', 'd\u00eda', '2026'],
            answer: '&#128197; <strong>Elecciones 2026</strong><br><br>Las fechas oficiales las define la <strong>Registradur\u00eda Nacional</strong>.<br><br>&#127760; M\u00e1s informaci\u00f3n en: <a href="https://www.registraduria.gov.co" target="_blank" style="color:#1e6fd4">www.registraduria.gov.co</a><br>&#128222; (608) 770 0000'
          }
        ];

        function findAnswer(text) {
          const lower = text.toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '');
          for (const e of KB) {
            const keys = e.keys.map(k => k.normalize('NFD').replace(/[\u0300-\u036f]/g, ''));
            if (keys.some(k => lower.includes(k))) return e.answer;
          }
          return '&#129300; No tengo respuesta exacta, pero puedo ayudarte con mesa, documentos y horarios.<br>&#128222; <strong>(608) 770 0000</strong><br>&#128231; registraduria@nobsa-boyaca.gov.co';
        }

        function nowTime() {
          return new Date().toLocaleTimeString('es-CO', { hour: '2-digit', minute: '2-digit' });
        }

        let chatOpen = false, welcomed = false;

        function toggleChat() {
          chatOpen = !chatOpen;
          document.getElementById('chat-window').classList.toggle('open', chatOpen);
          if (chatOpen && !welcomed) {
            welcomed = true;
            setTimeout(() => addMsg('bot', '&#128075; \u00a1Hola! Soy el asistente de la <strong>Registradur\u00eda de Nobsa</strong>. Puedo ayudarte con tu consulta de mesa, documentos para votar, horarios y m\u00e1s. \u00bfEn qu\u00e9 te ayudo?'), 350);
          }
          if (chatOpen) setTimeout(() => document.getElementById('chat-input').focus(), 400);
        }

        function closeBubble() {
          document.getElementById('robot-bubble').style.display = 'none';
        }

        function addMsg(who, html) {
          const wrap = document.createElement('div');
          wrap.className = 'msg-wrap ' + who;
          const el = document.createElement('div');
          el.className = 'msg msg-' + who;
          el.innerHTML = html;
          const t = document.createElement('div');
          t.className = 'msg-time';
          t.textContent = nowTime();
          wrap.appendChild(el);
          wrap.appendChild(t);
          const m = document.getElementById('chat-messages');
          m.appendChild(wrap);
          m.scrollTop = m.scrollHeight;
        }

        function showTyping() {
          const el = document.createElement('div');
          el.className = 'msg-typing'; el.id = 'typing-ind';
          el.innerHTML = '<span class="typing-dot"></span><span class="typing-dot"></span><span class="typing-dot"></span>';
          const m = document.getElementById('chat-messages');
          m.appendChild(el); m.scrollTop = m.scrollHeight;
        }
        function removeTyping() { const t = document.getElementById('typing-ind'); if (t) t.remove(); }

        function sendMessage() {
          const inp = document.getElementById('chat-input');
          const text = inp.value.trim();
          if (!text) return;
          addMsg('user', text);
          inp.value = '';
          showTyping();
          setTimeout(() => { removeTyping(); addMsg('bot', findAnswer(text)); }, 700 + Math.random() * 400);
        }

        function askChip(el) {
          const text = el.textContent.replace(/^[\u{1F000}-\u{1FFFF}\u{2600}-\u{27FF}\s]+/gu, '').trim();
          document.getElementById('chat-input').value = text;
          sendMessage();
        }
      </script>
    </body>

    </html>
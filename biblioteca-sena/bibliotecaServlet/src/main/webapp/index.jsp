<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Biblioteca SENA — Conocimiento sin Límites</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700;900&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Estilos.css">

        <style>
            /* ══════════════════════════════════════
               VARIABLES
            ══════════════════════════════════════ */
            :root {
                --azul-oscuro:   #0A1628;
                --azul-marino:   #0D2855;
                --azul-primario: #1565C0;
                --azul-medio:    #1976D2;
                --azul-claro:    #42A5F5;
                --dorado:        #FFD54F;
                --blanco:        #F8FBFF;
            }

            * {
                box-sizing: border-box;
            }

            html {
                scroll-behavior: smooth;
            }

            body {
                font-family: 'Lato', sans-serif;
                background: var(--azul-oscuro);
                color: var(--blanco);
                overflow-x: hidden;
                margin: 0;
                padding: 0;
            }

            /* ══════════════════════════════════════
               NAVBAR
            ══════════════════════════════════════ */
            .navbar-custom {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                z-index: 999;
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: .9rem 2.5rem;
                background: rgba(10,22,40,.85);
                backdrop-filter: blur(12px);
                -webkit-backdrop-filter: blur(12px);
                border-bottom: 1px solid rgba(66,165,245,.1);
                transition: background .3s;
            }
            .navbar-custom.scrolled {
                background: rgba(10,22,40,.97);
            }
            .navbar-brand-custom {
                font-family: 'Playfair Display', serif;
                color: var(--blanco);
                font-size: 1.18rem;
                font-weight: 700;
                text-decoration: none;
                display: flex;
                align-items: center;
                gap: .5rem;
            }
            .navbar-brand-custom i {
                color: var(--dorado);
                font-size: 1.3rem;
            }
            .btn-login-nav {
                background: linear-gradient(135deg, var(--azul-primario), var(--azul-claro));
                color: #fff;
                border-radius: 50px;
                padding: .48rem 1.3rem;
                font-size: .85rem;
                font-weight: 700;
                text-decoration: none;
                transition: all .2s;
                display: inline-flex;
                align-items: center;
                gap: .4rem;
            }
            .btn-login-nav:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 20px rgba(21,101,192,.45);
                color: #fff;
            }

            /* ══════════════════════════════════════
               HERO
            ══════════════════════════════════════ */
            .hero {
                min-height: 100vh;
                display: flex;
                align-items: center;
                position: relative;
                overflow: hidden;
                background:
                    radial-gradient(ellipse at 70% 50%, rgba(21,101,192,.35) 0%, transparent 70%),
                    radial-gradient(ellipse at 20% 80%, rgba(13,40,85,.6) 0%, transparent 60%),
                    var(--azul-oscuro);
                padding-top: 80px;
            }

            /* Partículas */
            .particles {
                position: absolute;
                inset: 0;
                pointer-events: none;
            }
            .particle {
                position: absolute;
                border-radius: 50%;
                background: var(--azul-claro);
                opacity: 0;
                animation: float-particle linear infinite;
            }
            @keyframes float-particle {
                0%   {
                    opacity:0;
                    transform:translateY(100vh) scale(0);
                }
                10%  {
                    opacity:.35;
                }
                90%  {
                    opacity:.15;
                }
                100% {
                    opacity:0;
                    transform:translateY(-20vh) scale(1);
                }
            }

            .hero-badge {
                display: inline-flex;
                align-items: center;
                gap: .5rem;
                background: rgba(66,165,245,.1);
                border: 1px solid rgba(66,165,245,.25);
                border-radius: 50px;
                padding: .4rem 1.1rem;
                font-size: .78rem;
                font-weight: 700;
                color: var(--azul-claro);
                letter-spacing: .5px;
                text-transform: uppercase;
                margin-bottom: 1.4rem;
            }
            .hero-title {
                font-family: 'Playfair Display', serif;
                font-size: clamp(2.6rem, 5vw, 4.2rem);
                font-weight: 900;
                color: var(--blanco);
                line-height: 1.08;
                margin-bottom: 1.3rem;
            }
            .hero-title span {
                color: var(--dorado);
            }

            .hero-desc {
                font-size: 1.05rem;
                color: rgba(248,251,255,.55);
                max-width: 480px;
                line-height: 1.7;
                margin-bottom: 2rem;
            }

            .hero-actions {
                display: flex;
                gap: 1rem;
                flex-wrap: wrap;
                margin-bottom: 2.5rem;
            }

            .btn-hero-primary {
                display: inline-flex;
                align-items: center;
                gap: .5rem;
                padding: .8rem 2rem;
                background: linear-gradient(135deg, var(--azul-primario), var(--azul-claro));
                border-radius: 50px;
                color: #fff;
                font-weight: 700;
                font-size: .95rem;
                text-decoration: none;
                transition: all .25s;
                box-shadow: 0 8px 24px rgba(21,101,192,.4);
            }
            .btn-hero-primary:hover {
                transform: translateY(-3px);
                box-shadow: 0 14px 32px rgba(21,101,192,.55);
                color: #fff;
            }
            .btn-hero-outline {
                display: inline-flex;
                align-items: center;
                gap: .5rem;
                padding: .8rem 2rem;
                border: 2px solid rgba(66,165,245,.38);
                border-radius: 50px;
                color: var(--azul-claro);
                font-weight: 700;
                font-size: .95rem;
                text-decoration: none;
                transition: all .25s;
            }
            .btn-hero-outline:hover {
                background: rgba(66,165,245,.1);
                border-color: var(--azul-claro);
                color: var(--azul-claro);
                transform: translateY(-3px);
            }

            .hero-stats {
                display: flex;
                gap: 2.5rem;
                flex-wrap: wrap;
            }
            .stat-item {
            }
            .stat-number {
                font-family: 'Playfair Display', serif;
                font-size: 1.75rem;
                font-weight: 700;
                color: var(--dorado);
                line-height: 1;
            }
            .stat-label {
                font-size: .72rem;
                color: rgba(248,251,255,.4);
                text-transform: uppercase;
                letter-spacing: .5px;
                margin-top: .2rem;
            }

            /* ── Mascota Búho ── */
            .book-scene {
                display: flex;
                justify-content: center;
                align-items: center;
                position: relative;
                min-height: 420px;
            }
            .mascot-wrap {
                position: relative;
                display: flex;
                align-items: center;
                justify-content: center;
                z-index: 2;
            }
            .mascot-glow {
                position: absolute;
                width: 340px;
                height: 340px;
                border-radius: 50%;
                background: radial-gradient(circle, rgba(21,101,192,.22) 0%, transparent 70%);
                animation: pulse-glow 3.5s ease-in-out infinite;
            }
            @keyframes pulse-glow {
                0%,100%{
                    transform:scale(1);
                    opacity:.6
                }
                50%{
                    transform:scale(1.18);
                    opacity:1
                }
            }
            .mascot-svg {
                animation: owl-float 4s ease-in-out infinite;
                filter: drop-shadow(0 20px 40px rgba(21,101,192,.45));
            }
            @keyframes owl-float {
                0%,100%{
                    transform:translateY(0) rotate(-1deg)
                }
                50%{
                    transform:translateY(-18px) rotate(1deg)
                }
            }
            .mascot-svg:hover {
                animation-play-state:paused;
            }
            /* Speech bubble */
            .speech-bubble {
                position: absolute;
                top: -18px;
                right: -30px;
                background: linear-gradient(135deg,rgba(21,101,192,.9),rgba(13,40,85,.95));
                border: 1px solid rgba(66,165,245,.35);
                border-radius: 16px 16px 16px 4px;
                padding: .55rem 1rem;
                font-size: .78rem;
                color: #fff;
                white-space: nowrap;
                backdrop-filter: blur(8px);
                animation: bubble-pop .4s .5s ease both, owl-float 4s ease-in-out infinite;
                box-shadow: 0 8px 24px rgba(0,0,0,.35);
            }
            @keyframes bubble-pop{
                from{
                    transform:scale(0);
                    opacity:0
                }
                to{
                    transform:scale(1);
                    opacity:1
                }
            }
            .star {
                position: absolute;
                width: 6px;
                height: 6px;
                background: var(--dorado);
                border-radius: 50%;
                animation: twinkle ease-in-out infinite;
            }
            @keyframes twinkle {
                0%,100%{
                    opacity:0;
                    transform:scale(.5)
                }
                50%{
                    opacity:1;
                    transform:scale(1)
                }
            }
            .book-particle {
                position: absolute;
                width: 6px;
                height: 6px;
                background: var(--azul-claro);
                border-radius: 50%;
                top:50%;
                left:50%;
                animation: orbit linear infinite;
            }
            @keyframes orbit {
                0%{
                    transform:rotate(0deg) translateX(140px) rotate(0deg);
                    opacity:.7
                }
                100%{
                    transform:rotate(360deg) translateX(140px) rotate(-360deg);
                    opacity:.7
                }
            }
            /* ══════════════════════════════════════
               SECCIONES GENERALES
            ══════════════════════════════════════ */
            section {
                padding: 5rem 0;
            }

            .section-services   {
                background: linear-gradient(180deg, var(--azul-oscuro) 0%, #0D1E38 100%);
            }
            .section-collection {
                background: linear-gradient(180deg, #0D1E38 0%, var(--azul-oscuro) 100%);
            }
            .section-map        {
                background: var(--azul-oscuro);
            }

            .section-tag {
                display: inline-block;
                font-size: .74rem;
                font-weight: 700;
                letter-spacing: 2px;
                text-transform: uppercase;
                color: var(--azul-claro);
                background: rgba(66,165,245,.1);
                border: 1px solid rgba(66,165,245,.2);
                border-radius: 50px;
                padding: .3rem 1rem;
                margin-bottom: 1rem;
            }
            .section-title {
                font-family: 'Playfair Display', serif;
                font-size: clamp(1.8rem, 3.5vw, 2.6rem);
                font-weight: 800;
                color: var(--blanco);
                line-height: 1.2;
                margin-bottom: .8rem;
            }
            .section-title span {
                color: var(--dorado);
            }
            .section-desc {
                color: rgba(248,251,255,.5);
                font-size: .95rem;
                line-height: 1.7;
                max-width: 520px;
            }

            /* Reveal on scroll */
            .reveal {
                opacity: 0;
                transform: translateY(30px);
                transition: opacity .65s ease, transform .65s ease;
            }
            .reveal.visible {
                opacity: 1;
                transform: translateY(0);
            }

            /* ══════════════════════════════════════
               SERVICE CARDS
            ══════════════════════════════════════ */
            .service-card {
                background: linear-gradient(135deg, rgba(13,40,85,.8), rgba(10,22,40,.95));
                border: 1px solid rgba(66,165,245,.12);
                border-radius: 20px;
                padding: 2rem 1.8rem;
                height: 100%;
                transition: transform .25s, box-shadow .25s, border-color .25s;
            }
            .service-card:hover {
                transform: translateY(-6px);
                box-shadow: 0 16px 40px rgba(0,0,0,.35);
                border-color: rgba(66,165,245,.32);
            }
            .service-icon {
                width: 56px;
                height: 56px;
                border-radius: 16px;
                background: linear-gradient(135deg, rgba(21,101,192,.3), rgba(66,165,245,.15));
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.3rem;
                color: var(--azul-claro);
                margin-bottom: 1.2rem;
            }
            .service-card h4 {
                font-family: 'Playfair Display', serif;
                font-size: 1.08rem;
                color: var(--blanco);
                margin-bottom: .6rem;
            }
            .service-card p {
                font-size: .88rem;
                color: rgba(248,251,255,.5);
                line-height: 1.6;
                margin: 0;
            }

            /* ══════════════════════════════════════
               COLLECTION VISUAL
            ══════════════════════════════════════ */
            .collection-visual {
                position: relative;
                height: 380px;
                background: linear-gradient(180deg, rgba(13,40,85,.4) 0%, rgba(10,22,40,.8) 100%);
                border-radius: 20px;
                border: 1px solid rgba(66,165,245,.1);
                overflow: hidden;
            }
            .shelf {
                position: absolute;
                left: 0;
                right: 0;
                height: 12px;
                background: linear-gradient(90deg, #1a2d50, #0D2855, #1a2d50);
                border-top: 2px solid rgba(66,165,245,.25);
            }
            .mini-book {
                position: absolute;
                border-radius: 2px 3px 3px 2px;
                box-shadow: 2px 0 4px rgba(0,0,0,.4);
                transition: transform .2s;
            }
            .mini-book:hover {
                transform: translateY(-10px) !important;
            }

            /* ══════════════════════════════════════
               MAPA
            ══════════════════════════════════════ */
            .map-wrapper {
                border-radius: 20px;
                overflow: hidden;
                border: 1px solid rgba(66,165,245,.15);
                height: 420px;
            }
            .map-wrapper iframe {
                width:100%;
                height:100%;
                border:0;
            }

            .map-info-card {
                background: linear-gradient(145deg, rgba(13,40,85,.8), rgba(10,22,40,.95));
                border: 1px solid rgba(66,165,245,.12);
                border-radius: 20px;
                padding: 2rem;
                height: 100%;
                display: flex;
                flex-direction: column;
                gap: 1.2rem;
            }
            .map-info-card h3 {
                font-family: 'Playfair Display', serif;
                font-size: 1.2rem;
                color: var(--blanco);
                margin: 0;
                line-height: 1.4;
            }
            .map-detail {
                display:flex;
                align-items:flex-start;
                gap:1rem;
            }
            .map-detail-icon {
                width: 36px;
                height: 36px;
                border-radius: 10px;
                background: rgba(21,101,192,.2);
                display: flex;
                align-items: center;
                justify-content: center;
                color: var(--azul-claro);
                flex-shrink: 0;
                font-size: .9rem;
            }
            .map-detail-text small {
                display: block;
                font-size: .7rem;
                color: rgba(248,251,255,.35);
                text-transform: uppercase;
                letter-spacing: .5px;
            }
            .map-detail-text span {
                font-size: .85rem;
                color: rgba(248,251,255,.7);
            }

            .btn-maps {
                display: inline-flex;
                align-items: center;
                gap: .5rem;
                padding: .65rem 1.4rem;
                background: linear-gradient(135deg, var(--azul-primario), var(--azul-claro));
                border-radius: 50px;
                color: #fff;
                font-weight: 700;
                font-size: .85rem;
                text-decoration: none;
                transition: all .25s;
                margin-top: auto;
                width: fit-content;
            }
            .btn-maps:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 20px rgba(21,101,192,.45);
                color: #fff;
            }

            /* ══════════════════════════════════════
               FOOTER
            ══════════════════════════════════════ */
            footer {
                background: #060d1a;
                border-top: 1px solid rgba(66,165,245,.08);
                padding: 3.5rem 0 1.5rem;
            }
            .footer-brand {
                font-family: 'Playfair Display', serif;
                font-size: 1.2rem;
                color: var(--blanco);
                font-weight: 700;
                margin-bottom: .8rem;
                display: flex;
                align-items: center;
                gap: .5rem;
            }
            .footer-brand i {
                color: var(--dorado);
            }
            .footer-desc {
                color: rgba(248,251,255,.4);
                font-size: .86rem;
                line-height: 1.6;
            }
            .footer-copy {
                text-align: center;
                color: rgba(248,251,255,.22);
                font-size: .78rem;
                margin-top: 2.5rem;
                border-top: 1px solid rgba(255,255,255,.05);
                padding-top: 1.2rem;
            }

            /* ══════════════════════════════════════
               ANIMACIONES GENERALES
            ══════════════════════════════════════ */
            @keyframes bounce {
                0%,100% {
                    transform: translateY(0);
                }
                50%     {
                    transform: translateY(7px);
                }
            }
            @keyframes fade-up {
                from {
                    opacity:0;
                    transform:translate(-50%, 10px);
                }
                to   {
                    opacity:.4;
                    transform:translate(-50%, 0);
                }
            }
        </style>
    </head>
    <body>

        <!-- ═══ NAVBAR ════════════════════════════════════════════════ -->
        <nav class="navbar-custom" id="mainNav">
            <a href="#" class="navbar-brand-custom">
                <i class="fas fa-book-open"></i> Biblioteca SENA
            </a>
            <a href="${pageContext.request.contextPath}/loginServlet" class="btn-login-nav">
                <i class="fas fa-sign-in-alt"></i> Iniciar Sesión
            </a>
        </nav>

        <!-- ═══ HERO ══════════════════════════════════════════════════ -->
        <section class="hero" id="inicio">

            <div class="particles" id="particles"></div>

            <div class="container py-5">
                <div class="row align-items-center g-5">

                    <!-- Texto izquierdo -->
                    <div class="col-lg-6 hero-content">
                        <span class="hero-badge">
                            <i class="fas fa-star"></i> Biblioteca Digital — SENA ADSO
                        </span>
                        <h1 class="hero-title">
                            El saber<br>
                            que <span>ilumina</span><br>
                            tu futuro.
                        </h1>
                        <p class="hero-desc">
                            Accede a miles de títulos, gestiona préstamos y descubre
                            nuevos mundos desde nuestra plataforma de gestión bibliotecaria.
                        </p>
                        <div class="hero-actions">
                            <a href="${pageContext.request.contextPath}/loginServlet" class="btn-hero-primary">
                                <i class="fas fa-rocket"></i> Ingresar al Sistema
                            </a>
                            <a href="#servicios" class="btn-hero-outline">
                                <i class="fas fa-compass"></i> Explorar
                            </a>
                        </div>
                        <div class="hero-stats">
                            <div class="stat-item">
                                <div class="stat-number">5.400+</div>
                                <div class="stat-label">Títulos</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-number">1.200+</div>
                                <div class="stat-label">Usuarios</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-number">98%</div>
                                <div class="stat-label">Satisfacción</div>
                            </div>
                        </div>
                    </div>

                    <!-- Mascota Búho Animada -->
                    <div class="col-lg-6 book-scene">
                        <div class="star" style="top:8%;left:12%;animation-duration:2.1s;animation-delay:.3s;width:8px;height:8px;"></div>
                        <div class="star" style="top:22%;left:82%;animation-duration:1.7s;animation-delay:.8s;"></div>
                        <div class="star" style="top:72%;left:8%;animation-duration:2.5s;animation-delay:.1s;width:7px;height:7px;"></div>
                        <div class="star" style="top:82%;left:78%;animation-duration:1.9s;animation-delay:.6s;"></div>
                        <div class="star" style="top:48%;left:90%;animation-duration:2.3s;animation-delay:.4s;width:9px;height:9px;"></div>

                        <div class="book-particle" style="animation-duration:8s;animation-delay:0s;"></div>
                        <div class="book-particle" style="animation-duration:11s;animation-delay:2s;width:4px;height:4px;background:#FFD54F;"></div>
                        <div class="book-particle" style="animation-duration:9s;animation-delay:4s;width:5px;height:5px;"></div>

                        <div class="mascot-wrap">
                            <div class="mascot-glow"></div>
                            <div class="speech-bubble">📖 ¡Hola! Bienvenido a la Biblioteca SENA</div>
                            <!-- SVG Búho leyendo un libro -->
                            <svg class="mascot-svg" width="300" height="320" viewBox="0 0 300 320" fill="none" xmlns="http://www.w3.org/2000/svg" title="¡Haz hover para pausar!">
                            <defs>
                            <radialGradient id="bgGrad" cx="50%" cy="50%" r="50%">
                            <stop offset="0%" stop-color="#1565C0" stop-opacity=".18"/>
                            <stop offset="100%" stop-color="#0A1628" stop-opacity="0"/>
                            </radialGradient>
                            <linearGradient id="bodyGrad" x1="0" y1="0" x2="1" y2="1">
                            <stop offset="0%" stop-color="#2E4A8A"/>
                            <stop offset="100%" stop-color="#1A2F5E"/>
                            </linearGradient>
                            <linearGradient id="bookGrad" x1="0" y1="0" x2="1" y2="0">
                            <stop offset="0%" stop-color="#1565C0"/>
                            <stop offset="100%" stop-color="#42A5F5"/>
                            </linearGradient>
                            <filter id="glow">
                                <feGaussianBlur stdDeviation="3" result="blur"/>
                                <feMerge><feMergeNode in="blur"/><feMergeNode in="SourceGraphic"/></feMerge>
                            </filter>
                            </defs>

                            <!-- Sombra base -->
                            <ellipse cx="150" cy="308" rx="72" ry="10" fill="rgba(0,0,0,.25)"/>

                            <!-- Cuerpo principal búho -->
                            <ellipse cx="150" cy="185" rx="68" ry="80" fill="url(#bodyGrad)" filter="url(#glow)"/>

                            <!-- Barriga clara -->
                            <ellipse cx="150" cy="200" rx="42" ry="55" fill="#3A5A9A" opacity=".6"/>
                            <!-- Patrón plumas barriga -->
                            <ellipse cx="150" cy="190" rx="28" ry="18" fill="rgba(255,255,255,.05)"/>
                            <ellipse cx="150" cy="212" rx="22" ry="14" fill="rgba(255,255,255,.04)"/>
                            <ellipse cx="150" cy="230" rx="18" ry="11" fill="rgba(255,255,255,.04)"/>

                            <!-- Alas -->
                            <path d="M82 170 Q50 155 48 210 Q55 235 85 230 L90 200 Z" fill="#1E3A6E"/>
                            <path d="M218 170 Q250 155 252 210 Q245 235 215 230 L210 200 Z" fill="#1E3A6E"/>
                            <!-- Textura alas -->
                            <path d="M82 170 Q68 175 62 195" stroke="rgba(255,255,255,.08)" stroke-width="2" fill="none"/>
                            <path d="M218 170 Q232 175 238 195" stroke="rgba(255,255,255,.08)" stroke-width="2" fill="none"/>

                            <!-- Cabeza -->
                            <circle cx="150" cy="120" r="62" fill="url(#bodyGrad)" filter="url(#glow)"/>

                            <!-- Orejas / plumas de la cabeza -->
                            <path d="M108 75 L96 42 L120 65 Z" fill="#1E3A6E"/>
                            <path d="M192 75 L204 42 L180 65 Z" fill="#1E3A6E"/>
                            <path d="M109 73 L100 50 L118 67 Z" fill="#2E4A8A"/>
                            <path d="M191 73 L200 50 L182 67 Z" fill="#2E4A8A"/>

                            <!-- Cara / máscara -->
                            <ellipse cx="150" cy="122" rx="46" ry="44" fill="#4A6BAA" opacity=".55"/>

                            <!-- Ojos grandes -->
                            <circle cx="128" cy="112" r="20" fill="#0D2855" stroke="#42A5F5" stroke-width="2"/>
                            <circle cx="172" cy="112" r="20" fill="#0D2855" stroke="#42A5F5" stroke-width="2"/>
                            <!-- Iris -->
                            <circle cx="128" cy="112" r="14" fill="linear-gradient(135deg,#FFD54F,#F9A825)"/>
                            <circle cx="128" cy="112" r="14" fill="#FFD54F"/>
                            <circle cx="172" cy="112" r="14" fill="#FFD54F"/>
                            <!-- Pupilas con brillo -->
                            <circle cx="128" cy="112" r="8" fill="#0A1628"/>
                            <circle cx="172" cy="112" r="8" fill="#0A1628"/>
                            <!-- Brillo ojos -->
                            <circle cx="122" cy="106" r="3.5" fill="white" opacity=".85"/>
                            <circle cx="166" cy="106" r="3.5" fill="white" opacity=".85"/>
                            <circle cx="132" cy="116" r="1.5" fill="white" opacity=".45"/>
                            <circle cx="176" cy="116" r="1.5" fill="white" opacity=".45"/>

                            <!-- Pico -->
                            <path d="M142 130 L150 142 L158 130 Z" fill="#FFD54F"/>
                            <path d="M144 132 L150 139 L156 132 Z" fill="#F9A825"/>

                            <!-- Birrete / gorra académica -->
                            <rect x="108" y="66" width="84" height="12" rx="3" fill="#1565C0"/>
                            <rect x="118" y="58" width="64" height="12" rx="3" fill="#1565C0"/>
                            <!-- Tablero del birrete -->
                            <rect x="110" y="54" width="80" height="8" rx="2" fill="#42A5F5" opacity=".8"/>
                            <!-- Borla -->
                            <line x1="185" y1="58" x2="195" y2="42" stroke="#FFD54F" stroke-width="2.5"/>
                            <circle cx="196" cy="40" r="5" fill="#FFD54F"/>
                            <line x1="196" y1="45" x2="190" y2="56" stroke="#FFD54F" stroke-width="1.5" opacity=".6"/>
                            <line x1="196" y1="45" x2="200" y2="55" stroke="#FFD54F" stroke-width="1.5" opacity=".6"/>

                            <!-- Patas -->
                            <path d="M118 265 L108 290 M118 265 L114 292 M118 265 L120 292" stroke="#42A5F5" stroke-width="3.5" stroke-linecap="round"/>
                            <path d="M182 265 L172 290 M182 265 L178 292 M182 265 L184 292" stroke="#42A5F5" stroke-width="3.5" stroke-linecap="round"/>

                            <!-- LIBRO que sostiene -->
                            <g transform="translate(100, 240)">
                            <!-- Libro cerrado -->
                            <rect x="0" y="0" width="100" height="68" rx="6" fill="url(#bookGrad)" filter="url(#glow)"/>
                            <!-- Lomo libro -->
                            <rect x="0" y="0" width="14" height="68" rx="3" fill="#0D2855"/>
                            <!-- Páginas -->
                            <rect x="86" y="2" width="8" height="64" rx="2" fill="#e8e0d0" opacity=".9"/>
                            <!-- Líneas del libro (texto) -->
                            <line x1="20" y1="18" x2="82" y2="18" stroke="rgba(255,255,255,.35)" stroke-width="2" stroke-linecap="round"/>
                            <line x1="20" y1="26" x2="78" y2="26" stroke="rgba(255,255,255,.25)" stroke-width="1.5" stroke-linecap="round"/>
                            <line x1="20" y1="34" x2="80" y2="34" stroke="rgba(255,255,255,.25)" stroke-width="1.5" stroke-linecap="round"/>
                            <line x1="20" y1="42" x2="74" y2="42" stroke="rgba(255,255,255,.2)" stroke-width="1.5" stroke-linecap="round"/>
                            <line x1="20" y1="50" x2="76" y2="50" stroke="rgba(255,255,255,.2)" stroke-width="1.5" stroke-linecap="round"/>
                            <!-- Título libro -->
                            <text x="50" y="9" text-anchor="middle" font-size="6" fill="rgba(255,255,255,.5)" font-family="sans-serif" letter-spacing=".5">SENA LIBRARY</text>
                            <!-- Estrella decorativa -->
                            <text x="50" y="64" text-anchor="middle" font-size="7" fill="#FFD54F" opacity=".7">★ ★ ★</text>
                            </g>

                            <!-- Gafas de estudio (pequeñas, encima de los ojos) -->
                            <path d="M110 118 Q128 126 146 118" stroke="#FFD54F" stroke-width="2" fill="none" opacity=".6"/>
                            <path d="M154 118 Q172 126 190 118" stroke="#FFD54F" stroke-width="2" fill="none" opacity=".6"/>
                            <line x1="146" y1="118" x2="154" y2="118" stroke="#FFD54F" stroke-width="1.8" opacity=".6"/>

                            <!-- Estrellas flotantes alrededor -->
                            <g opacity=".7" filter="url(#glow)">
                            <polygon points="40,80 43,70 46,80 36,74 50,74" fill="#FFD54F" opacity=".5" transform="scale(.7)"/>
                            <polygon points="260,60 263,50 266,60 256,54 270,54" fill="#42A5F5" opacity=".4" transform="scale(.7)"/>
                            </g>
                            </svg>
                        </div>
                    </div>

                </div>
            </div>

            <!-- Scroll indicator -->
            <div style="position:absolute;bottom:2rem;left:50%;transform:translateX(-50%);
                 display:flex;flex-direction:column;align-items:center;gap:.4rem;
                 opacity:.4;animation:fade-up 1s 1s both;">
                <span style="font-size:.68rem;letter-spacing:2px;text-transform:uppercase;">Scroll</span>
                <i class="fas fa-chevron-down" style="animation:bounce .9s ease-in-out infinite;"></i>
            </div>
        </section>

        <!-- ═══ SERVICIOS ════════════════════════════════════════════ -->
        <section class="section-services" id="servicios">
            <div class="container">
                <div class="row justify-content-center text-center mb-5 reveal">
                    <div class="col-lg-7">
                        <span class="section-tag">¿Qué ofrecemos?</span>
                        <h2 class="section-title">Todo lo que <span>necesitas</span><br>en un solo lugar</h2>
                        <p class="section-desc mx-auto">
                            Nuestra plataforma integra gestión de libros, préstamos, usuarios y más,
                            con una experiencia moderna y eficiente.
                        </p>
                    </div>
                </div>

                <div class="row g-4">
                    <div class="col-md-6 col-lg-4 reveal">
                        <div class="service-card">
                            <div class="service-icon"><i class="fas fa-book"></i></div>
                            <h4>Catálogo Digital</h4>
                            <p>Accede al inventario completo de libros, filtra por categoría, autor o editorial en segundos.</p>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-4 reveal" style="transition-delay:.1s">
                        <div class="service-card">
                            <div class="service-icon"><i class="fas fa-hand-holding"></i></div>
                            <h4>Préstamos Ágiles</h4>
                            <p>Registra y controla préstamos con fechas de vencimiento, alertas y renovaciones automáticas.</p>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-4 reveal" style="transition-delay:.2s">
                        <div class="service-card">
                            <div class="service-icon"><i class="fas fa-users"></i></div>
                            <h4>Gestión de Usuarios</h4>
                            <p>Administra el directorio de lectores, roles y permisos desde un panel centralizado.</p>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-4 reveal" style="transition-delay:.3s">
                        <div class="service-card">
                            <div class="service-icon"><i class="fas fa-exclamation-triangle"></i></div>
                            <h4>Control de Multas</h4>
                            <p>Genera y gestiona multas por retrasos de forma automática, con historial completo por usuario.</p>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-4 reveal" style="transition-delay:.4s">
                        <div class="service-card">
                            <div class="service-icon"><i class="fas fa-chart-bar"></i></div>
                            <h4>Reportes y Estadísticas</h4>
                            <p>Visualiza métricas clave del estado de tu biblioteca en tiempo real desde el dashboard.</p>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-4 reveal" style="transition-delay:.5s">
                        <div class="service-card">
                            <div class="service-icon"><i class="fas fa-shield-alt"></i></div>
                            <h4>Acceso Seguro</h4>
                            <p>Autenticación con roles diferenciados y protección de datos sensibles en todo momento.</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- ═══ COLECCIÓN VISUAL ═════════════════════════════════════ -->
        <section class="section-collection">
            <div class="container">
                <div class="row align-items-center g-5">
                    <div class="col-lg-5 reveal">
                        <span class="section-tag">Nuestra colección</span>
                        <h2 class="section-title">Miles de títulos<br>te <span>esperan</span></h2>
                        <p class="section-desc" style="max-width:100%">
                            Desde literatura clásica hasta ciencias aplicadas. Nuestra biblioteca
                            crece constantemente con nuevas adquisiciones para todos los gustos y disciplinas.
                        </p>
                        <div class="d-flex gap-4 mt-4">
                            <div>
                                <div style="font-family:'Playfair Display',serif;font-size:1.8rem;color:var(--dorado);font-weight:700;">120+</div>
                                <div style="font-size:.78rem;color:rgba(248,251,255,.5);">Categorías</div>
                            </div>
                            <div>
                                <div style="font-family:'Playfair Display',serif;font-size:1.8rem;color:var(--dorado);font-weight:700;">80+</div>
                                <div style="font-size:.78rem;color:rgba(248,251,255,.5);">Editoriales</div>
                            </div>
                            <div>
                                <div style="font-family:'Playfair Display',serif;font-size:1.8rem;color:var(--dorado);font-weight:700;">350+</div>
                                <div style="font-size:.78rem;color:rgba(248,251,255,.5);">Autores</div>
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/loginServlet"
                           class="btn-hero-primary d-inline-flex mt-4" style="width:fit-content;">
                            <i class="fas fa-search"></i> Ver catálogo
                        </a>
                    </div>

                    <!-- Estantería animada -->
                    <div class="col-lg-7 reveal" style="transition-delay:.2s">
                        <div class="collection-visual">
                            <div class="shelf" style="bottom:0"></div>
                            <div class="shelf" style="bottom:130px"></div>
                            <div class="shelf" style="bottom:260px"></div>

                            <!-- Fila 1 (abajo) -->
                            <div class="mini-book" style="height:110px;width:28px;background:linear-gradient(#1565C0,#0D47A1);left:20px;bottom:14px;"></div>
                            <div class="mini-book" style="height:95px;width:22px;background:linear-gradient(#C62828,#8B0000);left:52px;bottom:14px;"></div>
                            <div class="mini-book" style="height:120px;width:30px;background:linear-gradient(#2E7D32,#1B5E20);left:78px;bottom:14px;"></div>
                            <div class="mini-book" style="height:100px;width:25px;background:linear-gradient(#F57F17,#E65100);left:112px;bottom:14px;"></div>
                            <div class="mini-book" style="height:115px;width:26px;background:linear-gradient(#6A1B9A,#4A148C);left:141px;bottom:14px;"></div>
                            <div class="mini-book" style="height:90px;width:20px;background:linear-gradient(#0288D1,#01579B);left:171px;bottom:14px;"></div>
                            <div class="mini-book" style="height:108px;width:28px;background:linear-gradient(#37474F,#263238);left:195px;bottom:14px;"></div>
                            <div class="mini-book" style="height:118px;width:32px;background:linear-gradient(#FF6F00,#E65100);left:227px;bottom:14px;"></div>
                            <div class="mini-book" style="height:95px;width:22px;background:linear-gradient(#1565C0,#0D47A1);left:263px;bottom:14px;"></div>
                            <div class="mini-book" style="height:112px;width:26px;background:linear-gradient(#880E4F,#4A0072);left:289px;bottom:14px;"></div>
                            <div class="mini-book" style="height:100px;width:24px;background:linear-gradient(#1B5E20,#0A3D0A);left:319px;bottom:14px;"></div>
                            <div class="mini-book" style="height:88px;width:18px;background:linear-gradient(#BF360C,#7F1500);left:347px;bottom:14px;"></div>
                            <div class="mini-book" style="height:116px;width:30px;background:linear-gradient(#0D47A1,#01227B);left:369px;bottom:14px;"></div>

                            <!-- Fila 2 (medio) -->
                            <div class="mini-book" style="height:100px;width:24px;background:linear-gradient(#F57F17,#E65100);left:15px;bottom:144px;"></div>
                            <div class="mini-book" style="height:112px;width:28px;background:linear-gradient(#1565C0,#0D47A1);left:43px;bottom:144px;"></div>
                            <div class="mini-book" style="height:88px;width:20px;background:linear-gradient(#2E7D32,#1B5E20);left:75px;bottom:144px;"></div>
                            <div class="mini-book" style="height:105px;width:26px;background:linear-gradient(#37474F,#263238);left:99px;bottom:144px;"></div>
                            <div class="mini-book" style="height:118px;width:30px;background:linear-gradient(#C62828,#8B0000);left:129px;bottom:144px;"></div>
                            <div class="mini-book" style="height:95px;width:22px;background:linear-gradient(#6A1B9A,#4A148C);left:163px;bottom:144px;"></div>
                            <div class="mini-book" style="height:108px;width:26px;background:linear-gradient(#0288D1,#01579B);left:189px;bottom:144px;"></div>
                            <div class="mini-book" style="height:92px;width:20px;background:linear-gradient(#880E4F,#4A0072);left:219px;bottom:144px;"></div>
                            <div class="mini-book" style="height:115px;width:28px;background:linear-gradient(#FF6F00,#E65100);left:243px;bottom:144px;"></div>
                            <div class="mini-book" style="height:100px;width:24px;background:linear-gradient(#1B5E20,#0A3D0A);left:275px;bottom:144px;"></div>
                            <div class="mini-book" style="height:110px;width:26px;background:linear-gradient(#1565C0,#0D47A1);left:303px;bottom:144px;"></div>
                            <div class="mini-book" style="height:90px;width:22px;background:linear-gradient(#BF360C,#7F1500);left:333px;bottom:144px;"></div>
                            <div class="mini-book" style="height:105px;width:28px;background:linear-gradient(#37474F,#263238);left:359px;bottom:144px;"></div>

                            <!-- Fila 3 (arriba) -->
                            <div class="mini-book" style="height:95px;width:22px;background:linear-gradient(#2E7D32,#1B5E20);left:25px;bottom:274px;"></div>
                            <div class="mini-book" style="height:110px;width:26px;background:linear-gradient(#C62828,#8B0000);left:51px;bottom:274px;"></div>
                            <div class="mini-book" style="height:100px;width:24px;background:linear-gradient(#0288D1,#01579B);left:81px;bottom:274px;"></div>
                            <div class="mini-book" style="height:88px;width:20px;background:linear-gradient(#FF6F00,#E65100);left:109px;bottom:274px;"></div>
                            <div class="mini-book" style="height:115px;width:28px;background:linear-gradient(#6A1B9A,#4A148C);left:133px;bottom:274px;"></div>
                            <div class="mini-book" style="height:105px;width:26px;background:linear-gradient(#1565C0,#0D47A1);left:165px;bottom:274px;"></div>
                            <div class="mini-book" style="height:92px;width:22px;background:linear-gradient(#880E4F,#4A0072);left:195px;bottom:274px;"></div>
                            <div class="mini-book" style="height:108px;width:26px;background:linear-gradient(#F57F17,#E65100);left:221px;bottom:274px;"></div>
                            <div class="mini-book" style="height:98px;width:24px;background:linear-gradient(#37474F,#263238);left:251px;bottom:274px;"></div>
                            <div class="mini-book" style="height:112px;width:28px;background:linear-gradient(#2E7D32,#1B5E20);left:279px;bottom:274px;"></div>
                            <div class="mini-book" style="height:90px;width:20px;background:linear-gradient(#BF360C,#7F1500);left:311px;bottom:274px;"></div>
                            <div class="mini-book" style="height:106px;width:26px;background:linear-gradient(#0D47A1,#01227B);left:335px;bottom:274px;"></div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- ═══ MAPA ══════════════════════════════════════════════════ -->
        <section class="section-map" id="ubicacion">
            <div class="container">
                <div class="text-center mb-5 reveal">
                    <span class="section-tag">¿Dónde estamos?</span>
                    <h2 class="section-title">Visítanos en <span>persona</span></h2>
                </div>

                <div class="row g-4 align-items-stretch">
                    <div class="col-lg-8 reveal">
                        <div class="map-wrapper">
                            <iframe
                                src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3976.794!2d-74.06480!3d4.62820!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x8e3f9bfb6e3d0001%3A0x1234567890abcdef!2sCalle%2026%20%2369-76%2C%20Bogot%C3%A1%2C%20Colombia!5e0!3m2!1ses!2sco!4v1234567890"
                                allowfullscreen=""
                                loading="lazy"
                                referrerpolicy="no-referrer-when-downgrade">
                            </iframe>
                        </div>
                    </div>

                    <div class="col-lg-4 reveal" style="transition-delay:.15s">
                        <div class="map-info-card">
                            <h3>Biblioteca <span style="color:var(--dorado)">SENA</span><br>Centro de Conocimiento</h3>

                            <div class="map-detail">
                                <div class="map-detail-icon"><i class="fas fa-map-marker-alt"></i></div>
                                <div class="map-detail-text">
                                    <small>Dirección</small>
                                    <span>Calle 26 # 69 - 76, Bogotá, Colombia</span>
                                </div>
                            </div>
                            <div class="map-detail">
                                <div class="map-detail-icon"><i class="fas fa-clock"></i></div>
                                <div class="map-detail-text">
                                    <small>Horario de atención</small>
                                    <span>Lun – Vie: 7:00 am – 9:00 pm</span>
                                </div>
                            </div>
                            <div class="map-detail">
                                <div class="map-detail-icon"><i class="fas fa-phone-alt"></i></div>
                                <div class="map-detail-text">
                                    <small>Teléfono</small>
                                    <span>(601) 546 1500</span>
                                </div>
                            </div>
                            <div class="map-detail">
                                <div class="map-detail-icon"><i class="fas fa-envelope"></i></div>
                                <div class="map-detail-text">
                                    <small>Correo</small>
                                    <span>biblioteca@sena.edu.co</span>
                                </div>
                            </div>

                            <a href="https://maps.google.com/?q=Calle+26+69-76+Bogota+Colombia"
                               target="_blank" class="btn-maps">
                                <i class="fas fa-directions"></i> Cómo llegar
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <%@ page import="java.util.List, karen.adso.biblioteca.dao.LibroDAO, karen.adso.biblioteca.modelo.Libro" %>
        <%
            LibroDAO _libroDAO = new LibroDAO();
            List<Libro> _libros = _libroDAO.listarTodos();
        %>

        <!-- ═══ CARRUSEL DE LIBROS CON CALIFICACIÓN ══════════════════ -->
        <section style="padding:4.5rem 0;background:linear-gradient(180deg,#0D1E38 0%,#0A1628 100%);overflow:hidden;">
            <div style="max-width:1200px;margin:0 auto;padding:0 2rem;">

                <!-- Encabezado sección -->
                <div style="text-align:center;margin-bottom:2.5rem;">
                    <span style="display:inline-block;background:rgba(255,213,79,.1);border:1px solid rgba(255,213,79,.25);
                          color:#FFD54F;font-size:.72rem;font-weight:700;letter-spacing:2px;text-transform:uppercase;
                          padding:.4em 1.2em;border-radius:50px;margin-bottom:.9rem;">
                        Catálogo destacado
                    </span>
                    <h2 style="font-family:'Playfair Display',serif;font-size:2rem;font-weight:700;margin-bottom:.5rem;">
                        Libros que te <span style="color:#FFD54F;">esperan</span>
                    </h2>
                    <p style="color:rgba(248,251,255,.5);font-size:.9rem;max-width:500px;margin:0 auto;">
                        Explora nuestra colección. Inicia sesión para reservar o solicitar un préstamo.
                    </p>
                </div>

                <!-- Track del carrusel -->
                <div style="position:relative;">
                    <!-- Botón izquierda -->
                    <button id="carPrev" onclick="moverCarrusel(-1)"
                            style="position:absolute;left:-20px;top:50%;transform:translateY(-50%);z-index:10;
                            width:40px;height:40px;border-radius:50%;background:rgba(21,101,192,.7);
                            border:1px solid rgba(66,165,245,.3);color:#fff;font-size:.9rem;cursor:pointer;
                            display:flex;align-items:center;justify-content:center;transition:all .2s;">
                        <i class="fas fa-chevron-left"></i>
                    </button>
                    <!-- Botón derecha -->
                    <button id="carNext" onclick="moverCarrusel(1)"
                            style="position:absolute;right:-20px;top:50%;transform:translateY(-50%);z-index:10;
                            width:40px;height:40px;border-radius:50%;background:rgba(21,101,192,.7);
                            border:1px solid rgba(66,165,245,.3);color:#fff;font-size:.9rem;cursor:pointer;
                            display:flex;align-items:center;justify-content:center;transition:all .2s;">
                        <i class="fas fa-chevron-right"></i>
                    </button>

                    <div id="carTrack" style="display:flex;gap:1.2rem;overflow:hidden;scroll-behavior:smooth;padding:.5rem .2rem;">
                        <% if (_libros != null && !_libros.isEmpty()) {
                                for (Libro lb : _libros) {
                                    double rating = 4.0 + Math.random(); // Cuando tengas tabla resena: leer promedio real
                                    int ratingInt = (int) Math.round(rating);
                        %>
                        <div class="car-card"
                             style="flex:0 0 190px;background:rgba(255,255,255,.04);border:1px solid rgba(66,165,245,.12);
                             border-radius:16px;overflow:hidden;cursor:pointer;
                             transition:transform .25s,border-color .25s,box-shadow .25s;"
                             onmouseover="this.style.transform = 'translateY(-8px)';this.style.borderColor = 'rgba(66,165,245,.4)';this.style.boxShadow = '0 16px 40px rgba(0,0,0,.35)'"
                             onmouseout="this.style.transform = 'translateY(0)';this.style.borderColor = 'rgba(66,165,245,.12)';this.style.boxShadow = 'none'"
                             onclick="window.location = '${pageContext.request.contextPath}/loginServlet'">

                            <!-- Portada -->
                            <% if (lb.getImagen() != null && !lb.getImagen().isEmpty()) {%>
                            <img src="${pageContext.request.contextPath}/imagen?f=<%=lb.getImagen()%>"
                                 style="width:100%;height:200px;object-fit:cover;display:block;"
                                 alt="<%=lb.getTitulo()%>"
                                 onerror="this.parentNode.querySelector('.car-placeholder').style.display='flex';this.style.display='none'">
                            <div class="car-placeholder" style="display:none;width:100%;height:200px;background:linear-gradient(135deg,#0d2855,#1565c0);align-items:center;justify-content:center;font-size:3rem;">📖</div>
                            <% } else {%>
                            <div style="width:100%;height:200px;background:linear-gradient(135deg,#0d2855 0%,#1565c0 60%,#0a1628 100%);
                                 display:flex;flex-direction:column;align-items:center;justify-content:center;font-size:2.8rem;
                                 color:rgba(255,255,255,.15);">
                                📖
                                <span style="font-size:.65rem;color:rgba(255,255,255,.2);margin-top:.4rem;text-align:center;padding:0 .5rem;">
                                    <%=lb.getTitulo().length() > 25 ? lb.getTitulo().substring(0, 22) + "..." : lb.getTitulo()%>
                                </span>
                            </div>
                            <% }%>

                            <!-- Badge disponibilidad -->
                            <div style="padding:.75rem .9rem;">
                                <div style="font-weight:700;font-size:.84rem;color:#fff;
                                     white-space:nowrap;overflow:hidden;text-overflow:ellipsis;margin-bottom:.25rem;"
                                     title="<%=lb.getTitulo()%>">
                                    <%=lb.getTitulo()%>
                                </div>
                                <div style="font-size:.72rem;color:rgba(255,255,255,.45);margin-bottom:.4rem;">
                                    <%=lb.getCategoriaNombre() != null ? lb.getCategoriaNombre() : ""%>
                                </div>

                                <!-- Estrellas -->
                                <div style="display:flex;align-items:center;gap:.3rem;margin-bottom:.45rem;">
                                    <span style="color:#FFD54F;font-size:.78rem;letter-spacing:1px;">
                                        <%for (int s = 1; s <= 5; s++) {%><%=s <= ratingInt ? "★" : "☆"%><%}%>
                                    </span>
                                    <span style="font-size:.68rem;color:rgba(255,255,255,.35);">
                                        <%=String.format("%.1f", Math.min(rating, 5.0))%>
                                    </span>
                                </div>

                                <!-- Disponibilidad -->
                                <span style="display:inline-block;font-size:.68rem;font-weight:700;padding:.2em .6em;border-radius:50px;
                                      background:<%=lb.getDisponible() == 1 ? "rgba(76,175,80,.15)" : "rgba(239,83,80,.12)"%>;
                                      color:<%=lb.getDisponible() == 1 ? "#66BB6A" : "#EF5350"%>;
                                      border:1px solid <%=lb.getDisponible() == 1 ? "rgba(76,175,80,.3)" : "rgba(239,83,80,.28)"%>;">
                                    <%=lb.getDisponible() == 1 ? "Disponible" : "No disponible"%>
                                </span>
                            </div>
                        </div>
                        <% }
                        } else { %>
                        <p style="color:rgba(255,255,255,.3);padding:2rem;">No hay libros registrados aún.</p>
                        <% }%>
                    </div>
                </div>

                <!-- Indicadores (dots) -->
                <div id="carDots" style="display:flex;justify-content:center;gap:.5rem;margin-top:1.4rem;"></div>
            </div>
        </section>

        <script>
            (function () {
                var track = document.getElementById('carTrack');
                var dotsWrap = document.getElementById('carDots');
                if (!track)
                    return;

                var cards = track.querySelectorAll('.car-card');
                var cardW = 190 + 19; // card width + gap
                var visible = Math.floor(track.clientWidth / cardW) || 3;
                var total = Math.ceil(cards.length / visible);
                var current = 0;

                // Crear dots
                for (var i = 0; i < total; i++) {
                    var d = document.createElement('div');
                    d.style.cssText = 'width:8px;height:8px;border-radius:50%;background:rgba(255,255,255,.2);cursor:pointer;transition:all .3s;';
                    d.setAttribute('data-idx', i);
                    d.addEventListener('click', function () {
                        irA(parseInt(this.getAttribute('data-idx')));
                    });
                    dotsWrap.appendChild(d);
                }

                function actualizarDots() {
                    dotsWrap.querySelectorAll('div').forEach(function (d, idx) {
                        d.style.background = idx === current ? '#FFD54F' : 'rgba(255,255,255,.2)';
                        d.style.width = idx === current ? '20px' : '8px';
                    });
                }

                function irA(idx) {
                    current = Math.max(0, Math.min(idx, total - 1));
                    track.scrollLeft = current * visible * cardW;
                    actualizarDots();
                }

                window.moverCarrusel = function (dir) {
                    irA(current + dir);
                };

                actualizarDots();

                // Auto-play cada 4 segundos
                setInterval(function () {
                    irA(current + 1 < total ? current + 1 : 0);
                }, 4000);
            })();
        </script>

        <footer>
            <div class="container">
                <div class="row g-4">
                    <div class="col-md-5">
                        <div class="footer-brand">
                            <i class="fas fa-book-open"></i> Biblioteca SENA
                        </div>
                        <p class="footer-desc">
                            Sistema de Gestión Bibliotecaria desarrollado por aprendices ADSO.<br>
                            Conocimiento accesible para todos.
                        </p>
                    </div>
                    <div class="col-md-3 offset-md-1">
                        <p style="color:rgba(248,251,255,.45);font-size:.78rem;letter-spacing:2px;text-transform:uppercase;margin-bottom:1rem;">Módulos</p>
                        <ul style="list-style:none;padding:0;margin:0;">
                            <li style="margin-bottom:.5rem;">
                                <a href="${pageContext.request.contextPath}/loginServlet"
                                   style="color:rgba(248,251,255,.4);text-decoration:none;font-size:.875rem;transition:color .2s;"
                                   onmouseover="this.style.color = '#42A5F5'" onmouseout="this.style.color = 'rgba(248,251,255,.4)'">
                                    Libros
                                </a>
                            </li>
                            <li style="margin-bottom:.5rem;">
                                <a href="${pageContext.request.contextPath}/loginServlet"
                                   style="color:rgba(248,251,255,.4);text-decoration:none;font-size:.875rem;transition:color .2s;"
                                   onmouseover="this.style.color = '#42A5F5'" onmouseout="this.style.color = 'rgba(248,251,255,.4)'">
                                    Préstamos
                                </a>
                            </li>
                            <li style="margin-bottom:.5rem;">
                                <a href="${pageContext.request.contextPath}/loginServlet"
                                   style="color:rgba(248,251,255,.4);text-decoration:none;font-size:.875rem;transition:color .2s;"
                                   onmouseover="this.style.color = '#42A5F5'" onmouseout="this.style.color = 'rgba(248,251,255,.4)'">
                                    Usuarios
                                </a>
                            </li>
                            <li style="margin-bottom:.5rem;">
                                <a href="${pageContext.request.contextPath}/loginServlet"
                                   style="color:rgba(248,251,255,.4);text-decoration:none;font-size:.875rem;transition:color .2s;"
                                   onmouseover="this.style.color = '#42A5F5'" onmouseout="this.style.color = 'rgba(248,251,255,.4)'">
                                    Multas
                                </a>
                            </li>
                        </ul>
                    </div>
                    <div class="col-md-3">
                        <p style="color:rgba(248,251,255,.45);font-size:.78rem;letter-spacing:2px;text-transform:uppercase;margin-bottom:1rem;">Acceso rápido</p>
                        <a href="${pageContext.request.contextPath}/loginServlet"
                           class="btn-login-nav" style="font-size:.85rem;">
                            <i class="fas fa-sign-in-alt"></i> Iniciar Sesión
                        </a>
                    </div>
                </div>
                <p class="footer-copy">© 2025 Biblioteca SENA ❤️ </p>
            </div>
        </footer>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
                                       // Navbar scroll effect
                                       window.addEventListener('scroll', () => {
                                           document.getElementById('mainNav').classList.toggle('scrolled', window.scrollY > 50);
                                       });

                                       // Generar partículas flotantes
                                       const container = document.getElementById('particles');
                                       for (let i = 0; i < 28; i++) {
                                           const p = document.createElement('div');
                                           p.className = 'particle';
                                           const size = Math.random() * 4 + 2;
                                           p.style.cssText = `
                    width:${size}px;
                    height:${size}px;
                    left:${Math.random() * 100}%;
                    animation-duration:${Math.random() * 14 + 8}s;
                    animation-delay:${Math.random() * 10}s;
                `;
                                           container.appendChild(p);
                                       }

                                       // Scroll reveal
                                       const observer = new IntersectionObserver((entries) => {
                                           entries.forEach(e => {
                                               if (e.isIntersecting)
                                                   e.target.classList.add('visible');
                                           });
                                       }, {threshold: 0.12});
                                       document.querySelectorAll('.reveal').forEach(el => observer.observe(el));
        </script>

    </body>
</html>
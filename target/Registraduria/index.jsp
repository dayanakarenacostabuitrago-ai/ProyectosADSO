<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="es">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Registraduría Municipal de Nobsa — Inicio</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
        <link
            href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=DM+Sans:ital,wght@0,300;0,400;0,500;0,600;0,700;1,400&display=swap"
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
                --navy: #0b2346;
                --navy-med: #163a6b;
                --navy-light: #1e4d8c;
                --blue: #2979e8;
                --blue-light: #5b9cf6;
                --gold: #c8a84b;
                --gold-light: #e6c96a;
                --white: #ffffff;
                --off-white: #f5f8ff;
                --text: #1a2535;
                --muted: #5a6a7a;
                --border: rgba(200, 216, 232, 0.6);
                --radius: 14px;
                --shadow: 0 4px 24px rgba(11, 35, 70, .10);
                --shadow-lg: 0 12px 40px rgba(11, 35, 70, .16);
                --transition: .25s cubic-bezier(.4, 0, .2, 1);
            }

            html {
                scroll-behavior: smooth
            }

            body {
                font-family: 'DM Sans', sans-serif;
                background: var(--off-white);
                color: var(--text);
                min-height: 100vh;
                overflow-x: hidden
            }

            .banda-gov {
                height: 6px;
                background: linear-gradient(90deg, #ffd900 33.33%, #003087 33.33% 66.66%, #ce1126 66.66%);
                position: sticky;
                top: 0;
                z-index: 200
            }

            .navbar {
                background: var(--navy);
                padding: 0 40px;
                display: flex;
                align-items: center;
                justify-content: space-between;
                height: 68px;
                position: sticky;
                top: 6px;
                z-index: 100;
                box-shadow: 0 4px 24px rgba(0, 0, 0, .25)
            }

            .nav-brand {
                display: flex;
                align-items: center;
                gap: 14px;
                text-decoration: none
            }

            .nav-logo-ring {
                width: 42px;
                height: 42px;
                background: linear-gradient(135deg, var(--gold) 0%, var(--gold-light) 100%);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                flex-shrink: 0;
                box-shadow: 0 3px 10px rgba(200, 168, 75, .4)
            }

            .nav-logo-ring i {
                color: var(--navy);
                font-size: 18px
            }

            .nav-brand-text strong {
                display: block;
                color: #fff;
                font-size: 14px;
                font-weight: 700;
                letter-spacing: .01em
            }

            .nav-brand-text span {
                display: block;
                color: rgba(255, 255, 255, .5);
                font-size: 10.5px;
                text-transform: uppercase;
                letter-spacing: .09em;
                margin-top: 1px
            }

            .nav-links {
                display: flex;
                align-items: center;
                gap: 6px
            }

            .nav-link {
                color: rgba(255, 255, 255, .65);
                text-decoration: none;
                font-size: 13px;
                font-weight: 500;
                padding: 8px 14px;
                border-radius: 8px;
                transition: var(--transition);
                display: flex;
                align-items: center;
                gap: 6px
            }

            .nav-link:hover {
                color: #fff;
                background: rgba(255, 255, 255, .08);
                text-decoration: none
            }

            .nav-link-gold {
                color: var(--gold);
                border: 1px solid rgba(200, 168, 75, .4);
                padding: 7px 16px;
                margin-left: 8px
            }

            .nav-link-gold:hover {
                background: rgba(200, 168, 75, .12);
                color: var(--gold-light)
            }

            .hero {
                background: linear-gradient(145deg, var(--navy) 0%, var(--navy-med) 55%, var(--navy-light) 100%);
                min-height: 540px;
                display: flex;
                align-items: center;
                position: relative;
                overflow: hidden;
                padding: 60px 40px 100px
            }

            .hero-bg-decor {
                position: absolute;
                inset: 0;
                pointer-events: none
            }

            .hero-bg-decor::before {
                content: '';
                position: absolute;
                top: -100px;
                right: -100px;
                width: 600px;
                height: 600px;
                background: radial-gradient(ellipse, rgba(200, 168, 75, .12) 0%, transparent 70%);
                border-radius: 50%
            }

            .hero-bg-decor::after {
                content: '';
                position: absolute;
                bottom: -80px;
                left: -80px;
                width: 400px;
                height: 400px;
                background: radial-gradient(ellipse, rgba(41, 121, 232, .1) 0%, transparent 70%);
                border-radius: 50%
            }

            .hero-wave {
                position: absolute;
                bottom: -2px;
                left: 0;
                right: 0;
                height: 80px;
                background: var(--off-white);
                clip-path: ellipse(56% 100% at 50% 100%)
            }

            .hero-content {
                max-width: 1200px;
                margin: 0 auto;
                width: 100%;
                display: grid;
                grid-template-columns: 1fr auto;
                gap: 60px;
                align-items: center;
                position: relative;
                z-index: 2
            }

            .hero-tag {
                display: inline-flex;
                align-items: center;
                gap: 7px;
                background: rgba(200, 168, 75, .15);
                border: 1px solid rgba(200, 168, 75, .4);
                color: var(--gold-light);
                font-size: 11px;
                font-weight: 600;
                letter-spacing: .1em;
                text-transform: uppercase;
                padding: 5px 14px;
                border-radius: 20px;
                margin-bottom: 22px
            }

            .hero-title {
                font-family: 'Playfair Display', Georgia, serif;
                font-size: clamp(30px, 4vw, 52px);
                font-weight: 900;
                color: #fff;
                line-height: 1.12;
                margin-bottom: 18px
            }

            .hero-title span {
                color: var(--gold)
            }

            .hero-desc {
                color: rgba(255, 255, 255, .68);
                font-size: 16px;
                line-height: 1.7;
                max-width: 520px;
                margin-bottom: 34px
            }

            .hero-btns {
                display: flex;
                gap: 14px;
                flex-wrap: wrap
            }

            .btn-hero-primary {
                display: inline-flex;
                align-items: center;
                gap: 9px;
                background: linear-gradient(135deg, var(--gold) 0%, var(--gold-light) 100%);
                color: var(--navy);
                padding: 14px 28px;
                border-radius: 10px;
                font-size: 14px;
                font-weight: 700;
                text-decoration: none;
                box-shadow: 0 6px 22px rgba(200, 168, 75, .4);
                transition: var(--transition)
            }

            .btn-hero-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 10px 32px rgba(200, 168, 75, .55);
                color: var(--navy);
                text-decoration: none
            }

            .btn-hero-outline {
                display: inline-flex;
                align-items: center;
                gap: 9px;
                border: 1.5px solid rgba(255, 255, 255, .35);
                color: #fff;
                padding: 13px 26px;
                border-radius: 10px;
                font-size: 14px;
                font-weight: 600;
                text-decoration: none;
                transition: var(--transition)
            }

            .btn-hero-outline:hover {
                background: rgba(255, 255, 255, .1);
                border-color: rgba(255, 255, 255, .6);
                transform: translateY(-2px);
                color: #fff;
                text-decoration: none
            }

            .hero-quick-card {
                background: rgba(255, 255, 255, .08);
                backdrop-filter: blur(20px);
                border: 1px solid rgba(255, 255, 255, .15);
                border-radius: 20px;
                padding: 28px 26px;
                min-width: 300px;
                max-width: 320px
            }

            .hero-quick-title {
                color: #fff;
                font-size: 14px;
                font-weight: 700;
                margin-bottom: 6px;
                display: flex;
                align-items: center;
                gap: 8px
            }

            .hero-quick-title i {
                color: var(--gold)
            }

            .hero-quick-sub {
                color: rgba(255, 255, 255, .5);
                font-size: 12px;
                margin-bottom: 18px
            }

            .quick-input-wrap {
                position: relative;
                margin-bottom: 12px
            }

            .quick-input-wrap i {
                position: absolute;
                left: 14px;
                top: 50%;
                transform: translateY(-50%);
                color: rgba(255, 255, 255, .4);
                font-size: 14px;
                pointer-events: none
            }

            .quick-input {
                width: 100%;
                background: rgba(255, 255, 255, .12);
                border: 1.5px solid rgba(255, 255, 255, .2);
                border-radius: 10px;
                padding: 12px 14px 12px 40px;
                color: #fff;
                font-family: 'DM Sans', sans-serif;
                font-size: 15px;
                font-weight: 500;
                outline: none;
                transition: var(--transition)
            }

            .quick-input::placeholder {
                color: rgba(255, 255, 255, .35);
                font-weight: 400
            }

            .quick-input:focus {
                border-color: var(--gold);
                background: rgba(255, 255, 255, .16)
            }

            .btn-quick-submit {
                width: 100%;
                background: linear-gradient(135deg, var(--gold) 0%, #d4b05a 100%);
                color: var(--navy);
                border: none;
                padding: 12px;
                border-radius: 10px;
                font-family: 'DM Sans', sans-serif;
                font-size: 14px;
                font-weight: 700;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
                transition: var(--transition);
                box-shadow: 0 4px 14px rgba(200, 168, 75, .35)
            }

            .btn-quick-submit:hover {
                transform: translateY(-1px);
                box-shadow: 0 8px 22px rgba(200, 168, 75, .5)
            }

            .quick-disclaimer {
                color: rgba(255, 255, 255, .38);
                font-size: 10.5px;
                text-align: center;
                margin-top: 10px;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 5px
            }

            /* STATS */
            .stats-bar {
                background: var(--white);
                border-bottom: 1px solid var(--border);
                padding: 24px 40px
            }

            .stats-bar-inner {
                max-width: 1200px;
                margin: 0 auto;
                display: grid;
                grid-template-columns: repeat(4, 1fr)
            }

            .stat-item {
                display: flex;
                align-items: center;
                gap: 16px;
                padding: 0 32px;
                border-right: 1px solid var(--border)
            }

            .stat-item:first-child {
                padding-left: 0
            }

            .stat-item:last-child {
                border-right: none
            }

            .stat-icon {
                width: 48px;
                height: 48px;
                border-radius: 12px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 20px;
                flex-shrink: 0
            }

            .stat-icon-blue {
                background: linear-gradient(135deg, #ddeeff, #edf4fd);
                color: #1a5a9a
            }

            .stat-icon-gold {
                background: linear-gradient(135deg, #fef8e2, #fff3cc);
                color: #9a6200
            }

            .stat-icon-green {
                background: linear-gradient(135deg, #dff7ed, #e8f8f1);
                color: #1a7a4a
            }

            .stat-icon-navy {
                background: linear-gradient(135deg, #e8ecf5, #dde3f0);
                color: var(--navy-med)
            }

            .stat-num {
                font-size: 28px;
                font-weight: 800;
                color: var(--navy);
                line-height: 1
            }

            .stat-lbl {
                font-size: 12px;
                color: var(--muted);
                margin-top: 3px
            }

            /* SECTIONS */
            .section {
                padding: 70px 40px
            }

            .section-inner {
                max-width: 1200px;
                margin: 0 auto
            }

            .section-alt {
                background: #fff
            }

            .section-dark {
                background: linear-gradient(145deg, var(--navy) 0%, var(--navy-med) 100%);
                color: #fff
            }

            .section-label {
                font-size: 11px;
                font-weight: 700;
                letter-spacing: .14em;
                text-transform: uppercase;
                color: var(--blue);
                margin-bottom: 10px;
                display: flex;
                align-items: center;
                gap: 7px
            }

            .section-label::before {
                content: '';
                width: 20px;
                height: 2px;
                background: var(--blue);
                border-radius: 2px
            }

            .section-label-white {
                color: rgba(255, 255, 255, .7)
            }

            .section-label-white::before {
                background: rgba(255, 255, 255, .5)
            }

            .section-title {
                font-family: 'Playfair Display', serif;
                font-size: clamp(26px, 3vw, 38px);
                font-weight: 900;
                color: var(--navy);
                line-height: 1.18;
                margin-bottom: 14px
            }

            .section-title-white {
                color: #fff
            }

            .section-title span {
                color: var(--blue)
            }

            .section-title-white span {
                color: var(--gold)
            }

            .section-desc {
                color: var(--muted);
                font-size: 15px;
                line-height: 1.7;
                max-width: 580px;
                margin-bottom: 44px
            }

            .section-desc-white {
                color: rgba(255, 255, 255, .65)
            }

            /* SERVICES */
            .services-grid {
                display: grid;
                grid-template-columns: repeat(3, 1fr);
                gap: 20px
            }

            .service-card {
                background: #fff;
                border-radius: var(--radius);
                padding: 28px 24px;
                border: 1.5px solid var(--border);
                transition: var(--transition);
                position: relative;
                overflow: hidden;
                text-decoration: none;
                color: inherit;
                display: block
            }

            .service-card::before {
                content: '';
                position: absolute;
                bottom: 0;
                left: 0;
                right: 0;
                height: 3px;
                background: linear-gradient(90deg, var(--navy), var(--blue));
                transform: scaleX(0);
                transform-origin: left;
                transition: var(--transition)
            }

            .service-card:hover {
                border-color: rgba(41, 121, 232, .35);
                box-shadow: var(--shadow-lg);
                transform: translateY(-4px);
                color: inherit;
                text-decoration: none
            }

            .service-card:hover::before {
                transform: scaleX(1)
            }

            .service-icon {
                width: 52px;
                height: 52px;
                border-radius: 13px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 22px;
                margin-bottom: 18px
            }

            .si-blue {
                background: linear-gradient(135deg, #ddeeff, #edf4fd);
                color: var(--navy-light)
            }

            .si-navy {
                background: linear-gradient(135deg, #e8ecf5, #dde3f0);
                color: var(--navy)
            }

            .si-gold {
                background: linear-gradient(135deg, #fef8e2, #fff3cc);
                color: #9a6200
            }

            .si-green {
                background: linear-gradient(135deg, #dff7ed, #e8f8f1);
                color: #1a7a4a
            }

            .si-red {
                background: linear-gradient(135deg, #fde8e8, #fdf0f0);
                color: #c0392b
            }

            .si-purple {
                background: linear-gradient(135deg, #ede8fd, #f0edf9);
                color: #6040b0
            }

            .service-title {
                font-size: 15px;
                font-weight: 700;
                color: var(--navy);
                margin-bottom: 8px
            }

            .service-desc {
                font-size: 13px;
                color: var(--muted);
                line-height: 1.6;
                margin-bottom: 16px
            }

            .service-link {
                font-size: 12.5px;
                font-weight: 600;
                color: var(--blue);
                display: flex;
                align-items: center;
                gap: 5px;
                transition: gap var(--transition)
            }

            .service-card:hover .service-link {
                gap: 9px
            }

            /* CONSULT FEATURED */
            .consult-featured {
                background: linear-gradient(145deg, var(--navy) 0%, var(--navy-light) 100%);
                border-radius: 24px;
                padding: 52px;
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 48px;
                align-items: center;
                position: relative;
                overflow: hidden
            }

            .consult-featured::before {
                content: '';
                position: absolute;
                top: -80px;
                right: -80px;
                width: 400px;
                height: 400px;
                background: radial-gradient(ellipse, rgba(200, 168, 75, .15) 0%, transparent 70%);
                border-radius: 50%;
                pointer-events: none
            }

            .consult-steps {
                display: flex;
                flex-direction: column;
                gap: 22px;
                margin-top: 28px
            }

            .consult-step {
                display: flex;
                align-items: flex-start;
                gap: 14px
            }

            .step-num {
                width: 34px;
                height: 34px;
                background: rgba(200, 168, 75, .18);
                border: 1.5px solid rgba(200, 168, 75, .45);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 13px;
                font-weight: 800;
                color: var(--gold);
                flex-shrink: 0
            }

            .step-text strong {
                display: block;
                color: #fff;
                font-size: 14px;
                margin-bottom: 2px
            }

            .step-text p {
                color: rgba(255, 255, 255, .55);
                font-size: 12.5px;
                line-height: 1.5
            }

            .consult-form-card {
                background: rgba(255, 255, 255, .06);
                border: 1px solid rgba(255, 255, 255, .12);
                border-radius: 18px;
                padding: 36px 32px;
                backdrop-filter: blur(16px);
                position: relative;
                z-index: 1
            }

            .cf-title {
                color: #fff;
                font-size: 18px;
                font-weight: 700;
                margin-bottom: 6px;
                display: flex;
                align-items: center;
                gap: 10px
            }

            .cf-title i {
                color: var(--gold)
            }

            .cf-sub {
                color: rgba(255, 255, 255, .5);
                font-size: 13px;
                margin-bottom: 24px
            }

            .cf-label {
                display: block;
                color: rgba(255, 255, 255, .6);
                font-size: 11px;
                font-weight: 600;
                letter-spacing: .07em;
                text-transform: uppercase;
                margin-bottom: 8px
            }

            .cf-input-wrap {
                position: relative;
                margin-bottom: 16px
            }

            .cf-input-wrap i {
                position: absolute;
                left: 15px;
                top: 50%;
                transform: translateY(-50%);
                color: rgba(255, 255, 255, .4);
                font-size: 14px;
                pointer-events: none
            }

            .cf-input {
                width: 100%;
                background: rgba(255, 255, 255, .1);
                border: 1.5px solid rgba(255, 255, 255, .18);
                border-radius: 10px;
                padding: 13px 14px 13px 42px;
                color: #fff;
                font-family: 'DM Sans', sans-serif;
                font-size: 16px;
                font-weight: 500;
                outline: none;
                transition: var(--transition)
            }

            .cf-input::placeholder {
                color: rgba(255, 255, 255, .3);
                font-weight: 400
            }

            .cf-input:focus {
                border-color: var(--gold);
                background: rgba(255, 255, 255, .14)
            }

            .btn-cf-submit {
                width: 100%;
                background: linear-gradient(135deg, var(--gold) 0%, #d4b05a 100%);
                color: var(--navy);
                border: none;
                padding: 14px;
                border-radius: 10px;
                font-family: 'DM Sans', sans-serif;
                font-size: 15px;
                font-weight: 700;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 9px;
                transition: var(--transition);
                box-shadow: 0 5px 16px rgba(200, 168, 75, .4);
                margin-bottom: 12px
            }

            .btn-cf-submit:hover {
                transform: translateY(-2px);
                box-shadow: 0 10px 28px rgba(200, 168, 75, .55)
            }

            .cf-disclaimer {
                text-align: center;
                color: rgba(255, 255, 255, .38);
                font-size: 11px;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 5px
            }

            /* INFO */
            .info-grid {
                display: grid;
                grid-template-columns: repeat(2, 1fr);
                gap: 20px
            }

            .info-card {
                background: rgba(255, 255, 255, .06);
                border: 1px solid rgba(255, 255, 255, .1);
                border-radius: var(--radius);
                padding: 24px;
                transition: var(--transition)
            }

            .info-card:hover {
                background: rgba(255, 255, 255, .1);
                transform: translateY(-2px)
            }

            .info-card-icon {
                font-size: 28px;
                margin-bottom: 14px
            }

            .info-card-title {
                color: #fff;
                font-size: 15px;
                font-weight: 700;
                margin-bottom: 6px
            }

            .info-card-text {
                color: rgba(255, 255, 255, .55);
                font-size: 13px;
                line-height: 1.6
            }

            /* MESA CTA */
            .mesa-cta {
                background: linear-gradient(135deg, #fff 0%, #f0f5ff 100%);
                border: 2px solid rgba(41, 121, 232, .2);
                border-radius: 20px;
                padding: 40px;
                display: flex;
                align-items: center;
                justify-content: space-between;
                gap: 24px
            }

            .mesa-cta-left {
                flex: 1
            }

            .mesa-cta-tag {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                background: rgba(41, 121, 232, .1);
                border: 1px solid rgba(41, 121, 232, .25);
                color: var(--navy-light);
                font-size: 11px;
                font-weight: 700;
                letter-spacing: .09em;
                text-transform: uppercase;
                padding: 4px 12px;
                border-radius: 14px;
                margin-bottom: 12px
            }

            .mesa-cta-title {
                font-family: 'Playfair Display', serif;
                font-size: 24px;
                font-weight: 900;
                color: var(--navy);
                margin-bottom: 8px
            }

            .mesa-cta-desc {
                color: var(--muted);
                font-size: 14px;
                line-height: 1.6
            }

            .btn-mesa-cta {
                display: inline-flex;
                align-items: center;
                gap: 9px;
                background: linear-gradient(135deg, var(--navy) 0%, var(--navy-med) 100%);
                color: #fff;
                padding: 14px 32px;
                border-radius: 10px;
                font-size: 15px;
                font-weight: 700;
                text-decoration: none;
                box-shadow: 0 6px 20px rgba(11, 35, 70, .28);
                white-space: nowrap;
                transition: var(--transition)
            }

            .btn-mesa-cta:hover {
                transform: translateY(-2px);
                box-shadow: 0 10px 30px rgba(11, 35, 70, .38);
                color: #fff;
                text-decoration: none
            }

            /* NOTICES */
            .notices-grid {
                display: grid;
                grid-template-columns: repeat(3, 1fr);
                gap: 20px;
                margin-top: 40px
            }

            .notice-card {
                background: #fff;
                border-radius: var(--radius);
                border: 1.5px solid var(--border);
                overflow: hidden;
                transition: var(--transition)
            }

            .notice-card:hover {
                box-shadow: var(--shadow-lg);
                transform: translateY(-3px)
            }

            .notice-header {
                padding: 14px 20px 12px;
                display: flex;
                align-items: center;
                gap: 10px;
                border-bottom: 1px solid var(--border)
            }

            .notice-icon {
                width: 34px;
                height: 34px;
                border-radius: 8px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 14px;
                flex-shrink: 0
            }

            .ni-blue {
                background: #edf4fd;
                color: var(--navy-light)
            }

            .ni-gold {
                background: #fef8e2;
                color: #9a6200
            }

            .ni-green {
                background: #e8f8f1;
                color: #1a7a4a
            }

            .notice-badge {
                font-size: 10px;
                font-weight: 700;
                padding: 3px 9px;
                border-radius: 10px;
                margin-left: auto
            }

            .nb-blue {
                background: #edf4fd;
                color: var(--navy-light)
            }

            .nb-gold {
                background: #fef8e2;
                color: #9a6200
            }

            .nb-green {
                background: #e8f8f1;
                color: #1a7a4a
            }

            .notice-body {
                padding: 18px 20px 20px
            }

            .notice-title {
                font-size: 14px;
                font-weight: 700;
                color: var(--navy);
                margin-bottom: 8px
            }

            .notice-text {
                font-size: 13px;
                color: var(--muted);
                line-height: 1.6;
                margin-bottom: 14px
            }

            .notice-date {
                font-size: 11.5px;
                color: rgba(90, 106, 122, .6);
                display: flex;
                align-items: center;
                gap: 5px
            }

            /* CONTACT */
            .contact-row {
                display: grid;
                grid-template-columns: repeat(3, 1fr);
                gap: 20px;
                margin-top: 16px
            }

            .contact-card {
                background: rgba(255, 255, 255, .06);
                border: 1px solid rgba(255, 255, 255, .1);
                border-radius: var(--radius);
                padding: 24px;
                text-align: center;
                transition: var(--transition)
            }

            .contact-card:hover {
                background: rgba(255, 255, 255, .1);
                transform: translateY(-3px)
            }

            .contact-icon {
                width: 56px;
                height: 56px;
                background: rgba(200, 168, 75, .15);
                border: 1.5px solid rgba(200, 168, 75, .4);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 16px;
                font-size: 22px;
                color: var(--gold)
            }

            .contact-label {
                color: rgba(255, 255, 255, .5);
                font-size: 11px;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: .09em;
                margin-bottom: 6px
            }

            .contact-val {
                color: #fff;
                font-size: 14px;
                font-weight: 600;
                line-height: 1.5
            }

            /* FOOTER */
            .footer {
                background: #080f1c;
                padding: 40px 40px 24px
            }

            .footer-inner {
                max-width: 1200px;
                margin: 0 auto;
                display: grid;
                grid-template-columns: 2fr 1fr 1fr;
                gap: 40px;
                padding-bottom: 32px;
                border-bottom: 1px solid rgba(255, 255, 255, .07);
                margin-bottom: 24px
            }

            .footer-brand {
                display: flex;
                align-items: center;
                gap: 12px;
                margin-bottom: 14px
            }

            .footer-logo {
                width: 40px;
                height: 40px;
                background: linear-gradient(135deg, var(--gold), var(--gold-light));
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center
            }

            .footer-logo i {
                color: var(--navy);
                font-size: 16px
            }

            .footer-brand-name {
                color: #fff;
                font-size: 13px;
                font-weight: 700
            }

            .footer-brand-sub {
                color: rgba(255, 255, 255, .4);
                font-size: 10.5px;
                text-transform: uppercase;
                letter-spacing: .08em
            }

            .footer-about {
                color: rgba(255, 255, 255, .45);
                font-size: 13px;
                line-height: 1.7
            }

            .footer-col-title {
                color: rgba(255, 255, 255, .6);
                font-size: 11px;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: .1em;
                margin-bottom: 14px
            }

            .footer-links {
                display: flex;
                flex-direction: column;
                gap: 9px
            }

            .footer-link {
                color: rgba(255, 255, 255, .45);
                text-decoration: none;
                font-size: 13px;
                display: flex;
                align-items: center;
                gap: 7px;
                transition: color var(--transition)
            }

            .footer-link:hover {
                color: var(--gold-light);
                text-decoration: none
            }

            .footer-link i {
                font-size: 11px;
                color: rgba(200, 168, 75, .5)
            }

            .footer-bottom {
                max-width: 1200px;
                margin: 0 auto;
                display: flex;
                justify-content: space-between;
                align-items: center;
                flex-wrap: wrap;
                gap: 12px
            }

            .footer-copy {
                color: rgba(255, 255, 255, .3);
                font-size: 12px
            }

            .footer-copy span {
                color: var(--gold)
            }

            .footer-tricolor {
                height: 3px;
                width: 120px;
                background: linear-gradient(90deg, #ffd900 33.33%, #003087 33.33% 66.66%, #ce1126 66.66%);
                border-radius: 2px
            }

            @keyframes fadeUp {
                from {
                    opacity: 0;
                    transform: translateY(24px)
                }

                to {
                    opacity: 1;
                    transform: none
                }
            }

            .fade-up {
                animation: fadeUp .5s ease both
            }

            .delay-1 {
                animation-delay: .1s
            }

            .delay-2 {
                animation-delay: .2s
            }

            .delay-3 {
                animation-delay: .3s
            }

            @media(max-width:900px) {
                .hero-content {
                    grid-template-columns: 1fr
                }

                .hero-quick-card {
                    display: none
                }

                .services-grid {
                    grid-template-columns: 1fr 1fr
                }

                .stats-bar-inner {
                    grid-template-columns: repeat(2, 1fr);
                    gap: 20px
                }

                .stat-item {
                    padding: 0 20px
                }

                .consult-featured {
                    grid-template-columns: 1fr
                }

                .info-grid {
                    grid-template-columns: 1fr
                }

                .contact-row {
                    grid-template-columns: 1fr
                }

                .notices-grid {
                    grid-template-columns: 1fr
                }

                .footer-inner {
                    grid-template-columns: 1fr;
                    gap: 28px
                }
            }

            @media(max-width:600px) {
                .navbar {
                    padding: 0 20px
                }

                .nav-links {
                    display: none
                }

                .hero {
                    padding: 44px 20px 90px
                }

                .section {
                    padding: 48px 20px
                }

                .services-grid {
                    grid-template-columns: 1fr
                }

                .mesa-cta {
                    flex-direction: column;
                    align-items: flex-start
                }

                .stats-bar {
                    padding: 20px
                }

                .consult-featured {
                    padding: 28px 22px
                }

                .footer {
                    padding: 32px 20px 20px
                }
            }

            /* ── Voting Dates Carousel ── */
            .vote-date-item {
                display: flex;
                align-items: center;
                gap: 14px;
                padding: 12px 14px;
                border-radius: 12px;
                background: rgba(255, 255, 255, .06);
                border: 1px solid rgba(255, 255, 255, .1);
                margin-bottom: 10px;
                cursor: pointer;
                transition: all .4s cubic-bezier(.4, 0, .2, 1);
                opacity: .5;
                transform: scale(.96);
                position: relative;
                overflow: hidden;
            }

            .vote-date-item.active {
                opacity: 1;
                transform: scale(1);
                background: rgba(200, 168, 75, .12);
                border-color: rgba(200, 168, 75, .4);
                box-shadow: 0 4px 16px rgba(200, 168, 75, .2);
            }

            .vote-date-item::before {
                content: '';
                position: absolute;
                left: 0;
                top: 0;
                bottom: 0;
                width: 3px;
                background: var(--gold);
                transform: scaleY(0);
                transition: transform .3s ease;
                border-radius: 0 2px 2px 0;
            }

            .vote-date-item.active::before {
                transform: scaleY(1);
            }

            .vote-date-item:hover {
                background: rgba(255, 255, 255, .1);
                transform: scale(1);
                opacity: 1;
            }

            .vote-date-badge {
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                width: 44px;
                height: 44px;
                background: rgba(255, 255, 255, .1);
                border-radius: 10px;
                border: 1px solid rgba(255, 255, 255, .15);
                flex-shrink: 0;
                transition: all .3s ease;
            }

            .vote-date-item.active .vote-date-badge {
                background: rgba(200, 168, 75, .2);
                border-color: rgba(200, 168, 75, .5);
            }

            .vote-day {
                color: #fff;
                font-size: 16px;
                font-weight: 800;
                line-height: 1;
            }

            .vote-month {
                color: rgba(255, 255, 255, .6);
                font-size: 9px;
                font-weight: 700;
                letter-spacing: .08em;
                text-transform: uppercase;
                margin-top: 2px;
            }

            .vote-date-item.active .vote-month {
                color: var(--gold-light);
            }

            .vote-date-info {
                flex: 1;
                min-width: 0;
            }

            .vote-date-info strong {
                display: block;
                color: #fff;
                font-size: 13px;
                font-weight: 700;
                margin-bottom: 2px;
            }

            .vote-date-info span {
                color: rgba(255, 255, 255, .45);
                font-size: 11px;
            }

            .vote-date-item.active .vote-date-info span {
                color: rgba(255, 255, 255, .65);
            }

            .vote-arrow {
                color: rgba(255, 255, 255, .3);
                font-size: 12px;
                transition: all .3s ease;
                transform: translateX(-4px);
                opacity: 0;
            }

            .vote-date-item.active .vote-arrow {
                color: var(--gold);
                transform: translateX(0);
                opacity: 1;
            }

            .vote-dots {
                display: flex;
                justify-content: center;
                gap: 6px;
                margin: 14px 0 16px;
            }

            .vote-dot {
                width: 6px;
                height: 6px;
                border-radius: 50%;
                background: rgba(255, 255, 255, .25);
                transition: all .3s ease;
                cursor: pointer;
            }

            .vote-dot.active {
                background: var(--gold);
                width: 18px;
                border-radius: 3px;
            }

            .consult-cta-icon {
                width: 72px;
                height: 72px;
                border-radius: 50%;
                background: rgba(200, 168, 75, .15);
                border: 2px solid rgba(200, 168, 75, .35);
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 8px auto 0;
                font-size: 28px;
                color: var(--gold);
                animation: ctaPulse 2s ease-in-out infinite;
            }

            @keyframes ctaPulse {

                0%,
                100% {
                    box-shadow: 0 0 0 0 rgba(200, 168, 75, .3);
                }

                50% {
                    box-shadow: 0 0 0 12px rgba(200, 168, 75, 0);
                }
            }

            @keyframes voteSlideIn {
                from {
                    opacity: 0;
                    transform: translateX(20px);
                }

                to {
                    opacity: 1;
                    transform: translateX(0);
                }
            }

            .vote-date-item.active {
                animation: voteSlideIn .4s ease both;
            }
        </style>
    </head>

    <body>

        <div class="banda-gov"></div>

        <nav class="navbar">
            <a href="${pageContext.request.contextPath}/" class="nav-brand">
                <div class="nav-logo-ring"><i class="fas fa-landmark"></i></div>
                <div class="nav-brand-text">
                    <strong>Registraduría de Nobsa</strong>
                    <span>Boyacá · Colombia</span>
                </div>
            </a>
            <div class="nav-links">
                <a href="#servicios" class="nav-link"><i class="fas fa-grid-2"></i> Servicios</a>
                <a href="#informacion" class="nav-link"><i class="fas fa-circle-info"></i> Información</a>
                <a href="#contacto" class="nav-link"><i class="fas fa-phone"></i> Contacto</a>
                <a href="${pageContext.request.contextPath}/consultaMesa" class="nav-link nav-link-gold">
                    <i class="fas fa-search"></i> Consultar Mesa
                </a>
                <a href="${pageContext.request.contextPath}/login" class="nav-link" style="margin-left:4px;">
                    <i class="fas fa-shield-halved"></i> Admin
                </a>
            </div>
        </nav>

        <section class="hero">
            <div class="hero-bg-decor"></div>
            <div class="hero-wave"></div>
            <div class="hero-content">
                <div class="fade-up">
                    <div class="hero-tag"><i class="fas fa-vote-yea"></i> Elecciones Colombia 2026</div>
                    <h1 class="hero-title">Registraduría<br>Municipal de <span>Nobsa</span></h1>
                    <p class="hero-desc">Servicio oficial de consulta electoral y gestión documental para los ciudadanos
                        del municipio de Nobsa, Boyacá. Encuentra tu mesa de votación de forma rápida y segura.</p>
                    <div class="hero-btns">
                        <a href="${pageContext.request.contextPath}/consultaMesa" class="btn-hero-primary">
                            <i class="fas fa-magnifying-glass"></i> Consultar mi Mesa
                        </a>
                        <a href="#servicios" class="btn-hero-outline">
                            <i class="fas fa-grid-2"></i> Ver Servicios
                        </a>
                    </div>
                </div>
                <div class="hero-quick-card fade-up delay-2" id="voting-dates-card">
                    <div class="hero-quick-title"><i class="fas fa-calendar-star"></i> Próximas votaciones</div>
                    <p class="hero-quick-sub">Fechas oficiales del calendario electoral 2026</p>

                    <div class="vote-date-item active" data-index="0">
                        <div class="vote-date-badge">
                            <span class="vote-day">25</span>
                            <span class="vote-month">MAY</span>
                        </div>
                        <div class="vote-date-info">
                            <strong>Elecciones Presidenciales</strong>
                            <span>1ra vuelta · 2026</span>
                        </div>
                        <i class="fas fa-chevron-right vote-arrow"></i>
                    </div>

                    <div class="vote-date-item" data-index="1">
                        <div class="vote-date-badge">
                            <span class="vote-day">15</span>
                            <span class="vote-month">JUN</span>
                        </div>
                        <div class="vote-date-info">
                            <strong>2da Vuelta (si aplica)</strong>
                            <span>Segunda vuelta · 2026</span>
                        </div>
                        <i class="fas fa-chevron-right vote-arrow"></i>
                    </div>

                    <div class="vote-date-item" data-index="2">
                        <div class="vote-date-badge">
                            <span class="vote-day">25</span>
                            <span class="vote-month">OCT</span>
                        </div>
                        <div class="vote-date-info">
                            <strong>Consultas Partidistas</strong>
                            <span>Internas · 2026</span>
                        </div>
                        <i class="fas fa-chevron-right vote-arrow"></i>
                    </div>

                    <div class="vote-dots">
                        <span class="vote-dot active"></span>
                        <span class="vote-dot"></span>
                        <span class="vote-dot"></span>
                    </div>

                    <a href="${pageContext.request.contextPath}/consultaMesa" class="btn-quick-submit"
                        style="text-decoration:none;">
                        <i class="fas fa-magnifying-glass"></i> Consultar mi mesa
                    </a>
                </div>
            </div>
        </section>

        <div class="stats-bar">
            <div class="stats-bar-inner">
                <div class="stat-item">
                    <div class="stat-icon stat-icon-blue"><i class="fas fa-users"></i></div>
                    <div>
                        <div class="stat-num">12,400+</div>
                        <div class="stat-lbl">Ciudadanos registrados</div>
                    </div>
                </div>
                <div class="stat-item">
                    <div class="stat-icon stat-icon-gold"><i class="fas fa-chair"></i></div>
                    <div>
                        <div class="stat-num">38</div>
                        <div class="stat-lbl">Mesas de votación</div>
                    </div>
                </div>
                <div class="stat-item">
                    <div class="stat-icon stat-icon-green"><i class="fas fa-building"></i></div>
                    <div>
                        <div class="stat-num">5</div>
                        <div class="stat-lbl">Puestos de votación</div>
                    </div>
                </div>
                <div class="stat-item">
                    <div class="stat-icon stat-icon-navy"><i class="fas fa-layer-group"></i></div>
                    <div>
                        <div class="stat-num">3</div>
                        <div class="stat-lbl">Zonas electorales</div>
                    </div>
                </div>
            </div>
        </div>

        <section class="section" id="servicios">
            <div class="section-inner">
                <div class="section-label"><i class="fas fa-grid-2" style="font-size:10px;"></i> Servicios</div>
                <h2 class="section-title">¿En qué podemos <span>ayudarte?</span></h2>
                <p class="section-desc">Accede a todos los servicios de la Registraduría Municipal de Nobsa de forma
                    rápida y sencilla.</p>
                <div class="services-grid">
                    <a href="${pageContext.request.contextPath}/consultaMesa" class="service-card">
                        <div class="service-icon si-blue"><i class="fas fa-magnifying-glass"></i></div>
                        <div class="service-title">Consulta de Mesa de Votación</div>
                        <p class="service-desc">Ingresa tu cédula y conoce tu puesto, zona y mesa asignada para las
                            elecciones 2026.</p>
                        <div class="service-link">Consultar ahora <i class="fas fa-arrow-right"></i></div>
                    </a>
                    <div class="service-card" style="cursor:default;">
                        <div class="service-icon si-navy"><i class="fas fa-id-card"></i></div>
                        <div class="service-title">Cédula de Ciudadanía</div>
                        <p class="service-desc">Tramita tu cédula por primera vez, renuévala o realiza correcciones.
                            Agenda tu cita directamente en la oficina.</p>
                        <div class="service-link" style="color:var(--muted);">Atención presencial <i
                                class="fas fa-building"></i></div>
                    </div>
                    <div class="service-card" style="cursor:default;">
                        <div class="service-icon si-gold"><i class="fas fa-book-open"></i></div>
                        <div class="service-title">Registro Civil</div>
                        <p class="service-desc">Solicita copias de nacimiento, matrimonio o defunción con validez
                            nacional para todos los trámites.</p>
                        <div class="service-link" style="color:var(--muted);">Atención presencial <i
                                class="fas fa-building"></i></div>
                    </div>
                    <div class="service-card" style="cursor:default;">
                        <div class="service-icon si-green"><i class="fas fa-user-plus"></i></div>
                        <div class="service-title">Inscripción Electoral</div>
                        <p class="service-desc">Inscríbete para votar o solicita traslado de municipio antes de las
                            fechas límite establecidas.</p>
                        <div class="service-link" style="color:var(--muted);">Atención presencial <i
                                class="fas fa-building"></i></div>
                    </div>
                    <div class="service-card" style="cursor:default;">
                        <div class="service-icon si-red"><i class="fas fa-id-badge"></i></div>
                        <div class="service-title">Tarjeta de Identidad</div>
                        <p class="service-desc">Documento de identificación para jóvenes entre 7 y 17 años, primer paso
                            hacia la ciudadanía plena.</p>
                        <div class="service-link" style="color:var(--muted);">Atención presencial <i
                                class="fas fa-building"></i></div>
                    </div>
                    <div class="service-card" style="cursor:default;">
                        <div class="service-icon si-purple"><i class="fas fa-file-alt"></i></div>
                        <div class="service-title">Certificaciones</div>
                        <p class="service-desc">Obtén certificados de inscripción, constancias electorales y documentos
                            con validez para trámites oficiales.</p>
                        <div class="service-link" style="color:var(--muted);">Atención presencial <i
                                class="fas fa-building"></i></div>
                    </div>
                </div>
            </div>
        </section>

        <section class="section section-alt">
            <div class="section-inner">
                <div class="consult-featured">
                    <div>
                        <div class="section-label section-label-white"><i class="fas fa-vote-yea"
                                style="font-size:10px;"></i> Elecciones 2026</div>
                        <h2 class="section-title section-title-white">¿Cómo consultar<br>tu <span>mesa de
                                votación</span>?</h2>
                        <p class="section-desc section-desc-white">El proceso es completamente digital, gratuito y solo
                            toma unos segundos.</p>
                        <div class="consult-steps">
                            <div class="consult-step">
                                <div class="step-num">1</div>
                                <div class="step-text">
                                    <strong>Ingresa tu número de documento</strong>
                                    <p>Tu cédula de ciudadanía o tarjeta de identidad, sin puntos ni espacios.</p>
                                </div>
                            </div>
                            <div class="consult-step">
                                <div class="step-num">2</div>
                                <div class="step-text">
                                    <strong>Completa la verificación de seguridad</strong>
                                    <p>Resuelve el captcha para confirmar que eres un ciudadano real.</p>
                                </div>
                            </div>
                            <div class="consult-step">
                                <div class="step-num">3</div>
                                <div class="step-text">
                                    <strong>Conoce tu puesto y mesa</strong>
                                    <p>Recibirás el comprobante en tu correo registrado en formato PDF.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="consult-form-card" style="text-align:center;">
                        <div class="cf-title" style="justify-content:center;"><i class="fas fa-chair"></i> Consulta tu
                            mesa</div>
                        <p class="cf-sub">Servicio disponible 24 horas, todos los días</p>

                        <div class="consult-cta-icon">
                            <i class="fas fa-magnifying-glass-location"></i>
                        </div>
                        <p style="color:rgba(255,255,255,.6);font-size:13px;margin:16px 0 24px;line-height:1.6;">
                            Encuentra tu puesto, zona y número de mesa de votación de forma rápida y segura.
                        </p>

                        <a href="${pageContext.request.contextPath}/consultaMesa" class="btn-cf-submit"
                            style="text-decoration:none;display:inline-flex;width:auto;padding:14px 32px;">
                            <i class="fas fa-magnifying-glass"></i> Ir a consulta de mesa
                        </a>
                        <p class="cf-disclaimer"><i class="fas fa-lock" style="font-size:10px;"></i> Información
                            protegida · Ley 1581 de 2012</p>
                    </div>
                </div>
            </div>
        </section>

        <section class="section section-dark" id="informacion">
            <div class="section-inner">
                <div class="section-label section-label-white"><i class="fas fa-circle-info"
                        style="font-size:10px;"></i> Información importante</div>
                <h2 class="section-title section-title-white">Todo lo que necesitas <span>saber</span></h2>
                <p class="section-desc section-desc-white">Documentos, fechas y requisitos para participar en el proceso
                    electoral de forma informada.</p>
                <div class="info-grid">
                    <div class="info-card">
                        <div class="info-card-icon">📋</div>
                        <div class="info-card-title">Documentos para votar</div>
                        <p class="info-card-text">Presentar cédula de ciudadanía vigente (mayores de 18 años) o tarjeta
                            de identidad (jóvenes de 14 a 17 años). Solo se acepta documento original, no copias ni
                            digitales.</p>
                    </div>
                    <div class="info-card">
                        <div class="info-card-icon">⏰</div>
                        <div class="info-card-title">Horario de votación</div>
                        <p class="info-card-text">Las mesas abren de 8:00 AM a 4:00 PM el día de elecciones. Se
                            recomienda llegar con anticipación para evitar filas y garantizar tu participación.</p>
                    </div>
                    <div class="info-card">
                        <div class="info-card-icon">🔒</div>
                        <div class="info-card-title">Privacidad del voto</div>
                        <p class="info-card-text">El voto es secreto, universal y libre en Colombia. Ninguna persona
                            puede conocer tu preferencia electoral. Tu participación está protegida por la Constitución.
                        </p>
                    </div>
                    <div class="info-card">
                        <div class="info-card-icon">📍</div>
                        <div class="info-card-title">Cómo llegar a tu puesto</div>
                        <p class="info-card-text">Al consultar tu mesa, recibirás la dirección exacta del puesto de
                            votación. Lleva tu comprobante impreso o en tu correo electrónico el día de las elecciones.
                        </p>
                    </div>
                </div>
            </div>
        </section>

        <section class="section">
            <div class="section-inner">
                <div class="section-label"><i class="fas fa-bell" style="font-size:10px;"></i> Avisos oficiales</div>
                <h2 class="section-title">Noticias e <span>información</span> electoral</h2>
                <div class="notices-grid">
                    <div class="notice-card">
                        <div class="notice-header">
                            <div class="notice-icon ni-blue"><i class="fas fa-vote-yea"></i></div>
                            <span class="notice-badge nb-blue">Electoral</span>
                        </div>
                        <div class="notice-body">
                            <div class="notice-title">Consulta tu mesa para Elecciones 2026</div>
                            <p class="notice-text">El sistema de consulta está activo. Verifica tu puesto, zona y número
                                de mesa antes del día de las votaciones para planificar tu participación.</p>
                            <div class="notice-date"><i class="fas fa-calendar"></i> Disponible ahora · 2026</div>
                        </div>
                    </div>
                    <div class="notice-card">
                        <div class="notice-header">
                            <div class="notice-icon ni-gold"><i class="fas fa-id-card"></i></div>
                            <span class="notice-badge nb-gold">Cédulas</span>
                        </div>
                        <div class="notice-body">
                            <div class="notice-title">Actualización de datos de contacto</div>
                            <p class="notice-text">Si tu correo no está registrado o está desactualizado, acude
                                personalmente a la Registraduría para recibir notificaciones oficiales en el futuro.</p>
                            <div class="notice-date"><i class="fas fa-calendar"></i> Vigente · 2026</div>
                        </div>
                    </div>
                    <div class="notice-card">
                        <div class="notice-header">
                            <div class="notice-icon ni-green"><i class="fas fa-user-plus"></i></div>
                            <span class="notice-badge nb-green">Inscripción</span>
                        </div>
                        <div class="notice-body">
                            <div class="notice-title">Período de inscripción electoral</div>
                            <p class="notice-text">Los ciudadanos que deseen votar por primera vez o trasladarse de
                                municipio deben inscribirse dentro de los plazos establecidos por la Registraduría
                                Nacional.</p>
                            <div class="notice-date"><i class="fas fa-calendar"></i> Consultar fechas · 2026</div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section class="section section-alt" style="padding-top:0;padding-bottom:60px;">
            <div class="section-inner">
                <div class="mesa-cta">
                    <div class="mesa-cta-left">
                        <div class="mesa-cta-tag"><i class="fas fa-chair"></i> Mesa de Votación</div>
                        <div class="mesa-cta-title">¿Ya conoces tu mesa<br>de votación?</div>
                        <p class="mesa-cta-desc">Consulta ahora gratis y recibe el comprobante en tu correo. Listo en
                            menos de 30 segundos.</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/consultaMesa" class="btn-mesa-cta">
                        <i class="fas fa-magnifying-glass"></i> Consultar mi Mesa de Votación
                    </a>
                </div>
            </div>
        </section>

        <section class="section section-dark" id="contacto">
            <div class="section-inner">
                <div class="section-label section-label-white"><i class="fas fa-phone" style="font-size:10px;"></i>
                    Contacto</div>
                <h2 class="section-title section-title-white">¿Necesitas <span>ayuda?</span></h2>
                <p class="section-desc section-desc-white">El equipo de la Registraduría de Nobsa está disponible para
                    atenderte en horario de oficina.</p>
                <div class="contact-row">
                    <div class="contact-card">
                        <div class="contact-icon"><i class="fas fa-phone-alt"></i></div>
                        <div class="contact-label">Teléfono</div>
                        <div class="contact-val">(608) 770 0000</div>
                    </div>
                    <div class="contact-card">
                        <div class="contact-icon"><i class="fas fa-envelope"></i></div>
                        <div class="contact-label">Correo electrónico</div>
                        <div class="contact-val">registraduria@<br>nobsa-boyaca.gov.co</div>
                    </div>
                    <div class="contact-card">
                        <div class="contact-icon"><i class="fas fa-clock"></i></div>
                        <div class="contact-label">Horario de atención</div>
                        <div class="contact-val">Lun – Vie<br>8:00 AM – 4:00 PM</div>
                    </div>
                </div>
            </div>
        </section>

        <footer class="footer">
            <div class="footer-inner">
                <div>
                    <div class="footer-brand">
                        <div class="footer-logo"><i class="fas fa-landmark"></i></div>
                        <div>
                            <div class="footer-brand-name">Registraduría Municipal de Nobsa</div>
                            <div class="footer-brand-sub">Boyacá · Colombia</div>
                        </div>
                    </div>
                    <p class="footer-about">Entidad pública responsable del registro civil, identificación ciudadana y
                        organización de los procesos electorales en el municipio de Nobsa, Boyacá.</p>
                </div>
                <div>
                    <div class="footer-col-title">Servicios en línea</div>
                    <div class="footer-links">
                        <a href="${pageContext.request.contextPath}/consultaMesa" class="footer-link"><i
                                class="fas fa-chevron-right"></i> Consulta de Mesa</a>
                        <a href="${pageContext.request.contextPath}/login" class="footer-link"><i
                                class="fas fa-chevron-right"></i> Panel Administrativo</a>
                        <a href="#servicios" class="footer-link"><i class="fas fa-chevron-right"></i> Nuestros
                            Servicios</a>
                        <a href="#informacion" class="footer-link"><i class="fas fa-chevron-right"></i> Información
                            Electoral</a>
                    </div>
                </div>
                <div>
                    <div class="footer-col-title">Información legal</div>
                    <div class="footer-links">
                        <a href="https://www.registraduria.gov.co" target="_blank" class="footer-link"><i
                                class="fas fa-external-link"></i> Registraduría Nacional</a>
                        <a href="#" class="footer-link"><i class="fas fa-chevron-right"></i> Política de Privacidad</a>
                        <a href="#" class="footer-link"><i class="fas fa-chevron-right"></i> Ley 1581 de 2012</a>
                        <a href="#contacto" class="footer-link"><i class="fas fa-chevron-right"></i> Contáctenos</a>
                    </div>
                </div>
            </div>
            <div class="footer-bottom">
                <div class="footer-copy">© 2026 Registraduría Municipal de Nobsa · <span>Boyacá, Colombia</span> · Todos
                    los derechos reservados</div>
                <div class="footer-tricolor"></div>
            </div>
        </footer>

        <script>
            const CTX = '${pageContext.request.contextPath}';

            /* ── Voting Dates Carousel ── */
            (function () {
                const items = document.querySelectorAll('.vote-date-item');
                const dots = document.querySelectorAll('.vote-dot');
                let current = 0;
                let interval;

                function show(idx) {
                    items.forEach((it, i) => {
                        it.classList.toggle('active', i === idx);
                        it.style.animation = 'none';
                        if (i === idx) {
                            void it.offsetWidth; // reflow
                            it.style.animation = 'voteSlideIn .4s ease both';
                        }
                    });
                    dots.forEach((d, i) => d.classList.toggle('active', i === idx));
                    current = idx;
                }

                function next() {
                    show((current + 1) % items.length);
                }

                function start() {
                    interval = setInterval(next, 4000);
                }

                items.forEach((it, i) => {
                    it.addEventListener('click', () => {
                        clearInterval(interval);
                        show(i);
                        start();
                    });
                });

                dots.forEach((d, i) => {
                    d.addEventListener('click', () => {
                        clearInterval(interval);
                        show(i);
                        start();
                    });
                });

                start();
            })();

            // Scroll reveal
            const observer = new IntersectionObserver(entries => {
                entries.forEach(el => {
                    if (el.isIntersecting) {
                        el.target.style.opacity = '1';
                        el.target.style.transform = 'translateY(0)';
                        observer.unobserve(el.target);
                    }
                });
            }, { threshold: 0.1 });
            document.querySelectorAll('.service-card,.info-card,.notice-card,.contact-card,.stat-item').forEach(el => {
                el.style.opacity = '0';
                el.style.transform = 'translateY(20px)';
                el.style.transition = 'opacity .5s ease, transform .5s ease';
                observer.observe(el);
            });
        </script>
    </body>

    </html>
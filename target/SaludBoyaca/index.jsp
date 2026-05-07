<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <fmt:setLocale value="${not empty sessionScope.lang ? sessionScope.lang : 'es'}" />
            <fmt:setBundle basename="messages" />
            <!DOCTYPE html>
            <html lang="${not empty sessionScope.lang ? sessionScope.lang : 'es'}">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>
                    <fmt:message key="index.title" />
                </title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
                <link
                    href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&family=Playfair+Display:ital,wght@0,600;1,600&display=swap"
                    rel="stylesheet">

                <style>
                    :root {
                        --green: #6a9e8a;
                        --green-dark: #4d7a68;
                        --green-light: #8fbdaa;
                        --green-pale: #e8f2ee;
                        --green-bg: #f0f7f4;
                        --text-dark: #1a2e26;
                        --text-mid: #4a6258;
                        --text-light: #7a9a8e;
                        --white: #ffffff;
                        --gray-bg: #f7f9f8;
                        --border: #dce9e4;
                        --shadow: 0 4px 24px rgba(74, 120, 100, 0.10);
                        --shadow-lg: 0 12px 48px rgba(74, 120, 100, 0.16);
                        --radius: 18px;
                        --radius-sm: 12px;
                    }

                    * {
                        margin: 0;
                        padding: 0;
                        box-sizing: border-box;
                    }

                    html {
                        scroll-behavior: smooth;
                    }

                    body {
                        font-family: 'Inter', sans-serif;
                        background: var(--white);
                        color: var(--text-dark);
                        overflow-x: hidden;
                    }

                    /* ── URGENCY BAR ── */
                    .urgency-bar {
                        background: #fff8f0;
                        border-bottom: 1px solid #fde8c8;
                        padding: 0.45rem 2rem;
                        text-align: center;
                        font-size: 0.8rem;
                        color: #c26a10;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        gap: 0.5rem;
                    }

                    .urgency-bar i {
                        color: #e07a20;
                    }

                    .urgency-bar a {
                        color: #c26a10;
                        font-weight: 600;
                        text-decoration: none;
                    }

                    .urgency-bar a:hover {
                        text-decoration: underline;
                    }

                    /* ── NAVBAR ── */
                    .navbar-main {
                        position: sticky;
                        top: 0;
                        z-index: 1000;
                        background: var(--white);
                        border-bottom: 1px solid var(--border);
                        padding: 0 3rem;
                        height: 64px;
                        display: flex;
                        align-items: center;
                        justify-content: space-between;
                    }

                    .nav-brand {
                        font-size: 1.15rem;
                        font-weight: 800;
                        color: var(--text-dark);
                        text-decoration: none;
                        letter-spacing: -0.02em;
                    }

                    .nav-links {
                        display: flex;
                        align-items: center;
                        gap: 2.2rem;
                    }

                    .nav-links a {
                        font-size: 0.88rem;
                        font-weight: 500;
                        color: var(--text-mid);
                        text-decoration: none;
                        transition: color 0.2s;
                    }

                    .nav-links a:hover {
                        color: var(--green-dark);
                    }

                    .nav-actions {
                        display: flex;
                        align-items: center;
                        gap: 0.8rem;
                    }

                    .btn-ghost {
                        background: transparent;
                        border: 1.5px solid var(--border);
                        color: var(--text-dark);
                        font-size: 0.82rem;
                        font-weight: 600;
                        padding: 0.45rem 1.1rem;
                        border-radius: 50px;
                        cursor: pointer;
                        transition: all 0.2s;
                        text-decoration: none;
                        display: inline-flex;
                        align-items: center;
                        gap: 0.4rem;
                    }

                    .btn-ghost:hover {
                        border-color: var(--green);
                        color: var(--green-dark);
                    }

                    .btn-primary-nav {
                        background: var(--green);
                        color: var(--white);
                        font-size: 0.82rem;
                        font-weight: 600;
                        padding: 0.5rem 1.2rem;
                        border-radius: 50px;
                        border: none;
                        cursor: pointer;
                        transition: all 0.2s;
                        text-decoration: none;
                        display: inline-flex;
                        align-items: center;
                        gap: 0.4rem;
                    }

                    .btn-primary-nav:hover {
                        background: var(--green-dark);
                        color: var(--white);
                        transform: translateY(-1px);
                        box-shadow: 0 4px 16px rgba(74, 120, 100, 0.28);
                    }

                    /* ── LOGIN PANEL ── */
                    .login-panel-wrap {
                        position: fixed;
                        top: 110px;
                        right: 2rem;
                        z-index: 1100;
                        width: 340px;
                    }

                    .login-panel-wrap.hidden {
                        display: none;
                    }

                    .login-card {
                        background: var(--white);
                        border-radius: var(--radius);
                        border: 1px solid var(--border);
                        box-shadow: var(--shadow-lg);
                        overflow: hidden;
                        animation: panelIn 0.25s ease both;
                    }

                    @keyframes panelIn {
                        from {
                            opacity: 0;
                            transform: translateY(-8px) scale(0.98);
                        }

                        to {
                            opacity: 1;
                            transform: translateY(0) scale(1);
                        }
                    }

                    .login-card-head {
                        background: linear-gradient(135deg, var(--green-dark), var(--green));
                        padding: 1.1rem 1.4rem;
                        display: flex;
                        align-items: center;
                        gap: 0.7rem;
                    }

                    .login-card-head .lc-icon {
                        width: 38px;
                        height: 38px;
                        background: rgba(255, 255, 255, 0.2);
                        border-radius: 50%;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        color: #fff;
                        font-size: 1rem;
                    }

                    .login-card-head h3 {
                        color: #fff;
                        font-size: 1rem;
                        font-weight: 700;
                        margin: 0;
                    }

                    .login-card-head small {
                        color: rgba(255, 255, 255, 0.75);
                        font-size: 0.7rem;
                    }

                    .login-card-body {
                        padding: 1.2rem 1.4rem 1rem;
                    }

                    .lang-bar {
                        display: flex;
                        gap: 0.35rem;
                        margin-bottom: 1rem;
                    }

                    .lang-btn {
                        flex: 1;
                        text-align: center;
                        font-size: 0.72rem;
                        font-weight: 600;
                        padding: 0.28rem 0.5rem;
                        border-radius: 20px;
                        border: 1.5px solid var(--border);
                        color: var(--text-dark);
                        background: transparent;
                        text-decoration: none;
                        transition: all 0.2s;
                    }

                    .lang-btn:hover,
                    .lang-btn.active {
                        background: var(--green);
                        color: #fff;
                        border-color: var(--green);
                    }

                    .lf-group {
                        margin-bottom: 0.9rem;
                    }

                    .lf-group label {
                        display: block;
                        font-size: 0.72rem;
                        font-weight: 600;
                        color: var(--text-dark);
                        margin-bottom: 0.3rem;
                        text-transform: uppercase;
                        letter-spacing: 0.03em;
                    }

                    .lf-input-wrap {
                        position: relative;
                    }

                    .lf-input-wrap i {
                        position: absolute;
                        left: 0.75rem;
                        top: 50%;
                        transform: translateY(-50%);
                        color: var(--text-light);
                        font-size: 0.78rem;
                        pointer-events: none;
                    }

                    .lf-input {
                        width: 100%;
                        padding: 0.5rem 0.75rem 0.5rem 2.1rem;
                        border: 1.5px solid var(--border);
                        border-radius: var(--radius-sm);
                        font-family: 'Inter', sans-serif;
                        font-size: 0.85rem;
                        background: var(--gray-bg);
                        color: var(--text-dark);
                        transition: all 0.2s;
                        outline: none;
                    }

                    .lf-input:focus {
                        border-color: var(--green);
                        box-shadow: 0 0 0 3px rgba(106, 158, 138, 0.12);
                        background: #fff;
                    }

                    .btn-ingresar {
                        width: 100%;
                        padding: 0.58rem;
                        background: var(--green);
                        color: #fff;
                        border: none;
                        border-radius: var(--radius-sm);
                        font-family: 'Inter', sans-serif;
                        font-size: 0.88rem;
                        font-weight: 700;
                        cursor: pointer;
                        transition: all 0.2s;
                        box-shadow: 0 4px 12px rgba(106, 158, 138, 0.3);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        gap: 0.5rem;
                    }

                    .btn-ingresar:hover {
                        background: var(--green-dark);
                        transform: translateY(-1px);
                    }

                    .login-err {
                        font-size: 0.78rem;
                        color: #c53030;
                        background: #FFF5F5;
                        border: 1px solid #FEB2B2;
                        border-radius: 8px;
                        padding: 0.5rem 0.7rem;
                        margin-bottom: 0.8rem;
                        display: flex;
                        align-items: center;
                        gap: 0.4rem;
                    }

                    .login-err.hidden,
                    .hidden {
                        display: none !important;
                    }

                    .otp-section {
                        border-top: 1px solid var(--border);
                        padding: 1rem 1.4rem 1.1rem;
                        animation: fadeSlideDown 0.3s ease both;
                    }

                    .otp-section.hidden {
                        display: none !important;
                    }

                    @keyframes fadeSlideDown {
                        from {
                            opacity: 0;
                            transform: translateY(-8px);
                        }

                        to {
                            opacity: 1;
                            transform: translateY(0);
                        }
                    }

                    .otp-hint {
                        font-size: 0.76rem;
                        color: var(--text-mid);
                        text-align: center;
                        margin-bottom: 0.85rem;
                        line-height: 1.5;
                    }

                    .otp-hint strong {
                        color: var(--text-dark);
                    }

                    .otp-input-big {
                        width: 100%;
                        font-size: 1.8rem;
                        font-weight: 700;
                        letter-spacing: 10px;
                        text-align: center;
                        border: 2px solid var(--border);
                        border-radius: var(--radius-sm);
                        padding: 0.55rem 1rem;
                        color: var(--text-dark);
                        font-family: 'Courier New', monospace;
                        background: var(--gray-bg);
                        transition: all 0.2s;
                        outline: none;
                    }

                    .otp-input-big:focus {
                        border-color: var(--green);
                        box-shadow: 0 0 0 3px rgba(106, 158, 138, 0.12);
                        background: #fff;
                    }

                    .otp-timer {
                        text-align: center;
                        font-size: 0.75rem;
                        color: var(--text-light);
                        margin: 0.45rem 0 0.85rem;
                    }

                    #otp-countdown {
                        font-weight: 700;
                        color: var(--text-dark);
                    }

                    #otp-countdown.urgente {
                        color: #E53E3E;
                    }

                    .btn-verificar {
                        width: 100%;
                        padding: 0.55rem;
                        background: var(--green);
                        color: #fff;
                        border: none;
                        border-radius: var(--radius-sm);
                        font-family: 'Inter', sans-serif;
                        font-size: 0.85rem;
                        font-weight: 700;
                        cursor: pointer;
                        transition: opacity 0.2s;
                        margin-bottom: 0.55rem;
                    }

                    .btn-verificar:hover {
                        opacity: 0.88;
                    }

                    .btn-verificar:disabled {
                        background: #cbd5e0;
                        cursor: not-allowed;
                    }

                    .btn-reenviar-link {
                        display: block;
                        text-align: center;
                        font-size: 0.75rem;
                        color: var(--green-dark);
                        font-weight: 600;
                        text-decoration: none;
                        cursor: pointer;
                        background: transparent;
                        border: none;
                        width: 100%;
                        padding: 0.2rem;
                    }

                    .btn-reenviar-link:hover {
                        text-decoration: underline;
                    }

                    /* ── HERO ── */
                    .hero-section {
                        padding: 5rem 3rem 3rem;
                        background: var(--white);
                        position: relative;
                        overflow: hidden;
                    }

                    .hero-inner {
                        max-width: 1200px;
                        margin: 0 auto;
                        display: grid;
                        grid-template-columns: 1fr 1fr;
                        gap: 3rem;
                        align-items: center;
                    }

                    .hero-badge-pill {
                        display: inline-flex;
                        align-items: center;
                        gap: 0.5rem;
                        background: var(--green-pale);
                        color: var(--green-dark);
                        font-size: 0.75rem;
                        font-weight: 600;
                        padding: 0.35rem 0.9rem;
                        border-radius: 50px;
                        margin-bottom: 1.2rem;
                        border: 1px solid rgba(106, 158, 138, 0.25);
                    }

                    .hero-badge-pill .dot {
                        width: 7px;
                        height: 7px;
                        background: var(--green);
                        border-radius: 50%;
                    }

                    .hero-title {
                        font-size: clamp(2.2rem, 4.5vw, 3.5rem);
                        font-weight: 800;
                        line-height: 1.12;
                        color: var(--text-dark);
                        margin-bottom: 1.1rem;
                        letter-spacing: -0.03em;
                    }

                    .hero-title .accent {
                        color: var(--green);
                    }

                    .hero-desc {
                        font-size: 0.95rem;
                        color: var(--text-mid);
                        line-height: 1.7;
                        max-width: 440px;
                        margin-bottom: 2rem;
                    }

                    .hero-cta-row {
                        display: flex;
                        align-items: center;
                        gap: 1rem;
                        margin-bottom: 2.5rem;
                    }

                    .btn-hero-primary {
                        display: inline-flex;
                        align-items: center;
                        gap: 0.6rem;
                        background: var(--text-dark);
                        color: #fff;
                        text-decoration: none;
                        font-size: 0.9rem;
                        font-weight: 600;
                        padding: 0.8rem 1.6rem;
                        border-radius: 50px;
                        transition: all 0.2s;
                    }

                    .btn-hero-primary:hover {
                        background: var(--green-dark);
                        color: #fff;
                        transform: translateY(-2px);
                        box-shadow: 0 8px 24px rgba(26, 46, 38, 0.22);
                    }

                    .btn-hero-secondary {
                        display: inline-flex;
                        align-items: center;
                        gap: 0.6rem;
                        background: transparent;
                        color: var(--text-dark);
                        text-decoration: none;
                        font-size: 0.9rem;
                        font-weight: 600;
                        padding: 0.8rem 1.6rem;
                        border-radius: 50px;
                        border: 1.5px solid var(--border);
                        transition: all 0.2s;
                    }

                    .btn-hero-secondary:hover {
                        border-color: var(--green);
                        color: var(--green-dark);
                    }

                    .hero-stats-row {
                        display: flex;
                        align-items: center;
                        gap: 2rem;
                    }

                    .hero-stat {}

                    .hero-stat strong {
                        display: block;
                        font-size: 1.8rem;
                        font-weight: 800;
                        color: var(--text-dark);
                        letter-spacing: -0.03em;
                        line-height: 1;
                    }

                    .hero-stat span {
                        font-size: 0.78rem;
                        color: var(--text-light);
                        font-weight: 500;
                    }

                    .stat-divider {
                        width: 1px;
                        height: 36px;
                        background: var(--border);
                    }

                    /* Hero right */
                    .hero-right {
                        position: relative;
                    }

                    .hero-img-wrap {
                        border-radius: var(--radius);
                        overflow: hidden;
                        width: 100%;
                        height: 380px;
                        position: relative;
                    }

                    .hero-img-wrap img {
                        width: 100%;
                        height: 100%;
                        object-fit: cover;
                    }

                    .hero-img-overlay {
                        position: absolute;
                        inset: 0;
                        background: linear-gradient(to bottom, transparent 60%, rgba(0, 0, 0, 0.15) 100%);
                    }

                    /* Floating appointment card */
                    .appt-card {
                        position: absolute;
                        bottom: 1.5rem;
                        left: 1.5rem;
                        background: rgba(255, 255, 255, 0.95);
                        backdrop-filter: blur(12px);
                        border-radius: var(--radius-sm);
                        border: 1px solid rgba(255, 255, 255, 0.8);
                        box-shadow: 0 8px 28px rgba(26, 46, 38, 0.14);
                        padding: 0.9rem 1.1rem;
                        min-width: 200px;
                    }

                    .appt-card .ac-label {
                        font-size: 0.68rem;
                        text-transform: uppercase;
                        letter-spacing: 0.08em;
                        color: var(--text-light);
                        font-weight: 600;
                        margin-bottom: 0.5rem;
                    }

                    .appt-card .ac-date {
                        display: flex;
                        align-items: center;
                        gap: 0.7rem;
                    }

                    .appt-card .ac-day {
                        width: 36px;
                        height: 36px;
                        background: var(--green);
                        border-radius: 8px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        color: #fff;
                        font-size: 1rem;
                        font-weight: 800;
                    }

                    .appt-card .ac-info strong {
                        display: block;
                        font-size: 0.85rem;
                        font-weight: 700;
                        color: var(--text-dark);
                    }

                    .appt-card .ac-info small {
                        font-size: 0.72rem;
                        color: var(--text-light);
                    }

                    .appt-card .ac-link {
                        display: block;
                        font-size: 0.72rem;
                        color: var(--green-dark);
                        font-weight: 600;
                        margin-top: 0.6rem;
                        text-decoration: none;
                    }

                    .appt-card .ac-link:hover {
                        text-decoration: underline;
                    }

                    /* Doctor avatars */
                    .doctors-badge {
                        position: absolute;
                        top: 1.2rem;
                        right: 1.2rem;
                        background: rgba(255, 255, 255, 0.95);
                        backdrop-filter: blur(10px);
                        border-radius: 50px;
                        padding: 0.45rem 0.9rem 0.45rem 0.55rem;
                        display: flex;
                        align-items: center;
                        gap: 0.5rem;
                        box-shadow: 0 4px 16px rgba(26, 46, 38, 0.12);
                    }

                    .doctors-badge .av-stack {
                        display: flex;
                    }

                    .doctors-badge .av {
                        width: 28px;
                        height: 28px;
                        border-radius: 50%;
                        border: 2px solid #fff;
                        margin-left: -8px;
                        background: var(--green-pale);
                        overflow: hidden;
                    }

                    .doctors-badge .av:first-child {
                        margin-left: 0;
                    }

                    .doctors-badge .av img {
                        width: 100%;
                        height: 100%;
                        object-fit: cover;
                    }

                    .doctors-badge .av-text {
                        font-size: 0.72rem;
                        font-weight: 700;
                        color: var(--text-dark);
                    }

                    .doctors-badge .av-sub {
                        font-size: 0.62rem;
                        color: var(--text-light);
                    }

                    /* ── SEGUROS ── */
                    .seguros-section {
                        padding: 1.5rem 3rem;
                        border-top: 1px solid var(--border);
                        border-bottom: 1px solid var(--border);
                        background: var(--gray-bg);
                    }

                    .seguros-inner {
                        max-width: 1200px;
                        margin: 0 auto;
                        display: flex;
                        align-items: center;
                        gap: 2rem;
                    }

                    .seguros-label {
                        font-size: 0.68rem;
                        font-weight: 700;
                        text-transform: uppercase;
                        letter-spacing: 0.1em;
                        color: var(--text-light);
                        white-space: nowrap;
                    }

                    .seguros-logos {
                        display: flex;
                        align-items: center;
                        gap: 2.5rem;
                        flex-wrap: wrap;
                    }

                    .seguro-name {
                        font-size: 0.85rem;
                        font-weight: 600;
                        color: var(--text-light);
                        letter-spacing: -0.01em;
                    }

                    /* ── ESPECIALIDADES ── */
                    .especialidades-section {
                        padding: 5rem 3rem;
                        background: var(--white);
                    }

                    .section-inner {
                        max-width: 1200px;
                        margin: 0 auto;
                    }

                    .section-tag {
                        font-size: 0.72rem;
                        font-weight: 700;
                        text-transform: uppercase;
                        letter-spacing: 0.12em;
                        color: var(--text-light);
                        margin-bottom: 0.7rem;
                    }

                    .section-title {
                        font-size: clamp(1.6rem, 3vw, 2.3rem);
                        font-weight: 800;
                        color: var(--text-dark);
                        margin-bottom: 0.6rem;
                        letter-spacing: -0.03em;
                    }

                    .section-desc {
                        font-size: 0.92rem;
                        color: var(--text-mid);
                        line-height: 1.65;
                        max-width: 480px;
                    }

                    .section-header-row {
                        display: flex;
                        align-items: flex-end;
                        justify-content: space-between;
                        margin-bottom: 2.5rem;
                    }

                    .btn-outline-green {
                        display: inline-flex;
                        align-items: center;
                        gap: 0.5rem;
                        border: 1.5px solid var(--green);
                        color: var(--green-dark);
                        background: transparent;
                        font-size: 0.82rem;
                        font-weight: 600;
                        padding: 0.5rem 1.1rem;
                        border-radius: 50px;
                        text-decoration: none;
                        transition: all 0.2s;
                        white-space: nowrap;
                    }

                    .btn-outline-green:hover {
                        background: var(--green);
                        color: #fff;
                    }

                    .esp-grid {
                        display: grid;
                        grid-template-columns: repeat(4, 1fr);
                        gap: 1.2rem;
                    }

                    .esp-card {
                        background: var(--gray-bg);
                        border-radius: var(--radius);
                        border: 1px solid var(--border);
                        padding: 1.5rem 1.3rem 1.2rem;
                        transition: all 0.25s;
                        text-decoration: none;
                        color: inherit;
                        display: block;
                    }

                    .esp-card:hover {
                        transform: translateY(-4px);
                        box-shadow: var(--shadow-lg);
                        border-color: var(--green-light);
                        color: inherit;
                    }

                    .esp-icon {
                        width: 44px;
                        height: 44px;
                        background: var(--green-pale);
                        border-radius: 12px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        color: var(--green-dark);
                        font-size: 1.1rem;
                        margin-bottom: 1rem;
                    }

                    .esp-card h4 {
                        font-size: 0.95rem;
                        font-weight: 700;
                        color: var(--text-dark);
                        margin-bottom: 0.4rem;
                    }

                    .esp-card p {
                        font-size: 0.8rem;
                        color: var(--text-mid);
                        line-height: 1.5;
                        margin-bottom: 1rem;
                    }

                    .esp-link {
                        font-size: 0.78rem;
                        font-weight: 600;
                        color: var(--green-dark);
                        display: flex;
                        align-items: center;
                        gap: 0.3rem;
                    }

                    /* ── HISTORIAL MÉDICO ── */
                    .historial-section {
                        padding: 5rem 3rem;
                        background: var(--green-dark);
                        position: relative;
                        overflow: hidden;
                    }

                    .historial-section::before {
                        content: '';
                        position: absolute;
                        inset: 0;
                        background: radial-gradient(ellipse at 70% 50%, rgba(106, 158, 138, 0.35) 0%, transparent 70%);
                    }

                    .historial-inner {
                        max-width: 1200px;
                        margin: 0 auto;
                        display: grid;
                        grid-template-columns: 1fr 1fr;
                        gap: 4rem;
                        align-items: center;
                        position: relative;
                        z-index: 1;
                    }

                    .historial-content .section-tag {
                        color: rgba(255, 255, 255, 0.6);
                    }

                    .historial-content .section-title {
                        color: var(--white);
                    }

                    .historial-content .section-desc {
                        color: rgba(255, 255, 255, 0.75);
                        max-width: 400px;
                        margin-bottom: 2rem;
                    }

                    .historial-cta-row {
                        display: flex;
                        gap: 1rem;
                    }

                    .btn-white {
                        display: inline-flex;
                        align-items: center;
                        gap: 0.5rem;
                        background: var(--white);
                        color: var(--green-dark);
                        font-size: 0.85rem;
                        font-weight: 700;
                        padding: 0.7rem 1.4rem;
                        border-radius: 50px;
                        text-decoration: none;
                        transition: all 0.2s;
                    }

                    .btn-white:hover {
                        background: var(--green-pale);
                        color: var(--green-dark);
                    }

                    .btn-ghost-white {
                        display: inline-flex;
                        align-items: center;
                        gap: 0.5rem;
                        background: transparent;
                        color: var(--white);
                        font-size: 0.85rem;
                        font-weight: 700;
                        padding: 0.7rem 1.4rem;
                        border-radius: 50px;
                        border: 1.5px solid rgba(255, 255, 255, 0.4);
                        text-decoration: none;
                        transition: all 0.2s;
                    }

                    .btn-ghost-white:hover {
                        background: rgba(255, 255, 255, 0.12);
                        color: var(--white);
                    }

                    /* Clinical summary card */
                    .resumen-card {
                        background: var(--white);
                        border-radius: var(--radius);
                        box-shadow: var(--shadow-lg);
                        overflow: hidden;
                    }

                    .resumen-card-head {
                        display: flex;
                        align-items: center;
                        justify-content: space-between;
                        padding: 1rem 1.3rem 0.7rem;
                        border-bottom: 1px solid var(--border);
                    }

                    .resumen-card-head span {
                        font-size: 0.85rem;
                        font-weight: 700;
                        color: var(--text-dark);
                    }

                    .resumen-card-head small {
                        font-size: 0.72rem;
                        color: var(--green);
                        font-weight: 600;
                    }

                    .resumen-vitals {
                        display: grid;
                        grid-template-columns: 1fr 1fr;
                        padding: 1.1rem 1.3rem;
                        gap: 1rem;
                        border-bottom: 1px solid var(--border);
                    }

                    .vital-item {}

                    .vital-item strong {
                        display: block;
                        font-size: 1.6rem;
                        font-weight: 800;
                        color: var(--text-dark);
                        letter-spacing: -0.03em;
                        line-height: 1;
                    }

                    .vital-item small {
                        font-size: 0.72rem;
                        color: var(--text-light);
                    }

                    .resumen-lab {
                        padding: 0.9rem 1.3rem;
                        display: flex;
                        align-items: center;
                        justify-content: space-between;
                    }

                    .resumen-lab div {}

                    .resumen-lab strong {
                        display: block;
                        font-size: 0.82rem;
                        font-weight: 700;
                        color: var(--text-dark);
                    }

                    .resumen-lab small {
                        font-size: 0.72rem;
                        color: var(--text-light);
                    }

                    .btn-pdf {
                        background: var(--green);
                        color: #fff;
                        font-size: 0.72rem;
                        font-weight: 700;
                        padding: 0.35rem 0.8rem;
                        border-radius: 50px;
                        border: none;
                        cursor: pointer;
                        text-decoration: none;
                    }

                    /* ── MÉDICOS ── */
                    .medicos-section {
                        padding: 5rem 3rem;
                        background: var(--white);
                    }

                    .medicos-section .section-header-row {
                        margin-bottom: 2.5rem;
                    }

                    .medicos-grid {
                        display: grid;
                        grid-template-columns: repeat(3, 1fr);
                        gap: 1.5rem;
                        margin-bottom: 2rem;
                    }

                    .medico-card {
                        border-radius: var(--radius);
                        overflow: hidden;
                        border: 1px solid var(--border);
                        transition: all 0.25s;
                    }

                    .medico-card:hover {
                        transform: translateY(-4px);
                        box-shadow: var(--shadow-lg);
                    }

                    .medico-img {
                        width: 100%;
                        height: 240px;
                        object-fit: cover;
                        object-position: top center;
                        display: block;
                    }

                    .medico-body {
                        padding: 1.1rem 1.2rem;
                    }

                    .medico-body h4 {
                        font-size: 0.95rem;
                        font-weight: 700;
                        color: var(--text-dark);
                        margin-bottom: 0.2rem;
                    }

                    .medico-body .esp-tag {
                        font-size: 0.78rem;
                        color: var(--text-mid);
                        margin-bottom: 0.8rem;
                    }

                    .btn-agendar {
                        display: inline-flex;
                        align-items: center;
                        gap: 0.4rem;
                        font-size: 0.78rem;
                        font-weight: 600;
                        color: var(--green-dark);
                        text-decoration: none;
                        border: 1.5px solid var(--green);
                        padding: 0.38rem 0.9rem;
                        border-radius: 50px;
                        transition: all 0.2s;
                    }

                    .btn-agendar:hover {
                        background: var(--green);
                        color: #fff;
                    }

                    .medicos-ver-mas {
                        text-align: center;
                    }

                    .btn-ver-todos {
                        display: inline-flex;
                        align-items: center;
                        gap: 0.5rem;
                        background: transparent;
                        color: var(--text-dark);
                        font-size: 0.88rem;
                        font-weight: 700;
                        text-decoration: none;
                        border: 1.5px solid var(--border);
                        padding: 0.6rem 1.4rem;
                        border-radius: 50px;
                        transition: all 0.2s;
                    }

                    .btn-ver-todos:hover {
                        border-color: var(--green);
                        color: var(--green-dark);
                    }

                    /* ── FOOTER ── */
                    footer {
                        background: var(--gray-bg);
                        border-top: 1px solid var(--border);
                        padding: 3rem 3rem 2rem;
                    }

                    .footer-inner {
                        max-width: 1200px;
                        margin: 0 auto;
                    }

                    .footer-grid {
                        display: grid;
                        grid-template-columns: 1.5fr 1fr 1fr 1.2fr;
                        gap: 2.5rem;
                        margin-bottom: 2rem;
                    }

                    .footer-brand h3 {
                        font-size: 1rem;
                        font-weight: 800;
                        color: var(--text-dark);
                        margin-bottom: 0.6rem;
                    }

                    .footer-brand p {
                        font-size: 0.8rem;
                        color: var(--text-light);
                        line-height: 1.6;
                        max-width: 200px;
                    }

                    .footer-col h4 {
                        font-size: 0.8rem;
                        font-weight: 700;
                        color: var(--text-dark);
                        margin-bottom: 0.9rem;
                    }

                    .footer-col ul {
                        list-style: none;
                    }

                    .footer-col ul li {
                        margin-bottom: 0.5rem;
                    }

                    .footer-col ul li a {
                        font-size: 0.78rem;
                        color: var(--text-mid);
                        text-decoration: none;
                        transition: color 0.2s;
                    }

                    .footer-col ul li a:hover {
                        color: var(--green-dark);
                    }

                    .footer-col .contact-info {
                        font-size: 0.78rem;
                        color: var(--text-mid);
                        line-height: 1.8;
                    }

                    .footer-bottom {
                        border-top: 1px solid var(--border);
                        padding-top: 1.2rem;
                        display: flex;
                        align-items: center;
                        justify-content: space-between;
                    }

                    .footer-bottom small {
                        font-size: 0.75rem;
                        color: var(--text-light);
                    }

                    .footer-bottom-links {
                        display: flex;
                        gap: 1.2rem;
                    }

                    .footer-bottom-links a {
                        font-size: 0.75rem;
                        color: var(--text-light);
                        text-decoration: none;
                    }

                    .footer-bottom-links a:hover {
                        color: var(--green-dark);
                    }

                    /* ── RESPONSIVE ── */
                    @media (max-width: 992px) {
                        .navbar-main {
                            padding: 0 1.5rem;
                        }

                        .nav-links {
                            display: none;
                        }

                        .hero-inner,
                        .historial-inner {
                            grid-template-columns: 1fr;
                            gap: 2rem;
                        }

                        .esp-grid {
                            grid-template-columns: repeat(2, 1fr);
                        }

                        .medicos-grid {
                            grid-template-columns: repeat(2, 1fr);
                        }

                        .footer-grid {
                            grid-template-columns: 1fr 1fr;
                        }

                        .hero-section,
                        .especialidades-section,
                        .historial-section,
                        .medicos-section,
                        footer {
                            padding-left: 1.5rem;
                            padding-right: 1.5rem;
                        }
                    }

                    @media (max-width: 600px) {

                        .esp-grid,
                        .medicos-grid {
                            grid-template-columns: 1fr;
                        }

                        .footer-grid {
                            grid-template-columns: 1fr;
                        }

                        .hero-stats-row {
                            flex-wrap: wrap;
                            gap: 1rem;
                        }

                        .hero-title {
                            font-size: 2rem;
                        }
                    }

                    /* Selector de idioma en navbar */
                    .nav-lang-switcher {
                        display: flex;
                        gap: 0.25rem;
                        align-items: center;
                    }

                    .nav-lang-btn {
                        background: transparent;
                        border: 1.5px solid var(--border);
                        color: var(--text-dark);
                        font-size: 0.78rem;
                        font-weight: 500;
                        padding: 0.3rem 0.55rem;
                        border-radius: 6px;
                        cursor: pointer;
                        text-decoration: none;
                        transition: background 0.2s, color 0.2s, border-color 0.2s;
                        line-height: 1;
                    }

                    .nav-lang-btn:hover,
                    .nav-lang-btn.active {
                        background: var(--green);
                        color: #fff;
                        border-color: var(--green);
                    }
                </style>
            </head>

            <body>

                <!-- ═══ URGENCY BAR ═══ -->
                <div class="urgency-bar">
                    <i class="fas fa-exclamation-circle"></i>
                    <strong>
                        <fmt:message key="index.urgency.label" />
                    </strong>
                    <fmt:message key="index.urgency.line" />
                </div>

                <!-- ═══ NAVBAR ═══ -->
                <nav class="navbar-main">
                    <a class="nav-brand" href="#">SaludBoyacá</a>

                    <div class="nav-links">
                        <a href="#especialidades">
                            <fmt:message key="index.nav.specialties" />
                        </a>
                        <a href="#medicos">
                            <fmt:message key="index.nav.our.team" />
                        </a>
                        <a href="#">
                            <fmt:message key="index.nav.articles" />
                        </a>
                        <a href="#">
                            <fmt:message key="index.nav.contact" />
                        </a>
                    </div>

                    <div class="nav-actions">
                        <div class="nav-lang-switcher">
                            <a href="${pageContext.request.contextPath}/?lang=es"
                                class="nav-lang-btn ${(empty sessionScope.lang || sessionScope.lang=='es') ? 'active' : ''}">&#127464;&#127476;
                                ES</a>
                            <a href="${pageContext.request.contextPath}/?lang=en"
                                class="nav-lang-btn ${sessionScope.lang=='en' ? 'active' : ''}">&#127482;&#127480;
                                EN</a>
                            <a href="${pageContext.request.contextPath}/?lang=it"
                                class="nav-lang-btn ${sessionScope.lang=='it' ? 'active' : ''}">&#127470;&#127481;
                                IT</a>
                        </div>
                        <!-- Un solo botón de Consultar Cita -->
                        <a href="${pageContext.request.contextPath}/consulta_cita" class="btn-ghost">
                            <i class="fas fa-search"></i>
                            <fmt:message key="index.footer.consult" />
                        </a>
                        <!-- CAMBIO: redirige directamente a /login en lugar de abrir el modal -->
                        <a href="${pageContext.request.contextPath}/login" class="btn-ghost">
                            <i class="fas fa-user"></i>
                            <fmt:message key="index.btn.login" />
                        </a>
                    </div>
                </nav>

                <!-- ═══ LOGIN PANEL (conservado para uso interno si se necesita) ═══ -->
                <div class="login-panel-wrap hidden" id="loginPanel">
                    <div class="login-card">
                        <div class="login-card-head">
                            <div class="lc-icon"><i class="fas fa-shield-alt"></i></div>
                            <div>
                                <h3>
                                    <fmt:message key="index.access.title" />
                                </h3>
                                <small>
                                    <fmt:message key="index.access.subtitle" />
                                </small>
                            </div>
                        </div>
                        <div class="login-card-body" id="loginFormSection">
                            <div class="lang-bar">
                                <a href="${pageContext.request.contextPath}/login?lang=es"
                                    class="lang-btn ${(empty sessionScope.lang || sessionScope.lang=='es') ? 'active' : ''}">&#127464;&#127476;
                                    ES</a>
                                <a href="${pageContext.request.contextPath}/login?lang=en"
                                    class="lang-btn ${sessionScope.lang=='en' ? 'active' : ''}">&#127482;&#127480;
                                    EN</a>
                                <a href="${pageContext.request.contextPath}/login?lang=it"
                                    class="lang-btn ${sessionScope.lang=='it' ? 'active' : ''}">&#127470;&#127481;
                                    IT</a>
                            </div>
                            <c:if test="${not empty error}">
                                <div class="login-err"><i class="fas fa-exclamation-circle"></i> ${error}</div>
                            </c:if>
                            <div class="login-err hidden" id="jsError" style="display:none">
                                <i class="fas fa-exclamation-circle"></i>
                                <span id="jsErrorMsg"></span>
                            </div>
                            <div class="lf-group">
                                <label>
                                    <fmt:message key="login.user" />
                                </label>
                                <div class="lf-input-wrap">
                                    <i class="fas fa-user"></i>
                                    <input type="text" id="usernameField" class="lf-input"
                                        placeholder="<fmt:message key='login.user.placeholder'/>"
                                        autocomplete="username">
                                </div>
                            </div>
                            <div class="lf-group">
                                <label>
                                    <fmt:message key="login.pass" />
                                </label>
                                <div class="lf-input-wrap">
                                    <i class="fas fa-lock"></i>
                                    <input type="password" id="passwordField" class="lf-input" placeholder="••••••••"
                                        autocomplete="current-password">
                                </div>
                            </div>
                            <button class="btn-ingresar" id="btnIngresar" onclick="handleLogin()">
                                <i class="fas fa-sign-in-alt"></i>
                                <fmt:message key="index.btn.ingresar" />
                            </button>
                        </div>
                        <div class="otp-section hidden" id="otpSection">
                            <p class="otp-hint">
                                <fmt:message key="index.otp.hint" />
                            </p>
                            <input type="text" class="otp-input-big" id="otpCode" maxlength="6" placeholder="000000"
                                inputmode="numeric" autocomplete="one-time-code">
                            <div class="otp-timer"><i class="fas fa-clock"></i>
                                <fmt:message key="index.otp.expira" /> <span id="otp-countdown">5:00</span>
                            </div>
                            <button class="btn-verificar" id="btnVerificar" onclick="submitOtp()">
                                <i class="fas fa-check-circle me-1"></i>
                                <fmt:message key="index.btn.verify.code" />
                            </button>
                            <button class="btn-reenviar-link" onclick="reenviarOtp()">
                                <i class="fas fa-redo me-1"></i>
                                <fmt:message key="index.btn.resend.code" />
                            </button>
                        </div>
                    </div>
                </div>

                <!-- ═══ HERO ═══ -->
                <section class="hero-section" id="inicio">
                    <div class="hero-inner">
                        <div class="hero-left">
                            <div class="hero-badge-pill">
                                <span class="dot"></span>
                                <fmt:message key="index.urgency.badge" />
                            </div>
                            <h1 class="hero-title">
                                <fmt:message key="index.hero.title" /><br>
                                <span class="accent">
                                    <fmt:message key="index.hero.accent" />
                                </span>
                            </h1>
                            <p class="hero-desc">
                                <fmt:message key="index.hero.subtitle" />
                                <fmt:message key="index.hero.desc" />
                            </p>
                            <div class="hero-cta-row">
                                <a href="${pageContext.request.contextPath}/consulta_cita" class="btn-hero-primary">
                                    <i class="fas fa-calendar-check"></i>
                                    <fmt:message key="index.btn.consultar.citas" />
                                </a>
                                <!-- CAMBIO: Portal Pacientes redirige a /login directamente -->
                                <a href="${pageContext.request.contextPath}/login" class="btn-hero-secondary">
                                    <i class="fas fa-user-circle"></i>
                                    <fmt:message key="index.btn.portal.pacientes" />
                                </a>
                            </div>
                            <div class="hero-stats-row">
                                <div class="hero-stat">
                                    <strong>98%</strong>
                                    <span>
                                        <fmt:message key="index.stat.satisfaction" />
                                    </span>
                                </div>
                                <div class="stat-divider"></div>
                                <div class="hero-stat">
                                    <strong>+50</strong>
                                    <span>
                                        <fmt:message key="index.stat.specialties.label" />
                                    </span>
                                </div>
                                <div class="stat-divider"></div>
                                <div class="hero-stat">
                                    <strong>15k</strong>
                                    <span>
                                        <fmt:message key="index.stat.patients.annual" />
                                    </span>
                                </div>
                            </div>
                        </div>

                        <div class="hero-right">
                            <div class="hero-img-wrap">
                                <img src="https://i.pinimg.com/1200x/9a/e9/2f/9ae92f85aa88d39eed0f42f51a48315b.jpg"
                                    alt="<fmt:message key='index.doctors.tag'/>">
                                <div class="hero-img-overlay"></div>
                                <div class="doctors-badge">
                                    <div class="av-stack">
                                        <div class="av"><img src="https://randomuser.me/api/portraits/women/44.jpg"
                                                alt=""></div>
                                        <div class="av"><img src="https://randomuser.me/api/portraits/men/32.jpg"
                                                alt=""></div>
                                        <div class="av"><img src="https://randomuser.me/api/portraits/women/65.jpg"
                                                alt=""></div>
                                    </div>
                                    <div>
                                        <div class="av-text">20+
                                            <fmt:message key="role.medico" />s
                                        </div>
                                        <div class="av-sub">
                                            <fmt:message key="index.stat.available.today" />
                                        </div>
                                    </div>
                                </div>
                                <div class="appt-card">
                                    <div class="ac-label">
                                        <fmt:message key="index.next.appointment" />
                                    </div>
                                    <div class="ac-date">
                                        <div class="ac-day">24</div>
                                        <div class="ac-info">
                                            <strong>
                                                <fmt:message key="index.esp.cardiology" />
                                            </strong>
                                            <small>10:30 am · Dr. Santos</small>
                                        </div>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/consulta_cita" class="ac-link">
                                        <fmt:message key="index.link.ver.detalles" />
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- ═══ SEGUROS ═══ -->
                <div class="seguros-section">
                    <div class="seguros-inner">
                        <div class="seguros-label">
                            <fmt:message key="index.insurance.label" />
                        </div>
                        <div class="seguros-logos">
                            <span class="seguro-name">AllianzLife</span>
                            <span class="seguro-name">MediCare+</span>
                            <span class="seguro-name">GNP Seguros</span>
                            <span class="seguro-name">Sanitas</span>
                            <span class="seguro-name">MapfreSalud</span>
                        </div>
                    </div>
                </div>

                <!-- ═══ ESPECIALIDADES ═══ -->
                <section class="especialidades-section" id="especialidades">
                    <div class="section-inner">
                        <div class="section-header-row">
                            <div>
                                <div class="section-tag">
                                    <fmt:message key="index.services.tag" />
                                </div>
                                <h2 class="section-title">
                                    <fmt:message key="index.services.title" />
                                </h2>
                                <p class="section-desc">
                                    <fmt:message key="index.services.desc" />
                                </p>
                            </div>
                            <a href="#" class="btn-outline-green">
                                <fmt:message key="index.see.directory" />
                            </a>
                        </div>
                        <div class="esp-grid">
                            <a href="${pageContext.request.contextPath}/consulta_cita" class="esp-card">
                                <div class="esp-icon"><i class="fas fa-heartbeat"></i></div>
                                <h4>
                                    <fmt:message key="index.esp.cardiology" />
                                </h4>
                                <p>
                                    <fmt:message key="index.esp.cardiology.desc" />
                                </p>
                                <div class="esp-link">
                                    <fmt:message key="index.learn.more" /> <i class="fas fa-arrow-right"></i>
                                </div>
                            </a>
                            <a href="${pageContext.request.contextPath}/consulta_cita" class="esp-card">
                                <div class="esp-icon"><i class="fas fa-baby"></i></div>
                                <h4>
                                    <fmt:message key="index.esp.pediatrics" />
                                </h4>
                                <p>
                                    <fmt:message key="index.esp.pediatrics.desc" />
                                </p>
                                <div class="esp-link">
                                    <fmt:message key="index.learn.more" /> <i class="fas fa-arrow-right"></i>
                                </div>
                            </a>
                            <a href="${pageContext.request.contextPath}/consulta_cita" class="esp-card">
                                <div class="esp-icon"><i class="fas fa-flask"></i></div>
                                <h4>
                                    <fmt:message key="index.esp.lab" />
                                </h4>
                                <p>
                                    <fmt:message key="index.esp.lab.desc" />
                                </p>
                                <div class="esp-link">
                                    <fmt:message key="index.learn.more" /> <i class="fas fa-arrow-right"></i>
                                </div>
                            </a>
                            <a href="${pageContext.request.contextPath}/consulta_cita" class="esp-card">
                                <div class="esp-icon"><i class="fas fa-bone"></i></div>
                                <h4>
                                    <fmt:message key="index.esp.trauma" />
                                </h4>
                                <p>
                                    <fmt:message key="index.esp.trauma.desc" />
                                </p>
                                <div class="esp-link">
                                    <fmt:message key="index.learn.more" /> <i class="fas fa-arrow-right"></i>
                                </div>
                            </a>
                        </div>
                    </div>
                </section>

                <!-- ═══ HISTORIAL MÉDICO ═══ -->
                <section class="historial-section">
                    <div class="historial-inner">
                        <div class="historial-content">
                            <div class="section-tag">
                                <fmt:message key="index.feature.tag" />
                            </div>
                            <h2 class="section-title" style="color:#fff;">
                                <fmt:message key="index.feature.title" />
                            </h2>
                            <p class="section-desc">
                                <fmt:message key="index.feature.portal.desc" />
                            </p>
                            <div class="historial-cta-row">
                                <!-- CAMBIO: redirige a /login directamente -->
                                <a href="${pageContext.request.contextPath}/login" class="btn-white">
                                    <i class="fas fa-sign-in-alt"></i>
                                    <fmt:message key="index.feature.portal.btn" />
                                </a>
                                <a href="${pageContext.request.contextPath}/consulta_cita" class="btn-ghost-white">
                                    <i class="fas fa-calendar-check"></i>
                                    <fmt:message key="index.feature.consult.btn" />
                                </a>
                            </div>
                        </div>

                        <div class="historial-right">
                            <div class="resumen-card">
                                <div class="resumen-card-head">
                                    <span>
                                        <fmt:message key="index.clinical.summary" />
                                    </span>
                                    <small>
                                        <fmt:message key="index.updated.today" />
                                    </small>
                                </div>
                                <div class="resumen-vitals">
                                    <div class="vital-item">
                                        <strong>120/80</strong>
                                        <small>
                                            <fmt:message key="index.blood.pressure" />
                                        </small>
                                    </div>
                                    <div class="vital-item">
                                        <strong>92 mg/dL</strong>
                                        <small>
                                            <fmt:message key="index.glucose" />
                                        </small>
                                    </div>
                                </div>
                                <div class="resumen-lab">
                                    <div>
                                        <strong>
                                            <fmt:message key="index.lab.results" />
                                        </strong>
                                        <small>
                                            <fmt:message key="index.lab.subtitle" />
                                        </small>
                                    </div>
                                    <a href="#" class="btn-pdf"><i class="fas fa-download me-1"></i>
                                        <fmt:message key="index.btn.download.pdf" />
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- ═══ MÉDICOS ═══ -->
                <section class="medicos-section" id="medicos">
                    <div class="section-inner">
                        <div class="section-header-row">
                            <div>
                                <div class="section-tag">
                                    <fmt:message key="index.doctors.tag" />
                                </div>
                                <h2 class="section-title">
                                    <fmt:message key="index.doctors.title" />
                                </h2>
                                <p class="section-desc">
                                    <fmt:message key="index.doctors.desc" />
                                </p>
                            </div>
                        </div>
                        <div class="medicos-grid">
                            <div class="medico-card">
                                <img class="medico-img"
                                    src="https://i.pinimg.com/1200x/54/2f/05/542f0566f2e65f3698722b394568d92e.jpg"
                                    alt="Dr. Jacob ">
                                <div class="medico-body">
                                    <h4>Dr. Jacob Montenegro</h4>
                                    <div class="esp-tag">
                                        <fmt:message key="index.dr.jacob.specialty" />
                                    </div>
                                    <a href="${pageContext.request.contextPath}/consulta_cita" class="btn-agendar">
                                        <i class="fas fa-calendar-plus"></i>
                                        <fmt:message key="index.btn.agendar.cita" />
                                    </a>
                                </div>
                            </div>
                            <div class="medico-card">
                                <img class="medico-img"
                                    src="https://i.pinimg.com/1200x/95/aa/75/95aa755d19719a2f83b3a3f45b03adc6.jpg"
                                    alt="Dr. Roberto Santos">
                                <div class="medico-body">
                                    <h4>Dr. Roberto Santos</h4>
                                    <div class="esp-tag">
                                        <fmt:message key="index.dr.roberto.specialty" />
                                    </div>
                                    <a href="${pageContext.request.contextPath}/consulta_cita" class="btn-agendar">
                                        <i class="fas fa-calendar-plus"></i>
                                        <fmt:message key="index.btn.agendar.cita" />
                                    </a>
                                </div>
                            </div>
                            <div class="medico-card">
                                <img class="medico-img"
                                    src="https://i.pinimg.com/1200x/fb/e4/fd/fbe4fdaf2db918c5998a6105d47107e1.jpg"
                                    alt="Dra. Elena Ruiz">
                                <div class="medico-body">
                                    <h4>Dra. Elena Ruiz</h4>
                                    <div class="esp-tag">
                                        <fmt:message key="index.dr.elena.specialty" />
                                    </div>
                                    <a href="${pageContext.request.contextPath}/consulta_cita" class="btn-agendar">
                                        <i class="fas fa-calendar-plus"></i>
                                        <fmt:message key="index.btn.agendar.cita" />
                                    </a>
                                </div>
                            </div>
                        </div>
                        <div class="medicos-ver-mas">
                            <a href="#" class="btn-ver-todos">
                                <fmt:message key="index.see.all.doctors" /> <i class="fas fa-arrow-right"></i>
                            </a>
                        </div>
                    </div>
                </section>

                <!-- ═══ FOOTER ═══ -->
                <footer>
                    <div class="footer-inner">
                        <div class="footer-grid">
                            <div class="footer-brand">
                                <h3>SaludBoyacá</h3>
                                <p>
                                    <fmt:message key="index.footer.slogan" />
                                </p>
                            </div>
                            <div class="footer-col">
                                <h4>
                                    <fmt:message key="index.footer.links" />
                                </h4>
                                <ul>
                                    <li><a href="${pageContext.request.contextPath}/consulta_cita">
                                            <fmt:message key="index.footer.book" />
                                        </a></li>
                                    <li><a href="${pageContext.request.contextPath}/consulta_cita">
                                            <fmt:message key="index.footer.consult" />
                                        </a></li>
                                    <!-- CAMBIO: enlace directo a /login -->
                                    <li><a href="${pageContext.request.contextPath}/login">
                                            <fmt:message key="index.footer.login" />
                                        </a></li>
                                </ul>
                            </div>
                            <div class="footer-col">
                                <h4>
                                    <fmt:message key="index.footer.services" />
                                </h4>
                                <ul>
                                    <li><a href="#">
                                            <fmt:message key="index.svc.general" />
                                        </a></li>
                                    <li><a href="#">
                                            <fmt:message key="index.svc.nutrition" />
                                        </a></li>
                                    <li><a href="#">
                                            <fmt:message key="index.svc.derma" />
                                        </a></li>
                                    <li><a href="#">
                                            <fmt:message key="index.svc.mental" />
                                        </a></li>
                                </ul>
                            </div>
                            <div class="footer-col">
                                <h4>
                                    <fmt:message key="index.footer.contact" />
                                </h4>
                                <div class="contact-info">
                                    800-SERENA-9<br>
                                    hola@saludboyaca.co<br>
                                    Av. de la Paz 123, Paipa
                                </div>
                            </div>
                        </div>
                        <div class="footer-bottom">
                            <small>
                                <fmt:message key="index.footer.rights" />
                            </small>
                            <div class="footer-bottom-links">
                                <a href="#">
                                    <fmt:message key="consulta.privacy" />
                                </a>
                                <a href="#">
                                    <fmt:message key="consulta.terms" />
                                </a>
                            </div>
                        </div>
                    </div>
                </footer>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    function toggleLogin() {
                        document.getElementById('loginPanel').classList.toggle('hidden');
                    }
                    var otpTimerInterval = null;
                    function handleLogin() {
                        var user = document.getElementById('usernameField').value.trim();
                        var pass = document.getElementById('passwordField').value.trim();
                        if (!user || !pass) { showJsError(MSG_FILL_LOGIN); return; }
                        var btn = document.getElementById('btnIngresar');
                        btn.disabled = true;
                        btn.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i> Verificando...';
                        var form = new FormData();
                        form.append('username', user);
                        form.append('password', pass);
                        form.append('ajaxLogin', 'true');
                        fetch('${pageContext.request.contextPath}/login', { method: 'POST', body: form })
                            .then(function (r) {
                                if (r.redirected && r.url.indexOf('otp') !== -1) {
                                    showOtpSection();
                                    fetch('${pageContext.request.contextPath}/otp?accion=generar', { method: 'GET', redirect: 'manual' });
                                } else if (r.redirected && r.url.indexOf('dashboard') !== -1) {
                                    window.location.href = r.url;
                                } else {
                                    return r.text().then(function () {
                                        showJsError(MSG_LOGIN_ERR);
                                        btn.disabled = false;
                                        btn.innerHTML = '<i class="fas fa-sign-in-alt"></i> Ingresar';
                                    });
                                }
                            })
                            .catch(function () { submitTradicional(user, pass); });
                    }
                    function submitTradicional(user, pass) {
                        var f = document.createElement('form'); f.method = 'POST';
                        f.action = '${pageContext.request.contextPath}/login';
                        var u = document.createElement('input'); u.type = 'hidden'; u.name = 'username'; u.value = user;
                        var p = document.createElement('input'); p.type = 'hidden'; p.name = 'password'; p.value = pass;
                        f.appendChild(u); f.appendChild(p); document.body.appendChild(f); f.submit();
                    }
                    function showOtpSection() {
                        document.getElementById('loginFormSection').style.opacity = '0.45';
                        document.getElementById('loginFormSection').style.pointerEvents = 'none';
                        var otpSec = document.getElementById('otpSection');
                        otpSec.classList.remove('hidden');
                        startOtpTimer();
                        document.getElementById('otpCode').focus();
                    }
                    // i18n messages for JavaScript (index.jsp)
                    var MSG_FILL_LOGIN = '<fmt:message key="index.js.fill.login"/>';
                    var MSG_LOGIN_ERR = '<fmt:message key="index.js.login.error"/>';
                    var MSG_OTP_EXPIRED = '<fmt:message key="index.js.otp.expired"/>';
                    var MSG_OTP_ENTER = '<fmt:message key="index.js.otp.enter"/>';
                    var MSG_OTP_VERIFY = '<fmt:message key="index.js.otp.verifying"/>';
                    function showJsError(msg) {
                        var el = document.getElementById('jsError');
                        document.getElementById('jsErrorMsg').textContent = msg;
                        el.style.display = 'flex';
                    }
                    function startOtpTimer() {
                        if (otpTimerInterval) clearInterval(otpTimerInterval);
                        var restante = 300;
                        var el = document.getElementById('otp-countdown');
                        var btn = document.getElementById('btnVerificar');
                        otpTimerInterval = setInterval(function () {
                            restante--;
                            var m = Math.floor(restante / 60), s = restante % 60;
                            el.textContent = m + ':' + String(s).padStart(2, '0');
                            if (restante < 60) el.classList.add('urgente');
                            if (restante <= 0) {
                                clearInterval(otpTimerInterval);
                                btn.disabled = true;
                                btn.innerHTML = '<i class="fas fa-clock me-1"></i> ' + MSG_OTP_EXPIRED;
                            }
                        }, 1000);
                    }
                    function submitOtp() {
                        var code = document.getElementById('otpCode').value.trim();
                        if (code.length !== 6 || !/^\d{6}$/.test(code)) { alert(MSG_OTP_ENTER); return; }
                        var f = document.createElement('form'); f.method = 'POST';
                        f.action = '${pageContext.request.contextPath}/otp?accion=validar';
                        var c = document.createElement('input'); c.type = 'hidden'; c.name = 'otpCodigo'; c.value = code;
                        f.appendChild(c); document.body.appendChild(f); f.submit();
                    }
                    function reenviarOtp() {
                        if (otpTimerInterval) clearInterval(otpTimerInterval);
                        fetch('${pageContext.request.contextPath}/otp?accion=generar', { redirect: 'manual' });
                        document.getElementById('otpCode').value = '';
                        var btn = document.getElementById('btnVerificar');
                        btn.disabled = false;
                        btn.innerHTML = '<i class="fas fa-check-circle me-1"></i> <fmt:message key="index.btn.verify.code"/>';
                        document.getElementById('otp-countdown').classList.remove('urgente');
                        startOtpTimer();
                    }
                    document.getElementById('otpCode').addEventListener('input', function () {
                        this.value = this.value.replace(/\D/g, '').slice(0, 6);
                    });
                    document.getElementById('passwordField').addEventListener('keydown', function (e) {
                        if (e.key === 'Enter') handleLogin();
                    });
                    document.getElementById('usernameField').addEventListener('keydown', function (e) {
                        if (e.key === 'Enter') document.getElementById('passwordField').focus();
                    });
                </script>
            </body>

            </html>
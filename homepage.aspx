<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="homepage.aspx.cs" Inherits="Marathone.homepage" %>
<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@500;700;900&family=Exo+2:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

    <style>
        /* ─────── ALL NOTICES CTA – CYBERPUNK EDITION ─────── */
        .all-notices-cta {
            
            margin-top: 16px;   /* perfect tight-but-comfortable spacing */
            padding: 8px 0;     /* optional: reduce padding a tiny bit too */
            text-align: center;
            
        }

        .neon-cta-link {
            position: relative;
            display: inline-flex;
            align-items: center;
            gap: 14px;
            font-family: 'Orbitron', sans-serif;
            font-weight: 700;
            font-size: 1.15rem;
            color: #00e5ff;
            text-decoration: none;
            text-transform: uppercase;
            letter-spacing: 2px;
            padding: 14px 32px;
            border: 2px solid transparent;
            border-radius: 50px;
            background: linear-gradient(45deg, transparent, rgba(0, 229, 255, 0.1), transparent);
            overflow: hidden;
            transition: all 0.4s cubic-bezier(0.25, 0.8, 0.25, 1);
            z-index: 1;
        }

        .neon-cta-link i {
            font-size: 1.3rem;
            transition: transform 0.4s ease;
        }

        .neon-cta-link span {
            background: linear-gradient(90deg, #00e5ff, #7b2cff);
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
            text-shadow: 0 0 20px rgba(0, 229, 255, 0.6);
        }

        /* Glowing border + hover magic */
        .neon-cta-link::before {
            content: '';
            position: absolute;
            inset: 0;
            border-radius: 50px;
            padding: 2px;
            background: linear-gradient(45deg, #00e5ff, #7b2cff, #ff00c8);
            mask: linear-gradient(#fff 0 0) padding-box, linear-gradient(#fff 0 0);
            mask-composite: exclude;
            -webkit-mask-composite: destination-out;
            opacity: 0;
            transition: opacity 0.4s ease;
        }

        .neon-cta-link:hover::before {
            opacity: 1;
        }

        /* Animated glowing underline */
        .glow-line {
            position: absolute;
            bottom: 0;
            left: 50%;
            width: 0;
            height: 3px;
            background: linear-gradient(90deg, transparent, #00e5ff, #7b2cff, transparent);
            border-radius: 3px;
            box-shadow: 0 0 15px #00e5ff;
            transition: all 0.6s ease;
            transform: translateX(-50%);
        }

        .neon-cta-link:hover .glow-line {
            width: 100%;
        }

        /* Arrow animation on hover */
        .neon-cta-link:hover i {
            transform: translateX(8px);
        }

        /* Final hover lift + intense glow */
        .neon-cta-link:hover {
            transform: translateY(-4px);
            box-shadow: 0 0 30px rgba(0, 229, 255, 0.4);
            color: #ffffff;
        }
        *, *::before, *::after {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        html, body {
            height: 100%;
            overflow-x: hidden;
        }

        body {
            background: linear-gradient(135deg, #0f0f1e 0%, #1a1a2e 50%, #16213e 100%);
            color: #e0e0e0;
            font-family: 'Exo 2', sans-serif;
            min-height: 100vh;
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
        }

        .container {
            display: flex;
            min-height: 100vh;
            padding: 30px;
            gap: 30px;
            max-width: 1900px;
            margin: 0 auto;
            align-items: stretch;
        }

        /* LEFT HERO PANEL */
        .left-panel {
            flex: 62%;
            border-radius: 20px;
            overflow: hidden;
            position: relative;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.6);
        }

        .left-panel::before {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(45deg, rgba(0, 229, 255, 0.15), rgba(123, 44, 255, 0.25));
            z-index: 1;
            pointer-events: none;
        }

        .left-panel img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 10s ease-in-out;
            display: block;
            animation: fadeIn 1.2s ease-out forwards;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: scale(1.05); }
            to { opacity: 1; transform: scale(1); }
        }

        .left-panel:hover img {
            transform: scale(1.08);
        }

        .hero-overlay {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            padding: 50px;
            background: linear-gradient(to top, rgba(0,0,0,0.92), transparent);
            z-index: 2;
        }

        .tournament-title {
            font-family: 'Orbitron', sans-serif;
            font-size: 4.5rem;
            font-weight: 900;
            background: linear-gradient(90deg, #00e5ff, #7b2cff, #ff00c8);
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
            text-shadow: 0 0 30px rgba(0, 229, 255, 0.5);
            letter-spacing: 3px;
            line-height: 1.1;
        }

        .tournament-subtitle {
            font-size: 1.4rem;
            color: #00e5ff;
            margin-top: 10px;
            font-weight: 500;
            text-shadow: 0 0 10px rgba(0, 229, 255, 0.3);
        }

        /* RIGHT PANEL */
        .right-panel {
            flex: 38%;
            display: flex;
            flex-direction: column;
            gap: 25px;
            min-width: 340px;
        }

        /* AUTH BOX */
        .auth-box {
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(15px);
            -webkit-backdrop-filter: blur(15px);
            border-radius: 20px;
            padding: 40px 35px;
            border: 1px solid rgba(255, 255, 255, 0.15);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.4);
            text-align: center;
            position: relative;
            overflow: hidden;
            transition: transform 0.4s ease, box-shadow 0.4s ease;
        }

        .auth-box:hover {
            transform: translateY(-4px);
            box-shadow: 0 20px 50px rgba(0, 229, 255, 0.15);
        }

        .auth-box::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 4px;
            background: linear-gradient(90deg, #00e5ff, #7b2cff);
            border-radius: 20px 20px 0 0;
        }

        .auth-title {
            font-family: 'Orbitron', sans-serif;
            font-size: 2.2rem;
            font-weight: 700;
            background: linear-gradient(90deg, #00e5ff, #ffffff);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 10px;
        }

        .auth-subtitle {
            color: #b0b0b0;
            font-size: 1rem;
            margin-bottom: 30px;
            line-height: 1.5;
        }

        .auth-buttons {
            display: flex;
            gap: 20px;
            justify-content: center;
            margin-top: 20px;
        }

        .btn-neon {
            padding: 16px 40px;
            font-size: 1.1rem;
            font-weight: 600;
            border-radius: 50px;
            text-decoration: none;
            transition: all 0.4s ease;
            position: relative;
            overflow: hidden;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: white;
        }

        .btn-login {
            background: linear-gradient(45deg, #00e5ff, #0099cc);
            box-shadow: 0 0 20px rgba(0, 229, 255, 0.6);
        }

        .btn-register {
            background: linear-gradient(45deg, #7b2cff, #ff00c8);
            box-shadow: 0 0 20px rgba(123, 44, 255, 0.6);
        }

        .btn-neon:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.5);
        }

        .btn-neon::after {
            content: '';
            position: absolute;
            top: 0; left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            transition: 0.6s;
        }

        .btn-neon:hover::after {
            left: 100%;
        }

        /* UPDATES BOX */
        .updates-box {
            flex-grow: 1;
            background: rgba(255, 255, 255, 0.07);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border-radius: 20px;
            padding: 30px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.3);
            overflow-y: auto;
        }

        .updates-title {
            font-family: 'Orbitron', sans-serif;
            font-size: 1.8rem;
            text-align: center;
            margin-bottom: 25px;
            color: #00e5ff;
            text-shadow: 0 0 10px rgba(0, 229, 255, 0.5);
        }

        .update-item {
            background: rgba(255, 255, 255, 0.08);
            padding: 18px;
            margin-bottom: 16px;
            border-radius: 12px;
            border-left: 4px solid #7b2cff;
            transition: all 0.3s ease;
        }

        .update-item:hover {
    transform: translateX(12px);
    background: linear-gradient(90deg, 
        rgba(0, 229, 255, 0.18) 0%,   /* cyan glow start */
        rgba(123, 44, 255, 0.25) 50%,  /* purple center */
        rgba(0, 229, 255, 0.18) 100%   /* cyan glow end */
    );
    border-left: 4px solid #00e5ff;
    box-shadow: 
        0 0 20px rgba(0, 229, 255, 0.3),
        inset 0 0 30px rgba(123, 44, 255, 0.15);
    backdrop-filter: blur(4px);
    color: #ffffff !important;               /* force bright text */
    text-shadow: 0 0 8px rgba(0, 229, 255, 0.6);
    transition: all 0.35s ease;
}

/* Make sure title stays bright white on hover */
        .update-item:hover b {
            color: #ffffff;
            text-shadow: 0 0 12px #00e5ff;
        }

        /* Small timestamp stays visible */
        .update-item:hover small {
            color: #a0f7ff !important;
        }
        .update-item:hover small i {
            color: #7bffd4;
        }

        .update-item b {
            color: #00e5ff;
            font-size: 1.1rem;
        }

        .update-item small {
            color: #888;
            font-size: 0.85rem;
            display: block;
            margin-top: 8px;
        }

        .update-item small i {
            color: #7b2cff;
            margin-right: 5px;
        }

        /* CUSTOM SCROLLBAR */
        .updates-box::-webkit-scrollbar {
            width: 8px;
        }
        .updates-box::-webkit-scrollbar-track {
            background: rgba(255,255,255,0.05);
            border-radius: 10px;
        }
        .updates-box::-webkit-scrollbar-thumb {
            background: linear-gradient(#00e5ff, #7b2cff);
            border-radius: 10px;
        }

        /* RESPONSIVE FIX */
        @media (max-width: 992px) {
            .container {
                flex-direction: column;
                padding: 20px;
            }
            .left-panel, .right-panel {
                flex: 1;
            }
            .hero-overlay {
                padding: 40px;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container">
        <!-- LEFT HERO -->
        <div class="left-panel">
            <img src="~/imgs/44.jpg" runat="server" alt="Tournament Hero" />
            <div class="hero-overlay">
                <div class="tournament-title">MARATHON 2025</div>
                <div class="tournament-subtitle">THE ULTIMATE BATTLE BEGINS</div>
            </div>
        </div>

        <!-- RIGHT PANEL -->
        <div class="right-panel">
            <!-- PREMIUM AUTH BOX -->
            <div class="auth-box">
                <div class="auth-title">TOURNAMENT ACCESS</div>
                <p class="auth-subtitle">Join the elite. Secure your spot now.</p>
                <div class="auth-buttons">
                    <a href="Login.aspx" class="btn-neon btn-login">
                        <i class="fas fa-sign-in-alt"></i> LOGIN
                    </a>
                    <a href="User_Registration.aspx" class="btn-neon btn-register">
                        <i class="fas fa-user-plus"></i> REGISTER
                    </a>
                </div>
            </div>

            <!-- LIVE UPDATES -->
            <div class="updates-box">
                <div class="updates-title">
                    <i class="fas fa-broadcast-tower"></i> UPDATE NEWS
                </div>
                <asp:Repeater ID="rptNotices" runat="server">
                    <ItemTemplate>
                        <div class="update-item">
                            <b><%# Eval("Title") %></b><br />
                            <%# Eval("Description") %>
                            <small><i class="far fa-clock"></i> <%# Eval("CreatedDate", "{0:dd MMM yyyy • hh:mm tt}") %></small>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <div style="margin-top:10px; text-align:center;">
               <div class="all-notices-cta">
                <asp:HyperLink ID="lnkAllNotices" runat="server" 
                               NavigateUrl="AllNotices.aspx" 
                               CssClass="neon-cta-link">
                    <i class="fas fa-arrow-right"></i>
                    <span>VIEW ALL NOTICES</span>
                    <div class="glow-line"></div>
                </asp:HyperLink>
            </div>
            </div>
            </div>
        </div>
    </div>
</asp:Content>
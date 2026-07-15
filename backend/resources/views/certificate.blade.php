<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sertifikat Kelulusan - {{ $user->name }}</title>
    <!-- Premium Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@500;700;900&family=Great+Vibes&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --gold-primary: #C5A059;
            --gold-light: #F9E7B9;
            --gold-dark: #8C6D33;
            --gold-gradient: linear-gradient(135deg, #8c6d33 0%, #f9e7b9 30%, #c5a059 70%, #8c6d33 100%);
            --bg-dark: #0f172a;
            --text-dark: #1e293b;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #090d16 0%, #111827 100%);
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            color: #f8fafc;
        }

        .actions {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 100;
        }

        .btn {
            background: var(--gold-gradient);
            color: #0f172a;
            border: none;
            padding: 10px 20px;
            font-size: 13px;
            font-weight: 700;
            border-radius: 30px;
            cursor: pointer;
            box-shadow: 0 4px 15px rgba(197, 160, 89, 0.4);
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 10px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(197, 160, 89, 0.6);
        }

        /* Certificate Container: Luxury layout */
        .certificate-wrapper {
            padding: 20px;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .certificate-container {
            width: 850px;
            height: 600px;
            background-color: #fcfbfa;
            background-image: 
                radial-gradient(circle at 50% 50%, rgba(255, 255, 255, 0.8) 0%, rgba(252, 251, 250, 1) 100%),
                url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='80' height='80' viewBox='0 0 80 80'%3E%3Cg fill='%23c5a059' fill-opacity='0.02'%3E%3Cpath fill-rule='evenodd' d='M11 18c3.866 0 7-3.134 7-7s-3.134-7-7-7-7 3.134-7 7 3.134 7 7 7zm48 25c3.866 0 7-3.134 7-7s-3.134-7-7-7-7 3.134-7 7 3.134 7 7 7z'/%3E%3C/g%3E%3C/svg%3E");
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.5);
            position: relative;
            padding: 45px 50px 35px 50px;
            box-sizing: border-box;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            align-items: center;
            border-radius: 4px;
            color: var(--text-dark);
            overflow: hidden;
        }

        /* Watermark Background */
        .watermark {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            font-size: 320px;
            font-family: 'Cinzel', serif;
            font-weight: 900;
            color: rgba(197, 160, 89, 0.04);
            pointer-events: none;
            user-select: none;
            z-index: 1;
        }

        /* Borders */
        .border-outer {
            position: absolute;
            top: 20px;
            bottom: 20px;
            left: 20px;
            right: 20px;
            border: 5px solid transparent;
            border-image: var(--gold-gradient) 5;
            pointer-events: none;
            z-index: 2;
        }

        .border-inner {
            position: absolute;
            top: 30px;
            bottom: 30px;
            left: 30px;
            right: 30px;
            border: 1px solid rgba(140, 109, 51, 0.4);
            pointer-events: none;
            z-index: 2;
        }

        /* Corners */
        .corner {
            position: absolute;
            width: 40px;
            height: 40px;
            border: 2px solid transparent;
            z-index: 3;
        }
        .corner-tl { top: 35px; left: 35px; border-top-color: var(--gold-primary); border-left-color: var(--gold-primary); }
        .corner-tr { top: 35px; right: 35px; border-top-color: var(--gold-primary); border-right-color: var(--gold-primary); }
        .corner-bl { bottom: 35px; left: 35px; border-bottom-color: var(--gold-primary); border-left-color: var(--gold-primary); }
        .corner-br { bottom: 35px; right: 35px; border-bottom-color: var(--gold-primary); border-right-color: var(--gold-primary); }

        .header {
            text-align: center;
            z-index: 5;
            margin-top: 5px;
            width: 100%;
        }

        .logo-area {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            margin-bottom: 5px;
        }

        .logo-icon {
            width: 26px;
            height: 26px;
            background: var(--gold-gradient);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            font-weight: 800;
            font-size: 13px;
            font-family: 'Cinzel', serif;
            box-shadow: 0 2px 6px rgba(140, 109, 51, 0.3);
        }

        /* Darker high-contrast bronze for the brand text */
        .brand {
            font-family: 'Cinzel', serif;
            font-size: 16px;
            font-weight: 800;
            color: #5c4015;
            letter-spacing: 3px;
        }

        .title {
            font-family: 'Cinzel', serif;
            font-size: 28px;
            font-weight: 900;
            color: #1e3a8a;
            letter-spacing: 4px;
            margin: 5px 0 8px 0;
            text-shadow: 1px 1px 1px rgba(0,0,0,0.05);
        }

        .subtitle {
            font-size: 12px;
            font-weight: 500;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 2px;
        }

        .recipient-name {
            font-family: 'Cinzel', serif;
            font-size: 30px;
            font-weight: 700;
            color: #0f172a;
            margin: 8px 0;
            position: relative;
            display: inline-block;
        }

        .recipient-name::after {
            content: '';
            position: absolute;
            bottom: -3px;
            left: 10%;
            width: 80%;
            height: 1.5px;
            background: var(--gold-gradient);
        }

        .content {
            text-align: center;
            max-width: 650px;
            z-index: 5;
        }

        .course-text {
            font-size: 13px;
            color: #475569;
            line-height: 1.6;
            margin: 10px 0 5px 0;
        }

        .course-name {
            font-size: 18px;
            font-weight: 700;
            color: #1e3a8a;
            margin: 5px 0;
            letter-spacing: 0.5px;
        }

        .score-text {
            font-size: 13px;
            font-weight: 600;
            color: var(--gold-dark);
            margin-top: 3px;
        }

        .footer {
            width: 100%;
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            z-index: 5;
            padding: 0 20px;
            box-sizing: border-box;
        }

        .footer-col {
            width: 220px;
            text-align: center;
        }

        .footer-col.left { text-align: left; }
        .footer-col.right { text-align: center; }

        .line {
            border-top: 1px solid #cbd5e1;
            margin-bottom: 6px;
            width: 100%;
        }

        .label {
            font-size: 9px;
            color: #94a3b8;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            margin-bottom: 3px;
        }

        .value {
            font-size: 12px;
            font-weight: 600;
            color: #334155;
        }

        /* Centered signature with subtle overlap */
        .signature-img-container {
            height: 55px;
            display: flex;
            justify-content: center;
            align-items: center;
            margin-bottom: -2px; /* Raised signature for better spacing */
            position: relative;
            z-index: 10;
        }

        .signature-img {
            max-height: 55px;
            max-width: 130px;
            object-fit: contain;
            mix-blend-mode: multiply;
        }

        /* Enlarged Gold Seal with readable text */
        .seal-container {
            display: flex;
            justify-content: center;
            align-items: center;
            position: relative;
            width: 90px;
            height: 90px;
            margin-bottom: -15px;
        }

        .seal-ribbon-left {
            position: absolute;
            width: 16px;
            height: 50px;
            background: #b91c1c;
            transform: rotate(25deg);
            top: 45px;
            left: 28px;
            clip-path: polygon(0% 0%, 100% 0%, 100% 100%, 50% 85%, 0% 100%);
            box-shadow: 1px 2px 5px rgba(0,0,0,0.15);
        }

        .seal-ribbon-right {
            position: absolute;
            width: 16px;
            height: 50px;
            background: #b91c1c;
            transform: rotate(-25deg);
            top: 45px;
            right: 28px;
            clip-path: polygon(0% 0%, 100% 0%, 100% 100%, 50% 85%, 0% 100%);
            box-shadow: -1px 2px 5px rgba(0,0,0,0.15);
        }

        .seal-gold {
            width: 62px;
            height: 62px;
            background: radial-gradient(circle, #f9e7b9 0%, #c5a059 60%, #8c6d33 100%);
            border-radius: 50%;
            border: 2px dashed #f9e7b9;
            box-shadow: 0 4px 10px rgba(140, 109, 51, 0.4);
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            z-index: 10;
        }

        .seal-inner {
            width: 50px;
            height: 50px;
            border: 1px solid rgba(140, 109, 51, 0.5);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            color: #ffffff;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.4);
        }

        .seal-star {
            font-size: 13px;
            color: #ffffff;
            margin-bottom: -1px;
        }

        .seal-text {
            font-size: 7px;
            font-weight: 800;
            letter-spacing: 0.5px;
            text-transform: uppercase;
        }

        /* Mobile Scaling */
        @media (max-width: 900px) {
            .certificate-wrapper {
                padding: 10px 0;
                width: 100%;
                overflow: hidden;
                display: flex;
                justify-content: center;
            }
            .certificate-container {
                zoom: calc(100vw / 920);
                margin: 0 auto;
            }
            .actions {
                position: absolute;
                top: 10px;
                right: 10px;
            }
        }

        @media print {
            body {
                background: none;
                padding: 0;
            }
            .actions {
                display: none;
            }
            .certificate-wrapper {
                padding: 0;
            }
            .certificate-container {
                box-shadow: none;
                width: 100%;
                height: 100vh;
                padding: 50px;
                background-color: #ffffff !important;
                -webkit-print-color-adjust: exact;
                print-color-adjust: exact;
                zoom: 1 !important;
            }
        }
    </style>
</head>
<body>
    <div class="actions">
        <button class="btn" onclick="window.print()">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                <path d="M5 1a2 2 0 0 0-2 2v2H2a2 2 0 0 0-2 2v3a2 2 0 0 0 2 2h1v1a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2v-1h1a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-1V3a2 2 0 0 0-2-2zM4 3a1 1 0 0 1 1-1h6a1 1 0 0 1 1 1v2H4zm1 5a2 2 0 0 0-2 2v1H2a1 1 0 0 1-1-1V7a1 1 0 0 1 1-1h12a1 1 0 0 1 1 1v3a1 1 0 0 1-1 1h-1v-1a2 2 0 0 0-2-2zm7 2v3a1 1 0 0 1-1 1H5a1 1 0 0 1-1-1v-3a1 1 0 0 1 1-1h6a1 1 0 0 1 1 1z"/>
            </svg>
            Cetak Sertifikat
        </button>
    </div>

    <div class="certificate-wrapper">
        <div class="certificate-container">
            <!-- Background Watermark -->
            <div class="watermark">G</div>

            <!-- Borders -->
            <div class="border-outer"></div>
            <div class="border-inner"></div>

            <!-- Corners -->
            <div class="corner corner-tl"></div>
            <div class="corner corner-tr"></div>
            <div class="corner corner-bl"></div>
            <div class="corner corner-br"></div>

            <!-- Header -->
            <div class="header">
                <div class="logo-area">
                    <div class="logo-icon">G</div>
                    <span class="brand">G-LEARN</span>
                </div>
                <h2 class="title">SERTIFIKAT KELULUSAN</h2>
                <div class="subtitle">Diberikan Kepada:</div>
                <div class="recipient-name">{{ $user->name }}</div>
            </div>

            <!-- Course Details -->
            <div class="content">
                <div class="course-text">Telah berhasil menyelesaikan seluruh kurikulum kelas pembelajaran online dan dinyatakan lulus dengan hasil yang memuaskan dari kelas:</div>
                <div class="course-name">"{{ $package->name }}"</div>
                <div class="score-text">Mencapai Tingkat Kelulusan {{ $attempt->score }}% (Skor: {{ $attempt->score }}/100)</div>
            </div>

            <!-- Footer / Metadata & Seal -->
            <div class="footer">
                <div class="footer-col left">
                    <div class="label">Tanggal Terbit</div>
                    <div class="value">{{ \Carbon\Carbon::parse($certificate->issued_at)->format('d F Y') }}</div>
                    <div style="margin-top: 15px;"></div>
                    <div class="label">No. Sertifikat</div>
                    <div class="value" style="font-family: monospace; letter-spacing: 0.5px;">{{ $certificate->certificate_code }}</div>
                </div>

                <!-- Gold Seal -->
                <div class="seal-container">
                    <div class="seal-ribbon-left"></div>
                    <div class="seal-ribbon-right"></div>
                    <div class="seal-gold">
                        <div class="seal-inner">
                            <span class="seal-star">★</span>
                            <span class="seal-text">G-LEARN</span>
                            <span class="seal-text" style="font-size: 4px; opacity: 0.8;">OFFICIAL</span>
                        </div>
                    </div>
                </div>

                <div class="footer-col right">
                    <div class="signature-img-container">
                        <img src="{{ asset('signature.png') }}" alt="Tanda Tangan Guntur Lailam Yuro" class="signature-img">
                    </div>
                    <div class="line"></div>
                    <div class="label">CEO G-LEARN</div>
                    <div class="value" style="color: #1e3a8a;">Guntur Lailam Yuro S.Kom</div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Laporan Pendapatan Elearning</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            padding: 20px;
            background: white;
            color: #333;
        }
        
        .header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 3px solid #10b981;
        }
        
        .header h1 {
            color: #10b981;
            font-size: 28px;
            font-weight: bold;
            margin-bottom: 5px;
        }
        
        .header h2 {
            color: #333;
            font-size: 18px;
            font-weight: normal;
        }
        
        .header .date {
            color: #666;
            font-size: 14px;
            margin-top: 10px;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            padding: 20px;
            text-align: center;
        }
        
        .stat-card .label {
            font-size: 12px;
            color: #666;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 10px;
        }
        
        .stat-card .value {
            font-size: 24px;
            font-weight: bold;
            color: #1f2937;
        }
        
        .section {
            margin-bottom: 30px;
        }
        
        .section-title {
            font-size: 18px;
            font-weight: bold;
            color: #1f2937;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #e5e7eb;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        
        table th,
        table td {
            padding: 12px;
            text-align: left;
            border: 1px solid #e5e7eb;
        }
        
        table th {
            background-color: #f3f4f6;
            font-weight: bold;
            color: #1f2937;
        }
        
        table tr:nth-child(even) {
            background-color: #f9fafb;
        }
        
        .grid-2 {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
        }
        
        .revenue-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 15px;
            background-color: #f9fafb;
            border-radius: 6px;
            margin-bottom: 10px;
        }
        
        .revenue-item .name {
            font-weight: 500;
            color: #1f2937;
        }
        
        .revenue-item .amount {
            font-weight: bold;
            color: #10b981;
        }
        
        .highlight-card {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: white;
            border-radius: 8px;
            padding: 30px;
            text-align: center;
        }
        
        .highlight-card .label {
            font-size: 16px;
            margin-bottom: 10px;
            opacity: 0.9;
        }
        
        .highlight-card .value {
            font-size: 36px;
            font-weight: bold;
        }
        
        .highlight-card .period {
            font-size: 14px;
            margin-top: 5px;
            opacity: 0.8;
        }
        
        @media print {
            body {
                padding: 0;
            }
            .stats-grid {
                grid-template-columns: repeat(4, 1fr);
            }
        }
        
        @page {
            margin: 1cm;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>Laporan Pendapatan</h1>
        <h2>Elearning</h2>
        <div class="date">Dicetak pada: {{ now()->format('d F Y H:i') }}</div>
    </div>

    <!-- Stats Cards -->
    <div class="stats-grid">
        <div class="stat-card">
            <div class="label">Total Users</div>
            <div class="value">{{ $totalUsers }}</div>
        </div>
        <div class="stat-card">
            <div class="label">Pembayaran Pending</div>
            <div class="value">{{ $pendingPayments }}</div>
        </div>
        <div class="stat-card">
            <div class="label">Total Materi</div>
            <div class="value">{{ $totalMaterials }}</div>
        </div>
        <div class="stat-card">
            <div class="label">Total Pendapatan</div>
            <div class="value">Rp {{ number_format($totalRevenue, 0, ',', '.') }}</div>
        </div>
    </div>

    <!-- Recent Pending Payments -->
    <div class="section">
        <div class="section-title">5 Pembayaran Terbaru (Pending)</div>
        <table>
            <thead>
                <tr>
                    <th>No</th>
                    <th>User</th>
                    <th>Paket</th>
                    <th>Jumlah</th>
                    <th>Tanggal</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                @forelse($recentPending as $index => $payment)
                <tr>
                    <td>{{ $index + 1 }}</td>
                    <td>{{ $payment->user->name ?? '-' }}</td>
                    <td>{{ $payment->package->display_name ?? $payment->package->name ?? '-' }}</td>
                    <td>Rp {{ number_format($payment->amount, 0, ',', '.') }}</td>
                    <td>{{ $payment->created_at->format('d M Y') }}</td>
                    <td>Pending</td>
                </tr>
                @empty
                <tr>
                    <td colspan="6" style="text-align: center;">Tidak ada pembayaran pending</td>
                </tr>
                @endforelse
            </tbody>
        </table>
    </div>

    <div class="grid-2">
        <!-- Monthly Revenue 2026 -->
        <div class="section">
            <div class="section-title">Pendapatan Per Bulan (2026)</div>
            <table>
                <thead>
                    <tr>
                        <th>Bulan</th>
                        <th>Total Pendapatan</th>
                    </tr>
                </thead>
                <tbody>
                    @foreach($monthlyRevenueData as $data)
                    <tr>
                        <td>{{ $data['month_name'] }}</td>
                        <td>Rp {{ number_format($data['total'], 0, ',', '.') }}</td>
                    </tr>
                    @endforeach
                </tbody>
            </table>
        </div>

        <!-- Revenue Per Package -->
        <div class="section">
            <div class="section-title">Pendapatan Per Paket</div>
            @forelse($revenuePerPackage as $package)
            <div class="revenue-item">
                <span class="name">{{ $package->display_name ?? $package->package_name }}</span>
                <span class="amount">Rp {{ number_format($package->total, 0, ',', '.') }}</span>
            </div>
            @empty
            <p style="text-align: center; color: #666;">Tidak ada data pendapatan per paket</p>
            @endforelse
        </div>
    </div>

    <div class="grid-2">
        <!-- Annual Revenue -->
        <div class="section">
            <div class="section-title">Pendapatan Per Tahun</div>
            @forelse($annualRevenue as $year)
            <div class="revenue-item">
                <span class="name">{{ $year->year }}</span>
                <span class="amount">Rp {{ number_format($year->total, 0, ',', '.') }}</span>
            </div>
            @empty
            <p style="text-align: center; color: #666;">Tidak ada data pendapatan tahunan</p>
            @endforelse
        </div>

        <!-- Current Month Revenue -->
        <div class="section">
            <div class="section-title">Pendapatan Bulan Ini</div>
            <div class="highlight-card">
                <div class="label">Total Pendapatan</div>
                <div class="value">Rp {{ number_format($currentMonthRevenue, 0, ',', '.') }}</div>
                <div class="period">{{ now()->format('F Y') }}</div>
            </div>
        </div>
    </div>

    <div style="margin-top: 50px; text-align: center; color: #666; font-size: 12px;">
        <p>Laporan ini dibuat secara otomatis oleh sistem Elearning</p>
    </div>

    <script>
        window.onload = function() {
            window.print();
        };
    </script>
</body>
</html>

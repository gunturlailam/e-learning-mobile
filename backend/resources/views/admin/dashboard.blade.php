@extends('admin.layout')

@section('title', 'Laporan Pendapatan')
@section('page-title', 'Laporan Pendapatan Elearning')

@push('styles')
<style>
    @media print {
        .no-print { display: none !important; }
        .print-only { display: block !important; }
        body { background: white; }
        .shadow-lg { box-shadow: none !important; }
    }
    .print-only { display: none; }

    /* Premium SaaS Dashboard Design */
    .dashboard-container {
        background: transparent;
        min-height: 100vh;
        padding: 0;
    }

    .stat-card {
        background: rgba(255, 255, 255, 0.03);
        backdrop-filter: blur(10px);
        border-radius: 12px;
        padding: 1.25rem;
        border: 1px solid rgba(255, 255, 255, 0.08);
        transition: all 0.2s ease;
        position: relative;
        overflow: hidden;
    }

    .stat-card::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 1px;
        background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.1), transparent);
        opacity: 0;
        transition: opacity 0.2s ease;
    }

    .stat-card:hover::before {
        opacity: 1;
    }

    .stat-card:hover {
        background: rgba(255, 255, 255, 0.06);
        border-color: rgba(255, 255, 255, 0.12);
        transform: translateY(-2px);
    }

    .stat-card-blue {
        background: linear-gradient(135deg, rgba(99, 102, 241, 0.08) 0%, rgba(139, 92, 246, 0.08) 100%);
    }

    .stat-card-blue:hover {
        background: linear-gradient(135deg, rgba(99, 102, 241, 0.12) 0%, rgba(139, 92, 246, 0.12) 100%);
    }

    .stat-card-yellow {
        background: linear-gradient(135deg, rgba(245, 158, 11, 0.08) 0%, rgba(239, 68, 68, 0.08) 100%);
    }

    .stat-card-yellow:hover {
        background: linear-gradient(135deg, rgba(245, 158, 11, 0.12) 0%, rgba(239, 68, 68, 0.12) 100%);
    }

    .stat-card-green {
        background: linear-gradient(135deg, rgba(16, 185, 129, 0.08) 0%, rgba(6, 182, 212, 0.08) 100%);
    }

    .stat-card-green:hover {
        background: linear-gradient(135deg, rgba(16, 185, 129, 0.12) 0%, rgba(6, 182, 212, 0.12) 100%);
    }

    .stat-card-purple {
        background: linear-gradient(135deg, rgba(168, 85, 247, 0.08) 0%, rgba(236, 72, 153, 0.08) 100%);
    }

    .stat-card-purple:hover {
        background: linear-gradient(135deg, rgba(168, 85, 247, 0.12) 0%, rgba(236, 72, 153, 0.12) 100%);
    }

    .stat-icon {
        width: 40px;
        height: 40px;
        border-radius: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.1rem;
        transition: all 0.2s ease;
    }

    .stat-card:hover .stat-icon {
        transform: scale(1.05);
    }

    .stat-value {
        font-size: 1.75rem;
        font-weight: 600;
        color: white;
        line-height: 1.2;
        letter-spacing: -0.5px;
    }

    .stat-label {
        font-size: 0.75rem;
        color: rgba(255, 255, 255, 0.6);
        font-weight: 500;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .content-card {
        background: rgba(255, 255, 255, 0.03);
        backdrop-filter: blur(10px);
        border-radius: 12px;
        padding: 1.5rem;
        border: 1px solid rgba(255, 255, 255, 0.08);
        transition: all 0.2s ease;
    }

    .content-card:hover {
        border-color: rgba(255, 255, 255, 0.12);
        background: rgba(255, 255, 255, 0.05);
    }

    .card-header {
        display: flex;
        align-items: center;
        gap: 0.75rem;
        margin-bottom: 1rem;
        padding-bottom: 1rem;
        border-bottom: 1px solid rgba(255, 255, 255, 0.06);
    }

    .card-title {
        font-size: 1rem;
        font-weight: 600;
        color: white;
        letter-spacing: -0.3px;
    }

    .card-icon {
        width: 32px;
        height: 32px;
        border-radius: 8px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 0.9rem;
    }

    .modern-table {
        width: 100%;
        border-collapse: separate;
        border-spacing: 0;
    }

    .modern-table th {
        background: rgba(255, 255, 255, 0.03);
        padding: 0.75rem 1rem;
        text-align: left;
        font-weight: 500;
        color: rgba(255, 255, 255, 0.5);
        font-size: 0.7rem;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        border-bottom: 1px solid rgba(255, 255, 255, 0.06);
    }

    .modern-table td {
        padding: 0.75rem 1rem;
        border-bottom: 1px solid rgba(255, 255, 255, 0.04);
        color: rgba(255, 255, 255, 0.8);
        font-size: 0.8rem;
        font-weight: 400;
    }

    .modern-table tr:hover td {
        background: rgba(255, 255, 255, 0.02);
    }

    .modern-table tr:last-child td {
        border-bottom: none;
    }

    .status-badge {
        padding: 0.25rem 0.625rem;
        border-radius: 6px;
        font-size: 0.7rem;
        font-weight: 500;
        text-transform: uppercase;
        letter-spacing: 0.3px;
    }

    .status-pending {
        background: rgba(251, 191, 36, 0.15);
        color: #fbbf24;
        border: 1px solid rgba(251, 191, 36, 0.2);
    }

    .progress-bar {
        height: 4px;
        border-radius: 2px;
        background: rgba(255, 255, 255, 0.08);
        overflow: hidden;
    }

    .progress-fill {
        height: 100%;
        border-radius: 2px;
        background: linear-gradient(90deg, #818cf8 0%, #a78bfa 100%);
        transition: width 0.3s ease;
    }

    .revenue-item {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0.75rem 1rem;
        background: rgba(255, 255, 255, 0.02);
        border-radius: 8px;
        margin-bottom: 0.5rem;
        transition: all 0.15s ease;
        border: 1px solid transparent;
    }

    .revenue-item:hover {
        background: rgba(255, 255, 255, 0.04);
        border-color: rgba(255, 255, 255, 0.08);
    }

    .print-btn {
        background: rgba(255, 255, 255, 0.1);
        color: white;
        padding: 0.5rem 1rem;
        border-radius: 8px;
        font-weight: 500;
        display: flex;
        align-items: center;
        gap: 0.5rem;
        transition: all 0.2s ease;
        border: 1px solid rgba(255, 255, 255, 0.1);
        font-size: 0.875rem;
    }

    .print-btn:hover {
        background: rgba(255, 255, 255, 0.15);
        border-color: rgba(255, 255, 255, 0.2);
    }

    .highlight-card {
        background: linear-gradient(135deg, rgba(99, 102, 241, 0.1) 0%, rgba(168, 85, 247, 0.1) 100%);
        border-radius: 12px;
        padding: 1.5rem;
        color: white;
        text-align: center;
        border: 1px solid rgba(255, 255, 255, 0.08);
    }

    .highlight-value {
        font-size: 2rem;
        font-weight: 600;
        margin-bottom: 0.25rem;
        letter-spacing: -0.5px;
    }

    .highlight-label {
        font-size: 0.75rem;
        opacity: 0.7;
        margin-bottom: 0.25rem;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        font-weight: 500;
    }

    .highlight-period {
        font-size: 0.7rem;
        opacity: 0.5;
        font-weight: 400;
    }
</style>
@endpush

@section('content')
<div class="dashboard-container">
    <!-- Header -->
    <div class="flex justify-between items-center mb-8 no-print">
        <div>
            <h1 class="text-xl font-semibold text-white mb-1 tracking-tight">Ringkasan Laporan</h1>
            <p class="text-gray-400 text-sm">Pantau performa bisnis e-learning Anda secara real-time</p>
        </div>
        <a href="{{ route('admin.dashboard.print') }}" target="_blank" class="print-btn">
            <i class="fas fa-print text-sm"></i>
            Cetak Laporan
        </a>
    </div>

    <!-- Stats Cards -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
        <!-- Total Users -->
        <div class="stat-card stat-card-blue">
            <div class="flex items-center justify-between">
                <div>
                    <p class="stat-label">Total Users</p>
                    <h3 class="stat-value">{{ $totalUsers }}</h3>
                </div>
                <div class="stat-icon">
                    <i class="fas fa-users text-white"></i>
                </div>
            </div>
        </div>

        <!-- Pending Payments -->
        <div class="stat-card stat-card-yellow">
            <div class="flex items-center justify-between">
                <div>
                    <p class="stat-label">Pembayaran Pending</p>
                    <h3 class="stat-value">{{ $pendingPayments }}</h3>
                </div>
                <div class="stat-icon">
                    <i class="fas fa-clock text-white"></i>
                </div>
            </div>
        </div>

        <!-- Total Materials -->
        <div class="stat-card stat-card-green">
            <div class="flex items-center justify-between">
                <div>
                    <p class="stat-label">Total Materi</p>
                    <h3 class="stat-value">{{ $totalMaterials }}</h3>
                </div>
                <div class="stat-icon">
                    <i class="fas fa-book text-white"></i>
                </div>
            </div>
        </div>

        <!-- Total Revenue -->
        <div class="stat-card stat-card-purple">
            <div class="flex items-center justify-between">
                <div>
                    <p class="stat-label">Total Pendapatan</p>
                    <h3 class="stat-value">{{ number_format($totalRevenue, 0, ',', '.') }}</h3>
                </div>
                <div class="stat-icon">
                    <i class="fas fa-money-bill-wave text-white"></i>
                </div>
            </div>
        </div>
    </div>

    <!-- Recent Pending Payments -->
    <div class="content-card mb-8">
        <div class="card-header">
            <div class="card-icon" style="background: rgba(245, 158, 11, 0.15);">
                <i class="fas fa-clock text-amber-400"></i>
            </div>
            <h3 class="card-title">5 Pembayaran Terbaru (Pending)</h3>
        </div>
        <div class="overflow-x-auto">
            <table class="modern-table">
                <thead>
                    <tr>
                        <th>User</th>
                        <th>Paket</th>
                        <th>Jumlah</th>
                        <th>Tanggal</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    @forelse($recentPending as $payment)
                    <tr>
                        <td>{{ $payment->user->name ?? '-' }}</td>
                        <td>{{ $payment->package->display_name ?? $payment->package->name ?? '-' }}</td>
                        <td>Rp {{ number_format($payment->amount, 0, ',', '.') }}</td>
                        <td>{{ $payment->created_at->format('d M Y') }}</td>
                        <td>
                            <span class="status-badge status-pending">Pending</span>
                        </td>
                    </tr>
                    @empty
                    <tr>
                        <td colspan="5" class="text-center py-8 text-gray-500 text-sm">Tidak ada pembayaran pending</td>
                    </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-2 gap-4 mb-8">
        <!-- Monthly Revenue 2026 -->
        <div class="content-card">
            <div class="card-header">
                <div class="card-icon" style="background: rgba(99, 102, 241, 0.15);">
                    <i class="fas fa-chart-line text-indigo-400"></i>
                </div>
                <h3 class="card-title">Pendapatan Per Bulan (2026)</h3>
            </div>
            <div class="space-y-3">
                @foreach($monthlyRevenueData as $data)
                <div>
                    <div class="flex items-center justify-between mb-1">
                        <span class="text-xs text-gray-400">{{ $data['month_name'] }}</span>
                        <span class="text-xs font-medium text-white">Rp {{ number_format($data['total'], 0, ',', '.') }}</span>
                    </div>
                    @php
                    $maxRevenue = collect($monthlyRevenueData)->max('total');
                    $percentage = $maxRevenue > 0 ? ($data['total'] / $maxRevenue) * 100 : 0;
                    @endphp
                    <div class="progress-bar">
                        <div class="progress-fill" style="width: {{ $percentage }}%"></div>
                    </div>
                </div>
                @endforeach
            </div>
        </div>

        <!-- Revenue Per Package -->
        <div class="content-card">
            <div class="card-header">
                <div class="card-icon" style="background: rgba(16, 185, 129, 0.15);">
                    <i class="fas fa-box text-emerald-400"></i>
                </div>
                <h3 class="card-title">Pendapatan Per Paket</h3>
            </div>
            <div class="space-y-2">
                @forelse($revenuePerPackage as $package)
                <div class="revenue-item">
                    <div>
                        <p class="font-medium text-white text-xs">{{ $package->display_name ?? $package->package_name }}</p>
                        <p class="text-xs text-gray-500">{{ $package->count }} pembayaran</p>
                    </div>
                    <span class="font-medium text-emerald-400 text-xs">
                        Rp {{ number_format($package->total, 0, ',', '.') }}
                    </span>
                </div>
                @empty
                <p class="text-gray-500 text-center py-4 text-xs">Tidak ada data pendapatan per paket</p>
                @endforelse
            </div>
        </div>
    </div>

    <!-- Annual Revenue & Current Month -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-4">
        <!-- Annual Revenue -->
        <div class="content-card">
            <div class="card-header">
                <div class="card-icon" style="background: rgba(99, 102, 241, 0.15);">
                    <i class="fas fa-calendar-alt text-indigo-400"></i>
                </div>
                <h3 class="card-title">Pendapatan Per Tahun</h3>
            </div>
            <div class="space-y-2">
                @forelse($annualRevenue as $year)
                <div class="revenue-item">
                    <span class="font-medium text-white text-xs">{{ $year->year }}</span>
                    <span class="font-medium text-purple-400 text-xs">
                        Rp {{ number_format($year->total, 0, ',', '.') }}
                    </span>
                </div>
                @empty
                <p class="text-gray-500 text-center py-4 text-xs">Tidak ada data pendapatan tahunan</p>
                @endforelse
            </div>
        </div>

        <!-- Current Month Revenue -->
        <div class="highlight-card">
            <div class="highlight-label">Pendapatan Bulan Ini</div>
            <div class="highlight-value">Rp {{ number_format($currentMonthRevenue, 0, ',', '.') }}</div>
            <div class="highlight-period">{{ now()->format('F Y') }}</div>
        </div>
    </div>
</div>
@endsection
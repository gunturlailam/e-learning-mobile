<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\Payment;
use App\Models\LearningMaterial;
use App\Models\Package;
use Illuminate\Support\Facades\DB;

class AdminDashboardController extends Controller
{
    public function index()
    {
        // 1. Hitung jumlah user
        $totalUsers = User::count();

        // 2. Hitung pembayaran pending
        $pendingPayments = Payment::where('status', 'pending')->count();

        // 3. Hitung jumlah materi
        $totalMaterials = LearningMaterial::count();

        // 4. Hitung total pendapatan (dari pembayaran yang disetujui)
        $totalRevenue = Payment::where('status', 'approved')->sum('amount');

        // 5. Ambil 5 pembayaran terbaru (pending dengan user info)
        $recentPending = Payment::with('user', 'package')
            ->where('status', 'pending')
            ->latest()
            ->limit(5)
            ->get();

        // 6. Hitung pendapatan per bulan (untuk tahun 2026)
        $monthlyRevenue = Payment::where('status', 'approved')
            ->whereYear('created_at', 2026)
            ->selectRaw('MONTH(created_at) as month, SUM(amount) as total')
            ->groupBy('month')
            ->orderBy('month')
            ->get()
            ->keyBy('month');

        // Format data untuk 12 bulan
        $monthlyRevenueData = [];
        for ($i = 1; $i <= 12; $i++) {
            $monthlyRevenueData[] = [
                'month' => $i,
                'month_name' => date('F', mktime(0, 0, 0, $i, 1)),
                'total' => $monthlyRevenue->get($i)?->total ?? 0
            ];
        }

        // 7. Hitung pendapatan per paket
        $revenuePerPackage = Payment::where('status', 'approved')
            ->join('packages', 'payments.package_id', '=', 'packages.id')
            ->selectRaw('packages.name as package_name, packages.display_name, SUM(payments.amount) as total, COUNT(payments.id) as count')
            ->groupBy('packages.id', 'packages.name', 'packages.display_name')
            ->orderByDesc('total')
            ->get();

        // 8. Hitung pendapatan per tahun
        $annualRevenue = Payment::where('status', 'approved')
            ->selectRaw('YEAR(created_at) as year, SUM(amount) as total')
            ->groupBy('year')
            ->orderByDesc('year')
            ->get();

        // 9. Hitung pendapatan bulan ini
        $currentMonthRevenue = Payment::where('status', 'approved')
            ->whereYear('created_at', now()->year)
            ->whereMonth('created_at', now()->month)
            ->sum('amount');

        return view('admin.dashboard', compact(
            'totalUsers',
            'pendingPayments',
            'totalMaterials',
            'totalRevenue',
            'recentPending',
            'monthlyRevenueData',
            'revenuePerPackage',
            'annualRevenue',
            'currentMonthRevenue'
        ));
    }

    public function print()
    {
        // 1. Hitung jumlah user
        $totalUsers = User::count();

        // 2. Hitung pembayaran pending
        $pendingPayments = Payment::where('status', 'pending')->count();

        // 3. Hitung jumlah materi
        $totalMaterials = LearningMaterial::count();

        // 4. Hitung total pendapatan (dari pembayaran yang disetujui)
        $totalRevenue = Payment::where('status', 'approved')->sum('amount');

        // 5. Ambil 5 pembayaran terbaru (pending dengan user info)
        $recentPending = Payment::with('user', 'package')
            ->where('status', 'pending')
            ->latest()
            ->limit(5)
            ->get();

        // 6. Hitung pendapatan per bulan (untuk tahun 2026)
        $monthlyRevenue = Payment::where('status', 'approved')
            ->whereYear('created_at', 2026)
            ->selectRaw('MONTH(created_at) as month, SUM(amount) as total')
            ->groupBy('month')
            ->orderBy('month')
            ->get()
            ->keyBy('month');

        // Format data untuk 12 bulan
        $monthlyRevenueData = [];
        for ($i = 1; $i <= 12; $i++) {
            $monthlyRevenueData[] = [
                'month' => $i,
                'month_name' => date('F', mktime(0, 0, 0, $i, 1)),
                'total' => $monthlyRevenue->get($i)?->total ?? 0
            ];
        }

        // 7. Hitung pendapatan per paket
        $revenuePerPackage = Payment::where('status', 'approved')
            ->join('packages', 'payments.package_id', '=', 'packages.id')
            ->selectRaw('packages.name as package_name, packages.display_name, SUM(payments.amount) as total, COUNT(payments.id) as count')
            ->groupBy('packages.id', 'packages.name', 'packages.display_name')
            ->orderByDesc('total')
            ->get();

        // 8. Hitung pendapatan per tahun
        $annualRevenue = Payment::where('status', 'approved')
            ->selectRaw('YEAR(created_at) as year, SUM(amount) as total')
            ->groupBy('year')
            ->orderByDesc('year')
            ->get();

        // 9. Hitung pendapatan bulan ini
        $currentMonthRevenue = Payment::where('status', 'approved')
            ->whereYear('created_at', now()->year)
            ->whereMonth('created_at', now()->month)
            ->sum('amount');

        return view('admin.dashboard-print', compact(
            'totalUsers',
            'pendingPayments',
            'totalMaterials',
            'totalRevenue',
            'recentPending',
            'monthlyRevenueData',
            'revenuePerPackage',
            'annualRevenue',
            'currentMonthRevenue'
        ));
    }
}

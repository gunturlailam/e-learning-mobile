@extends('admin.layout')

@section('title', 'Manajemen Pembayaran')
@section('page-title', 'Pembayaran')

@section('content')
<div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-6">
        <div>
            <h3 class="text-xl font-bold text-gray-800">Manajemen Pembayaran</h3>
            <p class="text-sm text-gray-500">Kelola dan verifikasi bukti transfer pembayaran dari pengguna.</p>
        </div>
        
        <!-- Status Filter Tabs -->
        <div class="flex flex-wrap gap-2">
            <a href="{{ route('admin.payments.index') }}" 
               class="px-4 py-2 rounded-lg text-sm font-semibold transition-all {{ !$status ? 'bg-green-600 text-white shadow' : 'bg-gray-100 text-gray-600 hover:bg-gray-200' }}">
                Semua
            </a>
            <a href="{{ route('admin.payments.index', ['status' => 'pending']) }}" 
               class="px-4 py-2 rounded-lg text-sm font-semibold transition-all {{ $status === 'pending' ? 'bg-amber-500 text-white shadow' : 'bg-gray-100 text-gray-600 hover:bg-gray-200' }}">
                Pending
            </a>
            <a href="{{ route('admin.payments.index', ['status' => 'approved']) }}" 
               class="px-4 py-2 rounded-lg text-sm font-semibold transition-all {{ $status === 'approved' ? 'bg-green-600 text-white shadow' : 'bg-gray-100 text-gray-600 hover:bg-gray-200' }}">
                Disetujui
            </a>
            <a href="{{ route('admin.payments.index', ['status' => 'rejected']) }}" 
               class="px-4 py-2 rounded-lg text-sm font-semibold transition-all {{ $status === 'rejected' ? 'bg-red-600 text-white shadow' : 'bg-gray-100 text-gray-600 hover:bg-gray-200' }}">
                Ditolak
            </a>
        </div>
    </div>

    <!-- Table -->
    <div class="overflow-x-auto rounded-lg border border-gray-100">
        <table class="w-full text-left border-collapse">
            <thead>
                <tr class="bg-gray-50 border-b border-gray-100 text-xs font-bold text-gray-500 uppercase tracking-wider">
                    <th class="px-6 py-4">ID</th>
                    <th class="px-6 py-4">Pengguna</th>
                    <th class="px-6 py-4">Menu</th>
                    <th class="px-6 py-4">Jumlah</th>
                    <th class="px-6 py-4">Metode</th>
                    <th class="px-6 py-4">Status</th>
                    <th class="px-6 py-4">Tanggal</th>
                    <th class="px-6 py-4 text-right">Aksi</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-gray-100 text-sm text-gray-600">
                @forelse($payments as $payment)
                <tr class="hover:bg-gray-50 transition">
                    <td class="px-6 py-4 font-semibold text-gray-800">#{{ $payment->id }}</td>
                    <td class="px-6 py-4">
                        <div class="font-medium text-gray-900">{{ $payment->user->name ?? 'User Hilang' }}</div>
                        <div class="text-xs text-gray-400">{{ $payment->user->email ?? '' }}</div>
                    </td>
                    <td class="px-6 py-4 font-medium">{{ $payment->menu_name ?? ($payment->package->display_name ?? 'Paket') }}</td>
                    <td class="px-6 py-4 font-semibold text-gray-900">
                        Rp {{ number_format($payment->amount, 0, ',', '.') }}
                    </td>
                    <td class="px-6 py-4 text-xs font-mono text-gray-500">{{ $payment->method }}</td>
                    <td class="px-6 py-4">
                        @if($payment->status === 'pending')
                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-amber-100 text-amber-800">
                                <span class="w-1.5 h-1.5 mr-1.5 bg-amber-500 rounded-full"></span>
                                Pending
                            </span>
                        @elseif($payment->status === 'approved')
                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                <span class="w-1.5 h-1.5 mr-1.5 bg-green-500 rounded-full"></span>
                                Disetujui
                            </span>
                        @else
                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800">
                                <span class="w-1.5 h-1.5 mr-1.5 bg-red-500 rounded-full"></span>
                                Ditolak
                            </span>
                        @endif
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-gray-500">
                        {{ $payment->created_at ? $payment->created_at->format('d M Y') : '-' }}
                    </td>
                    <td class="px-6 py-4 text-right whitespace-nowrap">
                        <a href="{{ route('admin.payments.show', $payment->id) }}" 
                           class="text-green-600 hover:text-green-800 hover:underline font-semibold text-sm">
                            Detail
                        </a>
                    </td>
                </tr>
                @empty
                <tr>
                    <td colspan="8" class="text-center py-8 text-gray-400">
                        Tidak ada data pembayaran.
                    </td>
                </tr>
                @endforelse
            </tbody>
        </table>
    </div>

    <!-- Pagination -->
    <div class="mt-4">
        {{ $payments->links() }}
    </div>
</div>
@endsection

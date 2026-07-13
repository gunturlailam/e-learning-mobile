@extends('admin.layout')

@section('title', 'Detail Pembayaran #' . $payment->id)
@section('page-title', 'Detail Pembayaran')

@section('content')
<div class="mb-6">
    <a href="{{ route('admin.payments.index') }}" class="inline-flex items-center text-green-600 hover:text-green-800 font-semibold text-sm transition">
        <i class="fas fa-arrow-left mr-2"></i> Kembali ke daftar
    </a>
</div>

<div class="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-8">
    <!-- Left Card: Payment Information -->
    <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6 flex flex-col justify-between">
        <div>
            <h3 class="text-lg font-bold text-gray-800 mb-6">Informasi Pembayaran #{{ $payment->id }}</h3>
            
            <div class="space-y-4">
                <div class="flex justify-between py-2 border-b border-gray-50">
                    <span class="text-gray-500 font-medium">Pengguna:</span>
                    <span class="text-gray-900 font-semibold">{{ $payment->user->name ?? 'User Hilang' }}</span>
                </div>
                <div class="flex justify-between py-2 border-b border-gray-50">
                    <span class="text-gray-500 font-medium">Email:</span>
                    <span class="text-gray-900 font-semibold">{{ $payment->user->email ?? '-' }}</span>
                </div>
                <div class="flex justify-between py-2 border-b border-gray-50">
                    <span class="text-gray-500 font-medium">Menu:</span>
                    <span class="text-gray-900 font-semibold">{{ $payment->menu_name ?? ($payment->package->display_name ?? '-') }}</span>
                </div>
                <div class="flex justify-between py-2 border-b border-gray-50">
                    <span class="text-gray-500 font-medium">Jumlah:</span>
                    <span class="text-gray-900 font-bold text-base">Rp {{ number_format($payment->amount, 0, ',', '.') }}</span>
                </div>
                <div class="flex justify-between py-2 border-b border-gray-50">
                    <span class="text-gray-500 font-medium">Metode:</span>
                    <span class="text-gray-900 font-mono font-semibold">{{ $payment->method }}</span>
                </div>
                <div class="flex justify-between py-2 border-b border-gray-50">
                    <span class="text-gray-500 font-medium">Status:</span>
                    <span>
                        @if($payment->status === 'pending')
                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-amber-100 text-amber-800">
                                Pending
                            </span>
                        @elseif($payment->status === 'approved')
                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                                Disetujui
                            </span>
                        @else
                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800">
                                Ditolak
                            </span>
                        @endif
                    </span>
                </div>
                <div class="flex justify-between py-2 border-b border-gray-50">
                    <span class="text-gray-500 font-medium">Tanggal:</span>
                    <span class="text-gray-900 font-semibold">{{ $payment->created_at ? $payment->created_at->format('d M Y H:i') : '-' }}</span>
                </div>
                
                @if($payment->status === 'rejected' && $payment->reject_reason)
                <div class="mt-4 p-4 bg-red-50 rounded-lg border border-red-100 text-sm">
                    <span class="block font-bold text-red-800 mb-1">Alasan Penolakan:</span>
                    <span class="text-red-700">{{ $payment->reject_reason }}</span>
                </div>
                @endif

                @if($payment->status === 'approved' && $payment->approved_at)
                <div class="mt-4 p-4 bg-green-50 rounded-lg border border-green-100 text-sm">
                    <span class="block font-bold text-green-800 mb-1">Disetujui Pada:</span>
                    <span class="text-green-700">{{ $payment->approved_at->format('d M Y H:i') }}</span>
                </div>
                @endif
            </div>
        </div>
    </div>

    <!-- Right Card: Proof of Payment -->
    <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6 flex flex-col">
        <h3 class="text-lg font-bold text-gray-800 mb-6">Bukti Pembayaran</h3>
        
        <div class="flex-1 flex flex-col items-center justify-center border-2 border-dashed border-gray-200 rounded-xl p-8 bg-gray-50 text-center min-h-[300px]">
            @if($payment->proof)
                @php
                    $isPdf = Str::endsWith(strtolower($payment->proof), '.pdf');
                @endphp

                @if($isPdf)
                    <div class="flex flex-col items-center">
                        <div class="w-16 h-16 bg-red-100 rounded-2xl flex items-center justify-center text-red-600 text-3xl font-bold mb-4 shadow-sm">
                            <i class="far fa-file-pdf"></i>
                        </div>
                        <p class="font-bold text-gray-800 mb-1">Bukti dalam format PDF</p>
                        <p class="text-xs text-gray-400 mb-4">{{ basename($payment->proof) }}</p>
                        <a href="{{ $payment->proof_url }}" target="_blank"
                           class="px-6 py-2.5 bg-green-600 text-white text-sm font-semibold rounded-lg hover:bg-green-700 shadow hover:shadow-md transition">
                            Lihat PDF
                        </a>
                    </div>
                @else
                    <div class="flex flex-col items-center w-full">
                        <div class="max-w-[320px] max-h-[220px] overflow-hidden rounded-lg border border-gray-200 shadow-sm mb-4 bg-white">
                            <img src="{{ $payment->proof_url }}" alt="Bukti Pembayaran" class="object-contain w-full h-full max-h-[200px]">
                        </div>
                        <a href="{{ $payment->proof_url }}" target="_blank"
                           class="px-6 py-2.5 bg-green-600 text-white text-sm font-semibold rounded-lg hover:bg-green-700 shadow hover:shadow-md transition">
                            Lihat Full Gambar
                        </a>
                    </div>
                @endif
            @else
                <div class="flex flex-col items-center">
                    <div class="w-16 h-16 bg-gray-200 rounded-full flex items-center justify-center text-gray-400 text-2xl mb-4">
                        <i class="fas fa-file-invoice"></i>
                    </div>
                    <p class="font-bold text-gray-500 mb-1">Bukti belum diunggah</p>
                    <p class="text-xs text-gray-400">Pengguna belum melampirkan bukti transfer pembayaran.</p>
                </div>
            @endif
        </div>
    </div>
</div>

<!-- Bottom Card: Actions -->
<div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
    <h3 class="text-lg font-bold text-gray-800 mb-4">Tindakan</h3>
    
    @if($payment->status === 'pending')
        <div class="flex flex-col md:flex-row items-center gap-4">
            <!-- Approve Button Form -->
            <form action="{{ route('admin.payments.approve', $payment->id) }}" method="POST" class="w-full md:w-auto">
                @csrf
                <button type="submit" 
                        class="w-full md:w-auto px-6 py-3 bg-green-600 hover:bg-green-700 text-white font-bold rounded-lg shadow-sm hover:shadow transition text-center">
                    Setujui
                </button>
            </form>
            
            <!-- Reject Form -->
            <form action="{{ route('admin.payments.reject', $payment->id) }}" method="POST" class="flex-1 w-full flex items-center gap-3">
                @csrf
                <input type="text" name="reject_reason" required placeholder="Alasan penolakan..." 
                       class="flex-1 px-4 py-3 bg-gray-50 border border-gray-200 rounded-lg text-sm focus:outline-none focus:border-red-500 focus:bg-white transition">
                
                <button type="submit" 
                        class="px-6 py-3 bg-red-600 hover:bg-red-700 text-white font-bold rounded-lg shadow-sm hover:shadow transition">
                    Tolak
                </button>
            </form>
        </div>
    @else
        <div class="p-4 bg-gray-50 rounded-lg text-sm text-gray-500">
            Status pembayaran ini adalah <span class="font-bold text-gray-800">{{ strtoupper($payment->status) }}</span>. Tidak ada tindakan lebih lanjut yang diperlukan.
        </div>
    @endif
</div>
@endsection

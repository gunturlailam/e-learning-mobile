<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Payment;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class AdminPaymentController extends Controller
{
    /**
     * Tampilkan daftar semua pembayaran dengan filter.
     */
    public function index(Request $request): View
    {
        $status = $request->query('status');
        $query = Payment::with(['user', 'package'])->latest();

        if ($status && in_array($status, ['pending', 'approved', 'rejected'])) {
            $query->where('status', $status);
        }

        $payments = $query->paginate(15)->withQueryString();

        return view('admin.payments.index', compact('payments', 'status'));
    }

    /**
     * Tampilkan detail pembayaran tertentu.
     */
    public function show(int $id): View
    {
        $payment = Payment::with(['user', 'package'])->findOrFail($id);
        return view('admin.payments.show', compact('payment'));
    }

    /**
     * Setujui pembayaran.
     */
    public function approve(int $id): RedirectResponse
    {
        $payment = Payment::findOrFail($id);
        
        $payment->update([
            'status' => 'approved',
            'approved_at' => now(),
            'reject_reason' => null
        ]);

        return redirect()->route('admin.payments.index')->with('success', 'Pembayaran #' . $id . ' berhasil disetujui!');
    }

    /**
     * Tolak pembayaran.
     */
    public function reject(Request $request, int $id): RedirectResponse
    {
        $payment = Payment::findOrFail($id);

        $request->validate([
            'reject_reason' => 'required|string|max:1000'
        ]);

        $payment->update([
            'status' => 'rejected',
            'reject_reason' => $request->input('reject_reason'),
            'approved_at' => null
        ]);

        return redirect()->route('admin.payments.index')->with('success', 'Pembayaran #' . $id . ' berhasil ditolak.');
    }
}

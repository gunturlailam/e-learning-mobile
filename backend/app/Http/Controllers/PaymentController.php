<?php

namespace App\Http\Controllers;

use App\Models\Payment;
use App\Models\Package;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;

class PaymentController extends Controller
{
    /**
     * API: Membuat record pembayaran baru
     */
    public function createPayment(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'method' => 'required|in:bank_transfer,qr_code',
            'package_id' => 'nullable|integer',
            'menu_name' => 'required_without:package_id|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors()
            ], 422);
        }

        $user = $request->user();
        $package = null;
        $menuName = $request->input('menu_name');
        $packageId = $request->input('package_id');

        if ($packageId) {
            $package = Package::find($packageId);
        } elseif ($menuName) {
            $package = Package::where('name', $menuName)
                ->orWhere('display_name', $menuName)
                ->first();
        }

        if (!$package) {
            return response()->json([
                'success' => false,
                'message' => 'Paket belajar tidak ditemukan'
            ], 404);
        }

        // Cek jika sudah ada transaksi pending untuk paket ini
        $existing = Payment::where('user_id', $user->id)
            ->where('package_id', $package->id)
            ->where('status', 'pending')
            ->first();

        if ($existing) {
            // Gunakan data pending yang sudah ada
            $data = $existing->toArray();
            $data['payment_id'] = $existing->id; // Pastikan payment_id ada untuk kompatibilitas
            return response()->json([
                'success' => true,
                'message' => 'Pembayaran pending ditemukan',
                'data' => $data
            ], 201); // 201 agar sesuai dengan validasi response Flutter di modul
        }

        // Buat pembayaran baru
        $payment = Payment::create([
            'user_id' => $user->id,
            'package_id' => $package->id,
            'menu_name' => $package->name, // Simpan package name (misal: 'speaking') agar sinkron
            'amount' => $package->price,
            'method' => $request->input('method'),
            'status' => 'pending',
        ]);

        $data = $payment->toArray();
        $data['payment_id'] = $payment->id; // Tambahkan payment_id

        return response()->json([
            'success' => true,
            'message' => 'Pembayaran berhasil dibuat',
            'data' => $data
        ], 201);
    }

    /**
     * API: Mendapatkan daftar pembayaran milik user saat ini
     */
    public function getMyPayments(Request $request): JsonResponse
    {
        $user = $request->user();
        $payments = Payment::where('user_id', $user->id)
            ->latest()
            ->get();

        return response()->json([
            'success' => true,
            'data' => $payments
        ]);
    }

    /**
     * API: Mendapatkan status detail satu pembayaran
     */
    public function getPaymentStatus(Request $request, $id): JsonResponse
    {
        $user = $request->user();
        $payment = Payment::where('user_id', $user->id)->findOrFail($id);

        return response()->json([
            'success' => true,
            'data' => $payment
        ]);
    }

    /**
     * API: Mengunggah bukti pembayaran (PDF atau gambar)
     */
    public function uploadProof(Request $request, $id): JsonResponse
    {
        $user = $request->user();
        $payment = Payment::where('user_id', $user->id)->findOrFail($id);

        $validator = Validator::make($request->all(), [
            'proof' => 'required|file|mimes:pdf,jpg,jpeg,png|max:5120',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Upload bukti gagal. Harus berupa PDF/Gambar maksimal 5MB.',
                'errors' => $validator->errors()
            ], 422);
        }

        if ($request->hasFile('proof')) {
            // Hapus bukti lama jika ada
            if ($payment->proof) {
                Storage::disk('public')->delete($payment->proof);
            }

            // Simpan file bukti pembayaran baru
            $path = $request->file('proof')->store('proofs', 'public');
            
            $payment->update([
                'proof' => $path,
                'status' => 'pending' // Reset ke pending jika upload ulang
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Bukti pembayaran berhasil diunggah'
            ]);
        }

        return response()->json([
            'success' => false,
            'message' => 'File bukti pembayaran tidak ditemukan'
        ], 400);
    }
}

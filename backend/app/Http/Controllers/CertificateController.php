<?php

namespace App\Http\Controllers;

use App\Models\Certificate;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class CertificateController extends Controller
{
    /**
     * API: Get all certificates earned by the authenticated user.
     */
    public function myCertificates(Request $request): JsonResponse
    {
        $certificates = Certificate::with(['package'])
            ->where('user_id', $request->user()->id)
            ->orderBy('issued_at', 'desc')
            ->get();

        return response()->json([
            'success' => true,
            'data' => $certificates,
        ]);
    }

    /**
     * Web: Show a certificate earned from a quiz attempt.
     */
    public function showWebCertificate($attemptId)
    {
        $attempt = \App\Models\QuizAttempt::with(['user', 'quiz.package'])->findOrFail($attemptId);

        if (!$attempt->passed) {
            abort(403, 'Sertifikat tidak tersedia karena kuis ini belum lulus.');
        }

        $certificate = Certificate::where('user_id', $attempt->user_id)
            ->where('package_id', $attempt->quiz->package_id)
            ->first();

        if (!$certificate) {
            $certificate = Certificate::firstOrCreate(
                [
                    'user_id' => $attempt->user_id,
                    'package_id' => $attempt->quiz->package_id,
                ],
                [
                    'certificate_code' => 'ZAF-' . str_pad($attempt->id, 6, '0', STR_PAD_LEFT),
                    'issued_at' => $attempt->created_at ?? now(),
                ]
            );
        }

        return view('certificate', [
            'attempt' => $attempt,
            'certificate' => $certificate,
            'user' => $attempt->user,
            'package' => $attempt->quiz->package,
        ]);
    }
}


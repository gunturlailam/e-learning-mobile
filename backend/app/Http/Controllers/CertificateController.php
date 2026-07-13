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
}

<?php

namespace App\Http\Controllers;

use App\Models\Package;

class PackageController extends Controller
{
    /**
     * API: list semua paket kursus (untuk aplikasi mobile).
     */
    public function index()
    {
        $packages = Package::withCount('materials')
            ->orderBy('sort_order')
            ->get()
            ->map(function ($package) {
                $package->thumbnail_url = $package->thumbnail
                    ? asset('storage/' . $package->thumbnail)
                    : null;
                return $package;
            });

        return response()->json([
            'success' => true,
            'data'    => $packages,
        ]);
    }

    /**
     * API: detail satu paket beserta materinya.
     */
    public function show($id)
    {
        $package = Package::with('materials')->withCount('materials')->findOrFail($id);

        $package->thumbnail_url = $package->thumbnail
            ? asset('storage/' . $package->thumbnail)
            : null;

        $package->materials->transform(function ($item) {
            $item->video_url = $item->video ? asset('storage/' . $item->video) : null;
            $item->pdf_url   = $item->pdf   ? asset('storage/' . $item->pdf)   : null;
            return $item;
        });

        return response()->json([
            'success' => true,
            'data'    => $package,
        ]);
    }
}

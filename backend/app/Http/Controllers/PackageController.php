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
                    ? (filter_var($package->thumbnail, FILTER_VALIDATE_URL) ? $package->thumbnail : asset('storage/' . $package->thumbnail))
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
            ? (filter_var($package->thumbnail, FILTER_VALIDATE_URL) ? $package->thumbnail : asset('storage/' . $package->thumbnail))
            : null;

        $quiz = \App\Models\Quiz::where('package_id', $id)->first();

        $packageArray = $package->toArray();
        $packageArray['thumbnail_url'] = $package->thumbnail_url;
        $packageArray['has_quiz'] = !is_null($quiz);
        $packageArray['quiz_title'] = $quiz ? $quiz->title : null;

        $packageArray['materials'] = $package->materials->map(function ($item) {
            $itemArray = $item->toArray();
            $itemArray['video_url'] = $item->video
                ? (filter_var($item->video, FILTER_VALIDATE_URL) ? $item->video : asset('storage/' . $item->video))
                : null;
            $itemArray['pdf_url'] = $item->pdf
                ? (filter_var($item->pdf, FILTER_VALIDATE_URL) ? $item->pdf : asset('storage/' . $item->pdf))
                : null;
            return $itemArray;
        })->toArray();

        return response()->json([
            'success' => true,
            'data'    => $packageArray,
        ]);
    }
}

<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\SpeakingMaterial;

class SpeakingController extends Controller
{
    // API LIST MATERI
    public function index()
    {
        $materials = SpeakingMaterial::all();

        foreach ($materials as $item) {
            $item->video_url = asset('storage/' . $item->video);
            $item->pdf_url = asset('storage/' . $item->pdf);
        }

        return response()->json($materials);
    }

    // API UPLOAD MATERI
    public function store(Request $request)
    {
        $request->validate([
            'title' => 'required',
            'video' => 'required|mimes:mp4,mov,avi',
            'pdf' => 'nullable|mimes:pdf'
        ]);

        $video = $request->file('video')->store('videos', 'public');

        $pdf = null;
        if ($request->hasFile('pdf')) {
            $pdf = $request->file('pdf')->store('pdfs', 'public');
        }

        $material = SpeakingMaterial::create([
            'title' => $request->title,
            'description' => $request->description,
            'video' => $video,
            'pdf' => $pdf,
        ]);

        return response()->json([
            'message' => 'Materi berhasil upload',
            'data' => $material
        ]);
    }

    // API SAVE PROGRESS
    public function saveProgress(Request $request)
    {
        return response()->json([
            'message' => 'Progress berhasil disimpan'
        ]);
    }

    // Web: HALAMAN FORM UPLOAD
    public function create()
    {
        return view('upload-speaking');
    }

    // Web: UPLOAD DARI WEB
    public function storeWeb(Request $request)
    {
        $request->validate([
            'title' => 'required',
            'video' => 'required|mimes:mp4,mov,avi',
            'pdf' => 'nullable|mimes:pdf'
        ]);

        $video = $request->file('video')->store('videos', 'public');

        $pdf = null;
        if ($request->hasFile('pdf')) {
            $pdf = $request->file('pdf')->store('pdfs', 'public');
        }

        SpeakingMaterial::create([
            'title' => $request->title,
            'description' => $request->description,
            'video' => $video,
            'pdf' => $pdf,
        ]);

        return back()->with('success', 'Materi berhasil upload');
    }

    // Web: LIST MATERIAL WEB
    public function materials()
    {
        $materials = SpeakingMaterial::latest()->get();

        return view('materials', compact('materials'));
    }
}

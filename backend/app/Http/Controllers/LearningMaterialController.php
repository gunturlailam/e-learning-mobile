<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\LearningMaterial;

class LearningMaterialController extends Controller
{
    // =================================
    // API LIST SEMUA MATERI
    // =================================
    public function index()
    {
        $materials = LearningMaterial::all();
        foreach ($materials as $item) {
            $item->video_url = asset('storage/' . $item->video);
            $item->pdf_url = $item->pdf ? asset('storage/' . $item->pdf) : null;
        }
        return response()->json($materials);
    }

    // =================================
    // API FILTER BERDASARKAN KATEGORI
    // =================================
    public function byCategory($kategori)
    {
        $materials = LearningMaterial::where('kategori', $kategori)->get();
        foreach ($materials as $item) {
            $item->video_url = asset('storage/' . $item->video);
            $item->pdf_url = $item->pdf ? asset('storage/' . $item->pdf) : null;
        }
        return response()->json($materials);
    }

    // =================================
    // API UPLOAD MATERI
    // =================================
    public function store(Request $request)
    {
        $request->validate([
            'title' => 'required',
            'kategori' => 'required',
            'video' => 'required|mimes:mp4,mov,avi',
            'pdf' => 'nullable|mimes:pdf'
        ]);

        $video = $request->file('video')->store('videos', 'public');
        $pdf = null;
        if ($request->hasFile('pdf')) {
            $pdf = $request->file('pdf')->store('pdfs', 'public');
        }

        $material = LearningMaterial::create([
            'title' => $request->title,
            'description' => $request->description,
            'kategori' => $request->kategori,
            'video' => $video,
            'pdf' => $pdf,
        ]);

        return response()->json([
            'message' => 'Materi berhasil upload',
            'data' => $material
        ]);
    }

    // =================================
    // API SAVE PROGRESS
    // =================================
    public function saveProgress(Request $request)
    {
        return response()->json([
            'message' => 'Progress berhasil disimpan'
        ]);
    }

    // =================================
    // HALAMAN FORM UPLOAD
    // =================================
    public function create()
    {
        return view('upload-speaking');
    }

    // =================================
    // UPLOAD DARI WEB
    // =================================
    public function storeWeb(Request $request)
    {
        $request->validate([
            'title' => 'required',
            'kategori' => 'required',
            'video' => 'required|mimes:mp4,mov,avi',
            'pdf' => 'nullable|mimes:pdf'
        ]);

        $video = $request->file('video')->store('videos', 'public');
        $pdf = null;
        if ($request->hasFile('pdf')) {
            $pdf = $request->file('pdf')->store('pdfs', 'public');
        }

        LearningMaterial::create([
            'title' => $request->title,
            'description' => $request->description,
            'kategori' => $request->kategori,
            'video' => $video,
            'pdf' => $pdf,
        ]);

        return back()->with('success', 'Materi berhasil upload');
    }

    // =================================
    // LIST MATERIAL WEB
    // =================================
    public function materials()
    {
        $materials = LearningMaterial::latest()->get();
        return view('materials', compact('materials'));
    }
}

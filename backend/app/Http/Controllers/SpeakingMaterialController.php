<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\SpeakingMaterial;
use Illuminate\Support\Facades\Storage;

class SpeakingMaterialController extends Controller
{
    // API: Get All Speaking Materials
    public function index()
    {
        try {
            $materials = SpeakingMaterial::all();

            foreach ($materials as $item) {
                $item->video_url = asset('storage/' . $item->video);
                $item->pdf_url = $item->pdf ? asset('storage/' . $item->pdf) : null;
            }

            return response()->json($materials);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil data materi: ' . $e->getMessage()
            ], 500);
        }
    }

    // API: Get Speaking Material by ID
    public function show($id)
    {
        try {
            $material = SpeakingMaterial::findOrFail($id);

            $material->video_url = asset('storage/' . $material->video);
            $material->pdf_url = $material->pdf ? asset('storage/' . $material->pdf) : null;

            return response()->json([
                'success' => true,
                'message' => 'Data materi berhasil diambil',
                'data' => $material
            ]);
        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Materi tidak ditemukan'
            ], 404);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil data materi: ' . $e->getMessage()
            ], 500);
        }
    }

    // API: Create Speaking Material
    public function store(Request $request)
    {
        try {
            $request->validate([
                'title' => 'required|string|max:255',
                'description' => 'nullable|string',
                'video' => 'required|mimes:mp4,mov,avi|max:102400', // max 100MB
                'pdf' => 'nullable|mimes:pdf|max:10240' // max 10MB
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
                'success' => true,
                'message' => 'Materi berhasil ditambahkan!',
                'data' => $material
            ], 201);
        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $e->errors()
            ], 422);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menambahkan materi: ' . $e->getMessage()
            ], 500);
        }
    }

    // API: Update Speaking Material
    public function update(Request $request, $id)
    {
        try {
            $material = SpeakingMaterial::findOrFail($id);

            $request->validate([
                'title' => 'sometimes|required|string|max:255',
                'description' => 'nullable|string',
                'video' => 'nullable|mimes:mp4,mov,avi|max:102400',
                'pdf' => 'nullable|mimes:pdf|max:10240'
            ]);

            if ($request->hasFile('video')) {
                // Delete old video
                if ($material->video && Storage::disk('public')->exists($material->video)) {
                    Storage::disk('public')->delete($material->video);
                }
                $material->video = $request->file('video')->store('videos', 'public');
            }

            if ($request->hasFile('pdf')) {
                // Delete old pdf
                if ($material->pdf && Storage::disk('public')->exists($material->pdf)) {
                    Storage::disk('public')->delete($material->pdf);
                }
                $material->pdf = $request->file('pdf')->store('pdfs', 'public');
            }

            if ($request->has('title')) {
                $material->title = $request->title;
            }

            if ($request->has('description')) {
                $material->description = $request->description;
            }

            $material->save();

            return response()->json([
                'success' => true,
                'message' => 'Materi berhasil diperbarui!',
                'data' => $material
            ]);
        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Materi tidak ditemukan'
            ], 404);
        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $e->errors()
            ], 422);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal memperbarui materi: ' . $e->getMessage()
            ], 500);
        }
    }

    // API: Delete Speaking Material
    public function destroy($id)
    {
        try {
            $material = SpeakingMaterial::findOrFail($id);

            // Delete files from storage
            if ($material->video && Storage::disk('public')->exists($material->video)) {
                Storage::disk('public')->delete($material->video);
            }

            if ($material->pdf && Storage::disk('public')->exists($material->pdf)) {
                Storage::disk('public')->delete($material->pdf);
            }

            $material->delete();

            return response()->json([
                'success' => true,
                'message' => 'Materi berhasil dihapus'
            ]);
        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Materi tidak ditemukan'
            ], 404);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menghapus materi: ' . $e->getMessage()
            ], 500);
        }
    }

    // API: Save Progress
    public function saveProgress(Request $request)
    {
        try {
            $request->validate([
                'material_id' => 'required|exists:speaking_materials,id',
                'progress' => 'required|numeric|min:0|max:100',
                'user_id' => 'required|exists:users,id'
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Progress berhasil disimpan'
            ]);
        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $e->errors()
            ], 422);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menyimpan progress: ' . $e->getMessage()
            ], 500);
        }
    }
}

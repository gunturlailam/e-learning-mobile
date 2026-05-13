<?php

namespace App\Http\Controllers;

use App\Models\Topic;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;

class TopicController extends Controller
{
    /**
     * Tampilkan semua topik
     */
    public function index()
    {
        try {
            $topics = Topic::all();
            return response()->json([
                'success' => true,
                'message' => 'Data topik berhasil diambil',
                'data' => $topics
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil data topik: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Tampilkan detail topik berdasarkan ID
     */
    public function show($id)
    {
        try {
            $topic = Topic::find($id);
            if (!$topic) {
                return response()->json([
                    'success' => false,
                    'message' => 'Topik tidak ditemukan'
                ], 404);
            }

            return response()->json([
                'success' => true,
                'message' => 'Data topik berhasil diambil',
                'data' => $topic
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil data topik: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Tambah topik baru
     */
    public function store(Request $request)
    {
        try {
            // Validasi input
            $validated = $request->validate([
                'title' => 'required|string|max:255',
                'description' => 'nullable|string',
                'price' => 'nullable|numeric|min:0',
                'is_free' => 'nullable|boolean',
            ]);

            // Buat topik baru
            $topic = Topic::create([
                'title' => $validated['title'],
                'description' => $validated['description'] ?? null,
                'price' => $validated['price'] ?? 0,
                'is_free' => $validated['is_free'] ?? false,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Topik berhasil ditambahkan!',
                'data' => $topic
            ], 201);
        } catch (ValidationException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $e->errors()
            ], 422);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menambahkan topik: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Update data topik
     */
    public function update(Request $request, $id)
    {
        try {
            $topic = Topic::find($id);
            if (!$topic) {
                return response()->json([
                    'success' => false,
                    'message' => 'Topik tidak ditemukan'
                ], 404);
            }

            // Validasi input
            $validated = $request->validate([
                'title' => 'sometimes|string|max:255',
                'description' => 'nullable|string',
                'price' => 'nullable|numeric|min:0',
                'is_free' => 'nullable|boolean',
            ]);

            // Update data topik
            if (isset($validated['title'])) {
                $topic->title = $validated['title'];
            }
            if (isset($validated['description'])) {
                $topic->description = $validated['description'];
            }
            if (isset($validated['price'])) {
                $topic->price = $validated['price'];
            }
            if (isset($validated['is_free'])) {
                $topic->is_free = $validated['is_free'];
            }

            $topic->save();

            return response()->json([
                'success' => true,
                'message' => 'Topik berhasil diperbarui!',
                'data' => $topic
            ], 200);
        } catch (ValidationException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $e->errors()
            ], 422);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal memperbarui topik: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Hapus topik
     */
    public function destroy($id)
    {
        try {
            $topic = Topic::find($id);
            if (!$topic) {
                return response()->json([
                    'success' => false,
                    'message' => 'Topik tidak ditemukan'
                ], 404);
            }

            $topic->delete();

            return response()->json([
                'success' => true,
                'message' => 'Topik berhasil dihapus'
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menghapus topik: ' . $e->getMessage()
            ], 500);
        }
    }
}

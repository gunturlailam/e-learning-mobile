<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Package;
use App\Models\LearningMaterial;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\View\View;

class AdminWebPackageController extends Controller
{
    /**
     * Tampilkan daftar semua paket kursus.
     */
    public function index(): View
    {
        $packages = Package::withCount('materials')->orderBy('sort_order')->get();
        return view('admin.packages.index', compact('packages'));
    }

    /**
     * Tampilkan form tambah paket baru.
     */
    public function create(): View
    {
        return view('admin.packages.create');
    }

    /**
     * Simpan paket baru ke database.
     */
    public function store(Request $request): RedirectResponse
    {
        $request->validate([
            'name'         => 'required|string|max:255',
            'display_name' => 'required|string|max:255',
            'description'  => 'nullable|string',
            'price'        => 'required|numeric|min:0',
            'is_free'      => 'nullable',
            'kategori'     => 'nullable|string|max:100',
            'thumbnail'    => 'nullable|image|mimes:jpg,jpeg,png|max:2048',
        ]);

        $data = $request->only(['name', 'display_name', 'description', 'price', 'kategori']);
        $data['is_free']    = $request->boolean('is_free');
        $data['sort_order'] = Package::max('sort_order') + 1;

        if ($request->hasFile('thumbnail')) {
            $data['thumbnail'] = $request->file('thumbnail')->store('thumbnails', 'public');
        }

        Package::create($data);

        return redirect()->route('admin.packages.index')->with('success', 'Paket berhasil ditambahkan.');
    }

    /**
     * Tampilkan form edit paket.
     */
    public function edit(int $id): View
    {
        $package = Package::findOrFail($id);
        return view('admin.packages.edit', compact('package'));
    }

    /**
     * Update data paket.
     */
    public function update(Request $request, int $id): RedirectResponse
    {
        $package = Package::findOrFail($id);

        $request->validate([
            'name'         => 'required|string|max:255',
            'display_name' => 'required|string|max:255',
            'description'  => 'nullable|string',
            'price'        => 'required|numeric|min:0',
            'is_free'      => 'nullable',
            'kategori'     => 'nullable|string|max:100',
            'thumbnail'    => 'nullable|image|mimes:jpg,jpeg,png|max:2048',
        ]);

        $data = $request->only(['name', 'display_name', 'description', 'price', 'kategori']);
        $data['is_free'] = $request->boolean('is_free');

        if ($request->hasFile('thumbnail')) {
            // Hapus thumbnail lama jika ada
            if ($package->thumbnail) {
                Storage::disk('public')->delete($package->thumbnail);
            }
            $data['thumbnail'] = $request->file('thumbnail')->store('thumbnails', 'public');
        }

        $package->update($data);

        return redirect()->route('admin.packages.index')->with('success', 'Paket berhasil diperbarui.');
    }

    /**
     * Hapus paket.
     */
    public function destroy(int $id): RedirectResponse
    {
        $package = Package::findOrFail($id);

        if ($package->thumbnail) {
            Storage::disk('public')->delete($package->thumbnail);
        }

        $package->delete();

        return redirect()->route('admin.packages.index')->with('success', 'Paket berhasil dihapus.');
    }
}

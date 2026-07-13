@extends('admin.layout')

@section('title', 'Edit Paket')
@section('content')

<div class="mb-6">
    <a href="{{ route('admin.packages.index') }}" class="text-green-600 hover:text-green-800 text-sm">
        &larr; Kembali ke daftar
    </a>
</div>

<div class="bg-white rounded-lg shadow p-6 max-w-2xl">
    <h2 class="text-lg font-semibold text-gray-800 mb-6">Edit Paket: {{ $package->display_name }}</h2>

    <form method="POST" action="{{ route('admin.packages.update', $package->id) }}" enctype="multipart/form-data">
        @csrf
        @method('PUT')

        {{-- Nama (slug) --}}
        <div class="mb-4">
            <label for="name" class="block text-sm font-medium text-gray-700 mb-1">
                Nama (slug) <span class="text-red-500">*</span>
            </label>
            <input type="text" name="name" id="name" value="{{ old('name', $package->name) }}"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500 outline-none"
                placeholder="contoh: paket-basic" required>
            @error('name')
                <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
            @enderror
        </div>

        {{-- Nama Tampilan --}}
        <div class="mb-4">
            <label for="display_name" class="block text-sm font-medium text-gray-700 mb-1">
                Nama Tampilan <span class="text-red-500">*</span>
            </label>
            <input type="text" name="display_name" id="display_name" value="{{ old('display_name', $package->display_name) }}"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500 outline-none"
                placeholder="contoh: Paket Basic" required>
            @error('display_name')
                <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
            @enderror
        </div>

        {{-- Deskripsi --}}
        <div class="mb-4">
            <label for="description" class="block text-sm font-medium text-gray-700 mb-1">Deskripsi</label>
            <textarea name="description" id="description" rows="3"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500 outline-none">{{ old('description', $package->description) }}</textarea>
            @error('description')
                <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
            @enderror
        </div>

        {{-- Harga & Kategori --}}
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
            <div>
                <label for="price" class="block text-sm font-medium text-gray-700 mb-1">
                    Harga (Rp) <span class="text-red-500">*</span>
                </label>
                <input type="number" name="price" id="price" value="{{ old('price', $package->price) }}" min="0" step="1000"
                    class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500 outline-none"
                    required>
                @error('price')
                    <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
                @enderror
            </div>
            <div>
                <label for="kategori" class="block text-sm font-medium text-gray-700 mb-1">Kategori</label>
                <input type="text" name="kategori" id="kategori" value="{{ old('kategori', $package->kategori) }}"
                    class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500 outline-none"
                    placeholder="contoh: English">
                @error('kategori')
                    <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
                @enderror
            </div>
        </div>

        {{-- Paket Gratis --}}
        <div class="mb-4">
            <label class="flex items-center gap-2">
                <input type="checkbox" name="is_free" value="1" {{ old('is_free', $package->is_free) ? 'checked' : '' }}
                    class="w-4 h-4 text-green-600 border-gray-300 rounded focus:ring-green-500">
                <span class="text-sm font-medium text-gray-700">Paket Gratis</span>
            </label>
        </div>

        {{-- Thumbnail --}}
        <div class="mb-6">
            <label for="thumbnail" class="block text-sm font-medium text-gray-700 mb-1">
                Thumbnail (jpg, jpeg, png - max 2MB)
            </label>
            @if($package->thumbnail)
                <div class="mb-2">
                    <img src="{{ filter_var($package->thumbnail, FILTER_VALIDATE_URL) ? $package->thumbnail : Storage::url($package->thumbnail) }}" alt="Thumbnail saat ini"
                        class="w-24 h-24 rounded-lg object-cover border border-gray-200">
                    <p class="text-xs text-gray-500 mt-1">Thumbnail saat ini. Upload baru untuk mengganti.</p>
                </div>
            @endif
            <input type="file" name="thumbnail" id="thumbnail" accept=".jpg,.jpeg,.png"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500 outline-none">
            @error('thumbnail')
                <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
            @enderror
        </div>

        <div class="flex gap-3">
            <button type="submit"
                class="bg-green-600 hover:bg-green-700 text-white font-semibold py-2 px-6 rounded-lg transition">
                Simpan Perubahan
            </button>
            <a href="{{ route('admin.packages.index') }}"
                class="bg-gray-200 hover:bg-gray-300 text-gray-700 font-semibold py-2 px-6 rounded-lg transition">
                Batal
            </a>
        </div>
    </form>
</div>
@endsection

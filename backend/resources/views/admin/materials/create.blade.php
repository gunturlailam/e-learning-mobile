@extends('admin.layout')

@section('title', 'Add New Learning Material')
@section('page-title', 'Add New Learning Material')

@section('content')
<div class="max-w-2xl">
    <div class="bg-white rounded-xl shadow-lg overflow-hidden">
        <div class="p-6 border-b border-gray-200">
            <h3 class="text-xl font-semibold text-gray-800">
                <i class="fas fa-video text-green-600"></i> Upload New Learning Material
            </h3>
        </div>

        <form action="{{ route('admin.materials.store') }}" method="POST" enctype="multipart/form-data" class="p-6">
            @csrf

            <div class="mb-6">
                <label for="title" class="block text-sm font-medium text-gray-700 mb-2">
                    Title <span class="text-red-500">*</span>
                </label>
                <input type="text" name="title" id="title" value="{{ old('title') }}" required
                    class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent @error('title') border-red-500 @enderror">
                @error('title')
                <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
                @enderror
            </div>

            <div class="mb-6">
                <label for="kategori" class="block text-sm font-medium text-gray-700 mb-2">
                    Category <span class="text-red-500">*</span>
                </label>
                <select name="kategori" id="kategori" required
                    class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent @error('kategori') border-red-500 @enderror">
                    <option value="">-- Select Category --</option>
                    <option value="Flutter" {{ old('kategori') == 'Flutter' ? 'selected' : '' }}>Flutter</option>
                    <option value="Laravel" {{ old('kategori') == 'Laravel' ? 'selected' : '' }}>Laravel</option>
                    <option value="JavaScript" {{ old('kategori') == 'JavaScript' ? 'selected' : '' }}>JavaScript</option>
                    <option value="Python" {{ old('kategori') == 'Python' ? 'selected' : '' }}>Python</option>
                    <option value="React" {{ old('kategori') == 'React' ? 'selected' : '' }}>React</option>
                    <option value="Vue.js" {{ old('kategori') == 'Vue.js' ? 'selected' : '' }}>Vue.js</option>
                    <option value="Database" {{ old('kategori') == 'Database' ? 'selected' : '' }}>Database</option>
                    <option value="Other" {{ old('kategori') == 'Other' ? 'selected' : '' }}>Other</option>
                </select>
                @error('kategori')
                <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
                @enderror
            </div>

            <div class="mb-6">
                <label for="description" class="block text-sm font-medium text-gray-700 mb-2">
                    Description
                </label>
                <textarea name="description" id="description" rows="4"
                    class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent @error('description') border-red-500 @enderror">{{ old('description') }}</textarea>
                @error('description')
                <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
                @enderror
            </div>

            <div class="mb-6">
                <label for="video" class="block text-sm font-medium text-gray-700 mb-2">
                    Video File <span class="text-red-500">*</span>
                </label>
                <div class="mt-1 flex justify-center px-6 pt-5 pb-6 border-2 border-gray-300 border-dashed rounded-lg hover:border-green-500 transition-colors duration-200">
                    <div class="space-y-1 text-center">
                        <i class="fas fa-video text-4xl text-gray-400"></i>
                        <div class="flex text-sm text-gray-600">
                            <label for="video" class="relative cursor-pointer bg-white rounded-md font-medium text-green-600 hover:text-green-500 focus-within:outline-none">
                                <span>Upload a video</span>
                                <input id="video" name="video" type="file" accept=".mp4,.mov,.avi" required class="sr-only" onchange="displayFileName(this, 'video-name')">
                            </label>
                            <p class="pl-1">or drag and drop</p>
                        </div>
                        <p class="text-xs text-gray-500">MP4, MOV, AVI up to 100MB</p>
                        <p id="video-name" class="text-sm text-green-600 font-medium"></p>
                    </div>
                </div>
                @error('video')
                <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
                @enderror
            </div>

            <div class="mb-6">
                <label for="pdf" class="block text-sm font-medium text-gray-700 mb-2">
                    PDF File (Optional)
                </label>
                <div class="mt-1 flex justify-center px-6 pt-5 pb-6 border-2 border-gray-300 border-dashed rounded-lg hover:border-green-500 transition-colors duration-200">
                    <div class="space-y-1 text-center">
                        <i class="fas fa-file-pdf text-4xl text-gray-400"></i>
                        <div class="flex text-sm text-gray-600">
                            <label for="pdf" class="relative cursor-pointer bg-white rounded-md font-medium text-green-600 hover:text-green-500 focus-within:outline-none">
                                <span>Upload a PDF</span>
                                <input id="pdf" name="pdf" type="file" accept=".pdf" class="sr-only" onchange="displayFileName(this, 'pdf-name')">
                            </label>
                            <p class="pl-1">or drag and drop</p>
                        </div>
                        <p class="text-xs text-gray-500">PDF up to 10MB</p>
                        <p id="pdf-name" class="text-sm text-green-600 font-medium"></p>
                    </div>
                </div>
                @error('pdf')
                <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
                @enderror
            </div>

            <div class="flex items-center justify-between pt-4 border-t border-gray-200">
                <a href="{{ route('admin.materials') }}" class="text-gray-600 hover:text-gray-800">
                    <i class="fas fa-arrow-left mr-2"></i> Back to Materials
                </a>
                <button type="submit" class="bg-green-600 hover:bg-green-700 text-white px-6 py-2 rounded-lg transition-colors duration-200 shadow-md">
                    <i class="fas fa-upload mr-2"></i> Upload Material
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    function displayFileName(input, displayId) {
        const display = document.getElementById(displayId);
        if (input.files && input.files[0]) {
            display.textContent = '✓ ' + input.files[0].name;
        }
    }
</script>
@endsection
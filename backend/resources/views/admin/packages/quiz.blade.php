@extends('admin.layout')

@section('title', 'Quiz - ' . $package->display_name)

@section('content')
<div class="mb-6">
    <a href="{{ route('admin.packages.index') }}" class="text-green-600 hover:text-green-800 text-sm">&larr; Kembali ke daftar paket</a>
</div>

<h2 class="text-2xl font-bold text-gray-800 mb-6">Quiz: {{ $package->display_name }}</h2>

@if(session('success'))
<div class="mb-6 bg-green-100 border-l-4 border-green-500 text-green-700 p-4 rounded-lg">
    {{ session('success') }}
</div>
@endif

{{-- Quiz Settings --}}
<div class="bg-white rounded-lg shadow p-6 mb-6 max-w-2xl">
    <h3 class="text-lg font-semibold text-gray-800 mb-4">Pengaturan Quiz</h3>

    <form method="POST" action="{{ route('admin.packages.quiz.store', $package->id) }}">
        @csrf

        <div class="mb-4">
            <label for="title" class="block text-sm font-medium text-gray-700 mb-1">Judul Quiz <span class="text-red-500">*</span></label>
            <input type="text" name="title" id="title" value="{{ old('title', $quiz->title ?? '') }}"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500 outline-none"
                placeholder="contoh: Quiz Akhir Paket Basic" required>
            @error('title')
                <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
            @enderror
        </div>

        <div class="mb-4">
            <label for="description" class="block text-sm font-medium text-gray-700 mb-1">Deskripsi</label>
            <textarea name="description" id="description" rows="2"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500 outline-none"
                placeholder="Untuk mendapatkan sertifikat">{{ old('description', $quiz->description ?? '') }}</textarea>
            @error('description')
                <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
            @enderror
        </div>

        <div class="mb-4">
            <label for="passing_score" class="block text-sm font-medium text-gray-700 mb-1">Nilai Lulus (%) <span class="text-red-500">*</span></label>
            <input type="number" name="passing_score" id="passing_score" value="{{ old('passing_score', $quiz->passing_score ?? 70) }}"
                min="1" max="100"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500 outline-none"
                required>
            @error('passing_score')
                <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
            @enderror
        </div>

        <button type="submit"
            class="bg-green-600 hover:bg-green-700 text-white font-semibold py-2 px-6 rounded-lg transition">
            {{ $quiz ? 'Perbarui Quiz' : 'Buat Quiz' }}
        </button>
    </form>

    @if($quiz)
        <form method="POST" action="{{ route('admin.packages.quiz.destroy', $package->id) }}" class="mt-4 pt-4 border-t">
            @csrf
            @method('DELETE')
            <button type="submit" class="text-red-600 hover:text-red-800 text-sm font-medium"
                onclick="return confirm('Yakin ingin menghapus quiz beserta semua soalnya?')">
                🗑 Hapus Quiz Ini
            </button>
        </form>
    @endif
</div>

@if($quiz)
    {{-- Question List --}}
    @if($quiz->questions->count() > 0)
        <div class="space-y-4 mb-6 max-w-2xl">
            <h3 class="text-lg font-semibold text-gray-800">Daftar Soal ({{ $quiz->questions->count() }} soal)</h3>
            @foreach($quiz->questions->sortBy('sort_order') as $index => $question)
                <div class="border border-gray-200 rounded-lg p-4 bg-white">
                    <div class="flex items-start justify-between">
                        <div class="flex-1">
                            <p class="font-medium text-gray-800 mb-2">{{ $index + 1 }}. {{ $question->question }}</p>
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-1 text-sm">
                                <p class="{{ $question->correct_answer === 'a' ? 'text-green-700 font-semibold' : 'text-gray-600' }}">
                                    A. {{ $question->option_a }} {{ $question->correct_answer === 'a' ? '✓' : '' }}
                                </p>
                                <p class="{{ $question->correct_answer === 'b' ? 'text-green-700 font-semibold' : 'text-gray-600' }}">
                                    B. {{ $question->option_b }} {{ $question->correct_answer === 'b' ? '✓' : '' }}
                                </p>
                                <p class="{{ $question->correct_answer === 'c' ? 'text-green-700 font-semibold' : 'text-gray-600' }}">
                                    C. {{ $question->option_c }} {{ $question->correct_answer === 'c' ? '✓' : '' }}
                                </p>
                                <p class="{{ $question->correct_answer === 'd' ? 'text-green-700 font-semibold' : 'text-gray-600' }}">
                                    D. {{ $question->option_d }} {{ $question->correct_answer === 'd' ? '✓' : '' }}
                                </p>
                            </div>
                        </div>
                        <form method="POST" action="{{ route('admin.quiz.questions.destroy', $question->id) }}" class="ml-4">
                            @csrf
                            @method('DELETE')
                            <button type="submit" class="text-red-600 hover:text-red-800 text-sm font-medium"
                                onclick="return confirm('Yakin ingin menghapus soal ini?')">
                                Hapus
                            </button>
                        </form>
                    </div>
                </div>
            @endforeach
        </div>
    @else
        <p class="text-gray-500 text-sm mb-6">Belum ada soal. Tambahkan soal di bawah.</p>
    @endif

    {{-- Add Question Form --}}
    <div class="bg-white rounded-lg shadow p-6 max-w-2xl">
        <h3 class="text-lg font-semibold text-gray-800 mb-4">Tambah Soal Baru</h3>

        <form method="POST" action="{{ route('admin.quiz.questions.store', $quiz->id) }}">
            @csrf

            <div class="mb-4">
                <label for="question" class="block text-sm font-medium text-gray-700 mb-1">Pertanyaan <span class="text-red-500">*</span></label>
                <textarea name="question" id="question" rows="2"
                    class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500 outline-none"
                    placeholder="Tulis pertanyaan..." required>{{ old('question') }}</textarea>
                @error('question')
                    <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
                @enderror
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                <div>
                    <label for="option_a" class="block text-sm font-medium text-gray-700 mb-1">Opsi A <span class="text-red-500">*</span></label>
                    <input type="text" name="option_a" id="option_a" value="{{ old('option_a') }}"
                        class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500 outline-none"
                        required>
                    @error('option_a')
                        <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
                    @enderror
                </div>

                <div>
                    <label for="option_b" class="block text-sm font-medium text-gray-700 mb-1">Opsi B <span class="text-red-500">*</span></label>
                    <input type="text" name="option_b" id="option_b" value="{{ old('option_b') }}"
                        class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500 outline-none"
                        required>
                    @error('option_b')
                        <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
                    @enderror
                </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                <div>
                    <label for="option_c" class="block text-sm font-medium text-gray-700 mb-1">Opsi C <span class="text-red-500">*</span></label>
                    <input type="text" name="option_c" id="option_c" value="{{ old('option_c') }}"
                        class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500 outline-none"
                        required>
                    @error('option_c')
                        <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
                    @enderror
                </div>

                <div>
                    <label for="option_d" class="block text-sm font-medium text-gray-700 mb-1">Opsi D <span class="text-red-500">*</span></label>
                    <input type="text" name="option_d" id="option_d" value="{{ old('option_d') }}"
                        class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500 outline-none"
                        required>
                    @error('option_d')
                        <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
                    @enderror
                </div>
            </div>

            <div class="mb-6">
                <label for="correct_answer" class="block text-sm font-medium text-gray-700 mb-1">Jawaban Benar <span class="text-red-500">*</span></label>
                <select name="correct_answer" id="correct_answer"
                    class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500 outline-none"
                    required>
                    <option value="">Pilih jawaban benar</option>
                    <option value="a" {{ old('correct_answer') === 'a' ? 'selected' : '' }}>A</option>
                    <option value="b" {{ old('correct_answer') === 'b' ? 'selected' : '' }}>B</option>
                    <option value="c" {{ old('correct_answer') === 'c' ? 'selected' : '' }}>C</option>
                    <option value="d" {{ old('correct_answer') === 'd' ? 'selected' : '' }}>D</option>
                </select>
                @error('correct_answer')
                    <p class="mt-1 text-sm text-red-600">{{ $message }}</p>
                @enderror
            </div>

            <button type="submit"
                class="bg-green-600 hover:bg-green-700 text-white font-semibold py-2 px-6 rounded-lg transition">
                Tambah Soal
            </button>
        </form>
    </div>
@else
    <div class="bg-yellow-50 border border-yellow-200 rounded-lg p-4 text-sm text-yellow-800">
        Buat quiz terlebih dahulu untuk menambahkan soal.
    </div>
@endif
@endsection

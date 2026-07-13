<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Package;
use App\Models\Quiz;
use App\Models\QuizQuestion;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;

class AdminWebQuizController extends Controller
{
    public function show(int $packageId): View
    {
        $package = Package::findOrFail($packageId);
        $quiz = Quiz::with('questions')->where('package_id', $packageId)->first();
        return view('admin.packages.quiz', compact('package', 'quiz'));
    }

    public function storeQuiz(Request $request, int $packageId): RedirectResponse
    {
        $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'nullable|string',
            'passing_score' => 'required|integer|min:1|max:100',
        ]);

        Quiz::updateOrCreate(
            ['package_id' => $packageId],
            $request->only(['title', 'description', 'passing_score'])
        );

        return redirect()->route('admin.packages.quiz', $packageId)->with('success', 'Quiz berhasil disimpan.');
    }

    public function addQuestion(Request $request, int $quizId): RedirectResponse
    {
        $request->validate([
            'question' => 'required|string',
            'option_a' => 'required|string',
            'option_b' => 'required|string',
            'option_c' => 'required|string',
            'option_d' => 'required|string',
            'correct_answer' => 'required|in:a,b,c,d',
        ]);

        $quiz = Quiz::findOrFail($quizId);
        $sortOrder = QuizQuestion::where('quiz_id', $quizId)->max('sort_order') + 1;

        QuizQuestion::create([
            'quiz_id' => $quizId,
            'question' => $request->question,
            'option_a' => $request->option_a,
            'option_b' => $request->option_b,
            'option_c' => $request->option_c,
            'option_d' => $request->option_d,
            'correct_answer' => $request->correct_answer,
            'sort_order' => $sortOrder,
        ]);

        return redirect()->route('admin.packages.quiz', $quiz->package_id)->with('success', 'Soal berhasil ditambahkan.');
    }

    public function deleteQuestion(int $id): RedirectResponse
    {
        $question = QuizQuestion::findOrFail($id);
        $packageId = $question->quiz->package_id;
        $question->delete();

        return redirect()->route('admin.packages.quiz', $packageId)->with('success', 'Soal berhasil dihapus.');
    }

    public function destroyQuiz(int $packageId): RedirectResponse
    {
        $quiz = Quiz::where('package_id', $packageId)->first();
        if ($quiz) {
            $quiz->delete();
        }

        return redirect()->route('admin.packages.quiz', $packageId)->with('success', 'Quiz berhasil dihapus.');
    }
}

<?php

namespace App\Http\Controllers;

use App\Models\Quiz;
use App\Models\QuizAttempt;
use App\Models\Certificate;
use Illuminate\Support\Str;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class QuizController extends Controller
{
    public function show(int $packageId): JsonResponse
    {
        $quiz = Quiz::with('questions')->where('package_id', $packageId)->firstOrFail();
        return response()->json([
            'success' => true,
            'data' => [
                'id' => $quiz->id,
                'title' => $quiz->title,
                'description' => $quiz->description,
                'passing_score' => $quiz->passing_score,
                'questions' => $quiz->questions->map(function ($q) {
                    return [
                        'id' => $q->id,
                        'question' => $q->question,
                        'options' => [
                            'a' => $q->option_a,
                            'b' => $q->option_b,
                            'c' => $q->option_c,
                            'd' => $q->option_d,
                        ],
                    ];
                }),
            ],
        ]);
    }

    public function submit(Request $request, int $packageId): JsonResponse
    {
        $request->validate(['answers' => 'required|array']);

        $quiz = Quiz::with('questions')->where('package_id', $packageId)->firstOrFail();
        $answers = $request->answers;

        $correct = 0;
        $total = $quiz->questions->count();

        foreach ($quiz->questions as $question) {
            $userAnswer = $answers[strval($question->id)] ?? null;
            if ($userAnswer === $question->correct_answer) {
                $correct++;
            }
        }

        $score = $total > 0 ? round(($correct / $total) * 100) : 0;
        $passed = $score >= $quiz->passing_score;

        $attempt = QuizAttempt::create([
            'user_id' => $request->user()->id,
            'quiz_id' => $quiz->id,
            'score' => $score,
            'passed' => $passed,
            'answers' => $answers,
        ]);

        if ($passed) {
            Certificate::firstOrCreate(
                [
                    'user_id' => $request->user()->id,
                    'package_id' => $quiz->package_id,
                ],
                [
                    'certificate_code' => 'CERT-' . strtoupper(Str::random(4)) . '-' . strtoupper(Str::random(4)) . '-' . strtoupper(Str::random(4)),
                    'issued_at' => now(),
                ]
            );
        }

        return response()->json([
            'success' => true,
            'data' => [
                'attempt_id' => $attempt->id,
                'score' => $score,
                'passed' => $passed,
                'correct' => $correct,
                'total' => $total,
                'passing_score' => $quiz->passing_score,
            ],
            'message' => $passed ? 'Selamat! Anda lulus quiz!' : 'Belum lulus. Coba lagi!',
        ]);
    }

    public function myAttempts(Request $request): JsonResponse
    {
        $attempts = QuizAttempt::with('quiz.package:id,name,display_name')
            ->where('user_id', $request->user()->id)
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json(['success' => true, 'data' => $attempts]);
    }
}

<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AdminController;
use App\Http\Controllers\Admin\AdminWebPackageController;
use App\Http\Controllers\Admin\AuthController;
use App\Http\Controllers\Admin\AdminWebQuizController;

Route::get('/', function () {
    return redirect()->route('admin.login');
});

// Admin Auth Routes (guest)
Route::prefix('admin')->name('admin.')->group(function () {
    Route::get('/login', [AuthController::class, 'showLogin'])->name('login');
    Route::post('/login', [AuthController::class, 'login'])->name('login.submit');
    Route::post('/logout', [AuthController::class, 'logout'])->name('logout');
});

// Admin Routes (protected)
Route::prefix('admin')->name('admin.')->middleware('auth')->group(function () {
    // Dashboard
    Route::get('/', [AdminController::class, 'dashboard'])->name('dashboard');

    // User Management
    Route::get('/users', [AdminController::class, 'users'])->name('users');
    Route::get('/users/create', [AdminController::class, 'createUser'])->name('users.create');
    Route::post('/users', [AdminController::class, 'storeUser'])->name('users.store');
    Route::get('/users/{id}/edit', [AdminController::class, 'editUser'])->name('users.edit');
    Route::put('/users/{id}', [AdminController::class, 'updateUser'])->name('users.update');
    Route::delete('/users/{id}', [AdminController::class, 'deleteUser'])->name('users.delete');

    // Topic Management
    Route::get('/topics', [AdminController::class, 'topics'])->name('topics');
    Route::get('/topics/create', [AdminController::class, 'createTopic'])->name('topics.create');
    Route::post('/topics', [AdminController::class, 'storeTopic'])->name('topics.store');
    Route::get('/topics/{id}/edit', [AdminController::class, 'editTopic'])->name('topics.edit');
    Route::put('/topics/{id}', [AdminController::class, 'updateTopic'])->name('topics.update');
    Route::delete('/topics/{id}', [AdminController::class, 'deleteTopic'])->name('topics.delete');

    // Speaking Material Management
    Route::get('/materials', [AdminController::class, 'materials'])->name('materials');
    Route::get('/materials/create', [AdminController::class, 'createMaterial'])->name('materials.create');
    Route::post('/materials', [AdminController::class, 'storeMaterial'])->name('materials.store');
    Route::get('/materials/{id}/edit', [AdminController::class, 'editMaterial'])->name('materials.edit');
    Route::post('/materials/{id}', [AdminController::class, 'updateMaterial'])->name('materials.update');
    Route::delete('/materials/{id}', [AdminController::class, 'deleteMaterial'])->name('materials.delete');

    // Packages
    Route::get('/packages', [AdminWebPackageController::class, 'index'])->name('packages.index');
    Route::get('/packages/create', [AdminWebPackageController::class, 'create'])->name('packages.create');
    Route::post('/packages', [AdminWebPackageController::class, 'store'])->name('packages.store');
    Route::get('/packages/{id}/edit', [AdminWebPackageController::class, 'edit'])->name('packages.edit');
    Route::put('/packages/{id}', [AdminWebPackageController::class, 'update'])->name('packages.update');
    Route::delete('/packages/{id}', [AdminWebPackageController::class, 'destroy'])->name('packages.destroy');

    // Quiz Management
    Route::get('/packages/{packageId}/quiz', [AdminWebQuizController::class, 'show'])->name('packages.quiz');
    Route::post('/packages/{packageId}/quiz', [AdminWebQuizController::class, 'storeQuiz'])->name('packages.quiz.store');
    Route::delete('/packages/{packageId}/quiz', [AdminWebQuizController::class, 'destroyQuiz'])->name('packages.quiz.destroy');
    Route::post('/quiz/{quizId}/questions', [AdminWebQuizController::class, 'addQuestion'])->name('quiz.questions.store');
    Route::delete('/quiz/questions/{id}', [AdminWebQuizController::class, 'deleteQuestion'])->name('quiz.questions.destroy');

    // Payments Management
    Route::get('/payments', [\App\Http\Controllers\Admin\AdminPaymentController::class, 'index'])->name('payments.index');
    Route::get('/payments/{id}', [\App\Http\Controllers\Admin\AdminPaymentController::class, 'show'])->name('payments.show');
    Route::post('/payments/{id}/approve', [\App\Http\Controllers\Admin\AdminPaymentController::class, 'approve'])->name('payments.approve');
    Route::post('/payments/{id}/reject', [\App\Http\Controllers\Admin\AdminPaymentController::class, 'reject'])->name('payments.reject');
});
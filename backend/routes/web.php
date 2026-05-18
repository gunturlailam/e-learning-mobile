<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AdminController;

Route::get('/', function () {
    return view('welcome');
});

// Admin Routes
Route::prefix('admin')->name('admin.')->group(function () {
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
});

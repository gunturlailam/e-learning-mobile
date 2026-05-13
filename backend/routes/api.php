<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UserController;
use App\Http\Controllers\TopicController;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

// ===== USER ROUTES =====
// Lihat semua user
Route::get('/users', [UserController::class, 'index']);

// Lihat detail user
Route::get('/users/{id}', [UserController::class, 'show']);

// Tambah user
Route::post('/users', [UserController::class, 'store']);

// Update user
Route::put('/users/{id}', [UserController::class, 'update']);
Route::patch('/users/{id}', [UserController::class, 'update']);

// Hapus user
Route::delete('/users/{id}', [UserController::class, 'destroy']);

// ===== TOPIC ROUTES =====
// Lihat semua topik
Route::get('/topics', [TopicController::class, 'index']);

// Lihat detail topik
Route::get('/topics/{id}', [TopicController::class, 'show']);

// Tambah topik
Route::post('/topics', [TopicController::class, 'store']);

// Update topik
Route::put('/topics/{id}', [TopicController::class, 'update']);
Route::patch('/topics/{id}', [TopicController::class, 'update']);

// Hapus topik
Route::delete('/topics/{id}', [TopicController::class, 'destroy']);

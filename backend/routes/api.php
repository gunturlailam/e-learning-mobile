<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UserController;
use App\Http\Controllers\TopicController;
use App\Http\Controllers\LearningMaterialController;
use App\Http\Controllers\PackageController;
use App\Http\Controllers\AuthController;

// ===== AUTH ROUTES =====
Route::post('/login', [AuthController::class, 'login']);
Route::post('/register', [AuthController::class, 'register']);
Route::post('/logout', [AuthController::class, 'logout'])->middleware('auth:sanctum');
Route::get('/me', [AuthController::class, 'me'])->middleware('auth:sanctum');

// ===== USER ROUTES =====
Route::get('/users', [UserController::class, 'index']);
Route::get('/users/{id}', [UserController::class, 'show']);
Route::post('/users', [UserController::class, 'store']);
Route::put('/users/{id}', [UserController::class, 'update']);
Route::patch('/users/{id}', [UserController::class, 'update']);
Route::delete('/users/{id}', [UserController::class, 'destroy']);

// ===== TOPIC ROUTES =====
Route::get('/topics', [TopicController::class, 'index']);
Route::get('/topics/{id}', [TopicController::class, 'show']);
Route::post('/topics', [TopicController::class, 'store']);
Route::put('/topics/{id}', [TopicController::class, 'update']);
Route::patch('/topics/{id}', [TopicController::class, 'update']);
Route::delete('/topics/{id}', [TopicController::class, 'destroy']);

// ===== LEARNING MATERIAL ROUTES =====
Route::get('/learning-materials', [LearningMaterialController::class, 'index']);
Route::get('/learning-materials/category/{kategori}', [LearningMaterialController::class, 'byCategory']);
Route::post('/learning-materials', [LearningMaterialController::class, 'store']);
Route::post('/learning-materials/progress', [LearningMaterialController::class, 'saveProgress']);
Route::get('/learning-materials/web/list', [LearningMaterialController::class, 'materials']);
Route::get('/learning-materials/web/create', [LearningMaterialController::class, 'create']);
Route::post('/learning-materials/web/store', [LearningMaterialController::class, 'storeWeb']);

// ===== PACKAGE ROUTES =====
Route::get('/packages', [PackageController::class, 'index']);
Route::get('/packages/{id}', [PackageController::class, 'show']);

<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\UserController;

// Authentication Routes
Route::post('/register', [AuthController::class, 'register']); // Registration route
Route::post('/login', [AuthController::class, 'login']);       // Login route

// Protected routes
Route::middleware('auth:api')->group(function () {
    Route::get('/user', [UserController::class, 'getUser']);  // Get authenticated user
    Route::put('/user/update', [UserController::class, 'update']); // Update user profile
    Route::put('/user/change-password', [UserController::class, 'changePassword']); // Change user password
    Route::put('/user/updatelocation', [UserController::class, 'updateLocation']); // Update user location
    Route::post('/logout', [AuthController::class, 'logout']);     // Logout route
});
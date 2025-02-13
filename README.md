# 📱 Caretrack System - Flutter & Laravel API Setup Guide

<img src="caretrack_flutter/assets/icons/iconapps.png" alt="Caretrack Logo" width="100" />

[![Flutter](https://img.shields.io/badge/Flutter-3.6-blue?logo=flutter)](https://flutter.dev) [![Laravel](https://img.shields.io/badge/Laravel-10-red?logo=laravel)](https://laravel.com) [![API](https://img.shields.io/badge/API-RESTful-blue)](https://developer.mozilla.org/en-US/docs/Glossary/REST) [![License](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)

**Caretrack** is a **Flutter mobile application** integrated with a **Laravel REST API** for:

✅ **User Authentication**  
✅ **Location Tracking**  
✅ **Profile Management**  

---

## 🛠️ Prerequisites
Before starting, ensure you have the following installed:

- **Laravel** → PHP & Composer installed
- **Flutter** → Flutter SDK installed
- **Database** → MySQL or SQLite

---

## 🚀 Laravel API Setup

### 📌 Step 1: Create a Laravel Project
```sh
cd C:\laragon\www
composer create-project --prefer-dist laravel/laravel caretrack
cd caretrack
```

### 📌 Step 2: Configure Database
1. Create a **database** named `caretrack_db` in MySQL (SQLyog, phpMyAdmin, etc.).
2. Update your `.env` file:
```env
DB_CONNECTION=mysql
DB_DATABASE=caretrack_db
DB_USERNAME=root
DB_PASSWORD=
```

### 📌 Step 3: Install Laravel Sanctum (Authentication)
```sh
composer require laravel/sanctum
php artisan vendor:publish --provider="Laravel\Sanctum\SanctumServiceProvider"
php artisan migrate
```

### 📌 Step 4: Define API Routes (`routes/api.php`)
```php
use App\Http\Controllers\AuthController;
use App\Http\Controllers\UserController;
use Illuminate\Support\Facades\Route;

// 🛡️ Authentication Routes
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::post('/logout', [AuthController::class, 'logout'])->middleware('auth:sanctum');

// 🔒 Authenticated User Routes
Route::middleware('auth:sanctum')->group(function () {
Route::get('/user', [UserController::class, 'getUser']);
Route::put('/user/update', [UserController::class, 'update']);
Route::put('/user/change-password', [UserController::class, 'changePassword']);
Route::post('/user/reset-password', [UserController::class, 'resetPassword']);
});
```

### 📌 Step 5: Create AuthController
Implement user registration, login, and profile management functions inside `AuthController.php`.

### 📌 Step 6: Test API Endpoints
Use **Postman** to verify authentication and user-related API endpoints.

---

## 📱 Flutter App Setup

### 📌 Step 1: Create a Flutter Project
```sh
flutter create caretrack_flutter
cd caretrack_flutter
```

### 📌 Step 2: Add Dependencies (`pubspec.yaml`)
```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^0.13.3
  shared_preferences: ^2.0.6
  google_maps_flutter: ^2.10.0
  geolocator: ^10.1.0
  firebase_auth: ^4.7.2
  firebase_core: ^2.14.0
```
Run:
```sh
flutter pub get
```

### 📌 Step 3: Implement API Service

In `lib/api_service.dart`, implement methods for login, registration, user retrieval, updating, and deletion.

### 📌 Step 4: Build the User Interface
Create the following Flutter screens inside `lib/`:
- **`landing_page.dart`** → Welcome screen
- **`about_page.dart`** → App info
- **`profile_page.dart`** → User profile management
- **`login_page.dart`** → Login screen
- **`nearbyclinic_page.dart`** → Find nearby clinics
- **`register_page.dart`** → User registration

### 📌 Step 5: Run the Application
Start Laravel API server:
```sh
php artisan serve
```
Run the Flutter app:
```sh
flutter run
```

---

## 🎉 Congratulations!
Your **Caretrack System** is now up and running! 🚀 You have successfully set up:
✅ A Laravel API with user authentication and profile management  
✅ A Flutter mobile app integrated with the API  

Happy coding! 💻🚀

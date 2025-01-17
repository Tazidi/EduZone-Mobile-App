<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AllTablesApiController;
use App\Http\Controllers\PerTableApiController;
use App\Http\Controllers\CrudApiController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\NotesController;

// Rute untuk login Admin
Route::post('/admin/login', [AuthController::class, 'adminLogin']);

// Rute untuk login User
Route::post('/user/login', [AuthController::class, 'userLogin']);

// API untuk membaca semua tabel
Route::get('/all-tables', [AllTablesApiController::class, 'getAllTables']);

// API untuk membaca data per tabel
Route::get('/table/{table}', [PerTableApiController::class, 'getTableData']);

// API untuk CRUD per tabel
Route::post('/{table}', [CrudApiController::class, 'create']);
Route::get('/{table}/{id}', [CrudApiController::class, 'read']);
Route::put('/{table}/{id}', [CrudApiController::class, 'update']);
Route::delete('/{table}/{id}', [CrudApiController::class, 'delete']);

// CRUD Notes
Route::get('/notes', [NotesController::class, 'index']); // Get notes by user_id
Route::post('/notes', [NotesController::class, 'store']); // Create a new note
Route::put('/notes/{id}', [NotesController::class, 'update']); // Update an existing note
Route::delete('/notes/{id}', [NotesController::class, 'destroy']); // Delete a note



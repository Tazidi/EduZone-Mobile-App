<?php

use Illuminate\Support\Facades\Route;

use App\Http\Controllers\AllTablesApiController;
use App\Http\Controllers\PerTableApiController;
use App\Http\Controllers\CrudApiController;

// Menampilkan semua data dari semua tabel
Route::get('/all-tables', [AllTablesApiController::class, 'getAllTables']);

// Menampilkan data per tabel
Route::get('/table/{table}', [PerTableApiController::class, 'getTableData']);

// Menampilkan halaman CRUD per tabel
// Route::get('/crud/{table}', [CrudApiController::class, 'index']);
// Route::post('/crud/{table}', [CrudApiController::class, 'create']);
// Route::get('/crud/{table}/{id}', [CrudApiController::class, 'show']);
// Route::put('/crud/{table}/{id}', [CrudApiController::class, 'update']);
// Route::delete('/crud/{table}/{id}', [CrudApiController::class, 'destroy']);

Route::get('/', function () {
    return view('welcome');
});

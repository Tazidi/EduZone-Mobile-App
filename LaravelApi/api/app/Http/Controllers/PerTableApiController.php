<?php

namespace App\Http\Controllers;

use App\Models\Admin;
use App\Models\Kalender;
use App\Models\Note;
use App\Models\SekolahTujuan;
use App\Models\SoalBOS;
use App\Models\User;

class PerTableApiController extends Controller
{
    /**
     * Membaca semua data dari satu tabel tertentu.
     */
    public function getTableData($table)
    {
        switch ($table) {
            case 'admins':
                return response()->json(Admin::all());
            case 'kalenders':
                return response()->json(Kalender::all());
            case 'notes':
                return response()->json(Note::all());
            case 'sekolah_tujuans':
                return response()->json(SekolahTujuan::all());
            case 'soal_bos':
                return response()->json(SoalBOS::all());
            case 'users':
                return response()->json(User::all());
            default:
                return response()->json(['error' => 'Table not found'], 404);
        }
    }
}

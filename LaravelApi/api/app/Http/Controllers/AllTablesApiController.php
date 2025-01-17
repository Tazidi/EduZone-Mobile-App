<?php

namespace App\Http\Controllers;

use App\Models\Admin;
use App\Models\Kalender;
use App\Models\Note;
use App\Models\SekolahTujuan;
use App\Models\SoalBOS;
use App\Models\User;

class AllTablesApiController extends Controller
{
    /**
     * Membaca semua data dari semua tabel.
     */
    public function getAllTables()
    {
        return response()->json([
            'admins' => Admin::all(),
            'kalenders' => Kalender::all(),
            'notes' => Note::all(),
            'sekolah_tujuans' => SekolahTujuan::all(),
            'soal_bos' => SoalBOS::all(),
            'users' => User::all(),
        ]);
    }
}

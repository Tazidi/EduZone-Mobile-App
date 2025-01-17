<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Admin;
use App\Models\Kalender;
use App\Models\Note;
use App\Models\SekolahTujuan;
use App\Models\SoalBOS;
use App\Models\User;

class CrudApiController extends Controller
{
    /**
     * Create data
     */
    public function create(Request $request, $table)
    {
        $data = $request->all();
        switch ($table) {
            case 'admins':
                return response()->json(Admin::create($data));
            case 'kalenders':
                return response()->json(Kalender::create($data));
            case 'notes':
                return response()->json(Note::create($data));
            case 'sekolah_tujuans':
                return response()->json(SekolahTujuan::create($data));
            case 'soal_bos':
                return response()->json(SoalBOS::create($data));
            case 'users':
                return response()->json(User::create($data));
            default:
                return response()->json(['error' => 'Table not found'], 404);
        }
    }

    /**
     * Read data
     */
    public function read($table, $id)
    {
        switch ($table) {
            case 'admins':
                return response()->json(Admin::find($id));
            case 'kalenders':
                return response()->json(Kalender::find($id));
            case 'notes':
                return response()->json(Note::find($id));
            case 'sekolah_tujuans':
                return response()->json(SekolahTujuan::find($id));
            case 'soal_bos':
                return response()->json(SoalBOS::find($id));
            case 'users':
                // Menggunakan nis sebagai primary key
                return response()->json(User::where('nis', $id)->first());
            default:
                return response()->json(['error' => 'Table not found'], 404);
        }
    }

    /**
     * Update data
     */
    public function update(Request $request, $table, $id)
    {
        $data = $request->all();
        $model = $this->getModel($table, $id);

        if ($model) {
            $model->update($data);
            return response()->json($model);
        }

        return response()->json(['error' => 'Data not found'], 404);
    }

    /**
     * Delete data
     */
    public function delete($table, $id)
    {
        $model = $this->getModel($table, $id);

        if ($model) {
            $model->delete();
            return response()->json(['success' => 'Data deleted successfully']);
        }

        return response()->json(['error' => 'Data not found'], 404);
    }

    private function getModel($table, $id)
    {
        switch ($table) {
            case 'admins':
                return Admin::find($id);
            case 'kalenders':
                return Kalender::find($id);
            case 'notes':
                return Note::find($id);
            case 'sekolah_tujuans':
                return SekolahTujuan::find($id);
            case 'soal_bos':
                return SoalBOS::find($id);
            case 'users':
                // Menggunakan nis sebagai primary key
                return User::where('nis', $id)->first();
            default:
                return null;
        }
    }
}

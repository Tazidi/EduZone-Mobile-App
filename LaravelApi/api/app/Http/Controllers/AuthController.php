<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    // Fungsi login untuk Admin
    public function adminLogin(Request $request)
    {
        // Validasi input
        $request->validate([
            'username' => 'required|string',
            'password' => 'required|string',
        ]);

        $username = $request->input('username');
        $password = $request->input('password');

        // Cari admin berdasarkan username
        $admin = DB::table('admins')->where('username', $username)->first();

        // Validasi username dan password
        if ($admin && Hash::check($password, $admin->password)) {
            // Respon sukses
            return response()->json([
                'success' => true,
                'message' => 'Admin login successful',
                'data' => [
                    'id' => $admin->id,
                    'username' => $admin->username,
                ],
            ]);
        } else {
            // Respon gagal
            return response()->json([
                'success' => false,
                'message' => 'Invalid username or password',
            ], 401);
        }
    }

    // Fungsi login untuk User dengan email
    public function userLogin(Request $request)
    {
        // Validasi input
        $request->validate([
            'identifier' => 'required', // Bisa berupa email atau NIS
            'password' => 'required|string',
        ]);
    
        $identifier = $request->input('identifier'); // Bisa email atau NIS
        $password = $request->input('password');
    
        // Cek apakah input adalah email atau NIS
        $user = filter_var($identifier, FILTER_VALIDATE_EMAIL)
            ? DB::table('users')->where('email', $identifier)->first()
            : DB::table('users')->where('nis', $identifier)->first();
    
        // Validasi email/NIS dan password
        if ($user && $password === $user->password) {
            // Jika login berhasil
            return response()->json([
                'success' => true,
                'message' => 'User login successful',
                'data' => [
                    'id' => $user->id,
                    'nama_lengkap' => $user->nama_lengkap,
                    'email' => $user->email,
                    'nis' => $user->nis,
                    'nomor_telepon' => $user->nomor_telepon,
                    'alamat' => $user->alamat,
                    'kelas' => $user->kelas,
                ],
            ]);
        } else {
            // Jika email/NIS atau password salah
            return response()->json([
                'success' => false,
                'message' => 'Invalid identifier or password',
            ], 401);
        }        
    }    
}
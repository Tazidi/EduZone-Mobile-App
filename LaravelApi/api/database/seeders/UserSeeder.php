<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $users = [
            ['nis' => '152022014', 'nama_lengkap' => 'Kika Amalia'],
            ['nis' => '152022016', 'nama_lengkap' => 'Shidiq Nur Hasan'],
            ['nis' => '152022020', 'nama_lengkap' => 'Fadhil Teguh Amara'],
            ['nis' => '152022021', 'nama_lengkap' => 'Jabir Muhammad Nizar'],
            ['nis' => '152022022', 'nama_lengkap' => 'Fuad Grimaldi'],
            ['nis' => '152022025', 'nama_lengkap' => 'Putri Salsanabilah Muhyidin'],
            ['nis' => '152022026', 'nama_lengkap' => 'Irfan Satria Supriadi'],
            ['nis' => '152022031', 'nama_lengkap' => 'Selma Auliya El Aliya'],
            ['nis' => '152022034', 'nama_lengkap' => 'Fajar Faturohman Nugraha'],
            ['nis' => '152022037', 'nama_lengkap' => 'Syadda Abdullah'],
            ['nis' => '152022041', 'nama_lengkap' => 'Asep Ginanjar'],
            ['nis' => '152022042', 'nama_lengkap' => 'Farel Anugrah Al Fauzan'],
            ['nis' => '152022044', 'nama_lengkap' => 'Dimas Bratakusumah'],
            ['nis' => '152022066', 'nama_lengkap' => 'Andhika Fajar Prayoga'],
            ['nis' => '152022078', 'nama_lengkap' => 'Khayla Giri Fitriani'],
            ['nis' => '152022087', 'nama_lengkap' => 'Abhyasa Gunawan Yusuf'],
            ['nis' => '152022089', 'nama_lengkap' => 'Pasha Nur Aprilia'],
            ['nis' => '152022093', 'nama_lengkap' => 'Alamsyah Putra Mahrozar Pohan'],
            ['nis' => '152022097', 'nama_lengkap' => 'Alonza Nara Shadrika'],
            ['nis' => '152022100', 'nama_lengkap' => 'Abdy Ananda Yunan'],
            ['nis' => '152022105', 'nama_lengkap' => 'Andrew Reynaldo'],
            ['nis' => '152022110', 'nama_lengkap' => 'Wafiq Mariatul Azizah'],
            ['nis' => '152022113', 'nama_lengkap' => 'Raden Dika Natakusumah'],
            ['nis' => '152022210', 'nama_lengkap' => 'Nuraini'],
            ['nis' => '152022228', 'nama_lengkap' => 'Hilmy Raihan'],
            ['nis' => '152022242', 'nama_lengkap' => 'Daffa Fadhlurrahman Haris'],
        ];

        // Pilihan nama jalan
        $jalanOptions = [
            'Jalan Senang', 'Jalan Bahagia', 'Jalan Ancol',
            'Jalan Kenangan', 'Jalan Harmoni', 'Jalan Merdeka',
            'Jalan Pahlawan', 'Jalan Raya', 'Jalan Sukarno',
            'Jalan Hatta', 'Jalan Sudirman', 'Jalan Kartini',
            'Jalan Ahmad Yani'
        ];

        foreach ($users as $user) {
            $email = strtolower(str_replace(' ', '_', $user['nama_lengkap'])) . '@gmail.com';
            $phone = '08' . random_int(1000000000, 9999999999); // Nomor telepon acak
            $alamat = $jalanOptions[array_rand($jalanOptions)] . ' ' . random_int(1, 50); // Nama jalan dan nomor acak

            DB::table('users')->insert([
                'nis' => $user['nis'],
                'nama_lengkap' => $user['nama_lengkap'],
                'email' => $email,
                'password' => '123456',
                'nomor_telepon' => $phone,
                'alamat' => $alamat,
                'kelas' => ['7', '8', '9'][array_rand(['7', '8', '9'])], // Kelas acak
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
    }
}

<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class AdminSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        DB::table('admins')->insert([
            'username' => 'admin',
            'password' => Hash::make('admin123'), // Hash password untuk keamanan
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }
}

<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('users', function (Blueprint $table) {
            $table->id(); // Primary key
            $table->unsignedInteger('nis')->unique(); // NIS tetap sebagai data unik
            $table->string('nama_lengkap');
            $table->string('email')->unique();
            $table->string('password');
            $table->string('nomor_telepon')->nullable();
            $table->text('alamat')->nullable();
            $table->enum('kelas', ['7', '8', '9'])->default('7'); // Tambahkan kolom kelas
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('users');
    }
};

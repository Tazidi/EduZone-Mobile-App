<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class User extends Model
{
    use HasFactory;

    protected $fillable = [
        'nis',
        'nama_lengkap',
        'email',
        'password',
        'nomor_telepon',
        'alamat',
        'kelas',
    ];

    // Relasi ke model Note
    public function notes()
    {
        return $this->hasMany(Note::class);
    }

    // Relasi ke model SekolahTujuan
    public function sekolahTujuans()
    {
        return $this->hasMany(SekolahTujuan::class);
    }
}

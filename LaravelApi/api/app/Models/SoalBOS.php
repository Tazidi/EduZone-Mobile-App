<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class SoalBOS extends Model
{
    use HasFactory;

    protected $table = 'soal_bos';

    protected $fillable = [
        'nama',
        'jenis',
        'url',
    ];
}

<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class SekolahTujuan extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'jarak',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}

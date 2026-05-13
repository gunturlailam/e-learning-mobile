<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class SpeakingMaterial extends Model
{
    protected $fillable = [
        'title',
        'description',
        'video',
        'pdf',
    ];
}

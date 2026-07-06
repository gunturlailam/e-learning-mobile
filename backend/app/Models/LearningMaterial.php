<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class LearningMaterial extends Model
{
    use HasFactory;

    protected $table = 'learning_materials';

    protected $fillable = [
        'title',
        'description',
        'kategori',
        'video',
        'audio',
        'pdf',
        'learning_guide',
        'package_id',
    ];

    protected $casts = [
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    /**
     * Relasi ke Package (banyak materi milik satu package)
     */
    public function package()
    {
        return $this->belongsTo(Package::class);
    }
}

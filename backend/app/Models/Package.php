<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Package extends Model
{
    use HasFactory;

    protected $table = 'packages';

    protected $fillable = [
        'name',
        'display_name',
        'description',
        'price',
        'is_free',
        'thumbnail',
        'kategori',
        'sort_order',
    ];

    protected $casts = [
        'is_free'    => 'boolean',
        'price'      => 'decimal:2',
        'sort_order' => 'integer',
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    /**
     * Relasi ke LearningMaterial (satu package punya banyak materi)
     */
    public function materials()
    {
        return $this->hasMany(LearningMaterial::class, 'package_id');
    }
}

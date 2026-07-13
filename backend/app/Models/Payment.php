<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Payment extends Model
{
    protected $table = 'payments';

    protected $fillable = [
        'user_id',
        'package_id',
        'menu_name',
        'amount',
        'method',
        'proof',
        'status',
        'reject_reason',
        'approved_at',
    ];

    protected $casts = [
        'user_id' => 'integer',
        'package_id' => 'integer',
        'amount' => 'decimal:2',
        'approved_at' => 'datetime',
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    protected $appends = ['proof_url', 'bank_account_info', 'qr_code_url'];

    /**
     * Accessor untuk proof_url
     */
    public function getProofUrlAttribute(): ?string
    {
        return $this->proof ? asset('storage/' . $this->proof) : null;
    }

    /**
     * Accessor untuk bank_account_info
     */
    public function getBankAccountInfoAttribute(): string
    {
        return "Bank BCA\nNo. Rekening: 8123-4567-89\na.n. CV Zafira Edukasi";
    }

    /**
     * Accessor untuk qr_code_url
     */
    public function getQrCodeUrlAttribute(): string
    {
        return "https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=ZafiraElearningPayment";
    }

    /**
     * Relasi ke User
     */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    /**
     * Relasi ke Package
     */
    public function package(): BelongsTo
    {
        return $this->belongsTo(Package::class, 'package_id');
    }
}

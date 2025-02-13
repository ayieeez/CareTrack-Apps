<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Location extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id', // Foreign key to associate with users
        'latitude',
        'longitude',
    ];

    // Define the relationship back to the User model
    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
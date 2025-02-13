<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Passport\HasApiTokens;
// use Illuminate\Support\Facades\Hash; // Add this line

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'name',
        'email',
        'password',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
    ];

    /**
     * The relationship with the location model.
     */
    public function location()
    {
        return $this->hasOne(Location::class);
    }

    // /**
    //  * Hash the password before saving the user.
    //  *
    //  * @param string $value
    //  * @return void
    //  */
    // public function setPasswordAttribute($value)
    // {
    //     $this->attributes['password'] = Hash::make($value); // Use Hash::make for consistency
    // }
}
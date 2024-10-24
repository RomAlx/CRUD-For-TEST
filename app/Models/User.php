<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Support\Facades\Log;

class User extends Authenticatable
{
    use HasFactory;
    protected $fillable = [
        'name',
        'email',
        'password',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected static function boot()
    {
        parent::boot();

        static::created(function ($user) {
            Log::info('User created', [
                'id' => $user->id,
                'email' => $user->email,
                'ip' => request()->ip(),
                'user_agent' => request()->userAgent()
            ]);
        });

        static::updated(function ($user) {
            Log::info('User updated', [
                'id' => $user->id,
                'changes' => $user->getChanges(),
                'ip' => request()->ip(),
                'user_agent' => request()->userAgent()
            ]);
        });

        static::deleted(function ($user) {
            Log::info('User deleted', [
                'id' => $user->id,
                'email' => $user->email,
                'ip' => request()->ip(),
                'user_agent' => request()->userAgent()
            ]);
        });
    }
}

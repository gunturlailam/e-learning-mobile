<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // Default admin account untuk login panel
        User::updateOrCreate(
            ['email' => 'admin@elearning.com'],
            [
                'name'     => 'Administrator',
                'password' => Hash::make('password'),
            ]
        );

        $this->call([
            UserSeeder::class,
            PackageSeeder::class,
            LearningMaterialSeeder::class,
            QuizSeeder::class,
            PaymentSeeder::class,
        ]);
    }
}

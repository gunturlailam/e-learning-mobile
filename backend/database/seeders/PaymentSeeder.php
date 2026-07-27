<?php

namespace Database\Seeders;

use App\Models\Payment;
use App\Models\User;
use App\Models\Package;
use Illuminate\Database\Seeder;
use Carbon\Carbon;

class PaymentSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Get users and packages
        $users = User::where('email', '!=', 'admin@elearning.com')->get();
        $packages = Package::where('is_free', false)->get();

        if ($users->isEmpty() || $packages->isEmpty()) {
            $this->command->warn('No users or paid packages found. Skipping PaymentSeeder.');
            return;
        }

        // Create pending payments (5 latest)
        $pendingPayments = [
            [
                'user_email' => 'budi@example.com',
                'package_name' => 'speak-without-template',
                'amount' => 50000,
                'method' => 'bank_transfer',
                'days_ago' => 0,
            ],
            [
                'user_email' => 'siti@example.com',
                'package_name' => 'survival-english',
                'amount' => 60000,
                'method' => 'bank_transfer',
                'days_ago' => 1,
            ],
            [
                'user_email' => 'ahmad@example.com',
                'package_name' => 'socially-fluent',
                'amount' => 100000,
                'method' => 'qr_code',
                'days_ago' => 2,
            ],
            [
                'user_email' => 'dewi@example.com',
                'package_name' => 'toefl',
                'amount' => 200000,
                'method' => 'bank_transfer',
                'days_ago' => 3,
            ],
            [
                'user_email' => 'rudi@example.com',
                'package_name' => 'business-english',
                'amount' => 150000,
                'method' => 'qr_code',
                'days_ago' => 4,
            ],
        ];

        foreach ($pendingPayments as $paymentData) {
            $user = User::where('email', $paymentData['user_email'])->first();
            $package = Package::where('name', $paymentData['package_name'])->first();

            if ($user && $package) {
                Payment::updateOrCreate(
                    [
                        'user_id' => $user->id,
                        'package_id' => $package->id,
                        'status' => 'pending',
                    ],
                    [
                        'menu_name' => $package->display_name,
                        'amount' => $paymentData['amount'],
                        'method' => $paymentData['method'],
                        'proof' => 'payments/proof_' . $user->id . '_' . $package->id . '.jpg',
                        'status' => 'pending',
                        'created_at' => Carbon::now()->subDays($paymentData['days_ago']),
                        'updated_at' => Carbon::now()->subDays($paymentData['days_ago']),
                    ]
                );
            }
        }

        // Create some approved payments for revenue data
        $approvedPayments = [
            [
                'user_email' => 'maya@example.com',
                'package_name' => 'speak-without-template',
                'amount' => 50000,
                'method' => 'bank_transfer',
                'days_ago' => 30,
            ],
            [
                'user_email' => 'feri@example.com',
                'package_name' => 'survival-english',
                'amount' => 60000,
                'method' => 'bank_transfer',
                'days_ago' => 25,
            ],
            [
                'user_email' => 'lina@example.com',
                'package_name' => 'socially-fluent',
                'amount' => 100000,
                'method' => 'qr_code',
                'days_ago' => 20,
            ],
            [
                'user_email' => 'budi@example.com',
                'package_name' => 'toefl',
                'amount' => 200000,
                'method' => 'bank_transfer',
                'days_ago' => 60,
            ],
            [
                'user_email' => 'siti@example.com',
                'package_name' => 'ielts',
                'amount' => 250000,
                'method' => 'bank_transfer',
                'days_ago' => 45,
            ],
            [
                'user_email' => 'ahmad@example.com',
                'package_name' => 'business-english',
                'amount' => 150000,
                'method' => 'qr_code',
                'days_ago' => 15,
            ],
            [
                'user_email' => 'dewi@example.com',
                'package_name' => 'pronunciation',
                'amount' => 90000,
                'method' => 'bank_transfer',
                'days_ago' => 10,
            ],
        ];

        foreach ($approvedPayments as $paymentData) {
            $user = User::where('email', $paymentData['user_email'])->first();
            $package = Package::where('name', $paymentData['package_name'])->first();

            if ($user && $package) {
                Payment::updateOrCreate(
                    [
                        'user_id' => $user->id,
                        'package_id' => $package->id,
                        'status' => 'approved',
                    ],
                    [
                        'menu_name' => $package->display_name,
                        'amount' => $paymentData['amount'],
                        'method' => $paymentData['method'],
                        'proof' => 'payments/proof_' . $user->id . '_' . $package->id . '.jpg',
                        'status' => 'approved',
                        'approved_at' => Carbon::now()->subDays($paymentData['days_ago']),
                        'created_at' => Carbon::now()->subDays($paymentData['days_ago'] + 1),
                        'updated_at' => Carbon::now()->subDays($paymentData['days_ago']),
                    ]
                );
            }
        }

        $this->command->info('PaymentSeeder completed successfully.');
    }
}

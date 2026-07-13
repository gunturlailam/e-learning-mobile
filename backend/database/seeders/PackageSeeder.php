<?php

namespace Database\Seeders;

use App\Models\Package;
use Illuminate\Database\Seeder;

class PackageSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $packages = [
            [
                'name' => 'speaking',
                'display_name' => 'Speak & Shine',
                'description' => 'Tingkatkan kepercayaan diri Anda dalam berbicara bahasa Inggris dengan modul latihan percakapan sehari-hari.',
                'price' => 0.00,
                'is_free' => true,
                'thumbnail' => 'https://images.unsplash.com/photo-1543269865-cbf427effbad?auto=format&fit=crop&q=80&w=400',
                'kategori' => 'Speaking',
                'sort_order' => 1,
            ],
            [
                'name' => 'speak-without-template',
                'display_name' => 'Speak Without Template',
                'description' => 'Belajar berbicara secara spontan dan alami tanpa menghafal template percakapan yang kaku.',
                'price' => 50000.00,
                'is_free' => false,
                'thumbnail' => 'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?auto=format&fit=crop&q=80&w=400',
                'kategori' => 'Speaking',
                'sort_order' => 2,
            ],
            [
                'name' => 'survival-english',
                'display_name' => 'Real Life English Survival',
                'description' => 'Ungkapan penting dan kosa kata praktis untuk bertahan hidup di lingkungan berbahasa Inggris (wisata, belanja, dll).',
                'price' => 60000.00,
                'is_free' => false,
                'thumbnail' => 'https://images.unsplash.com/photo-1488190211105-8b0e65b80b4e?auto=format&fit=crop&q=80&w=400',
                'kategori' => 'Speaking',
                'sort_order' => 3,
            ],
            [
                'name' => 'socially-fluent',
                'display_name' => 'Socially Fluent',
                'description' => 'Kuasai seni mengobrol ringan (small talk) dan bergaul dengan penutur asli dalam situasi sosial apa pun.',
                'price' => 100000.00,
                'is_free' => false,
                'thumbnail' => 'https://images.unsplash.com/photo-1522071820081-009f0129c71c?auto=format&fit=crop&q=80&w=400',
                'kategori' => 'Speaking',
                'sort_order' => 4,
            ],
            [
                'name' => 'vocabulary',
                'display_name' => 'Vocabulary Builder',
                'description' => 'Perbanyak kosa kata Anda dengan cara yang asyik dan terstruktur untuk berbagai topik kehidupan.',
                'price' => 0.00,
                'is_free' => true,
                'thumbnail' => 'https://images.unsplash.com/photo-1456513080510-7bf3a84b82f8?auto=format&fit=crop&q=80&w=400',
                'kategori' => 'Vocabulary',
                'sort_order' => 5,
            ],
            [
                'name' => 'toefl',
                'display_name' => 'Toefle Preparation Master',
                'description' => 'Persiapan intensif menghadapi ujian TOEFL dengan latihan soal structure, listening, dan reading.',
                'price' => 200000.00,
                'is_free' => false,
                'thumbnail' => 'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?auto=format&fit=crop&q=80&w=400',
                'kategori' => 'Test Prep',
                'sort_order' => 6,
            ],
            [
                'name' => 'ielts',
                'display_name' => 'IELTS Breakthrough',
                'description' => 'Strategi mendapatkan band score tinggi (7.0+) untuk modul Speaking, Writing, Listening, dan Reading.',
                'price' => 250000.00,
                'is_free' => false,
                'thumbnail' => 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&q=80&w=400',
                'kategori' => 'Test Prep',
                'sort_order' => 7,
            ],
            [
                'name' => 'grammar',
                'display_name' => 'Grammar Made Simple',
                'description' => 'Belajar tenses dan tata bahasa Inggris tanpa pusing menggunakan analogi visual yang sederhana.',
                'price' => 0.00,
                'is_free' => true,
                'thumbnail' => 'https://images.unsplash.com/photo-1506784983877-45594efa4cbe?auto=format&fit=crop&q=80&w=400',
                'kategori' => 'Grammar',
                'sort_order' => 8,
            ],
            [
                'name' => 'business-english',
                'display_name' => 'Business English Professional',
                'description' => 'Kuasai bahasa Inggris formal untuk presentasi, menulis email kerja, negosiasi, dan meeting.',
                'price' => 150000.00,
                'is_free' => false,
                'thumbnail' => 'https://images.unsplash.com/photo-1427504494785-3a9ca7044f45?auto=format&fit=crop&q=80&w=400',
                'kategori' => 'Professional',
                'sort_order' => 9,
            ],
            [
                'name' => 'pronunciation',
                'display_name' => 'Perfect Pronunciation',
                'description' => 'Latihan mereduksi logat lokal dan meniru pengucapan aksen British/American secara presisi.',
                'price' => 90000.00,
                'is_free' => false,
                'thumbnail' => 'https://images.unsplash.com/photo-1484704849700-f032a568e944?auto=format&fit=crop&q=80&w=400',
                'kategori' => 'Speaking',
                'sort_order' => 10,
            ],
        ];

        foreach ($packages as $pkg) {
            Package::updateOrCreate(['name' => $pkg['name']], $pkg);
        }
    }
}

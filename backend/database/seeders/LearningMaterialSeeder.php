<?php

namespace Database\Seeders;

use App\Models\Package;
use App\Models\LearningMaterial;
use Illuminate\Database\Seeder;

class LearningMaterialSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $materials = [
            'speaking' => [
                [
                    'title' => 'Introduction to Public Speaking',
                    'description' => 'Dalam materi pertama ini, Anda akan mempelajari dasar-dasar public speaking, bagaimana menstruktur presentasi Anda, dan cara mengatasi ketakutan awal saat berbicara di depan umum.',
                    'kategori' => 'Speaking',
                    'video' => 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
                    'pdf' => 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
                ],
                [
                    'title' => 'Mastering Body Language',
                    'description' => 'Bahasa tubuh menyumbang lebih dari 50% dari efektivitas komunikasi Anda. Pelajari cara menggunakan gerakan tangan, postur, dan kontak mata untuk meyakinkan audiens Anda.',
                    'kategori' => 'Speaking',
                    'video' => 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
                    'pdf' => null,
                ],
            ],
            'speak-without-template' => [
                [
                    'title' => 'Thinking in English',
                    'description' => 'Kunci utama berbicara tanpa template adalah berhenti menerjemahkan dari bahasa Indonesia ke bahasa Inggris di kepala Anda. Pelajari teknik latihan berpikir langsung dalam bahasa Inggris.',
                    'kategori' => 'Speaking',
                    'video' => 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
                    'pdf' => 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
                ],
                [
                    'title' => 'Spontaneous Response Drills',
                    'description' => 'Latihan praktis untuk menanggapi berbagai pertanyaan acak dengan cepat menggunakan teknik asosiasi kata dan struktur respon sederhana.',
                    'kategori' => 'Speaking',
                    'video' => 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
                    'pdf' => null,
                ],
            ],
            'survival-english' => [
                [
                    'title' => 'English for Travel & Directions',
                    'description' => 'Kumpulan frasa penting untuk menanyakan arah, membeli tiket transportasi umum, dan memesan taksi saat Anda berada di luar negeri.',
                    'kategori' => 'Speaking',
                    'video' => 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4',
                    'pdf' => 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
                ],
                [
                    'title' => 'Dining Out & Ordering Food',
                    'description' => 'Pelajari cara memesan makanan di restoran, melakukan reservasi, meminta rekomendasi menu, dan cara melakukan pembayaran.',
                    'kategori' => 'Speaking',
                    'video' => 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4',
                    'pdf' => null,
                ],
            ],
            'socially-fluent' => [
                [
                    'title' => 'The Art of Small Talk',
                    'description' => 'Mengobrol santai adalah pintu gerbang membangun hubungan sosial. Pelajari topik-topik aman, cara memulai percakapan, dan cara mengakhirinya dengan sopan.',
                    'kategori' => 'Speaking',
                    'video' => 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4',
                    'pdf' => 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
                ],
                [
                    'title' => 'Building Deeper Connections',
                    'description' => 'Bagaimana melangkah dari obrolan ringan ke percakapan yang lebih bermakna menggunakan active listening dan mengajukan open-ended questions.',
                    'kategori' => 'Speaking',
                    'video' => 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4',
                    'pdf' => null,
                ],
            ],
            'vocabulary' => [
                [
                    'title' => 'Daily Life Vocabulary',
                    'description' => 'Perkaya kosa kata harian Anda untuk aktivitas di rumah, di dapur, di kantor, dan di tempat rekreasi secara interaktif.',
                    'kategori' => 'Vocabulary',
                    'video' => 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
                    'pdf' => 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
                ],
                [
                    'title' => 'Idioms and Slang Expressions',
                    'description' => 'Pelajari idiom populer dan bahasa gaul (slang) yang sering digunakan oleh penutur asli dalam percakapan sehari-hari.',
                    'kategori' => 'Vocabulary',
                    'video' => 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
                    'pdf' => null,
                ],
            ],
            'toefl' => [
                [
                    'title' => 'TOEFL Listening Strategies',
                    'description' => 'Strategi menjawab soal-soal Listening Section pada TOEFL ITP, memahami maksud pembicara, dan mendeteksi jawaban jebakan.',
                    'kategori' => 'Test Prep',
                    'video' => 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
                    'pdf' => 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
                ],
                [
                    'title' => 'Structure & Written Expression Keys',
                    'description' => 'Pelajari pola tata bahasa yang paling sering diujikan dalam TOEFL Structure beserta tips eliminasi jawaban salah dengan cepat.',
                    'kategori' => 'Test Prep',
                    'video' => 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
                    'pdf' => null,
                ],
            ],
            'ielts' => [
                [
                    'title' => 'IELTS Speaking Band 7+ Guide',
                    'description' => 'Kriteria penilaian IELTS Speaking dan cara menyusun jawaban terstruktur untuk Part 1, Part 2 (Cue Card), dan Part 3.',
                    'kategori' => 'Test Prep',
                    'video' => 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
                    'pdf' => 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
                ],
                [
                    'title' => 'IELTS Academic Writing Task 1 & 2',
                    'description' => 'Cara menganalisis grafik/tabel di Task 1 serta menyusun esai argumentatif yang kohesif dan kaya kosa kata akademis di Task 2.',
                    'kategori' => 'Test Prep',
                    'video' => 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
                    'pdf' => null,
                ],
            ],
            'grammar' => [
                [
                    'title' => 'Present & Past Tenses Visualized',
                    'description' => 'Pahami perbedaan esensial antara Simple Present, Present Continuous, Simple Past, dan Past Continuous melalui garis waktu visual.',
                    'kategori' => 'Grammar',
                    'video' => 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4',
                    'pdf' => 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
                ],
                [
                    'title' => 'Active vs Passive Voice Masterclass',
                    'description' => 'Pelajari kapan harus menggunakan kalimat aktif atau pasif, cara mengubah kalimat, dan menghindari kesalahan umum struktur pasif.',
                    'kategori' => 'Grammar',
                    'video' => 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4',
                    'pdf' => null,
                ],
            ],
            'business-english' => [
                [
                    'title' => 'Professional Email Writing',
                    'description' => 'Pelajari etika berkirim email bisnis, frasa pembuka dan penutup yang sopan, serta cara menyampaikan keluhan atau permohonan secara profesional.',
                    'kategori' => 'Professional',
                    'video' => 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4',
                    'pdf' => 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
                ],
                [
                    'title' => 'Leading & Participating in Business Meetings',
                    'description' => 'Ungkapan penting untuk menyela pembicaraan secara sopan, memberikan presentasi data, bernegosiasi, dan menyimpulkan hasil rapat.',
                    'kategori' => 'Professional',
                    'video' => 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4',
                    'pdf' => null,
                ],
            ],
            'pronunciation' => [
                [
                    'title' => 'Phonetic Symbols & Vowel Sounds',
                    'description' => 'Pelajari simbol fonetis bahasa Inggris (IPA) dan cara melafalkan bunyi huruf vokal yang sering membingungkan secara tepat.',
                    'kategori' => 'Speaking',
                    'video' => 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
                    'pdf' => 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
                ],
                [
                    'title' => 'Word Stress & Intonation Patterns',
                    'description' => 'Tekanan kata yang salah bisa mengubah arti kata. Latihlah penekanan suku kata dan pola intonasi kalimat tanya serta pernyataan.',
                    'kategori' => 'Speaking',
                    'video' => 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
                    'pdf' => null,
                ],
            ],
        ];

        foreach ($materials as $pkgName => $items) {
            $package = Package::where('name', $pkgName)->first();
            if ($package) {
                foreach ($items as $item) {
                    LearningMaterial::updateOrCreate(
                        [
                            'package_id' => $package->id,
                            'title' => $item['title'],
                        ],
                        $item
                    );
                }
            }
        }
    }
}

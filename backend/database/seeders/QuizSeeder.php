<?php

namespace Database\Seeders;

use App\Models\Package;
use App\Models\Quiz;
use App\Models\QuizQuestion;
use Illuminate\Database\Seeder;

class QuizSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $quizzesData = [
            'speaking' => [
                'title' => 'Quiz Speak & Shine',
                'description' => 'Ujian akhir untuk mengukur pemahaman materi presentasi dan body language kelas Speak & Shine.',
                'passing_score' => 70,
                'questions' => [
                    [
                        'question' => 'Ketika merasa gugup sebelum berpresentasi, tindakan fisik terbaik untuk menenangkan diri adalah...',
                        'option_a' => 'Minum kopi sebanyak-banyaknya',
                        'option_b' => 'Melatih pernapasan dalam (deep breathing)',
                        'option_c' => 'Membaca naskah secara kaku dan tergesa-gesa',
                        'option_d' => 'Menghindari kontak mata dengan audiens',
                        'correct_answer' => 'b',
                        'sort_order' => 1,
                    ],
                    [
                        'question' => 'Manakah elemen bahasa tubuh yang paling penting untuk membangun kredibilitas di mata penonton?',
                        'option_a' => 'Berdiri tegak tanpa bergerak sedikit pun',
                        'option_b' => 'Kontak mata yang stabil dan gerakan tangan yang rileks',
                        'option_c' => 'Terus-menerus menatap layar slide presentasi',
                        'option_d' => 'Melipat tangan di depan dada',
                        'correct_answer' => 'b',
                        'sort_order' => 2,
                    ],
                ]
            ],
            'speak-without-template' => [
                'title' => 'Quiz Speak Without Template',
                'description' => 'Tes kelulusan kelas berbicara spontan tanpa bantuan skrip/template percakapan.',
                'passing_score' => 70,
                'questions' => [
                    [
                        'question' => 'Apa langkah utama agar dapat berbicara bahasa Inggris secara spontan tanpa tersendat-sendat?',
                        'option_a' => 'Menghafal kamus kosa kata',
                        'option_b' => 'Membiasakan diri berpikir langsung dalam bahasa Inggris tanpa menerjemahkan',
                        'option_c' => 'Menulis seluruh naskah lalu menghafalnya',
                        'option_d' => 'Berbicara sangat lambat agar waktu habis',
                        'correct_answer' => 'b',
                        'sort_order' => 1,
                    ],
                    [
                        'question' => 'Jika seseorang menanyakan pertanyaan yang tidak Anda duga, taktik awal terbaik adalah...',
                        'option_a' => 'Diam saja dan tidak menjawab',
                        'option_b' => 'Gunakan filler words yang sopan untuk membeli waktu berpikir (seperti "That is an interesting question...")',
                        'option_c' => 'Langsung menjawab secara asal-asalan',
                        'option_d' => 'Meminta penanya untuk menanyakan hal lain',
                        'correct_answer' => 'b',
                        'sort_order' => 2,
                    ],
                ]
            ],
            'survival-english' => [
                'title' => 'Quiz Real Life English Survival',
                'description' => 'Evaluasi penguasaan percakapan dasar bahasa Inggris untuk kebutuhan sehari-hari dan traveling.',
                'passing_score' => 60,
                'questions' => [
                    [
                        'question' => 'Bagaimana cara menanyakan arah ke stasiun kereta terdekat dengan sopan?',
                        'option_a' => 'Hey, where train station?',
                        'option_b' => 'Excuse me, could you tell me the way to the nearest train station, please?',
                        'option_c' => 'Give me station location now!',
                        'option_d' => 'I want train station direct.',
                        'correct_answer' => 'b',
                        'sort_order' => 1,
                    ],
                    [
                        'question' => 'Frasa apa yang biasanya digunakan saat Anda ingin meminta tagihan pembayaran di sebuah restoran?',
                        'option_a' => 'Could we have the bill, please?',
                        'option_b' => 'I want to pay money.',
                        'option_c' => 'Give me my paper!',
                        'option_d' => 'How much food costs?',
                        'correct_answer' => 'a',
                        'sort_order' => 2,
                    ],
                ]
            ],
            'socially-fluent' => [
                'title' => 'Quiz Socially Fluent',
                'description' => 'Tes kemampuan basa-basi (small talk) dan bersosialisasi secara natural.',
                'passing_score' => 70,
                'questions' => [
                    [
                        'question' => 'Topik pembicaraan manakah yang paling aman untuk dijadikan obrolan pembuka (small talk) dengan orang asing?',
                        'option_a' => 'Keyakinan politik dan agama',
                        'option_b' => 'Cuaca, hobi, atau acara yang sedang berlangsung',
                        'option_c' => 'Riwayat penyakit pribadi',
                        'option_d' => 'Jumlah penghasilan bulanan',
                        'correct_answer' => 'b',
                        'sort_order' => 1,
                    ],
                    [
                        'question' => 'Bagaimana cara terbaik menunjukkan ketertarikan aktif saat mendengarkan lawan bicara bercerita?',
                        'option_a' => 'Bermain HP sesekali',
                        'option_b' => 'Mengangguk, tersenyum, dan mengajukan pertanyaan lanjutan yang relevan',
                        'option_c' => 'Langsung memotong ceritanya dengan cerita Anda sendiri',
                        'option_d' => 'Melihat jam tangan terus-menerus',
                        'correct_answer' => 'b',
                        'sort_order' => 2,
                    ],
                ]
            ],
            'vocabulary' => [
                'title' => 'Quiz Vocabulary Builder',
                'description' => 'Tes penguasaan kosakata dasar dan ungkapan praktis bahasa Inggris.',
                'passing_score' => 60,
                'questions' => [
                    [
                        'question' => 'Manakah dari kata berikut yang bermakna antonim (lawan kata) dari "ANCIENT"?',
                        'option_a' => 'Old',
                        'option_b' => 'Modern',
                        'option_c' => 'Classic',
                        'option_d' => 'Historic',
                        'correct_answer' => 'b',
                        'sort_order' => 1,
                    ],
                    [
                        'question' => 'Apa arti dari idiom populer "break a leg" yang biasa diucapkan kepada penampil?',
                        'option_a' => 'Semoga kakimu patah',
                        'option_b' => 'Semoga sukses / beruntung',
                        'option_c' => 'Jangan lari terlalu cepat',
                        'option_d' => 'Kerjakan dengan hati-hati',
                        'correct_answer' => 'b',
                        'sort_order' => 2,
                    ],
                ]
            ],
            'toefl' => [
                'title' => 'Quiz TOEFL Preparation Master',
                'description' => 'Simulasi ujian struktur bahasa dan pemahaman mendengar standar TOEFL.',
                'passing_score' => 70,
                'questions' => [
                    [
                        'question' => 'Complete the sentence: "By the time the class starts, Sarah ___ her homework."',
                        'option_a' => 'will finish',
                        'option_b' => 'will have finished',
                        'option_c' => 'finishes',
                        'option_d' => 'has finished',
                        'correct_answer' => 'b',
                        'sort_order' => 1,
                    ],
                    [
                        'question' => 'Complete the sentence: "Rarely ___ such a beautiful painting."',
                        'option_a' => 'I have seen',
                        'option_b' => 'have I seen',
                        'option_c' => 'I saw',
                        'option_d' => 'did I saw',
                        'correct_answer' => 'b',
                        'sort_order' => 2,
                    ],
                ]
            ],
            'ielts' => [
                'title' => 'Quiz IELTS Breakthrough',
                'description' => 'Uji pemahaman standar penilaian IELTS Speaking & Writing.',
                'passing_score' => 70,
                'questions' => [
                    [
                        'question' => 'Dalam kriteria penilaian IELTS Writing, apa yang dimaksud dengan "Coherence and Cohesion"?',
                        'option_a' => 'Kekayaan kosakata yang digunakan',
                        'option_b' => 'Kelancaran alur logika ide dan penggunaan kata penghubung paragraf yang tepat',
                        'option_c' => 'Ketepatan tanda baca dan huruf kapital',
                        'option_d' => 'Jumlah total kata yang ditulis',
                        'correct_answer' => 'b',
                        'sort_order' => 1,
                    ],
                    [
                        'question' => 'Manakah cara terbaik untuk memberikan jawaban dalam IELTS Speaking Part 3?',
                        'option_a' => 'Menjawab hanya dengan satu atau dua kata saja',
                        'option_b' => 'Memberikan poin utama, menjelaskan alasannya, dan menyertakan contoh konkret',
                        'option_c' => 'Membaca langsung dari catatan kecil yang sudah disiapkan',
                        'option_d' => 'Mengulang-ulang kalimat pertanyaan yang sama',
                        'correct_answer' => 'b',
                        'sort_order' => 2,
                    ],
                ]
            ],
            'grammar' => [
                'title' => 'Quiz Grammar Made Simple',
                'description' => 'Tes pemahaman struktur kalimat, tenses, dan passive voice.',
                'passing_score' => 70,
                'questions' => [
                    [
                        'question' => 'Pilih kalimat pasif (passive voice) yang benar dari kalimat aktif: "The manager approved the document."',
                        'option_a' => 'The document approved the manager.',
                        'option_b' => 'The document was approved by the manager.',
                        'option_c' => 'The document is approving by the manager.',
                        'option_d' => 'The manager was approved by the document.',
                        'correct_answer' => 'b',
                        'sort_order' => 1,
                    ],
                    [
                        'question' => 'Kalimat pengandaian (conditional type 2) manakah yang benar?',
                        'option_a' => 'If I have money, I would buy a car.',
                        'option_b' => 'If I had money, I would buy a car.',
                        'option_c' => 'If I would have money, I will buy a car.',
                        'option_d' => 'If I had had money, I will buy a car.',
                        'correct_answer' => 'b',
                        'sort_order' => 2,
                    ],
                ]
            ],
            'business-english' => [
                'title' => 'Quiz Business English Professional',
                'description' => 'Uji kecakapan penulisan email dan komunikasi formal di lingkungan kerja.',
                'passing_score' => 70,
                'questions' => [
                    [
                        'question' => 'Manakah salam pembuka email bisnis yang paling tepat jika Anda tidak mengetahui nama penerimanya?',
                        'option_a' => 'Hey bro,',
                        'option_b' => 'Dear Sir or Madam,',
                        'option_c' => 'Hello there,',
                        'option_d' => 'To anyone,',
                        'correct_answer' => 'b',
                        'sort_order' => 1,
                    ],
                    [
                        'question' => 'Apa ungkapan sopan yang digunakan dalam rapat untuk menyela pembicara lain?',
                        'option_a' => 'Stop talking, listen to me!',
                        'option_b' => 'Could I just jump in here for a moment?',
                        'option_c' => 'You are wrong about that.',
                        'option_d' => 'My turn to speak now.',
                        'correct_answer' => 'b',
                        'sort_order' => 2,
                    ],
                ]
            ],
            'pronunciation' => [
                'title' => 'Quiz Perfect Pronunciation',
                'description' => 'Tes pengetahuan intonasi dan pelafalan (pronunciation) aksen standar.',
                'passing_score' => 70,
                'questions' => [
                    [
                        'question' => 'Untuk kata kerja "present" (menyajikan), penekanan suku kata (word stress) yang tepat terletak pada...',
                        'option_a' => 'Suku kata pertama (PRE-sent)',
                        'option_b' => 'Suku kata kedua (pre-SENT)',
                        'option_c' => 'Kedua suku kata ditekankan sama rata',
                        'option_d' => 'Tidak ada penekanan',
                        'correct_answer' => 'b',
                        'sort_order' => 1,
                    ],
                    [
                        'question' => 'Kalimat tanya dengan jawaban Yes/No biasanya diucapkan dengan intonasi...',
                        'option_a' => 'Menurun di akhir kalimat (falling intonation)',
                        'option_b' => 'Meningkat di akhir kalimat (rising intonation)',
                        'option_c' => 'Datar tanpa nada',
                        'option_d' => 'Sangat cepat',
                        'correct_answer' => 'b',
                        'sort_order' => 2,
                    ],
                ]
            ],
        ];

        foreach ($quizzesData as $pkgName => $qData) {
            $package = Package::where('name', $pkgName)->first();
            if ($package) {
                $quiz = Quiz::updateOrCreate(
                    ['package_id' => $package->id],
                    [
                        'title' => $qData['title'],
                        'description' => $qData['description'],
                        'passing_score' => $qData['passing_score'],
                    ]
                );

                foreach ($qData['questions'] as $q) {
                    QuizQuestion::updateOrCreate(
                        [
                            'quiz_id' => $quiz->id,
                            'question' => $q['question'],
                        ],
                        $q
                    );
                }
            }
        }
    }
}

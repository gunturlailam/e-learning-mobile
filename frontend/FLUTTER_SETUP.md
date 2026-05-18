# Flutter E-Learning App - Setup Guide

## 📁 Struktur Project

```
frontend/
├── lib/
│   ├── main.dart
│   ├── core/
│   │   ├── constants/
│   │   │   └── api_constants.dart      ← Ganti base URL di sini
│   │   └── theme/
│   │       └── app_theme.dart
│   ├── data/
│   │   ├── models/
│   │   │   ├── user_model.dart
│   │   │   ├── topic_model.dart
│   │   │   └── speaking_material_model.dart
│   │   └── services/
│   │       └── api_service.dart
│   └── presentation/
│       └── screens/
│           ├── home_screen.dart
│           ├── users/
│           │   ├── users_screen.dart
│           │   └── user_form_screen.dart
│           ├── topics/
│           │   ├── topics_screen.dart
│           │   └── topic_form_screen.dart
│           └── materials/
│               ├── materials_screen.dart
│               ├── material_detail_screen.dart
│               └── material_upload_screen.dart
└── pubspec.yaml
```

---

## 🚀 Cara Menjalankan

### 1. Install dependencies

```bash
cd frontend
flutter pub get
```

### 2. Jalankan backend Laravel

```bash
cd backend
php artisan serve
```

### 3. Sesuaikan Base URL

Buka file `lib/core/constants/api_constants.dart`:

```dart
// Untuk emulator Android:
static const String baseUrl = 'http://10.0.2.2:8000/api';

// Untuk device fisik (ganti dengan IP komputer Anda):
static const String baseUrl = 'http://192.168.x.x:8000/api';

// Untuk iOS simulator:
static const String baseUrl = 'http://localhost:8000/api';
```

Cek IP komputer Anda dengan:

```bash
# Windows
ipconfig

# Mac/Linux
ifconfig
```

### 4. Jalankan Flutter app

```bash
flutter run
```

---

## 📱 Fitur Aplikasi

### 🏠 Home Screen

- Dashboard dengan banner dan menu utama
- Navigasi ke semua fitur

### 📚 Topics Screen

- List semua topik dari API
- Tambah topik baru
- Hapus topik
- Badge Free/Paid

### 🎥 Speaking Materials Screen

- List semua materi speaking
- Upload materi baru (video + PDF)
- Lihat detail materi
- Buka video di browser
- Buka PDF di browser
- Hapus materi

### 👥 Users Screen

- List semua user
- Tambah user baru
- Edit user (nama, email, password)
- Hapus user

---

## ⚙️ Konfigurasi Android

File `android/app/src/main/res/xml/network_security_config.xml` sudah dikonfigurasi untuk mengizinkan HTTP ke localhost.

Pastikan `AndroidManifest.xml` sudah memiliki:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.READ_MEDIA_VIDEO"/>
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>

<application
    android:networkSecurityConfig="@xml/network_security_config"
    ...>
```

---

## 🔧 Troubleshooting

### Error: Connection refused

- Pastikan Laravel server running: `php artisan serve`
- Cek base URL di `api_constants.dart`
- Emulator Android: gunakan `10.0.2.2` bukan `localhost`

### Error: Cleartext HTTP not permitted

- Pastikan `network_security_config.xml` sudah ada
- Pastikan `AndroidManifest.xml` sudah referensi ke file tersebut

### Error: File picker tidak bisa pilih file

- Pastikan permission storage sudah diberikan di device
- Untuk Android 13+: gunakan `READ_MEDIA_VIDEO` dan `READ_MEDIA_IMAGES`

---

## 📦 Dependencies

| Package              | Versi    | Kegunaan             |
| -------------------- | -------- | -------------------- |
| http                 | ^1.2.1   | HTTP requests ke API |
| dio                  | ^5.4.3+1 | Advanced HTTP client |
| provider             | ^6.1.2   | State management     |
| shared_preferences   | ^2.2.3   | Local storage        |
| video_player         | ^2.8.6   | Video playback       |
| chewie               | ^1.8.1   | Video player UI      |
| flutter_pdfview      | ^1.3.2   | PDF viewer           |
| file_picker          | ^8.0.3   | File selection       |
| cached_network_image | ^3.3.1   | Image caching        |
| shimmer              | ^3.0.0   | Loading skeleton     |
| fluttertoast         | ^8.2.5   | Toast messages       |
| url_launcher         | ^6.3.0   | Open URLs            |
| intl                 | ^0.19.0  | Date formatting      |

---

## 🎨 Design System

### Warna

- **Primary**: `#4F46E5` (Indigo)
- **Secondary**: `#10B981` (Green)
- **Accent**: `#F59E0B` (Amber)
- **Danger**: `#EF4444` (Red)
- **Background**: `#F8FAFC`
- **Surface**: `#FFFFFF`

### Komponen

- Rounded cards dengan border
- Bottom navigation bar
- FAB untuk tambah data
- Pull-to-refresh
- Loading states
- Error states dengan retry
- Empty states
- Confirmation dialogs
- SnackBar notifications

---

**Happy Coding! 🚀**

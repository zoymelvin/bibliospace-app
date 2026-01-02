# BiblioSpace 📚

**BiblioSpace** adalah aplikasi mobile manajemen perpustakaan digital dan toko buku modern yang dikembangkan menggunakan Flutter. Aplikasi ini memungkinkan pengguna untuk menjelajahi, menyewa, dan membeli buku dengan pengalaman pengguna yang mulus, didukung oleh sinkronisasi data real-time.

---

## 📋 Daftar Isi

- [Tentang Proyek](#-tentang-proyek)
- [Fitur Utama](#-fitur-utama)
- [Arsitektur & Teknologi](#-arsitektur--teknologi)
- [Struktur Proyek](#-struktur-proyek)
- [Instalasi & Penggunaan](#-instalasi--penggunaan)

---

## 📖 Tentang Proyek

BiblioSpace dirancang untuk memecahkan masalah aksesibilitas buku fisik dengan menyediakan platform digital hibrida (Sewa & Beli). Aplikasi ini mengintegrasikan layanan REST API eksternal untuk katalog buku dengan Firebase untuk manajemen pengguna dan transaksi, menciptakan ekosistem aplikasi yang responsif dan aman.

Fokus utama pengembangan meliputi optimalisasi performa pencarian data (client-side caching), keamanan data pengguna, dan antarmuka pengguna (UI) yang intuitif.

---

## ✨ Fitur Utama

### 1. Otentikasi & Keamanan Pengguna
- **Login & Register:** Terintegrasi penuh dengan Firebase Authentication.
- **Manajemen Profil:** Pengguna dapat mengubah nama profil dan kata sandi dengan validasi keamanan yang ketat.
- **Member Badge:** Visualisasi status keanggotaan pada halaman profil.

### 2. Katalog & Pencarian Buku Cerdas
- **Pagination:** Memuat data buku secara bertahap untuk efisiensi memori.
- **Optimized Search Engine:** Menggunakan mekanisme *caching* dan *loop-fetching* untuk memungkinkan pencarian global pada dataset API yang terpaginasi.
- **Debounce:** Mencegah pemanggilan API berlebihan saat pengguna mengetik kata kunci pencarian.

### 3. Transaksi (Sewa & Beli)
- **Sewa Buku:** Opsi penyewaan dengan durasi tertentu. Sistem secara otomatis menghitung dan memvalidasi masa berlaku sewa.
- **Beli Buku:** Opsi pembelian untuk akses permanen terhadap konten buku.
- **Validasi Ganda:** Mencegah pembelian ulang untuk buku yang sudah dimiliki atau sedang disewa.

### 4. Personalisasi & Analitik
- **Favorit:** Menyimpan buku ke daftar keinginan (Wishlist) yang tersimpan di Cloud Firestore.
- **Insight Genre:** Fitur analitik di halaman profil yang secara otomatis mendeteksi "Genre Favorit" pengguna berdasarkan riwayat transaksi mereka.

---

## 🛠 Arsitektur & Teknologi

Aplikasi ini dibangun menggunakan prinsip **Clean Architecture** yang dipisahkan berdasarkan fitur, dengan **BLoC (Business Logic Component)** sebagai manajemen state utama.

### Tech Stack
- **Framework:** Flutter (Dart)
- **State Management:** flutter_bloc
- **Networking:** Dio (dengan Interceptors & Timeouts)
- **Backend as a Service:** Firebase (Auth, Cloud Firestore)


---

## 📂 Struktur Proyek

Struktur direktori disusun secara modular untuk memudahkan pemeliharaan dan skalabilitas:
```
lib/
├── blocs/                  # Manajemen State (Business Logic)
│   ├── auth/               # Logika Login/Register/Logout
│   ├── book/               # Logika Pagination Buku (Home)
│   ├── search/             # Logika Pencarian & Caching
│   ├── favorite/           # Logika Tambah/Hapus Favorit
│   └── transaction/        # Logika Pembelian & Penyewaan
├── core/                   # Utilitas & Konfigurasi Global
│   ├── configs/            # Tema & Konstanta
│   └── utils/              # Validator Input
├── data/                   # Layer Data
│   ├── models/             # Data Models (JSON Serialization)
│   ├── repositories/       # Logika Komunikasi Data (API & Firebase)
│   └── services/           # Konfigurasi Client API (Dio)
├── ui/                     # Layer Presentasi (Widgets & Pages)
│   ├── pages/              # Halaman Layar Penuh (Auth, Home, Detail, Profile)
│   └── widgets/            # Komponen UI yang dapat digunakan kembali
└── main.dart               # Entry Point & Inisialisasi App
```

---

## 🚀 Instalasi & Penggunaan

Ikuti langkah-langkah berikut untuk menjalankan proyek ini di lingkungan lokal Anda:

### Prasyarat
- Flutter SDK (Versi Stable terbaru)
- Android Studio / VS Code
- Akun Firebase (untuk konfigurasi google-services.json)

### Langkah Instalasi

#### 1. Clone Repository
```bash
git clone https://github.com/username/bibliospace.git
cd bibliospace
```

#### 2. Install Dependencies
```bash
flutter pub get
```

#### 3. Konfigurasi Firebase

Pastikan file `google-services.json` (untuk Android) dan `GoogleService-Info.plist` (untuk iOS) telah ditempatkan di direktori masing-masing:

- **Android:** `android/app/google-services.json`
- **iOS:** `ios/Runner/GoogleService-Info.plist`

#### 4. Jalankan Aplikasi
```bash
flutter run
```

---

## 👨‍💻 Author

**Joy Melvin Ginting**  
*Flutter Developer


**Developed by Joy Melvin Ginting**  
*Mini Project - Mobile Application Development*

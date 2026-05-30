# Ayatone

[![Flutter Version](https://img.shields.io/badge/Flutter-%3E%3D_3.35.0-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-%3E%3D_3.5.0-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**Ayatone** adalah aplikasi pemutar audio (Audio Player) berbasis mobile yang dibangun menggunakan **Flutter** dan **GetX** untuk manajemen status yang efisien. Aplikasi ini dirancang untuk memberikan pengalaman mendengarkan musik atau audio yang lancar, responsif, dan interaktif dengan antarmuka pengguna yang modern.

---

## 📸 Media Preview

| ✨ UI Screenshot | 🎥 Video Demo |
| :---: | :---: |
| <img src="docs/screenshots/app_preview.png" width="280" alt="Ayatone Screenshot"> <br> *Tampilan Antarmuka Ayatone* | <img src="docs/screenshots/video_placeholder.gif" width="280" alt="Ayatone Demo"> <br> *[Klik di sini untuk melihat video](#)* |

> 💡 **Catatan untuk Pengembang:** *Ganti gambar di atas dengan screenshot asli proyek Anda di folder `docs/screenshots/app_preview.png` dan video/GIF demo Anda.*

---

## 🚀 Fitur Utama

* **Seamless Audio Playback:** Memutar, menjeda (*pause*), menghentikan (*stop*), dan menggeser (*seek*) durasi audio secara *real-time*.
* **State Management dengan GetX:** Manajemen memori yang efisien menggunakan `Get.put()` dan `Get.find()` untuk performa aplikasi yang ringan.
* **Modern UI/UX:** Desain antarmuka yang bersih, intuitif, dan nyaman di mata pengguna.
* **Optimized Size:** Konfigurasi build yang dioptimalkan untuk menghasilkan ukuran APK/AAB sekecil mungkin.

---

## 🛠️ Tech Stack & Dependencies

Aplikasi ini menggunakan beberapa teknologi utama berikut:
* **Framework:** [Flutter](https://flutter.dev)
* **State Management:** [GetX](https://pub.dev/packages/get)
* **Audio Engine:** [Audioplayers](https://pub.dev/packages/audioplayers) (v6.6.0+)

---

## ⚙️ Langkah-Langkah Instalasi

Ikuti panduan berikut untuk menjalankan proyek Ayatone di lingkungan lokal Anda.

### Prasyarat (Prerequisites)
Pastikan Anda sudah menginstal:
* Flutter SDK (Versi `>= 3.35.0`)
* Android Studio / VS Code
* Git

### 1. Clone Repositori
Buka terminal/command prompt Anda dan jalankan perintah berikut:
```bash
git clone [https://github.com/MuhammadHelga/Ayatone.git](https://github.com/MuhammadHelga/Ayatone.git)
cd Ayatone

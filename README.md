# 🚀 GERAK Mobile App

![Build Status](https://img.shields.io/badge/build-passing-brightgreen?style=for-the-badge)
![Coverage](https://img.shields.io/badge/coverage-85%25-green?style=for-the-badge)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)
![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)

**GERAK Mobile App** adalah sebuah platform komunitas dan *matchmaking* untuk aktivitas olahraga. Aplikasi ini memfasilitasi pembuatan, pencarian, dan pendaftaran berbagai kegiatan olahraga bersama (seperti Futsal, Badminton, Basket, dll).

### 🎯 Kenapa GERAK? & Untuk Siapa?
Aplikasi ini dirancang khusus untuk menjembatani dua jenis pengguna:
- 🏃‍♂️ **Pecinta Olahraga (Peserta):** Bagi Anda yang ingin rutin berolahraga namun terkendala karena *kurang teman main*, Anda bisa dengan mudah mencari dan bergabung (*Join Event*) ke pertandingan *pick-up games* di sekitar kota Anda.
- 🏟️ **Penyelenggara (Event Creator):** Bagi komunitas yang sudah menyewa lapangan namun kekurangan orang (misalnya untuk patungan), Anda dapat mendaftarkan sesi olahraga tersebut, menentukan level permainan, mengatur kuota maksimal, dan mencari peserta tambahan secara otomatis.

Dilengkapi dengan sistem *rating* pengguna, **GERAK** hadir untuk menjaga kualitas permainan dan membangun ekosistem olahraga lokal yang positif!

![Screenshot](https://via.placeholder.com/800x400?text=Screenshot/GIF+Aplikasi+Anda+Di+Sini)

---

## 🛠 Tech Stack

Aplikasi ini dibangun menggunakan teknologi modern terbaik untuk memastikan skalabilitas, keamanan, dan performa tinggi:

| Kategori | Teknologi | Deskripsi Singkat |
| --- | --- | --- |
| **Frontend** | ![Flutter](https://img.shields.io/badge/-Flutter-02569B?logo=flutter&logoColor=white) ![GetX](https://img.shields.io/badge/-GetX-FF0000?logo=dart&logoColor=white) | Aplikasi cross-platform responsif menggunakan Flutter dengan State Management GetX. |
| **Backend** | ![Node.js](https://img.shields.io/badge/-Node.js-339933?logo=node.js&logoColor=white) ![Express.js](https://img.shields.io/badge/-Express-000000?logo=express&logoColor=white) | REST API super cepat berbasis Node.js dan Express. |
| **Database** | ![MongoDB](https://img.shields.io/badge/-MongoDB-47A248?logo=mongodb&logoColor=white) | NoSQL Database untuk fleksibilitas penyimpanan data. |
| **Security** | ![JWT](https://img.shields.io/badge/-JWT-000000?logo=JSON%20web%20tokens&logoColor=white) | Autentikasi yang aman dengan JSON Web Tokens & perlindungan API menggunakan Helmet & CORS. |

## ✨ Key Features

- **Autentikasi Terintegrasi:** Sistem Login dan Register yang aman menggunakan JWT dan **Google Sign-In**.
- **State Management Reaktif:** Navigasi dan manajemen state global yang mulus serta efisien dengan **GetX**.
- **Penyimpanan Lokal Enkripsi:** Menjaga privasi data sensitif di sisi klien menggunakan *Flutter Secure Storage*.
- **RESTful API Berkinerja Tinggi:** Backend Express.js yang siap di-scale, dilengkapi kontrol akses dan *error handling* yang mumpuni.

## 🏗 System Architecture

> *Placeholder: Tambahkan Diagram Arsitektur sistem Anda (misalnya dari draw.io atau excalidraw) di sini.*

## 📋 Prerequisites

Sebelum memulai, pastikan perangkat pengembangan Anda telah memenuhi syarat berikut:
- **Flutter SDK:** `^3.10.0` atau yang lebih baru.
- **Node.js:** v18.0.0 atau yang lebih baru.
- **MongoDB:** Sedang berjalan di lokal (`localhost:27017`) atau *cluster* cloud MongoDB Atlas.
- **Git:** Untuk melakukan kloning repositori.

---

## 🚀 Getting Started

Ikuti panduan langkah demi langkah ini untuk menginstal dan menjalankan aplikasi di lingkungan lokal Anda.

### 1. Kloning Repositori
```bash
git clone https://github.com/username-kamu/gerak-mobile-app.git
cd gerak-mobile-app
```

### 2. Setup Backend (Server API)
Buka terminal dan arahkan ke direktori backend:
```bash
cd backend
npm install
```

Salin *file* konfigurasi environment:
```bash
cp .env.example .env
```
*(Pastikan Anda menyesuaikan kredensial di dalam file `.env`)*

Jalankan server untuk mode *development*:
```bash
npm run dev
```

### 3. Setup Frontend (Mobile App)
Buka terminal baru di *root directory* proyek:
```bash
flutter pub get
flutter run
```

---

## ⚙️ Environment Variables (`.env`)

Untuk menjalankan *backend*, pastikan Anda mengisi *environment variables* berikut di file `backend/.env`:

```env
# Server Configuration
PORT=3000
NODE_ENV=development

# Database
MONGODB_URI=mongodb://localhost:27017/gerak_db

# JWT & Authentication
JWT_SECRET=super_secret_key_anda_di_sini
JWT_EXPIRES_IN=30d
GOOGLE_CLIENT_ID=client_id_google_api_anda
```

## 💡 Usage

Aplikasi dapat langsung diakses melalui *emulator* (Android/iOS) atau perangkat fisik. Jika Anda ingin melakukan *testing* API secara terpisah, berikut adalah contoh request otentikasi sederhana:

**Request Login (POST `/api/auth/login`)**:
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response (200 OK)**:
```json
{
  "success": true,
  "token": "eyJhbGciOiJIUzI1NiIsInR5c...",
  "user": {
    "id": "60d0fe4f5311236168a109ca",
    "name": "Nama Pengguna"
  }
}
```

## 🧪 Testing

Jalankan perintah berikut untuk memastikan aplikasi beroperasi tanpa kendala.

**Menjalankan Test Flutter**:
```bash
flutter test
```

*(Opsional)* **Menjalankan Test Backend**:
```bash
cd backend
npm test
```

---

## 🤝 Contributing

Kontribusi selalu diterima dari sesama *developer*! Jika Anda ingin menambahkan fitur, memperbaiki *bug*, atau mempercantik UI, ikuti *workflow* berikut:

1. **Fork** repositori ini.
2. Buat branch baru untuk fitur yang dikerjakan (`git checkout -b feature/FiturKeren`).
3. Lakukan **Commit** (`git commit -m 'Menambahkan Fitur Keren'`).
4. **Push** ke branch Anda (`git push origin feature/FiturKeren`).
5. Ajukan **Pull Request** untuk di-review.

## 📄 License

Didistribusikan di bawah lisensi MIT. Lihat file `LICENSE` untuk rincian lebih lanjut.

## 📬 Contact & Author

**- Muhammad Brata Hadinata**
**- Ersya Hasby Satria**
**- Varian Abidarma Syuhada**  
*Senior Software Engineer & Open Source Enthusiast*

- 💼 **LinkedIn:** 
  - https://www.linkedin.com/in/muhammadbratahadinata/
  - https://www.linkedin.com/in/ersyahasbysatria/
  - http://linkedin.com/in/varian-abidarma-syuhada-368212386/

---
*Dibuat dengan ❤️ oleh [Nama Anda]. Berikan ⭐️ jika proyek ini bermanfaat bagi Anda!*

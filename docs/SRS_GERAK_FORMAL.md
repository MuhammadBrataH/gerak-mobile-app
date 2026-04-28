<div style="text-align: center; margin-top: 80px;">

# *SRS (Software Requirements Specification) pada Aplikasi*
# **GERAK: Platform Komunitas Olahraga Berbasis Lokasi**

<br>

**241511072 - Ersya Hasby Satria**  
**241511082 - Muhammad Brata Hadinata**  
**241511091 - Varian Abidarma Syuhada**

<br>

Program Studi Diploma 3 Teknik Informatika  
Jl. Gegerkalong Hilir, Desa Ciwaruga, Kecamatan Parongpong,  
Kabupaten Bandung Barat, Jawa Barat 40012

<br>

Politeknik Negeri Bandung, Indonesia

</div>

## Abstrak

Dokumen ini adalah Software Requirements Specification (SRS) untuk aplikasi GERAK—sebuah platform komunitas olahraga berbasis lokasi yang memfasilitasi pencarian pertandingan olahraga secara real-time. Dokumen ini mendefinisikan kebutuhan fungsional dan non-fungsional yang menjadi panduan untuk tim development selama 7 minggu pengembangan. SRS mencakup use case diagram, acceptance criteria untuk setiap fitur, functional requirements dengan prioritas MoSCoW (Must/Should/Could/Won't), non-functional requirements untuk performance dan security, serta constraints dan limitasi project. Tujuan SRS adalah memastikan semua stakeholder memiliki pemahaman yang sama tentang apa yang akan dibangun dan bagaimana aplikasi akan berperilaku.

**Kata kunci:** *SRS, Software Requirements Specification, GERAK, platform olahraga, functional requirements, use case, acceptance criteria*

## I. PENDAHULUAN

### 1.1 Tujuan Dokumen

Dokumen SRS ini bertujuan untuk:

1. Mendefinisikan kebutuhan fungsional aplikasi GERAK secara detail dan terukur
2. Menjelaskan fitur-fitur dengan prioritas menggunakan MoSCoW method
3. Menyediakan acceptance criteria yang jelas untuk setiap requirement
4. Mendokumentasikan kebutuhan non-fungsional (performance, security, compatibility)
5. Mengidentifikasi constraint dan asumsi yang mempengaruhi development
6. Menjadi referensi untuk design, development, dan quality assurance

### 1.2 Scope Dokumen

Dokumen ini mencakup:

- ✓ Use case diagram dan deskripsi untuk setiap fitur
- ✓ Kebutuhan fungsional dengan detail acceptance criteria
- ✓ Kebutuhan non-fungsional (performance, security, compatibility)
- ✓ Prioritas fitur menggunakan MoSCoW method
- ✓ Assumptions dan constraints
- ✓ Glossary dan terminologi

### 1.3 Target Pembaca

- **Development Team:** Brata dan Abi untuk implementasi
- **Project Manager:** Ersya untuk tracking dan validasi
- **Stakeholder:** Dosen dan reviewers untuk approval

## II. DESKRIPSI UMUM PRODUK

### 2.1 Visi Produk

GERAK adalah platform direktori olahraga komunitas yang menghubungkan individu pencari olahraga dengan penyelenggara event olahraga lokal. Platform ini memudahkan pengguna menemukan event berdasarkan preferensi (jenis olahraga, level kemampuan) dan lokasi regional (filter kota/kecamatan). Integrasi WhatsApp Smart-Redirect memungkinkan komunikasi cepat dan structured antara pemain dan organizer tanpa perlu in-app chat.

### 2.2 Nilai yang Diberikan

| Untuk Pencari Olahraga | Untuk Organizer Event |
|---|---|
| Menemukan event komunitas dengan filter regional | Mencari pemain untuk mengisi slot kosong |
| Filter berdasarkan jenis olahraga dan level kemampuan | Reach pengguna lebih luas |
| Komunikasi terstruktur via WhatsApp Smart-Redirect | Manajemen event lebih efisien |
| Lihat rating komunitas sebelum join | Build community trust dan reputasi |

### 2.3 Pengguna Target

- **Primary User:** Individu usia 18-50 tahun yang aktif berolahraga dan punya smartphone
- **Secondary User:** Organizer/admin komunitas olahraga, team leader

### 2.4 Asumsi dan Dependensi

- Pengguna memiliki koneksi internet (WiFi atau 3G+)
- WhatsApp terpasang di device pengguna (wajib untuk Smart-Redirect)
- GPS adalah optional untuk MVP (bisa diaktifkan di future phase untuk geofencing)
- Backend API sudah siap minggu ke-4
- MongoDB Atlas atau MongoDB lokal sudah disetup
- Pengguna memiliki nomor WhatsApp yang valid untuk dihubungi

## III. FITUR-FITUR (MoSCoW PRIORITY)

### 3.1 MUST HAVE (Fitur Inti - Wajib Ada)

#### 3.1.1 Authentication & User Management

**Deskripsi:** Pengguna dapat login/register dengan email dan password, serta mengelola profil mereka.

**User Story:**
- Sebagai pengguna baru, saya ingin register dengan email, password, nama, dan profil olahraga
- Sebagai pengguna terdaftar, saya ingin login dengan email dan password
- Sebagai pengguna, saya ingin logout dan session hilang
- Sebagai pengguna, saya ingin melihat dan edit profil saya (nama, olahraga, level kemampuan)

**Acceptance Criteria:**

| ID | Kriteria | Detail |
|---|---|---|
| AUTH-01 | Register berhasil | Validasi email unik, password strength, semua field wajib diisi |
| AUTH-02 | Login berhasil | Token disimpan di local storage, user redirect ke home |
| AUTH-03 | Login gagal | Error message jelas, user bisa retry |
| AUTH-04 | Session persist | User tetap login saat app ditutup & dibuka kembali |
| AUTH-05 | Logout | Session dihapus, user redirect ke login |
| AUTH-06 | Edit profil | Update nama, foto, olahraga favorit, level kemampuan |

#### 3.1.2 Browse & Search Events (dengan Regional Filter)

**Deskripsi:** Pengguna dapat melihat list event dengan filter berbasis text (kota/kecamatan) dan dropdown preferensi.

**User Story:**
- Sebagai pengguna, saya ingin melihat list event terdekat dari region saya
- Sebagai pengguna, saya ingin filter event berdasarkan olahraga (futsal, badminton, basket, dll)
- Sebagai pengguna, saya ingin filter event berdasarkan level kemampuan (pemula, menengah, kompetitif)
- Sebagai pengguna, saya ingin filter event berdasarkan kota/kecamatan
- Sebagai pengguna, saya ingin scroll infinite atau load more untuk event lebih banyak
- Sebagai pengguna, saya ingin pull-to-refresh untuk update list event terbaru

**Acceptance Criteria:**

| ID | Kriteria | Detail |
|---|---|---|
| EVT-01 | List event | Tampilkan: nama, olahraga, level, slot kosong, waktu, lokasi, rating |
| EVT-02 | Filter sport | Dropdown list olahraga (futsal, badminton, basketball, tennis, volleyball) |
| EVT-03 | Filter level | Filter: pemula (beginner), menengah (intermediate), kompetitif (advanced), mixed |
| EVT-04 | Filter city | Dropdown kota/kab atau free-text search kota |
| EVT-05 | Filter district | Optional: filter spesifik kecamatan (dropdown atau autocomplete) |
| EVT-06 | Pagination | Infinite scroll atau tombol Load More |
| EVT-07 | Pull-to-refresh | Gesture tarik ke atas untuk refresh list |
| EVT-08 | Sort default | Default sort berdasarkan waktu event atau rating tertinggi |

#### 3.1.3 Event Detail, Rating View, & WhatsApp Smart-Redirect

**Deskripsi:** Pengguna dapat melihat detail event lengkap, rating komunitas, dan redirect terstruktur ke WhatsApp admin.

**User Story:**
- Sebagai pengguna, saya ingin melihat informasi lengkap event (deskripsi, pemain yang sudah join, rating, ulasan)
- Sebagai pengguna, saya ingin join event dan confirm kehadiran
- Sebagai pengguna, saya ingin redirect ke WhatsApp admin dengan pesan template yang terstruktur
- Sebagai pengguna, saya ingin tahu berapa slot yang tersedia dan siapa saja yang sudah join

**Acceptance Criteria:**

| ID | Kriteria | Detail |
|---|---|---|
| DET-01 | Detail event | Info: nama, deskripsi, waktu, lokasi (kota/kecamatan), level, slot kosong, organizer |
| DET-02 | List pemain | Tampilkan nama & level kemampuan pemain yang sudah join |
| DET-03 | Rating & ulasan | Tampilkan rata-rata rating dan 3-5 ulasan terbaru dari pengguna lain |
| DET-04 | Join button | Tombol aktif jika ada slot kosong, disable jika penuh atau sudah join |
| DET-05 | Confirmation modal | Modal popup konfirmasi "Yakin join event ini?" sebelum proceed |
| DET-06 | WhatsApp Smart-Redirect | Deep link ke WhatsApp dengan format pesan terstruktur: "Nama User join Event Name - [Nama Acara]" |
| DET-07 | Admin contact | Tampilkan nomor WhatsApp organizer (masked atau format wa.me link) |
| DET-08 | Leave event | Tombol untuk leave/cancel join jika belum dimulai |

#### 3.1.4 Create Event (untuk Organizer/Admin)

**Deskripsi:** Organizer atau penyelenggara dapat membuat event baru dan publikasi ke direktori.

**User Story:**
- Sebagai organizer, saya ingin buat event baru dengan detail lengkap
- Sebagai organizer, saya ingin set jumlah slot dan jenis olahraga
- Sebagai organizer, saya ingin edit atau delete event yang sudah dibuat
- Sebagai organizer, saya ingin provide nomor WhatsApp untuk dihubungi pemain

**Acceptance Criteria:**

| ID | Kriteria | Detail |
|---|---|---|
| CRT-01 | Create form | Input: nama event, deskripsi, olahraga, level, waktu mulai/selesai, lokasi, kota, kecamatan, max slot, nomor WhatsApp |
| CRT-02 | Validation | Semua field wajib diisi, format waktu valid, max slot > 0 |
| CRT-03 | Publish event | Event otomatis ter-list di browse page setelah create |
| CRT-04 | Edit event | Organizer bisa edit event yang masih berlangsung atau akan datang |
| CRT-05 | Delete event | Organizer bisa delete event dan event hilang dari direktori |
| CRT-06 | Event history | Organizer bisa lihat list event yang sudah dibuat |

### 3.2 SHOULD HAVE (Fitur Penting - Sangat Diinginkan)

#### 3.2.1 Rating & Review System

**Deskripsi:** Pengguna dapat memberikan rating dan ulasan untuk event yang sudah diikuti untuk membangun trust dan reputasi komunitas.

**User Story:**
- Sebagai pengguna, saya ingin memberi rating 1-5 bintang untuk event yang sudah selesai
- Sebagai pengguna, saya ingin tulis ulasan tekstual tentang pengalaman event
- Sebagai pengguna, saya ingin lihat rating dan ulasan dari pengguna lain sebelum join
- Sebagai organizer, saya ingin lihat feedback dari pemain untuk improve event kedepannya

**Acceptance Criteria:**

| ID | Kriteria | Detail |
|---|---|---|
| RAT-01 | Form rating | UI: star rating (1-5 stars) dan text field untuk ulasan max 500 karakter |
| RAT-02 | Only post-event | User hanya bisa rate setelah event selesai (backend validasi time) |
| RAT-03 | List reviews | Tampilkan 5-10 review terbaru dengan nama user, rating, text, tanggal |
| RAT-04 | Average rating | Hitung dan display rata-rata rating event di event card dan detail page |
| RAT-05 | Review count | Tampilkan jumlah review total (contoh: "4.5 bintang dari 23 ulasan") |
| RAT-06 | Update/Delete | User bisa update atau delete rating mereka sendiri |
| RAT-07 | User rating badge | Tampilkan average rating dari pengguna di profile (reputasi) |

#### 3.2.2 User Profile & History

**Deskripsi:** Pengguna dapat melihat profil dan riwayat event yang sudah diikuti.

**User Story:**
- Sebagai pengguna, saya ingin melihat profil saya dengan semua data personal
- Sebagai pengguna, saya ingin lihat history event yang sudah diikuti
- Sebagai pengguna, saya ingin lihat rating yang diberikan ke saya dari organizer

**Acceptance Criteria:**

| ID | Kriteria | Detail |
|---|---|---|
| PRF-01 | Profile page | Tampilkan: foto, nama, email, olahraga, level, rating |
| PRF-02 | Edit profile | Tombol edit untuk update data personal |
| PRF-03 | Event history | Tab: upcoming, ongoing, completed events |
| PRF-04 | User rating | Tampilkan average rating dari event yang sudah dihadiri |

### 3.3 COULD HAVE (Fitur Tambahan - Nice to Have)

#### 3.3.1 Geofencing & GPS-based Location

Aplikasi menggunakan GPS dan radius calculation untuk filter event berdasarkan lokasi real-time pengguna. Fitur ini optional untuk MVP dan bisa diimplementasikan di phase kedua setelah core features stable. Jika dijalankan, akan include: GPS permission request, radius slider (1/5/10/20 km), distance display per event, dan sorting by distance.

#### 3.3.2 Push Notification

Notifikasi untuk event terbaru atau event matching dengan preferensi pengguna (sport, level, lokasi). Optional, bisa ditambah kemudian untuk user engagement yang lebih tinggi.

#### 3.3.3 Map View with Event Markers

Tampilan peta interaktif dengan marker untuk event terdekat. User bisa tap marker untuk lihat detail event. Optional, berguna untuk visual discovery tapi kompleks untuk MVP phase.

#### 3.3.4 Tournament Directory (Mading Digital)

**Deskripsi:** Admin/penyelenggara dapat publikasi info turnamen lokal dengan poster dan tautan pendaftaran eksternal (read-only untuk user biasa).

**User Story:**
- Sebagai organizer, saya ingin publikasikan info turnamen dengan poster dan deskripsi
- Sebagai pengguna, saya ingin lihat daftar turnamen lokal dengan kategori dan tanggal
- Sebagai pengguna, saya ingin klik untuk buka tautan pendaftaran turnamen (eksternal link)

**Acceptance Criteria:**

| ID | Kriteria | Detail |
|---|---|---|
| TRN-01 | Tournament listing | Tab terpisah di app atau section di home page |
| TRN-02 | Tournament card | Tampilkan: nama, tanggal, olahraga, kategori level, foto poster |
| TRN-03 | Tournament detail | Info: deskripsi, prize pool, slots tersedia, contact, registration link |
| TRN-04 | External link | Tombol daftar mengarah ke link eksternal (web/form) |
| TRN-05 | Admin create | Organizer bisa upload poster & info turnamen |

### 3.4 WON'T HAVE (Out of Scope)

- Payment gateway atau transaksi finansial
- Booking venue (hanya event listing)
- Chat in-app dengan organizer (cukup WhatsApp redirect)
- Live tracking lokasi pengguna

## IV. KEBUTUHAN NON-FUNGSIONAL

### 4.1 Performance

| Requirement | Target | Catatan |
|---|---|---|
| Load list event | < 2 detik (3G) | Dengan pagination |
| Open event detail | < 1 detik | Cached data support |
| GPS location get | < 500ms | Background execution |
| Geofencing calculation | < 200ms | Efficient query (jika enabled di phase 2) |

### 4.2 Security

- Password harus ter-hash menggunakan bcrypt atau argon2
- Token authentication gunakan JWT dengan expiry 24 jam
- All API calls gunakan HTTPS
- Validasi input di client dan server
- Sensitive data tidak disimpan di local storage (hanya token)

### 4.3 Compatibility

| Platform | Version | Details |
|---|---|---|
| Android | 5.0 (API 21+) | Minimum |
| iOS | 11.0+ | Minimum |
| Screen size | 4.5" - 6.7" | Responsive design |

### 4.4 Reliability

- Automatic retry untuk failed API call (max 3x)
- Offline mode: display cached data dengan indicator
- Graceful error handling dengan user-friendly messages
- App crash recovery: restart dengan recover state

### 4.5 Usability

- Bahasa: Bahasa Indonesia
- Ikuti design dari Figma mockup (Abi)
- Loading indicator untuk setiap async operation
- Clear error messages (bukan technical error codes)
- Minimal 3 tap/click untuk core actions

## V. CONSTRAINTS & LIMITASI

### 5.1 Timeline

- **Total Duration:** 7 minggu
  - Minggu 1: Diskusi & kickoff
  - Minggu 2: Fiksasi & Git setup
  - Minggu 3: SRS & SDD finalization
  - Minggu 4-5: Development
  - Minggu 6: Testing & bugfix
  - Minggu 7: Presentasi

### 5.2 Team

- **Total:** 3 orang
  - Abi: UI/UX Designer & Frontend
  - Brata: Full Stack Developer & Backend
  - Ersya: Project Manager & QA

### 5.3 Technology

- **Frontend:** Flutter (Dart) only
- **Backend:** Node.js/Express API (managed separately)
- **Database:** MongoDB (Cloud atau local)
- **Authentication:** JWT + Refresh Token
- **Communication:** REST API

### 5.4 External Dependencies

- WhatsApp API untuk redirect (free wa.me deep link)
- Firebase atau geospatial service untuk GPS (jika needed)
- MongoDB Atlas atau local instance

## VI. GLOSSARY & TERMINOLOGI

| Term | Definisi |
|---|---|
| Event | Pertandingan atau sesi latihan olahraga yang memiliki slot pemain terbatas |
| Slot | Posisi pemain dalam event yang masih kosong dan bisa diisi |
| Sparring | Pertandingan training antara dua komunitas untuk cari lawan |
| Geofencing | Teknologi pembatasan area berdasarkan koordinat GPS dan radius |
| MoSCoW | Prioritas fitur: Must, Should, Could, Won't |
| User Story | Deskripsi fitur dari perspektif pengguna "Sebagai [user], saya ingin [action], supaya [benefit]" |
| Acceptance Criteria | Kondisi yang harus terpenuhi agar fitur dianggap selesai |
| API | Application Programming Interface, antarmuka untuk komunikasi backend-frontend |
| JWT | JSON Web Token, untuk authentication stateless |
| GPS | Global Positioning System, teknologi lokasi |


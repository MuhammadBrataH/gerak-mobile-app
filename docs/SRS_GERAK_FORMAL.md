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

GERAK adalah platform mobile yang menghubungkan individu pencari olahraga dengan penyelenggara event olahraga komunitas. Platform ini memudahkan pengguna menemukan event terdekat berdasarkan preferensi (jenis olahraga, level kemampuan) dan lokasi real-time via GPS.

### 2.2 Nilai yang Diberikan

| Untuk Pencari Olahraga | Untuk Organizer Event |
|---|---|
| Menemukan event terdekat dengan cepat | Mencari pemain untuk mengisi slot kosong |
| Filter berdasarkan level kemampuan | Reach pengguna lebih luas |
| Komunikasi langsung via WhatsApp | Manajemen event lebih efisien |
| Lihat rating komunitas sebelum join | Build community trust |

### 2.3 Pengguna Target

- **Primary User:** Individu usia 18-50 tahun yang aktif berolahraga dan punya smartphone
- **Secondary User:** Organizer/admin komunitas olahraga, team leader

### 2.4 Asumsi dan Dependensi

- Pengguna memiliki koneksi internet (WiFi atau 3G+)
- GPS terhubung dan enabled di device
- WhatsApp terpasang di device pengguna
- Backend API sudah siap minggu ke-4
- MongoDB Atlas atau MongoDB lokal sudah disetup

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

#### 3.1.2 Browse & Search Events

**Deskripsi:** Pengguna dapat melihat list event dengan filter dan search.

**User Story:**
- Sebagai pengguna, saya ingin melihat list event terdekat dari lokasi saya
- Sebagai pengguna, saya ingin filter event berdasarkan olahraga dan level kemampuan
- Sebagai pengguna, saya ingin scroll infinite atau load more untuk event lebih banyak
- Sebagai pengguna, saya ingin pull-to-refresh untuk update list event terbaru

**Acceptance Criteria:**

| ID | Kriteria | Detail |
|---|---|---|
| EVT-01 | List event | Tampilkan: nama, olahraga, level, slot kosong, jarak, waktu |
| EVT-02 | Filter sport | Dropdown list olahraga (futsal, badminton, basketball, tennis, volleyball) |
| EVT-03 | Filter level | Filter: beginner, intermediate, advanced, mixed |
| EVT-04 | Pagination | Infinite scroll atau tombol Load More |
| EVT-05 | Pull-to-refresh | Gesture tarik ke atas untuk refresh list |
| EVT-06 | Sort by distance | Default sort berdasarkan jarak terdekat |

#### 3.1.3 Event Detail & Join

**Deskripsi:** Pengguna dapat melihat detail event dan join/confirm kehadiran.

**User Story:**
- Sebagai pengguna, saya ingin melihat informasi lengkap event (deskripsi, pemain, rating, ulasan)
- Sebagai pengguna, saya ingin join event dan confirm kehadiran
- Sebagai pengguna, saya ingin redirect ke WhatsApp admin setelah join
- Sebagai pengguna, saya ingin tahu berapa slot yang tersedia

**Acceptance Criteria:**

| ID | Kriteria | Detail |
|---|---|---|
| DET-01 | Detail event | Info: nama, deskripsi, waktu, lokasi, level, slot kosong |
| DET-02 | List pemain | Tampilkan nama & level kemampuan pemain yang sudah join |
| DET-03 | Rating & ulasan | Tampilkan rata-rata rating dan ulasan dari pengguna lain |
| DET-04 | Join button | Tombol aktif jika ada slot kosong, disable jika penuh |
| DET-05 | Confirmation modal | Modal popup konfirmasi sebelum join |
| DET-06 | WhatsApp redirect | Tombol hubungi admin via WhatsApp (deep link wa.me) |
| DET-07 | Status user | Indicator: sudah join / belum join / pending approval |

#### 3.1.4 Geofencing & Location

**Deskripsi:** Aplikasi menggunakan GPS untuk filter event berdasarkan radius lokasi pengguna.

**User Story:**
- Sebagai pengguna, saya ingin aplikasi meminta izin akses GPS
- Sebagai pengguna, saya ingin filter event berdasarkan radius (1km, 5km, 10km, 20km, semua lokasi)
- Sebagai pengguna, saya ingin tahu jarak setiap event dari lokasi saya
- Sebagai pengguna, saya ingin event diurutkan berdasarkan jarak terdekat

**Acceptance Criteria:**

| ID | Kriteria | Detail |
|---|---|---|
| GEO-01 | GPS permission | Request izin akses lokasi saat app pertama kali dibuka |
| GEO-02 | Radius filter | Slider atau dropdown untuk pilih 1/5/10/20 km atau semua |
| GEO-03 | Distance display | Tampilkan jarak event dalam format "2.5 km" |
| GEO-04 | Sort by distance | Event dengan jarak terdekat muncul paling atas |
| GEO-05 | GPS off handling | Graceful error jika GPS tidak aktif |

### 3.2 SHOULD HAVE (Fitur Penting - Sangat Diinginkan)

#### 3.2.1 Rating & Review System

**Deskripsi:** Pengguna dapat memberikan rating dan ulasan untuk event yang sudah diikuti.

**User Story:**
- Sebagai pengguna, saya ingin memberi rating 1-5 bintang untuk event yang sudah selesai
- Sebagai pengguna, saya ingin tulis ulasan tekstual tentang pengalaman event
- Sebagai pengguna, saya ingin lihat rating dan ulasan dari pengguna lain

**Acceptance Criteria:**

| ID | Kriteria | Detail |
|---|---|---|
| RAT-01 | Form rating | UI: star rating (1-5) dan text field untuk ulasan max 500 karakter |
| RAT-02 | Only post-event | User hanya bisa rate setelah event selesai (backend validasi) |
| RAT-03 | List reviews | Tampilkan 5-10 review terbaru dengan nama user, rating, text, date |
| RAT-04 | Average rating | Hitung dan display rata-rata rating event |
| RAT-05 | Review count | Tampilkan jumlah review total |

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

#### 3.3.1 Push Notification

Notifikasi untuk event terbaru berdasarkan preferensi pengguna (opsional, bisa ditambah kemudian).

#### 3.3.2 Map View

Tampilan map dengan marker untuk event terdekat (opsional, bisa diimplementasikan tahap 2).

#### 3.3.3 Sparring Finder

Fitur khusus untuk mencari lawan sparring (opsional, kompleks, bisa dimulai dari MVP sederhana).

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
| Geofencing calculation | < 200ms | Efficient query |

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


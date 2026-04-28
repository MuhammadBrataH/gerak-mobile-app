<div style="text-align: center; margin-top: 80px;">

# *SDD (Software Design Document) pada Aplikasi*
# **GERAK: Platform Komunitas Olahraga Berbasis Lokasi**

<br>

**241511072 - Ersya Hasby Satria**  
**241511082 - Muhammad Brata Hadinata**  
**241511091 - Varian Abidarma Syuhada**

<br>

Program Studi Diploma 3 Teknik Informatika  
Jl. Gegerkalong Hilir, Desa Ciwaruga, Kecamatan Parongpong,  
Kabupaten Bandung Barat, Jawa Barat 40012

Politeknik Negeri Bandung, Indonesia

</div>

## Abstrak

Dokumen ini adalah *Software Design Document* (SDD) untuk aplikasi GERAK—sebuah platform direktori olahraga komunitas yang memfasilitasi pencarian pertandingan dan pencarian lawan tanding (sparring) secara terpusat. GERAK membantu individu menemukan rekan bermain yang selevel dan komunitas dapat mengisi slot pemain dengan lebih efisien melalui integrasi WhatsApp Smart-Redirect. Dibangun dengan Flutter untuk frontend mobile, Node.js/Express untuk backend API, dan MongoDB untuk database, aplikasi ini menerapkan filter berbasis lokasi teks/dropdown regional, rating system, dan event matching dengan priority pada core MVP (Must-Have features). Dokumen ini mendefinisikan use case diagram, activity diagram, entity relationship diagram, struktur database, rancangan antarmuka pengguna, dan strategi pengujian untuk memandu implementasi yang konsisten selama 7 minggu pengembangan oleh tim 3 orang. Tujuan akhir adalah menghasilkan aplikasi production-ready yang dapat digunakan komunitas olahraga nyata dan berkelanjutan hingga tugas akhir.

**Kata kunci:** *SDD, Software Design Document, GERAK, platform olahraga, direktori event, smart matchmaking, WhatsApp integration, regional filter*


## I. PENDAHULUAN

### 1.1 Tujuan Dokumen

Dokumen Software Design Document (SDD) ini bertujuan untuk:

1. Mendefisikan arsitektur teknis dan struktur aplikasi GERAK secara detail
2. Menjelaskan design pattern dan technology stack yang digunakan
3. Menyediakan blueprint struktur database dan API contracts
4. Mendokumentasikan alur sistem melalui use case dan activity diagram
5. Mengarahkan tim implementasi untuk konsisten dalam coding dan architecture
6. Menjadi referensi untuk testing dan quality assurance di minggu 6-7

### 1.2 Scope Dokumen

Dokumen ini mencakup:

- Analisis kebutuhan perangkat keras dan lunak
- Use case diagram untuk setiap modul fitur
- Activity diagram untuk alur kerja pengguna
- Entity relationship diagram dan struktur database
- Rancangan antarmuka pengguna per screen
- Strategi testing dengan kuisioner
- Teknologi stack dan tools yang digunakan


## II. IDENTIFIKASI MASALAH

Masalah yang akan diselesaikan oleh aplikasi GERAK:

### 2.1 Kesulitan Mencari Rekan Olahraga Selevel

- Individu yang ingin berolahraga rutin kesulitan menemukan partner/tim yang sebanding kemampuannya
- Tidak ada platform terpusat untuk discovery event olahraga lokal

### 2.2 Komunitas Kesulitan Mengisi Slot Pemain

- Penyelenggara event sering kekurangan pemain untuk jadwal tertentu
- Proses rekrutmen pemain bersifat manual dan time-consuming

### 2.3 Komunikasi Tidak Efisien

- Belum ada channel komunikasi langsung yang cepat antara pencari dan penyelenggara
- Informasi event tersebar di berbagai media sosial

### 2.4 Kurangnya Informasi Event Berbasis Regional/Lokasi

- Belum ada direktori terpusat untuk discovery event olahraga per wilayah (kota/kecamatan)
- User harus manual mencari informasi event tersebar di berbagai media sosial
- Tidak ada mekanisme efisien untuk kontak langsung antara pencari dan organizer event




## III. TUJUAN

### 3.1 Tujuan Utama

- Menyediakan direktori terpusat (mading digital) untuk pengguna menemukan event olahraga berbasis filter regional (kota/kecamatan)
- Memfasilitasi penyelenggara untuk mencari dan merekrut pemain baru dengan reach yang lebih luas
- Mempercepat komunikasi dan negosiasi antara pemain dan penyelenggara melalui WhatsApp Smart-Redirect dengan pesan template terstruktur

### 3.2 Tujuan Sekunder

- Membangun community trust melalui rating dan review system
- Menciptakan ecosystem olahraga komunitas yang lebih terkoneksi
- Menghasilkan aplikasi production-ready yang sustainable hingga tugas akhir


## IV. PEMBAHASAN

### 4.1 Analisa Kebutuhan Perangkat Keras

Untuk menjalankan pengembangan aplikasi GERAK, diperlukan perangkat keras minimal dengan spesifikasi berikut:

| Komponen | Spesifikasi |
|---|---|
| **Processor** | Intel Core i5 atau Ryzen 5 (2.0 GHz) atau lebih tinggi |
| **Memory (RAM)** | 8 GB DDR4 (minimum 6 GB) |
| **Storage (SSD)** | 256 GB (untuk Android emulator, Flutter SDK, dan project files) |
| **Monitor** | 13" inch atau lebih besar untuk development |
| **USB Port** | USB 3.0 untuk debugging device |
| **Networking** | WiFi adapter atau Ethernet (koneksi stabil untuk API testing) |
| **Operating System** | Windows 10/11, macOS 10.14+, atau Linux Ubuntu 18.04+ |
| **Device Testing** | Android device (API 21+) atau iOS device (iOS 11+) |

### 4.2 Analisa Kebutuhan Perangkat Lunak

Untuk menjalankan aplikasi GERAK pada sisi user, diperlukan:

#### **a. Mobile Device Requirements:**

- Android minimum versi 5.0 (API Level 21) dengan minimal 2GB RAM
- iOS minimum versi 11.0 dengan minimal 2GB RAM
- Koneksi internet (WiFi atau mobile data 3G+)
- WhatsApp terpasang untuk Smart-Redirect komunikasi (wajib)
- GPS enabled adalah optional (untuk future geofencing feature di Could-Have phase)

#### **b. Development Tools:**

- Flutter SDK version 3.0+ dan Dart SDK 2.17+
- Android Studio 4.1+ atau VS Code dengan Flutter extension
- Git untuk version control
- Postman atau Insomnia untuk API testing
- MongoDB Compass untuk database management

#### **c. Backend & Database:**

- Backend Server: Node.js 14+ dengan Express Framework
- Database: MongoDB 4.4+ (Cloud: MongoDB Atlas atau Local)
- API Testing: Postman atau Thunder Client


## V. RANCANGAN USE CASE DIAGRAM

### 5.1 Sistem Use Case Diagram Utama

```
┌─────────────────────────────────────────────────────────────┐
│                  Aplikasi GERAK                             │
├─────────────────────────────────────────────────────────────┤
│              ┌──────────────────┐                            │
│              │                  │                            │
│              │   Login & Auth   │◄───────────┐               │
│              │                  │            │               │
│              └──────────────────┘            │               │
│                       │                      │               │
│                       ▼                      │               │
│              ┌──────────────────┐           │                │
│              │                  │           │ ┌─────────┐    │
│        ┌────►│ Browse Events    │           └─┤  User   │    │
│        │     │ (Filter & List)  │     ┌──────►└─────────┘    │
│        │     │                  │     │                       │
│        │     └──────────────────┘     │                       │
│        │            │                 │                       │
│        │            ▼                 │                       │
│        │     ┌──────────────────┐    │                        │
│        │     │                  │    │                        │
│        │     │ View Event Detail│    │                        │
│        │     │ & Join           │    │                        │
│        │     │                  │    │                        │
│        │     └──────────────────┘    │                        │
│        │                             │                        │
│        │     ┌──────────────────┐   │                         │
│        │     │                  │   │   ┌──────────┐          │
│        │     │ Rate & Review    │───────►│ Organizer│          │
│        │     │ Event            │       └──────────┘          │
│        │     │                  │                             │
│        │     └──────────────────┘                             │
│        │                                                             │
│        │     ┌──────────────────┐                             │
│        │     │                  │                             │
│        └────►│ View Profile &   │                             │
│              │ Joined Events    │                             │
│              │                  │                             │
│              └──────────────────┘                             │
│                                                               │
│                                                             │
│                                                               │
└─────────────────────────────────────────────────────────────┘
``` 

### 5.2 Use Case Diagram - Authentication

```
┌──────────────────────────────────────────┐
│      Authentication Module               │
├──────────────────────────────────────────┤
│                                          │
│     ┌────────────────────┐               │
│     │                    │               │
│     │   Login            │               │
│     │   - Email/Password │               │
│     │                    │    ┌──────┐   │
│   ┌─►                    ├───►│ User │   │
│   │ └────────────────────┘    └──────┘   │
│   │                                       │
│   │ ┌────────────────────┐               │
│   │ │                    │               │
│   │ │   Register         │               │
│   │ │   - New Account    │               │
│   └─►   - Profile Setup  │               │
│     │                    │               │
│     └────────────────────┘               │
│                                          │
│     ┌────────────────────┐               │
│     │                    │               │
│     │   Logout           │               │
│     │   - Clear Session  │               │
│     │                    │               │
│     └────────────────────┘               │
│                                          │
└──────────────────────────────────────────┘
```

### 5.3 Use Case Diagram - Event Management

```
┌──────────────────────────────────────────┐
│      Event Management Module             │
├──────────────────────────────────────────┤
│                                          │
│     ┌────────────────────┐               │
│     │                    │               │
│     │  Browse Events     │               │
│     │  - List View       │    ┌──────┐   │
│   ┌─►  - Filter Sport    ├───►│ User │   │
│   │ │  - Filter Level    │    └──────┘   │
│   │ └────────────────────┘               │
│   │                                       │
│   │ ┌────────────────────┐               │
│   │ │                    │               │
│   │ │  View Detail       │               │
│   │ │  - Event Info      │               │
│   └─►  - Joined Players  │               │
│     │  - Ratings         │               │
│     └────────────────────┘               │
│                                          │
│     ┌────────────────────┐               │
│     │                    │               │
│     │  Join Event        │               │
│     │  - Confirm Join    │               │
│     │  - Redirect WA     │               │
│     │                    │               │
│     └────────────────────┘               │
│                                          │
└──────────────────────────────────────────┘
```

## VI. RANCANGAN ACTIVITY DIAGRAM

### 6.1 Activity Diagram - Login & Register

```
┌──────────────────────────────────────────────────────────┐
│               LOGIN & REGISTER FLOW                      │
├──────────────────────────────────────────────────────────┤
│                                                          │
│  ┌─────────┐                                            │
│  │ START   │                                            │
│  └────┬────┘                                            │
│       │                                                 │
│       ▼                                                 │
│  ┌─────────────────────┐                               │
│  │ Open Login Screen   │                               │
│  └────┬────────────────┘                               │
│       │                                                │
│       ▼                                                │
│  ◇──────────────────────────◇                          │
│  │ User has account?       │                           │
│  │ YES / NO               │                            │
│  ◇────┬──────────────┬─────◇                           │
│       │              │                                 │
│   YES │              │ NO                              │
│       │              │                                 │
│       ▼              ▼                                 │
│  ┌────────────┐  ┌──────────────────┐               │
│  │ Input Email│  │ Fill Register    │               │
│  │ & Password │  │ - Email/Password │               │
│  └─────┬──────┘  │ - Name/Sports    │               │
│        │         │ - Level Ability  │               │
│        │         └────────┬─────────┘               │
│        │                  │                         │
│        ▼                  ▼                         │
│   ┌─────────────────────────────┐                  │
│   │ Call API /auth/login        │ (or /register)  │
│   └────┬────────────────────────┘                  │
│        │                                            │
│        ▼                                            │
│   ◇──────────────────────◇                         │
│   │ Success?             │                         │
│   ◇─────┬────────┬───────◇                         │
│         │        │                                 │
│     YES │        │ NO                              │
│         │        │                                 │
│         ▼        ▼                                 │
│    ┌────────┐ ┌──────────────┐                    │
│    │ Save   │ │ Show Error   │                    │
│    │ Token  │ │ Message      │                    │
│    └───┬────┘ └──────┬───────┘                    │
│        │             │                            │
│        │        ┌────▼────┐                       │
│        │        │ Retry?  │                       │
│        │        └────┬────┘                       │
│        │             │                            │
│        │        ┌────▼──────────┐                 │
│        │        │ Back to Login  │                 │
│        │        └────┬──────────┘                 │
│        │             │                            │
│        │        ┌────▼────────────┐              │
│        │        │ Retry Login     │              │
│        │        └────┬────────────┘              │
│        │             └──────────────┐             │
│        ▼                            ▼             │
│   ┌────────────────────┐     ┌─────────────┐     │
│   │ Redirect to Home   │     │ Back to     │     │
│   │ (Event List)       │─────► Login       │     │
│   └─────────┬──────────┘     └─────────────┘     │
│             │                                     │
│             ▼                                     │
│        ┌────────────┐                            │
│        │ END        │                            │
│        └────────────┘                            │
│                                                  │
└──────────────────────────────────────────────────┘
```

### 6.2 Activity Diagram - Browse & Join Event

```
┌────────────────────────────────────────────────────────────┐
│           BROWSE & JOIN EVENT FLOW                         │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  ┌─────────────┐                                          │
│  │ START       │                                          │
│  └──────┬──────┘                                          │
│         │                                                 │
│         ▼                                                 │
│  ┌──────────────────────┐                                │
│  │ Load Event List      │                                │
│  │ (Default: All)       │                                │
│  └──────┬───────────────┘                                │
│         │                                                │
│         ▼                                                │
│  ┌──────────────────────┐                                │
│  │ Display Events Cards │                                │
│  │ - Name, Sport, Dist  │                                │
│  │ - Level, Slots Left  │                                │
│  └──────┬───────────────┘                                │
│         │                                                │
│         ▼                                                │
│  ◇──────────────────────────────────◇                   │
│  │ User Action?                     │                   │
│  ◇────┬────┬──────────┬────────┬────◇                   │
│       │    │          │        │                        │
│  FILTER│SCROLL│TAP CARD│ etc.  │                        │
│       │    │          │        │                        │
│       ▼    ▼          ▼        ▼                        │
│   ┌──────────┐  ┌──────────┐ ┌──────────┐            │
│   │ Apply    │  │ Load More│ │ Open     │            │
│   │ Filter   │  │ Events   │ │ Detail   │            │
│   │ Sport/   │  │ (Scroll) │ │ Page     │            │
│   │ Level    │  └────┬─────┘ └────┬─────┘            │
│   └────┬─────┘       │             │                  │
│        │             │             ▼                  │
│        │             ▼        ┌──────────────┐       │
│        │        ┌──────────┐  │ Show Event   │       │
│        │        │ Display  │  │ - Full Info  │       │
│        │        │ Filtered │  │ - Joined     │       │
│        │        │ Events   │  │ - Ratings    │       │
│        │        └────┬─────┘  └─────┬────────┘       │
│        └─────────┬──────────────────┘                │
│                  │                                    │
│                  ▼                                    │
│        ┌──────────────────────┐                     │
│        │ User Tap Join Button │                     │
│        └────┬─────────────────┘                     │
│             │                                        │
│             ▼                                        │
│        ◇──────────────────────◇                     │
│        │ Confirm Join?        │                     │
│        ◇────┬─────────┬────────◇                     │
│             │         │                              │
│           YES│        │NO                            │
│             │         │                              │
│             ▼         ▼                              │
│        ┌────────┐  ┌──────────────┐                │
│        │ Call   │  │ Back to List │                │
│        │ API    │  │ or Detail    │                │
│        │ Join   │  └──────────────┘                │
│        └───┬────┘                                  │
│            │                                        │
│            ▼                                        │
│        ◇──────────────────────◇                    │
│        │ Success?             │                    │
│        ◇────┬─────────┬────────◇                    │
│             │         │                             │
│           YES│        │NO                           │
│             │         │                             │
│             ▼         ▼                             │
│        ┌────────┐  ┌──────────────┐               │
│        │ Update │  │ Show Error   │               │
│        │ Event  │  │ Msg & Retry  │               │
│        │ Joined │  └──────┬───────┘               │
│        └───┬────┘         │                       │
│            │              │                       │
│            ▼              │                       │
│        ┌─────────────────┐│                       │
│        │ Show WhatsApp   ││                       │
│        │ Admin Button    ││                       │
│        │ & Redirect      ││                       │
│        └────┬────────────┘│                       │
│             │             │                       │
│        ┌────▼─────────────┘                       │
│        │                                          │
│        ▼                                          │
│   ┌───────────────┐                              │
│   │ END           │                              │
│   └───────────────┘                              │
│                                                  │
└──────────────────────────────────────────────────┘
```


## VII. RANCANGAN ENTITY RELATIONSHIP DIAGRAM (ERD)

### 7.1 ERD Aplikasi GERAK

```
┌─────────────────────────┐                    ┌──────────────────────┐
│   USERS                 │                    │   EVENTS             │
├─────────────────────────┤                    ├──────────────────────┤
│ id (PK)                 │                    │ id (PK)              │
│ email (Unique)          │                    │ name                 │
│ password (Hashed)       │                    │ description          │
│ name                    │                    │ sport                │
│ phone                   │ 1      M           │ level                │
│ photo_url               │◄─────────────────► │ start_time           │
│ sports[]                │  joined_users      │ end_time             │
│ level                   │                    │ location             │
│ latitude                │                    │ latitude             │
│ longitude               │                    │ longitude            │
│ created_at              │                    │ total_slots          │
│ updated_at              │                    │ max_slots            │
└─────────────────────────┘                    │ admin_phone          │
          ▲                                     │ image_url            │
          │                                     │ created_at           │
          │ 1          M                       └────────┬─────────────┘
          │◄───────────────┐                          │
          │   user_id      │                          │ 1        M
          │                │                          │◄────────────────┐
          │                │                          │   event_id      │
┌─────────────────────────┐ │        ┌──────────────────────┐         │
│   RATINGS               │ │        │   EVENT_PARTICIPANTS │         │
├─────────────────────────┤ │        ├──────────────────────┤         │
│ id (PK)                 │ │        │ id (PK)              │         │
│ event_id (FK)───────────┼─┘        │ event_id (FK)────────┼─────────┘
│ user_id (FK)────────────┼──────────│ user_id (FK)         │
│ score (1-5)             │          │ joined_date          │
│ review                  │          │ status               │
│ created_at              │          │ confirmed_date       │
└─────────────────────────┘          └──────────────────────┘

Relasi:
- 1 USERS ke M EVENTS (sebagai participant yang join)
- 1 EVENTS ke M RATINGS (event punya banyak rating dari pengguna)
- 1 USERS ke M RATINGS (user bisa beri rating ke banyak event)
```


## VIII. STRUKTUR TABEL BASIS DATA

### 8.1 Tabel Users

| Nama Kolom | Tipe Data | Panjang | Keterangan |
|---|---|---|---|
| id | ObjectId | - | Primary Key (MongoDB) |
| email | String | 100 | Unique, email user |
| password | String | 255 | Hashed password (bcrypt) |
| name | String | 100 | Nama lengkap user |
| phone | String | 20 | Nomor telepon |
| photo_url | String | 255 | URL foto profil (optional) |
| sports | Array | - | Array olahraga favorit, contoh: ['futsal', 'badminton'] |
| level | String | 50 | Level kemampuan: 'beginner', 'intermediate', 'advanced' |
| latitude | Double | - | Koordinat latitude (optional) |
| longitude | Double | - | Koordinat longitude (optional) |
| created_at | Date | - | Timestamp pembuatan akun |
| updated_at | Date | - | Timestamp update terakhir |

### 8.2 Tabel Events

| Nama Kolom | Tipe Data | Panjang | Keterangan |
|---|---|---|---|
| id | ObjectId | - | Primary Key (MongoDB) |
| name | String | 255 | Nama event |
| description | String | 500 | Deskripsi event (optional) |
| sport | String | 50 | Jenis olahraga: futsal, badminton, basketball, tennis, volleyball |
| level | String | 50 | Level: beginner, intermediate, advanced, mixed |
| start_time | Date | - | Waktu mulai event |
| end_time | Date | - | Waktu selesai event |
| location | String | 255 | Alamat lengkap lokasi event |
| city | String | 100 | Kota/kab untuk filter regional (contoh: Bandung, Jakarta) |
| district | String | 100 | Kecamatan/district untuk filter lebih spesifik (optional) |
| total_slots | Integer | - | Total slot pemain yang tersedia |
| joined_users | Array | - | Array User ID yang sudah join |
| max_slots | Integer | - | Maksimal slot (sama dengan total_slots) |
| admin_phone | String | 20 | Nomor WhatsApp admin/penyelenggara |
| image_url | String | 255 | URL foto event (optional) |
| average_rating | Double | - | Rata-rata rating (auto-calculated) |
| review_count | Integer | - | Jumlah review |
| created_at | Date | - | Timestamp pembuatan event |
| updated_at | Date | - | Timestamp update terakhir |

### 8.3 Tabel Ratings

| Nama Kolom | Tipe Data | Panjang | Keterangan |
|---|---|---|---|
| id | ObjectId | - | Primary Key (MongoDB) |
| event_id | ObjectId | - | Foreign Key ke Events |
| user_id | ObjectId | - | Foreign Key ke Users |
| score | Integer | - | Rating 1-5 stars |
| review | String | 500 | Teks review (optional) |
| created_at | Date | - | Timestamp pembuatan rating |

### 8.4 Tabel Event Participants (Optional - jika ingin track status join)

| Nama Kolom | Tipe Data | Panjang | Keterangan |
|---|---|---|---|
| id | ObjectId | - | Primary Key (MongoDB) |
| event_id | ObjectId | - | Foreign Key ke Events |
| user_id | ObjectId | - | Foreign Key ke Users |
| joined_date | Date | - | Tanggal user join event |
| status | String | 50 | Status: 'joined', 'confirmed', 'cancelled' |
| confirmed_date | Date | - | Tanggal konfirmasi hadir |


## IX. API ENDPOINTS SPECIFICATION

### 9.1 Authentication Endpoints

| Method | Endpoint | Parameters | Response | Status |
|---|---|---|---|---|
| POST | `/auth/register` | email, password, name, phone, sports[], level | `{ user: {...}, token: "..." }` | 201 |
| POST | `/auth/login` | email, password | `{ user: {...}, token: "..." }` | 200 |
| POST | `/auth/logout` | - | `{ message: "Logout successful" }` | 200 |
| GET | `/auth/me` | Header: Authorization | `{ user: {...} }` | 200 |
| POST | `/auth/refresh-token` | Header: Authorization | `{ token: "..." }` | 200 |

### 9.2 Events Endpoints

| Method | Endpoint | Parameters | Response | Status |
|---|---|---|---|---|
| GET | `/events` | query: sport, level, city, district, page, limit | `{ events: [...], total: 10, page: 1 }` | 200 |
| GET | `/events/:id` | - | `{ event: {...} }` | 200 |
| POST | `/events` | name, description, sport, level, startTime, endTime, location, city, district, maxSlots, adminPhone | `{ event: {...} }` | 201 |
| PUT | `/events/:id` | (update fields) | `{ event: {...} }` | 200 |
| DELETE | `/events/:id` | - | `{ message: "Event deleted" }` | 200 |
| POST | `/events/:id/join` | - | `{ message: "Join successful", event: {...} }` | 200 |
| POST | `/events/:id/leave` | - | `{ message: "Leave successful", event: {...} }` | 200 |
| GET | `/events/:id/participants` | - | `{ participants: [...] }` | 200 |

### 9.3 Ratings Endpoints

| Method | Endpoint | Parameters | Response | Status |
|---|---|---|---|---|
| POST | `/ratings` | eventId, score, review | `{ rating: {...} }` | 201 |
| GET | `/ratings/event/:eventId` | page, limit | `{ ratings: [...], total: 5 }` | 200 |
| GET | `/ratings/user/:userId` | - | `{ ratings: [...] }` | 200 |
| PUT | `/ratings/:id` | score, review | `{ rating: {...} }` | 200 |
| DELETE | `/ratings/:id` | - | `{ message: "Rating deleted" }` | 200 |



## X. RANCANGAN PENGUJIAN (TESTING STRATEGY)

### 10.1 Tipe Pengujian yang Dilakukan

**a. Unit Testing**
- Test setiap controller/business logic function
- Mock HTTP responses dan database calls
- Target: 70% code coverage minimal

**b. Widget Testing**
- Test UI components (button, input, card)
- Test navigation antar screen
- Test form input validation

**c. Integration Testing**
- End-to-end flow: Login → Browse Events → Join → Rate
- API integration dengan backend (mock atau actual)
- GPS & geofencing functionality

**d. Manual Testing (Minggu 6)**
- Test di device Android (API 21+) dan iOS (11.0+)
- Test dengan koneksi 3G
- Test dengan GPS off/on
- User acceptance testing

### 10.2 Kuisioner Pengujian (User Acceptance Test)

**Kriteria Penilaian:**
- STS (Sangat Tidak Setuju) = 1 Poin
- TS (Tidak Setuju) = 2 Poin
- N (Netral) = 3 Poin
- S (Setuju) = 4 Poin
- SS (Sangat Setuju) = 5 Poin

**Tabel Kuisioner:**

| No | Keterangan | STS | TS | N | S | SS |
|---|---|---|---|---|---|---|
| 1 | Aplikasi mudah digunakan untuk mencari event olahraga | ☐ | ☐ | ☐ | ☐ | ☐ |
| 2 | Filter event berdasarkan olahraga dan level kemampuan berfungsi dengan baik | ☐ | ☐ | ☐ | ☐ | ☐ |
| 3 | Fitur geofencing (radius lokasi) membantu menemukan event terdekat | ☐ | ☐ | ☐ | ☐ | ☐ |
| 4 | Proses join event dan redirect ke WhatsApp mudah dan cepat | ☐ | ☐ | ☐ | ☐ | ☐ |
| 5 | Rating dan review membantu memilih event berkualitas | ☐ | ☐ | ☐ | ☐ | ☐ |
| 6 | Tampilan UI/UX menarik dan intuitif | ☐ | ☐ | ☐ | ☐ | ☐ |
| 7 | Sistem login dan registrasi aman dan mudah | ☐ | ☐ | ☐ | ☐ | ☐ |
| 8 | Performa aplikasi cepat dan responsif | ☐ | ☐ | ☐ | ☐ | ☐ |
| 9 | Aplikasi stabil tanpa error atau crash | ☐ | ☐ | ☐ | ☐ | ☐ |
| 10 | Saya akan merekomendasikan aplikasi ini kepada teman untuk berolahraga | ☐ | ☐ | ☐ | ☐ | ☐ |

**Skor Interpretasi:**
- Total Skor 50-70: Perlu perbaikan significant
- Total Skor 71-85: Baik, ada minor improvements
- Total Skor 86-100: Excellent, siap production


## XI. TEKNOLOGI STACK & TOOLS

| Komponen | Technology | Alasan |
|---|---|---|
| Frontend | Flutter 3.0+ (Dart) | Cross-platform, hot reload, performa tinggi |
| Backend | Node.js + Express | Eco-system besar, async handling bagus, JavaScript |
| Database | MongoDB 4.4+ | Flexible schema, geospatial query support |
| HTTP Client | Dio | Interceptor, timeout, retry built-in |
| State Management | Provider / GetX | TBD minggu 3 (lightweight vs all-in-one) |
| Local Storage | Shared Preferences / Hive | Simpan token, user session |
| Authentication | JWT + Refresh Token | Stateless, scalable |
| Geospatial | MongoDB Geospatial Index | Native support untuk query radius |
| Version Control | Git + GitHub | Standard, easy collaboration |
| Testing | Flutter Test + Mockito | Unit & widget testing |
| API Testing | Postman | API documentation & testing |
| Database Management | MongoDB Compass | Database visualization & management |


## XII. KESIMPULAN

Aplikasi GERAK dirancang sebagai platform komunitas olahraga yang menghubungkan pencari olahraga dengan penyelenggara event secara efisien. Melalui fitur geofencing, filtering berbasis level kemampuan, dan integrasi WhatsApp, GERAK memberikan solusi praktis untuk masalah rekrutmen pemain dan discovery event olahraga lokal.

Dokumen SDD ini menjadi blueprint teknis untuk implementasi selama 7 minggu oleh tim 3 orang. Dengan arsitektur yang jelas, technology stack yang tepat, dan rencana testing yang komprehensif, diharapkan aplikasi dapat mencapai tahap production-ready dan sustainable untuk jangka panjang.

Kesuksesan implementasi bergantung pada:
1. Koordinasi tim yang baik dan consistent communication
2. Adherence terhadap timeline dan sprint targets
3. Quality assurance yang ketat di minggu 6
4. Feedback loop dari stakeholder/dosen di setiap review


## XIII. DAFTAR PUSTAKA

Fadholi, M.L., 2018. Sistem Online Untuk Dokumen Perancangan Perangkat Lunak Bagi Perusahaan Atau Tim Pengembang, Yogyakarta.

Google Flutter Documentation, 2024. Flutter Official Documentation - https://flutter.dev/docs

MongoDB Inc., 2024. MongoDB Manual - Geospatial Indexes. Diakses dari https://docs.mongodb.com/manual/geospatial-queries/

Express.js Official Documentation, 2024. Building APIs with Express - https://expressjs.com

Node.js Official Documentation, 2024. Node.js Guide - https://nodejs.org/en/docs/

IEEE Std 1016-2009, Software Design Specifications Standard.

Sommerville, I., 2011. Software Engineering (9th ed.). Addison-Wesley.

Pressman, R. S., & Maxim, B. R., 2014. Software Engineering: A Practitioner's Approach (8th ed.). McGraw-Hill.



Tentu, ini versi `.md` yang bersih dan siap kamu *copy-paste* ke dalam proyekmu. Format ini sudah disesuaikan dengan standar dokumentasi profesional.

```markdown
# Asset Management Backend (Rewrite Version)

Sistem Backend Manajemen Aset Perusahaan yang dirancang untuk stabilitas, akurasi perhitungan finansial (depresiasi), dan integritas data (audit trail). Dibangun dengan pendekatan manual coding untuk memastikan kontrol penuh atas logika bisnis dan arsitektur sistem.

## 🚀 Tech Stack
*   **Framework:** Ruby on Rails (API Only)
*   **Database:** PostgreSQL
*   **Containerization:** Docker & Docker Compose

## 🛠 Features
- **Asset Lifecycle Management:** Tracking dari akuisisi hingga disposal.
- **Automated QR Code Generation:** Identitas unik untuk setiap aset fisik via `asset_code`.
- **Financial Depreciation:** Perhitungan nilai buku (book value) menggunakan metode *Straight-Line*.
- **Ownership & Location Tracking:** Riwayat perpindahan aset antar user dan lokasi secara real-time.
- **Enterprise Audit Trail:** Log aktivitas mendetail untuk setiap perubahan data aset (action, location, dan user logs).

## 🏗 Database Schema (ERD Overview)
Sistem menggunakan relasi yang ketat untuk menjaga integritas data:
*   **Users**: Manajemen penanggung jawab aset.
*   **Locations**: Master data lokasi fisik atau departemen.
*   **Assets**: Core data mencakup informasi finansial (`acquisition_cost`, `salvage_value`, `useful_value`) dan tracking (`current_holder_id`, `location_id`).
*   **AssetLogs**: Tabel audit trail untuk mencatat sejarah perpindahan dan perubahan status aset.

## 🐳 Getting Started with Docker

1.  **Clone the repository**
    ```bash
    git clone [https://github.com/username/asset-mgmt-backend.git](https://github.com/username/asset-mgmt-backend.git)
    cd asset-mgmt-backend
    ```

2.  **Build and Run Docker Compose**
    ```bash
    docker-compose build
    docker-compose up
    ```

3.  **Access the Application**
    ```bash
    http://localhost:3000
    ```

4.  **Run Tests**
    ```bash
    docker-compose exec app bundle exec rspec
    ```

5.  **Stop and Remove Docker Compose**
    ```bash
    docker-compose down
    ```

# Bill Status Workflow

## Status Enum

```dart
enum BillStatus {
  unpaid,    // Belum Dibayar
  pending,   // Menunggu Verifikasi
  paid,      // Lunas
  overdue,   // Terlambat
  rejected   // Ditolak
}
```

## Workflow

### 1. **UNPAID** (Belum Dibayar)
- Status awal ketika tagihan dibuat
- Warga belum melakukan pembayaran
- Belum ada bukti pembayaran
- **Tidak ada tombol verifikasi** untuk admin

### 2. **PENDING** (Menunggu Verifikasi)
- Warga sudah upload bukti pembayaran
- Menunggu admin untuk approve/reject
- **Tombol Setujui/Tolak muncul** untuk admin
- Admin bisa lihat bukti pembayaran

### 3. **PAID** (Lunas)
- Admin approve pembayaran
- Dibayar **tepat waktu** (sebelum atau pada periode tagihan)
- Status final ✅

### 4. **OVERDUE** (Terlambat)
- Admin approve pembayaran
- Dibayar **lewat periode** tagihan
- Status final ✅

### 5. **REJECTED** (Ditolak)
- Admin reject pembayaran
- Warga harus upload ulang bukti pembayaran yang benar
- Bisa kembali ke status PENDING setelah upload ulang

## Logic Flow

```
                    ┌─────────────┐
                    │   UNPAID    │
                    │ (Belum Bayar)│
                    └──────┬──────┘
                           │
              Warga upload │ bukti bayar
                           │
                    ┌──────▼──────┐
                    │   PENDING   │
                    │(Tunggu Admin)│
                    └──────┬──────┘
                           │
            ┌──────────────┼──────────────┐
            │                             │
    Admin   │ Approve              Admin  │ Reject
    Cek     │                      Cek    │
    Tanggal │                      Bukti  │
            │                             │
    ┌───────▼────────┐           ┌───────▼────────┐
    │ Tepat Waktu?   │           │   REJECTED     │
    └───────┬────────┘           │   (Ditolak)    │
            │                    └────────────────┘
    ┌───────┼────────┐
    │                │
    │ Ya             │ Tidak
    │                │
┌───▼───┐       ┌────▼────┐
│ PAID  │       │OVERDUE  │
│(Lunas)│       │(Terlambat)│
└───────┘       └─────────┘
```

## UI Behavior

### Bill Detail Screen

1. **Status UNPAID**: 
   - Tidak ada section Informasi Pembayaran
   - Tidak ada tombol Setujui/Tolak

2. **Status PENDING**:
   - Tampil section Informasi Pembayaran
   - Tampil bukti pembayaran
   - **Tampil tombol Setujui & Tolak**
   - Admin bisa input catatan

3. **Status PAID/OVERDUE/REJECTED**:
   - Tampil section Informasi Pembayaran
   - Tampil informasi verifikasi
   - Tidak ada tombol Setujui/Tolak

## Color Scheme

- **UNPAID**: Grey (Status netral)
- **PENDING**: Orange (Butuh perhatian admin)
- **PAID**: Green (Success)
- **OVERDUE**: Red (Warning)
- **REJECTED**: Dark Red (Error)

## API Endpoints

- `PATCH /bills/{id}/verify-payment` - Approve/reject pembayaran
- `PATCH /bills/{id}/mark-paid` - Manual mark as paid
- `POST /bills/mark-overdue` - Batch mark overdue bills

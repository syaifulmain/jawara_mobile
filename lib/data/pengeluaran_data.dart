import '../models/data_pengeluaran_model.dart';

final List<DataPengeluaranModel> DummyDataPengeluaran = [
  DataPengeluaranModel(
    nama: 'Pembelian Alat Kebersihan',
    kategoriPengeluaran: 'Kebersihan',
    tanggal: '15-10-2025',
    nominal: 'Rp. 2.500.000',
    tanggalVerifikasi: '15-10-2025',
    verifikator: 'Admin A',
  ),
  DataPengeluaranModel(
    nama: 'Biaya Listrik Bulan Oktober',
    kategoriPengeluaran: 'Operasional',
    tanggal: '20-10-2025',
    nominal: 'Rp. 1.200.000',
    tanggalVerifikasi: '21-10-2025',
    verifikator: 'Admin B',
  ),
  DataPengeluaranModel(
    nama: 'Perbaikan Gerbang Utama',
    kategoriPengeluaran: 'Pemeliharaan',
    tanggal: '25-10-2025',
    nominal: 'Rp. 3.000.000',
    tanggalVerifikasi: '26-10-2025',
    verifikator: 'Admin C',
  ),
];
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// import 'package:jawara_mobile/screens/admin/data_warga/warga_tambah.dart';
import 'package:jawara_mobile/screens/admin/data_warga/keluarga.dart';
import 'package:jawara_mobile/screens/admin/data_warga/rumah_daftar.dart';
import 'package:jawara_mobile/screens/admin/data_warga/rumah_tambah.dart';
import 'package:jawara_mobile/screens/admin/data_warga/detail_rumah.dart';
import 'package:jawara_mobile/screens/admin/data_warga/detail_keluarga.dart';
import 'package:jawara_mobile/screens/admin/broadcast/daftar.dart';
import 'package:jawara_mobile/screens/admin/broadcast/tambah.dart';
import 'package:jawara_mobile/screens/admin/dashboard/keuangan.dart';
import 'package:jawara_mobile/screens/admin/dashboard/kegiatan.dart';
import 'package:jawara_mobile/screens/admin/dashboard/kependudukan.dart';
import 'package:jawara_mobile/screens/admin/kegiatan/daftar.dart';
import 'package:jawara_mobile/screens/admin/kegiatan/tambah.dart';
import 'package:jawara_mobile/screens/admin/kegiatan/detail.dart';
import 'package:jawara_mobile/screens/admin/laporan_keuangan/cetak_laporan.dart';
import 'package:jawara_mobile/screens/admin/laporan_keuangan/detail_laporan_keuangan.dart';
import 'package:jawara_mobile/screens/admin/laporan_keuangan/semua_pemasukan.dart';
import 'package:jawara_mobile/screens/admin/laporan_keuangan/semua_pengeluaran.dart';
import 'package:jawara_mobile/screens/admin/layout.dart';
import 'package:jawara_mobile/screens/admin/pemasukan/daftar.dart';
import 'package:jawara_mobile/screens/admin/pemasukan/tambah.dart';
import 'package:jawara_mobile/screens/admin/pemasukan/detail.dart';
import 'package:jawara_mobile/screens/admin/pengeluaran/daftar.dart';
import 'package:jawara_mobile/screens/admin/pengeluaran/tambah.dart';
import 'package:jawara_mobile/screens/admin/warga/daftar.dart';
import 'package:jawara_mobile/screens/admin/warga/detail.dart';
import 'package:jawara_mobile/screens/admin/warga/tambah.dart';
import 'package:jawara_mobile/screens/auth/login.dart';
import 'package:jawara_mobile/screens/auth/register.dart';
import 'package:jawara_mobile/screens/placeholder.dart';

import 'models/data_warga_model.dart';
import 'models/data_pemasukan_model.dart';
import 'models/data_kegiatan_model.dart';

// A map to associate route paths with their titles.
const Map<String, String> _routeTitles = {
  '/admin': 'Dashboard Keuangan',
  '/dashboard/keuangan': 'Dashboard Keuangan',
  '/dashboard/kependudukan': 'Dashboard Kependudukan',
  '/dashboard/kegiatan': 'Dashboard Kegiatan',
  '/kegiatan/daftar': 'Daftar Kegiatan',
  '/kegiatan/tambah': 'Tambah Kegiatan',
  '/broadcast/daftar': 'Daftar Broadcast',
  '/broadcast/tambah': 'Tambah Broadcast',
  '/laporan_keuangan/cetak_laporan': 'Cetak Laporan Keuangan',
  '/laporan_keuangan/semua_pemasukan': 'Laporan Semua Pemasukan',
  '/laporan_keuangan/semua_pengeluaran': 'Laporan Semua Pengeluaran',
  '/laporan_keuangan/detail_laporan_keuangan': 'Detail Data Laporan Keuangan',
  '/pemasukan/daftar': 'Daftar Pemasukan',
  '/pemasukan/tambah': 'Tambah Pemasukan',
  '/pemasukan/detail': 'Detail Pemasukan',
  '/pengeluaran/daftar': 'Daftar Pengeluaran',
  '/pengeluaran/tambah': 'Tambah Pengeluaran',
  '/rumah/detail': 'Detail Rumah',
  '/keluarga/detail': 'Detail Keluarga',
  '/keluarga': 'Data Keluarga',
  '/rumah/daftar': 'Daftar Rumah',
  '/rumah/tambah': 'Tambah Rumah',
  '/warga/daftar': 'Daftar Warga',
  '/warga/tambah': 'Tambah Warga',
  '/warga/detail': 'Detail Warga',
};

final router = GoRouter(
  initialLocation: "/login",
  routes: [
    GoRoute(path: '/', redirect: (context, state) => '/login'),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => RegisterScreen(),
    ),

    // ShellRoute for the admin layout
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        // Get the current route path and look up its title.
        final String path = state.uri.toString();
        final String title =
            _routeTitles[path] ?? 'Jawara Pintar'; // Default title
        return AdminLayoutScreen(title: title, child: child);
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/admin',
          name: 'admin',
          builder: (BuildContext context, GoRouterState state) {
            // Ganti PlaceholderScreen dengan halaman utama dashboard kamu
            return const KeuanganScreen(); // ✅ tampilkan dashboard keuangan
          },
        ),
        GoRoute(
          path: '/dashboard/keuangan',
          name: 'dashboard-keuangan',
          builder: (BuildContext context, GoRouterState state) {
            return const KeuanganScreen();
          },
        ),
        GoRoute(
          path: '/dashboard/kependudukan',
          name: 'dashboard-kependudukan',
          builder: (BuildContext context, GoRouterState state) {
            return const DashboardKependudukan();
          },
        ),
        GoRoute(
          path: '/dashboard/kegiatan',
          name: 'dashboard-kegiatan',
          builder: (BuildContext context, GoRouterState state) {
            return const Kegiatan();
          },
        ),
        GoRoute(
          path: '/kegiatan/daftar',
          name: 'kegiatan-daftar',
          builder: (context, state) => const KegiatanDaftarScreen(),
        ),
        GoRoute(
          path: '/kegiatan/tambah',
          name: 'kegiatan-tambah',
          builder: (context, state) => const KegiatanTambahScreen(),
        ),
        GoRoute(
          path: '/kegiatan/detail',
          name: 'kegiatan-detail',
          builder: (context, state) =>
              KegiatanDetailScreen(dataKegiatan: state.extra as DataKegiatanModel),
        ),
        GoRoute(
          path: '/broadcast/daftar',
          name: 'broadcast-daftar',
          builder: (context, state) => const BroadcastDaftarScreen(),
        ),
        GoRoute(
          path: '/broadcast/tambah',
          name: 'broadcast-tambah',
          builder: (context, state) => const BroadcastTambahScreen(),
        ),
        GoRoute(
          path: '/placeholder',
          name: 'placeholder',
          builder: (context, state) => const PlaceholderScreen(),
        ),
        GoRoute(
          path: '/laporan_keuangan/cetak_laporan',
          name: 'laporan_keuangan-cetak_laporan',
          builder: (context, state) => CetakLaporan(),
        ),
        GoRoute(
          path: '/laporan_keuangan/detail_laporan_keuangan',
          name: 'laporan_keuangan-detail_laporan_keuanga',
          builder: (context, state) {
            final laporan =
                state.extra
                    as Map<String, dynamic>?;
            return DetailLaporanKeuangan(laporan: laporan ?? {});
          },
        ),
        GoRoute(
          path: '/laporan_keuangan/semua_pemasukan',
          name: 'laporan_keuangan-semua_pemasukan',
          builder: (context, state) => SemuaPemasukan(),
        ),
        GoRoute(
          path: '/laporan_keuangan/semua_pengeluaran',
          name: 'laporan_keuangan-semua_pengeluaran',
          builder: (context, state) => SemuaPengeluaran(),
        ),
        GoRoute(
          path: '/pemasukan/daftar',
          name: 'pemasukan-daftar',
          builder: (context, state) => const DaftarPemasukanScreen(),
        ),
        GoRoute(
          path: '/pemasukan/tambah',
          name: 'pemasukan-tambah',
          builder: (context, state) => TambahPemasukanScreen(),
        ),
        GoRoute(
          path: '/pemasukan/detail',
          name: 'pemasukan-detail',
          builder: (context, state) =>
              PemasukanDetailScreen(dataPemasukan: state.extra as DataPemasukanModel),
        ),
        GoRoute(
          path: '/pengeluaran/daftar',
          name: 'pengeluaran-daftar',
          builder: (context, state) => const DaftarPengeluaranScreen(),
        ),
        GoRoute(
          path: '/pengeluaran/tambah',
          name: 'pengeluaran-tambah',
          builder: (context, state) => TambahPengeluaranScreen(),
        ),
        //GoRoute(
        //  path: '/warga/tambah',
        //  name: 'warga-tambah',
        //  builder: (context, state) => const WargaTambahScreen(),
        //),
        GoRoute(
          path: '/rumah/detail',
          name: 'rumah-detail',
          builder: (context, state) => const DetailRumahScreen(),
        ),
        GoRoute(
          path: '/keluarga/detail',
          name: 'keluarga-detail',
          builder: (context, state) => const DetailKeluargaScreen(),
        ),
        GoRoute(
          path: '/keluarga',
          name: 'keluarga',
          builder: (context, state) => const KeluargaScreen(),
        ),
        GoRoute(
          path: '/rumah/daftar',
          name: 'rumah-daftar',
          builder: (context, state) => const RumahDaftarScreen(),
        ),
        GoRoute(
          path: '/rumah/tambah',
          name: 'rumah-tambah',
          builder: (context, state) => const RumahTambahScreen(),
        ),
        GoRoute(
          path: '/warga/daftar',
          name: 'warga-daftar',
          builder: (context, state) => const WargaDaftarScreen(),
        ),
        GoRoute(
          path: '/warga/tambah',
          name: 'warga-tambah',
          builder: (context, state) => const WargaTambahScreen(),
        ),
        GoRoute(
          path: '/warga/detail',
          name: 'warga-detail',
          builder: (context, state) =>
              WargaDetailScreen(dataWarga: state.extra as DataWargaModel),
        ),
      ],
    ),
  ],
);

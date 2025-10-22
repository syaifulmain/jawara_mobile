import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_mobile/screens/admin/data_warga/warga_tambah.dart';
import 'package:jawara_mobile/screens/admin/data_warga/keluarga.dart';
import 'package:jawara_mobile/screens/admin/data_warga/rumah_daftar.dart';
import 'package:jawara_mobile/screens/admin/data_warga/rumah_tambah.dart';
import 'package:jawara_mobile/screens/admin/data_warga/detail_rumah.dart';
import 'package:jawara_mobile/screens/admin/data_warga/detail_keluarga.dart';
import 'package:jawara_mobile/screens/admin/broadcast/daftar.dart';
import 'package:jawara_mobile/screens/admin/broadcast/tambah.dart';
import 'package:jawara_mobile/screens/admin/dashboard/kegiatan.dart';
import 'package:jawara_mobile/screens/admin/dashboard/kependudukan.dart';
import 'package:jawara_mobile/screens/admin/kegiatan/daftar.dart';
import 'package:jawara_mobile/screens/admin/kegiatan/tambah.dart';
import 'package:jawara_mobile/screens/admin/laporan_keuangan/cetak_laporan.dart';
import 'package:jawara_mobile/screens/admin/laporan_keuangan/semua_pemasukan.dart';
import 'package:jawara_mobile/screens/admin/laporan_keuangan/semua_pengeluaran.dart';
import 'package:jawara_mobile/screens/admin/layout.dart';
import 'package:jawara_mobile/screens/admin/pengeluaran/daftar.dart';
import 'package:jawara_mobile/screens/admin/pengeluaran/tambah.dart';
import 'package:jawara_mobile/screens/auth/login.dart';
import 'package:jawara_mobile/screens/auth/register.dart';
import 'package:jawara_mobile/screens/placeholder.dart';

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
        return AdminLayoutScreen(child: child);
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/admin',
          name: 'admin',
          // For the default admin page, you can show a placeholder or a default dashboard
          builder: (BuildContext context, GoRouterState state) {
            return const PlaceholderScreen(); // Or your default dashboard widget
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
          path: '/pengeluaran/daftar',
          name: 'pengeluaran-daftar',
          builder: (context, state) => const DaftarPengeluaranScreen(),
        ),
        GoRoute(
          path: '/pengeluaran/tambah',
          name: 'pengeluaran-tambah',
          builder: (context, state) => TambahPengeluaranScreen(),
        ),
        GoRoute(
          path: '/warga/tambah',
          name: 'warga-tambah',
          builder: (context, state) => const WargaTambahScreen(),
        ),
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
      ],
    ),
  ],
);

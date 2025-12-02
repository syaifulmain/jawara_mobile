import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../constants/color_constant.dart';
import '../constants/rem_constant.dart';
import '../providers/auth_provider.dart';
import '../widgets/menu_list_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(Rem.rem0_625),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.menu_book_rounded,
                color: Colors.white,
                size: Rem.rem1_25,
              ),
            ),
            const SizedBox(width: Rem.rem0_5),
            Text(
              "Jawara Pintar",
              style: GoogleFonts.poppins(
                fontSize: Rem.rem1_5,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ],
        ),
        // title: const Text('Home'),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.logout),
        //     onPressed: () async {
        //       await authProvider.logout();
        //       if (context.mounted) {
        //         context.goNamed('login');
        //       }
        //     },
        //   ),
        // ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. BAGIAN ATAS: INFORMASI PENGGUNA (TETAP DI ATAS)
          Padding(
            padding: const EdgeInsets.all(Rem.rem1),
            child: Card(
              color: Theme.of(context).primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(Rem.rem1),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: const Icon(
                        Icons.person,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selamat Datang,',
                            style: GoogleFonts.poppins(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.name,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            user.email,
                            style: GoogleFonts.poppins(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 2. BAGIAN BAWAH: MENU (DAPAT DI-SCROLL)
          // Expanded membuat SingleChildScrollView mengisi sisa ruang yang tersedia.
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: Rem.rem1),
              child: Column(
                children: [
                  // Menu non user
                  if (!user.isUser) ...[
                    // Dashboard
                    MenuListTile(
                      icon: Icons.analytics,
                      title: 'Dashboard',
                      subtitle: 'Lihat ringkasan data',
                      color: Colors.teal,
                      onTap: () => context.pushNamed('dashboard_menu'),
                    ),
                    const SizedBox(height: 12),

                    // Data Warga dan Rumah
                    MenuListTile(
                      icon: Icons.home,
                      title: 'Data Warga dan Rumah',
                      subtitle: 'Kelola data warga dan rumah',
                      color: Colors.blue,
                      onTap: () =>
                          context.pushNamed('residents_and_houses_menu'),
                    ),
                    const SizedBox(height: 12),

                    // Pemasukan
                    MenuListTile(
                      icon: Icons.attach_money,
                      title: 'Pemasukan',
                      subtitle: 'Kelola data pemasukan',
                      color: Colors.green,
                      onTap: () => context.pushNamed('income_menu'),
                    ),
                    const SizedBox(height: 12),

                    // Pengeluaran
                    MenuListTile(
                      icon: Icons.money_off,
                      title: 'Pengeluaran',
                      subtitle: 'Kelola data pengeluaran',
                      color: Colors.purple,
                      onTap: () => context.pushNamed('expenditure_menu'),
                    ),
                    const SizedBox(height: 12),

                    // Laporan Keuangan
                    MenuListTile(
                      icon: Icons.report,
                      title: 'Laporan Keuangan',
                      subtitle: 'Lihat laporan keuangan',
                      color: Colors.brown,
                      onTap: () => context.pushNamed('financial_reports_menu'),
                    ),
                    const SizedBox(height: 12),

                    // Kegiatan dan broadcast
                    MenuListTile(
                      icon: Icons.event,
                      title: 'Kegiatan dan Broadcast',
                      subtitle: 'Kelola kegiatan dan broadcast',
                      color: Colors.red,
                      onTap: () =>
                          context.pushNamed('activities_and_broadcast_menu'),
                    ),
                    const SizedBox(height: 12),

                    if (user.canAccessActivity) ...[
                      // Pesan Warga
                      MenuListTile(
                        icon: Icons.message,
                        title: 'Pesan Warga',
                        subtitle: 'Kelola pesan dari warga',
                        color: Colors.indigo,
                        onTap: () => context.pushNamed('citizen_messages_menu'),
                        disabled: true,
                      ),
                      const SizedBox(height: 12),
                    ],

                    if (user.hasFullAccess) ...[
                      // Penerimaan Warga
                      MenuListTile(
                        icon: Icons.inbox,
                        title: 'Penerimaan Warga',
                        subtitle: 'Kelola penerimaan warga',
                        color: Colors.cyan,
                        onTap: () => context.pushNamed('citizen_receipts_menu'),
                        disabled: true,
                      ),
                      const SizedBox(height: 12),

                      // Mutasi Keluarga
                      MenuListTile(
                        icon: Icons.swap_horiz,
                        title: 'Mutasi Keluarga',
                        subtitle: 'Kelola mutasi keluarga',
                        color: Colors.tealAccent,
                        onTap: () => context.pushNamed('family_mutation_menu'),
                      ),
                      const SizedBox(height: 12),
                    ],

                    // Log Aktivitas
                    MenuListTile(
                      icon: Icons.history,
                      title: 'Log Aktivitas',
                      subtitle: 'Lihat riwayat aktivitas pengguna',
                      color: Colors.grey,
                      onTap: () => context.pushNamed('activity_log_menu'),
                      disabled: true,
                    ),
                    const SizedBox(height: 12),

                    if (user.hasFullAccess) ...[
                      // Managemen Pengguna
                      MenuListTile(
                        icon: Icons.manage_accounts,
                        title: 'Managemen Pengguna',
                        subtitle: 'Kelola data pengguna aplikasi',
                        color: Colors.orange,
                        onTap: () => context.pushNamed('user_management_menu'),
                      ),
                      const SizedBox(height: 12),
                    ],

                    // Channel Transfer
                    MenuListTile(
                      icon: Icons.account_balance,
                      title: 'Channel Transfer',
                      subtitle: 'Kelola channel transfer pembayaran',
                      color: Colors.lightGreen,
                      onTap: () => context.pushNamed('transfer_channel_menu'),
                    ),
                  ]
                  // Menu role user
                  else ...[
                    // Dashboard Warga
                    MenuListTile(
                      icon: Icons.dashboard,
                      title: 'Dashboard Warga',
                      subtitle: 'Lihat ringkasan data warga',
                      color: Colors.teal,
                      onTap: () => context.pushNamed('resident_dashboard'),
                    ),
                    const SizedBox(height: 12),

                    // Keluarga
                    MenuListTile(
                      icon: Icons.family_restroom,
                      title: 'Keluarga',
                      subtitle: 'Lihat data keluarga Anda',
                      color: Colors.blue,
                      onTap: () => context.pushNamed('family_data'),
                    ),
                    const SizedBox(height: 12),

                    // Tagihan
                    MenuListTile(
                      icon: Icons.receipt_long,
                      title: 'Tagihan',
                      subtitle: 'Lihat dan bayar tagihan Anda',
                      color: Colors.green,
                      onTap: () => context.pushNamed('bills'),
                    ),
                    const SizedBox(height: 12),

                    // Laporan Keuangan
                    MenuListTile(
                      icon: Icons.report,
                      title: 'Laporan Keuangan',
                      subtitle: 'Lihat laporan keuangan Anda',
                      color: Colors.brown,
                      onTap: () =>
                          context.pushNamed('resident_financial_reports'),
                    ),
                    const SizedBox(height: 12),

                    // Kegiatan
                    MenuListTile(
                      icon: Icons.event,
                      title: 'Kegiatan',
                      subtitle: 'Lihat kegiatan yang diikuti',
                      color: Colors.red,
                      onTap: () => context.pushNamed('resident_activities_menu'),
                    ),
                    const SizedBox(height: 12),

                    // Broadcast
                    MenuListTile(
                      icon: Icons.campaign,
                      title: 'Broadcast',
                      subtitle: 'Lihat broadcast terbaru',
                      color: Colors.orange,
                      onTap: () => context.pushNamed('resident_broadcast_menu'),
                    ),
                    const SizedBox(height: 12),

                    // Informasi Aspirasi warga
                    MenuListTile(
                      icon: Icons.feedback,
                      title: 'Aspirasi Warga',
                      subtitle: 'Kirim dan lihat aspirasi warga',
                      color: Colors.pink,
                      onTap: () => context.pushNamed('citizen_aspirations'),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // logout
                  Card(
                    child: ListTile(
                      onTap: () async {
                        await authProvider.logout();
                        if (context.mounted) {
                          context.goNamed('login');
                        }
                      },
                      title: Center(
                        child: Text(
                          'Keluar dari aplikasi',
                          style: GoogleFonts.poppins(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Tambahkan padding bawah agar tombol logout tidak terlalu mepet
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

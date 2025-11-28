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
                    const SizedBox(height: 12),
                    MenuListTile(
                      icon: Icons.analytics,
                      title: 'Dashboard',
                      subtitle: 'Lihat ringkasan data',
                      color: Colors.teal,
                      onTap: () => context.pushNamed('dashboard_menu'),
                    ),
                    const SizedBox(height: 12),
                    MenuListTile(
                      icon: Icons.event,
                      title: 'Kegiatan dan Broadcast',
                      subtitle: 'Kelola kegiatan dan broadcast',
                      color: Colors.red,
                      onTap: () => context.pushNamed('activities_and_broadcast_menu'),
                    ),
                    const SizedBox(height: 12),
                    MenuListTile(
                      icon: Icons.people,
                      title: 'Users',
                      subtitle: 'Kelola data pengguna',
                      color: Colors.green,
                      onTap: () => context.pushNamed('users'),
                    ),
                    const SizedBox(height: 12),
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
        )
    );
  }
}

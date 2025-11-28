import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/color_constant.dart';
import '../../../constants/rem_constant.dart';
import '../../../widgets/menu_list_tile.dart';

class ActivitiesAndBroadcastMenuScreen extends StatelessWidget {
  const ActivitiesAndBroadcastMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Kegiatan & Broadcast',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Rem.rem1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MenuListTile(
              icon: Icons.list_alt,
              title: 'Daftar Kegiatan',
              subtitle: 'Lihat semua kegiatan',
              color: Colors.blue,
              onTap: () => context.pushNamed('activities_list'),
            ),
            const SizedBox(height: Rem.rem1),
            MenuListTile(
              icon: Icons.add_circle,
              title: 'Tambah Kegiatan',
              subtitle: 'Buat kegiatan baru',
              color: Colors.blue,
              onTap: () => context.pushNamed('add_activity'),
            ),
            const SizedBox(height: Rem.rem1),
            MenuListTile(
              icon: Icons.campaign,
              title: 'Daftar Broadcast',
              subtitle: 'Lihat semua broadcast',
              color: Colors.orange,
              onTap: () => context.pushNamed('broadcasts_list'),
            ),
            const SizedBox(height: Rem.rem1),
            MenuListTile(
              icon: Icons.add_alert,
              title: 'Tambah Broadcast',
              subtitle: 'Buat broadcast baru',
              color: Colors.orange,
              onTap: () => context.pushNamed('add_broadcast'),
            ),
          ],
        ),
      ),
    );
  }
}

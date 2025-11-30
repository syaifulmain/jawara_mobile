// File: lib/widgets/layout/custom_sidebar.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; 
import 'package:jawara_mobile/widgets/layout/sidebar_items.dart'; 

class CustomSidebar extends StatelessWidget {
  final bool isCollapsed; 
  const CustomSidebar({super.key, this.isCollapsed = false});

  @override
  Widget build(BuildContext context) {
    const Color sidebarBg = Colors.white; 

    // Mengambil rute yang sedang aktif (GoRouter.of(context).currentLocation)
    // Menggunakan GoRouter.of(context).uri.toString() untuk kompatibilitas yang lebih baik
    final String currentRoute = GoRouter.of(context).uri.toString();
    
    // Fungsi untuk memeriksa apakah ExpansionTile seharusnya dibuka (jika salah satu sub-itemnya aktif)
    final bool isKegiatanExpanded = currentRoute.startsWith('/activities');

    return Container(
      color: sidebarBg,
      child: ListView(
        children: <Widget>[
          // Logo dan Judul Aplikasi
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isCollapsed ? 15 : 20, vertical: 30),
            child: Row(
              mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start, 
              children: [
                const Icon(Icons.bookmark, color: Color(0xFF635BFF), size: 30),
                if (!isCollapsed) ...[
                  const SizedBox(width: 8),
                  const Text(
                    'Jawara Pintar.',
                    style: TextStyle(
                      color: Colors.black87, 
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // Judul Bagian Menu ("Menu")
          if (!isCollapsed) 
            const Padding(
              padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),

          // Menu Statis
          // PENTING: Perbaiki item dashboard duplikasi
          SidebarItem(
            icon: Icons.dashboard, 
            title: 'Dashboard', 
            isActive: currentRoute == '/dashboard', // Asumsi rute dashboard
            isCollapsed: isCollapsed
          ),
          SidebarItem(icon: Icons.home, title: 'Data Warga & Rumah', isActive: false, isCollapsed: isCollapsed),
          SidebarItem(icon: Icons.account_balance_wallet, title: 'Pemasukan', isActive: false, isCollapsed: isCollapsed),
          SidebarItem(icon: Icons.money_off, title: 'Pengeluaran', isActive: false, isCollapsed: isCollapsed),
          SidebarItem(icon: Icons.bar_chart, title: 'Laporan Keuangan', isActive: false, isCollapsed: isCollapsed),
          
          // --- Menu ExpansionTile (Kegiatan & Broadcast) ---
          SidebarExpansionItem(
            title: 'Kegiatan & Broadcast',
            icon: Icons.calendar_today,
            isCollapsed: isCollapsed,
            // PASTIKAN EXPANSION TERBUKA JIKA RUTE AKTIF ADA DI DALAMNYA
            initiallyExpanded: isKegiatanExpanded, 
            children: [
              // Logika isActive DISINI (Berdasarkan Rute)
              SidebarSubItem(
                title: 'Kegiatan - Daftar', 
                isActive: currentRoute == '/activities', // AKTIF JIKA RUTE ADALAH /activities
              ),
              SidebarSubItem(
                title: 'Kegiatan - Tambah', 
                isActive: currentRoute == '/activities/add', // AKTIF JIKA RUTE ADALAH /activities/add
              ),
              const SidebarSubItem(title: 'Broadcast - Daftar', isActive: false),
              const SidebarSubItem(title: 'Broadcast - Tambah', isActive: false),
            ],
          ),
          
          // Menu Statis Lainnya
          SidebarItem(icon: Icons.mail, title: 'Pesan Warga', isActive: false, isCollapsed: isCollapsed),
          SidebarItem(icon: Icons.people, title: 'Penerimaan Warga', isActive: false, isCollapsed: isCollapsed),
          SidebarItem(icon: Icons.swap_horiz, title: 'Mutasi Keluarga', isActive: false, isCollapsed: isCollapsed),
          SidebarItem(icon: Icons.history, title: 'Log Aktifitas', isActive: false, isCollapsed: isCollapsed),
          SidebarItem(icon: Icons.group, title: 'Manajemen Pengguna', isActive: false, isCollapsed: isCollapsed),
          SidebarItem(icon: Icons.alt_route, title: 'Channel Transfer', isActive: false, isCollapsed: isCollapsed),
        ],
      ),
    );
  }
}

extension on GoRouter {
  get uri => null;
}
// File: lib/screens/dashboard/activity_list_screen.dart (DIUBAH)

import 'package:flutter/material.dart';
import 'package:jawara_mobile/widgets/layout/custom_sidebar.dart';
import 'package:jawara_mobile/widgets/layout/activity_list_table.dart';

// Import untuk mengendalikan state sidebar
// Hapus import custom_header yang lama

class ActivityListScreen extends StatefulWidget { // UBAH MENJADI STATEFUL
  const ActivityListScreen({super.key});

  @override
  State<ActivityListScreen> createState() => _ActivityListScreenState();
}

class _ActivityListScreenState extends State<ActivityListScreen> {
  // State untuk mengontrol lebar sidebar
  double _sidebarWidth = 280;
  final double _collapsedWidth = 60; // Lebar saat sidebar ditutup

  void _toggleSidebar() {
    setState(() {
      _sidebarWidth = (_sidebarWidth == 280) ? _collapsedWidth : 280;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // --- 1. Sidebar ---
          AnimatedContainer( // Gunakan AnimatedContainer untuk transisi halus
            duration: const Duration(milliseconds: 200),
            width: _sidebarWidth, 
            child: CustomSidebar(isCollapsed: _sidebarWidth == _collapsedWidth), // Kirim state ke Sidebar
          ),
          
          // --- 2. Konten Utama ---
          Expanded(
            child: Column(
              children: <Widget>[
                // Tambahkan Header Minimal di sini
                MinimalHeader(onToggle: _toggleSidebar), // Gunakan Header Minimal
                
                // Konten utama Daftar Kegiatan (Tabel)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ActivityListTable(), 
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Tambahkan Widget Header Minimal di file yang sama atau di custom_header.dart ---

class MinimalHeader extends StatelessWidget {
  final VoidCallback onToggle;

  const MinimalHeader({super.key, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60, // Tinggi yang tetap
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Color(0xFFF9FAFB), // Warna latar belakang di atas tabel
        border: Border(bottom: BorderSide(color: Colors.black12, width: 1)),
      ),
      child: Row(
        children: [
          // Ikon Tombol (Sesuai gambar, Ikon untuk buka/tutup)
          IconButton(
            icon: const Icon(Icons.menu_rounded, color: Colors.black87),
            onPressed: onToggle,
          ),
          const Spacer(),
          // Konten lain di Header jika diperlukan
        ],
      ),
    );
  }
}
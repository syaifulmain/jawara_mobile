import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // PENTING: Import GoRouter

// Definisi Warna Dasar Sidebar Putih
const Color _inactiveColor = Colors.black54; 
const Color _activePrimaryColor = Color(0xFF635BFF); // AppColors.primaryColor
const Color _activeItemBg = Color(0xFFF1F5F9); // Warna latar belakang terang untuk highlight

// Widget untuk item menu biasa (non-ExpansionTile)
class SidebarItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isActive;
  final bool isCollapsed;

  const SidebarItem({
    super.key,
    required this.icon,
    required this.title,
    required this.isActive,
    this.isCollapsed = false,
  });

  @override
  Widget build(BuildContext context) {
    // Menambahkan dekorasi highlight untuk item menu utama
    final Widget itemContent = ListTile(
      leading: Icon(icon, color: _inactiveColor),
      title: Text(
        title,
        style: TextStyle(color: isActive ? _activePrimaryColor : _inactiveColor),
      ),
      trailing: const Icon(Icons.chevron_right, color: _inactiveColor),
      onTap: () {
        // Contoh: Navigasi Dashboard
        if (title == 'Dashboard') {
          GoRouter.of(context).go('/dashboard'); 
        }
        // Tambahkan navigasi untuk item menu utama lainnya di sini
      }, 
    );

    // Tampilan saat Sidebar sedang Collapsed (hanya ikon)
    if (isCollapsed) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
        child: Icon(icon, color: _inactiveColor),
      );
    }

    // Tampilan saat Sidebar terbuka (dengan highlight)
    return Container(
      // Dekorasi untuk item yang aktif
      decoration: BoxDecoration(
        color: isActive ? _activeItemBg : Colors.transparent,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(5),
          bottomRight: Radius.circular(5),
        ),
      ),
      child: itemContent,
    );
  }
}

// Widget untuk menu Expansion (Kegiatan & Broadcast)
class SidebarExpansionItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  final bool isCollapsed;
  final bool initiallyExpanded; // <--- PROPERTI BARU DITAMBAHKAN

  const SidebarExpansionItem({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
    this.isCollapsed = false,
    this.initiallyExpanded = false, // <--- DEFAULT DITAMBAHKAN
  });

  @override
  Widget build(BuildContext context) {
    if (isCollapsed) {
      // Ketika Collapsed, ExpansionTile TIDAK BOLEH digunakan.
      return SidebarItem(icon: icon, title: title, isActive: false, isCollapsed: true);
    }
    
    // Tampilan ExpansionTile saat terbuka
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded, // <--- PROPERTI BARU DIGUNAKAN
        iconColor: _inactiveColor,
        collapsedIconColor: _inactiveColor,
        tilePadding: const EdgeInsets.symmetric(horizontal: 20),
        title: Text(
          title,
          style: const TextStyle(color: _inactiveColor),
        ),
        leading: Icon(icon, color: _inactiveColor),
        children: children.map((item) {
          return Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: item,
          );
        }).toList(),
      ),
    );
  }
}

// Widget untuk sub-item di dalam ExpansionTile
class SidebarSubItem extends StatelessWidget {
  final String title;
  final bool isActive;

  const SidebarSubItem({
    super.key,
    required this.title,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    // Warna teks aktif di sub-item menggunakan warna gelap
    const Color activeTextColor = Colors.black87; 
    
    return Container(
      decoration: BoxDecoration(
        color: isActive ? _activeItemBg : Colors.transparent, // Highlight dengan warna terang
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(5),
          bottomRight: Radius.circular(5),
        ),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? activeTextColor : _inactiveColor, // Warna teks gelap
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
        contentPadding: const EdgeInsets.only(left: 35.0), 
        onTap: () {
          // --- LOGIKA NAVIGASI DITEMPATKAN DI SINI ---
          if (title == 'Kegiatan - Tambah') {
            GoRouter.of(context).goNamed('add_activity');
          } else if (title == 'Kegiatan - Daftar') {
            GoRouter.of(context).goNamed('activities');
          }
          else if (title == 'Broadcast - Daftar') {
            GoRouter.of(context).goNamed('broadcast_list');
          } 
          // Tambahkan logika navigasi untuk item sub-menu lain di sini jika diperlukan
        },
      ),
    );
  }
}
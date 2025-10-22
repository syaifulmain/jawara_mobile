// File: lib/widgets/layout/minimal_header.dart

import 'package:flutter/material.dart';

class MinimalHeader extends StatelessWidget {
  final VoidCallback onToggle;

  const MinimalHeader({super.key, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60, // Tinggi yang tetap
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Color(0xFFF9FAFB), // Warna latar belakang di atas konten
        border: Border(bottom: BorderSide(color: Colors.black12, width: 1)),
      ),
      child: Row(
        children: [
          // Ikon Tombol (untuk buka/tutup sidebar)
          IconButton(
            icon: const Icon(Icons.menu_rounded, color: Colors.black87),
            onPressed: onToggle,
          ),
          const Spacer(),
          // Anda dapat menambahkan konten header lain di sini jika perlu
        ],
      ),
    );
  }
}
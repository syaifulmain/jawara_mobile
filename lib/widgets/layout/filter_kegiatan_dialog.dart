// File: lib/widgets/layout/filter_kegiatan_dialog.dart
import 'package:flutter/material.dart';
import 'package:jawara_mobile/widgets/custom_text_field.dart'; // Digunakan
import 'package:jawara_mobile/widgets/custom_dropdown.dart';   // Digunakan
import 'package:jawara_mobile/constants/colors.dart';         // Digunakan (AppColors)
import 'package:jawara_mobile/constants/rem.dart';             // Digunakan (Rem)
// ... (imports lain yang mungkin dibutuhkan)
// Tambahkan widget ini di dalam file lib/widgets/layout/activity_list_table.dart

class FilterKegiatanDialog extends StatelessWidget {
  const FilterKegiatanDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.only(
        top: 10,
        left: 24,
        right: 24,
        bottom: 0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Rem.rem0_75),
      ),

      title: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Filter Kegiatan',
              style: TextStyle(
                fontSize: Rem.rem1_25,
                fontWeight: FontWeight.w600,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(), // Tutup dialog
            ),
          ],
        ),
      ),

      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. Nama Kegiatan
            const Text(
              "Nama Kegiatan",
              style: TextStyle(
                fontSize: Rem.rem1,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: Rem.rem0_5),
            CustomTextField(
              hintText: "Cari kegiatan...",
              // Hapus labelText agar tidak duplikasi dengan Text di atas
            ),

            const SizedBox(height: Rem.rem1_5),

            // 2. Tanggal Pelaksanaan
            const Text(
              "Tanggal Pelaksanaan",
              style: TextStyle(
                fontSize: Rem.rem1,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: Rem.rem0_5),
            // Menggunakan TextField biasa untuk meniru input tanggal dengan ikon X dan Kalender
            TextField(
              decoration: InputDecoration(
                hintText: "--/--/----",
                hintStyle: TextStyle(color: Colors.grey.shade600),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Rem.rem0_5),
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.close), onPressed: () {}),
                    const VerticalDivider(width: 1),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: Rem.rem1_5),

            // 3. Kategori
            const Text(
              "Kategori",
              style: TextStyle(
                fontSize: Rem.rem1,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: Rem.rem0_5),
            CustomDropdown<String>(
              hintText: "-- Pilih Kategori --",
              items: const [
                DropdownMenuEntry(value: 'sosial', label: 'Komunitas & Sosial'),
                DropdownMenuEntry(value: 'kebersihan', label: 'Kebersihan'),
                DropdownMenuEntry(value: 'keuangan', label: 'Keuangan'),
              ],
              // Hapus labelText agar tidak duplikasi
            ),
          ],
        ),
      ),

      // Tombol Aksi (Reset dan Terapkan)
      actions: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Reset Filter
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey.shade700,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Reset Filter',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

              // Terapkan
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Rem.rem0_5),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Terapkan',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

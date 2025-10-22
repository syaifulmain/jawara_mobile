// File: lib/screens/dashboard/add_activity_screen.dart

import 'package:flutter/material.dart';
import 'package:jawara_mobile/widgets/layout/custom_sidebar.dart';
import 'package:jawara_mobile/widgets/custom_text_field.dart';
import 'package:jawara_mobile/widgets/custom_dropdown.dart';
import 'package:jawara_mobile/constants/colors.dart';
import 'package:jawara_mobile/constants/rem.dart';
import 'package:jawara_mobile/widgets/layout/minimal_header.dart'; // Pastikan widget ini sudah ada

class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({super.key});

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  // State untuk sidebar (asumsi lebar default 280)
  double _sidebarWidth = 280;
  final double _collapsedWidth = 60; 

  void _toggleSidebar() {
    setState(() {
      _sidebarWidth = (_sidebarWidth == 280) ? _collapsedWidth : 280;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor, // Latar belakang abu-abu muda
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // --- 1. Sidebar ---
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: _sidebarWidth, 
            child: CustomSidebar(isCollapsed: _sidebarWidth == _collapsedWidth), 
          ),
          
          // --- 2. Konten Formulir Utama ---
          Expanded(
            child: Column(
              children: <Widget>[
                // Header minimalis untuk tombol buka/tutup sidebar
                MinimalHeader(onToggle: _toggleSidebar), 
                
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(Rem.rem2), // Padding konten
                    child: ActivityForm(), // Widget formulir utama
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

// Widget Formulir Utama
class ActivityForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const Color purpleColor = Color(0xFF6C63FF); 

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Rem.rem2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Rem.rem0_75),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Buat Kegiatan Baru',
            style: TextStyle(
              fontSize: Rem.rem1_5,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: Rem.rem2),

          // --- 1. Nama Kegiatan ---
          const CustomTextField(
            labelText: "Nama Kegiatan",
            hintText: "Contoh: Musyawarah Warga",
          ),
          const SizedBox(height: Rem.rem2),

          // --- 2. Kategori Kegiatan (Dropdown) ---
          const CustomDropdown<String>(
            labelText: "Kategori Kegiatan",
            hintText: "-- Pilih Kategori --",
            items: [
              DropdownMenuEntry(value: 'sosial', label: 'Komunitas & Sosial'),
              DropdownMenuEntry(value: 'kebersihan', label: 'Kebersihan'),
              DropdownMenuEntry(value: 'keuangan', label: 'Keuangan'),
            ],
          ),
          const SizedBox(height: Rem.rem2),

          // --- 3. Tanggal Pelaksanaan ---
          const Text(
            "Tanggal",
            style: TextStyle(fontSize: Rem.rem1, fontWeight: FontWeight.normal, color: Colors.black87),
          ),
          const SizedBox(height: Rem.rem0_5),
          TextField(
            decoration: InputDecoration(
              hintText: "--/--/----",
              hintStyle: TextStyle(color: Colors.grey.shade600),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(Rem.rem0_5)),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryColor)),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(icon: const Icon(Icons.close), onPressed: () {}),
                  const VerticalDivider(width: 1),
                  IconButton(icon: const Icon(Icons.calendar_today), onPressed: () {}),
                ],
              ),
            ),
          ),
          const SizedBox(height: Rem.rem2),

          // --- 4. Lokasi ---
          const CustomTextField(
            labelText: "Lokasi",
            hintText: "Contoh: Balai RT 03",
          ),
          const SizedBox(height: Rem.rem2),

          // --- 5. Penanggung Jawab ---
          const CustomTextField(
            labelText: "Penanggung Jawab",
            hintText: "Contoh: Pak RT atau Bu RW",
          ),
          const SizedBox(height: Rem.rem2),

          // --- 6. Deskripsi (Text Area) ---
          const Text(
            "Deskripsi",
            style: TextStyle(fontSize: Rem.rem1, fontWeight: FontWeight.normal, color: Colors.black87),
          ),
          const SizedBox(height: Rem.rem0_5),
          TextField(
            maxLines: 5,
            decoration: InputDecoration(
              hintText: "Tuliskan detail event seperti agenda, keperluan, dll.",
              hintStyle: TextStyle(color: Colors.grey.shade600),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(Rem.rem0_5)),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryColor)),
              contentPadding: const EdgeInsets.symmetric(horizontal: Rem.rem0_75, vertical: Rem.rem0_75),
            ),
          ),
          const SizedBox(height: Rem.rem2),

          // --- Tombol Submit dan Reset ---
          Row(
            children: [
              // Submit
              ElevatedButton(
                onPressed: () {
                  // Logic submit
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: purpleColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: Rem.rem1_5, vertical: Rem.rem1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Rem.rem0_5)),
                ),
                child: const Text('Submit'),
              ),
              const SizedBox(width: Rem.rem1),
              
              // Reset
              OutlinedButton(
                onPressed: () {
                  // Logic reset
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey.shade700,
                  side: BorderSide(color: Colors.grey.shade400),
                  padding: const EdgeInsets.symmetric(horizontal: Rem.rem1_5, vertical: Rem.rem1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Rem.rem0_5)),
                ),
                child: const Text('Reset'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
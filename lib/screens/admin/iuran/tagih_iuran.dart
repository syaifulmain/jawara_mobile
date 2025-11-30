import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_mobile/constants/colors.dart';
import 'package:jawara_mobile/constants/rem.dart';
import 'package:jawara_mobile/widgets/custom_button.dart';
import 'package:jawara_mobile/widgets/custom_dropdown.dart';
import 'package:jawara_mobile/widgets/custom_select_calender.dart';
import 'package:jawara_mobile/data/kategori_iuran_data.dart';

class TagihIuranScreen extends StatefulWidget {
  const TagihIuranScreen({super.key});

  @override
  State<TagihIuranScreen> createState() => _TagihIuranScreenState();
}

class _TagihIuranScreenState extends State<TagihIuranScreen> {
  String? _selectedJenisIuran;
  DateTime? _selectedDate = DateTime.now();
  
  // Get jenis iuran options from kategori iuran data
  List<DropdownMenuEntry<String>> get _jenisIuranOptions {
    final uniqueJenis = dummyDataKategoriIuran
        .map((kategori) => kategori.namaIuran)
        .toSet()
        .toList();
    
    return uniqueJenis.map((jenis) => DropdownMenuEntry(
      value: jenis,
      label: jenis,
    )).toList();
  }

  void _submitForm() {
    if (_selectedJenisIuran == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon pilih jenis iuran terlebih dahulu'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon pilih tanggal terlebih dahulu'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tagihan iuran $_selectedJenisIuran berhasil dikirim ke semua keluarga aktif!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _resetForm() {
    setState(() {
      _selectedJenisIuran = null;
      _selectedDate = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tagih Iuran Warga'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Rem.rem1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card utama form tagih iuran
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Rem.rem0_75),
              ),
              child: Padding(
                padding: const EdgeInsets.all(Rem.rem1_5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(Rem.rem0_5),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.send,
                            color: Colors.white,
                            size: Rem.rem1_25,
                          ),
                        ),
                        const SizedBox(width: Rem.rem1),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Form Tagih',
                                style: GoogleFonts.figtree(
                                  fontSize: Rem.rem0_875,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                'Iuran ke Semua Keluarga Aktif',
                                style: GoogleFonts.figtree(
                                  fontSize: Rem.rem1_25,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: Rem.rem1_5),
                    const Divider(),
                    const SizedBox(height: Rem.rem1),
                    
                    // Jenis Iuran Dropdown
                    CustomDropdown<String>(
                      labelText: "Jenis Iuran",
                      hintText: _selectedJenisIuran ?? "Pilih jenis iuran",
                      items: _jenisIuranOptions,
                      initialSelection: _selectedJenisIuran,
                      onSelected: (String? newValue) {
                        setState(() {
                          _selectedJenisIuran = newValue;
                        });
                      },
                    ),
                    
                    const SizedBox(height: Rem.rem1_5),
                    
                    // Tanggal
                    CustomSelectCalendar(
                      labelText: "Tanggal",
                      hintText: "Pilih tanggal tagihan",
                      onDateSelected: (DateTime selectedDate) {
                        setState(() {
                          _selectedDate = selectedDate;
                        });
                      },
                    ),
                    
                    const SizedBox(height: Rem.rem2),
                    
                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            onPressed: _submitForm,
                            child: Text(
                              'Tagih Iuran',
                              style: GoogleFonts.figtree(
                                fontSize: Rem.rem1,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: Rem.rem1),
                        Expanded(
                          child: CustomButton(
                            backgroundColor: Colors.grey,
                            onPressed: _resetForm,
                            child: Text(
                              'Reset',
                              style: GoogleFonts.figtree(
                                fontSize: Rem.rem1,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: Rem.rem1_5),
                    
                    // Info section
                    Container(
                      padding: const EdgeInsets.all(Rem.rem1),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        border: Border.all(color: Colors.blue.shade200),
                        borderRadius: BorderRadius.circular(Rem.rem0_5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info, color: Colors.blue.shade600, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                'Informasi:',
                                style: GoogleFonts.figtree(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tagihan akan dikirim ke semua keluarga yang terdaftar aktif di sistem. Pastikan jenis iuran dan tanggal sudah benar sebelum mengirim tagihan.',
                            style: GoogleFonts.figtree(
                              color: Colors.blue.shade800,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
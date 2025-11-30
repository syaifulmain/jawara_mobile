import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_mobile/constants/colors.dart';
import 'package:jawara_mobile/constants/rem.dart';
import 'package:jawara_mobile/widgets/custom_dropdown.dart';
import 'package:jawara_mobile/providers/kategori_iuran_form_provider.dart';
import 'package:provider/provider.dart';

class KategoriIuranTambahScreen extends StatefulWidget {
  const KategoriIuranTambahScreen({super.key});

  @override
  State<KategoriIuranTambahScreen> createState() => _KategoriIuranTambahScreenState();
}

class _KategoriIuranTambahScreenState extends State<KategoriIuranTambahScreen> {
  void _submitForm(KategoriIuranFormProvider provider) {
    if (!provider.isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon lengkapi semua field yang diperlukan'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // TODO: Implementasi submit form dengan data dari provider.getFormData()
    final formData = provider.getFormData();
    print('Form data: $formData'); // Debug print

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kategori iuran berhasil ditambahkan!'),
        backgroundColor: Colors.green,
      ),
    );

    // Reset form
    provider.resetForm();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<KategoriIuranFormProvider>(
      builder: (context, provider, child) => _buildContent(context, provider),
    );
  }

  Widget _buildContent(BuildContext context, KategoriIuranFormProvider provider) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Kategori Iuran'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Rem.rem1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card utama form tambah kategori iuran
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
                            Icons.add,
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
                                'Form Tambah',
                                style: GoogleFonts.figtree(
                                  fontSize: Rem.rem0_875,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                'Kategori Iuran Baru',
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

                    // Form fields dengan design row seperti detail
                    _buildFormRow(
                      'Nama Iuran',
                      Icons.monetization_on,
                      TextField(
                        controller: provider.namaIuranController,
                        style: GoogleFonts.figtree(),
                        decoration: InputDecoration(
                          hintText: 'Contoh: Iuran Bulanan RT 03',
                          hintStyle: GoogleFonts.figtree(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(Rem.rem0_5),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(Rem.rem0_5),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(Rem.rem0_5),
                            borderSide: const BorderSide(
                              color: AppColors.primaryColor,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: Rem.rem0_75,
                            vertical: Rem.rem0_75,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: Rem.rem1),

                    _buildFormRow(
                      'Jenis Iuran',
                      Icons.category,
                      CustomDropdown<String>(
                        initialSelection: provider.selectedJenisIuran,
                        hintText: '-- Pilih Jenis Iuran --',
                        items: provider.jenisIuranOptions.map((jenis) {
                          return DropdownMenuEntry<String>(
                            value: jenis,
                            label: jenis,
                          );
                        }).toList(),
                        onSelected: (value) {
                          provider.setSelectedJenisIuran(value);
                        },
                      ),
                    ),
                    const SizedBox(height: Rem.rem1),

                    _buildFormRow(
                      'Nominal',
                      Icons.payments,
                      TextField(
                        controller: provider.nominalController,
                        style: GoogleFonts.figtree(),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Contoh: 25000',
                          hintStyle: GoogleFonts.figtree(color: Colors.grey),
                          prefixText: 'Rp ',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(Rem.rem0_5),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(Rem.rem0_5),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(Rem.rem0_5),
                            borderSide: const BorderSide(
                              color: AppColors.primaryColor,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: Rem.rem0_75,
                            vertical: Rem.rem0_75,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
                        'Informasi Jenis Iuran:',
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
                    '• Iuran Bulanan: Dibayar setiap bulan sekali secara rutin oleh setiap warga.',
                    style: GoogleFonts.figtree(
                      color: Colors.blue.shade800,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '• Iuran Khusus: Dibayar sesuai jadwal atau kebutuhan tertentu, seperti untuk acara khusus, renovasi, atau kegiatan lain yang tidak rutin.',
                    style: GoogleFonts.figtree(
                      color: Colors.blue.shade800,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: Rem.rem1_5),

            // Tombol aksi dengan design yang sama seperti detail
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _submitForm(provider),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 23),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Rem.rem0_5),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.save, color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Simpan',
                          style: GoogleFonts.figtree(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: Rem.rem1),
                Expanded(
                  child: OutlinedButton(
                    onPressed: provider.resetForm,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.grey),
                      padding: const EdgeInsets.symmetric(vertical: 23),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Rem.rem0_5),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.refresh, color: Colors.grey, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Reset',
                          style: GoogleFonts.figtree(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormRow(String label, IconData icon, Widget inputWidget) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey[600],
        ),
        const SizedBox(width: Rem.rem0_75),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.figtree(
                  fontSize: Rem.rem0_875,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              inputWidget,
            ],
          ),
        ),
      ],
    );
  }
}
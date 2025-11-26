import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_mobile/constants/colors.dart';
import 'package:jawara_mobile/constants/rem.dart';
import 'package:jawara_mobile/widgets/custom_button.dart';
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
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(Rem.rem1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Rem.rem0_75),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(Rem.rem1_5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey.shade100,
                    foregroundColor: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(width: Rem.rem0_75),
                Text(
                  'Buat Kategori Iuran Baru',
                  style: GoogleFonts.figtree(
                    fontSize: Rem.rem1_5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Rem.rem1_5),

            // Form
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama Iuran
                    Text(
                      'Nama Iuran',
                      style: GoogleFonts.figtree(
                        fontSize: Rem.rem1,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: Rem.rem0_5),
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
                    const SizedBox(height: Rem.rem1),

                    // Jenis Iuran
                    Text(
                      'Jenis Iuran',
                      style: GoogleFonts.figtree(
                        fontSize: Rem.rem1,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: Rem.rem0_5),
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
                    const SizedBox(height: Rem.rem1),

                    // Nominal
                    Text(
                      'Nominal',
                      style: GoogleFonts.figtree(
                        fontSize: Rem.rem1,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: Rem.rem0_5),
                    TextField(
                      controller: provider.nominalController,
                      style: GoogleFonts.figtree(),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Contoh: 25000',
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
                    const SizedBox(height: Rem.rem2),

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
                                'Info Jenis Iuran:',
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
                            '• Iuran Bulanan: Dibayar setiap bulan sekali secara rutin',
                            style: GoogleFonts.figtree(
                              color: Colors.blue.shade800,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '• Iuran Khusus: Dibayar sesuai jadwal atau kebutuhan tertentu',
                            style: GoogleFonts.figtree(
                              color: Colors.blue.shade800,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: Rem.rem2),

                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            onPressed: () => _submitForm(provider),
                            child: Text(
                              'Submit',
                              style: GoogleFonts.figtree(
                                fontWeight: FontWeight.w600,
                              ),
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
                            child: Text(
                              'Reset',
                              style: GoogleFonts.figtree(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
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
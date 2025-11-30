import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_mobile/constants/colors.dart';
import 'package:jawara_mobile/constants/rem.dart';
import 'package:jawara_mobile/models/data_kategori_iuran_model.dart';

class KategoriIuranDetailScreen extends StatelessWidget {
  final DataKategoriIuranModel data;

  const KategoriIuranDetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Kategori Iuran'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Rem.rem1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card utama informasi kategori iuran
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
                            Icons.monetization_on,
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
                                'Kategori Iuran',
                                style: GoogleFonts.figtree(
                                  fontSize: Rem.rem0_875,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                data.namaIuran,
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

                    // Detail informasi
                    _buildDetailRow(
                      'Jenis Iuran',
                      data.jenisIuran,
                      Icons.category,
                    ),
                    const SizedBox(height: Rem.rem1),
                    
                    _buildDetailRow(
                      'Nominal',
                      data.nominal,
                      Icons.monetization_on,
                    ),
                    const SizedBox(height: Rem.rem1),
                    _buildDetailRow(
                      'Tanggal Dibuat',
                      data.tanggalBuat,
                      Icons.calendar_today,
                    ),
                    const SizedBox(height: Rem.rem1),
                    
                    _buildDetailRow(
                      'Dibuat Oleh',
                      data.dibuatOleh,
                      Icons.person,
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
                  if (data.jenisIuran == 'Iuran Bulanan')
                    Text(
                      'Iuran ini dibayar setiap bulan sekali secara rutin oleh setiap warga.',
                      style: GoogleFonts.figtree(
                        color: Colors.blue.shade800,
                        fontSize: 13,
                      ),
                    )
                  else
                    Text(
                      'Iuran ini dibayar sesuai jadwal atau kebutuhan tertentu, seperti untuk acara khusus, renovasi, atau kegiatan lain yang tidak rutin.',
                      style: GoogleFonts.figtree(
                        color: Colors.blue.shade800,
                        fontSize: 13,
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: Rem.rem1_5),

            // Tombol aksi
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _showEditDialog(context);
                    },
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
                        const Icon(Icons.edit, color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Edit',
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
                    onPressed: () {
                      _showDeleteDialog(context);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 23),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Rem.rem0_5),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.delete, color: Colors.red, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Hapus',
                          style: GoogleFonts.figtree(
                            color: Colors.red,
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

  Widget _buildDetailRow(String label, String value, IconData icon) {
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
              Text(
                value,
                style: GoogleFonts.figtree(
                  fontSize: Rem.rem1,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showEditDialog(BuildContext context) {
    final TextEditingController namaController = TextEditingController(text: data.namaIuran);
    final TextEditingController nominalController = TextEditingController(text: data.nominal.replaceAll(RegExp(r'[^\d]'), ''));
    String selectedJenis = data.jenisIuran;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Rem.rem0_75),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.all(Rem.rem1_5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Edit Kategori Iuran',
                          style: GoogleFonts.figtree(
                            fontSize: Rem.rem1_25,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ubah data kategori iuran yang diperlukan.',
                      style: GoogleFonts.figtree(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: Rem.rem1_5),
                    
                    // Form fields
                    Text(
                      'Nama Iuran',
                      style: GoogleFonts.figtree(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: namaController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Rem.rem0_5),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8,
                        ),
                      ),
                    ),
                    const SizedBox(height: Rem.rem1),
                    
                    Text(
                      'Nominal',
                      style: GoogleFonts.figtree(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: nominalController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Rem.rem0_5),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8,
                        ),
                        prefixText: 'Rp ',
                      ),
                    ),
                    const SizedBox(height: Rem.rem1),
                    
                    Text(
                      'Jenis Iuran',
                      style: GoogleFonts.figtree(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: selectedJenis,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Rem.rem0_5),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8,
                        ),
                      ),
                      items: ['Iuran Bulanan', 'Iuran Khusus'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedJenis = newValue!;
                        });
                      },
                    ),
                    
                    const SizedBox(height: Rem.rem2),
                    
                    // Action buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'Batal',
                            style: GoogleFonts.figtree(color: Colors.grey.shade600),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Kategori iuran berhasil diperbarui'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Rem.rem0_5),
                            ),
                          ),
                          child: Text(
                            'Simpan',
                            style: GoogleFonts.figtree(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Hapus Kategori Iuran',
            style: GoogleFonts.figtree(fontWeight: FontWeight.w600),
          ),
          content: Text(
            'Apakah Anda yakin ingin menghapus kategori iuran "${data.namaIuran}"?',
            style: GoogleFonts.figtree(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Kembali ke list
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Kategori iuran berhasil dihapus'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
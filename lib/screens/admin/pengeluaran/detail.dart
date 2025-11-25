import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_mobile/constants/colors.dart';
import 'package:jawara_mobile/constants/rem.dart';
import 'package:jawara_mobile/models/data_pengeluaran_model.dart';
import 'package:jawara_mobile/widgets/custom_button.dart';

class PengeluaranDetailScreen extends StatelessWidget {
  final DataPengeluaranModel data;

  const PengeluaranDetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pengeluaran'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Rem.rem1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card utama informasi pengeluaran
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
                            Icons.money_off_rounded,
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
                                'Pengeluaran',
                                style: GoogleFonts.figtree(
                                  fontSize: Rem.rem0_875,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                data.nama,
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
                      'Kategori Pengeluaran',
                      data.kategoriPengeluaran,
                      Icons.category,
                    ),
                    const SizedBox(height: Rem.rem1),
                    
                    _buildDetailRow(
                      'Tanggal Pengeluaran',
                      data.tanggal,
                      Icons.calendar_today,
                    ),
                    const SizedBox(height: Rem.rem1),
                    
                    _buildDetailRow(
                      'Nominal',
                      data.nominal,
                      Icons.money_off_rounded,
                    ),
                    const SizedBox(height: Rem.rem1),
                    
                    _buildDetailRow(
                      'Tanggal Verifikasi',
                      data.tanggalVerifikasi,
                      Icons.verified,
                    ),
                    const SizedBox(height: Rem.rem1),
                    
                    _buildDetailRow(
                      'Verifikator',
                      data.verifikator,
                      Icons.person,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: Rem.rem1_5),

            // Tombol aksi
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    onPressed: () {
                      _showEditDialog(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.edit, color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Edit',
                          style: GoogleFonts.figtree(
                            fontWeight: FontWeight.w600,
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Edit Pengeluaran',
            style: GoogleFonts.figtree(fontWeight: FontWeight.w600),
          ),
          content: Text(
            'Fitur edit pengeluaran akan segera tersedia.',
            style: GoogleFonts.figtree(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
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
            'Hapus Pengeluaran',
            style: GoogleFonts.figtree(fontWeight: FontWeight.w600),
          ),
          content: Text(
            'Apakah Anda yakin ingin menghapus pengeluaran "${data.nama}"?',
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
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pengeluaran berhasil dihapus'),
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
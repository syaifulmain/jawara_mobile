import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_mobile/constants/colors.dart';
import 'package:jawara_mobile/constants/rem.dart';

import '../../../models/data_pemasukan_model.dart';

class PemasukanDetailScreen extends StatefulWidget {
  final DataPemasukanModel dataPemasukan;

  const PemasukanDetailScreen({super.key, required this.dataPemasukan});

  @override
  State<PemasukanDetailScreen> createState() => _PemasukanDetailScreenState();
}

class _PemasukanDetailScreenState extends State<PemasukanDetailScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pemasukan'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Rem.rem1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(Rem.rem0_5),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.account_balance_wallet,
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
                                'Detail Pemasukan',
                                style: GoogleFonts.figtree(
                                  fontSize: Rem.rem0_875,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                widget.dataPemasukan.jenisPemasukan,
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

                    _buildDetailRow('Nama Pemasukan', widget.dataPemasukan.nama, Icons.description),
                    const SizedBox(height: Rem.rem1),
                    _buildDetailRow('Jenis Pemasukan', widget.dataPemasukan.jenisPemasukan, Icons.category),
                    const SizedBox(height: Rem.rem1),
                    _buildDetailRow('Jumlah', widget.dataPemasukan.nominal, Icons.monetization_on),
                    const SizedBox(height: Rem.rem1),
                    _buildDetailRow('Tanggal Transaksi', widget.dataPemasukan.tanggal, Icons.calendar_today),
                    const SizedBox(height: Rem.rem1),
                    _buildDetailRow('Tanggal Terverifikasi', widget.dataPemasukan.tanggalVerifikasi, Icons.verified),
                    const SizedBox(height: Rem.rem1),
                    _buildDetailRow('Verifikator', widget.dataPemasukan.verifikator, Icons.person),
                  ],
                ),
              ),
            ),

            const SizedBox(height: Rem.rem1_5),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Fitur edit akan segera tersedia'), backgroundColor: Colors.orange),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 23),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Rem.rem0_5)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.edit, color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Text('Edit', style: GoogleFonts.figtree(fontWeight: FontWeight.w600, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: Rem.rem1),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showDeleteDialog(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 23),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Rem.rem0_5)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.delete, color: Colors.red, size: 18),
                        const SizedBox(width: 8),
                        Text('Hapus', style: GoogleFonts.figtree(color: Colors.red, fontWeight: FontWeight.w600)),
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
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: Rem.rem0_75),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GoogleFonts.figtree(fontSize: Rem.rem0_875, color: Colors.grey[600])),
              const SizedBox(height: 4),
              Text(value, style: GoogleFonts.figtree(fontSize: Rem.rem1, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus Data Pemasukan', style: GoogleFonts.figtree(fontWeight: FontWeight.w600)),
        content: Text('Apakah Anda yakin ingin menghapus data pemasukan "${widget.dataPemasukan.nama}"?', style: GoogleFonts.figtree()),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data pemasukan berhasil dihapus'), backgroundColor: Colors.green),
              );
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
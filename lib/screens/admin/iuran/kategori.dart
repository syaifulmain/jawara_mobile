import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';  
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_mobile/constants/rem.dart';

import '../../../constants/colors.dart';
import '../../../data/kategori_iuran_data.dart';
import '../../../models/data_kategori_iuran_model.dart';

class KategoriIuranScreen extends StatelessWidget {
  const KategoriIuranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          // Info header
          Container(
            margin: const EdgeInsets.all(Rem.rem1),
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
                      'Info:',
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
                  'Iuran Bulanan: Dibayar setiap bulan sekali secara rutin.',
                  style: GoogleFonts.figtree(
                    color: Colors.blue.shade800,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Iuran Khusus: Dibayar sesuai jadwal atau kebutuhan tertentu, misalnya iuran untuk acara khusus, renovasi, atau kegiatan lain yang tidak rutin.',
                  style: GoogleFonts.figtree(
                    color: Colors.blue.shade800,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          
          // Action buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Rem.rem1),
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    context.pushNamed('iuran-tambah_kategori');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Rem.rem0_5),
                    ),
                  ),
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(
                    'Tambah',
                    style: GoogleFonts.figtree(fontSize: 14),
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Implement filter
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade100,
                    foregroundColor: Colors.grey.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Rem.rem0_5),
                    ),
                  ),
                  icon: const Icon(Icons.filter_alt, size: 18),
                  label: Text(
                    'Filter',
                    style: GoogleFonts.figtree(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: Rem.rem1),
          
          // Data list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: Rem.rem1),
              itemCount: dummyDataKategoriIuran.length,
              itemBuilder: (context, index) {
                final data = dummyDataKategoriIuran[index];
                return DataCard(data: data, index: index + 1);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DataCard extends StatelessWidget {
  final DataKategoriIuranModel data;
  final int index;
  
  const DataCard({super.key, required this.data, required this.index});

  Widget _buildStatusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: GoogleFonts.figtree(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: Rem.rem0_75,
        ),
      ),
    );
  }







  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.backgroundColor,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // Nomor urut
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      index.toString(),
                      style: GoogleFonts.figtree(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
                
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.namaIuran,
                          style: GoogleFonts.figtree(
                            fontSize: Rem.rem1,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.visibility,
                      color: Colors.white,
                      size: 18,
                    ),
                    onPressed: () {
                      context.pushNamed(
                        'iuran-detail',
                        extra: data,
                      );
                    },
                  ),
                ),
              ],
            ),
            const Divider(height: 16),

            _buildDataRow(Icons.category, 'Jenis Iuran', data.jenisIuran),

            const SizedBox(height: 10),

            //Nominal dan Badge ---
            Row(
              children: <Widget>[
                const Icon(
                  Icons.monetization_on,
                  size: 16,
                  color: Colors.green,
                ),
                const SizedBox(width: 4),
                Text(
                  'Nominal: ',
                  style: GoogleFonts.figtree(fontSize: 13),
                ),
                Text(
                  data.nominal,
                  style: GoogleFonts.figtree(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
                const Spacer(),
                // Status badge berdasarkan jenis
                _buildStatusBadge(
                  data.jenisIuran,
                  data.jenisIuran == 'Iuran Bulanan' ? Colors.blue : Colors.orange,
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '$label:',
            style: GoogleFonts.figtree(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.figtree(fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:jawara_mobile/constants/colors.dart';
import 'package:jawara_mobile/widgets/white_card_page.dart';
import 'package:jawara_mobile/constants/rem.dart';

class DetailLaporanKeuangan extends StatelessWidget {
  final Map<String, dynamic> laporan; // 🟢 properti baru untuk menerima data
  final String title = "Detail Laporan Keuangan";

  const DetailLaporanKeuangan({
    super.key,
    required this.laporan,
  });

  @override
  Widget build(BuildContext context) {
    // Ambil data dari laporan
    final DateTime startDate = laporan['tanggalMulai'] ?? DateTime.now();
    final DateTime endDate = laporan['tanggalSelesai'] ?? DateTime.now();
    final String jenisLaporan = laporan['jenis'] ?? 'Tidak diketahui';
    final double total = laporan['total'] ?? 0.0;

    return WhiteCardPage(
      // title: title,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: Rem.rem1_5,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: Rem.rem2),

        // ====== Detail tanggal mulai ======
        Text(
          'Tanggal Mulai',
          style: TextStyle(fontSize: Rem.rem1, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: Rem.rem1 / 2),
        Text(
          startDate.toLocal().toString().split(' ')[0],
          style: TextStyle(fontSize: Rem.rem1),
        ),
        SizedBox(height: Rem.rem2),

        // ====== Detail tanggal selesai ======
        Text(
          'Tanggal Selesai',
          style: TextStyle(fontSize: Rem.rem1, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: Rem.rem1 / 2),
        Text(
          endDate.toLocal().toString().split(' ')[0],
          style: TextStyle(fontSize: Rem.rem1),
        ),
        SizedBox(height: Rem.rem2),

        // ====== Jenis Laporan ======
        Text(
          'Jenis Laporan',
          style: TextStyle(fontSize: Rem.rem1, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: Rem.rem1 / 2),
        Text(
          jenisLaporan,
          style: TextStyle(fontSize: Rem.rem1),
        ),
        SizedBox(height: Rem.rem2),

        // ====== Total ======
        Text(
          'Total',
          style: TextStyle(fontSize: Rem.rem1, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: Rem.rem1 / 2),
        Text(
          'Rp ${total.toStringAsFixed(2)}',
          style: TextStyle(fontSize: Rem.rem1),
        ),
        SizedBox(height: Rem.rem3),

        // Tombol aksi
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: EdgeInsets.symmetric(
                  horizontal: Rem.rem2,
                  vertical: Rem.rem1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Kembali',
                style: TextStyle(fontSize: Rem.rem1, color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

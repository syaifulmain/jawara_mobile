import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_mobile/constants/colors.dart';
import 'package:jawara_mobile/constants/rem.dart';
import '../../../widgets/white_card_page.dart';

class DetailRumahScreen extends StatelessWidget {
  const DetailRumahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Card 1: Detail Rumah
          WhiteCardPage(
            title: 'Detail Rumah',
            children: [
              const SizedBox(height: Rem.rem1),
              _buildDetailRow('Alamat', 'Jl. Melati No. 12'),
              _buildDetailRow('Status', 'Ditempati'),
            ],
          ),

          const SizedBox(height: Rem.rem2),

          // Card 2: Riwayat Penghuni
          WhiteCardPage(
            title: 'Riwayat Penghuni',
            children: [
              const SizedBox(height: Rem.rem1),
              Center(
                child: Text(
                  'Tidak ada riwayat penghuni',
                  style: GoogleFonts.poppins(
                    fontSize: Rem.rem0_875,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: Rem.rem2),

          // Tombol kembali
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: Rem.rem2,
                  vertical: Rem.rem0_75,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Rem.rem0_5),
                ),
              ),
              child: Text(
                'Kembali',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: Rem.rem2),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Rem.rem1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: GoogleFonts.poppins(
              fontSize: Rem.rem0_875,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: Rem.rem0_5),
          Text(value, style: GoogleFonts.poppins(fontSize: Rem.rem0_875)),
        ],
      ),
    );
  }
}

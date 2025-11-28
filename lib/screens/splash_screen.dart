import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/color_constant.dart';
import '../../constants/rem_constant.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Menggunakan Scaffold agar layouting lebih mudah
    return Scaffold(
      // Gunakan warna primary agar terlihat "penuh"
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Icon (Menggunakan icon yang sama dengan di Login)
            Container(
              padding: const EdgeInsets.all(Rem.rem1),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.menu_book_rounded,
                color: AppColors.primaryColor,
                size: Rem.rem3, // Ukuran lebih besar
              ),
            ),
            const SizedBox(height: Rem.rem1_5),
            // Nama Aplikasi
            Text(
              "Jawara Pintar",
              style: GoogleFonts.figtree(
                fontSize: Rem.rem2,
                fontWeight: FontWeight.w700,
                color: Colors.white, // Teks putih
              ),
            ),
            const SizedBox(height: Rem.rem3),
            // Loading Indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            const SizedBox(height: Rem.rem1),
            Text(
              "Memuat data...",
              style: GoogleFonts.figtree(
                color: Colors.white70,
                fontSize: Rem.rem0_875,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
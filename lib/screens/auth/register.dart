import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_mobile/constants/colors.dart';
import 'package:jawara_mobile/constants/rem.dart';
import 'package:jawara_mobile/widgets/custom_button.dart';
import 'package:jawara_mobile/widgets/custom_dropdown.dart';
import 'package:jawara_mobile/widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      body: Padding(
        padding: const EdgeInsets.all(Rem.rem1_5),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(Rem.rem0_625),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.menu_book_rounded,
                        color: Colors.white,
                        size: Rem.rem1_25,
                      ),
                    ),

                    const SizedBox(width: Rem.rem0_5),

                    Text(
                      "Jawara Pintar",
                      style: GoogleFonts.figtree(
                        fontSize: Rem.rem1_5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: Rem.rem1_5),

                Container(
                  padding: const EdgeInsets.all(Rem.rem1_5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Rem.rem0_75),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.withOpacity(0.05),
                        blurRadius: Rem.rem0_625,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Daftar Akun Anda",
                        style: GoogleFonts.figtree(
                          fontSize: Rem.rem1_5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: Rem.rem0_5),

                      Text(
                        "Lengkapi formulir untuk membuat akun",
                        style: GoogleFonts.figtree(
                          fontSize: Rem.rem0_875,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: Rem.rem1_5),

                      CustomTextField(
                        labelText: "Nama Lengkap",
                        hintText: "Masukkan nama lengkap",
                      ),

                      const SizedBox(height: Rem.rem1),

                      CustomTextField(
                        labelText: "NIK",
                        hintText: "Masukkan NIK sesuai KTP",
                      ),

                      const SizedBox(height: Rem.rem1_5),

                      CustomTextField(
                        labelText: "Email",
                        hintText: "Masukkan email aktif",
                      ),

                      const SizedBox(height: Rem.rem1),

                      CustomTextField(
                        labelText: "No Telepon",
                        hintText: "08xxxxxxxx",
                      ),

                      const SizedBox(height: Rem.rem1_5),

                      CustomTextField(
                        labelText: "Password",
                        hintText: "Masukkan password",
                        obscureText: true,
                      ),

                      const SizedBox(height: Rem.rem1),

                      CustomTextField(
                        labelText: "Konfirmasi Password",
                        hintText: "Masukkan ulang password",
                        obscureText: true,
                      ),

                      const SizedBox(height: Rem.rem1_5),

                      CustomDropdown<String>(
                        labelText: "Jenis Kelamin",
                        hintText: "-- PILIH JENIS KELAMIN --",
                        items: const [
                          DropdownMenuEntry(value: "L", label: "Laki-laki"),
                          DropdownMenuEntry(value: "P", label: "Perempuan"),
                        ],
                      ),

                      Text(
                        "Kalau tidak ada di daftar, silakan isi alamat rumah di bawah ini",
                        style: GoogleFonts.figtree(
                          fontSize: Rem.rem0_875,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: Rem.rem1),

                      CustomTextField(
                        labelText: "Alamat Rumah(jika tidak ada di daftar)",
                        hintText: "Masukkan alamat lengkap",
                      ),

                      const SizedBox(height: Rem.rem1),

                      CustomDropdown<String>(
                        labelText: "Status kepemilikan rumah",
                        hintText: "-- PILIH STATUS --",
                        items: const [
                          DropdownMenuEntry(value: "pemilik", label: "Pemilik"),
                          DropdownMenuEntry(value: "penyewa", label: "Penyewa"),
                        ],
                      ),

                      const SizedBox(height: Rem.rem1),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Foto identitas",
                            style: GoogleFonts.figtree(
                              fontSize: Rem.rem1,
                              fontWeight: FontWeight.normal,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: Rem.rem0_5),

                          Container(
                            width: double.infinity,
                            height: Rem.rem4_5,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(Rem.rem0_5),
                            ),
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                "Upload Foto KK/KTP (.png/.jpg)",
                                style: GoogleFonts.poppins(color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: Rem.rem1_5),

                      CustomButton(
                        onPressed: () {},
                        child: Text(
                          'Buat Akun',
                          style: GoogleFonts.poppins(fontSize: Rem.rem1),
                        ),
                      ),

                      const SizedBox(height: Rem.rem1_5),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Sudah punya akun? ",
                            style: GoogleFonts.figtree(),
                          ),
                          GestureDetector(
                            onTap: () {
                              context.goNamed('login');
                            },
                            child: Text(
                              "Masuk",
                              style: GoogleFonts.figtree(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

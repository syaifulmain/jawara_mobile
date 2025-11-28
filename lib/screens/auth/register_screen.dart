import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/color_constant.dart';
import '../../../constants/rem_constant.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_text_form_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(Rem.rem1),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                      style: GoogleFonts.poppins(
                        fontSize: Rem.rem1_5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Rem.rem1_5),
                Text(
                  "Daftar Akun Anda",
                  style: GoogleFonts.poppins(
                    fontSize: Rem.rem1_5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: Rem.rem0_5),
                Text(
                  "Lengkapi formulir untuk membuat akun",
                  style: GoogleFonts.poppins(
                    fontSize: Rem.rem0_875,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: Rem.rem1),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomTextFormField(
                      labelText: "Nama Lengkap",
                      hintText: "Masukkan nama lengkap",
                    ),

                    const SizedBox(height: Rem.rem1),

                    CustomTextFormField(
                      labelText: "NIK",
                      hintText: "Masukkan NIK sesuai KTP",
                    ),

                    const SizedBox(height: Rem.rem1),

                    CustomTextFormField(
                      labelText: "Email",
                      hintText: "Masukkan email aktif",
                    ),

                    const SizedBox(height: Rem.rem1),

                    CustomTextFormField(
                      labelText: "No Telepon",
                      hintText: "08xxxxxxxx",
                    ),

                    const SizedBox(height: Rem.rem1),

                    CustomTextFormField(
                      labelText: "Password",
                      hintText: "Masukkan password",
                      obscureText: true,
                    ),

                    const SizedBox(height: Rem.rem1),

                    CustomTextFormField(
                      labelText: "Konfirmasi Password",
                      hintText: "Masukkan ulang password",
                      obscureText: true,
                    ),

                    const SizedBox(height: Rem.rem1),

                    CustomDropdown<String>(
                      labelText: "Jenis Kelamin",
                      hintText: "-- PILIH JENIS KELAMIN --",
                      items: const [
                        DropdownMenuEntry(value: "L", label: "Laki-laki"),
                        DropdownMenuEntry(value: "P", label: "Perempuan"),
                      ],
                    ),

                    const SizedBox(height: Rem.rem1),

                    Text(
                      "Kalau tidak ada di daftar, silakan isi alamat rumah di bawah ini",
                      style: GoogleFonts.poppins(
                        fontSize: Rem.rem0_875,
                        color: Colors.grey,
                      ),
                    ),

                    CustomTextFormField(
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
                          style: GoogleFonts.poppins(
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
                          style: GoogleFonts.poppins(),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.goNamed('login');
                          },
                          child: Text(
                            "Masuk",
                            style: GoogleFonts.poppins(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

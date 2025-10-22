import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_mobile/constants/colors.dart';
import 'package:jawara_mobile/constants/rem.dart';
import 'package:jawara_mobile/widgets/custom_button.dart';
import 'package:jawara_mobile/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      body: Padding(
        padding: const EdgeInsets.all(Rem.rem1_5),
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
                      style: GoogleFonts.figtree(
                        fontSize: Rem.rem1_5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: Rem.rem1_5),

                Text(
                  "Selamat Datang",
                  style: GoogleFonts.figtree(
                    fontSize: Rem.rem1_5,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: Rem.rem0_5),

                Text(
                  "Login untuk mengakses sistem Jawara Pintar.",
                  style: GoogleFonts.figtree(
                    fontSize: Rem.rem0_875,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: Rem.rem1),

                Container(
                  padding: const EdgeInsets.all(Rem.rem1_5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Rem.rem0_75),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Masuk ke akun anda",
                        style: GoogleFonts.figtree(
                          fontSize: Rem.rem1_5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: Rem.rem1_5),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            labelText: "Email",
                            hintText: "Masukkan email disini",
                            keyboardType: TextInputType.emailAddress,
                          ),

                          const SizedBox(height: Rem.rem2),

                          CustomTextField(
                            labelText: "Password",
                            hintText: "Masukkan password disini",
                            obscureText: true,
                          ),

                          const SizedBox(height: Rem.rem2),

                          CustomButton(
                            onPressed: () {
                              context.goNamed('admin');
                            },
                            child: Text(
                              'Login',
                              style: GoogleFonts.poppins(fontSize: Rem.rem1),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: Rem.rem1_5),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Belum punya akun? ",
                            style: GoogleFonts.figtree(),
                          ),
                          GestureDetector(
                            onTap: () {
                              context.goNamed('register');
                            },
                            child: Text(
                              "Daftar",
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
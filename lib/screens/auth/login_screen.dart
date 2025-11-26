import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../constants/color_constant.dart';
import '../../../constants/rem_constant.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login gagal. Periksa email dan password Anda.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

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
                  child: Form(
                    key: _formKey,
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
                            CustomTextFormField(
                              labelText: "Email",
                              hintText: "Masukkan email disini",
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email tidak boleh kosong';
                                }
                                if (!value.contains('@')) {
                                  return 'Email tidak valid';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: Rem.rem2),

                            CustomTextFormField(
                              labelText: "Password",
                              hintText: "Masukkan password disini",
                              obscureText: _obscurePassword,
                              controller: _passwordController,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password tidak boleh kosong';
                                }
                                if (value.length < 6) {
                                  return 'Password minimal 6 karakter';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: Rem.rem2),

                            CustomButton(
                              onPressed: authProvider.isLoading
                                  ? null
                                  : _handleLogin,
                              child: authProvider.isLoading
                                  ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                                  : Text(
                                'Login',
                                style: GoogleFonts.poppins(
                                  fontSize: Rem.rem1,
                                ),
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

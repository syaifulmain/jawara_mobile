import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_mobile/constants/colors.dart';
import 'package:jawara_mobile/constants/rem.dart';
import 'package:jawara_mobile/widgets/custom_button.dart';

class RumahTambahScreen extends StatefulWidget {
  const RumahTambahScreen({super.key});

  @override
  State<RumahTambahScreen> createState() => _RumahTambahScreenState();
}

class _RumahTambahScreenState extends State<RumahTambahScreen> {
  // Form controller
  final _alamatController = TextEditingController();

  @override
  void dispose() {
    _alamatController.dispose();
    super.dispose();
  }

  void _submitForm() {
    // TODO: Implementasi submit form
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Rumah berhasil ditambahkan!'),
        backgroundColor: Colors.green,
      ),
    );

    _resetForm();
  }

  void _resetForm() {
    _alamatController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(Rem.rem1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Rem.rem0_75),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(Rem.rem1_5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Tambah Rumah',
              style: GoogleFonts.poppins(
                fontSize: Rem.rem1_25,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: Rem.rem1_5),

            // Form
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Alamat Rumah
                    Text(
                      'Alamat Rumah',
                      style: GoogleFonts.poppins(
                        fontSize: Rem.rem0_875,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: Rem.rem0_5),
                    TextField(
                      controller: _alamatController,
                      style: GoogleFonts.poppins(),
                      decoration: InputDecoration(
                        hintText: 'Contoh: Jl. Melati No. 12',
                        hintStyle: GoogleFonts.poppins(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Rem.rem0_5),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Rem.rem0_5),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Rem.rem0_5),
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: Rem.rem0_75,
                          vertical: Rem.rem0_75,
                        ),
                      ),
                    ),
                    const SizedBox(height: Rem.rem2),

                    // Buttons (Submit & Reset) sama persis seperti KegiatanTambahScreen
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            onPressed: _submitForm,
                            child: Text(
                              'Submit',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: Rem.rem1),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _resetForm,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.grey),
                              padding: const EdgeInsets.symmetric(
                                vertical: Rem.rem0_875,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(Rem.rem0_5),
                              ),
                            ),
                            child: Text(
                              'Reset',
                              style: GoogleFonts.poppins(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w600,
                              ),
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
    );
  }
}

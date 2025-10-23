import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_mobile/constants/colors.dart';
import 'package:jawara_mobile/constants/rem.dart';
import 'package:jawara_mobile/widgets/custom_button.dart';

class BroadcastTambahScreen extends StatefulWidget {
  const BroadcastTambahScreen({super.key});

  @override
  State<BroadcastTambahScreen> createState() => _BroadcastTambahScreenState();
}

class _BroadcastTambahScreenState extends State<BroadcastTambahScreen> {
  final _judulBroadcastController = TextEditingController();
  final _isiBroadcastController = TextEditingController();

  @override
  void dispose() {
    _judulBroadcastController.dispose();
    _isiBroadcastController.dispose();
    super.dispose();
  }

  void _submitForm() {
    // TODO: Implement form submission logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Broadcast berhasil dibuat!'),
        backgroundColor: Colors.green,
      ),
    );
    _resetForm();
  }

  void _resetForm() {
    _judulBroadcastController.clear();
    _isiBroadcastController.clear();
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            // Text(
            //   'Buat Broadcast Baru',
            //   style: GoogleFonts.poppins(
            //     fontSize: Rem.rem1_25,
            //     fontWeight: FontWeight.w600,
            //   ),
            // ),
            // const SizedBox(height: Rem.rem1_5),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Judul Broadcast
                    Text(
                      'Judul Broadcast',
                      style: GoogleFonts.poppins(
                        fontSize: Rem.rem0_875,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: Rem.rem0_5),
                    TextField(
                      controller: _judulBroadcastController,
                      style: GoogleFonts.poppins(),
                      decoration: InputDecoration(
                        hintText: 'Masukkan judul broadcast',
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
                          borderSide:
                              const BorderSide(color: AppColors.primaryColor),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: Rem.rem0_75,
                          vertical: Rem.rem0_75,
                        ),
                      ),
                    ),
                    const SizedBox(height: Rem.rem1),

                    // Isi Broadcast
                    Text(
                      'Isi Broadcast',
                      style: GoogleFonts.poppins(
                        fontSize: Rem.rem0_875,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: Rem.rem0_5),
                    TextField(
                      controller: _isiBroadcastController,
                      maxLines: 6,
                      style: GoogleFonts.poppins(),
                      decoration: InputDecoration(
                        hintText: 'Tulis isi broadcast di sini...',
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
                          borderSide:
                              const BorderSide(color: AppColors.primaryColor),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: Rem.rem0_75,
                          vertical: Rem.rem0_75,
                        ),
                      ),
                    ),
                    const SizedBox(height: Rem.rem1_5),

                    // Upload Foto
                    Text(
                      'Foto',
                      style: GoogleFonts.poppins(
                        fontSize: Rem.rem0_875,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: Rem.rem0_25),
                    Text(
                      'Maksimal 10 gambar (.png / .jpg), ukuran maksimal 5MB per gambar.',
                      style: GoogleFonts.poppins(
                        fontSize: Rem.rem0_75,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: Rem.rem0_5),
                    Container(
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade300,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(Rem.rem0_5),
                        color: Colors.grey.shade50,
                      ),
                      child: InkWell(
                        onTap: () {
                          // TODO: Implementasi upload foto
                        },
                        borderRadius: BorderRadius.circular(Rem.rem0_5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_upload_outlined,
                              size: 32,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(height: Rem.rem0_5),
                            Text(
                              'Upload foto png/jpg',
                              style: GoogleFonts.poppins(
                                color: Colors.grey[600],
                                fontSize: Rem.rem0_875,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: Rem.rem1_5),

                    // Upload Dokumen
                    Text(
                      'Dokumen',
                      style: GoogleFonts.poppins(
                        fontSize: Rem.rem0_875,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: Rem.rem0_25),
                    Text(
                      'Maksimal 10 file (.pdf), ukuran maksimal 5MB per file.',
                      style: GoogleFonts.poppins(
                        fontSize: Rem.rem0_75,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: Rem.rem0_5),
                    Container(
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade300,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(Rem.rem0_5),
                        color: Colors.grey.shade50,
                      ),
                      child: InkWell(
                        onTap: () {
                          // TODO: Implementasi upload dokumen
                        },
                        borderRadius: BorderRadius.circular(Rem.rem0_5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.description_outlined,
                              size: 32,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(height: Rem.rem0_5),
                            Text(
                              'Upload dokumen pdf',
                              style: GoogleFonts.poppins(
                                color: Colors.grey[600],
                                fontSize: Rem.rem0_875,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: Rem.rem2),

                    // Buttons
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
                              side: const BorderSide(
                                color: Colors.grey,
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: Rem.rem0_875,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  Rem.rem0_5,
                                ),
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

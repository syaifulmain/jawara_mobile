import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_mobile/constants/colors.dart';
import 'package:jawara_mobile/constants/rem.dart';
import '../../../widgets/white_card_page.dart';

class DetailKeluargaScreen extends StatelessWidget {
  const DetailKeluargaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> anggotaKeluarga = [
      {
        'nama': 'John Doe',
        'nik': '1234567890123456',
        'peran': 'Kepala Keluarga',
        'jenisKelamin': 'Laki-laki',
        'tanggalLahir': '12/08/1990',
        'status': 'Aktif',
      },
      {
        'nama': 'Jane Doe',
        'nik': '9876543210987654',
        'peran': 'Istri',
        'jenisKelamin': 'Perempuan',
        'tanggalLahir': '20/04/1992',
        'status': 'Aktif',
      },
      {
        'nama': 'Alex Doe',
        'nik': '1122334455667788',
        'peran': 'Anak',
        'jenisKelamin': 'Laki-laki',
        'tanggalLahir': '05/03/2012',
        'status': 'Pelajar',
      },
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          WhiteCardPage(
            title: 'Detail Keluarga',
            children: [
              const SizedBox(height: Rem.rem1),

              // Informasi keluarga utama
              _buildDetailRow('Nama Keluarga', 'Keluarga Doe'),
              _buildDetailRow('Kepala Keluarga', 'John Doe'),
              _buildDetailRow('Rumah Saat Ini', 'Jl. Melati No. 12'),
              _buildDetailRow('Status Kepemilikan', 'Milik Sendiri'),
              _buildDetailRow('Status Keluarga', 'Aktif'),

              const SizedBox(height: Rem.rem1_5),

              // Header anggota keluarga
              Text(
                'Anggota Keluarga',
                style: GoogleFonts.poppins(
                  fontSize: Rem.rem1,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: Rem.rem1),

              // List anggota keluarga
              Column(
                children: anggotaKeluarga.map((anggota) {
                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: Rem.rem1),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(Rem.rem0_75),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(Rem.rem1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Nama anggota
                          Text(
                            anggota['nama'] ?? '',
                            style: GoogleFonts.poppins(
                              fontSize: Rem.rem1,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          const SizedBox(height: Rem.rem0_75),

                          _buildDetailRow('NIK', anggota['nik'] ?? ''),
                          _buildDetailRow('Peran', anggota['peran'] ?? ''),
                          _buildDetailRow(
                            'Jenis Kelamin',
                            anggota['jenisKelamin'] ?? '',
                          ),
                          _buildDetailRow(
                            'Tanggal Lahir',
                            anggota['tanggalLahir'] ?? '',
                          ),
                          _buildDetailRow('Status', anggota['status'] ?? ''),
                        ],
                      ),
                    ),
                  );
                }).toList(),
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
      padding: const EdgeInsets.only(bottom: Rem.rem0_75),
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
          const SizedBox(height: Rem.rem0_25),
          Text(value, style: GoogleFonts.poppins(fontSize: Rem.rem0_875)),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_mobile/constants/colors.dart';
import 'package:jawara_mobile/constants/rem.dart';
import 'package:jawara_mobile/widgets/custom_button.dart';
import 'package:jawara_mobile/widgets/custom_dropdown.dart';
import 'package:jawara_mobile/widgets/custom_text_field.dart';

import '../../../widgets/custom_select_calender.dart';

class WargaTambahScreen extends StatelessWidget {
  const WargaTambahScreen({super.key});
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
                Container(
                  padding: const EdgeInsets.all(Rem.rem1_5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Rem.rem0_75),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.withValues(alpha: 0.05),
                        blurRadius: Rem.rem0_625,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomDropdown<String>(
                        labelText: "Pilih Keluarga",
                        hintText: "-- PILIH KELUARGA --",
                        items: const [
                          DropdownMenuEntry(value: 'k1', label: 'Keluarga '),
                          DropdownMenuEntry(value: "P", label: "Perempuan"),
                        ],
                      ),

                      const SizedBox(height: Rem.rem1_5),

                      CustomTextField(
                        labelText: "Nama Lengkap",
                        hintText: "Masukkan nama lengkap",
                      ),

                      const SizedBox(height: Rem.rem1_5),

                      CustomTextField(
                        labelText: "NIK",
                        hintText: "Masukkan NIK sesuai KTP",
                      ),

                      const SizedBox(height: Rem.rem1_5),

                      CustomTextField(
                        labelText: "No Telepon",
                        hintText: "08xxxxxxxx",
                      ),

                      const SizedBox(height: Rem.rem1_5),

                      CustomTextField(
                        labelText: "Tempat Lahir",
                        hintText: "Masukkan tempat lahir",
                      ),

                      const SizedBox(height: Rem.rem1_5),

                      CustomSelectCalendar(
                        labelText: "Tanggal Lahir",
                        hintText: "Pilih tanggal lahir",
                          onDateSelected: (DateTime selectedDate) {
                            // Handle the selected date here
                          },
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

                      const SizedBox(height: Rem.rem1_5),

                      CustomDropdown<String>(
                        labelText: "AGAMA",
                        hintText: "-- PILIH AGAMA --",
                        items: const [
                          DropdownMenuEntry(value: "islam", label: "Islam"),
                          DropdownMenuEntry(value: "kristen", label: "Kristen"),
                          DropdownMenuEntry(value: "katolik", label: "Katolik"),
                          DropdownMenuEntry(value: "hindu", label: "Hindu"),
                          DropdownMenuEntry(value: "buddha", label: "Buddha"),
                          DropdownMenuEntry(value: "konghucu", label: "Konghucu"),
                        ],
                      ),

                      const SizedBox(height: Rem.rem1_5),

                      CustomDropdown<String>(
                        labelText: "Golongan Darah",
                        hintText: "-- PILIH GOLONGAN DARAH --",
                        items: const [
                          DropdownMenuEntry(value: "A", label: "A"),
                          DropdownMenuEntry(value: "B", label: "B"),
                          DropdownMenuEntry(value: "AB", label: "AB"),
                          DropdownMenuEntry(value: "O", label: "O"),
                          DropdownMenuEntry(value: "tidak_tahu", label: "Tidak Tahu"),
                        ],
                      ),

                      const SizedBox(height: Rem.rem1_5),

                      CustomDropdown<String>(
                        labelText: "Peran Keluarga",
                        hintText: "-- PILIH PERAN KELUARGA --",
                        items: const [
                          DropdownMenuEntry(value: "kepala_keluarga", label: "Kepala Keluarga"),
                          DropdownMenuEntry(value: "istri", label: "Istri"),
                          DropdownMenuEntry(value: "anak", label: "Anak"),
                        ],
                      ),

                      const SizedBox(height: Rem.rem1_5),

                      CustomDropdown<String>(
                        labelText: "Pendidikan Terakhir",
                        hintText: "-- PILIH PENDIDIKAN --",
                        items: const [
                          DropdownMenuEntry(value: "tidak_sekolah", label: "Tidak/Belum Sekolah"),
                          DropdownMenuEntry(value: "sd", label: "SD/Sederajat"),
                          DropdownMenuEntry(value: "smp", label: "SMP/Sederajat"),
                          DropdownMenuEntry(value: "sma", label: "SMA/Sederajat"),
                          DropdownMenuEntry(value: "d1-d3", label: "Diploma (D1-D3)"),
                          DropdownMenuEntry(value: "s1", label: "Sarjana (S1)"),
                          DropdownMenuEntry(value: "s2", label: "Magister (S2)"),
                          DropdownMenuEntry(value: "s3", label: "Doktor (S3)"),
                        ],
                      ),

                      const SizedBox(height: Rem.rem1_5),

                      CustomDropdown<String>(
                        labelText: "Pekerjaan",
                        hintText: "-- PILIH PEKERJAAN --",
                        items: const [
                          DropdownMenuEntry(value: "tidak_bekerja", label: "Belum/Tidak Bekerja"),
                          DropdownMenuEntry(value: "pelajar", label: "Pelajar/Mahasiswa"),
                          DropdownMenuEntry(value: "pns", label: "PNS"),
                          DropdownMenuEntry(value: "tni_polri", label: "TNI/POLRI"),
                          DropdownMenuEntry(value: "swasta", label: "Karyawan Swasta"),
                          DropdownMenuEntry(value: "wiraswasta", label: "Wiraswasta"),
                          DropdownMenuEntry(value: "petani", label: "Petani"),
                          DropdownMenuEntry(value: "lainnya", label: "Lainnya"),
                        ],
                      ),

                      const SizedBox(height: Rem.rem1_5),

                      CustomDropdown<String>(
                        labelText: "Status Perkawinan",
                        hintText: "-- PILIH STATUS --",
                        items: const [
                          DropdownMenuEntry(value: "belum_kawin", label: "Belum Kawin"),
                          DropdownMenuEntry(value: "kawin", label: "Kawin"),
                          DropdownMenuEntry(value: "cerai_hidup", label: "Cerai Hidup"),
                          DropdownMenuEntry(value: "cerai_mati", label: "Cerai Mati"),
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

                      const SizedBox(height: Rem.rem1),

                      CustomButton(
                          backgroundColor: Colors.grey,
                        onPressed: () {},
                        child: Text(
                          'Reset',
                          style: GoogleFonts.poppins(fontSize: Rem.rem1),
                        ),
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

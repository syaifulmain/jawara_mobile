import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_mobile/constants/colors.dart';
import 'package:jawara_mobile/constants/rem.dart';
import 'package:jawara_mobile/data/data_warga_data.dart';
import 'package:jawara_mobile/widgets/custom_button.dart';
import 'package:jawara_mobile/widgets/custom_dropdown.dart';
import 'package:jawara_mobile/widgets/custom_text_field.dart';

import '../../../widgets/custom_select_calender.dart';

class WargaTambahScreen extends StatefulWidget {
  const WargaTambahScreen({super.key});

  @override
  State<WargaTambahScreen> createState() => _WargaTambahScreenState();
}

class _WargaTambahScreenState extends State<WargaTambahScreen> {
  // --- State Management for Form Fields ---

  // Controllers for TextFields
  final _namaController = TextEditingController();
  final _nikController = TextEditingController();
  final _teleponController = TextEditingController();
  final _tempatLahirController = TextEditingController();

  // Variables for Dropdowns and Calendar
  String? _selectedKeluarga;
  DateTime? _selectedTanggalLahir;
  String? _selectedJenisKelamin;
  String? _selectedAgama;
  String? _selectedGolonganDarah;
  String? _selectedPeranKeluarga;
  String? _selectedPendidikan;
  String? _selectedPekerjaan;
  String? _selectedStatusPerkawinan;

  @override
  void dispose() {
    // Dispose controllers to free up resources
    _namaController.dispose();
    _nikController.dispose();
    _teleponController.dispose();
    _tempatLahirController.dispose();
    super.dispose();
  }

  /// Handles the form submission.
  void _submitForm() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data Warga berhasil ditambahkan!'),
        backgroundColor: Colors.green,
      ),
    );

    _resetForm();
  }

  /// Resets all form fields to their initial state.
  void _resetForm() {
    setState(() {
      _namaController.clear();
      _nikController.clear();
      _teleponController.clear();
      _tempatLahirController.clear();

      _selectedKeluarga = null;
      _selectedTanggalLahir = null;
      _selectedJenisKelamin = null;
      _selectedAgama = null;
      _selectedGolonganDarah = null;
      _selectedPeranKeluarga = null;
      _selectedPendidikan = null;
      _selectedPekerjaan = null;
      _selectedStatusPerkawinan = null;
    });
  }

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
                        color: Colors.black12.withOpacity(0.05),
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
                          DropdownMenuEntry(value: 'k1', label: 'Keluarga Ridwan'),
                          DropdownMenuEntry(value: "k2", label: "Keluarga Budi"),
                          DropdownMenuEntry(value: "k3", label: "Keluarga Ani"),
                          DropdownMenuEntry(value: "k4", label: "Keluarga Indah"),
                        ],
                        initialSelection: _selectedKeluarga,
                        onSelected: (value) {
                          setState(() {
                            _selectedKeluarga = value;
                          });
                        },
                      ),

                      const SizedBox(height: Rem.rem1_5),

                      CustomTextField(
                        controller: _namaController,
                        labelText: "Nama Lengkap",
                        hintText: "Masukkan nama lengkap",
                      ),

                      const SizedBox(height: Rem.rem1_5),

                      CustomTextField(
                        controller: _nikController,
                        labelText: "NIK",
                        hintText: "Masukkan NIK sesuai KTP",
                      ),

                      const SizedBox(height: Rem.rem1_5),

                      CustomTextField(
                        controller: _teleponController,
                        labelText: "No Telepon",
                        hintText: "08xxxxxxxx",
                      ),

                      const SizedBox(height: Rem.rem1_5),

                      CustomTextField(
                        controller: _tempatLahirController,
                        labelText: "Tempat Lahir",
                        hintText: "Masukkan tempat lahir",
                      ),

                      const SizedBox(height: Rem.rem1_5),

                      CustomSelectCalendar(
                        labelText: "Tanggal Lahir",
                        hintText: "Pilih tanggal lahir",
                        initialDate: _selectedTanggalLahir,
                        onDateSelected: (DateTime selectedDate) {
                          setState(() {
                            _selectedTanggalLahir = selectedDate;
                          });
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
                        initialSelection: _selectedJenisKelamin,
                        onSelected: (value) {
                          setState(() {
                            _selectedJenisKelamin = value;
                          });
                        },
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
                        initialSelection: _selectedAgama,
                        onSelected: (value) {
                          setState(() {
                            _selectedAgama = value;
                          });
                        },
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
                        initialSelection: _selectedGolonganDarah,
                        onSelected: (value) {
                          setState(() {
                            _selectedGolonganDarah = value;
                          });
                        },
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
                        initialSelection: _selectedPeranKeluarga,
                        onSelected: (value) {
                          setState(() {
                            _selectedPeranKeluarga = value;
                          });
                        },
                      ),

                      const SizedBox(height: Rem.rem1_5),

                      CustomDropdown<String>(
                        labelText: "Pendidikan Terakhir",
                        hintText: "-- PILIH PENDIDIKAN --",
                        items: const [
                          DropdownMenuEntry(value: "tidak_sekolah", label: "Tidak/Belum Sekolah"),
                          DropdownMenuEntry(value: "SD", label: "SD/Sederajat"),
                          DropdownMenuEntry(value: "SMP", label: "SMP/Sederajat"),
                          DropdownMenuEntry(value: "SMA", label: "SMA/Sederajat"),
                          DropdownMenuEntry(value: "S1", label: "Sarjana (S1)"),
                          DropdownMenuEntry(value: "S2", label: "Magister (S2)"),
                          DropdownMenuEntry(value: "S3", label: "Doktor (S3)"),
                        ],
                        initialSelection: _selectedPendidikan,
                        onSelected: (value) {
                          setState(() {
                            _selectedPendidikan = value;
                          });
                        },
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
                        initialSelection: _selectedPekerjaan,
                        onSelected: (value) {
                          setState(() {
                            _selectedPekerjaan = value;
                          });
                        },
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
                        initialSelection: _selectedStatusPerkawinan,
                        onSelected: (value) {
                          setState(() {
                            _selectedStatusPerkawinan = value;
                          });
                        },
                      ),

                      const SizedBox(height: Rem.rem1_5),

                      CustomButton(
                        onPressed: _submitForm, // Connect to submit function
                        child: Text(
                          'Simpan',
                          style: GoogleFonts.poppins(fontSize: Rem.rem1),
                        ),
                      ),

                      const SizedBox(height: Rem.rem1),

                      CustomButton(
                        backgroundColor: Colors.grey,
                        onPressed: _resetForm, // Connect to reset function
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

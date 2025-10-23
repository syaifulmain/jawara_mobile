import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_mobile/constants/colors.dart';
import 'package:jawara_mobile/constants/rem.dart';
import 'package:jawara_mobile/widgets/custom_button.dart';
import 'package:jawara_mobile/widgets/custom_dropdown.dart';
import 'package:jawara_mobile/widgets/custom_text_field.dart';

import '../../../models/data_warga_model.dart';
import '../../../widgets/custom_select_calender.dart';

// Converted to a StatefulWidget to manage form state with TextEditingControllers.
class WargaDetailScreen extends StatefulWidget {
  final DataWargaModel dataWarga;

  const WargaDetailScreen({super.key, required this.dataWarga});

  @override
  State<WargaDetailScreen> createState() => _WargaDetailScreenState();
}

class _WargaDetailScreenState extends State<WargaDetailScreen> {
  // Controllers for text fields to pre-fill them with existing data.
  late TextEditingController _namaController;
  late TextEditingController _nikController;
  late TextEditingController _teleponController;
  late TextEditingController _tempatLahirController;

  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with data from the dataWarga model.
    _namaController = TextEditingController(text: widget.dataWarga.nama);
    _nikController = TextEditingController(text: widget.dataWarga.nik);
    _teleponController = TextEditingController(
      text: widget.dataWarga.nomorTelepon,
    );
    _tempatLahirController = TextEditingController(
      text: widget.dataWarga.tempatLahir,
    );
    _selectedDate = DateFormat(
      "dd-MM-yyyy",
    ).parse(widget.dataWarga.tanggalLahir);
  }

  @override
  void dispose() {
    // Dispose controllers to free up resources.
    _namaController.dispose();
    _nikController.dispose();
    _teleponController.dispose();
    _tempatLahirController.dispose();
    super.dispose();
  }

  void _submitForm() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data Warga berhasil Diperbarui!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _deleteData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data Warga berhasil Dihapus!'),
        backgroundColor: Colors.red,
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      body: Padding(
        padding: const EdgeInsets.all(Rem.rem1_5),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(Rem.rem1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // The family dropdown is pre-filled using initialSelection.
                    CustomDropdown<String>(
                      labelText: "Pilih Keluarga",
                      hintText: "-- PILIH KELUARGA --",
                      items: const [
                        DropdownMenuEntry(
                          value: 'k1',
                          label: 'Keluarga Ridwan',
                        ),
                        DropdownMenuEntry(
                          value: "k2",
                          label: "Keluarga Budi",
                        ),
                        DropdownMenuEntry(value: "k3", label: "Keluarga Ani"),
                        DropdownMenuEntry(
                          value: "k4",
                          label: "Keluarga Indah",
                        ),
                      ],
                      initialSelection:
                          widget.dataWarga.keluarga, // Example value
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
                      initialDate: _selectedDate, // Pass initial date
                      onDateSelected: (DateTime selectedDate) {
                        setState(() {
                          _selectedDate = selectedDate;
                        });
                      },
                    ),

                    const SizedBox(height: Rem.rem1_5),

                    CustomDropdown<String>(
                      labelText: "Jenis Kelamin",
                      hintText: "-- PILIH JENIS KELAMIN --",
                      initialSelection: widget.dataWarga.jenisKelamin,
                      items: const [
                        DropdownMenuEntry(value: "L", label: "Laki-laki"),
                        DropdownMenuEntry(value: "P", label: "Perempuan"),
                      ],
                    ),

                    const SizedBox(height: Rem.rem1_5),

                    CustomDropdown<String>(
                      labelText: "AGAMA",
                      hintText: "-- PILIH AGAMA --",
                      initialSelection: widget.dataWarga.agama,
                      items: const [
                        DropdownMenuEntry(value: "islam", label: "Islam"),
                        DropdownMenuEntry(value: "kristen", label: "Kristen"),
                        DropdownMenuEntry(value: "katolik", label: "Katolik"),
                        DropdownMenuEntry(value: "hindu", label: "Hindu"),
                        DropdownMenuEntry(value: "buddha", label: "Buddha"),
                        DropdownMenuEntry(
                          value: "konghucu",
                          label: "Konghucu",
                        ),
                      ],
                    ),

                    const SizedBox(height: Rem.rem1_5),

                    CustomDropdown<String>(
                      labelText: "Golongan Darah",
                      hintText: "-- PILIH GOLONGAN DARAH --",
                      initialSelection: widget.dataWarga.golonganDarah,
                      items: const [
                        DropdownMenuEntry(value: "A", label: "A"),
                        DropdownMenuEntry(value: "B", label: "B"),
                        DropdownMenuEntry(value: "AB", label: "AB"),
                        DropdownMenuEntry(value: "O", label: "O"),
                        DropdownMenuEntry(
                          value: "tidak_tahu",
                          label: "Tidak Tahu",
                        ),
                      ],
                    ),

                    const SizedBox(height: Rem.rem1_5),

                    CustomDropdown<String>(
                      labelText: "Peran Keluarga",
                      hintText: "-- PILIH PERAN KELUARGA --",
                      initialSelection: widget.dataWarga.peranDalamKeluarga,
                      items: const [
                        DropdownMenuEntry(
                          value: "kepala_keluarga",
                          label: "Kepala Keluarga",
                        ),
                        DropdownMenuEntry(value: "istri", label: "Istri"),
                        DropdownMenuEntry(value: "anak", label: "Anak"),
                      ],
                    ),

                    const SizedBox(height: Rem.rem1_5),

                    CustomDropdown<String>(
                      labelText: "Pendidikan Terakhir",
                      hintText: "-- PILIH PENDIDIKAN --",
                      initialSelection: widget.dataWarga.pendidikanTerakhir,
                      items: const [
                        DropdownMenuEntry(
                          value: "tidak_sekolah",
                          label: "Tidak/Belum Sekolah",
                        ),
                        DropdownMenuEntry(value: "SD", label: "SD/Sederajat"),
                        DropdownMenuEntry(
                          value: "SMP",
                          label: "SMP/Sederajat",
                        ),
                        DropdownMenuEntry(
                          value: "SMA",
                          label: "SMA/Sederajat",
                        ),
                        DropdownMenuEntry(value: "S1", label: "Sarjana (S1)"),
                        DropdownMenuEntry(
                          value: "S2",
                          label: "Magister (S2)",
                        ),
                        DropdownMenuEntry(value: "S3", label: "Doktor (S3)"),
                      ],
                    ),

                    const SizedBox(height: Rem.rem1_5),

                    CustomDropdown<String>(
                      labelText: "Pekerjaan",
                      hintText: "-- PILIH PEKERJAAN --",
                      initialSelection: widget.dataWarga.pekerjaan,
                      items: const [
                        DropdownMenuEntry(
                          value: "tidak_bekerja",
                          label: "Belum/Tidak Bekerja",
                        ),
                        DropdownMenuEntry(
                          value: "pelajar",
                          label: "Pelajar/Mahasiswa",
                        ),
                        DropdownMenuEntry(value: "pns", label: "PNS"),
                        DropdownMenuEntry(
                          value: "tni_polri",
                          label: "TNI/POLRI",
                        ),
                        DropdownMenuEntry(
                          value: "swasta",
                          label: "Karyawan Swasta",
                        ),
                        DropdownMenuEntry(
                          value: "wiraswasta",
                          label: "Wiraswasta",
                        ),
                        DropdownMenuEntry(value: "petani", label: "Petani"),
                        DropdownMenuEntry(value: "lainnya", label: "Lainnya"),
                      ],
                    ),

                    const SizedBox(height: Rem.rem1_5),

                    CustomDropdown<String>(
                      labelText: "Status Perkawinan",
                      hintText: "-- PILIH STATUS --",
                      initialSelection: widget.dataWarga.statusPenduduk,
                      items: const [
                        DropdownMenuEntry(
                          value: "belum_kawin",
                          label: "Belum Kawin",
                        ),
                        DropdownMenuEntry(value: "kawin", label: "Kawin"),
                        DropdownMenuEntry(
                          value: "cerai_hidup",
                          label: "Cerai Hidup",
                        ),
                        DropdownMenuEntry(
                          value: "cerai_mati",
                          label: "Cerai Mati",
                        ),
                      ],
                    ),

                    const SizedBox(height: Rem.rem1_5),

                    // Updated button text for saving changes.
                    CustomButton(
                      onPressed: () {
                        _submitForm();
                      },
                      child: Text(
                        'Simpan Perubahan',
                        style: GoogleFonts.poppins(fontSize: Rem.rem1),
                      ),
                    ),

                    const SizedBox(height: Rem.rem1),

                    CustomButton(
                      backgroundColor: Colors.red,
                      onPressed: () {
                        _deleteData();
                      },
                      child: Text(
                        'Hapus Data',
                        style: GoogleFonts.poppins(fontSize: Rem.rem1),
                      ),
                    ),

                    const SizedBox(height: Rem.rem1),

                    CustomButton(
                      backgroundColor: Colors.grey,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Kembali',
                        style: GoogleFonts.poppins(fontSize: Rem.rem1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

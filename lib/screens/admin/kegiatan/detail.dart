import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_mobile/constants/colors.dart';
import 'package:jawara_mobile/constants/rem.dart';
import 'package:jawara_mobile/widgets/custom_button.dart';
import 'package:jawara_mobile/widgets/custom_dropdown.dart';
import 'package:jawara_mobile/widgets/custom_image_display.dart';
import 'package:jawara_mobile/widgets/custom_text_field.dart';

import '../../../models/data_kegiatan_model.dart';
import '../../../widgets/custom_select_calender.dart';

// Converted to a StatefulWidget to manage form state with TextEditingControllers.
class KegiatanDetailScreen extends StatefulWidget {
  final DataKegiatanModel dataKegiatan;

  const KegiatanDetailScreen({super.key, required this.dataKegiatan});

  @override
  State<KegiatanDetailScreen> createState() => _KegiatanDetailScreenState();
}

class _KegiatanDetailScreenState extends State<KegiatanDetailScreen> {
  late TextEditingController _namaKegiatanController;
  late TextEditingController _kategoriController;
  late TextEditingController _lokasiController;
  late TextEditingController _penanggungJawabController;
  late TextEditingController _deskripsiController;
  late TextEditingController _dokumentasiController;
  late TextEditingController _dibuatOlehController;

  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _namaKegiatanController = TextEditingController(
      text: widget.dataKegiatan.nama_kegiatan,
    );
    _kategoriController = TextEditingController(
      text: widget.dataKegiatan.kategori,
    );
    _penanggungJawabController = TextEditingController(
      text: widget.dataKegiatan.penanggung_jawab,
    );
    _lokasiController = TextEditingController(text: widget.dataKegiatan.lokasi);
    _deskripsiController = TextEditingController(
      text: widget.dataKegiatan.deskripsi,
    );
    _dokumentasiController = TextEditingController(
      text: widget.dataKegiatan.dokumentasi,
    );
    _selectedDate = DateFormat(
      "dd-MM-yyyy",
    ).parse(widget.dataKegiatan.tanggal_pelaksanaan);
  }

  @override
  void dispose() {
    // Dispose controllers to free up resources.
    _namaKegiatanController.dispose();
    _kategoriController.dispose();
    _lokasiController.dispose();
    _penanggungJawabController.dispose();
    _deskripsiController.dispose();
    _dokumentasiController.dispose();
    _dibuatOlehController.dispose();
    super.dispose();
  }

  void _submitForm() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data Kegiatan berhasil Diperbarui!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _deleteData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data Kegiatan berhasil Dihapus!'),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Detail Kegiatan',
                      style: GoogleFonts.figtree(
                        fontSize: Rem.rem1_5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: Rem.rem1_25),
                    CustomTextField(
                      controller: _namaKegiatanController,
                      labelText: "Nama Kegiatan",
                      hintText: "Masukkan Nama Kegiatan",
                    ),
                    const SizedBox(height: Rem.rem1_5),
                    CustomDropdown<String>(
                      labelText: "Pilih Kategori Kegiatan",
                      hintText: widget.dataKegiatan.kategori,
                      items: const [
                        DropdownMenuEntry(
                          value: 'k1',
                          label: 'Komunitas & Sosial',
                        ),
                        DropdownMenuEntry(
                          value: "k2",
                          label: "Kebersihan & Keamanan",
                        ),
                        DropdownMenuEntry(value: "k3", label: "Keagamaan"),
                        DropdownMenuEntry(value: "k4", label: "Pendidikan"),
                        DropdownMenuEntry(
                          value: "k5",
                          label: "Kesehatan & Olahraga",
                        ),
                        DropdownMenuEntry(value: "k6", label: "Lainnya"),
                      ],
                      initialSelection: widget.dataKegiatan.kategori, // Set initial selection
                    ),

                    const SizedBox(height: Rem.rem1_25),
                    CustomSelectCalendar(
                      labelText: "Tanggal Pelaksanaan",
                      hintText: "Pilih Tanggal Pelaksanaan",
                      initialDate: _selectedDate, // Pass initial date
                      onDateSelected: (DateTime selectedDate) {
                        setState(() {
                          _selectedDate = selectedDate;
                        });
                      },
                    ),
                    const SizedBox(height: Rem.rem1),
                    CustomTextField(
                      controller: _lokasiController,
                      labelText: "Lokasi",
                      hintText: "Masukkan Lokasi",
                    ),
                    const SizedBox(height: Rem.rem1),
                    CustomTextField(
                      controller: _penanggungJawabController,
                      labelText: "Penanggung Jawab",
                      hintText: "Masukkan Penanggung Jawab",
                    ),
                    const SizedBox(height: Rem.rem1),
                    CustomTextField(
                      controller: _deskripsiController,
                      labelText: "Deskripsi",
                      hintText: "Masukkan deskripsi lengkap",
                      keyboardType: TextInputType.multiline,
                      minLines: 4,
                      maxLines: 6,
                    ),
                    const SizedBox(height: Rem.rem1),
                    CustomImageDisplay(
                      label: "Dokumentasi Kegiatan",
                      imagePath: 'images/test.png',
                      onEdit: () {
                        _showImagePickerModal();
                      },
                    ),
                    const SizedBox(height: Rem.rem1),
                    Text(
                      'Dibuat Oleh',
                      style: GoogleFonts.poppins(fontSize: Rem.rem0_75),
                    ),
                    Text(
                      widget.dataKegiatan.dibuat_oleh,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: Rem.rem1,
                      ),
                    ),

                    const SizedBox(height: Rem.rem1_5),

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

  void _showImagePickerModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Ambil Foto'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implementasi camera
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library), 
              title: Text('Pilih dari Gallery'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implementasi gallery picker
              },
            ),
          ],
        ),
      ),
    );
  }

}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_mobile/constants/colors.dart';
import 'package:jawara_mobile/constants/rem.dart';
import 'package:jawara_mobile/widgets/custom_button.dart';
import 'package:jawara_mobile/widgets/custom_dropdown.dart';

class KegiatanTambahScreen extends StatefulWidget {
  const KegiatanTambahScreen({super.key});

  @override
  State<KegiatanTambahScreen> createState() => _KegiatanTambahScreenState();
}

class _KegiatanTambahScreenState extends State<KegiatanTambahScreen> {
  // Form controllers
  final _namaKegiatanController = TextEditingController();
  final _lokasiController = TextEditingController();
  final _penanggungJawabController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _tanggalController = TextEditingController();

  String? _selectedKategori;
  DateTime? _selectedDate;

  // Kategori kegiatan options
  final List<String> _kategoriOptions = [
    'Komunitas & Sosial',
    'Pendidikan',
    'Kesehatan',
    'Lingkungan',
    'Ekonomi',
    'Budaya',
    'Olahraga',
    'Keagamaan',
  ];

  @override
  void dispose() {
    _namaKegiatanController.dispose();
    _lokasiController.dispose();
    _penanggungJawabController.dispose();
    _deskripsiController.dispose();
    _tanggalController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _tanggalController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _submitForm() {
    // TODO: Implementasi submit form
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kegiatan berhasil ditambahkan!'),
        backgroundColor: Colors.green,
      ),
    );

    // Reset form
    _resetForm();
  }

  void _resetForm() {
    _namaKegiatanController.clear();
    _lokasiController.clear();
    _penanggungJawabController.clear();
    _deskripsiController.clear();
    _tanggalController.clear();
    setState(() {
      _selectedKategori = null;
      _selectedDate = null;
    });
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
            // Text(
            //   'Buat Kegiatan Baru',
            //   style: GoogleFonts.poppins(
            //     fontSize: Rem.rem1_25,
            //     fontWeight: FontWeight.w600,
            //   ),
            // ),
            // const SizedBox(height: Rem.rem1_5),

            // Form
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama Kegiatan
                    Text(
                      'Nama Kegiatan',
                      style: GoogleFonts.poppins(
                        fontSize: Rem.rem0_875,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: Rem.rem0_5),
                    TextField(
                      controller: _namaKegiatanController,
                      style: GoogleFonts.poppins(),
                      decoration: InputDecoration(
                        hintText: 'Contoh: Musyawarah Warga',
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

                    // Kategori Kegiatan
                    Text(
                      'Kategori kegiatan',
                      style: GoogleFonts.poppins(
                        fontSize: Rem.rem0_875,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: Rem.rem0_5),
                    CustomDropdown<String>(
                      initialSelection: _selectedKategori,
                      hintText: '-- Pilih Kategori --',
                      items: _kategoriOptions.map((kategori) {
                        return DropdownMenuEntry<String>(
                          value: kategori,
                          label: kategori,
                        );
                      }).toList(),
                      onSelected: (value) {
                        setState(() {
                          _selectedKategori = value;
                        });
                      },
                    ),
                    const SizedBox(height: Rem.rem1),

                    // Tanggal
                    Text(
                      'Tanggal',
                      style: GoogleFonts.poppins(
                        fontSize: Rem.rem0_875,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: Rem.rem0_5),
                    TextField(
                      controller: _tanggalController,
                      readOnly: true,
                      style: GoogleFonts.poppins(),
                      decoration: InputDecoration(
                        hintText: '--/--/---- ',
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
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: _selectDate,
                        ),
                      ),
                    ),
                    const SizedBox(height: Rem.rem1),

                    // Lokasi
                    Text(
                      'Lokasi',
                      style: GoogleFonts.poppins(
                        fontSize: Rem.rem0_875,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: Rem.rem0_5),
                    TextField(
                      controller: _lokasiController,
                      style: GoogleFonts.poppins(),
                      decoration: InputDecoration(
                        hintText: 'Contoh: Balai RT 03',
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

                    // Penanggung Jawab
                    Text(
                      'Penanggung Jawab',
                      style: GoogleFonts.poppins(
                        fontSize: Rem.rem0_875,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: Rem.rem0_5),
                    TextField(
                      controller: _penanggungJawabController,
                      style: GoogleFonts.poppins(),
                      decoration: InputDecoration(
                        hintText: 'Contoh: Pak RT atau Bu RW',
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

                    // Deskripsi
                    Text(
                      'Deskripsi',
                      style: GoogleFonts.poppins(
                        fontSize: Rem.rem0_875,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: Rem.rem0_5),
                    TextField(
                      controller: _deskripsiController,
                      maxLines: 5,
                      style: GoogleFonts.poppins(),
                      decoration: InputDecoration(
                        hintText:
                            'Tuliskan detail event seperti agenda, keperluan, dll.',
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

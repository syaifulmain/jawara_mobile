import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_mobile/constants/colors.dart';
import 'package:jawara_mobile/constants/rem.dart';
import 'package:jawara_mobile/widgets/custom_button.dart';
import 'package:jawara_mobile/widgets/custom_dropdown.dart';

class WargaTambahScreen extends StatefulWidget {
  const WargaTambahScreen({super.key});

  @override
  State<WargaTambahScreen> createState() => _WargaTambahScreenState();
}

class _WargaTambahScreenState extends State<WargaTambahScreen> {
  // Controllers
  final _namaController = TextEditingController();
  final _nikController = TextEditingController();
  final _noTelpController = TextEditingController();
  final _tempatLahirController = TextEditingController();
  final _tanggalLahirController = TextEditingController();

  // Dropdown selections
  String? _selectedKeluarga;
  String? _selectedJenisKelamin;
  String? _selectedAgama;
  String? _selectedGolonganDarah;
  String? _selectedPeranKeluarga;
  String? _selectedPendidikan;
  String? _selectedPekerjaan;
  String? _selectedStatus;

  DateTime? _selectedDate;

  // Sample options
  final List<String> _keluargaOptions = ['Keluarga Santoso', 'Keluarga Wijaya'];
  final List<String> _jenisKelaminOptions = ['Laki-laki', 'Perempuan'];
  final List<String> _agamaOptions = [
    'Islam',
    'Kristen',
    'Katolik',
    'Hindu',
    'Budha',
    'Konghucu',
  ];
  final List<String> _golonganDarahOptions = ['A', 'B', 'AB', 'O'];
  final List<String> _peranOptions = ['Kepala Keluarga', 'Anggota'];
  final List<String> _pendidikanOptions = [
    'SD',
    'SMP',
    'SMA',
    'D3',
    'S1',
    'S2',
    'S3',
  ];
  final List<String> _pekerjaanOptions = [
    'Pelajar',
    'Pegawai',
    'Wiraswasta',
    'Lainnya',
  ];
  final List<String> _statusOptions = ['Aktif', 'Nonaktif'];

  @override
  void dispose() {
    _namaController.dispose();
    _nikController.dispose();
    _noTelpController.dispose();
    _tempatLahirController.dispose();
    _tanggalLahirController.dispose();
    super.dispose();
  }

  Future<void> _selectTanggalLahir() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
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

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _tanggalLahirController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _submitForm() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Warga berhasil ditambahkan!'),
        backgroundColor: Colors.green,
      ),
    );
    _resetForm();
  }

  void _resetForm() {
    _namaController.clear();
    _nikController.clear();
    _noTelpController.clear();
    _tempatLahirController.clear();
    _tanggalLahirController.clear();
    setState(() {
      _selectedKeluarga = null;
      _selectedJenisKelamin = null;
      _selectedAgama = null;
      _selectedGolonganDarah = null;
      _selectedPeranKeluarga = null;
      _selectedPendidikan = null;
      _selectedPekerjaan = null;
      _selectedStatus = null;
      _selectedDate = null;
    });
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: Rem.rem0_875,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: Rem.rem0_5),
        TextField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          style: GoogleFonts.poppins(),
          decoration: InputDecoration(
            hintText: readOnly ? '--/--/----' : 'Masukkan $label',
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
              borderSide: const BorderSide(color: AppColors.primaryColor),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: Rem.rem0_75,
              vertical: Rem.rem0_75,
            ),
            suffixIcon: readOnly
                ? IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: onTap,
                  )
                : null,
          ),
        ),
        const SizedBox(height: Rem.rem1),
      ],
    );
  }

  Widget _buildDropdown(
    String label,
    String? selectedValue,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: Rem.rem0_875,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: Rem.rem0_5),
        CustomDropdown<String>(
          initialSelection: selectedValue,
          hintText: '-- Pilih $label --',
          items: options
              .map((e) => DropdownMenuEntry<String>(value: e, label: e))
              .toList(),
          onSelected: onChanged,
        ),
        const SizedBox(height: Rem.rem1),
      ],
    );
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
            Text(
              'Tambah Warga',
              style: GoogleFonts.poppins(
                fontSize: Rem.rem1_25,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: Rem.rem1_5),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDropdown(
                      'Keluarga',
                      _selectedKeluarga,
                      _keluargaOptions,
                      (val) => setState(() => _selectedKeluarga = val),
                    ),
                    _buildTextField('Nama', _namaController),
                    _buildTextField('NIK', _nikController),
                    _buildTextField('No Telepon', _noTelpController),
                    _buildTextField('Tempat Lahir', _tempatLahirController),
                    _buildTextField(
                      'Tanggal Lahir',
                      _tanggalLahirController,
                      readOnly: true,
                      onTap: _selectTanggalLahir,
                    ),
                    _buildDropdown(
                      'Jenis Kelamin',
                      _selectedJenisKelamin,
                      _jenisKelaminOptions,
                      (val) => setState(() => _selectedJenisKelamin = val),
                    ),
                    _buildDropdown(
                      'Agama',
                      _selectedAgama,
                      _agamaOptions,
                      (val) => setState(() => _selectedAgama = val),
                    ),
                    _buildDropdown(
                      'Golongan Darah',
                      _selectedGolonganDarah,
                      _golonganDarahOptions,
                      (val) => setState(() => _selectedGolonganDarah = val),
                    ),
                    _buildDropdown(
                      'Peran Keluarga',
                      _selectedPeranKeluarga,
                      _peranOptions,
                      (val) => setState(() => _selectedPeranKeluarga = val),
                    ),
                    _buildDropdown(
                      'Pendidikan Terakhir',
                      _selectedPendidikan,
                      _pendidikanOptions,
                      (val) => setState(() => _selectedPendidikan = val),
                    ),
                    _buildDropdown(
                      'Pekerjaan',
                      _selectedPekerjaan,
                      _pekerjaanOptions,
                      (val) => setState(() => _selectedPekerjaan = val),
                    ),
                    _buildDropdown(
                      'Status',
                      _selectedStatus,
                      _statusOptions,
                      (val) => setState(() => _selectedStatus = val),
                    ),
                    const SizedBox(height: Rem.rem2),
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

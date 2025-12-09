import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../constants/color_constant.dart';
import '../../../../constants/rem_constant.dart';
import '../../../../enums/resident_enum.dart';
import '../../../../models/resident/resident_request_model.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/resident_provider.dart';
import '../../../../providers/family_provider.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_dropdown.dart';
import '../../../../widgets/custom_text_form_field.dart';

class AddUserFamilyScreen extends StatefulWidget {
  const AddUserFamilyScreen({Key? key}) : super(key: key);

  @override
  State<AddUserFamilyScreen> createState() => _AddUserFamilyScreenState();
}

class _AddUserFamilyScreenState extends State<AddUserFamilyScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _nikController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthPlaceController = TextEditingController();

  // Selections
  DateTime? _selectedBirthDate;
  Gender? _selectedGender;
  Religion? _selectedReligion;
  BloodType? _selectedBloodType;
  LastEducation? _selectedLastEducation;
  Occupation? _selectedOccupation;
  FamilyRole? _selectedFamilyRole;
  int? _selectedFamilyId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFamilies();
    });
  }

  void _loadFamilies() {
    final authProvider = context.read<AuthProvider>();
    final familyProvider = context.read<FamilyProvider>();

    if (authProvider.token != null) {
      familyProvider.fetchFamilies(authProvider.token!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nikController.dispose();
    _phoneController.dispose();
    _birthPlaceController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedBirthDate) {
      setState(() {
        _selectedBirthDate = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedFamilyId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Silakan pilih keluarga')));
      return;
    }

    if (_selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih jenis kelamin')),
      );
      return;
    }

    if (_selectedFamilyRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih peran keluarga')),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final residentProvider = Provider.of<ResidentProvider>(
      context,
      listen: false,
    );

    final token = authProvider.token;
    if (token == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Anda belum login')));
      return;
    }

    final request = ResidentRequestModel(
      familyId: _selectedFamilyId!,
      fullName: _nameController.text,
      nik: _nikController.text,
      phoneNumber: _phoneController.text.isNotEmpty
          ? _phoneController.text
          : null,
      birthPlace: _birthPlaceController.text.isNotEmpty
          ? _birthPlaceController.text
          : null,
      birthDate: _selectedBirthDate?.toIso8601String().split('T')[0],
      gender: _selectedGender!.value,
      religion: _selectedReligion?.label,
      bloodType: _selectedBloodType?.label,
      familyRole: _selectedFamilyRole!.label,
      lastEducation: _selectedLastEducation?.label,
      occupation: _selectedOccupation?.label,
      isAlive: true,
      isActive: true,
    );

    final success = await residentProvider.createResident(token, request);

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Penduduk berhasil ditambahkan')),
        );
        context.pop(true);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              residentProvider.errorMessage ?? 'Gagal menambahkan penduduk',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
        title: Text(
          'Tambah Penduduk',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<ResidentProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(Rem.rem1_5),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Family Selection (First)
                  Consumer<FamilyProvider>(
                    builder: (context, familyProvider, child) {
                      return CustomDropdown<int>(
                        labelText: "Keluarga",
                        hintText: "-- PILIH KELUARGA --",
                        initialSelection: _selectedFamilyId,
                        items: familyProvider.families
                            .map(
                              (e) => DropdownMenuEntry(
                                value: e.id,
                                label: e.namaKeluarga,
                              ),
                            )
                            .toList(),
                        onSelected: (value) =>
                            setState(() => _selectedFamilyId = value),
                      );
                    },
                  ),
                  const SizedBox(height: Rem.rem1),

                  _buildSectionTitle('Informasi Dasar'),
                  CustomTextFormField(
                    controller: _nameController,
                    labelText: "Nama Lengkap",
                    hintText: "Masukkan nama lengkap",
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Nama harus diisi';
                      if (value.length > 150)
                        return 'Nama maksimal 150 karakter';
                      return null;
                    },
                  ),
                  const SizedBox(height: Rem.rem1),
                  CustomTextFormField(
                    controller: _nikController,
                    labelText: "NIK",
                    hintText: "Masukkan NIK",
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'NIK harus diisi';
                      if (value.length != 16) return 'NIK harus 16 digit';
                      return null;
                    },
                  ),
                  const SizedBox(height: Rem.rem1),
                  CustomTextFormField(
                    controller: _birthPlaceController,
                    labelText: "Tempat Lahir",
                    hintText: "Masukkan tempat lahir",
                  ),
                  const SizedBox(height: Rem.rem1),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tanggal Lahir",
                        style: GoogleFonts.poppins(
                          fontSize: Rem.rem1,
                          fontWeight: FontWeight.normal,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: Rem.rem0_5),
                      InkWell(
                        onTap: () => _selectDate(context),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: Rem.rem1,
                            vertical: Rem.rem0_875,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(Rem.rem0_5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedBirthDate == null
                                    ? 'Pilih tanggal lahir'
                                    : DateFormat(
                                        'dd/MM/yyyy',
                                      ).format(_selectedBirthDate!),
                                style: GoogleFonts.poppins(
                                  color: _selectedBirthDate == null
                                      ? Colors.grey
                                      : Colors.black,
                                ),
                              ),
                              Icon(
                                Icons.calendar_today,
                                size: Rem.rem1_25,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Rem.rem1),
                  CustomDropdown<Gender>(
                    labelText: "Jenis Kelamin",
                    hintText: "-- PILIH GENDER --",
                    initialSelection: _selectedGender,
                    items: Gender.values
                        .map((e) => DropdownMenuEntry(value: e, label: e.label))
                        .toList(),
                    onSelected: (value) =>
                        setState(() => _selectedGender = value),
                  ),
                  const SizedBox(height: Rem.rem1),
                  CustomDropdown<BloodType>(
                    labelText: "Golongan Darah",
                    hintText: "-- PILIH GOLONGAN DARAH --",
                    initialSelection: _selectedBloodType,
                    items: BloodType.values
                        .map((e) => DropdownMenuEntry(value: e, label: e.label))
                        .toList(),
                    onSelected: (value) =>
                        setState(() => _selectedBloodType = value),
                  ),
                  const SizedBox(height: Rem.rem1),
                  CustomDropdown<Religion>(
                    labelText: "Agama",
                    hintText: "-- PILIH AGAMA --",
                    initialSelection: _selectedReligion,
                    items: Religion.values
                        .map((e) => DropdownMenuEntry(value: e, label: e.label))
                        .toList(),
                    onSelected: (value) =>
                        setState(() => _selectedReligion = value),
                  ),

                  const SizedBox(height: Rem.rem2),
                  _buildSectionTitle('Kontak & Pekerjaan'),
                  CustomTextFormField(
                    controller: _phoneController,
                    labelText: "Nomor Telepon",
                    hintText: "Masukkan nomor telepon",
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: Rem.rem1),
                  CustomDropdown(
                    labelText: "Pekerjaan",
                    hintText: "-- PILIH PEKERJAAN --",
                    initialSelection: _selectedOccupation,
                    items: Occupation.values
                        .map((e) => DropdownMenuEntry(value: e, label: e.label))
                        .toList(),
                    onSelected: (value) =>
                        setState(() => _selectedOccupation = value),
                  ),
                  const SizedBox(height: Rem.rem1),
                  CustomDropdown<LastEducation>(
                    labelText: "Pendidikan Terakhir",
                    hintText: "-- PILIH PENDIDIKAN --",
                    initialSelection: _selectedLastEducation,
                    items: LastEducation.values
                        .map((e) => DropdownMenuEntry(value: e, label: e.label))
                        .toList(),
                    onSelected: (value) =>
                        setState(() => _selectedLastEducation = value),
                  ),

                  const SizedBox(height: Rem.rem2),
                  _buildSectionTitle('Peran Keluarga'),
                  CustomDropdown<FamilyRole>(
                    labelText: "Peran dalam Keluarga",
                    hintText: "-- PILIH PERAN --",
                    initialSelection: _selectedFamilyRole,
                    items: FamilyRole.values
                        .map((e) => DropdownMenuEntry(value: e, label: e.label))
                        .toList(),
                    onSelected: (value) =>
                        setState(() => _selectedFamilyRole = value),
                  ),

                  const SizedBox(height: Rem.rem2),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      onPressed: provider.isLoading ? null : _submit,
                      child: provider.isLoading
                          ? const SizedBox(
                              height: Rem.rem1_25,
                              width: Rem.rem1_25,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Simpan',
                              style: GoogleFonts.poppins(fontSize: Rem.rem1),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: Rem.rem1),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: Rem.rem1_25,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}

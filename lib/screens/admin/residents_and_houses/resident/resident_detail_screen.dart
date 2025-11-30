import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../constants/color_constant.dart';
import '../../../../constants/rem_constant.dart';
import '../../../../enums/resident_enum.dart';
import '../../../../models/resident/resident_detail_model.dart';
import '../../../../models/resident/resident_request_model.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/resident_provider.dart';
import '../../../../providers/family_provider.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_dropdown.dart';
import '../../../../widgets/custom_text_form_field.dart';

class ResidentDetailScreen extends StatefulWidget {
  final String id;

  const ResidentDetailScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<ResidentDetailScreen> createState() => _ResidentDetailScreenState();
}

class _ResidentDetailScreenState extends State<ResidentDetailScreen> {
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
  FamilyRole? _selectedFamilyRole;
  Occupation? _selectedOccupation;
  int? _selectedFamilyId;
  bool _isFamilyHead = false;
  bool _isAlive = true;
  bool _isActive = true;

  bool _isEditMode = false;
  ResidentDetailModel? _resident;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDetail();
    });
  }

  void _loadDetail() async {
    final authProvider = context.read<AuthProvider>();
    final residentProvider = context.read<ResidentProvider>();
    final familyProvider = context.read<FamilyProvider>();

    if (authProvider.token != null) {
      familyProvider.fetchFamilies(authProvider.token!);
      await residentProvider.fetchResidentDetail(authProvider.token!, widget.id);
      _resident = residentProvider.selectedResident;
      
      if (_resident != null && mounted) {
        _initializeFields();
      }
    }
  }

  void _initializeFields() {
    if (_resident == null) return;

    setState(() {
      _nameController.text = _resident!.name;
      _nikController.text = _resident!.nik;
      _phoneController.text = _resident!.phoneNumber ?? '';
      _birthPlaceController.text = _resident!.birthPlace ?? '';
      
      _selectedBirthDate = _resident!.birthDate;
      _selectedGender = Gender.fromString(_resident!.gender);
      _selectedReligion = _resident!.religion != null ? Religion.fromString(_resident!.religion!) : null;
      _selectedBloodType = _resident!.bloodType != null ? BloodType.fromString(_resident!.bloodType!) : null;
      _selectedLastEducation = _resident!.lastEducation != null ? LastEducation.fromString(_resident!.lastEducation!) : null;
      _selectedFamilyRole = FamilyRole.fromString(_resident!.familyRole);
      _selectedFamilyId = _resident!.familyId;
      _selectedOccupation = _resident!.occupation != null ? Occupation.fromString(_resident!.occupation!) : null;
      
      _isFamilyHead = _resident!.isFamilyHead;
      _isAlive = _resident!.isAlive;
      _isActive = _resident!.isActive;
    });
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
    if (!_isEditMode) return;

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

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
      if (!_isEditMode) {
        _initializeFields(); // Reset to original data
      }
    });
  }

  Future<void> _updateResident() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedFamilyId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih keluarga')),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final residentProvider = Provider.of<ResidentProvider>(context, listen: false);

    final token = authProvider.token;
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Anda belum login')),
      );
      return;
    }

    final request = ResidentRequestModel(
      familyId: _selectedFamilyId!,
      fullName: _nameController.text,
      nik: _nikController.text,
      phoneNumber: _phoneController.text.isNotEmpty ? _phoneController.text : null,
      birthPlace: _birthPlaceController.text.isNotEmpty ? _birthPlaceController.text : null,
      birthDate: _selectedBirthDate?.toIso8601String().split('T')[0],
      gender: _selectedGender?.value ?? (_resident?.gender == 'Laki-laki' ? 'M' : 'F'), // Fallback or correct mapping
      religion: _selectedReligion?.label,
      bloodType: _selectedBloodType?.label,
      familyRole: _selectedFamilyRole?.label ?? 'Famili Lain',
      lastEducation: _selectedLastEducation?.label,
      occupation: _selectedOccupation?.label,
      isAlive: _isAlive,
      isActive: _isActive,
    );

    final success = await residentProvider.updateResident(token, widget.id, request);

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data penduduk berhasil diperbarui')),
        );
        setState(() {
          _isEditMode = false;
        });
        _loadDetail(); // Refresh data
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              residentProvider.errorMessage ?? 'Gagal memperbarui data penduduk',
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
          _isEditMode ? 'Edit Penduduk' : 'Detail Penduduk',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (!_isEditMode)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _toggleEditMode,
              tooltip: 'Edit',
            ),
        ],
      ),
      body: Consumer<ResidentProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && !_isEditMode) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null && _resident == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${provider.errorMessage}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadDetail,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(Rem.rem1_5),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildSectionTitle('Informasi Dasar'),
                  CustomTextFormField(
                    controller: _nameController,
                    labelText: "Nama Lengkap",
                    hintText: "Masukkan nama lengkap",
                    readOnly: !_isEditMode,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Nama harus diisi';
                      return null;
                    },
                  ),
                  const SizedBox(height: Rem.rem1),
                  CustomTextFormField(
                    controller: _nikController,
                    labelText: "NIK",
                    hintText: "Masukkan NIK",
                    readOnly: !_isEditMode,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'NIK harus diisi';
                      return null;
                    },
                  ),
                  const SizedBox(height: Rem.rem1),
                  CustomTextFormField(
                    controller: _birthPlaceController,
                    labelText: "Tempat Lahir",
                    hintText: "Masukkan tempat lahir",
                    readOnly: !_isEditMode,
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
                        onTap: _isEditMode ? () => _selectDate(context) : null,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: Rem.rem1,
                            vertical: Rem.rem0_875,
                          ),
                          decoration: BoxDecoration(
                            color: _isEditMode ? Colors.white : Colors.grey.shade100,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(Rem.rem0_5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedBirthDate == null
                                    ? 'Pilih tanggal lahir'
                                    : DateFormat('dd/MM/yyyy').format(_selectedBirthDate!),
                                style: GoogleFonts.poppins(
                                  color: _selectedBirthDate == null
                                      ? Colors.grey
                                      : Colors.black,
                                ),
                              ),
                              Icon(
                                Icons.calendar_today,
                                size: Rem.rem1_25,
                                color: _isEditMode ? Colors.black : Colors.grey,
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
                    enabled: _isEditMode,
                    items: Gender.values.map((e) => DropdownMenuEntry(value: e, label: e.label)).toList(),
                    onSelected: (value) => setState(() => _selectedGender = value),
                  ),
                  const SizedBox(height: Rem.rem1),
                  CustomDropdown<BloodType>(
                    labelText: "Golongan Darah",
                    hintText: "-- PILIH GOLONGAN DARAH --",
                    initialSelection: _selectedBloodType,
                    enabled: _isEditMode,
                    items: BloodType.values.map((e) => DropdownMenuEntry(value: e, label: e.label)).toList(),
                    onSelected: (value) => setState(() => _selectedBloodType = value),
                  ),
                  const SizedBox(height: Rem.rem1),
                  CustomDropdown<Religion>(
                    labelText: "Agama",
                    hintText: "-- PILIH AGAMA --",
                    initialSelection: _selectedReligion,
                    enabled: _isEditMode,
                    items: Religion.values.map((e) => DropdownMenuEntry(value: e, label: e.label)).toList(),
                    onSelected: (value) => setState(() => _selectedReligion = value),
                  ),

                  const SizedBox(height: Rem.rem2),
                  _buildSectionTitle('Kontak & Pekerjaan'),
                  CustomTextFormField(
                    controller: _phoneController,
                    labelText: "Nomor Telepon",
                    hintText: "Masukkan nomor telepon",
                    readOnly: !_isEditMode,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: Rem.rem1),
                  CustomDropdown(
                    labelText: "Pekerjaan",
                    hintText: "-- PILIH PEKERJAAN --",
                    initialSelection: _selectedOccupation,
                    enabled: _isEditMode,
                    items: Occupation.values.map((e) => DropdownMenuEntry(value: e, label: e.label)).toList(),
                    onSelected: (value) => setState(() => _selectedOccupation = value),
                  ),
                  const SizedBox(height: Rem.rem1),
                  CustomDropdown<LastEducation>(
                    labelText: "Pendidikan Terakhir",
                    hintText: "-- PILIH PENDIDIKAN --",
                    initialSelection: _selectedLastEducation,
                    enabled: _isEditMode,
                    items: LastEducation.values.map((e) => DropdownMenuEntry(value: e, label: e.label)).toList(),
                    onSelected: (value) => setState(() => _selectedLastEducation = value),
                  ),

                  const SizedBox(height: Rem.rem2),
                  _buildSectionTitle('Status Keluarga'),
                  
                  // Family Dropdown
                  Consumer<FamilyProvider>(
                    builder: (context, familyProvider, child) {
                      return CustomDropdown<int>(
                        labelText: "Keluarga",
                        hintText: "-- PILIH KELUARGA --",
                        initialSelection: _selectedFamilyId,
                        enabled: _isEditMode && !_isFamilyHead,
                        items: familyProvider.families.map((e) => DropdownMenuEntry(value: e.id, label: e.namaKeluarga)).toList(),
                        onSelected: (value) => setState(() => _selectedFamilyId = value),
                      );
                    },
                  ),
                  const SizedBox(height: Rem.rem1),
                  
                  CustomDropdown<FamilyRole>(
                    labelText: "Peran dalam Keluarga",
                    hintText: "-- PILIH PERAN --",
                    initialSelection: _selectedFamilyRole,
                    enabled: _isEditMode,
                    items: FamilyRole.values.map((e) => DropdownMenuEntry(value: e, label: e.label)).toList(),
                    onSelected: (value) => setState(() => _selectedFamilyRole = value),
                  ),
                  const SizedBox(height: Rem.rem1),
                  _buildSwitchTile(
                    title: 'Status Hidup (Hidup)',
                    value: _isAlive,
                    onChanged: _isEditMode ? (val) => setState(() => _isAlive = val) : null,
                  ),
                  _buildSwitchTile(
                    title: 'Status Data (Aktif)',
                    value: _isActive,
                    onChanged: _isEditMode ? (val) => setState(() => _isActive = val) : null,
                  ),

                  if (_isEditMode) ...[
                    const SizedBox(height: Rem.rem2),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            onPressed: _toggleEditMode,
                            child: const Text('Batal'),
                            isOutlined: true,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomButton(
                            onPressed: provider.isLoading ? null : _updateResident,
                            child: provider.isLoading
                                ? const SizedBox(
                                    height: Rem.rem1_25,
                                    width: Rem.rem1_25,
                                    child: CircularProgressIndicator(color: Colors.white),
                                  )
                                : Text(
                                    'Simpan',
                                    style: GoogleFonts.poppins(fontSize: Rem.rem1),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
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

  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool>? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Rem.rem1),
      child: Container(
        decoration: BoxDecoration(
          color: _isEditMode ? Colors.white : Colors.grey.shade100,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(Rem.rem0_5),
        ),
        child: SwitchListTile(
          title: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: Rem.rem1,
              color: Colors.black87,
            ),
          ),
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primaryColor,
        ),
      ),
    );
  }
}

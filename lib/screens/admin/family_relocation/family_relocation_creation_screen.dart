import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_mobile_v2/enums/relocation_type.dart';
import 'package:jawara_mobile_v2/models/family_relocation/family_relocation_request_model.dart';
import 'package:jawara_mobile_v2/providers/family_relocation_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../constants/color_constant.dart';
import '../../../../constants/rem_constant.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/family_provider.dart';
import '../../../../providers/address_provider.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_dropdown.dart';
import '../../../../widgets/custom_text_form_field.dart';

class FamilyRelocationCreationScreen extends StatefulWidget {
  const FamilyRelocationCreationScreen({Key? key}) : super(key: key);

  @override
  State<FamilyRelocationCreationScreen> createState() =>
      _FamilyRelocationCreationScreenState();
}

class _FamilyRelocationCreationScreenState
    extends State<FamilyRelocationCreationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _reasonController = TextEditingController();

  // Selections
  RelocationType? _selectedRelocationType;
  DateTime? _selectedRelocationDate;
  int? _selectedFamilyId;
  int? _selectedNewAddressId;
  String? _currentFamilyAddress; // Info alamat keluarga saat ini

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() {
    final authProvider = context.read<AuthProvider>();
    final token = authProvider.token;

    if (token != null) {
      context.read<FamilyProvider>().fetchFamilies(token);
      context.read<AddressProvider>().fetchAddresses(token);
    }
  }

  void _onFamilySelected(int? familyId) {
    setState(() {
      _selectedFamilyId = familyId;
      
      // Ambil alamat keluarga yang dipilih
      if (familyId != null) {
        final familyProvider = context.read<FamilyProvider>();
        final selectedFamily = familyProvider.families.firstWhere(
          (family) => family.id == familyId,
          orElse: () => familyProvider.families.first,
        );
        _currentFamilyAddress = selectedFamily.alamatRumah;
      } else {
        _currentFamilyAddress = null;
      }
    });
  }

  void _onRelocationTypeSelected(RelocationType? type) {
    setState(() {
      _selectedRelocationType = type;
      // Reset new address jika tipe bukan MOVE_HOUSE
      if (type != RelocationType.moveHouse) {
        _selectedNewAddressId = null;
      }
    });
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedRelocationDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedRelocationDate) {
      setState(() {
        _selectedRelocationDate = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedRelocationType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih tipe perpindahan')),
      );
      return;
    }

    if (_selectedRelocationDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih tanggal pindah')),
      );
      return;
    }

    if (_selectedFamilyId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih keluarga')),
      );
      return;
    }

    // Validasi new address hanya untuk MOVE_HOUSE
    if (_selectedRelocationType == RelocationType.moveHouse && 
        _selectedNewAddressId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih alamat baru')),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final provider = Provider.of<FamilyRelocationProvider>(
      context,
      listen: false,
    );

    final token = authProvider.token;
    final userId = authProvider.currentUser?.id;

    if (token == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Anda belum login')));
      return;
    }


    final request = FamilyRelocationRequestModel(
      relocationType: _selectedRelocationType!,
      relocationDate: _selectedRelocationDate!,
      reason: _reasonController.text,
      familyId: _selectedFamilyId!,
      newAddressId: _selectedNewAddressId, // Bisa null untuk EMIGRATE
    );

    final success = await provider.createFamilyRelocation(token, request);

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data pindah keluarga berhasil ditambahkan'),
          ),
        );
        context.pop(true);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              provider.errorMessage ?? 'Gagal menambahkan data pindah keluarga',
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
          'Tambah Pindah Keluarga',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<FamilyRelocationProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(Rem.rem1_5),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Informasi Keluarga'),
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
                        onSelected: _onFamilySelected,
                      );
                    },
                  ),
                  
                  // Tampilkan alamat saat ini sebagai info
                  if (_currentFamilyAddress != null) ...[
                    const SizedBox(height: Rem.rem1),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(Rem.rem1),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(Rem.rem0_5),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: Rem.rem1,
                                color: Colors.blue.shade700,
                              ),
                              const SizedBox(width: Rem.rem0_5),
                              Text(
                                'Alamat Saat Ini',
                                style: GoogleFonts.poppins(
                                  fontSize: Rem.rem0_875,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: Rem.rem0_5),
                          Text(
                            _currentFamilyAddress!,
                            style: GoogleFonts.poppins(
                              fontSize: Rem.rem0_875,
                              color: Colors.blue.shade900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: Rem.rem1_5),
                  _buildSectionTitle('Informasi Perpindahan'),
                  CustomDropdown<RelocationType>(
                    labelText: "Tipe Perpindahan",
                    hintText: "-- PILIH TIPE PERPINDAHAN --",
                    initialSelection: _selectedRelocationType,
                    items: RelocationType.values
                        .map((e) => DropdownMenuEntry(value: e, label: e.label))
                        .toList(),
                    onSelected: _onRelocationTypeSelected,
                  ),
                  const SizedBox(height: Rem.rem1),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tanggal Pindah",
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
                                _selectedRelocationDate == null
                                    ? 'Pilih tanggal pindah'
                                    : DateFormat('dd/MM/yyyy')
                                        .format(_selectedRelocationDate!),
                                style: GoogleFonts.poppins(
                                  color: _selectedRelocationDate == null
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
                  CustomTextFormField(
                    controller: _reasonController,
                    labelText: "Alasan Pindah",
                    hintText: "Masukkan alasan pindah",
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Alasan harus diisi';
                      }
                      return null;
                    },
                  ),
                  
                  // Alamat Baru - hanya tampil jika MOVE_HOUSE
                  if (_selectedRelocationType == RelocationType.moveHouse) ...[
                    const SizedBox(height: Rem.rem1_5),
                    _buildSectionTitle('Alamat Tujuan'),
                    Consumer<AddressProvider>(
                      builder: (context, addressProvider, child) {
                        return CustomDropdown<int>(
                          labelText: "Alamat Baru",
                          hintText: "-- PILIH ALAMAT BARU --",
                          initialSelection: _selectedNewAddressId,
                          items: addressProvider.addresses
                              .map(
                                (e) => DropdownMenuEntry(
                                  value: e.id,
                                  label: e.alamat,
                                ),
                              )
                              .toList(),
                          onSelected: (value) =>
                              setState(() => _selectedNewAddressId = value),
                        );
                      },
                    ),
                  ],
                  
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
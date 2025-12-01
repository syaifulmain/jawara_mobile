import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_mobile_v2/models/transfer_channel/transfer_channel_detail_model.dart';
import 'package:jawara_mobile_v2/models/transfer_channel/transfer_channel_type.dart';
import 'package:jawara_mobile_v2/providers/transfer_channel_provider.dart';
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

class TransferChannelDetailScreen extends StatefulWidget {
  final String id;

  const TransferChannelDetailScreen({Key? key, required this.id})
    : super(key: key);

  @override
  State<TransferChannelDetailScreen> createState() =>
      _TransferChannelDetailScreenState();
}

class _TransferChannelDetailScreenState
    extends State<TransferChannelDetailScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  // final _typeController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _notesController = TextEditingController();

  // Selections
  TransferChannelType? _selectedType;

  bool _isEditMode = false;
  TransferChannelDetailModel? _transferChannel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDetail();
    });
  }

  void _loadDetail() async {
    final authProvider = context.read<AuthProvider>();
    final transferChannelProvider = context.read<TransferChannelProvider>();

    if (authProvider.token != null) {
      await transferChannelProvider.fetchTransferChannelDetail(
        authProvider.token!,
        widget.id,
      );
      _transferChannel = transferChannelProvider.selectedTransferChannel;

      if (_transferChannel != null && mounted) {
        _initializeFields();
      }
    }
  }

  void _initializeFields() {
    if (_transferChannel == null) return;

    setState(() {
      _nameController.text = _transferChannel!.name;
      // _typeController.text = _transferChannel!.type.toStringValue();

      _selectedType = _transferChannel!.type;

      _ownerNameController.text = _transferChannel!.ownerName;
      _accountNumberController.text = _transferChannel!.accountNumber;
      _notesController.text = _transferChannel!.notes;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    // _typeController.dispose();
    _ownerNameController.dispose();
    _accountNumberController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
      if (!_isEditMode) {
        _initializeFields(); // Reset to original data
      }
    });
  }

  Future<void> _updateTransferChannel() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final transferChannelProvider = Provider.of<TransferChannelProvider>(
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

    final request = TransferChannelDetailModel(
      id: _transferChannel!.id,
      name: _nameController.text,
      type: _selectedType ?? _transferChannel!.type,
      ownerName: _ownerNameController.text,
      accountNumber: _accountNumberController.text,
      notes: _notesController.text,
      // familyId: _selectedFamilyId!,
      // fullName: _nameController.text,
      // nik: _nikController.text,
      // phoneNumber: _phoneController.text.isNotEmpty ? _phoneController.text : null,
      // birthPlace: _birthPlaceController.text.isNotEmpty ? _birthPlaceController.text : null,
      // birthDate: _selectedBirthDate?.toIso8601String().split('T')[0],
      // gender: _selectedGender?.value ?? (_transferChannel?.gender == 'Laki-laki' ? 'M' : 'F'), // Fallback or correct mapping
      // religion: _selectedReligion?.label,
      // bloodType: _selectedBloodType?.label,
      // familyRole: _selectedFamilyRole?.label ?? 'Famili Lain',
      // lastEducation: _selectedLastEducation?.label,
      // occupation: _selectedOccupation?.label,
      // isAlive: _isAlive,
      // isActive: _isActive,
    );

    final success = await transferChannelProvider.updateTransferChannel(
      token,
      widget.id,
      request,
    );

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil diperbarui')),
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
              transferChannelProvider.errorMessage ?? 'Gagal memperbarui data',
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
          _isEditMode ? 'Edit Saluran Transfer' : 'Detail Saluran Transfer',
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
      body: Consumer<TransferChannelProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && !_isEditMode) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null && _transferChannel == null) {
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
                    labelText: "Nama Saluran",
                    hintText: "Masukkan nama saluran.",
                    readOnly: !_isEditMode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama harus diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: Rem.rem1),
                  // CustomTextFormField(
                  //   controller: _typeController,
                  //   labelText: "Tipe Saluran",
                  //   hintText: "Masukkan tipe saluran.",
                  //   readOnly: !_isEditMode,
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return 'Tipe harus diisi';
                  //     }
                  //     return null;
                  //   },
                  // )
                  CustomDropdown<TransferChannelType>(
                    labelText: "Tipe Saluran",
                    hintText: "Masukkan tipe saluran.",
                    initialSelection: _selectedType,
                    enabled: _isEditMode,
                    items: TransferChannelType.values
                        .map((e) => DropdownMenuEntry(value: e, label: e.label))
                        .toList(),
                    onSelected: (value) =>
                        setState(() => _selectedType = value),
                  ),
                  CustomTextFormField(
                    controller: _ownerNameController,
                    labelText: "Pemilik Saluran",
                    hintText: "Masukkan pemilik saluran.",
                    readOnly: !_isEditMode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Pemilik harus diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: Rem.rem1),
                  CustomTextFormField(
                    controller: _accountNumberController,
                    labelText: "Nomor Rekening",
                    hintText: "Masukkan nomor rekening.",
                    readOnly: !_isEditMode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nomor rekening harus diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: Rem.rem1),
                  CustomTextFormField(
                    controller: _notesController,
                    labelText: "Catatan",
                    hintText: "Masukkan catatan.",
                    readOnly: !_isEditMode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Catatan harus diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(width: 12),
                  if (_isEditMode) ...[
                    const SizedBox(height: Rem.rem2),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            onPressed: _toggleEditMode,
                            isOutlined: true,
                            child: const Text('Batal'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomButton(
                            onPressed: provider.isLoading ? null : _updateTransferChannel,
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

  // Widget _buildSwitchTile({
  //   required String title,
  //   required bool value,
  //   required ValueChanged<bool>? onChanged,
  // }) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: Rem.rem1),
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: _isEditMode ? Colors.white : Colors.grey.shade100,
  //         border: Border.all(color: Colors.grey.shade300),
  //         borderRadius: BorderRadius.circular(Rem.rem0_5),
  //       ),
  //       child: SwitchListTile(
  //         title: Text(
  //           title,
  //           style: GoogleFonts.poppins(
  //             fontSize: Rem.rem1,
  //             color: Colors.black87,
  //           ),
  //         ),
  //         value: value,
  //         onChanged: onChanged,
  //         activeColor: AppColors.primaryColor,
  //       ),
  //     ),
  //   );
  // }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_mobile_v2/models/transfer_channel/transfer_channel_detail_model.dart';
import 'package:jawara_mobile_v2/models/transfer_channel/transfer_channel_request_model.dart';
import 'package:jawara_mobile_v2/models/transfer_channel/transfer_channel_type.dart';
import 'package:jawara_mobile_v2/providers/transfer_channel_provider.dart';
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

class TransferChannelCreationScreen extends StatefulWidget {
  const TransferChannelCreationScreen({Key? key}) : super(key: key);

  @override
  State<TransferChannelCreationScreen> createState() =>
      _TransferChannelCreationScreenState();
}

class _TransferChannelCreationScreenState
    extends State<TransferChannelCreationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _notesController = TextEditingController();

  // Selections
  TransferChannelType? _selectedType;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _loadChannels();
    // });
  }

  // void _loadChannels() {
  //   final authProvider = context.read<AuthProvider>();
  //   final familyProvider = context.read<TransferChannelProvider>();

  //   if (authProvider.token != null) {
  //     familyProvider.fetchTransferChannels(authProvider.token!);
  //   }
  // }

  @override
  void dispose() {
    _nameController.dispose();
    _ownerNameController.dispose();
    _accountNumberController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih tipe transfer channel')),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final provider = Provider.of<TransferChannelProvider>(
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

    final request = TransferChannelRequestModel(
      name: _nameController.text,
      type: _selectedType!,
      ownerName: _ownerNameController.text,
      accountNumber: _accountNumberController.text,
      notes: _notesController.text,
    );

    final success = await provider.createTransferChannel(token, request);

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Saluran transfer berhasil ditambahkan'),
          ),
        );
        context.pop(true);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              provider.errorMessage ?? 'Gagal menambahkan saluran transfer',
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
                  _buildSectionTitle('Informasi Dasar'),
                  CustomTextFormField(
                    controller: _nameController,
                    labelText: "Nama Saluran Transfer",
                    hintText: "Masukkan nama saluran transfer.",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama harus diisi';
                      }
                      if (value.length > 150) {
                        return 'Nama maksimal 150 karakter';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: Rem.rem1),
                  CustomDropdown<TransferChannelType>(
                    labelText: "Tipe Saluran Transfer",
                    hintText: "-- PILIH GENDER --",
                    initialSelection: _selectedType,
                    items: TransferChannelType.values
                        .map((e) => DropdownMenuEntry(value: e, label: e.label))
                        .toList(),
                    onSelected: (value) =>
                        setState(() => _selectedType = value),
                  ),
                  const SizedBox(height: Rem.rem1),

                  CustomTextFormField(
                    controller: _ownerNameController,
                    labelText: "Nama Pemilik Saluran Transfer",
                    hintText: "Masukkan nama pemilik saluran transfer.",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama harus diisi';
                      }
                      if (value.length > 150) {
                        return 'Nama maksimal 150 karakter';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: Rem.rem1),

                  CustomTextFormField(
                    controller: _accountNumberController,
                    labelText: "Nomor Rekening Saluran Transfer",
                    hintText: "Masukkan nomor rekening saluran transfer.",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nomor rekening harus diisi';
                      }
                      if (value.length > 150) {
                        return 'Nomor rekening maksimal 150 karakter';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: Rem.rem1),
                  CustomTextFormField(
                    controller: _notesController,
                    labelText: "Catatan",
                    hintText: "Masukkan catatan tambahan.",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Catatan harus diisi';
                      }
                      if (value.length > 150) {
                        return 'Catatan maksimal 150 karakter';
                      }
                      return null;
                    },
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

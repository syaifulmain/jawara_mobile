import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_mobile_v2/models/transfer_channel/transfer_channel_detail_model.dart';
import 'package:jawara_mobile_v2/models/transfer_channel/transfer_channel_type.dart';
import 'package:jawara_mobile_v2/providers/transfer_channel_provider.dart';
import 'package:jawara_mobile_v2/widgets/custom_photo_viewer.dart';
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

  const TransferChannelDetailScreen({super.key, required this.id});

  @override
  State<TransferChannelDetailScreen> createState() =>
      _TransferChannelDetailScreenState();
}
class _TransferChannelDetailScreenState
    extends State<TransferChannelDetailScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _notesController = TextEditingController();

  // Selections
  TransferChannelType? _selectedType;
  bool _isEditMode = false;
  
  // TransferChannelDetailModel? _transferChannel;

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
      
      // Ambil langsung dari provider
      final transferChannel = transferChannelProvider.selectedTransferChannel;

      if (transferChannel != null && mounted) {
        _initializeFields(transferChannel);
      }
    }
  }

  // Terima parameter
  void _initializeFields(TransferChannelDetailModel transferChannel) {
    setState(() {
      _nameController.text = transferChannel.name;
      _selectedType = transferChannel.type;
      _ownerNameController.text = transferChannel.ownerName;
      _accountNumberController.text = transferChannel.accountNumber;
      _notesController.text = transferChannel.notes;
    });
  }

  void _toggleEditMode() {
    final transferChannelProvider = context.read<TransferChannelProvider>();
    final transferChannel = transferChannelProvider.selectedTransferChannel;
    
    setState(() {
      _isEditMode = !_isEditMode;
      if (!_isEditMode && transferChannel != null) {
        _initializeFields(transferChannel); // Reset to original data
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
    
    // ✅ Ambil dari provider
    final transferChannel = transferChannelProvider.selectedTransferChannel;
    if (transferChannel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data tidak ditemukan')),
      );
      return;
    }

    final token = authProvider.token;
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Anda belum login')),
      );
      return;
    }

    final request = TransferChannelDetailModel(
      id: transferChannel.id,
      name: _nameController.text,
      type: _selectedType ?? transferChannel.type,
      ownerName: _ownerNameController.text,
      accountNumber: _accountNumberController.text,
      notes: _notesController.text,
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
          // ✅ Ambil dari provider di sini
          final transferChannel = provider.selectedTransferChannel;
          
          if (provider.isLoading && transferChannel == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null && transferChannel == null) {
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

          // Guard clause
          if (transferChannel == null) {
            return const Center(
              child: Text('Data tidak ditemukan'),
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
                  // ✅ Sekarang aman menggunakan transferChannel
                  if (transferChannel.qrCodeImagePath != null) ...[
                    const SizedBox(height: Rem.rem1_5),
                    CustomPhotoViewer(
                      photoUrl: transferChannel.qrCodeImagePath!,
                    ),
                  ],
                  const SizedBox(height: Rem.rem1_5),
                  if (transferChannel.thumbnailImagePath != null) ...[
                    CustomPhotoViewer(
                      photoUrl: transferChannel.thumbnailImagePath!,
                    ),
                  ],
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
                            onPressed: provider.isLoading
                                ? null
                                : _updateTransferChannel,
                            child: provider.isLoading
                                ? const SizedBox(
                                    height: Rem.rem1_25,
                                    width: Rem.rem1_25,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    'Simpan',
                                    style: GoogleFonts.poppins(
                                      fontSize: Rem.rem1,
                                    ),
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
}
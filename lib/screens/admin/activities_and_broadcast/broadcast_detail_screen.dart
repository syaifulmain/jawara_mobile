import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_mobile_v2/widgets/file_picker_button.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../constants/color_constant.dart';
import '../../../constants/rem_constant.dart';
import '../../../models/broadcast_model.dart';
import '../../../providers/broadcast_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../widgets/custom_photo_viewer.dart';
import '../../../widgets/document_viewer.dart';

class BroadcastDetailScreen extends StatefulWidget {
  final String broadcastId;

  const BroadcastDetailScreen({Key? key, required this.broadcastId})
    : super(key: key);

  @override
  State<BroadcastDetailScreen> createState() => _BroadcastDetailScreenState();
}

class _BroadcastDetailScreenState extends State<BroadcastDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isEditMode = false;
  Broadcast? _broadcast;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_broadcast == null) {
      _loadBroadcast();
    }
  }

  void _loadBroadcast() {
    final broadcastProvider = context.read<BroadcastProvider>();

    _broadcast = broadcastProvider.broadcasts.firstWhere(
      (b) => b.id.toString() == widget.broadcastId,
    );

    if (_broadcast != null) {
      _titleController.text = _broadcast!.title;
      _messageController.text = _broadcast!.message;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
      if (!_isEditMode) {
        _loadBroadcast();
      }
    });
  }

  Future<void> _updateBroadcast() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final updatedBroadcast = _broadcast!.copyWith(
      title: _titleController.text,
      message: _messageController.text,
    );

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final broadcastProvider = Provider.of<BroadcastProvider>(
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

    final success = await broadcastProvider.updateBroadcast(
      token,
      widget.broadcastId,
      updatedBroadcast,
    );

    if (success) {
      if (mounted) {
        setState(() {
          _isEditMode = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Broadcast berhasil diperbarui')),
        );
        _loadBroadcast();
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              broadcastProvider.errorMessage ?? 'Gagal memperbarui broadcast',
            ),
          ),
        );
      }
    }
  }

  Future<void> _deleteBroadcast() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Broadcast'),
        content: const Text('Apakah Anda yakin ingin menghapus broadcast ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final broadcastProvider = Provider.of<BroadcastProvider>(
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

    final success = await broadcastProvider.deleteBroadcast(
      token,
      widget.broadcastId,
    );

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Broadcast berhasil dihapus')),
        );
        context.pop();
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              broadcastProvider.errorMessage ?? 'Gagal menghapus broadcast',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMMM yyyy, HH:mm');

    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
        title: Text(
          _isEditMode ? 'Edit Broadcast' : 'Detail Broadcast',
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
          if (!_isEditMode)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: _deleteBroadcast,
              tooltip: 'Hapus',
            ),
        ],
      ),
      body: Consumer<BroadcastProvider>(
        builder: (context, provider, _) {
          if (_broadcast == null) {
            return const Center(child: Text('Broadcast tidak ditemukan'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(Rem.rem1_5),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextFormField(
                    controller: _titleController,
                    labelText: "Judul Broadcast",
                    hintText: "Masukkan judul broadcast",
                    readOnly: !_isEditMode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Judul harus diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: Rem.rem1),
                  CustomTextFormField(
                    controller: _messageController,
                    labelText: "Pesan",
                    hintText: "Masukkan pesan broadcast",
                    maxLines: 6,
                    readOnly: !_isEditMode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Pesan harus diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: Rem.rem1),
                  _buildInfoField(
                    "Pembuat",
                    _broadcast!.creatorName ?? 'Unknown',
                    Icons.person,
                  ),
                  const SizedBox(height: Rem.rem1),
                  _buildInfoField(
                    "Tanggal Publikasi",
                    _broadcast!.publishedAt != null
                        ? dateFormat.format(_broadcast!.publishedAt!)
                        : 'Belum dipublikasi',
                    Icons.calendar_today,
                  ),
                  if (_broadcast!.photo != null) ...[
                    const SizedBox(height: Rem.rem1_5),
                    CustomPhotoViewer(photoUrl: _broadcast!.photoUrl!),
                  ],
                  if (_broadcast!.document != null) ...[
                    const SizedBox(height: Rem.rem1_5),
                    DocumentViewer(documentUrl: _broadcast!.documentUrl!),
                  ],
                  if (_isEditMode) ...[
                    const SizedBox(height: Rem.rem1_5),
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
                                : _updateBroadcast,
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

  Widget _buildInfoField(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: Rem.rem1,
            fontWeight: FontWeight.normal,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: Rem.rem0_5),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: Rem.rem1,
            vertical: Rem.rem0_875,
          ),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(Rem.rem0_5),
          ),
          child: Row(
            children: [
              Icon(icon, size: Rem.rem1_25, color: Colors.grey),
              const SizedBox(width: Rem.rem0_75),
              Expanded(
                child: Text(
                  value,
                  style: GoogleFonts.poppins(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

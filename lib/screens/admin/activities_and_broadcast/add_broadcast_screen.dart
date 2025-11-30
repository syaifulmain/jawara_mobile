import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../../../constants/color_constant.dart';
import '../../../constants/rem_constant.dart';
import '../../../models/broadcast_model.dart';
import '../../../providers/broadcast_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_form_field.dart';

class AddBroadcastScreen extends StatefulWidget {
  const AddBroadcastScreen({Key? key}) : super(key: key);

  @override
  State<AddBroadcastScreen> createState() => _AddBroadcastScreenState();
}

class _AddBroadcastScreenState extends State<AddBroadcastScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  File? _photoFile;
  File? _documentFile;
  String? _photoFileName;
  String? _documentFileName;

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _photoFile = File(result.files.single.path!);
          _photoFileName = result.files.single.name;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal memilih foto: $e')));
      }
    }
  }

  Future<void> _pickDocument() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _documentFile = File(result.files.single.path!);
          _documentFileName = result.files.single.name;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal memilih dokumen: $e')));
      }
    }
  }

  void _removePhoto() {
    setState(() {
      _photoFile = null;
      _photoFileName = null;
    });
  }

  void _removeDocument() {
    setState(() {
      _documentFile = null;
      _documentFileName = null;
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final broadcast = Broadcast(
      title: _titleController.text,
      message: _messageController.text,
      publishedAt: DateTime.now(),
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

    final success = await broadcastProvider.createBroadcast(
      token,
      broadcast,
      photoFile: _photoFile,
      documentFile: _documentFile,
    );

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Broadcast berhasil ditambahkan')),
        );
        context.pop();
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              broadcastProvider.errorMessage ?? 'Gagal menambahkan broadcast',
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
          'Tambah Broadcast',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<BroadcastProvider>(
        builder: (context, provider, _) {
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Pesan harus diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: Rem.rem1),
                  Text(
                    "Lampiran (Opsional)",
                    style: GoogleFonts.poppins(
                      fontSize: Rem.rem1,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: Rem.rem0_5),
                  if (_photoFile != null)
                    Container(
                      padding: const EdgeInsets.all(Rem.rem0_75),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(Rem.rem0_5),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.image, color: Colors.blue),
                          const SizedBox(width: Rem.rem0_5),
                          Expanded(
                            child: Text(
                              _photoFileName ?? 'Foto',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: Rem.rem1_25),
                            onPressed: _removePhoto,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    )
                  else
                    CustomButton(
                      onPressed: _pickPhoto,
                      isOutlined: true,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.add_photo_alternate),
                          const SizedBox(width: 8),
                          const Text('Tambahkan Foto'),
                        ],
                      ),
                    ),
                  const SizedBox(height: Rem.rem0_75),
                  if (_documentFile != null)
                    Container(
                      padding: const EdgeInsets.all(Rem.rem0_75),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(Rem.rem0_5),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.description, color: Colors.orange),
                          const SizedBox(width: Rem.rem0_5),
                          Expanded(
                            child: Text(
                              _documentFileName ?? 'Dokumen',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: Rem.rem1_25),
                            onPressed: _removeDocument,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    )
                  else
                    CustomButton(
                      onPressed: _pickDocument,
                      isOutlined: true,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.attach_file),
                          const SizedBox(width: 8),
                          const Text('Tambahkan Dokumen'),
                        ],
                      ),
                    ),
                  const SizedBox(height: Rem.rem1_5),
                  CustomButton(
                    onPressed: provider.isLoading ? null : _submitForm,
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
                            'Kirim Broadcast',
                            style: GoogleFonts.poppins(fontSize: Rem.rem1),
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
}

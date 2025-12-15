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
import '../../../widgets/file_picker_button.dart';

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
                  FilePickerButton(
                    file: _photoFile,
                    fileName: _photoFileName,
                    fileType: FileType.image,
                    onFilePicked: (file, fileName) {
                      setState(() {
                        _photoFile = file;
                        _photoFileName = fileName;
                      });
                    },
                    onFileRemoved: () {
                      setState(() {
                        _photoFile = null;
                        _photoFileName = null;
                      });
                    },
                    icon: Icons.add_photo_alternate,
                    iconColor: Colors.blue,
                    buttonText: 'Tambahkan Foto',
                  ),
                  const SizedBox(height: Rem.rem0_75),
                  FilePickerButton(
                    file: _documentFile,
                    fileName: _documentFileName,
                    fileType: FileType.custom,
                    allowedExtensions: ['pdf', 'doc', 'docx'],
                    onFilePicked: (file, fileName) {
                      setState(() {
                        _documentFile = file;
                        _documentFileName = fileName;
                      });
                    },
                    onFileRemoved: () {
                      setState(() {
                        _documentFile = null;
                        _documentFileName = null;
                      });
                    },
                    icon: Icons.attach_file,
                    iconColor: Colors.orange,
                    buttonText: 'Tambahkan Dokumen',
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

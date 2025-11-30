// dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:jawara_mobile/constants/colors.dart';
import 'package:jawara_mobile/constants/rem.dart';
import 'package:jawara_mobile/models/channel_transfer_model.dart';
import 'package:jawara_mobile/providers/channel_transfer_form_provider.dart';
import 'package:jawara_mobile/widgets/custom_button.dart';
import 'package:jawara_mobile/widgets/custom_dropdown.dart';
import 'package:jawara_mobile/widgets/custom_file_upload.dart';

class TambahChannelTransferScreen extends StatefulWidget {
  const TambahChannelTransferScreen({super.key});

  @override
  State<TambahChannelTransferScreen> createState() =>
      _TambahChannelTransferScreenState();
}

class _TambahChannelTransferScreenState
    extends State<TambahChannelTransferScreen> {
  Future<void> _handleImagePick(ChannelTransferFormProvider provider,
      {required String target}) async {
    try {
      final String? choice = await showDialog<String>(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text('Pilih Sumber Gambar',
                style: GoogleFonts.figtree(fontWeight: FontWeight.w600)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: Text('Kamera', style: GoogleFonts.figtree()),
                  onTap: () => Navigator.of(ctx).pop('camera'),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: Text('Gallery', style: GoogleFonts.figtree()),
                  onTap: () => Navigator.of(ctx).pop('gallery'),
                ),
              ],
            ),
          );
        },
      );

      if (choice == null) return;

      final ImagePicker picker = ImagePicker();
      final XFile? file = await picker.pickImage(
        source: choice == 'camera' ? ImageSource.camera : ImageSource.gallery,
      );

      if (file != null) {
        if (target == 'qr') {
          provider.setQrPath(file.path);
        } else {
          provider.setThumbnailPath(file.path);
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gambar berhasil dipilih'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _submitForm(ChannelTransferFormProvider provider) {
    if (!provider.isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon lengkapi semua field yang diperlukan'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final ChannelTransferModel formData = provider.getFormData();
    // Currently just debug print; in real app persist via API / local store
    debugPrint(
        'ChannelTransferModel: ${formData.namaChannel}, tipe=${formData.tipe.label}, QR=${formData.QRPath}, thumb=${formData.thumbnailPath}');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Channel transfer berhasil ditambahkan!'),
        backgroundColor: Colors.green,
      ),
    );

    provider.resetForm();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChannelTransferFormProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(
            title: Text('Tambah Channel Transfer', style: GoogleFonts.figtree()),
            backgroundColor: AppColors.primaryColor,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(Rem.rem1),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Rem.rem0_75),
              ),
              child: Padding(
                padding: const EdgeInsets.all(Rem.rem1_5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Buat Channel Transfer Baru',
                      style: GoogleFonts.figtree(
                        fontSize: Rem.rem1_5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: Rem.rem1_5),

                    // Nama Channel
                    Text('Nama Channel',
                        style: GoogleFonts.figtree(
                            fontSize: Rem.rem1, fontWeight: FontWeight.w500)),
                    const SizedBox(height: Rem.rem0_5),
                    TextField(
                      controller: provider.namaChannelController,
                      style: GoogleFonts.figtree(),
                      decoration: InputDecoration(
                        hintText: 'Contoh: Transfer Bank BCA',
                        hintStyle: GoogleFonts.figtree(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Rem.rem0_5),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: Rem.rem0_75,
                          vertical: Rem.rem0_75,
                        ),
                      ),
                    ),
                    const SizedBox(height: Rem.rem1),

                    // Tipe Channel
                    Text('Tipe Channel',
                        style: GoogleFonts.figtree(
                            fontSize: Rem.rem1, fontWeight: FontWeight.w500)),
                    const SizedBox(height: Rem.rem0_5),
                    CustomDropdown<String>(
                      initialSelection: provider.selectedTipeLabel,
                      hintText: '-- Pilih Tipe Channel --',
                      items: provider.tipeOptions.map((tipeLabel) {
                        return DropdownMenuEntry<String>(
                          value: tipeLabel,
                          label: tipeLabel,
                        );
                      }).toList(),
                      onSelected: (value) {
                        provider.setSelectedTipeLabel(value);
                      },
                    ),
                    const SizedBox(height: Rem.rem1),

                    // Nomor Rekening
                    Text('Nomor Rekening',
                        style: GoogleFonts.figtree(
                            fontSize: Rem.rem1, fontWeight: FontWeight.w500)),
                    const SizedBox(height: Rem.rem0_5),
                    TextField(
                      controller: provider.nomorRekeningController,
                      style: GoogleFonts.figtree(),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Contoh: 0123456789',
                        hintStyle: GoogleFonts.figtree(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Rem.rem0_5),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: Rem.rem0_75,
                          vertical: Rem.rem0_75,
                        ),
                      ),
                    ),
                    const SizedBox(height: Rem.rem1),

                    // Nama Pemilik
                    Text('Nama Pemilik Rekening',
                        style: GoogleFonts.figtree(
                            fontSize: Rem.rem1, fontWeight: FontWeight.w500)),
                    const SizedBox(height: Rem.rem0_5),
                    TextField(
                      controller: provider.namaPemilikController,
                      style: GoogleFonts.figtree(),
                      decoration: InputDecoration(
                        hintText: 'Contoh: PT Contoh Nama',
                        hintStyle: GoogleFonts.figtree(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Rem.rem0_5),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: Rem.rem0_75,
                          vertical: Rem.rem0_75,
                        ),
                      ),
                    ),
                    const SizedBox(height: Rem.rem1),

                    // Catatan
                    Text('Catatan (opsional)',
                        style: GoogleFonts.figtree(
                            fontSize: Rem.rem1, fontWeight: FontWeight.w500)),
                    const SizedBox(height: Rem.rem0_5),
                    TextField(
                      controller: provider.catatanController,
                      style: GoogleFonts.figtree(),
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Tambahkan catatan jika perlu',
                        hintStyle: GoogleFonts.figtree(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Rem.rem0_5),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: Rem.rem0_75,
                          vertical: Rem.rem0_75,
                        ),
                      ),
                    ),
                    const SizedBox(height: Rem.rem1),

                    // QR image upload
                    CustomFileUpload.photo(
                      label: 'Upload QR (opsional)',
                      onTap: () => _handleImagePick(provider, target: 'qr'),
                      selectedFiles:
                      provider.qrPath != null ? [provider.qrPath!] : [],
                      onRemoveFile: (_) => provider.setQrPath(null),
                    ),
                    const SizedBox(height: Rem.rem1),

                    // Thumbnail upload
                    CustomFileUpload.photo(
                      label: 'Upload Thumbnail (opsional)',
                      onTap: () =>
                          _handleImagePick(provider, target: 'thumbnail'),
                      selectedFiles: provider.thumbnailPath != null
                          ? [provider.thumbnailPath!]
                          : [],
                      onRemoveFile: (_) => provider.setThumbnailPath(null),
                    ),
                    const SizedBox(height: Rem.rem2),

                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            onPressed: () => _submitForm(provider),
                            child: Text('Submit',
                                style: GoogleFonts.figtree(
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                        const SizedBox(width: Rem.rem1),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: provider.resetForm,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.grey),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(Rem.rem0_5),
                              ),
                            ),
                            child: Text('Reset',
                                style: GoogleFonts.figtree(
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

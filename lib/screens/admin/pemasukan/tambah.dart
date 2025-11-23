import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_mobile/constants/colors.dart';
import 'package:jawara_mobile/constants/rem.dart';
import 'package:jawara_mobile/widgets/custom_button.dart';
import 'package:jawara_mobile/widgets/custom_dropdown.dart';
import 'package:jawara_mobile/widgets/custom_file_upload.dart';
import 'package:jawara_mobile/widgets/custom_text_field.dart';
import 'package:jawara_mobile/widgets/white_card_page.dart';
import 'package:jawara_mobile/providers/pemasukan_form_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class PemasukanTambahScreen extends StatefulWidget {
  // final String title = 'Buat Pemasukan Baru';
  // final DateTime selectedDate = DateTime.now();

  const PemasukanTambahScreen({super.key});

  @override
  State<PemasukanTambahScreen> createState() => _PemasukanTambahScreenState();
}

@override
class _PemasukanTambahScreenState extends State<PemasukanTambahScreen> {
  Future<void> _selectDate(PemasukanFormProvider provider) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      provider.setSelectedDate(picked);
    }
  }

  void _submitForm(PemasukanFormProvider provider) {
    if (!provider.isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon lengkapi semua field yang diperlukan'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // TODO: Implementasi submit form dengan data dari provider.getFormData()
    final formData = provider.getFormData();
    print('Form data: $formData'); // Debug print

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kegiatan berhasil ditambahkan!'),
        backgroundColor: Colors.green,
      ),
    );

    // Reset form
    provider.resetForm();
  }

  Widget build(BuildContext context) {
    return Consumer<PemasukanFormProvider>(
      builder: (context, provider, child) => _buildContent(context, provider),
    );
  }

  @override
  Widget _buildContent(BuildContext context, PemasukanFormProvider provider) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(Rem.rem1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Rem.rem0_75),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(Rem.rem1_5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Buat Data Pemasukan Baru',
              style: GoogleFonts.figtree(
                fontSize: Rem.rem1_5,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: Rem.rem1_5),

            // Form
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama Pemasukan
                    Text(
                      'Nama Pemasukan',
                      style: GoogleFonts.figtree(
                        fontSize: Rem.rem1,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: Rem.rem0_5),
                    TextField(
                      controller: provider.namaController,
                      style: GoogleFonts.figtree(),
                      decoration: InputDecoration(
                        hintText: 'Contoh: Iuran Warga Bulan Juni',
                        hintStyle: GoogleFonts.figtree(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Rem.rem0_5),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Rem.rem0_5),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Rem.rem0_5),
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: Rem.rem0_75,
                          vertical: Rem.rem0_75,
                        ),
                      ),
                    ),
                    const SizedBox(height: Rem.rem1),

                    // Jenis Pemasukan
                    Text(
                      'Jenis Pemasukan',
                      style: GoogleFonts.figtree(
                        fontSize: Rem.rem1,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: Rem.rem0_5),
                    CustomDropdown<String>(
                      initialSelection: provider.selectedJenisPemasukan,
                      hintText: '-- Pilih Jenis Pemasukan --',
                      items: provider.jenisPemasukanOptions.map((jenis) {
                        return DropdownMenuEntry<String>(
                          value: jenis,
                          label: jenis,
                        );
                      }).toList(),
                      onSelected: (value) {
                        provider.setSelectedJenisPemasukan(value);
                      },
                    ),
                    const SizedBox(height: Rem.rem1),

                    // Tanggal
                    Text(
                      'Tanggal Pemasukan',
                      style: GoogleFonts.figtree(
                        fontSize: Rem.rem1,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: Rem.rem0_5),
                    TextField(
                      controller: provider.tanggalController,
                      readOnly: true,
                      style: GoogleFonts.figtree(),
                      decoration: InputDecoration(
                        hintText: '--/--/---- ',
                        hintStyle: GoogleFonts.figtree(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Rem.rem0_5),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Rem.rem0_5),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Rem.rem0_5),
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: Rem.rem0_75,
                          vertical: Rem.rem0_75,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () => _selectDate(provider),
                        ),
                      ),
                    ),
                    const SizedBox(height: Rem.rem1),

                    // Nominal
                    Text(
                      'Nominal',
                      style: GoogleFonts.figtree(
                        fontSize: Rem.rem1,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: Rem.rem0_5),
                    TextField(
                      controller: provider.nominalController,
                      style: GoogleFonts.figtree(),
                      decoration: InputDecoration(
                        hintText: 'Contoh: 500000',
                        hintStyle: GoogleFonts.figtree(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Rem.rem0_5),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Rem.rem0_5),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Rem.rem0_5),
                          borderSide: const BorderSide(
                            color: AppColors.primaryColor,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: Rem.rem0_75,
                          vertical: Rem.rem0_75,
                        ),
                      ),
                    ),
                    const SizedBox(height: Rem.rem1),
                    CustomFileUpload.photo(
                      label: 'Upload Foto Bukti Pemasukan',
                      onTap: () => _handlePhotoUpload(provider),
                      selectedFiles: provider.selectedPhotos,
                      onRemoveFile: (index) => provider.removePhoto(index),
                    ),
                    const SizedBox(height: Rem.rem2),

                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            onPressed: () => _submitForm(provider),
                            child: Text(
                              'Submit',
                              style: GoogleFonts.figtree(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: Rem.rem1),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: provider.resetForm,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.grey),
                              padding: const EdgeInsets.symmetric(vertical: 23),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(Rem.rem0_5),
                              ),
                            ),
                            child: Text(
                              'Reset',
                              style: GoogleFonts.figtree(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handlePhotoUpload(PemasukanFormProvider provider) async {
    try {
      // Tampilkan dialog pilihan
      final String? choice = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Pilih Sumber Gambar',
              style: GoogleFonts.figtree(fontWeight: FontWeight.w600),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: Text('Kamera', style: GoogleFonts.figtree()),
                  onTap: () => Navigator.of(context).pop('camera'),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: Text('Gallery', style: GoogleFonts.figtree()),
                  onTap: () => Navigator.of(context).pop('gallery'),
                ),
              ],
            ),
          );
        },
      );

      if (choice != null) {
        final ImagePicker picker = ImagePicker();

        if (choice == 'camera') {
          // Pilih dari camera
          final XFile? photo = await picker.pickImage(
            source: ImageSource.camera,
          );

          if (photo != null) {
            provider.addPhoto(photo.path);

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Foto berhasil diambil!'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          }
        } else if (choice == 'gallery') {
          // Pilih dari gallery (multiple)
          final List<XFile> images = await picker.pickMultiImage();

          if (images.isNotEmpty) {
            provider.addPhotos(images.map((image) => image.path).toList());

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${images.length} foto berhasil dipilih!'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          }
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
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../constants/color_constant.dart';
import '../../../constants/rem_constant.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/fruit_image_provider.dart';
import '../../../providers/user_family_provider.dart';
import '../../../widgets/custom_button.dart';
import '../../../models/fruit/fruit_classification_model.dart';

class FruitClassificationScreen extends StatefulWidget {
  const FruitClassificationScreen({Key? key}) : super(key: key);

  @override
  State<FruitClassificationScreen> createState() =>
      _FruitClassificationScreenState();
}

class _FruitClassificationScreenState extends State<FruitClassificationScreen> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      final userFamilyProvider = context.read<UserFamilyProvider>();
      if (authProvider.token != null) {
        userFamilyProvider.fetchMyFamily(authProvider.token!);
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (photo != null) {
        setState(() {
          _selectedImage = File(photo.path);
        });
        _classifyImage();
      }
    } catch (e) {
      _showErrorSnackBar('Gagal mengambil foto: $e');
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
        _classifyImage();
      }
    } catch (e) {
      _showErrorSnackBar('Gagal memilih gambar: $e');
    }
  }

  Future<void> _classifyImage() async {
    if (_selectedImage == null) return;

    final fruitProvider = context.read<FruitImageProvider>();
    final success = await fruitProvider.classifyFruit(_selectedImage!);

    if (!success && mounted) {
      _showErrorSnackBar(
        fruitProvider.errorMessage ?? 'Gagal mengklasifikasi gambar',
      );
    } else if (success && mounted) {
      // Auto-fill name with classification result
      final classification = fruitProvider.lastClassification;
      if (classification != null) {
        _nameController.text = classification.prediction.className;
      }
    }
  }

  Future<void> _saveImage() async {
    if (_selectedImage == null) {
      _showErrorSnackBar('Pilih gambar terlebih dahulu');
      return;
    }

    if (_nameController.text.trim().isEmpty) {
      _showErrorSnackBar('Masukkan nama buah');
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final fruitProvider = context.read<FruitImageProvider>();
    final userFamilyProvider = context.read<UserFamilyProvider>();

    if (authProvider.token == null) {
      _showErrorSnackBar('Token tidak valid');
      return;
    }

    final family = userFamilyProvider.selectedFamily;
    if (family == null || family.id == null) {
      _showErrorSnackBar('Data keluarga tidak ditemukan');
      return;
    }

    final familyId = family.id!;

    final result = await fruitProvider.saveFruitImage(
      authProvider.token!,
      name: _nameController.text.trim(),
      familyId: familyId,
      imageFile: _selectedImage!,
    );

    if (mounted) {
      if (result != null) {
        _showSuccessSnackBar('Gambar berhasil disimpan');
        _resetForm();
      } else {
        _showErrorSnackBar(
          fruitProvider.errorMessage ?? 'Gagal menyimpan gambar',
        );
      }
    }
  }

  void _resetForm() {
    setState(() {
      _selectedImage = null;
      _nameController.clear();
    });
    context.read<FruitImageProvider>().clearClassification();
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(Rem.rem1_5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Pilih Sumber Gambar',
              style: GoogleFonts.poppins(
                fontSize: Rem.rem1_25,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: Rem.rem1_5),
            ListTile(
              leading: const Icon(
                Icons.camera_alt,
                color: AppColors.primaryColor,
              ),
              title: const Text('Kamera'),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromCamera();
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: AppColors.primaryColor,
              ),
              title: const Text('Galeri'),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromGallery();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Klasifikasi Buah'),
        actions: [
          if (_selectedImage != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _resetForm,
              tooltip: 'Reset',
            ),
        ],
      ),
      body: Consumer<FruitImageProvider>(
        builder: (context, fruitProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(Rem.rem1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Info Card
                Card(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(Rem.rem1),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: AppColors.primaryColor,
                        ),
                        const SizedBox(width: Rem.rem0_75),
                        Expanded(
                          child: Text(
                            'Ambil atau pilih foto buah untuk mengidentifikasi jenisnya',
                            style: GoogleFonts.poppins(
                              fontSize: Rem.rem0_875,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: Rem.rem1_5),

                // Image Display
                if (_selectedImage != null) ...[
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Rem.rem0_75),
                      border: Border.all(color: Colors.grey.shade300, width: 2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Rem.rem0_75),
                      child: Image.file(_selectedImage!, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: Rem.rem1_5),
                ] else ...[
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(Rem.rem0_75),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_outlined,
                          size: 80,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: Rem.rem1),
                        Text(
                          'Belum ada gambar dipilih',
                          style: GoogleFonts.poppins(
                            color: Colors.grey.shade600,
                            fontSize: Rem.rem1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Rem.rem1_5),
                ],

                // Select Image Button
                CustomButton(
                  onPressed: _showImageSourceDialog,
                  isOutlined: true,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.add_photo_alternate),
                      const SizedBox(width: Rem.rem0_5),
                      Text(
                        _selectedImage == null
                            ? 'Pilih Gambar'
                            : 'Ganti Gambar',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Rem.rem1_5),

                // Classification Result
                if (fruitProvider.isClassifying)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(Rem.rem1_5),
                      child: Column(
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: Rem.rem1),
                          Text(
                            'Mengklasifikasi gambar...',
                            style: GoogleFonts.poppins(fontSize: Rem.rem0_875),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (fruitProvider.lastClassification != null)
                  _buildClassificationResult(fruitProvider.lastClassification!),

                const SizedBox(height: Rem.rem1_5),

                // Name Input
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nama Buah',
                    hintText: 'Masukkan nama buah',
                    prefixIcon: const Icon(Icons.label),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Rem.rem0_5),
                    ),
                  ),
                ),
                const SizedBox(height: Rem.rem1_5),

                // Save Button
                if (fruitProvider.isSaving)
                  const Center(child: CircularProgressIndicator())
                else
                  CustomButton(
                    onPressed: _saveImage,
                    child: const Text('Simpan Gambar'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildClassificationResult(FruitClassification classification) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(Rem.rem1_5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 24),
                const SizedBox(width: Rem.rem0_5),
                Text(
                  'Hasil Klasifikasi',
                  style: GoogleFonts.poppins(
                    fontSize: Rem.rem1_125,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Divider(height: Rem.rem1_5),

            // Main Prediction
            Container(
              padding: const EdgeInsets.all(Rem.rem1),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(Rem.rem0_5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    classification.prediction.className,
                    style: GoogleFonts.poppins(
                      fontSize: Rem.rem1_25,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: Rem.rem0_5),
                  Row(
                    children: [
                      const Icon(
                        Icons.bar_chart,
                        size: 16,
                        color: Colors.black54,
                      ),
                      const SizedBox(width: Rem.rem0_25),
                      Text(
                        'Confidence: ${classification.prediction.confidencePercentage}',
                        style: GoogleFonts.poppins(
                          fontSize: Rem.rem0_875,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: Rem.rem1),

            // Top 5 Predictions
            Text(
              'Top 5 Prediksi:',
              style: GoogleFonts.poppins(
                fontSize: Rem.rem1,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: Rem.rem0_5),
            ...classification.top5Predictions.map((pred) {
              return Padding(
                padding: const EdgeInsets.only(bottom: Rem.rem0_5),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: pred.rank == 1
                            ? AppColors.primaryColor
                            : Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${pred.rank}',
                          style: GoogleFonts.poppins(
                            fontSize: Rem.rem0_75,
                            fontWeight: FontWeight.w600,
                            color: pred.rank == 1
                                ? Colors.white
                                : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: Rem.rem0_75),
                    Expanded(
                      child: Text(
                        pred.className,
                        style: GoogleFonts.poppins(fontSize: Rem.rem0_875),
                      ),
                    ),
                    Text(
                      pred.confidencePercentage,
                      style: GoogleFonts.poppins(
                        fontSize: Rem.rem0_75,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),

            const Divider(height: Rem.rem1_5),

            // Performance Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPerformanceChip(
                  'Model',
                  classification.metadata.modelType,
                ),
                _buildPerformanceChip(
                  'Time',
                  classification.performance.totalTime,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Rem.rem0_75,
        vertical: Rem.rem0_5,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(Rem.rem0_5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: Rem.rem0_625,
              color: Colors.black54,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: Rem.rem0_875,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

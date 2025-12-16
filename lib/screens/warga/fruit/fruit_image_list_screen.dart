import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../constants/rem_constant.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/fruit_image_provider.dart';
import '../../../providers/user_family_provider.dart';
import '../../../widgets/custom_image_display.dart';
import '../../../models/fruit/fruit_image_model.dart';

class FruitImageListScreen extends StatefulWidget {
  const FruitImageListScreen({Key? key}) : super(key: key);

  @override
  State<FruitImageListScreen> createState() => _FruitImageListScreenState();
}

class _FruitImageListScreenState extends State<FruitImageListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFruitImages();
    });
  }

  void _loadFruitImages() {
    final authProvider = context.read<AuthProvider>();
    final fruitProvider = context.read<FruitImageProvider>();
    final userFamilyProvider = context.read<UserFamilyProvider>();

    if (authProvider.token != null) {
      // Load family first if not already loaded
      if (userFamilyProvider.selectedFamily == null) {
        userFamilyProvider.fetchMyFamily(authProvider.token!).then((_) {
          final family = userFamilyProvider.selectedFamily;
          if (family != null && family.id != null) {
            fruitProvider.fetchFruitImages(
              authProvider.token!,
              familyId: family.id!,
            );
          }
        });
      } else {
        final family = userFamilyProvider.selectedFamily;
        if (family != null && family.id != null) {
          fruitProvider.fetchFruitImages(
            authProvider.token!,
            familyId: family.id!,
          );
        }
      }
    }
  }

  Future<void> _deleteImage(int id) async {
    final authProvider = context.read<AuthProvider>();
    final fruitProvider = context.read<FruitImageProvider>();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Gambar'),
        content: const Text('Apakah Anda yakin ingin menghapus gambar ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      final success = await fruitProvider.deleteFruitImage(
        authProvider.token!,
        id,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success ? 'Gambar berhasil dihapus' : 'Gagal menghapus gambar',
            ),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Gambar Buah')),
      body: Consumer<FruitImageProvider>(
        builder: (context, fruitProvider, child) {
          if (fruitProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (fruitProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: Rem.rem1),
                  Text(
                    fruitProvider.errorMessage!,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: Rem.rem1),
                  ElevatedButton(
                    onPressed: _loadFruitImages,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          if (fruitProvider.fruitImages.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_not_supported,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: Rem.rem1),
                  Text(
                    'Belum ada gambar buah tersimpan',
                    style: GoogleFonts.poppins(
                      fontSize: Rem.rem1,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: Rem.rem0_5),
                  Text(
                    'Mulai klasifikasi buah untuk menyimpan gambar',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: Rem.rem0_875,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => _loadFruitImages(),
            child: ListView.builder(
              padding: const EdgeInsets.all(Rem.rem1),
              itemCount: fruitProvider.fruitImages.length,
              itemBuilder: (context, index) {
                return _FruitImageCard(
                  fruitImage: fruitProvider.fruitImages[index],
                  onDelete: _deleteImage,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _FruitImageCard extends StatelessWidget {
  final FruitImage fruitImage;
  final Function(int) onDelete;

  const _FruitImageCard({required this.fruitImage, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');

    return Card(
      margin: const EdgeInsets.only(bottom: Rem.rem1),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Rem.rem0_75),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          if (fruitImage.fileUrl != null)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(Rem.rem0_75),
              ),
              child: CustomImageDisplay(
                imageUrl: fruitImage.fileUrl!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            )
          else
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(Rem.rem0_75),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.image_not_supported,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
              ),
            ),

          // Content
          Padding(
            padding: const EdgeInsets.all(Rem.rem1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        fruitImage.name,
                        style: GoogleFonts.poppins(
                          fontSize: Rem.rem1_125,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        if (fruitImage.id != null) {
                          onDelete(fruitImage.id!);
                        }
                      },
                      tooltip: 'Hapus',
                    ),
                  ],
                ),
                const SizedBox(height: Rem.rem0_5),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: Rem.rem0_25),
                    Text(
                      fruitImage.createdAt != null
                          ? dateFormat.format(fruitImage.createdAt!)
                          : '-',
                      style: GoogleFonts.poppins(
                        fontSize: Rem.rem0_875,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

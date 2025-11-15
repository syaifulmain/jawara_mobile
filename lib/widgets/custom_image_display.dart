import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_mobile/constants/colors.dart';
import 'package:jawara_mobile/constants/rem.dart';

/// Widget untuk menampilkan gambar dengan thumbnail dan preview modal
/// 
/// Contoh penggunaan:
/// ```dart
/// CustomImageDisplay(
///   label: 'Dokumentasi Event',
///   imagePath: 'https://example.com/image.jpg', // atau path asset
///   onEdit: () {
///     // Fungsi untuk mengganti gambar
///     showImagePickerModal();
///   },
///   thumbnailWidth: 150,  // opsional, default 150
///   thumbnailHeight: 200, // opsional, default 200
/// )
/// ```
class CustomImageDisplay extends StatelessWidget {
  final String label;
  final String? imagePath;
  final VoidCallback? onEdit;
  final double thumbnailHeight;
  final double thumbnailWidth;

  const CustomImageDisplay({
    super.key,
    required this.label,
    this.imagePath,
    this.onEdit,
    this.thumbnailHeight = 200,
    this.thumbnailWidth = 150,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label dengan tombol ubah
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: Rem.rem0_875,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            if (onEdit != null)
              TextButton(
                onPressed: onEdit,
                child: Text(
                  'Ubah',
                  style: GoogleFonts.poppins(
                    fontSize: Rem.rem0_75,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: Rem.rem0_5),

        // Thumbnail gambar
        GestureDetector(
          onTap: imagePath != null ? () => _showFullImage(context) : null,
          child: Container(
            width: thumbnailWidth,
            height: thumbnailHeight,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(Rem.rem0_5),
              color: Colors.grey.shade50,
            ),
            child: imagePath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(Rem.rem0_5),
                    child: _buildImageWidget(),
                  )
                : _buildPlaceholder(),
          ),
        ),
      ],
    );
  }

  Widget _buildImageWidget() {
    if (imagePath!.startsWith('http')) {
      return Image.network(
        imagePath!,
        fit: BoxFit.cover,
        width: thumbnailWidth,
        height: thumbnailHeight,
        errorBuilder: (context, error, stackTrace) => _buildErrorPlaceholder(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildLoadingPlaceholder();
        },
      );
    } else {
      return Image.asset(
        imagePath!,
        fit: BoxFit.cover,
        width: thumbnailWidth,
        height: thumbnailHeight,
        errorBuilder: (context, error, stackTrace) => _buildErrorPlaceholder(),
      );
    }
  }

  Widget _buildPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.image_outlined,
          size: 48,
          color: Colors.grey[400],
        ),
        const SizedBox(height: Rem.rem0_5),
        Text(
          'Tidak ada gambar',
          style: GoogleFonts.poppins(
            fontSize: Rem.rem0_75,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.broken_image_outlined,
          size: 48,
          color: Colors.grey[400],
        ),
        const SizedBox(height: Rem.rem0_5),
        Text(
          'Gagal memuat gambar',
          style: GoogleFonts.poppins(
            fontSize: Rem.rem0_75,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primaryColor,
          ),
        ),
        const SizedBox(height: Rem.rem0_5),
        Text(
          'Memuat gambar...',
          style: GoogleFonts.poppins(
            fontSize: Rem.rem0_75,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  void _showFullImage(BuildContext context) {
    if (imagePath == null) return;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(Rem.rem1),
          child: Stack(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black54,
                ),
              ),
              Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.9,
                    maxHeight: MediaQuery.of(context).size.height * 0.8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Rem.rem0_75),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(Rem.rem1),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(Rem.rem0_75),
                            topRight: Radius.circular(Rem.rem0_75),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              label,
                              style: GoogleFonts.poppins(
                                fontSize: Rem.rem1,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.all(Rem.rem1),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(Rem.rem0_5),
                            child: imagePath!.startsWith('http')
                                ? Image.network(
                                    imagePath!,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) =>
                                        _buildErrorPlaceholder(),
                                  )
                                : Image.asset(
                                    imagePath!,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) =>
                                        _buildErrorPlaceholder(),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
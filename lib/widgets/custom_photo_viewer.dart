import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/rem_constant.dart';

class CustomPhotoViewer extends StatelessWidget {
  final String photoUrl;
  final String? label;

  const CustomPhotoViewer({
    Key? key,
    required this.photoUrl,
    this.label = 'Foto',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label!,
          style: GoogleFonts.poppins(
            fontSize: Rem.rem1,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: Rem.rem0_5),
        ClipRRect(
          borderRadius: BorderRadius.circular(Rem.rem0_5),
          child: CachedNetworkImage(
            imageUrl: photoUrl,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              height: 200,
              color: Colors.grey.shade200,
              child: const Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => Container(
              height: 200,
              color: Colors.grey.shade200,
              child: const Icon(Icons.error),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/rem_constant.dart';

class DocumentViewer extends StatelessWidget {
  final String documentUrl;
  final String? label;
  final String? buttonText;

  const DocumentViewer({
    Key? key,
    required this.documentUrl,
    this.label = 'Dokumen',
    this.buttonText = 'Lihat Dokumen',
  }) : super(key: key);

  Future<void> _openDocument(BuildContext context) async {
    final uri = Uri.parse(documentUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak dapat membuka dokumen')),
        );
      }
    }
  }

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
        InkWell(
          onTap: () => _openDocument(context),
          child: Container(
            padding: const EdgeInsets.all(Rem.rem1),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(Rem.rem0_5),
            ),
            child: Row(
              children: [
                const Icon(Icons.description, color: Colors.orange),
                const SizedBox(width: Rem.rem0_75),
                Expanded(
                  child: Text(
                    buttonText!,
                    style: GoogleFonts.poppins(),
                  ),
                ),
                const Icon(Icons.open_in_new, size: Rem.rem1_25),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

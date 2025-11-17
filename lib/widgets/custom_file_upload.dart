import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_mobile/constants/rem.dart';

class CustomFileUpload extends StatelessWidget {
  final String label;
  final String description;
  final IconData icon;
  final String uploadText;
  final VoidCallback onTap;
  final List<String>? selectedFiles;
  final Function(int index)? onRemoveFile;
  final double height;
  final double? width;

  const CustomFileUpload({
    super.key,
    required this.label,
    required this.description,
    required this.icon,
    required this.uploadText,
    required this.onTap,
    this.selectedFiles,
    this.onRemoveFile,
    this.height = 120,
    this.width,
  });

  factory CustomFileUpload.photo({
    required VoidCallback onTap,
    List<String>? selectedFiles,
    Function(int index)? onRemoveFile,
    String label = 'Foto',
    String description = 'Maksimal 10 gambar (.png / .jpg), ukuran maksimal 5MB per gambar.',
    String uploadText = 'Upload foto png/jpg',
    double height = 120,
    double? width,
  }) {
    return CustomFileUpload(
      label: label,
      description: description,
      icon: Icons.cloud_upload_outlined,
      uploadText: uploadText,
      onTap: onTap,
      selectedFiles: selectedFiles,
      onRemoveFile: onRemoveFile,
      height: height,
      width: width,
    );
  }

  factory CustomFileUpload.document({
    required VoidCallback onTap,
    List<String>? selectedFiles,
    Function(int index)? onRemoveFile,
    String label = 'Dokumen',
    String description = 'Maksimal 10 file (.pdf), ukuran maksimal 5MB per file.',
    String uploadText = 'Upload dokumen pdf',
    double height = 120,
    double? width,
  }) {
    return CustomFileUpload(
      label: label,
      description: description,
      icon: Icons.description_outlined,
      uploadText: uploadText,
      onTap: onTap,
      selectedFiles: selectedFiles,
      onRemoveFile: onRemoveFile,
      height: height,
      width: width,
    );
  }

  factory CustomFileUpload.video({
    required VoidCallback onTap,
    List<String>? selectedFiles,
    Function(int index)? onRemoveFile,
    String label = 'Video',
    String description = 'Maksimal 5 video (.mp4), ukuran maksimal 50MB per video.',
    String uploadText = 'Upload video mp4',
    double height = 120,
    double? width,
  }) {
    return CustomFileUpload(
      label: label,
      description: description,
      icon: Icons.videocam_outlined,
      uploadText: uploadText,
      onTap: onTap,
      selectedFiles: selectedFiles,
      onRemoveFile: onRemoveFile,
      height: height,
      width: width,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.figtree(
            fontSize: Rem.rem1,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: Rem.rem0_25),
        Text(
          description,
          style: GoogleFonts.figtree(
            fontSize: Rem.rem0_75,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: Rem.rem0_5),
        Container(
          width: width ?? double.infinity,
          height: height,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(Rem.rem0_5),
            color: Colors.grey.shade50,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(Rem.rem0_5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 32,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(height: Rem.rem0_5),
                  Text(
                    uploadText,
                    style: GoogleFonts.poppins(
                      color: Colors.grey[600],
                      fontSize: Rem.rem0_875,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (selectedFiles != null && selectedFiles!.isNotEmpty) ...[
          const SizedBox(height: Rem.rem0_75),
          _buildSelectedFilesList(),
        ],
      ],
    );
  }

  Widget _buildSelectedFilesList() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(Rem.rem0_5),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Rem.rem0_75,
              vertical: Rem.rem0_5,
            ),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(Rem.rem0_5),
                topRight: Radius.circular(Rem.rem0_5),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'File terpilih (${selectedFiles!.length})',
                  style: GoogleFonts.poppins(
                    fontSize: Rem.rem0_75,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: selectedFiles!.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: Colors.grey.shade300,
            ),
            itemBuilder: (context, index) {
              final fileName = selectedFiles![index].split('/').last;
              return ListTile(
                dense: true,
                leading: Icon(
                  _getFileIcon(fileName),
                  color: Colors.grey[600],
                  size: 20,
                ),
                title: Text(
                  fileName,
                  style: GoogleFonts.poppins(fontSize: Rem.rem0_75),
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: onRemoveFile != null
                    ? IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.red,
                          size: 18,
                        ),
                        onPressed: () => onRemoveFile!(index),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: Rem.rem0_75,
                  vertical: 0,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  IconData _getFileIcon(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Icons.image;
      case 'mp4':
      case 'avi':
      case 'mov':
        return Icons.video_file;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      default:
        return Icons.insert_drive_file;
    }
  }
}
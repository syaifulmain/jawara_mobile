import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../constants/rem_constant.dart';
import 'custom_button.dart';

class FilePickerButton extends StatelessWidget {
  final File? file;
  final String? fileName;
  final FileType fileType;
  final List<String>? allowedExtensions;
  final Function(File file, String fileName) onFilePicked;
  final VoidCallback onFileRemoved;
  final IconData icon;
  final Color iconColor;
  final String buttonText;

  const FilePickerButton({
    Key? key,
    required this.file,
    required this.fileName,
    required this.fileType,
    this.allowedExtensions,
    required this.onFilePicked,
    required this.onFileRemoved,
    required this.icon,
    required this.iconColor,
    required this.buttonText,
  }) : super(key: key);

  Future<void> _pickFile(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: fileType,
        allowedExtensions: allowedExtensions,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        onFilePicked(
          File(result.files.single.path!),
          result.files.single.name,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memilih file: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (file != null) {
      return Container(
        padding: const EdgeInsets.all(Rem.rem0_75),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(Rem.rem0_5),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: Rem.rem0_5),
            Expanded(
              child: Text(
                fileName ?? 'File',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, size: Rem.rem1_25),
              onPressed: onFileRemoved,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      );
    }

    return CustomButton(
      onPressed: () => _pickFile(context),
      isOutlined: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(buttonText),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_mobile/constants/colors.dart';
import 'package:jawara_mobile/constants/rem.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextEditingController? controller;

  // Tambahan
  final int? minLines;
  final int? maxLines;
  final bool expands;

  const CustomTextField({
    super.key,
    this.labelText,
    this.hintText,
    this.suffixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.controller,
    this.minLines,
    this.maxLines,
    this.expands = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null && labelText!.isNotEmpty) ...[
          Text(
            labelText!,
            style: GoogleFonts.figtree(
              fontSize: Rem.rem1,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: Rem.rem0_5),
        ],
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          style: GoogleFonts.poppins(),
          minLines: obscureText ? 1 : minLines,
          maxLines: obscureText ? 1 : maxLines,
          expands: expands,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.poppins(color: Colors.grey),
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
              borderSide: const BorderSide(color: AppColors.primaryColor),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: Rem.rem0_75,
              vertical: Rem.rem0_25,
            ),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}


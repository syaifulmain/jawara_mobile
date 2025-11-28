import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/color_constant.dart';
import '../constants/rem_constant.dart';

class CustomChip extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;

  const CustomChip({
    super.key,
    required this.label,
    this.backgroundColor = AppColors.primaryColor,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Rem.rem0_5),
        side: BorderSide.none,
      ),
      label: Text(
        label,
        style: GoogleFonts.poppins(fontSize: Rem.rem0_75, color: textColor),
      ),
      backgroundColor: AppColors.primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: Rem.rem0_5),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

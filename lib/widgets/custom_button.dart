import 'package:flutter/material.dart';

import '../constants/color_constant.dart';
import '../constants/rem_constant.dart';

class CustomButton extends StatelessWidget {
  final Function()? onPressed;
  final Color? backgroundColor;
  final Widget? child;

  const CustomButton({super.key, required this.onPressed, required this.child, this.backgroundColor=AppColors.primaryColor});

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = ThemeData.estimateBrightnessForColor(backgroundColor!);
    final Color textColor = brightness == Brightness.light ? Colors.black87 : Colors.white;

    return SizedBox(
      width: double.infinity,
      height: Rem.rem3,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Rem.rem0_5),
          ),
        ),
        child: child,
      ),
    );
  }
}

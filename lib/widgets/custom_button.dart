import 'package:flutter/material.dart';

import '../constants/color_constant.dart';
import '../constants/rem_constant.dart';

class CustomButton extends StatelessWidget {
  final Function()? onPressed;
  final Color? backgroundColor;
  final Widget? child;
  final bool isOutlined;

  const CustomButton({super.key, required this.onPressed, required this.child, this.backgroundColor=AppColors.primaryColor, this.isOutlined = false});

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = ThemeData.estimateBrightnessForColor(backgroundColor!);
    final Color filledTextColor = brightness == Brightness.light ? Colors.black87 : Colors.white;

    // Tentukan widget tombol berdasarkan flag isOutlined
    final Widget buttonWidget = isOutlined
        ? OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        // Warna foreground (teks/ikon) sama dengan warna background utama
        foregroundColor: backgroundColor,
        // Warna border adalah warna background utama
        side: BorderSide(color: backgroundColor!, width: Rem.rem0_125),
        // Background transparan, khas Outline Button
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Rem.rem0_5),
        ),
      ),
      child: child,
    )
        : ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        // Warna latar belakang (warna penuh)
        backgroundColor: backgroundColor,
        // Warna teks/ikon (dihitung agar kontras)
        foregroundColor: filledTextColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Rem.rem0_5),
        ),
      ),
      child: child,
    );

    return SizedBox(
      width: double.infinity,
      height: Rem.rem3,
      // Mengembalikan widget tombol yang sudah dipilih (Elevated/Outlined)
      child: buttonWidget,
    );
  }
}

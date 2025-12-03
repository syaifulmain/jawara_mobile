import 'package:flutter/material.dart';

class InfoBanner extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? iconColor;
  final Color? textColor;

  const InfoBanner({
    Key? key,
    required this.message,
    this.icon = Icons.info,
    this.backgroundColor,
    this.borderColor,
    this.iconColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ?? Colors.blue.shade50;
    final effectiveBorderColor = borderColor ?? Colors.blue.shade200;
    final effectiveIconColor = iconColor ?? Colors.blue.shade600;
    final effectiveTextColor = textColor ?? Colors.blue.shade800;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        border: Border.all(color: effectiveBorderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: effectiveIconColor, size: 16),
              const SizedBox(width: 8),
              Text(
                'Informasi:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: effectiveIconColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              color: effectiveTextColor,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

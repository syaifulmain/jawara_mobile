import 'package:flutter/material.dart';

class MenuListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  final Color backgroundColor;
  final bool disabled;
  final bool hidden;
  final bool gap;

  const MenuListTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
    this.backgroundColor = Colors.white,
    this.disabled = false,
    this.hidden = false,
    this.gap = true,
  });

  @override
  Widget build(BuildContext context) {
    if (hidden) return const SizedBox.shrink();

    final bool isDisabled = disabled;
    final Color titleColor = isDisabled ? Colors.grey : Colors.black;
    final Color subtitleColor = isDisabled ? Colors.grey[400]! : Colors.grey[600]!;
    final VoidCallback? tileOnTap = isDisabled ? null : onTap;
    final Color iconColor = isDisabled ? Colors.grey : color;

    return Column(
      children: [
        Card(
          color: backgroundColor,
          elevation: 2,
          child: ListTile(
            onTap: tileOnTap,
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            title: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: titleColor,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: TextStyle(
                color: subtitleColor,
                fontSize: 12,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: isDisabled ? Colors.grey : null,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ),
        if (gap) const SizedBox(height: 12),
      ],
    );
  }
}

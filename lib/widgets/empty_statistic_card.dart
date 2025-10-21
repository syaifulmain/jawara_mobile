import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_mobile/constants/rem.dart';

class EmptyStatisticCard extends StatelessWidget {
  final String title;
  final Color color;
  final Color backgroundColor;
  final IconData icon;
  /// Children will be rendered in column right after the title.
  final List<Widget> children;

  const EmptyStatisticCard({
    Key? key,
    required this.title,
    required this.color,
    required this.backgroundColor,
    required this.icon,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(Rem.rem1),
        child: Row(
          children: [
            Icon(icon, color: color, size: Rem.rem1_75),
            const SizedBox(width: Rem.rem1),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.figtree(
                    fontSize: Rem.rem1,
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                ...this.children.map((child) {
                  return child;
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

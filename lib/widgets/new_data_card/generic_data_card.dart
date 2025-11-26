import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_mobile/constants/colors.dart';
import 'package:jawara_mobile/widgets/new_data_card/card_action.dart';
import 'package:jawara_mobile/widgets/new_data_card/generic_badge.dart';
import 'package:jawara_mobile/widgets/new_data_card/generic_data_row.dart';

class GenericDataCard extends StatelessWidget {
  final String title;
  final List<GenericDataRow> rows;
  final List<GenericBadge> badges;
  final VoidCallback? onDetailTap;
  final List<CardAction>? actions;

  const GenericDataCard({
    super.key,
    required this.title,
    required this.rows,
    this.badges = const [],
    this.onDetailTap,
    this.actions,
  });

  Widget _buildBadge(GenericBadge badge) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badge.color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        badge.text,
        style: GoogleFonts.figtree(
          color: badge.color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildRow(GenericDataRow row) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(row.icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '${row.label}: ',
            style: GoogleFonts.figtree(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              row.value,
              style: GoogleFonts.figtree(fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _openMenu(BuildContext context) {
    if (actions == null || actions!.isEmpty) return;

    final RenderBox button = context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero),
        button.localToGlobal(button.size.bottomRight(Offset.zero)),
      ),
      Offset.zero & MediaQuery.of(context).size,
    );

    showMenu<String>(
      context: context,
      position: position,
      items: actions!
          .map(
            (a) => PopupMenuItem<String>(
              value: a.id,
              child: Text(a.label),
              onTap: a.onTap,
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.backgroundColor,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.figtree(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Detail Button
                if (onDetailTap != null)
                  IconButton(
                    icon: const Icon(Icons.remove_red_eye_outlined),
                    onPressed: onDetailTap,
                  ),

                // Actions menu
                if (actions != null && actions!.isNotEmpty)
                  Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () => _openMenu(context),
                    ),
                  ),
              ],
            ),

            const Divider(),

            // DATA ROWS
            ...rows.map(_buildRow),

            // BADGES
            if (badges.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  for (var b in badges) ...[
                    _buildBadge(b),
                    const SizedBox(width: 6),
                  ],
                ],
              ),
          ],
        ),
      ),
    );
  }
}

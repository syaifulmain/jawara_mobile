// dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_mobile/constants/colors.dart';
import 'package:jawara_mobile/constants/rem.dart';
import 'package:jawara_mobile/data/broadcast_data.dart';
import 'package:jawara_mobile/widgets/new_data_card/card_action.dart';
import 'package:jawara_mobile/widgets/new_data_card/generic_badge.dart';
import 'package:jawara_mobile/widgets/new_data_card/generic_data_card.dart';
import 'package:jawara_mobile/widgets/new_data_card/generic_data_row.dart';

class DaftarBroadcastScreen extends StatelessWidget {
  const DaftarBroadcastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: Rem.rem1),
        itemCount: dummyBroadcasts.length,
        itemBuilder: (context, index) {
          final b = dummyBroadcasts[index];

          final badges = <GenericBadge>[];
          if (b.fotoPath.isNotEmpty) {
            badges.add(GenericBadge(text: 'Image', color: AppColors.primaryColor));
          }
          if (b.dokumenPath.isNotEmpty) {
            badges.add(GenericBadge(text: 'Document', color: Colors.grey));
          }

          final rows = <GenericDataRow>[
            GenericDataRow(
              icon: Icons.description,
              label: 'Isi',
              value: b.isi,
            ),
            GenericDataRow(
              icon: Icons.calendar_today,
              label: 'Tanggal',
              value: b.tanggal,
            ),
            GenericDataRow(
              icon: Icons.person,
              label: 'User',
              value: b.userId,
            ),
          ];

          return GenericDataCard(
            title: b.judul,
            rows: rows,
            badges: badges,
            onDetailTap: () => context.pushNamed('broadcast-detail', extra: b),
            actions: [
              CardAction(id: 'edit', label: 'Edit', onTap: () {}),
              CardAction(id: 'hapus', label: 'Hapus', onTap: () {}),
            ],
          );
        },
      ),
    );
  }
}
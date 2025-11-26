import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawara_mobile/constants/colors.dart';
import 'package:jawara_mobile/constants/rem.dart';
import 'package:jawara_mobile/data/channel_transfer_data.dart';
import 'package:jawara_mobile/data/pengeluaran_data.dart';
import 'package:jawara_mobile/widgets/new_data_card/card_action.dart';
import 'package:jawara_mobile/widgets/new_data_card/generic_badge.dart';
import 'package:jawara_mobile/widgets/new_data_card/generic_data_card.dart';
import 'package:jawara_mobile/widgets/new_data_card/generic_data_row.dart';

class DaftarChannelTransferScreen extends StatelessWidget {
  DaftarChannelTransferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: Rem.rem1),
        itemCount: ChannelTransferDummy.data.length,
        itemBuilder: (context, index) {
          final data = ChannelTransferDummy.data[index];

          var dataCard = GenericDataCard(
            title: data.namaChannel,
            onDetailTap: () =>
                context.pushNamed('channel-transfer-detail', extra: data),
            rows: <GenericDataRow>[
              GenericDataRow(
                icon: Icons.category,
                label: 'Tipe Channel',
                value: data.tipe.label,
              ),
              GenericDataRow(
                icon: Icons.money_off_rounded,
                label: 'Rekening',
                value: data.nomorRekening,
              ),
              GenericDataRow(
                icon: Icons.person,
                label: 'Nama Pemilik',
                value: data.namaPemilik,
              ),
            ],
            actions: [
              CardAction(id: 'edit', label: 'Edit', onTap: () {}),
              CardAction(id: 'hapus', label: 'Hapus', onTap: () {}),
            ],
          );
          return dataCard;
        },
      ),
    );
  }
}

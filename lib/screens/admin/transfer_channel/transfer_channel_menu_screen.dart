import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/sub_menu.dart';

class TransferChannelMenuScreen extends StatelessWidget {
  const TransferChannelMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SubMenuScreen(
      title: 'Saluran Transfer',
      menuItems: [
        SubMenuItem(
          icon: Icons.list_alt,
          title: 'Daftar Saluran Transfer',
          subtitle: 'Lihat semua saluran transfer',
          color: Colors.teal,
          onTap: () => context.pushNamed('transfer_channels_list'),
        ),
        SubMenuItem(
          icon: Icons.add_circle,
          title: 'Tambah Saluran Transfer',
          subtitle: 'Tambah saluran transfer baru',
          color: Colors.teal,
          onTap: () => context.pushNamed('add_transfer_channel'),
        ),
      ],
    );
  }
}

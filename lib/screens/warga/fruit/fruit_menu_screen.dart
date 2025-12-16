import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/sub_menu.dart';

class FruitMenuScreen extends StatelessWidget {
  const FruitMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SubMenuScreen(
      title: 'Klasifikasi Buah',
      menuItems: [
        SubMenuItem(
          icon: Icons.camera_alt,
          title: 'Klasifikasi Buah',
          subtitle: 'Identifikasi jenis buah dengan foto',
          color: Colors.green,
          onTap: () => context.pushNamed('fruit_classification'),
        ),
        SubMenuItem(
          icon: Icons.photo_library,
          title: 'Daftar Gambar',
          subtitle: 'Lihat gambar buah yang tersimpan',
          color: Colors.green,
          onTap: () => context.pushNamed('fruit_image_list'),
        ),
      ],
    );
  }
}

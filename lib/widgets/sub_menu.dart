import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/color_constant.dart';
import '../constants/rem_constant.dart';
import '../widgets/menu_list_tile.dart';

class SubMenuScreen extends StatelessWidget {
  final String title;
  final List<SubMenuItem> menuItems;
  final Color? backgroundColor;

  const SubMenuScreen({
    Key? key,
    required this.title,
    required this.menuItems,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          title,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Rem.rem1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: menuItems.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: Rem.rem0_75),
              child: MenuListTile(
                icon: item.icon,
                title: item.title,
                subtitle: item.subtitle,
                color: item.color,
                onTap: item.onTap,
                  gap: false
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class SubMenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const SubMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });
}

import 'package:flutter/material.dart';
import 'package:jawara_mobile/constants/colors.dart';

class WhiteCardPage extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const WhiteCardPage({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColors.backgroundColor,

      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Card(
            color: AppColors.secondaryColor,

            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  for (var child in children) ...[child],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

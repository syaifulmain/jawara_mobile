import 'package:flutter/material.dart';
import 'package:jawara_mobile/constants/colors.dart';

class WhiteCardPage extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const WhiteCardPage({super.key, this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
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
                  if (title != null) ...[
                    Text(
                      title!,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Divider(thickness: 2),
                    const SizedBox(height: 16),
                  ],
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

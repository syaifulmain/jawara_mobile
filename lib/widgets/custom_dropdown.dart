import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_mobile/constants/colors.dart';
import 'package:jawara_mobile/constants/rem.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final List<DropdownMenuEntry<T>> items;
  final T? initialSelection;
  final Function(T?)? onSelected;

  const CustomDropdown({
    super.key,
    this.labelText,
    this.hintText,
    required this.items,
    this.initialSelection,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (labelText != null && labelText!.isNotEmpty) ...[
              Text(
                labelText!,
                style: GoogleFonts.figtree(
                  fontSize: Rem.rem1,
                  fontWeight: FontWeight.normal,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: Rem.rem0_5),
            ],

            DropdownMenu<T>(
              width: width,
              initialSelection: initialSelection,
              onSelected: onSelected,
              hintText: hintText,
              textStyle: GoogleFonts.poppins(),

              menuStyle: MenuStyle(
                maximumSize: WidgetStateProperty.all(
                  Size(width, double.infinity),
                ),
                backgroundColor: WidgetStateProperty.all(Colors.white),
                elevation: WidgetStateProperty.all(4),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Rem.rem0_5),
                  ),
                ),
              ),

              inputDecorationTheme: InputDecorationTheme(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: Rem.rem0_75,
                  vertical: Rem.rem0_25,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Rem.rem0_5),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Rem.rem0_5),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Rem.rem0_5),
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
              ),

              dropdownMenuEntries: items,
            ),
          ],
        );
      },
    );
  }
}

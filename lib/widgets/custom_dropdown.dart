import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/color_constant.dart';
import '../constants/rem_constant.dart';

// Converted to a StatefulWidget to properly manage state and handle resets.
class CustomDropdown<T> extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final List<DropdownMenuEntry<T>> items;
  final T? initialSelection;
  final Function(T?)? onSelected;
  final bool enabled;

  const CustomDropdown({
    super.key,
    this.labelText,
    this.hintText,
    required this.items,
    this.initialSelection,
    this.onSelected,
    this.enabled = true,
  });

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _updateControllerWithInitialValue();
  }

  // didUpdateWidget is crucial for reacting to parent state changes (like a reset).
  @override
  void didUpdateWidget(CustomDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the parent widget provides a new initialSelection, update the controller.
    if (widget.initialSelection != oldWidget.initialSelection) {
      _updateControllerWithInitialValue();
    }
  }

  void _updateControllerWithInitialValue() {
    if (widget.initialSelection == null) {
      // If the initial selection is null (e.g., after a reset), clear the controller.
      _controller.clear();
      return;
    }

    // Find the corresponding label for the initial value and set the controller's text.
    try {
      final entry = widget.items.firstWhere(
        (item) => item.value == widget.initialSelection,
      );
      _controller.text = entry.label;
    } catch (e) {
      // If no matching entry is found, clear the controller.
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.labelText != null && widget.labelText!.isNotEmpty) ...[
              Text(
                widget.labelText!,
                style: GoogleFonts.poppins(
                  fontSize: Rem.rem0_875,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: Rem.rem0_5),
            ],
            DropdownMenu<T>(
              controller: _controller, // Use the controller to manage the displayed text.
              width: width,
              onSelected: widget.onSelected,
              hintText: widget.hintText,
              textStyle: GoogleFonts.poppins(),
              enabled: widget.enabled,
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
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: Rem.rem0_75,
                  vertical: Rem.rem0_75,
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
                  borderSide: const BorderSide(color: AppColors.primaryColor),
                ),
              ),
              dropdownMenuEntries: widget.items,
            ),
          ],
        );
      },
    );
  }
}

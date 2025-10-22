import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_mobile/constants/colors.dart';
import 'package:jawara_mobile/constants/rem.dart';

class CustomSelectCalendar extends StatefulWidget {
  final String labelText;
  final String hintText;
  final Function(DateTime) onDateSelected;
  final DateTime? initialDate;

  const CustomSelectCalendar({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.onDateSelected,
    this.initialDate, // Added initialDate property
  });

  @override
  State<CustomSelectCalendar> createState() => _CustomSelectCalendarState();
}

class _CustomSelectCalendarState extends State<CustomSelectCalendar> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    // Set the initial date from the widget property when the state is first created.
    _selectedDate = widget.initialDate;
  }

  @override
  void didUpdateWidget(CustomSelectCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the initialDate provided by the parent widget changes, update the state.
    if (widget.initialDate != oldWidget.initialDate) {
      setState(() {
        _selectedDate = widget.initialDate;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900), // Allow selection of past dates for birth dates
      lastDate: DateTime.now(), // Prevent selection of future dates
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor, // Header background color
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      widget.onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText,
          style: GoogleFonts.poppins(
            fontSize: Rem.rem0_875,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: Rem.rem0_5),
        InkWell(
          onTap: () => _selectDate(context),
          borderRadius: BorderRadius.circular(Rem.rem0_5),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Rem.rem0_75,
              vertical: Rem.rem0_75,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Rem.rem0_5),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.grey),
                const SizedBox(width: Rem.rem0_75),
                Text(
                  _selectedDate == null
                      ? widget.hintText
                      : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                  style: GoogleFonts.poppins(
                    color: _selectedDate == null ? Colors.grey : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

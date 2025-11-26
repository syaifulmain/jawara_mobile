import 'dart:ui';

class CardAction {
  final String id;
  final String label;
  final VoidCallback? onTap;

  CardAction({
    required this.id,
    required this.label,
    this.onTap,
  });
}

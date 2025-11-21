import 'package:flutter/material.dart';

class WhiteCardPage extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget> children;

  /// Opsional
  final EdgeInsetsGeometry padding;
  final bool scrollable;
  final double maxWidth;

  const WhiteCardPage({
    super.key,
    this.title,
    this.titleWidget,
    required this.children,
    this.padding = const EdgeInsets.all(16),
    this.scrollable = true,
    this.maxWidth = 600, // Biar nyaman untuk tablet/web
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (titleWidget != null || title != null) ...[
          titleWidget ??
              Text(
                title!,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
          const SizedBox(height: 16),
          const Divider(thickness: 1),
          const SizedBox(height: 16),
        ],
        ...children,
      ],
    );

    final card = Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(padding: padding, child: content),
    );

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: scrollable
            ? SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: card,
              )
            : card,
      ),
    );
  }
}

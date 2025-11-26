import 'package:flutter/material.dart';

class AppRouteItem {
  final String path;
  final String name;
  final String label;
  final IconData icon;
  final Widget Function(BuildContext, dynamic) builder;
  final bool adminOnly;

  const AppRouteItem({
    required this.path,
    required this.name,
    required this.label,
    required this.icon,
    required this.builder,
    this.adminOnly = false,
  });
}
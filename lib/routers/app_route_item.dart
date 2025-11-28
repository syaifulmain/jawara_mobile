import 'package:flutter/material.dart';

class AppRouteItem {
  final String path;
  final String name;
  final String label;
  final Widget Function(BuildContext, dynamic) builder;

  const AppRouteItem({
    required this.path,
    required this.name,
    required this.label,
    required this.builder
  });
}
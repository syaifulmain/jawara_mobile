import 'package:flutter/material.dart';
import 'package:jawara_mobile/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Jawara Pintar Mobile',
      routerConfig: router,
    );
  }
}

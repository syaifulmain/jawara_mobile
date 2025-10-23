import 'package:flutter/material.dart';

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Placeholder'),
      ),
      body: const Center(
        child: Text(
          'This is a placeholder screen.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

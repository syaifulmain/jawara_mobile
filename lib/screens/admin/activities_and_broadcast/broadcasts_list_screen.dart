import 'package:flutter/material.dart';

class BroadcastsListScreen extends StatelessWidget {
  const BroadcastsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Broadcast'),
      ),
      body: const Center(
        child: Text('Daftar Broadcast Screen'),
      ),
    );
  }
}

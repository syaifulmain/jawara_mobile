import 'package:flutter/material.dart';

class AddBroadcastScreen extends StatelessWidget {
  const AddBroadcastScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Broadcast'),
      ),
      body: const Center(
        child: Text('Tambah Broadcast Screen'),
      ),
    );
  }
}

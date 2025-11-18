// lib/screens/daftar_pengeluaran_screen.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jawara_mobile/models/pengeluaran_model.dart';
import 'package:jawara_mobile/riverpod_providers/pengeluaran/notifiers/pengeluaran_notifiers.dart';

import 'tambah_pengeluaran_screen.dart';

class DaftarPengeluaranScreen extends ConsumerWidget {
  static const routeName = '/daftar-pengeluaran';
  const DaftarPengeluaranScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(pengeluaranProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pengeluaran'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(TambahPengeluaranScreen.routeName);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: data.isEmpty
            ? const Center(child: Text('Belum ada pengeluaran'))
            : ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, i) {
            final PengeluaranModel pengeluaran = data[i];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: pengeluaran.buktiPath != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.file(
                    File(pengeluaran.buktiPath!),
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  ),
                )
                    : const Icon(Icons.receipt_long),
                title: Text(pengeluaran.nama),
                subtitle: Text('${pengeluaran.kategori} • ${pengeluaran.tanggal.toIso8601String().split('T')[0]}'),
                trailing: Text('Rp ${pengeluaran.nominal}'),
                onTap: () {
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

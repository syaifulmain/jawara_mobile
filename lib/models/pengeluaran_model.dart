// lib/models/pengeluaran.dart
import 'package:flutter/foundation.dart';

@immutable
class PengeluaranModel {
  final String id;
  final String nama;
  final String kategori;
  final DateTime tanggal;
  final int nominal;
  final String? buktiPath; // path ke file gambar (XFile.path)

  const PengeluaranModel({
    required this.id,
    required this.nama,
    required this.kategori,
    required this.tanggal,
    required this.nominal,
    this.buktiPath,
  });
}

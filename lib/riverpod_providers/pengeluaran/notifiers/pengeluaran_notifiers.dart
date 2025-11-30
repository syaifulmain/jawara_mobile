// lib/providers/pengeluaran_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:jawara_mobile/models/pengeluaran_model.dart';
import 'package:uuid/uuid.dart';

final _uuid = Uuid();

class PengeluaranNotifier extends StateNotifier<List<PengeluaranModel>> {
  PengeluaranNotifier() : super([]);

  void tambah({
    required String nama,
    required String kategori,
    required DateTime tanggal,
    required int nominal,
    String? buktiPath,
  }) {
    final p = PengeluaranModel(
      id: _uuid.v4(),
      nama: nama,
      kategori: kategori,
      tanggal: tanggal,
      nominal: nominal,
      buktiPath: buktiPath,
    );

    state = [...state, p];
  }

  void reset() {
    state = [];
  }

  void hapusById(String id) {
    state = state.where((e) => e.id != id).toList();
  }
}

final pengeluaranProvider =
StateNotifierProvider<PengeluaranNotifier, List<PengeluaranModel>>(
      (ref) => PengeluaranNotifier(),
);

import 'dart:io';
import '../../enums/activity_category.dart';

class CreateActivityRequest {
  final String name;
  final ActivityCategory category;
  final DateTime date;
  final String location;
  final String personInCharge;
  final String? description;
  final bool isPengeluaran;

  // Fields untuk pengeluaran (required jika isPengeluaran = true)
  final String? namaPengeluaran;
  final String? kategori;
  final double? nominal;
  final String? verifikator;
  final File? buktiPengeluaran;

  CreateActivityRequest({
    required this.name,
    required this.category,
    required this.date,
    required this.location,
    required this.personInCharge,
    this.description,
    required this.isPengeluaran,
    this.namaPengeluaran,
    this.kategori,
    this.nominal,
    this.verifikator,
    this.buktiPengeluaran,
  });

  Map<String, String> toFields() {
    final fields = {
      'name': name,
      'category': category.value,
      'date': date.toIso8601String(),
      'location': location,
      'person_in_charge': personInCharge,
      'is_pengeluaran': isPengeluaran ? '1' : '0',
    };

    if (description != null && description!.isNotEmpty) {
      fields['description'] = description!;
    }

    if (isPengeluaran) {
      if (namaPengeluaran != null) {
        fields['nama_pengeluaran'] = namaPengeluaran!;
      }
      if (kategori != null) {
        fields['kategori'] = kategori!;
      }
      if (nominal != null) {
        fields['nominal'] = nominal!.toString();
      }
      if (verifikator != null) {
        fields['verifikator'] = verifikator!;
      }
    }

    return fields;
  }

  Map<String, dynamic> toJson() {
    final json = {
      'name': name,
      'category': category.value,
      'date': date.toIso8601String(),
      'location': location,
      'person_in_charge': personInCharge,
      'is_pengeluaran': isPengeluaran,
    };

    if (description != null) {
      json['description'] = description!;
    }

    if (isPengeluaran) {
      if (namaPengeluaran != null) {
        json['nama_pengeluaran'] = namaPengeluaran!;
      }
      if (kategori != null) {
        json['kategori'] = kategori!;
      }
      if (nominal != null) {
        json['nominal'] = nominal!;
      }
      if (verifikator != null) {
        json['verifikator'] = verifikator!;
      }
    }

    return json;
  }
}

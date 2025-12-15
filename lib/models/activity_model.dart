import '../enums/activity_category.dart';

class Activity {
  final int? id;
  final String name;
  final ActivityCategory category;
  final DateTime date;
  final String location;
  final String personInCharge;
  final String? description;
  final bool isPengeluaran;

  // Pengeluaran fields
  final String? namaPengeluaran;
  final String? kategori;
  final double? nominal;
  final String? verifikator;
  final String? buktiPengeluaran;

  Activity({
    this.id,
    required this.name,
    required this.category,
    required this.date,
    required this.location,
    required this.personInCharge,
    this.description,
    this.isPengeluaran = false,
    this.namaPengeluaran,
    this.kategori,
    this.nominal,
    this.verifikator,
    this.buktiPengeluaran,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] as int?,
      name: json['name'] as String,
      category: ActivityCategory.fromString(json['category'] as String),
      date: DateTime.parse(json['date'] as String),
      location: json['location'] as String,
      personInCharge: json['person_in_charge'] as String,
      description: json['description'] as String?,
      isPengeluaran:
          json['is_pengeluaran'] == 1 || json['is_pengeluaran'] == true,
      namaPengeluaran: json['nama_pengeluaran'] as String?,
      kategori: json['kategori'] as String?,
      nominal: json['nominal'] != null
          ? double.tryParse(json['nominal'].toString())
          : null,
      verifikator: json['verifikator'] as String?,
      buktiPengeluaran: json['bukti_pengeluaran'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'name': name,
      'category': category.value,
      'date': date.toIso8601String(),
      'location': location,
      'person_in_charge': personInCharge,
      'is_pengeluaran': isPengeluaran,
    };

    if (id != null) {
      json['id'] = id!;
    }

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

  Activity copyWith({
    int? id,
    String? name,
    ActivityCategory? category,
    DateTime? date,
    String? location,
    String? personInCharge,
    String? description,
    bool? isPengeluaran,
    String? namaPengeluaran,
    String? kategori,
    double? nominal,
    String? verifikator,
    String? buktiPengeluaran,
  }) {
    return Activity(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      date: date ?? this.date,
      location: location ?? this.location,
      personInCharge: personInCharge ?? this.personInCharge,
      description: description ?? this.description,
      isPengeluaran: isPengeluaran ?? this.isPengeluaran,
      namaPengeluaran: namaPengeluaran ?? this.namaPengeluaran,
      kategori: kategori ?? this.kategori,
      nominal: nominal ?? this.nominal,
      verifikator: verifikator ?? this.verifikator,
      buktiPengeluaran: buktiPengeluaran ?? this.buktiPengeluaran,
    );
  }
}

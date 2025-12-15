import 'package:jawara_mobile_v2/enums/relocation_type.dart';

class FamilyRelocationListModel {
  final int id;
  final RelocationType relocationType;
  final DateTime relocationDate;
  final String familyName;

  FamilyRelocationListModel({
    required this.id,
    required this.relocationType,
    required this.relocationDate,
    required this.familyName,
  });

  factory FamilyRelocationListModel.fromJson(Map<String, dynamic> json) {
    return FamilyRelocationListModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      relocationType: RelocationType.fromString(json['relocation_type'] ?? ''),
      relocationDate: json['date'] is int
          ? DateTime.fromMillisecondsSinceEpoch(json['date'])
          : DateTime.tryParse(json['date'] ?? '') ??
                DateTime.fromMillisecondsSinceEpoch(0),

      familyName: json['family_name'] ?? '',
    );
  }
}

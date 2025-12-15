import 'package:jawara_mobile_v2/enums/relocation_type.dart';

class FamilyRelocationDetailModel {
  final int id;
  final RelocationType relocationType;
  final DateTime relocationDate;
  final String reason;
  final String familyName;
  final String pastAddress;
  final String newAddress;
  final String createdBy;

  FamilyRelocationDetailModel({
    required this.id,
    required this.relocationType,
    required this.relocationDate,
    required this.reason,
    required this.familyName,
    required this.pastAddress,
    required this.newAddress,
    required this.createdBy,
  });

  factory FamilyRelocationDetailModel.fromJson(Map<String, dynamic> json) {
    return FamilyRelocationDetailModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      relocationType: RelocationType.fromString(json['relocation_type'] ?? ''),
      relocationDate: json['date'] is int
          ? DateTime.fromMillisecondsSinceEpoch(json['date'])
          : DateTime.tryParse(json['date'] ?? '') ??
                DateTime.fromMillisecondsSinceEpoch(0),
      reason: json['reason'] ?? '',
      familyName: json['family_name'] ?? '',
      pastAddress: json['past_address'] ?? '',
      newAddress: json['new_address'] ?? '',
      createdBy: json['created_by'] ?? '',
    );
  }
}

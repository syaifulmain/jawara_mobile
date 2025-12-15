import 'package:jawara_mobile_v2/enums/relocation_type.dart';

class FamilyRelocationRequestModel {
  RelocationType relocationType;
  DateTime relocationDate;
  String reason;
  int familyId;
  int pastAddressId;
  int newAddressId;

  int createdBy;

  FamilyRelocationRequestModel({
    required this.relocationType,
    required this.relocationDate,
    required this.reason,
    required this.familyId,
    required this.pastAddressId,
    required this.newAddressId,
    required this.createdBy,
  });

  Map<String, dynamic> toJson() {
    return {
      'relocation_type': relocationType.value,
      'relocation_date': relocationDate.toIso8601String(),
      'reason': reason,
      'family_id': familyId,
      'past_address_id': pastAddressId,
      'new_address_id': newAddressId,
      'created_by': createdBy,
    };
  }
}
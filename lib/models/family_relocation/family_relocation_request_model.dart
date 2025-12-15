import 'package:jawara_mobile_v2/enums/relocation_type.dart';

class FamilyRelocationRequestModel {
  final RelocationType relocationType;
  final DateTime relocationDate;
  final String reason;
  final int familyId;
  final int? newAddressId;


  FamilyRelocationRequestModel({
    required this.relocationType,
    required this.relocationDate,
    required this.reason,
    required this.familyId,
    this.newAddressId,
  });

  Map<String, dynamic> toJson() {
    return {
      'relocation_type': relocationType.value,
      'relocation_date': relocationDate.toIso8601String(),
      'reason': reason,
      'family_id': familyId,
      // 'past_address_id': pastAddressId,
      'new_address_id': newAddressId,
    };
  }
}
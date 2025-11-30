class ResidentRequestModel {
  final int familyId;
  final String fullName;
  final String nik;
  final String? phoneNumber;
  final String? birthPlace;
  final String? birthDate;
  final String gender;
  final String? religion;
  final String? bloodType;
  final String familyRole;
  final String? lastEducation;
  final String? occupation;
  final bool? isAlive;
  final bool? isActive;

  ResidentRequestModel({
    required this.familyId,
    required this.fullName,
    required this.nik,
    this.phoneNumber,
    this.birthPlace,
    this.birthDate,
    required this.gender,
    this.religion,
    this.bloodType,
    required this.familyRole,
    this.lastEducation,
    this.occupation,
    this.isAlive,
    this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      'family_id': familyId,
      'full_name': fullName,
      'nik': nik,
      'phone_number': phoneNumber,
      'birth_place': birthPlace,
      'birth_date': birthDate,
      'gender': gender,
      'religion': religion,
      'blood_type': bloodType,
      'family_role': familyRole,
      'last_education': lastEducation,
      'occupation': occupation,
      'is_alive': isAlive,
      'is_active': isActive,
    };
  }
}

import '../../enums/resident_enum.dart';

class ResidentDetailModel {
  final int id;
  final int? familyId;
  final String name;
  final String nik;
  final String? phoneNumber;
  final String? birthPlace;
  final DateTime? birthDate;
  final String gender;
  final String? religion;
  final String? bloodType;
  final String familyRole;
  final String? lastEducation;
  final String? occupation;
  final bool isFamilyHead;
  final bool isAlive;
  final bool isActive;

  ResidentDetailModel({
    required this.id,
    this.familyId,
    required this.name,
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
    required this.isFamilyHead,
    required this.isAlive,
    required this.isActive,
  });

  factory ResidentDetailModel.fromJson(Map<String, dynamic> json) {
    return ResidentDetailModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      familyId: json['family_id'] != null
          ? (json['family_id'] is int
                ? json['family_id']
                : int.tryParse(json['family_id'].toString()))
          : null,
      name: json['name'] ?? '',
      nik: json['nik'] ?? '',
      phoneNumber: json['phone_number'],
      birthPlace: json['birth_place'],
      birthDate: json['birth_date'] != null
          ? DateTime.tryParse(json['birth_date'])
          : null,
      gender: json['gender'] ?? '',
      religion: json['religion'],
      bloodType: json['blood_type'],
      familyRole: json['family_role'] ?? '',
      lastEducation: json['last_education'],
      occupation: json['occupation'],
      isFamilyHead:
          json['is_family_head'] == true || json['is_family_head'] == 1,
      isAlive: json['is_alive'] == true || json['is_alive'] == 1,
      isActive: json['is_active'] == true || json['is_active'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'family_id': familyId,
      'name': name,
      'nik': nik,
      'phone_number': phoneNumber,
      'birth_place': birthPlace,
      'birth_date': birthDate?.toIso8601String(),
      'gender': gender,
      'religion': religion,
      'blood_type': bloodType,
      'family_role': familyRole,
      'last_education': lastEducation,
      'occupation': occupation,
      'is_family_head': isFamilyHead,
      'is_alive': isAlive,
      'is_active': isActive,
    };
  }
}

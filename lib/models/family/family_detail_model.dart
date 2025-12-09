class FamilyDetailModel {
  final String familyName;
  final String? familyHead;
  final String? currentAddress;
  final String? ownershipStatus;
  final String familyStatus;
  final List<FamilyMemberModel> familyMembers;

  FamilyDetailModel({
    required this.familyName,
    this.familyHead,
    this.currentAddress,
    this.ownershipStatus,
    required this.familyStatus,
    required this.familyMembers,
  });

  factory FamilyDetailModel.fromJson(Map<String, dynamic> json) {
    return FamilyDetailModel(
      familyName: json['family_name'] ?? '',
      familyHead: json['family_head'],
      currentAddress: json['current_address'],
      ownershipStatus: json['ownership_status'],
      familyStatus: json['family_status'] ?? 'Tidak Aktif',
      familyMembers:
          (json['family_members'] as List<dynamic>?)
              ?.map((e) => FamilyMemberModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'family_name': familyName,
      'family_head': familyHead,
      'current_address': currentAddress,
      'ownership_status': ownershipStatus,
      'family_status': familyStatus,
      'family_members': familyMembers.map((e) => e.toJson()).toList(),
    };
  }
}

class FamilyMemberModel {
  final int id;
  final int? familyId;
  final String name;
  final String nik;
  final String role;
  final String gender;
  final String? birthDate;
  final String status;

  FamilyMemberModel({
    required this.id,
    this.familyId,
    required this.name,
    required this.nik,
    required this.role,
    required this.gender,
    this.birthDate,
    required this.status,
  });

  factory FamilyMemberModel.fromJson(Map<String, dynamic> json) {
    final parsedId = json['id'] != null
        ? int.tryParse(json['id'].toString())
        : null;

    if (parsedId == null) {
      throw Exception('FamilyMemberModel.id tidak valid: ${json}');
    }

    return FamilyMemberModel(
      id: parsedId,
      familyId: json['family_id'] != null
          ? (json['family_id'] is int
                ? json['family_id']
                : int.tryParse(json['family_id'].toString()))
          : null,
      name: json['name'] ?? '',
      nik: json['nik'] ?? '',
      role: json['role'] ?? '',
      gender: json['gender'] ?? '',
      birthDate: json['birth_date'],
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nik': nik,
      'role': role,
      'gender': gender,
      'birth_date': birthDate,
      'status': status,
    };
  }
}

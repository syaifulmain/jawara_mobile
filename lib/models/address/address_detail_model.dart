class AddressDetailModel {
  final String address;
  final String status;
  final List<AddressHistoryModel> history;

  AddressDetailModel({
    required this.address,
    required this.status,
    required this.history,
  });

  factory AddressDetailModel.fromJson(Map<String, dynamic> json) {
    return AddressDetailModel(
      address: json['address'] ?? '',
      status: json['status'] ?? '',
      history: (json['history'] as List<dynamic>?)
              ?.map((e) => AddressHistoryModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'status': status,
      'history': history.map((e) => e.toJson()).toList(),
    };
  }
}

class AddressHistoryModel {
  final String? family;
  final String? headResident;
  final String? movedInAt;
  final String movedOutAt;

  AddressHistoryModel({
    this.family,
    this.headResident,
    this.movedInAt,
    required this.movedOutAt,
  });

  factory AddressHistoryModel.fromJson(Map<String, dynamic> json) {
    return AddressHistoryModel(
      family: json['family'],
      headResident: json['head_resident'],
      movedInAt: json['moved_in_at'],
      movedOutAt: json['moved_out_at'] ?? 'Masih tinggal',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'family': family,
      'head_resident': headResident,
      'moved_in_at': movedInAt,
      'moved_out_at': movedOutAt,
    };
  }
}

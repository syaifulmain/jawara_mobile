class AddressListModel {
  final int id;
  final String alamat;
  final String status;

  AddressListModel({
    required this.id,
    required this.alamat,
    required this.status,
  });

  factory AddressListModel.fromJson(Map<String, dynamic> json) {
    return AddressListModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      alamat: json['alamat'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'alamat': alamat,
      'status': status,
    };
  }
}

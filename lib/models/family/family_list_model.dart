class FamilyListModel {
  final int id;
  final String namaKeluarga;
  final String kepalaKeluarga;
  final String alamatRumah;
  final String statusKepemilikan;
  final String status;

  FamilyListModel({
    required this.id,
    required this.namaKeluarga,
    required this.kepalaKeluarga,
    required this.alamatRumah,
    required this.statusKepemilikan,
    required this.status,
  });

  factory FamilyListModel.fromJson(Map<String, dynamic> json) {
    return FamilyListModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      namaKeluarga: json['nama_keluarga'] ?? '',
      kepalaKeluarga: json['kepala_keluarga'] ?? '-',
      alamatRumah: json['alamat_rumah'] ?? '-',
      statusKepemilikan: json['status_kepemilikan'] ?? '-',
      status: json['status'] ?? 'Tidak Aktif',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_keluarga': namaKeluarga,
      'kepala_keluarga': kepalaKeluarga,
      'alamat_rumah': alamatRumah,
      'status_kepemilikan': statusKepemilikan,
      'status': status,
    };
  }
}

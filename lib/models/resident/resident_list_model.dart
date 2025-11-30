class ResidentListModel {
  final int id;
  final String nama;
  final String nik;
  final String? keluarga;
  final String jenisKelamin;
  final String statusDomisili;
  final String statusHidup;
  final bool isActive;

  ResidentListModel({
    required this.id,
    required this.nama,
    required this.nik,
    this.keluarga,
    required this.jenisKelamin,
    required this.statusDomisili,
    required this.statusHidup,
    required this.isActive,
  });

  factory ResidentListModel.fromJson(Map<String, dynamic> json) {
    return ResidentListModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      nama: json['nama'] ?? '',
      nik: json['nik'] ?? '',
      keluarga: json['keluarga'],
      jenisKelamin: json['jenis_kelamin'] ?? '',
      statusDomisili: json['status_domisili'] ?? '-',
      statusHidup: json['status_hidup'] ?? '',
      isActive: json['is_active'] == true || json['is_active'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'nik': nik,
      'keluarga': keluarga,
      'jenis_kelamin': jenisKelamin,
      'status_domisili': statusDomisili,
      'status_hidup': statusHidup,
      'is_active': isActive,
    };
  }
}

class BroadcastModel{
  final String id;
  final String judul;
  final String isi;
  final String tanggal;
  final String fotoPath;
  final String dokumenPath;

  final String userId;

  BroadcastModel({
    required this.id,
    required this.judul,
    required this.isi,
    required this.tanggal,
    required this.fotoPath,
    required this.dokumenPath,
    required this.userId,
  });

  factory BroadcastModel.fromJson(Map<String, dynamic> json) {
    return BroadcastModel(
      id: json['id'] as String,
      judul: json['judul'] as String,
      isi: json['isi'] as String,
      tanggal: json['tanggal'] as String,
      fotoPath: json['fotoPath'] as String,
      dokumenPath: json['dokumenPath'] as String,
      userId: json['userId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'isi': isi,
      'tanggal': tanggal,
      'fotoPath': fotoPath,
      'dokumenPath': dokumenPath,
      'userId': userId,
    };
  }
}
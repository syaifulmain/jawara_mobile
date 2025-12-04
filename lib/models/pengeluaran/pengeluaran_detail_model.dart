class PengeluaranDetailModel {
  final int id;
  final String namaPengeluaran;
  final String tanggal;
  final String kategori;
  final int nominal;
  final String verifikator;
  final String? buktiPengeluaran;
  final String createdAt;
  final String updatedAt;

  PengeluaranDetailModel({
    required this.id,
    required this.namaPengeluaran,
    required this.tanggal,
    required this.kategori,
    required this.nominal,
    required this.verifikator,
    this.buktiPengeluaran,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PengeluaranDetailModel.fromJson(Map<String, dynamic> json) {
    return PengeluaranDetailModel(
      id: json['id'],
      namaPengeluaran: json['nama_pengeluaran'],
      tanggal: json['tanggal'],
      kategori: json['kategori'],
      nominal: json['nominal'],
      verifikator: json['verifikator'],
      buktiPengeluaran: json['bukti_pengeluaran'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class PengeluaranListModel {
  final int id;
  final String namaPengeluaran;
  final String tanggal;
  final String kategori;
  final int nominal;
  final String verifikator;
  final String? buktiPengeluaran;

  PengeluaranListModel({
    required this.id,
    required this.namaPengeluaran,
    required this.tanggal,
    required this.kategori,
    required this.nominal,
    required this.verifikator,
    this.buktiPengeluaran,
  });

  factory PengeluaranListModel.fromJson(Map<String, dynamic> json) {
    return PengeluaranListModel(
      id: json['id'],
      namaPengeluaran: json['nama_pengeluaran'],
      tanggal: json['tanggal'],
      kategori: json['kategori'],
      nominal: json['nominal'],
      verifikator: json['verifikator'],
      buktiPengeluaran: json['bukti_pengeluaran'],
    );
  }
}

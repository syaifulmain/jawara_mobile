class PengeluaranRequestModel {
  final String namaPengeluaran;
  final String tanggal; // format: yyyy-mm-dd
  final String kategori;
  final int nominal;
  final String verifikator;
  final String? buktiPengeluaran; // optional

  PengeluaranRequestModel({
    required this.namaPengeluaran,
    required this.tanggal,
    required this.kategori,
    required this.nominal,
    required this.verifikator,
    this.buktiPengeluaran,
  });

  Map<String, dynamic> toJson() {
    return {
      'nama_pengeluaran': namaPengeluaran,
      'tanggal': tanggal,
      'kategori': kategori,
      'nominal': nominal,
      'verifikator': verifikator,
      'bukti_pengeluaran': buktiPengeluaran,
    };
  }
}

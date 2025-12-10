class FinancialReport {
  final String judul;
  final ReportPeriod periode;
  final ReportSummary ringkasan;
  final List<Transaction> transaksi;
  final String dicetakPada;

  FinancialReport({
    required this.judul,
    required this.periode,
    required this.ringkasan,
    required this.transaksi,
    required this.dicetakPada,
  });

  factory FinancialReport.fromJson(Map<String, dynamic> json) {
    return FinancialReport(
      judul: json['judul'] as String,
      periode: ReportPeriod.fromJson(json['periode']),
      ringkasan: ReportSummary.fromJson(json['ringkasan']),
      transaksi: (json['transaksi'] as List)
          .map((t) => Transaction.fromJson(t))
          .toList(),
      dicetakPada: json['dicetak_pada'] as String,
    );
  }
}

class ReportPeriod {
  final String start;
  final String end;
  final String text;

  ReportPeriod({
    required this.start,
    required this.end,
    required this.text,
  });

  factory ReportPeriod.fromJson(Map<String, dynamic> json) {
    return ReportPeriod(
      start: json['start'] as String,
      end: json['end'] as String,
      text: json['text'] as String,
    );
  }
}

class ReportSummary {
  final int totalPemasukan;
  final int totalPengeluaran;
  final int saldoAkhir;
  final String formattedTotalPemasukan;
  final String formattedTotalPengeluaran;
  final String formattedSaldoAkhir;

  ReportSummary({
    required this.totalPemasukan,
    required this.totalPengeluaran,
    required this.saldoAkhir,
    required this.formattedTotalPemasukan,
    required this.formattedTotalPengeluaran,
    required this.formattedSaldoAkhir,
  });

  factory ReportSummary.fromJson(Map<String, dynamic> json) {
    return ReportSummary(
      totalPemasukan: json['total_pemasukan'] as int,
      totalPengeluaran: json['total_pengeluaran'] as int,
      saldoAkhir: json['saldo_akhir'] as int,
      formattedTotalPemasukan: json['formatted_total_pemasukan'] as String,
      formattedTotalPengeluaran: json['formatted_total_pengeluaran'] as String,
      formattedSaldoAkhir: json['formatted_saldo_akhir'] as String,
    );
  }
}

class Transaction {
  final String tanggal;
  final String jenis;
  final String kategori;
  final String deskripsi;
  final int jumlah;
  final String formattedJumlah;

  Transaction({
    required this.tanggal,
    required this.jenis,
    required this.kategori,
    required this.deskripsi,
    required this.jumlah,
    required this.formattedJumlah,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      tanggal: json['tanggal'] as String,
      jenis: json['jenis'] as String,
      kategori: json['kategori'] as String,
      deskripsi: json['deskripsi'] as String,
      jumlah: json['jumlah'] as int,
      formattedJumlah: json['formatted_jumlah'] as String,
    );
  }
}

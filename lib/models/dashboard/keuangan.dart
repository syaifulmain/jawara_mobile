class DashboardKeuanganResponse {
  final bool success;
  final String message;
  final DashboardKeuanganData data;

  DashboardKeuanganResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory DashboardKeuanganResponse.fromJson(Map<String, dynamic> json) {
    return DashboardKeuanganResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: DashboardKeuanganData.fromJson(json['data'] ?? {}),
    );
  }
}

class DashboardKeuanganData {
  final int year;
  final KeuanganSummary summary;
  final List<MonthlyChart> monthlyChart;
  final List<BillsStatusChart> billsStatusChart;
  final List<TopPengeluaranChart> topPengeluaranChart;

  DashboardKeuanganData({
    required this.year,
    required this.summary,
    required this.monthlyChart,
    required this.billsStatusChart,
    required this.topPengeluaranChart,
  });

  factory DashboardKeuanganData.fromJson(Map<String, dynamic> json) {
    return DashboardKeuanganData(
      year: json['year'] ?? 0,
      summary: KeuanganSummary.fromJson(json['summary'] ?? {}),
      monthlyChart: (json['monthly_chart'] as List?)
          ?.map((e) => MonthlyChart.fromJson(e))
          .toList() ??
          [],
      billsStatusChart: (json['bills_status_chart'] as List?)
          ?.map((e) => BillsStatusChart.fromJson(e))
          .toList() ??
          [],
      topPengeluaranChart: (json['top_pengeluaran_chart'] as List?)
          ?.map((e) => TopPengeluaranChart.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class KeuanganSummary {
  final double totalPemasukan;
  final String totalPemasukanFormatted;
  final double totalPengeluaran;
  final String totalPengeluaranFormatted;
  final double saldo;
  final String saldoFormatted;
  final int pendingBills;
  final int overdueBills;

  KeuanganSummary({
    required this.totalPemasukan,
    required this.totalPemasukanFormatted,
    required this.totalPengeluaran,
    required this.totalPengeluaranFormatted,
    required this.saldo,
    required this.saldoFormatted,
    required this.pendingBills,
    required this.overdueBills,
  });

  factory KeuanganSummary.fromJson(Map<String, dynamic> json) {
    return KeuanganSummary(
      totalPemasukan: (json['total_pemasukan'] ?? 0).toDouble(),
      totalPemasukanFormatted: json['total_pemasukan_formatted'] ?? '',
      totalPengeluaran: (json['total_pengeluaran'] ?? 0).toDouble(),
      totalPengeluaranFormatted: json['total_pengeluaran_formatted'] ?? '',
      saldo: (json['saldo'] ?? 0).toDouble(),
      saldoFormatted: json['saldo_formatted'] ?? '',
      pendingBills: json['pending_bills'] ?? 0,
      overdueBills: json['overdue_bills'] ?? 0,
    );
  }
}

class MonthlyChart {
  final int month;
  final String monthName;
  final double pemasukan;
  final double pengeluaran;

  MonthlyChart({
    required this.month,
    required this.monthName,
    required this.pemasukan,
    required this.pengeluaran,
  });

  factory MonthlyChart.fromJson(Map<String, dynamic> json) {
    return MonthlyChart(
      month: json['month'] ?? 0,
      monthName: json['month_name'] ?? '',
      pemasukan: (json['pemasukan'] ?? 0).toDouble(),
      pengeluaran: (json['pengeluaran'] ?? 0).toDouble(),
    );
  }
}

class BillsStatusChart {
  final String status;
  final String label;
  final int total;

  BillsStatusChart({
    required this.status,
    required this.label,
    required this.total,
  });

  factory BillsStatusChart.fromJson(Map<String, dynamic> json) {
    return BillsStatusChart(
      status: json['status'] ?? '',
      label: json['label'] ?? '',
      total: json['total'] ?? 0,
    );
  }
}

class TopPengeluaranChart {
  final String kategori;
  final double total;

  TopPengeluaranChart({
    required this.kategori,
    required this.total,
  });

  factory TopPengeluaranChart.fromJson(Map<String, dynamic> json) {
    return TopPengeluaranChart(
      kategori: json['kategori'] ?? '',
      total: (json['total'] ?? 0).toDouble(),
    );
  }
}

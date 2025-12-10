class DashboardKegiatanResponse {
  final bool success;
  final String message;
  final DashboardKegiatanData data;

  DashboardKegiatanResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory DashboardKegiatanResponse.fromJson(Map<String, dynamic> json) {
    return DashboardKegiatanResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: DashboardKegiatanData.fromJson(json['data'] ?? {}),
    );
  }
}

class DashboardKegiatanData {
  final int year;
  final KegiatanSummary summary;
  final List<CategoryChart> categoryChart;
  final List<MonthlyActivityChart> monthlyChart;
  final List<TopLocationChart> topLocationsChart;
  final List<TopPersonInChargeChart> topPersonInChargeChart;
  final List<UpcomingActivity> upcomingActivities;

  DashboardKegiatanData({
    required this.year,
    required this.summary,
    required this.categoryChart,
    required this.monthlyChart,
    required this.topLocationsChart,
    required this.topPersonInChargeChart,
    required this.upcomingActivities,
  });

  factory DashboardKegiatanData.fromJson(Map<String, dynamic> json) {
    return DashboardKegiatanData(
      year: json['year'] ?? 0,
      summary: KegiatanSummary.fromJson(json['summary'] ?? {}),
      categoryChart: (json['category_chart'] as List?)
          ?.map((e) => CategoryChart.fromJson(e))
          .toList() ??
          [],
      monthlyChart: (json['monthly_chart'] as List?)
          ?.map((e) => MonthlyActivityChart.fromJson(e))
          .toList() ??
          [],
      topLocationsChart: (json['top_locations_chart'] as List?)
          ?.map((e) => TopLocationChart.fromJson(e))
          .toList() ??
          [],
      topPersonInChargeChart: (json['top_person_in_charge_chart'] as List?)
          ?.map((e) => TopPersonInChargeChart.fromJson(e))
          .toList() ??
          [],
      upcomingActivities: (json['upcoming_activities'] as List?)
          ?.map((e) => UpcomingActivity.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class KegiatanSummary {
  final int totalKegiatan;
  final int kegiatanBulanIni;
  final int sudahLewat;
  final int hariIni;
  final int akanDatang;

  KegiatanSummary({
    required this.totalKegiatan,
    required this.kegiatanBulanIni,
    required this.sudahLewat,
    required this.hariIni,
    required this.akanDatang,
  });

  factory KegiatanSummary.fromJson(Map<String, dynamic> json) {
    return KegiatanSummary(
      totalKegiatan: json['total_kegiatan'] ?? 0,
      kegiatanBulanIni: json['kegiatan_bulan_ini'] ?? 0,
      sudahLewat: json['sudah_lewat'] ?? 0,
      hariIni: json['hari_ini'] ?? 0,
      akanDatang: json['akan_datang'] ?? 0,
    );
  }
}

class CategoryChart {
  final String category;
  final String label;
  final int total;

  CategoryChart({
    required this.category,
    required this.label,
    required this.total,
  });

  factory CategoryChart.fromJson(Map<String, dynamic> json) {
    return CategoryChart(
      category: json['category'] ?? '',
      label: json['label'] ?? '',
      total: json['total'] ?? 0,
    );
  }
}

class MonthlyActivityChart {
  final int month;
  final String monthName;
  final int keagamaan;
  final int pendidikan;
  final int lainnya;
  final int total;

  MonthlyActivityChart({
    required this.month,
    required this.monthName,
    required this.keagamaan,
    required this.pendidikan,
    required this.lainnya,
    required this.total,
  });

  factory MonthlyActivityChart.fromJson(Map<String, dynamic> json) {
    return MonthlyActivityChart(
      month: json['month'] ?? 0,
      monthName: json['month_name'] ?? '',
      keagamaan: json['keagamaan'] ?? 0,
      pendidikan: json['pendidikan'] ?? 0,
      lainnya: json['lainnya'] ?? 0,
      total: json['total'] ?? 0,
    );
  }
}

class TopLocationChart {
  final String location;
  final int total;

  TopLocationChart({
    required this.location,
    required this.total,
  });

  factory TopLocationChart.fromJson(Map<String, dynamic> json) {
    return TopLocationChart(
      location: json['location'] ?? '',
      total: json['total'] ?? 0,
    );
  }
}

class TopPersonInChargeChart {
  final String personInCharge;
  final int total;

  TopPersonInChargeChart({
    required this.personInCharge,
    required this.total,
  });

  factory TopPersonInChargeChart.fromJson(Map<String, dynamic> json) {
    return TopPersonInChargeChart(
      personInCharge: json['person_in_charge'] ?? '',
      total: json['total'] ?? 0,
    );
  }
}

class UpcomingActivity {
  final int id;
  final String name;
  final String category;
  final String categoryLabel;
  final DateTime date;
  final String location;
  final String personInCharge;

  UpcomingActivity({
    required this.id,
    required this.name,
    required this.category,
    required this.categoryLabel,
    required this.date,
    required this.location,
    required this.personInCharge,
  });

  factory UpcomingActivity.fromJson(Map<String, dynamic> json) {
    return UpcomingActivity(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      categoryLabel: json['category_label'] ?? '',
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),
      location: json['location'] ?? '',
      personInCharge: json['person_in_charge'] ?? '',
    );
  }
}

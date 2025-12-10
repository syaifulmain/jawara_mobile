class DashboardKependudukanResponse {
  final bool success;
  final String message;
  final DashboardKependudukanData data;

  DashboardKependudukanResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory DashboardKependudukanResponse.fromJson(Map<String, dynamic> json) {
    return DashboardKependudukanResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: DashboardKependudukanData.fromJson(json['data'] ?? {}),
    );
  }
}

class DashboardKependudukanData {
  final KependudukanSummary summary;
  final List<GenderChart> genderChart;
  final List<ReligionChart> religionChart;
  final List<BloodTypeChart> bloodTypeChart;
  final List<AgeDistributionChart> ageDistributionChart;
  final List<EducationChart> educationChart;
  final List<OccupationChart> occupationChart;
  final List<OwnershipChart> ownershipChart;
  final List<FamilyRoleChart> familyRoleChart;

  DashboardKependudukanData({
    required this.summary,
    required this.genderChart,
    required this.religionChart,
    required this.bloodTypeChart,
    required this.ageDistributionChart,
    required this.educationChart,
    required this.occupationChart,
    required this.ownershipChart,
    required this.familyRoleChart,
  });

  factory DashboardKependudukanData.fromJson(Map<String, dynamic> json) {
    return DashboardKependudukanData(
      summary: KependudukanSummary.fromJson(json['summary'] ?? {}),
      genderChart: (json['gender_chart'] as List?)
          ?.map((e) => GenderChart.fromJson(e))
          .toList() ??
          [],
      religionChart: (json['religion_chart'] as List?)
          ?.map((e) => ReligionChart.fromJson(e))
          .toList() ??
          [],
      bloodTypeChart: (json['blood_type_chart'] as List?)
          ?.map((e) => BloodTypeChart.fromJson(e))
          .toList() ??
          [],
      ageDistributionChart: (json['age_distribution_chart'] as List?)
          ?.map((e) => AgeDistributionChart.fromJson(e))
          .toList() ??
          [],
      educationChart: (json['education_chart'] as List?)
          ?.map((e) => EducationChart.fromJson(e))
          .toList() ??
          [],
      occupationChart: (json['occupation_chart'] as List?)
          ?.map((e) => OccupationChart.fromJson(e))
          .toList() ??
          [],
      ownershipChart: (json['ownership_chart'] as List?)
          ?.map((e) => OwnershipChart.fromJson(e))
          .toList() ??
          [],
      familyRoleChart: (json['family_role_chart'] as List?)
          ?.map((e) => FamilyRoleChart.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class KependudukanSummary {
  final int totalPenduduk;
  final int totalKeluarga;
  final int totalRumah;
  final int rumahDitempati;
  final int rumahKosong;
  final int lakiLaki;
  final int perempuan;

  KependudukanSummary({
    required this.totalPenduduk,
    required this.totalKeluarga,
    required this.totalRumah,
    required this.rumahDitempati,
    required this.rumahKosong,
    required this.lakiLaki,
    required this.perempuan,
  });

  factory KependudukanSummary.fromJson(Map<String, dynamic> json) {
    return KependudukanSummary(
      totalPenduduk: json['total_penduduk'] ?? 0,
      totalKeluarga: json['total_keluarga'] ?? 0,
      totalRumah: json['total_rumah'] ?? 0,
      rumahDitempati: json['rumah_ditempati'] ?? 0,
      rumahKosong: json['rumah_kosong'] ?? 0,
      lakiLaki: json['laki_laki'] ?? 0,
      perempuan: json['perempuan'] ?? 0,
    );
  }
}

class GenderChart {
  final String gender;
  final String label;
  final int total;

  GenderChart({
    required this.gender,
    required this.label,
    required this.total,
  });

  factory GenderChart.fromJson(Map<String, dynamic> json) {
    return GenderChart(
      gender: json['gender'] ?? '',
      label: json['label'] ?? '',
      total: json['total'] ?? 0,
    );
  }
}

class ReligionChart {
  final String religion;
  final int total;

  ReligionChart({
    required this.religion,
    required this.total,
  });

  factory ReligionChart.fromJson(Map<String, dynamic> json) {
    return ReligionChart(
      religion: json['religion'] ?? '',
      total: json['total'] ?? 0,
    );
  }
}

class BloodTypeChart {
  final String bloodType;
  final int total;

  BloodTypeChart({
    required this.bloodType,
    required this.total,
  });

  factory BloodTypeChart.fromJson(Map<String, dynamic> json) {
    return BloodTypeChart(
      bloodType: json['blood_type'] ?? '',
      total: json['total'] ?? 0,
    );
  }
}

class AgeDistributionChart {
  final String ageRange;
  final int total;

  AgeDistributionChart({
    required this.ageRange,
    required this.total,
  });

  factory AgeDistributionChart.fromJson(Map<String, dynamic> json) {
    return AgeDistributionChart(
      ageRange: json['age_range'] ?? '',
      total: json['total'] ?? 0,
    );
  }
}

class EducationChart {
  final String education;
  final int total;

  EducationChart({
    required this.education,
    required this.total,
  });

  factory EducationChart.fromJson(Map<String, dynamic> json) {
    return EducationChart(
      education: json['education'] ?? '',
      total: json['total'] ?? 0,
    );
  }
}

class OccupationChart {
  final String occupation;
  final int total;

  OccupationChart({
    required this.occupation,
    required this.total,
  });

  factory OccupationChart.fromJson(Map<String, dynamic> json) {
    return OccupationChart(
      occupation: json['occupation'] ?? '',
      total: json['total'] ?? 0,
    );
  }
}

class OwnershipChart {
  final String status;
  final String label;
  final int total;

  OwnershipChart({
    required this.status,
    required this.label,
    required this.total,
  });

  factory OwnershipChart.fromJson(Map<String, dynamic> json) {
    return OwnershipChart(
      status: json['status'] ?? '',
      label: json['label'] ?? '',
      total: json['total'] ?? 0,
    );
  }
}

class FamilyRoleChart {
  final String role;
  final int total;

  FamilyRoleChart({
    required this.role,
    required this.total,
  });

  factory FamilyRoleChart.fromJson(Map<String, dynamic> json) {
    return FamilyRoleChart(
      role: json['role'] ?? '',
      total: json['total'] ?? 0,
    );
  }
}

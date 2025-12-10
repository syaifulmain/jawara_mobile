import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/color_constant.dart';
import '../../../constants/rem_constant.dart';
import '../../../models/dashboard/kependudukan.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/dashboard_provider.dart';

class PopulationScreen extends StatefulWidget {
  const PopulationScreen({Key? key}) : super(key: key);

  @override
  State<PopulationScreen> createState() => _PopulationScreenState();
}

class _PopulationScreenState extends State<PopulationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDashboard();
    });
  }

  void _loadDashboard() {
    final authProvider = context.read<AuthProvider>();
    final dashboardProvider = context.read<DashboardProvider>();

    final token = authProvider.token;
    if (token != null) {
      dashboardProvider.fetchDashboardKependudukan(token);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
        title: Text(
          'Dashboard Kependudukan',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<DashboardProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(provider.errorMessage!),
                  const SizedBox(height: Rem.rem1),
                  ElevatedButton(
                    onPressed: _loadDashboard,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          final data = provider.dashboardKependudukanData;
          if (data == null) {
            return const Center(child: Text('Data tidak tersedia'));
          }

          return RefreshIndicator(
            onRefresh: () async => _loadDashboard(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(Rem.rem1_5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummaryCards(data.summary),
                  const SizedBox(height: Rem.rem1_5),
                  _buildGenderChart(data.genderChart),
                  const SizedBox(height: Rem.rem1_5),
                  _buildReligionChart(data.religionChart),
                  const SizedBox(height: Rem.rem1_5),
                  _buildBloodTypeChart(data.bloodTypeChart),
                  const SizedBox(height: Rem.rem1_5),
                  _buildAgeDistributionChart(data.ageDistributionChart),
                  const SizedBox(height: Rem.rem1_5),
                  _buildEducationChart(data.educationChart),
                  const SizedBox(height: Rem.rem1_5),
                  _buildOccupationChart(data.occupationChart),
                  const SizedBox(height: Rem.rem1_5),
                  _buildOwnershipChart(data.ownershipChart),
                  const SizedBox(height: Rem.rem1_5),
                  _buildFamilyRoleChart(data.familyRoleChart),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCards(KependudukanSummary summary) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Total Penduduk',
                summary.totalPenduduk.toString(),
                Colors.blue,
                Icons.people,
              ),
            ),
            const SizedBox(width: Rem.rem0_75),
            Expanded(
              child: _buildSummaryCard(
                'Total Keluarga',
                summary.totalKeluarga.toString(),
                Colors.green,
                Icons.family_restroom,
              ),
            ),
          ],
        ),
        const SizedBox(height: Rem.rem0_75),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Total Rumah',
                summary.totalRumah.toString(),
                Colors.orange,
                Icons.home,
              ),
            ),
            const SizedBox(width: Rem.rem0_75),
            Expanded(
              child: _buildSummaryCard(
                'Rumah Ditempati',
                summary.rumahDitempati.toString(),
                Colors.purple,
                Icons.home_filled,
              ),
            ),
          ],
        ),
        const SizedBox(height: Rem.rem0_75),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Laki-laki',
                summary.lakiLaki.toString(),
                Colors.indigo,
                Icons.male,
              ),
            ),
            const SizedBox(width: Rem.rem0_75),
            Expanded(
              child: _buildSummaryCard(
                'Perempuan',
                summary.perempuan.toString(),
                Colors.pink,
                Icons.female,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color, IconData icon) {
    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(Rem.rem1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: Rem.rem2),
            const SizedBox(height: Rem.rem0_5),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: Rem.rem0_875,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: Rem.rem0_5),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: Rem.rem1_25,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderChart(List<GenderChart> data) {
    if (data.isEmpty) return const SizedBox.shrink();

    final colors = [Colors.blue, Colors.pink];

    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(Rem.rem1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Distribusi Gender',
              style: GoogleFonts.poppins(
                fontSize: Rem.rem1_125,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: Rem.rem1),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: data.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return PieChartSectionData(
                      value: item.total.toDouble(),
                      title: '${item.label}\n${item.total}',
                      color: colors[index % colors.length],
                      radius: 50,
                      titleStyle: GoogleFonts.poppins(
                        fontSize: Rem.rem0_875,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                  sectionsSpace: 2,
                  centerSpaceRadius: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReligionChart(List<ReligionChart> data) {
    if (data.isEmpty) return const SizedBox.shrink();

    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(Rem.rem1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Distribusi Agama',
              style: GoogleFonts.poppins(
                fontSize: Rem.rem1_125,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: Rem.rem1),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _getMaxValue(data.map((e) => e.total).toList()) * 1.2,
                  barGroups: data.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.total.toDouble(),
                          color: Colors.green,
                          width: 20,
                        ),
                      ],
                    );
                  }).toList(),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 && value.toInt() < data.length) {
                            return Text(
                              data[value.toInt()].religion,
                              style: GoogleFonts.poppins(fontSize: Rem.rem0_75),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBloodTypeChart(List<BloodTypeChart> data) {
    if (data.isEmpty) return const SizedBox.shrink();

    final colors = [Colors.red, Colors.blue, Colors.green, Colors.orange];

    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(Rem.rem1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Distribusi Golongan Darah',
              style: GoogleFonts.poppins(
                fontSize: Rem.rem1_125,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: Rem.rem1),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: data.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return PieChartSectionData(
                      value: item.total.toDouble(),
                      title: '${item.bloodType}\n${item.total}',
                      color: colors[index % colors.length],
                      radius: 50,
                      titleStyle: GoogleFonts.poppins(
                        fontSize: Rem.rem0_875,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                  sectionsSpace: 2,
                  centerSpaceRadius: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgeDistributionChart(List<AgeDistributionChart> data) {
    if (data.isEmpty) return const SizedBox.shrink();

    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(Rem.rem1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Distribusi Usia',
              style: GoogleFonts.poppins(
                fontSize: Rem.rem1_125,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: Rem.rem1),
            SizedBox(
              height: 400,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _getMaxValue(data.map((e) => e.total).toList()) * 1.2,
                  barGroups: data.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.total.toDouble(),
                          color: Colors.purple,
                          width: 20,
                        ),
                      ],
                    );
                  }).toList(),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 && value.toInt() < data.length) {
                            return Text(
                              data[value.toInt()].ageRange,
                              style: GoogleFonts.poppins(fontSize: Rem.rem0_75),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEducationChart(List<EducationChart> data) {
    if (data.isEmpty) return const SizedBox.shrink();

    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(Rem.rem1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Distribusi Pendidikan',
              style: GoogleFonts.poppins(
                fontSize: Rem.rem1_125,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: Rem.rem1),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _getMaxValue(data.map((e) => e.total).toList()) * 1.2,
                  barGroups: data.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.total.toDouble(),
                          color: Colors.teal,
                          width: 20,
                        ),
                      ],
                    );
                  }).toList(),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 && value.toInt() < data.length) {
                            return Text(
                              data[value.toInt()].education,
                              style: GoogleFonts.poppins(fontSize: Rem.rem0_75),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOccupationChart(List<OccupationChart> data) {
    if (data.isEmpty) return const SizedBox.shrink();

    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(Rem.rem1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Distribusi Pekerjaan',
              style: GoogleFonts.poppins(
                fontSize: Rem.rem1_125,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: Rem.rem1),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _getMaxValue(data.map((e) => e.total).toList()) * 1.2,
                  barGroups: data.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.total.toDouble(),
                          color: Colors.amber,
                          width: 20,
                        ),
                      ],
                    );
                  }).toList(),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 && value.toInt() < data.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                data[value.toInt()].occupation,
                                style: GoogleFonts.poppins(fontSize: Rem.rem0_625),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOwnershipChart(List<OwnershipChart> data) {
    if (data.isEmpty) return const SizedBox.shrink();

    final colors = [Colors.indigo, Colors.cyan];

    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(Rem.rem1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status Kepemilikan Rumah',
              style: GoogleFonts.poppins(
                fontSize: Rem.rem1_125,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: Rem.rem1),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: data.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return PieChartSectionData(
                      value: item.total.toDouble(),
                      title: '${item.label}\n${item.total}',
                      color: colors[index % colors.length],
                      radius: 80,
                      titleStyle: GoogleFonts.poppins(
                        fontSize: Rem.rem0_875,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFamilyRoleChart(List<FamilyRoleChart> data) {
    if (data.isEmpty) return const SizedBox.shrink();

    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(Rem.rem1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Peran dalam Keluarga',
              style: GoogleFonts.poppins(
                fontSize: Rem.rem1_125,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: Rem.rem1),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _getMaxValue(data.map((e) => e.total).toList()) * 1.2,
                  barGroups: data.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.total.toDouble(),
                          color: Colors.deepOrange,
                          width: 20,
                        ),
                      ],
                    );
                  }).toList(),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 && value.toInt() < data.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                data[value.toInt()].role,
                                style: GoogleFonts.poppins(fontSize: Rem.rem0_625),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _getMaxValue(List<int> values) {
    if (values.isEmpty) return 10;
    return values.reduce((a, b) => a > b ? a : b).toDouble();
  }
}

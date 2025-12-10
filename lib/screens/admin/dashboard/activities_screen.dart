import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../constants/color_constant.dart';
import '../../../constants/rem_constant.dart';
import '../../../models/dashboard/kegiatan.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/dashboard_provider.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({Key? key}) : super(key: key);

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
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
      dashboardProvider.fetchDashboardKegiatan(token);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
        title: Text(
          'Dashboard Kegiatan',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Consumer<DashboardProvider>(
            builder: (context, provider, _) {
              return PopupMenuButton<int>(
                icon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      provider.currentYear.toString(),
                      style: GoogleFonts.poppins(fontSize: Rem.rem0_875),
                    ),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
                color: Colors.white,
                onSelected: (year) {
                  final authProvider = context.read<AuthProvider>();
                  final token = authProvider.token;
                  if (token != null) {
                    provider.changeYearKegiatan(token, year);
                  }
                },
                itemBuilder: (context) {
                  final currentYear = DateTime.now().year;
                  return List.generate(5, (index) {
                    final year = currentYear - index;
                    return PopupMenuItem<int>(
                      value: year,
                      child: Text(year.toString()),
                    );
                  });
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDashboard,
          ),
        ],
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
                  Text(
                    provider.errorMessage!,
                    style: GoogleFonts.poppins(),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: Rem.rem1),
                  ElevatedButton(
                    onPressed: _loadDashboard,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          final data = provider.dashboardKegiatanData;
          if (data == null) {
            return Center(
              child: Text(
                'Tidak ada data',
                style: GoogleFonts.poppins(),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => _loadDashboard(),
            child: ListView(
              padding: const EdgeInsets.all(Rem.rem1_5),
              children: [
                _buildSummaryCards(data.summary),
                const SizedBox(height: Rem.rem1_5),
                _buildCategoryChart(data.categoryChart),
                const SizedBox(height: Rem.rem1_5),
                _buildMonthlyChart(data.monthlyChart),
                const SizedBox(height: Rem.rem1_5),
                _buildTopLocationsChart(data.topLocationsChart),
                const SizedBox(height: Rem.rem1_5),
                _buildTopPersonInChargeChart(data.topPersonInChargeChart),
                const SizedBox(height: Rem.rem1_5),
                _buildUpcomingActivities(data.upcomingActivities),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCards(KegiatanSummary summary) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Total Kegiatan',
                '${summary.totalKegiatan}',
                Colors.blue,
                Icons.event,
              ),
            ),
            const SizedBox(width: Rem.rem0_75),
            Expanded(
              child: _buildSummaryCard(
                'Bulan Ini',
                '${summary.kegiatanBulanIni}',
                Colors.green,
                Icons.calendar_month,
              ),
            ),
          ],
        ),
        const SizedBox(height: Rem.rem0_75),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Hari Ini',
                '${summary.hariIni}',
                Colors.orange,
                Icons.today,
              ),
            ),
            const SizedBox(width: Rem.rem0_75),
            Expanded(
              child: _buildSummaryCard(
                'Akan Datang',
                '${summary.akanDatang}',
                Colors.purple,
                Icons.upcoming,
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
            Row(
              children: [
                Icon(icon, color: color, size: Rem.rem1_5),
                const SizedBox(width: Rem.rem0_5),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: Rem.rem0_875,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
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

  Widget _buildCategoryChart(List<CategoryChart> data) {
    if (data.isEmpty) return const SizedBox.shrink();

    final colors = [Colors.green, Colors.blue, Colors.orange];

    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(Rem.rem1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kategori Kegiatan',
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
                    final color = colors[index % colors.length];
                    return PieChartSectionData(
                      value: item.total.toDouble(),
                      title: '${item.total}',
                      color: color,
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
            const SizedBox(height: Rem.rem1),
            ...data.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final color = colors[index % colors.length];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: Rem.rem0_25),
                child: Row(
                  children: [
                    Container(
                      width: Rem.rem1,
                      height: Rem.rem1,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: Rem.rem0_5),
                    Expanded(
                      child: Text(
                        item.label,
                        style: GoogleFonts.poppins(fontSize: Rem.rem0_875),
                      ),
                    ),
                    Text(
                      '${item.total}',
                      style: GoogleFonts.poppins(
                        fontSize: Rem.rem0_875,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyChart(List<MonthlyActivityChart> data) {
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
              'Grafik Bulanan',
              style: GoogleFonts.poppins(
                fontSize: Rem.rem1_125,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: Rem.rem1),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _getMaxMonthlyValue(data) * 1.2,
                  barGroups: data.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: item.keagamaan.toDouble(),
                          color: Colors.green,
                          width: 8,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                        BarChartRodData(
                          toY: item.pendidikan.toDouble(),
                          color: Colors.blue,
                          width: 8,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                        BarChartRodData(
                          toY: item.lainnya.toDouble(),
                          color: Colors.orange,
                          width: 8,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() < data.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: Rem.rem0_5),
                              child: Text(
                                data[value.toInt()].monthName,
                                style: GoogleFonts.poppins(fontSize: Rem.rem0_75),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: GoogleFonts.poppins(fontSize: Rem.rem0_75),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.shade300,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
            const SizedBox(height: Rem.rem1),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem('Keagamaan', Colors.green),
                const SizedBox(width: Rem.rem1),
                _buildLegendItem('Pendidikan', Colors.blue),
                const SizedBox(width: Rem.rem1),
                _buildLegendItem('Lainnya', Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  double _getMaxMonthlyValue(List<MonthlyActivityChart> data) {
    double max = 0;
    for (var item in data) {
      if (item.total > max) max = item.total.toDouble();
    }
    return max == 0 ? 10 : max;
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: Rem.rem1,
          height: Rem.rem1,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: Rem.rem0_5),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: Rem.rem0_75),
        ),
      ],
    );
  }

  Widget _buildTopLocationsChart(List<TopLocationChart> data) {
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
              'Lokasi Terpopuler',
              style: GoogleFonts.poppins(
                fontSize: Rem.rem1_125,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: Rem.rem1),
            ...data.map((item) => Container(
              margin: const EdgeInsets.only(bottom: Rem.rem0_75),
              padding: const EdgeInsets.all(Rem.rem0_75),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(Rem.rem0_5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.location,
                      style: GoogleFonts.poppins(fontSize: Rem.rem0_875),
                    ),
                  ),
                  Text(
                    '${item.total} kegiatan',
                    style: GoogleFonts.poppins(
                      fontSize: Rem.rem0_875,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildTopPersonInChargeChart(List<TopPersonInChargeChart> data) {
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
              'Penanggung Jawab Teraktif',
              style: GoogleFonts.poppins(
                fontSize: Rem.rem1_125,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: Rem.rem1),
            ...data.map((item) => Container(
              margin: const EdgeInsets.only(bottom: Rem.rem0_75),
              padding: const EdgeInsets.all(Rem.rem0_75),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(Rem.rem0_5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.personInCharge,
                      style: GoogleFonts.poppins(fontSize: Rem.rem0_875),
                    ),
                  ),
                  Text(
                    '${item.total} kegiatan',
                    style: GoogleFonts.poppins(
                      fontSize: Rem.rem0_875,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingActivities(List<UpcomingActivity> data) {
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
              'Kegiatan Mendatang',
              style: GoogleFonts.poppins(
                fontSize: Rem.rem1_125,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: Rem.rem1),
            ...data.map((item) => Container(
              margin: const EdgeInsets.only(bottom: Rem.rem0_75),
              padding: const EdgeInsets.all(Rem.rem0_75),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(Rem.rem0_5),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: GoogleFonts.poppins(
                            fontSize: Rem.rem0_875,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Rem.rem0_5,
                          vertical: Rem.rem0_25,
                        ),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(item.category),
                          borderRadius: BorderRadius.circular(Rem.rem0_25),
                        ),
                        child: Text(
                          item.categoryLabel,
                          style: GoogleFonts.poppins(
                            fontSize: Rem.rem0_75,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Rem.rem0_5),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: Rem.rem0_875, color: Colors.grey.shade600),
                      const SizedBox(width: Rem.rem0_25),
                      Text(
                        DateFormat('dd MMM yyyy, HH:mm').format(item.date),
                        style: GoogleFonts.poppins(
                          fontSize: Rem.rem0_75,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Rem.rem0_25),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: Rem.rem0_875, color: Colors.grey.shade600),
                      const SizedBox(width: Rem.rem0_25),
                      Expanded(
                        child: Text(
                          item.location,
                          style: GoogleFonts.poppins(
                            fontSize: Rem.rem0_75,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Rem.rem0_25),
                  Row(
                    children: [
                      Icon(Icons.person, size: Rem.rem0_875, color: Colors.grey.shade600),
                      const SizedBox(width: Rem.rem0_25),
                      Expanded(
                        child: Text(
                          item.personInCharge,
                          style: GoogleFonts.poppins(
                            fontSize: Rem.rem0_75,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'keagamaan':
        return Colors.green;
      case 'pendidikan':
        return Colors.blue;
      case 'lainnya':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}


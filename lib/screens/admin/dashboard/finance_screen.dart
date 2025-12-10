import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constants/color_constant.dart';
import '../../../constants/rem_constant.dart';
import '../../../models/dashboard/keuangan.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/dashboard_provider.dart';

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({Key? key}) : super(key: key);

  @override
  State<FinanceScreen> createState() => _FinanceScreen();
}

class _FinanceScreen extends State<FinanceScreen> {
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
      dashboardProvider.fetchDashboard(token);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
        title: Text(
          'Dashboard Keuangan',
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
                    provider.changeYear(token, year);
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

          final data = provider.dashboardData;
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
                _buildMonthlyChart(data.monthlyChart),
                const SizedBox(height: Rem.rem1_5),
                _buildBillsStatusChart(data.billsStatusChart),
                const SizedBox(height: Rem.rem1_5),
                _buildTopPengeluaranChart(data.topPengeluaranChart),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCards(KeuanganSummary summary) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Pemasukan',
                summary.totalPemasukanFormatted,
                Colors.green,
                Icons.arrow_upward,
              ),
            ),
            const SizedBox(width: Rem.rem0_75),
            Expanded(
              child: _buildSummaryCard(
                'Pengeluaran',
                summary.totalPengeluaranFormatted,
                Colors.red,
                Icons.arrow_downward,
              ),
            ),
          ],
        ),
        const SizedBox(height: Rem.rem0_75),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Saldo',
                summary.saldoFormatted,
                Colors.blue,
                Icons.account_balance_wallet,
              ),
            ),
            const SizedBox(width: Rem.rem0_75),
            Expanded(
              child: _buildSummaryCard(
                'Tagihan Pending',
                '${summary.pendingBills}',
                Colors.orange,
                Icons.pending_actions,
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
                Icon(icon, color: color, size: Rem.rem1_25),
                const SizedBox(width: Rem.rem0_5),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: Rem.rem0_75,
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
                fontSize: Rem.rem1,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyChart(List<MonthlyChart> data) {
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
                  maxY: _getMaxValue(data) * 1.2,
                  barGroups: data.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: item.pemasukan / 1000000,
                          color: Colors.green,
                          width: 12,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                        BarChartRodData(
                          toY: item.pengeluaran / 1000000,
                          color: Colors.red,
                          width: 12,
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
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}M',
                            style: GoogleFonts.poppins(fontSize: Rem.rem0_75),
                          );
                        },
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
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
                _buildLegendItem('Pemasukan', Colors.green),
                const SizedBox(width: Rem.rem1_5),
                _buildLegendItem('Pengeluaran', Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  double _getMaxValue(List<MonthlyChart> data) {
    double max = 0;
    for (var item in data) {
      if (item.pemasukan / 1000000 > max) max = item.pemasukan / 1000000;
      if (item.pengeluaran / 1000000 > max) max = item.pengeluaran / 1000000;
    }
    return max;
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

  Widget _buildBillsStatusChart(List<BillsStatusChart> data) {
    if (data.isEmpty) return const SizedBox.shrink();

    final colors = [Colors.green, Colors.orange, Colors.red, Colors.blue];

    return Card(
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(Rem.rem1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status Tagihan',
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

  Widget _buildTopPengeluaranChart(List<TopPengeluaranChart> data) {
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
              'Top Pengeluaran',
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
                  Text(
                    item.kategori,
                    style: GoogleFonts.poppins(fontSize: Rem.rem0_875),
                  ),
                  Text(
                    'Rp ${_formatNumber(item.total)}',
                    style: GoogleFonts.poppins(
                      fontSize: Rem.rem0_875,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
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

  String _formatNumber(double number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toStringAsFixed(0);
  }
}

import 'package:flutter/material.dart';
import 'package:jawara_mobile/widgets/bar_chart_card.dart'; 
import 'package:jawara_mobile/widgets/pie_chart_cart.dart';
import 'package:jawara_mobile/models/pie_chart_data_model.dart';

import '../../../constants/colors.dart';

const List<Color> _incomeColors = [
  Colors.blue,
  Colors.cyan,
  Colors.lightBlue,
];
const List<Color> _expenseColors = [
  Colors.red,
  Colors.orange,
  Colors.deepOrange,
];

class Keuangan {
  static List<Map<String, dynamic>> numberStats = [
    {
      'title': 'Total Pemasukan',
      'value': '100 jt',
      'icon': Icons.trending_up,
      'color': Colors.blue, 
      'backgroundColor': Colors.blueAccent.withOpacity(0.1),
    },
    {
      'title': 'Total Pengeluaran',
      'value': '3 jt',
      'icon': Icons.trending_down,
      'color': Colors.red, 
      'backgroundColor': Colors.redAccent.withOpacity(0.1),
    },
    {
      'title': 'Jumlah Transaksi',
      'value': '7',
      'icon': Icons.receipt_long,
      'color': Colors.orange,
      'backgroundColor': Colors.orangeAccent.withOpacity(0.1),
    },
  ];

  static List<Map<String, dynamic>> barCharts = [
    {
      'title': 'Pemasukan per Bulan',
      'data': {'Agu': 30.0, 'Sep': 20.0, 'Okt': 50.0},
      'color': Colors.blue, 
    },
    {
      'title': 'Pengeluaran per Bulan',
      'data': {'Agu': 850.0, 'Sep': 150.0, 'Okt': 650.0}, 
      'color': Colors.redAccent,
    },
  ];

  static List<Map<String, dynamic>> rawPieCharts = [
    {
      'title': 'Pemasukan Berdasarkan Kategori',
      'icon': Icons.pie_chart,
      'data': {'Gaji': 70, 'Bonus': 20, 'Lainnya': 10},
    },
    {
      'title': 'Pengeluaran Berdasarkan Kategori',
      'icon': Icons.pie_chart_outline,
      'data': {'Makan': 34, 'Transport': 25, 'Belanja': 41},
    },
  ];

  static List<Map<String, dynamic>> get pieCharts {
    return rawPieCharts.map((rawChart) {
      final isIncome = rawChart['title'].toString().contains('Pemasukan');
      final colors = isIncome ? _incomeColors : _expenseColors;
      
      List<PieChartDataModel> models = (rawChart['data'] as Map<String, int>)
          .entries
          .toList()
          .asMap()
          .entries
          .map((entry) {
        int index = entry.key;
        MapEntry<String, int> mapEntry = entry.value;

        return PieChartDataModel(
          mapEntry.key, 
          mapEntry.value.toDouble(), 
          colors[index % colors.length],
          mapEntry.key, 
        );
      }).toList();

      return {
        'title': rawChart['title'],
        'icon': rawChart['icon'],
        'data': models, 
      };
    }).toList();
  }
}

class KeuanganScreen extends StatelessWidget {
  const KeuanganScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Dashboard Keuangan')),
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ringkasan Keuangan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: Keuangan.numberStats.map((item) {
                double cardWidth;
                final screenWidth = MediaQuery.of(context).size.width;
                
                const double globalPadding = 32.0;
                const double spacing = 12.0;

                if (screenWidth > 700) {
                  const double totalInternalSpacing = spacing * 2;
                  cardWidth = (screenWidth - globalPadding - totalInternalSpacing) / 3; 
                } else {
                  const double totalInternalSpacing = spacing;
                  cardWidth = (screenWidth - globalPadding - totalInternalSpacing) / 2;
                }

                return Container(
                  width: cardWidth, 
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: item['backgroundColor'],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(item['icon'], color: item['color'], size: 30),
                      const SizedBox(height: 8),
                      Text(item['title'], textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(item['value'], style: TextStyle(color: item['color'], fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            const Text(
              'Grafik per Bulan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 16,
                children: Keuangan.barCharts.map((chart) {
                  return SizedBox(
                    width: 300,
                    child: BarChartCard(
                      title: chart['title'],
                      data: chart['data'] as Map<String, double>,
                      color: chart['color'],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Kategori Keuangan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: Keuangan.pieCharts.map((chart) {
                return PieChartCard(
                  title: chart['title'],
                  data: chart['data'] as List<PieChartDataModel>, 
                  icon: chart['icon'],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

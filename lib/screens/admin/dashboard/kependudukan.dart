import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/rem.dart';
import '../../../data/dashboard_kependudukan_data.dart';
import '../../../widgets/pie_chart_cart.dart';
import '../../../widgets/statistic_card.dart';

void main() {
  runApp(const MaterialApp(home: DashboardKependudukan()));
}

class DashboardKependudukan extends StatelessWidget {
  const DashboardKependudukan({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> dashboardItems = [];

    for (var stat in mainStats) {
      dashboardItems.add(
        StatisticCard(
          title: stat['title'],
          value: stat['value'],
          color: stat['color'],
          backgroundColor: stat['backgroundColor'],
          icon: stat['icon'],
        ),
      );
    }

    for (var chartData in dummyData) {
      dashboardItems.add(
        PieChartCard(
          title: chartData['title'],
          data: chartData['data'],
          icon: chartData['icon'],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(Rem.rem1),
        child: ListView.separated(
          itemCount: dashboardItems.length,
          itemBuilder: (context, index) {
            return dashboardItems[index];
          },
          separatorBuilder: (context, index) => const SizedBox(height: Rem.rem0_5),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:jawara_mobile/constants/colors.dart';
import 'package:jawara_mobile/constants/rem.dart';
import 'package:jawara_mobile/data/dashboard_kependudukan_data.dart';
import 'package:jawara_mobile/data/kegiatan_data.dart';
import 'package:jawara_mobile/widgets/empty_statistic_card.dart';
import 'package:jawara_mobile/widgets/pie_chart_cart.dart';
import 'package:jawara_mobile/widgets/statistic_card.dart';

class Kegiatan extends StatelessWidget {
  const Kegiatan({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> dashboardItems = [];

    for (var stat in KegiatanData.numberStats) {
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

    for (var chartData in KegiatanData.kegiatanPerKategori) {
      dashboardItems.add(
        PieChartCard(
          title: chartData['title'],
          data: chartData['data'],
          icon: chartData['icon'],
        ),
      );
    }

    dashboardItems.add(
      EmptyStatisticCard(
        title: "Kegiatan Berdasarkan Waktu",
        color: Colors.black54,
        backgroundColor: Colors.yellow,
        icon: Icons.alarm,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("Sudah Lewat: "), Text("1")],
          ),Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("Hari Ini: "), Text("2")],
          ),Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("Akan Datang: "), Text("2")],
          ),

        ],
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(Rem.rem1),
        child: ListView.separated(
          itemCount: dashboardItems.length,
          itemBuilder: (context, index) {
            return dashboardItems[index];
          },
          separatorBuilder: (context, index) =>
              const SizedBox(height: Rem.rem0_5),
        ),
      ),
    );
  }
}

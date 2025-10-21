import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_mobile/constants/rem.dart';
import '../models/pie_chart_data_model.dart';

class PieChartCard extends StatelessWidget {
  final String title;
  final List<PieChartDataModel> data;
  final IconData icon;

  const PieChartCard({
    Key? key,
    required this.title,
    required this.data,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(Rem.rem1),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, size: Rem.rem1_25),
                const SizedBox(width: Rem.rem0_5),
                Text(
                  title,
                  style: GoogleFonts.figtree(
                      fontSize: Rem.rem1, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: Rem.rem0_5),

            AspectRatio(
              aspectRatio: 1.7,
              child: _buildPieChart(data),
            ),
            const SizedBox(height: Rem.rem0_5),

            Align(
              alignment: Alignment.centerLeft,
              child: _buildLegend(data),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart(List<PieChartDataModel> data) {
    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: Rem.rem2_5,
        startDegreeOffset: 90,
        sections: data.map((item) {
          return PieChartSectionData(
            color: item.color,
            value: item.value,
            title: '${item.value.toStringAsFixed(0)}%',
            radius: 50,
            titleStyle: GoogleFonts.figtree(
              fontSize: Rem.rem0_75,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLegend(List<PieChartDataModel> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: data.map((item) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                color: item.color,
              ),
              const SizedBox(width: Rem.rem0_5),
              Text(
                item.label,
                style: GoogleFonts.figtree(fontSize: Rem.rem0_75),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

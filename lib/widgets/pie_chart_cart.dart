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
    super.key,
    required this.title,
    required this.data,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(Rem.rem1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: Rem.rem1_25),
                const SizedBox(width: Rem.rem0_5),
                Text(
                  title,
                  style: GoogleFonts.figtree(
                    fontSize: Rem.rem1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: Rem.rem0_75),

            // PieChart Responsive
            AspectRatio(
              aspectRatio: 1.4,
              child: _buildPieChart(context, data),
            ),

            const SizedBox(height: Rem.rem1),

            Text(
              "Keterangan",
              style: GoogleFonts.figtree(
                fontSize: Rem.rem0_75,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: Rem.rem0_5),

            _buildLegend(data),
          ],
        ),
      ),
    );
  }

  /// Pie chart responsive radius
  Widget _buildPieChart(BuildContext context, List<PieChartDataModel> data) {
    double screenWidth = MediaQuery.of(context).size.width;
    double radius = screenWidth * 0.18; // 18% dari lebar layar (mobile-friendly)

    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: Rem.rem0_25,
        startDegreeOffset: -90,
        sections: data.map((item) {
          return PieChartSectionData(
            color: item.color,
            value: item.value,
            title: '${item.value.toStringAsFixed(0)}%',
            radius: radius,
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

  /// Legend rapi dan wrap otomatis
  Widget _buildLegend(List<PieChartDataModel> data) {
    return Wrap(
      spacing: Rem.rem1,
      runSpacing: Rem.rem0_5,
      children: data.map((item) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: item.color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: Rem.rem0_5),
            Text(
              item.label,
              style: GoogleFonts.figtree(fontSize: Rem.rem0_5),
            ),
          ],
        );
      }).toList(),
    );
  }
}

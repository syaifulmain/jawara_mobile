import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BarChartCard extends StatelessWidget {
  final String title;
  final Map<String, double> data;
  final Color color;

  const BarChartCard({
    super.key,
    required this.title,
    required this.data,
    required this.color,
  });

  BarChartData _getBarChartData(List<String> keys, List<double> values) {
    final double maxValue = values.reduce((a, b) => a > b ? a : b);

    double maxY;
    double intervalY;
    
    if (title.contains('Pemasukan')) {
      maxY = 60.0; 
      intervalY = 15.0;
    } else if (title.contains('Pengeluaran')) {
      maxY = 900.0; 
      intervalY = 150.0;
    } else {
      maxY = maxValue * 1.05;
      intervalY = maxY / 4;
    }

    return BarChartData(
      maxY: maxY,
      minY: title.contains('Pengeluaran') ? 50.0 : 0.0,
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Colors.black38, width: 1), 
          left: BorderSide(color: Colors.black38, width: 1), 
          top: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
        ),
      ),
      gridData: const FlGridData(show: false),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            interval: intervalY,
            getTitlesWidget: (value, meta) {
              if (value > maxY) return const SizedBox();
              String text;
              if (title.contains('Pemasukan')) {
                text = (value >= 1) ? '${value.toStringAsFixed(0)} jt' : '0';
              } else if (title.contains('Pengeluaran')) {
                text = value.toStringAsFixed(0);
              } else {
                text = value.toStringAsFixed(0);
              }
              return SideTitleWidget(
                axisSide: meta.axisSide,
                space: 4,
                child: Text(text, style: const TextStyle(fontSize: 10)),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              if (value.toInt() < keys.length) {
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(keys[value.toInt()], style: const TextStyle(fontSize: 10)),
                );
              }
              return const SizedBox();
            },
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      barGroups: List.generate(values.length, (i) {
        return BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: values[i],
              color: color,
              width: 22,
              borderRadius: BorderRadius.circular(6),
            ),
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final keys = data.keys.toList();
    final values = data.values.toList();

    return SizedBox(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white, 
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 250,
                child: BarChart(_getBarChartData(keys, values)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

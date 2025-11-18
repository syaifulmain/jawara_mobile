import 'package:flutter/material.dart';
import 'package:jawara_mobile/models/pie_chart_data_model.dart';

class KegiatanData {
  static List<Map<String, dynamic>> kegiatanPerKategori = [
    {
      'title': 'Kegiatan Per Kategori',
      'icon': Icons.folder,
      'data': [
        PieChartDataModel(
          'Komunitas & Sosial',
          5.0,
          Colors.green,
          'Komunitas & Sosial',
        ),
        PieChartDataModel(
          'Kebersihan & Keamanan',
          10.0,
          Colors.brown,
          'Kebersihan & Keamanan',
        ),
        PieChartDataModel('Keagamaan', 15.0, Colors.amberAccent, 'Keagamaan'),
        PieChartDataModel('Pendidikan', 20.0, Colors.cyanAccent, 'Pendidikan'),
        PieChartDataModel(
          'Kesehatan & Olahraga',
          25.0,
          Colors.orange,
          'Kesehatan & Olahraga',
        ),
        PieChartDataModel('Lainnya', 30.0, Colors.deepPurple, 'Lainnya'),
      ],
    },
  ];
  static final List<Map<String, dynamic>> numberStats = [
    {
      'title': 'Total Kegiatan',
      'value': '10',
      'icon': Icons.campaign,
      'color': Colors.blue.shade800,
      'backgroundColor': Colors.blue.shade100,
    },
  ];
}

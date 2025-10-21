import 'package:flutter/material.dart';

import '../models/pie_chart_data_model.dart';

final List<Map<String, dynamic>> dummyData = [
  {
    'title': 'Status Penduduk',
    'icon': Icons.people,
    'data': [
      PieChartDataModel('Aktif', 85.0, Colors.green, 'Aktif'),
      PieChartDataModel('Nonaktif', 15.0, Colors.brown, 'Nonaktif'),
    ],
  },
  {
    'title': 'Jenis Kelamin',
    'icon': Icons.accessibility_sharp,
    'data': [
      PieChartDataModel('Laki-laki', 55.0, Colors.blue, 'Laki-laki'),
      PieChartDataModel('Perempuan', 45.0, Colors.red, 'Perempuan'),
    ],
  },
  {
    'title': 'Pekerjaan Penduduk',
    'icon': Icons.business_center,
    'data': [
      PieChartDataModel('Petani', 40.0, Colors.purple, 'Petani'),
      PieChartDataModel('Pedagang', 25.0, Colors.redAccent, 'Pedagang'),
      PieChartDataModel('PNS/Swasta', 35.0, Colors.pink, 'PNS/Swasta'),
    ],
  },
  {
    'title': 'Peran Dalam Keluarga',
    'icon': Icons.family_restroom,
    'data': [
      PieChartDataModel(
        'Kepala Keluarga',
        75.0,
        Colors.blue,
        'Kepala Keluarga',
      ),
      PieChartDataModel('Anak', 10.0, Colors.redAccent, 'Anak'),
      PieChartDataModel('Anggota Lain', 15.0, Colors.pink, 'Anggota Lain'),
    ],
  },
  {
    'title': 'Agama',
    'icon': Icons.handshake,
    'data': [
      PieChartDataModel('Islam', 75.0, Colors.blue, 'Islam'),
      PieChartDataModel('Kristen', 25.0, Colors.redAccent, 'Kristen'),
    ],
  },
  {
    'title': 'Pendidikan',
    'icon': Icons.school,
    'data': [
      PieChartDataModel('SD', 25.0, Colors.blue, 'SD'),
      PieChartDataModel('SMP', 25.0, Colors.redAccent, 'SMP'),
      PieChartDataModel('SMA', 25.0, Colors.pink, 'SMA'),
      PieChartDataModel('S1', 25.0, Colors.green, 'S1'),
    ],
  },
];

final List<Map<String, dynamic>> mainStats = [
  {
    'title': 'Total Keluarga',
    'value': '10',
    'icon': Icons.family_restroom,
    'color': Colors.blue.shade800,
    'backgroundColor': Colors.blue.shade100,
  },
  {
    'title': 'Total Penduduk',
    'value': '13',
    'icon': Icons.people,
    'color': Colors.green.shade800,
    'backgroundColor': Colors.green.shade100,
  },
];

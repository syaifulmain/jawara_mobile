import 'package:flutter/material.dart';

class PopulationScreen extends StatelessWidget {
  const PopulationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Kependudukan'),
        elevation: 0,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _buildReportCard(context, Icons.people, 'Total Users', '125'),
          _buildReportCard(context, Icons.trending_up, 'Aktif Hari Ini', '45'),
          _buildReportCard(context, Icons.analytics, 'Transaksi', '89'),
          _buildReportCard(context, Icons.attach_money, 'Pendapatan', 'Rp 5.4M'),
        ],
      ),
    );
  }

  Widget _buildReportCard(BuildContext context, IconData icon, String title, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Theme.of(context).primaryColor),
            const SizedBox(height: 12),
            Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

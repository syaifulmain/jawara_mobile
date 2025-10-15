import 'package:flutter/material.dart';
import 'package:jawara_mobile/pages/templates/white_card_page.dart';

class Daftar extends StatelessWidget {
  final String title;
  final List<Map<String, String>> data;

  const Daftar({super.key, required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    return WhiteCardPage(
      title: title,
      children: [
        // Judul tabel
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // ElevatedButton.icon(
            //   onPressed: () {
            //     // Aksi untuk menambah data
            //   },
            //   icon: const Icon(Icons.filter_list_alt, color: Colors.white,),
            //   label: const Text('Filter'),
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Color(0xFF625AFF),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //   ),
            // ),
            ElevatedButton(
              onPressed: () {
                // Aksi untuk menambah data
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF625AFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Icon(Icons.filter_list_alt, color: Colors.white),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Tabel data
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(Color(0xFFE2E8F0)),
            columns: const [
              DataColumn(label: Text('No')),
              DataColumn(label: Text('Nama')),
              DataColumn(label: Text('Jenis Pengeluaran')),
              DataColumn(label: Text('Tanggal')),
              DataColumn(label: Text('Nominal')),
              DataColumn(label: Text('Aksi')),
            ],
            rows: data.asMap().entries.map((entry) {
              final i = entry.key + 1;
              final row = entry.value;
              return DataRow(
                cells: [
                  DataCell(Text('$i')),
                  DataCell(Text(row['nama'] ?? '-')),
                  DataCell(Text(row['jenis_pengeluaran'] ?? '-')),
                  DataCell(Text(row['tanggal'] ?? '-')),
                  DataCell(Text(row['nominal'] ?? '-')),
                  DataCell(Text(row['aksi'] ?? '-')),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

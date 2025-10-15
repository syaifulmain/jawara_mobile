import 'package:flutter/material.dart';

class Daftar extends StatelessWidget {
  final String title;
  final List<Map<String, String>> data;

  const Daftar({super.key, required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Color(0xFFF1F5F9),

      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          color: Color(0xFFFEFEFF),

          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // Judul tabel
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 24),
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
            ),
          ),
        ),
      ),
    );
  }
}

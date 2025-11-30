import 'package:flutter/material.dart';

class BroadcastListTable extends StatelessWidget {
  final List<Map<String, String>> data = const [
    {
      'no': '1',
      'pengirim': 'Admin Jawara',
      'judul': 'Pengumuman',
      'tanggal': '21 Oktober 2025',
    },
    {
      'no': '2',
      'pengirim': 'Admin Jawara',
      'judul': 'DJ BAWS',
      'tanggal': '17 Oktober 2025',
    },
    {
      'no': '3',
      'pengirim': 'Admin Jawara',
      'judul': 'gotong royong',
      'tanggal': '14 Oktober 2025',
    },
  ];

  const BroadcastListTable({super.key});

  @override
  Widget build(BuildContext context) {
    const Color purpleColor = Color(0xFF6C63FF); 

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Tombol Filter
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 16.0, bottom: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: purpleColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(12),
                  ),
                  child: const Icon(Icons.filter_list, color: Colors.white),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Colors.black12), 

          // Tabel Data
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double minTableWidth = constraints.maxWidth;
                  
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: minTableWidth),
                    child: DataTable(
                      headingRowColor: MaterialStateProperty.all(Colors.grey.shade100),
                      columnSpacing: 10, 
                      dataRowMaxHeight: 60,
                      dividerThickness: 1, 
                      
                      columns: const [
                        DataColumn(label: Text('NO', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54))),
                        DataColumn(label: Text('PENGIRIM', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54))),
                        DataColumn(label: Text('JUDUL', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54))),
                        DataColumn(label: Text('TANGGAL', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54))),
                        DataColumn(label: Text('AKSI', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54))),
                      ],
                      rows: data.map((item) {
                        return DataRow(cells: [
                          DataCell(Text(item['no']!)),
                          DataCell(Text(item['pengirim']!)),
                          DataCell(Text(item['judul']!)),
                          DataCell(Text(item['tanggal']!)),
                          DataCell(
                            const Text('---', style: TextStyle(color: Colors.grey)),
                          ),
                        ]);
                      }).toList(),
                    ),
                  ),
                );
              }
            ),
          ),

          // Pagination
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0), 
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(icon: const Icon(Icons.chevron_left), color: Colors.grey, onPressed: () {}),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(color: purpleColor, borderRadius: BorderRadius.circular(6)),
                  child: const Text('1', style: TextStyle(color: Colors.white, fontSize: 14)),
                ),
                IconButton(icon: const Icon(Icons.chevron_right), color: Colors.grey.shade800, onPressed: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
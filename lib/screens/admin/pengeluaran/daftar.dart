import 'package:flutter/material.dart';
import 'package:jawara_mobile/widgets/data_card.dart';
import 'package:jawara_mobile/widgets/white_card_page.dart';
import '../../../data/pengeluaran_data.dart';



class Daftar extends StatelessWidget {
  final String title = "Daftar Pengeluaran";
  final List<Map<String, String>> data;

  const Daftar({super.key, this.data=DummyData.pengeluaran});

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
        ListView(
          shrinkWrap: true,
          children: data.map((item) {
            return DataCard(itemName: item['nama'] ?? '', itemData: 
            [
              {
                'Jenis Pengeluaran': item['jenis_pengeluaran'] ?? '',
                'Tanggal': item['tanggal'] ?? '',
                'Nominal': item['nominal'] ?? '',
              }
            ]);
          }).toList(),
        )
      ],
    );
  }
}

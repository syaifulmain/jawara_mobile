import 'package:flutter/material.dart';
import 'package:jawara_mobile/widgets/data_card.dart';
import 'package:jawara_mobile/widgets/white_card_page.dart';
import '../../../data/laporan_keuangan_data.dart';

class SemuaPemasukan extends StatelessWidget {
  final String title = "Seluruh Pemasukan";
  final List<Map<String, String>> data;

  const SemuaPemasukan({super.key, this.data=DummyData.pemasukan});

  @override
  Widget build(BuildContext context) {
    return WhiteCardPage(
      // title: title,
      children: [
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


        // Tabel data
        ListView(
          shrinkWrap: true,
          children: data.map((item) {
            return DataCard(itemName: item['nama'] ?? '', itemData: 
            [
              {
                'Jenis Pemasukan': item['jenis_pemasukan'] ?? '',
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

import 'package:flutter/material.dart';
import 'package:jawara_mobile/widgets/data_card.dart';
import 'package:jawara_mobile/widgets/white_card_page.dart';
import 'package:jawara_mobile/data/pemasukan_data.dart';

class DaftarPemasukanScreen extends StatelessWidget {
  final String title = "Daftar Pemasukan";
  final List<Map<String, String>> data;

  DaftarPemasukanScreen({super.key, this.data = DummyData.pemasukan});

  @override
  Widget build(BuildContext context) {
    return WhiteCardPage(
      title: title,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF625AFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ],
        ),

        const SizedBox(height: 16),

        ListView(
          shrinkWrap: true,
          children: data.map((item) {
            return DataCard(
              itemName: item['nama'] ?? '',
              itemData: [
                {
                  'Jenis Pemasukan': item['jenis_pemasukan'] ?? '',
                  'Tanggal': item['tanggal'] ?? '',
                  'Nominal': item['nominal'] ?? '',
                },
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}

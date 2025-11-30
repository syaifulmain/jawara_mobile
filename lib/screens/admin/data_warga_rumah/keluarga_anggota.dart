import 'package:flutter/material.dart';
import 'package:jawara_mobile/data/warga_data.dart';

class KeluargaAnggotaPage extends StatelessWidget {
  final String noKK;
  const KeluargaAnggotaPage({super.key, required this.noKK});

  @override
  Widget build(BuildContext context) {
    // Ambil semua warga yang no_kk sama
    final anggota = DummyWarga.data
        .where((item) => item["no_kk"] == noKK)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Anggota Keluarga ($noKK)"),
      ),
      body: ListView.builder(
        itemCount: anggota.length,
        itemBuilder: (context, index) {
          final item = anggota[index];

          return Card(
            margin: const EdgeInsets.all(12),
            child: ListTile(
              title: Text(item["nama"]),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("NIK: ${item["nik"]}"),
                  Text("Status: ${item["status"]}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

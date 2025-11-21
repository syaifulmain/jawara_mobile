import 'package:flutter/material.dart';
import 'package:jawara_mobile/data/keluarga_data.dart';
import 'package:jawara_mobile/screens/admin/data_warga_rumah/keluarga_anggota.dart';

class KeluargaDaftarPage extends StatelessWidget {
  const KeluargaDaftarPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil data dari file dummy
    final keluargaList = DummyKeluarga.data;

    return Scaffold(
      appBar: AppBar(title: const Text("Data Keluarga")),
      // PERBAIKAN 1: ListView.builder diletakkan di dalam properti 'body'
      body: ListView.builder(
        // PERBAIKAN 2: Gunakan variabel 'keluargaList' yang sudah didefinisikan
        itemCount: keluargaList.length,
        itemBuilder: (context, index) {
          final item = keluargaList[index];

          // PENANGANAN NULL-SAFETY: Pastikan semua data diubah ke String dan diberi default value
          final kepalaKeluarga = item["kepala_keluarga"]?.toString() ?? "-";
          final noKK = item["no_kk"]?.toString() ?? "-";
          final alamat = item["alamat"]?.toString() ?? "-";
          // Pastikan RT dan RW adalah String sebelum digabungkan
          final rt = item["rt"]?.toString() ?? "-";
          final rw = item["rw"]?.toString() ?? "-";
          // Pastikan jumlah_anggota diubah ke String
          final jumlahAnggota = item["jumlah_anggota"]?.toString() ?? "0";

          return Card(
            margin: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
            child: ListTile(
              title: Text(kepalaKeluarga),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("No KK: $noKK"),
                  Text("Alamat: $alamat"),
                  Text("RT/RW: $rt/$rw"),
                  Text("Jumlah Anggota: $jumlahAnggota"),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => KeluargaAnggotaPage(noKK: noKK),
                        ),
                      );
                    },
                    child: const Text("Lihat Anggota"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

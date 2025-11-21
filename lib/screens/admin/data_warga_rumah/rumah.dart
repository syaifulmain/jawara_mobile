import 'package:flutter/material.dart';
import 'package:jawara_mobile/data/rumah_data.dart';

class RumahPage extends StatelessWidget {
  const RumahPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Rumah"),
      ),
      body: ListView.builder(
        itemCount: DummyRumah.data.length,
        itemBuilder: (context, index) {
          final rumah = DummyRumah.data[index];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            elevation: 2,
            child: ListTile(
              leading: CircleAvatar(
                child: Text(rumah["no_rumah"].toString()),
              ),
              title: Text(rumah["alamat"]),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("RT/RW: ${rumah["rt"]}/${rumah["rw"]}"),
                  Text("Status Rumah: ${rumah["status_rumah"]}"),
                  Text("Jumlah Penghuni: ${rumah["penghuni"]} orang"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

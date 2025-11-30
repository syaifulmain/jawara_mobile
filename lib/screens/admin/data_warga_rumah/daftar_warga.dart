import 'package:flutter/material.dart';
import 'package:jawara_mobile/widgets/white_card_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_mobile/constants/rem.dart';
import 'package:jawara_mobile/data/warga_data.dart';

class WargaDaftarScreen extends StatefulWidget {
  const WargaDaftarScreen({super.key});

  @override
  State<WargaDaftarScreen> createState() => _WargaDaftarScreenState();
}

class _WargaDaftarScreenState extends State<WargaDaftarScreen> {
  String title = "Daftar Warga";
  List<Map<String, dynamic>> warga = DummyWarga.data;
  List<Map<String, dynamic>> filtered = DummyWarga.data;

  final TextEditingController searchController = TextEditingController();

  void _search(String query) {
    setState(() {
      filtered = warga.where((item) {
        final name = item["nama"].toString().toLowerCase();
        final nik = item["nik"].toString().toLowerCase();
        final q = query.toLowerCase();
        return name.contains(q) || nik.contains(q);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WhiteCardPage(
      title: title,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: Rem.rem1_25,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),

        // Search Bar
        TextField(
          controller: searchController,
          onChanged: _search,
          decoration: InputDecoration(
            hintText: "Cari berdasarkan nama atau NIK...",
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // List Data Warga
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            var item = filtered[index];
            return _buildWargaCard(item);
          },
        )
      ],
    );
  }

  Widget _buildWargaCard(Map<String, dynamic> item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Foto
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person, size: 32, color: Colors.white),
            ),

            const SizedBox(width: 16),

            // Data warga
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item["nama"],
                    style: GoogleFonts.poppins(
                      fontSize: Rem.rem1,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text("NIK: ${item['nik']}"),
                  Text("KK : ${item['no_kk']}"),
                  Text("Alamat: RT ${item['rt']} / RW ${item['rw']}"),
                  Text("Status: ${item['status']}"),
                ],
              ),
            ),

            // Icon detail
            IconButton(
              icon: const Icon(Icons.chevron_right_rounded),
              onPressed: () {
                // nanti menuju detail warga
              },
            )
          ],
        ),
      ),
    );
  }
}
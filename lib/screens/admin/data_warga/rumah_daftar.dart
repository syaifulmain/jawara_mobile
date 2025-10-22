import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_mobile/constants/colors.dart';
import 'package:jawara_mobile/constants/rem.dart';
import '../../../widgets/white_card_page.dart';

class RumahDaftarScreen extends StatelessWidget {
  const RumahDaftarScreen({super.key});

  // Dummy data untuk tabel
  final List<Map<String, dynamic>> _rumahData = const [
    {'no': 1, 'alamat': 'Jl. Melati No. 12', 'status': 'Ditempati'},
    {'no': 2, 'alamat': 'Jl. Mawar No. 7', 'status': 'Tersedia'},
  ];

  @override
  Widget build(BuildContext context) {
    return WhiteCardPage(
      title: 'Daftar Rumah',
      children: [
        const SizedBox(height: Rem.rem1),
        // Tombol filter
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement filter
              },
              icon: const Icon(Icons.filter_list, size: 18),
              label: const Text('Filter'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: Rem.rem1,
                  vertical: Rem.rem0_75,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Rem.rem0_5),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: Rem.rem1),

        // Tabel
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: MaterialStateProperty.all(const Color(0xFFE2E8F0)),
            headingTextStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              fontSize: Rem.rem0_875,
            ),
            dataTextStyle: GoogleFonts.poppins(
              fontSize: Rem.rem0_875,
              color: Colors.black87,
            ),
            columnSpacing: Rem.rem2,
            columns: const [
              DataColumn(label: Text('NO')),
              DataColumn(label: Text('ALAMAT')),
              DataColumn(label: Text('STATUS')),
              DataColumn(label: Text('AKSI')),
            ],
            rows: _rumahData.map((data) {
              return DataRow(
                cells: [
                  DataCell(Text('${data['no']}')),
                  DataCell(Text(data['alamat'])),
                  // Status dengan bubble warna
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Rem.rem1,
                        vertical: Rem.rem0_25,
                      ),
                      decoration: BoxDecoration(
                        color: data['status'] == 'Ditempati'
                            ? Colors.blue[100]
                            : Colors.green[100],
                        borderRadius: BorderRadius.circular(Rem.rem1),
                      ),
                      child: Text(
                        data['status'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: data['status'] == 'Ditempati'
                              ? Colors.blue[800]
                              : Colors.green[800],
                          fontSize: Rem.rem0_875,
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, size: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Rem.rem0_5),
                      ),
                      onSelected: (value) {
                        if (value == 'edit') {
                          // TODO: Navigate to edit page
                        } else if (value == 'delete') {
                          // TODO: Show delete confirmation
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              const Icon(
                                Icons.edit,
                                size: 18,
                                color: Colors.black87,
                              ),
                              const SizedBox(width: Rem.rem0_5),
                              Text('Edit', style: GoogleFonts.poppins()),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              const Icon(
                                Icons.delete,
                                size: 18,
                                color: Colors.red,
                              ),
                              const SizedBox(width: Rem.rem0_5),
                              Text(
                                'Hapus',
                                style: GoogleFonts.poppins(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),

        // Pagination / navigasi
        const SizedBox(height: Rem.rem1),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.chevron_left),
              style: IconButton.styleFrom(backgroundColor: Colors.grey[200]),
            ),
            const SizedBox(width: Rem.rem0_5),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Rem.rem1,
                vertical: Rem.rem0_5,
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(Rem.rem0_5),
              ),
              child: Text(
                '1',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: Rem.rem0_5),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.chevron_right),
              style: IconButton.styleFrom(backgroundColor: Colors.grey[200]),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_mobile/constants/colors.dart';
import 'package:jawara_mobile/constants/rem.dart';
import '../../../widgets/white_card_page.dart';

class KeluargaScreen extends StatelessWidget {
  const KeluargaScreen({super.key});

  // Dummy data untuk tabel
  final List<Map<String, dynamic>> _keluargaData = const [
    {
      'no': 1,
      'nama_keluarga': 'Keluarga Santoso',
      'kepala_keluarga': 'Budi Santoso',
      'alamat_rumah': 'Jl. Melati No. 12',
      'status_kepemilikan': 'Milik Sendiri',
      'status': 'Aktif',
    },
    {
      'no': 2,
      'nama_keluarga': 'Keluarga Wijaya',
      'kepala_keluarga': 'Siti Wijaya',
      'alamat_rumah': 'Jl. Mawar No. 7',
      'status_kepemilikan': 'Sewa',
      'status': 'Nonaktif',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return WhiteCardPage(
      title: 'Daftar Keluarga',
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
              DataColumn(label: Text('NAMA KELUARGA')),
              DataColumn(label: Text('KEPALA KELUARGA')),
              DataColumn(label: Text('ALAMAT RUMAH')),
              DataColumn(label: Text('STATUS KEPEMILIKAN')),
              DataColumn(label: Text('STATUS')),
              DataColumn(label: Text('AKSI')),
            ],
            rows: _keluargaData.map((data) {
              return DataRow(
                cells: [
                  DataCell(Text('${data['no']}')),
                  DataCell(Text(data['nama_keluarga'])),
                  DataCell(Text(data['kepala_keluarga'])),
                  DataCell(Text(data['alamat_rumah'])),
                  DataCell(Text(data['status_kepemilikan'])),
                  // Status dengan warna
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Rem.rem1,
                        vertical: Rem.rem0_25,
                      ),
                      decoration: BoxDecoration(
                        color: data['status'] == 'Aktif'
                            ? Colors.green[100]
                            : Colors.red[100],
                        borderRadius: BorderRadius.circular(Rem.rem1),
                      ),
                      child: Text(
                        data['status'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: data['status'] == 'Aktif'
                              ? Colors.green[800]
                              : Colors.red[800],
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

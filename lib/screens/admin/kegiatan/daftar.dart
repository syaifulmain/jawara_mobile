import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_mobile/constants/colors.dart';
import 'package:jawara_mobile/constants/rem.dart';

class KegiatanDaftarScreen extends StatelessWidget {
  const KegiatanDaftarScreen({super.key});

  // Dummy data for the table
  final List<Map<String, dynamic>> _kegiatanData = const [
    {
      'no': 1,
      'nama_kegiatan': 'Musyawarah Warga Bulanan',
      'kategori': 'Komunitas & Sosial',
      'penanggung_jawab': 'Kepala Dusun',
      'tanggal_pelaksanaan': '12 Oktober 2025',
    },
    {
      'no': 2,
      'nama_kegiatan': 'Gotong Royong Perbaikan Jalan',
      'kategori': 'Infrastruktur',
      'penanggung_jawab': 'Ketua RW 01',
      'tanggal_pelaksanaan': '19 Oktober 2025',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: AppColors.backgroundColor,
        child: Card(
          elevation: 2,
          margin: const EdgeInsets.all(Rem.rem1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Rem.rem0_75),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(Rem.rem1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with filter button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ' ',
                      style: GoogleFonts.poppins(
                        fontSize: Rem.rem1_25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
                const SizedBox(height: Rem.rem1_5),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(
                      const Color(0xFFE2E8F0),
                    ),
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
                      DataColumn(label: Text('NAMA KEGIATAN')),
                      DataColumn(label: Text('KATEGORI')),
                      DataColumn(label: Text('PENANGGUNG JAWAB')),
                      DataColumn(label: Text('TANGGAL PELAKSANAAN')),
                      DataColumn(label: Text('AKSI')),
                    ],
                    rows: _kegiatanData.map((data) {
                      return DataRow(
                        cells: [
                          DataCell(Text('${data['no']}')),
                          DataCell(Text(data['nama_kegiatan'])),
                          DataCell(Text(data['kategori'])),
                          DataCell(Text(data['penanggung_jawab'])),
                          DataCell(Text(data['tanggal_pelaksanaan'])),
                          DataCell(
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert, size: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(Rem.rem0_5),
                              ),
                              onSelected: (value) {
                                // TODO: Implement actions
                                if (value == 'edit') {
                                  // Navigate to edit page
                                } else if (value == 'delete') {
                                  // Show delete confirmation
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
                                        style: GoogleFonts.poppins(
                                          color: Colors.red,
                                        ),
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

                // Pagination
                const SizedBox(height: Rem.rem1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        // TODO: Previous page
                      },
                      icon: const Icon(Icons.chevron_left),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                      ),
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
                      onPressed: () {
                        // TODO: Next page
                      },
                      icon: const Icon(Icons.chevron_right),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

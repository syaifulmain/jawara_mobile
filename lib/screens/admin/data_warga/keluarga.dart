import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_mobile/constants/colors.dart';
import 'package:jawara_mobile/constants/rem.dart';
import 'package:jawara_mobile/screens/admin/data_warga/detail_keluarga.dart';
import '../../../widgets/white_card_page.dart';

class KeluargaScreen extends StatelessWidget {
  const KeluargaScreen({super.key});

  // Dummy data daftar keluarga
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

        // --- Gaya Kartu untuk Daftar Keluarga ---
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _keluargaData.length,
          itemBuilder: (context, index) {
            final data = _keluargaData[index];
            return _KeluargaCard(data: data);
          },
        ),

        // Pagination
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

// --- Komponen Kartu Keluarga ---
class _KeluargaCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _KeluargaCard({required this.data});

  Widget _buildStatusBadge(String status) {
    final isAktif = status == 'Aktif';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (isAktif ? Colors.green : Colors.red).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: GoogleFonts.poppins(
          color: isAktif ? Colors.green[800] : Colors.red[800],
          fontWeight: FontWeight.w600,
          fontSize: Rem.rem0_75,
        ),
      ),
    );
  }

  void _showActionMenu(BuildContext context, RenderBox button) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(
          button.size.topRight(Offset.zero),
          ancestor: overlay,
        ),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    showMenu<String>(
      context: context,
      position: position,
      items: const [
        PopupMenuItem<String>(value: 'detail', child: Text('Detail')),
      ],
    ).then((value) {
      if (value == 'detail') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DetailKeluargaScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.backgroundColor,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Nama Keluarga dan menu aksi
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data['nama_keluarga'],
                  style: GoogleFonts.poppins(
                    fontSize: Rem.rem1,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                Builder(
                  builder: (buttonContext) {
                    return IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {
                        final button =
                            buttonContext.findRenderObject() as RenderBox;
                        _showActionMenu(buttonContext, button);
                      },
                    );
                  },
                ),
              ],
            ),
            const Divider(height: 16),

            // Kepala keluarga
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Kepala: ${data['kepala_keluarga']}',
                    style: GoogleFonts.poppins(fontSize: Rem.rem0_875),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Alamat rumah
            Row(
              children: [
                const Icon(Icons.home, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    data['alamat_rumah'],
                    style: GoogleFonts.poppins(fontSize: Rem.rem0_875),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Status kepemilikan
            Row(
              children: [
                const Icon(Icons.house_siding, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Kepemilikan: ${data['status_kepemilikan']}',
                    style: GoogleFonts.poppins(fontSize: Rem.rem0_875),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Status aktif/nonaktif
            _buildStatusBadge(data['status']),
          ],
        ),
      ),
    );
  }
}

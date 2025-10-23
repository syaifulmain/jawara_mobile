import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_mobile/constants/colors.dart';
import 'package:jawara_mobile/constants/rem.dart';
import 'package:jawara_mobile/screens/admin/data_warga/detail_keluarga.dart';

class KeluargaScreen extends StatelessWidget {
  const KeluargaScreen({super.key});

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(Rem.rem1),
        children: [
          const SizedBox(height: Rem.rem1),

          // Tombol filter
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
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

          // Kartu keluarga full-width
          ..._keluargaData.map((data) => _KeluargaCard(data: data)).toList(),

          const SizedBox(height: Rem.rem1),

          // Pagination
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
      ),
    );
  }
}

// --- Komponen Kartu Keluarga Full-Width ---
class _KeluargaCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _KeluargaCard({required this.data});

  Widget _buildStatusBadge(String status) {
    final isAktif = status == 'Aktif';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (isAktif ? Colors.green : Colors.red).withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: GoogleFonts.figtree(
          color: isAktif ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: Rem.rem0_75,
        ),
      ),
    );
  }

  void _showActionMenu(BuildContext context, RenderBox icon) {
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        icon.localToGlobal(Offset.zero, ancestor: overlay),
        icon.localToGlobal(
          Offset(icon.size.width, icon.size.height),
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
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Nama Keluarga dan ikon aksi
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  data['nama_keluarga'],
                  style: GoogleFonts.figtree(
                    fontSize: Rem.rem1,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Builder(
                builder: (iconContext) {
                  return IconButton(
                    icon: const Icon(Icons.remove_red_eye_outlined),
                    onPressed: () {
                      final renderBox =
                          iconContext.findRenderObject() as RenderBox;
                      _showActionMenu(iconContext, renderBox);
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
                  style: GoogleFonts.figtree(fontSize: 13),
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
                  style: GoogleFonts.figtree(fontSize: 13),
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
                  style: GoogleFonts.figtree(fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Status aktif/nonaktif
          _buildStatusBadge(data['status']),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_mobile/constants/rem.dart';

import '../../../constants/colors.dart';
import '../../../data/data_warga_data.dart';
import '../../../models/data_warga_model.dart';

class WargaDaftarScreen extends StatelessWidget {
  const WargaDaftarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: Rem.rem1),
        itemCount: DummyDataWarga.length,
        itemBuilder: (context, index) {
          final data = DummyDataWarga[index];
          return DataCard(data: data);
        },
      ),
    );
  }
}

class DataCard extends StatelessWidget {
  final DataWargaModel data;
  const DataCard({super.key, required this.data});

  Widget _buildStatusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: GoogleFonts.figtree(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: Rem.rem0_75,
        ),
      ),
    );
  }

  void _showActionMenu(BuildContext context, DataWargaModel data) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: null),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: null,
        ),
      ),
      Offset.zero & MediaQuery.of(context).size,
    );

    showMenu<String>(
      context: context,
      position: position,
      items: <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'detail',
          child: const Text('Detail'),
          onTap: () {
            context.pushNamed('warga-detail', extra: data);
          },
        ),
        const PopupMenuItem<String>(value: 'edit', child: Text('Edit')),
        const PopupMenuItem<String>(value: 'hapus', child: Text('Hapus')),
      ],
      elevation: 8.0,
    ).then((value) {
      if (value != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Aksi ${value.toUpperCase()} dipilih untuk ${data.nama}',
            ),
          ),
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
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.nama,
                        style: GoogleFonts.figtree(
                          fontSize: Rem.rem1,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Builder(
                  builder: (context) {
                    return IconButton(
                      icon: const Icon(Icons.remove_red_eye_outlined),
                      onPressed: () =>
                          context.pushNamed('warga-detail', extra: data),
                    );
                  },
                ),
              ],
            ),
            const Divider(height: 16),

            _buildDataRow(Icons.credit_card, 'NIK', data.nik),
            _buildDataRow(Icons.people_alt, 'Keluarga', data.keluargaTitle),

            const SizedBox(height: 10),

            //Jenis Kelamin, Status Domisili, Status Hidup ---
            Row(
              children: <Widget>[
                Icon(
                  data.jenisKelamin == 'P' ? Icons.female : Icons.male,
                  size: 16,
                  color: Colors.blue,
                ),
                const SizedBox(width: 4),
                Text(
                  data.jenisKelamin == 'P' ? 'Perempuan' : 'Laki-laki',
                  style: GoogleFonts.figtree(fontSize: 13),
                ),
                const Spacer(),
                // Status Domisili (Aktif)
                _buildStatusBadge(
                  data.statusDomisili == 'Aktif' ? 'Aktif' : 'Tidak Aktif',
                  Colors.green,
                ),
                const SizedBox(width: 8),
                // Status Hidup (Hidup/Wafat)
                _buildStatusBadge(
                  data.statusHidup,
                  data.statusHidup == 'Hidup' ? Colors.green : Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '$label:',
            style: GoogleFonts.figtree(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.figtree(fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

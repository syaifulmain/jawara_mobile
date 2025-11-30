import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_mobile/constants/colors.dart';
import 'package:jawara_mobile/constants/rem.dart';
import 'package:jawara_mobile/models/data_tagihan_model.dart';
import 'package:jawara_mobile/widgets/custom_button.dart';
import 'package:jawara_mobile/widgets/custom_text_field.dart';

class TagihanDetailScreen extends StatefulWidget {
  final DataTagihanModel data;

  const TagihanDetailScreen({super.key, required this.data});

  @override
  State<TagihanDetailScreen> createState() => _TagihanDetailScreenState();
}

class _TagihanDetailScreenState extends State<TagihanDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _buktiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _buktiController.text = widget.data.buktiPembayaran.isEmpty 
        ? 'Tulis alasan penolakan...' 
        : widget.data.buktiPembayaran;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _buktiController.dispose();
    super.dispose();
  }

  void _setujuiPembayaran() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pembayaran telah disetujui'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.of(context).pop();
  }

  void _tolakPembayaran() {
    if (_buktiController.text.trim().isEmpty || 
        _buktiController.text == 'Tulis alasan penolakan...') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon masukkan alasan penolakan'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pembayaran telah ditolak'),
        backgroundColor: Colors.red,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColor,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
          color: AppColors.primaryColor,
        ),
        elevation: 0,
        title: Text(
          'Verifikasi Pembayaran Iuran',
          style: GoogleFonts.figtree(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primaryColor,
          tabs: const [
            Tab(text: 'Detail'),
            Tab(text: 'Riwayat Pembayaran'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDetailTab(),
          _buildRiwayatTab(),
        ],
      ),
    );
  }

  Widget _buildDetailTab() {
    return Padding(
      padding: const EdgeInsets.all(Rem.rem1_5),
      child: SingleChildScrollView(
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(Rem.rem1_5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header informasi
                Container(
                  padding: const EdgeInsets.all(Rem.rem1),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(Rem.rem0_5),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.receipt_long,
                        color: AppColors.primaryColor,
                        size: 24,
                      ),
                      const SizedBox(width: Rem.rem0_75),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Kode Iuran',
                              style: GoogleFonts.figtree(
                                fontSize: Rem.rem0_875,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              widget.data.kodeTagihan,
                              style: GoogleFonts.figtree(
                              fontSize: Rem.rem1_25,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: Rem.rem1_5),

                // Detail informasi tagihan
                _buildDetailSection('Informasi Iuran', [
                  _buildDetailRow('Nama Iuran', widget.data.namaIuran),
                  _buildDetailRow('Kategori', widget.data.jenisIuran),
                  _buildDetailRow('Periode', widget.data.periode),
                  _buildDetailRow('Nominal', widget.data.nominal),
                ]),

                const SizedBox(height: Rem.rem1_5),

                _buildDetailSection('Informasi Keluarga', [
                  _buildDetailRow('Nama KK', widget.data.namaKeluarga),
                  _buildDetailRow('Status', widget.data.statusKeluarga),
                  _buildDetailRow('Alamat', widget.data.alamat),
                ]),

                const SizedBox(height: Rem.rem1_5),

                _buildDetailSection('Informasi Pembayaran', [
                  _buildDetailRow('Status', widget.data.status, 
                      statusColor: _getStatusColor(widget.data.status)),
                  _buildDetailRow('Metode Pembayaran', widget.data.metodePembayaran),
                ]),

                const SizedBox(height: Rem.rem1_5),

                // Bukti pembayaran / alasan
                Text(
                  'Bukti',
                  style: GoogleFonts.figtree(
                    fontSize: Rem.rem1_25,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: Rem.rem0_75),
                
                CustomTextField(
                  controller: _buktiController,
                  labelText: 'Catatan/Bukti',
                  hintText: 'Tulis alasan penolakan atau catatan verifikasi...',
                  keyboardType: TextInputType.multiline,
                  minLines: 4,
                  maxLines: 6,
                ),

                const SizedBox(height: Rem.rem2),

                // Action buttons
                if (widget.data.status == 'Belum Dibayar' || 
                    widget.data.status == 'Terlambat') ...[
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          onPressed: _setujuiPembayaran,
                          backgroundColor: Colors.green,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.check_circle, color: Colors.white, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'Setujui',
                                style: GoogleFonts.figtree(
                                  fontSize: Rem.rem1,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: Rem.rem1),
                      Expanded(
                        child: CustomButton(
                          onPressed: _tolakPembayaran,
                          backgroundColor: Colors.red,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.cancel, color: Colors.white, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'Tolak',
                                style: GoogleFonts.figtree(
                                  fontSize: Rem.rem1,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.all(Rem.rem1),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      border: Border.all(color: Colors.green.shade200),
                      borderRadius: BorderRadius.circular(Rem.rem0_5),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green.shade600, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Pembayaran telah lunas',
                          style: GoogleFonts.figtree(
                            fontWeight: FontWeight.w600,
                            color: Colors.green.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRiwayatTab() {
    return Padding(
      padding: const EdgeInsets.all(Rem.rem1_5),
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(Rem.rem1_5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Riwayat Pembayaran',
                style: GoogleFonts.figtree(
                  fontSize: Rem.rem1_25,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: Rem.rem1),
              
              // Contoh riwayat
              _buildRiwayatItem(
                tanggal: '25 November 2025',
                aksi: 'Tagihan dibuat',
                status: 'Sistem',
                color: Colors.blue,
              ),
              
              if (widget.data.status != 'Belum Dibayar') ...[
                _buildRiwayatItem(
                  tanggal: '26 November 2025',
                  aksi: 'Pembayaran diterima',
                  status: 'User',
                  color: Colors.orange,
                ),
                
                if (widget.data.status == 'Lunas') ...[
                  _buildRiwayatItem(
                    tanggal: '27 November 2025',
                    aksi: 'Pembayaran diverifikasi',
                    status: 'Admin',
                    color: Colors.green,
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.figtree(
            fontSize: Rem.rem1_25,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryColor,
          ),
        ),
        const SizedBox(height: Rem.rem0_75),
        Container(
          padding: const EdgeInsets.all(Rem.rem1),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(Rem.rem0_5),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? statusColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: GoogleFonts.figtree(
                fontSize: Rem.rem0_875,
                color: Colors.grey[600],
              ),
            ),
          ),
          const Text(' : '),
          Expanded(
            child: statusColor != null
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      value,
                      style: GoogleFonts.figtree(
                        fontSize: Rem.rem0_875,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  )
                : Text(
                    value,
                    style: GoogleFonts.figtree(
                      fontSize: Rem.rem0_875,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiwayatItem({
    required String tanggal,
    required String aksi,
    required String status,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(Rem.rem0_75),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(Rem.rem0_5),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: Rem.rem0_75),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  aksi,
                  style: GoogleFonts.figtree(
                    fontWeight: FontWeight.w600,
                    fontSize: Rem.rem0_875,
                  ),
                ),
                Text(
                  '$tanggal • $status',
                  style: GoogleFonts.figtree(
                    fontSize: Rem.rem0_75,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'lunas':
        return Colors.green;
      case 'belum dibayar':
        return Colors.orange;
      case 'terlambat':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
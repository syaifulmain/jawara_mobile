import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../constants/color_constant.dart';
import '../../../../constants/rem_constant.dart';
import '../../../../models/pengeluaran/pengeluaran_detail_model.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/pengeluaran_provider.dart';
import 'package:intl/intl.dart';

class ExpenditureDetailScreen extends StatefulWidget {
  final String id;

  const ExpenditureDetailScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<ExpenditureDetailScreen> createState() =>
      _ExpenditureDetailScreenState();
}

class _ExpenditureDetailScreenState extends State<ExpenditureDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDetail();
    });
  }

  void _loadDetail() {
    final authProvider = context.read<AuthProvider>();
    final expProvider = context.read<PengeluaranProvider>();

    if (authProvider.token != null) {
      expProvider.fetchPengeluaranDetail(authProvider.token!, widget.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
        title: Text(
          'Detail Pengeluaran',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<PengeluaranProvider>(
        builder: (context, expProvider, child) {
          if (expProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (expProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${expProvider.errorMessage}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadDetail,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          final exp = expProvider.selectedPengeluaran;
          if (exp == null) {
            return const Center(
              child: Text('Data pengeluaran tidak ditemukan'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(Rem.rem1_5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_buildInfoCard(exp)],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(PengeluaranDetailModel exp) {
    final tanggalTransaksi = DateFormat(
      'dd MMMM yyyy',
      'id',
    ).format(DateTime.parse(exp.tanggal));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Rem.rem1_5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Rem.rem0_75),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informasi Pengeluaran',
            style: GoogleFonts.poppins(
              fontSize: Rem.rem1_25,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: Rem.rem1),
          _buildInfoRow('Nama Pengeluaran', exp.namaPengeluaran),
          const SizedBox(height: Rem.rem1),
          _buildInfoRow('Kategori', exp.kategori),
          const SizedBox(height: Rem.rem1),
          _buildInfoRow('Tanggal Transaksi', tanggalTransaksi),
          const SizedBox(height: Rem.rem1),
          _buildInfoRow(
            'Nominal',
            NumberFormat.currency(
              locale: 'id',
              symbol: 'Rp ',
              decimalDigits: 0,
            ).format(exp.nominal),
          ),
          const SizedBox(height: Rem.rem1),
          _buildInfoRow('Tanggal Terverifikasi', tanggalTransaksi),
          const SizedBox(height: Rem.rem1),
          _buildInfoRow('Verifikator', exp.verifikator),
          // ------------------ Tampilkan bukti jika ada ------------------
          if (exp.buktiPengeluaran != null && exp.buktiPengeluaran!.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: Rem.rem1),
                Text(
                  'Bukti Pengeluaran',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: Rem.rem1,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: Rem.rem0_75),
                ClipRRect(
                  borderRadius: BorderRadius.circular(Rem.rem0_5),
                  child: Image.network(
                    exp.buktiPengeluaran!,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.grey.shade600,
            fontSize: Rem.rem0_875,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: Rem.rem1,
          ),
        ),
      ],
    );
  }
}

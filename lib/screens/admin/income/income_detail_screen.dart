import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../constants/color_constant.dart';
import '../../../constants/rem_constant.dart';
import '../../../providers/income_provider.dart';
import '../../../models/income/income_list_model.dart';

class IncomeDetailScreen extends StatefulWidget {
  final String id;

  const IncomeDetailScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<IncomeDetailScreen> createState() => _IncomeDetailScreenState();
}

class _IncomeDetailScreenState extends State<IncomeDetailScreen> {
  IncomeListModel? _income;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_income == null) _loadData();
  }

  void _loadData() {
    final provider = context.read<IncomeProvider>();
    try {
      _income =
          provider.incomes.firstWhere((e) => e.id.toString() == widget.id);
    } catch (e) {
      _income = null;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final income = _income;

    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
        title: Text(
          "Detail Pemasukan",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: income == null
          ? const Center(child: Text("Data tidak ditemukan"))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(Rem.rem1_5),
              child: _buildDetailCard(income), // Menggunakan fungsi baru
            ),
    );
  }

  // --------------------------------------------------------
  // ✅ Tampilan kartu dengan format detail seperti form/list item
  // --------------------------------------------------------
  Widget _buildDetailCard(IncomeListModel data) {
    final dateFormat = DateFormat('dd MMMM yyyy');

    // Format mata uang untuk Jumlah
    final amountFormatter = NumberFormat.currency(
      locale: "id_ID",
      symbol: "Rp ",
      decimalDigits: 0,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Rem.rem1_5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Rem.rem1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Informasi Pemasukan",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: Rem.rem1_25,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: Rem.rem1),

          _detailItem(
              label: "Nama Pemasukan", value: data.name),
          _detailItem(
              label: "Tipe Pemasukan", value: data.incomeType),
          _detailItem(
            label: "Tanggal Pemasukan",
            value: data.date.isNotEmpty
                ? dateFormat.format(DateTime.parse(data.date))
                : "-",
          ),
          _detailItem(
            label: "Jumlah",
            value: amountFormatter.format(data.amount),
            // Opsional: berikan gaya khusus untuk jumlah
            valueStyle: GoogleFonts.poppins(
              fontSize: Rem.rem1,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryColor,
            ),
          ),

          if (data.verification != null)
            _detailItem(
                label: "Status Verifikasi", value: data.verification.toString()),

          if (data.dateVerification != null)
            _detailItem(
                label: "Tanggal Verifikasi", value: data.dateVerification ?? "-"),
        ],
      ),
    );
  }

  // --------------------------------------------------------
  // ITEM DETAIL (Pengganti ROW TABEL)
  // --------------------------------------------------------
  Widget _detailItem({
    required String label,
    required String value,
    TextStyle? valueStyle,
  }) {
    // Memberikan padding bawah agar tidak terlalu rapat
    return Padding(
      padding: const EdgeInsets.only(bottom: Rem.rem1), 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: Rem.rem0_875,
              color: Colors.grey.shade600, // Label lebih redup
            ),
          ),
          const SizedBox(height: Rem.rem0_25),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: Rem.rem0_75, horizontal: Rem.rem1),
            decoration: BoxDecoration(
              color: AppColors.secondaryColor.withOpacity(0.5), // Warna latar belakang seperti input field
              borderRadius: BorderRadius.circular(Rem.rem0_5),
              border: Border.all(color: Colors.grey.shade300, width: 1),
            ),
            child: Text(
              value,
              style: valueStyle ?? GoogleFonts.poppins(
                fontSize: Rem.rem1,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi _divider dihilangkan karena tampilan form/list item umumnya tidak menggunakan pembatas di antara setiap item.
}
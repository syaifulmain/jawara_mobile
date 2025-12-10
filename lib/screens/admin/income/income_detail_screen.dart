import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../constants/color_constant.dart';
import '../../../constants/rem_constant.dart';
import '../../../providers/income_provider.dart';
import '../../../models/income/income_list_model.dart'; // Asumsi model ini memiliki field yang digunakan

class IncomeDetailScreen extends StatefulWidget {
  final String id;

  const IncomeDetailScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<IncomeDetailScreen> createState() => _IncomeDetailScreenState();
}

class _IncomeDetailScreenState extends State<IncomeDetailScreen> {
  // Menggunakan Future untuk meniru fetching API (untuk konsistensi UI pattern)
  late Future<IncomeListModel> _incomeDetailFuture;

  @override
  void initState() {
    super.initState();
    // Inisialisasi future di initState
    _incomeDetailFuture = _loadData();
  }

  // Fungsi yang memuat data secara lokal (mirip fetching)
  Future<IncomeListModel> _loadData() async {
    // Menunggu sebentar untuk meniru waktu loading jaringan
    await Future.delayed(const Duration(milliseconds: 100)); 
    
    final provider = context.read<IncomeProvider>();
    try {
      // Mencari data di list provider yang sudah ada
      final income = provider.incomes.firstWhere(
          (e) => e.id.toString() == widget.id,
          // Jika tidak ditemukan, throw error
          orElse: () => throw Exception("Data Pemasukan tidak ditemukan untuk ID: ${widget.id}"),
      );
      return income;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // HELPER: Field Hanya-Baca seperti Form Field
  Widget _buildReadOnlyField({
    required String label,
    required String value,
    IconData? icon,
    int maxLines = 1,
    Color? customValueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Rem.rem1),
      child: TextFormField(
        initialValue: value,
        readOnly: true, // PENTING: Membuat field hanya-baca
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null ? Icon(icon, color: AppColors.primaryColor) : null,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(
            vertical: maxLines > 1 ? Rem.rem1 : Rem.rem0_75,
            horizontal: Rem.rem1,
          ),
        ),
        style: GoogleFonts.poppins(
          fontSize: Rem.rem1,
          fontWeight: maxLines > 1 ? FontWeight.normal : FontWeight.w600,
          color: customValueColor ?? Colors.black87,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder<IncomeListModel>(
        future: _incomeDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(Rem.rem2),
                child: Text(
                  'Gagal memuat detail:\n${snapshot.error.toString()}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(color: Colors.red),
                ),
              ),
            );
          }

          if (snapshot.hasData) {
            final data = snapshot.data!;
            final dateFormat = DateFormat('dd MMMM yyyy, HH:mm');
            
            final amountFormatter = NumberFormat.currency(
              locale: "id_ID",
              symbol: "Rp ",
              decimalDigits: 0,
            );
            
            // Mengubah status verifikasi menjadi badge/warna jika diperlukan
            // Untuk saat ini, kita hanya mendapatkan warnanya
            Color verificationColor = Colors.grey;
            if (data.verification?.toLowerCase() == 'approved') {
                verificationColor = Colors.green;
            } else if (data.verification?.toLowerCase() == 'pending') {
                verificationColor = Colors.orange;
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(Rem.rem1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Judul Section ---
                  Padding(
                    padding: const EdgeInsets.only(bottom: Rem.rem1),
                    child: Text(
                      "Informasi Pemasukan",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: Rem.rem1_25,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),

                  // --- FIELD UTAMA ---
                  _buildReadOnlyField(
                    label: "Nama Pemasukan",
                    value: data.name ?? "-",
                    icon: Icons.label_important_outline,
                  ),
                  _buildReadOnlyField(
                    label: "Tipe Pemasukan",
                    value: data.incomeType ?? "-",
                    icon: Icons.category_outlined,
                  ),
                  
                  // --- JUMLAH (Diberi warna khusus) ---
                  _buildReadOnlyField(
                    label: "Jumlah",
                    value: amountFormatter.format(data.amount ?? 0),
                    icon: Icons.payments,
                    customValueColor: AppColors.primaryColor,
                  ),

                  _buildReadOnlyField(
                    label: "Tanggal Pemasukan",
                    value: data.date != null && data.date!.isNotEmpty
                        ? dateFormat.format(DateTime.parse(data.date!))
                        : "-",
                    icon: Icons.calendar_today,
                  ),

                  // --- VERIFIKASI ---
                  _buildReadOnlyField(
                    label: "Status Verifikasi",
                    value: data.verification ?? "Belum terverifikasi",
                    icon: Icons.check_circle_outline,
                    customValueColor: verificationColor,
                  ),
                  
                  if (data.dateVerification != null)
                    _buildReadOnlyField(
                      label: "Tanggal Verifikasi",
                      value: data.dateVerification ?? "-",
                      icon: Icons.access_time_filled_outlined,
                    ),

                  const SizedBox(height: Rem.rem1),
                ],
              ),
            );
          }
          
          return const Center(child: Text("Data tidak ditemukan"));
        },
      ),
    );
  }
}
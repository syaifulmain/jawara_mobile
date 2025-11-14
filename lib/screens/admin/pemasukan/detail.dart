import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_mobile/constants/colors.dart';
import 'package:jawara_mobile/constants/rem.dart';
import 'package:jawara_mobile/widgets/custom_button.dart';
import 'package:jawara_mobile/widgets/custom_dropdown.dart';
import 'package:jawara_mobile/widgets/custom_text_field.dart';

import '../../../models/data_pemasukan_model.dart';
import '../../../widgets/custom_select_calender.dart';

// Converted to a StatefulWidget to manage form state with TextEditingControllers.
class PemasukanDetailScreen extends StatefulWidget {
  final DataPemasukanModel dataPemasukan;

  const PemasukanDetailScreen({super.key, required this.dataPemasukan});

  @override
  State<PemasukanDetailScreen> createState() => _PemasukanDetailScreenState();
}

class _PemasukanDetailScreenState extends State<PemasukanDetailScreen> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    // _selectedDate = DateFormat(
    //   "dd-MM-yyyy",
    // ).parse(widget.dataPemasukan.tanggalLahir);
  }

  void _submitForm() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data Pemasukan berhasil Diperbarui!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _deleteData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data Pemasukan berhasil Dihapus!'),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      body: Padding(
        padding: const EdgeInsets.all(Rem.rem1_5),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(Rem.rem1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // The family dropdown is pre-filled using initialSelection.
                    Text(
                      'Detail Pemasukan',
                      style: GoogleFonts.poppins(
                        fontSize: Rem.rem1_5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: Rem.rem1_25),
                    Text(
                      'Nama Pemasukan',
                      style: GoogleFonts.poppins(fontSize: Rem.rem0_75),
                    ),
                    Text(
                      widget.dataPemasukan.nama,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: Rem.rem0_875),
                    ),
                    const SizedBox(height: Rem.rem1),
                    Text(
                      'Jenis Pemasukan',
                      style: GoogleFonts.poppins(fontSize: Rem.rem0_75),
                    ),
                    Text(
                      widget.dataPemasukan.jenisPemasukan,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: Rem.rem0_875),
                    ),
                    const SizedBox(height: Rem.rem1),
                    Text(
                      'Jumlah',
                      style: GoogleFonts.poppins(fontSize: Rem.rem0_75),
                    ),
                    Text(
                      widget.dataPemasukan.nominal,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: Rem.rem0_875),
                    ),
                    const SizedBox(height: Rem.rem1),
                    Text(
                      'Tanggal Transaksi',
                      style: GoogleFonts.poppins(fontSize: Rem.rem0_75),
                    ),
                    Text(
                      widget.dataPemasukan.tanggal,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: Rem.rem0_875),
                    ),
                    const SizedBox(height: Rem.rem1),
                    Text(
                      'Tanggal Terverifikasi',
                      style: GoogleFonts.poppins(fontSize: Rem.rem0_75),
                    ),
                    Text(
                      widget.dataPemasukan.tanggalVerifikasi,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: Rem.rem0_875),
                    ),
                    const SizedBox(height: Rem.rem1),
                    Text(
                      'Verifikator',
                      style: GoogleFonts.poppins(fontSize: Rem.rem0_75),
                    ),
                    Text(
                      widget.dataPemasukan.verifikator,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: Rem.rem0_875),
                    ),
                    const SizedBox(height: Rem.rem1),
                    CustomButton(
                      backgroundColor: Colors.grey,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Kembali',
                        style: GoogleFonts.poppins(fontSize: Rem.rem1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

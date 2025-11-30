import 'package:flutter/material.dart';
import 'package:jawara_mobile/constants/colors.dart';
import 'package:jawara_mobile/constants/rem.dart';
import 'package:jawara_mobile/widgets/white_card_page.dart';

class TambahWargaScreen extends StatelessWidget {
  final String title = 'Tambah Warga Baru';
  final DateTime selectedDate = DateTime.now();

  TambahWargaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WhiteCardPage(
      title: title,
      children: [
        // NIK
        Text(
          'NIK',
          style: TextStyle(fontSize: Rem.rem1, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: Rem.rem1),
        TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            hintText: 'Masukkan NIK warga',
          ),
        ),

        SizedBox(height: Rem.rem2),

        // Nama Lengkap
        Text(
          'Nama Lengkap',
          style: TextStyle(fontSize: Rem.rem1, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: Rem.rem1),
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            hintText: 'Masukkan nama lengkap warga',
          ),
        ),

        SizedBox(height: Rem.rem2),

        // Tanggal Lahir
        Text(
          'Tanggal Lahir',
          style: TextStyle(fontSize: Rem.rem1, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: Rem.rem1),
        OutlinedButton(
          onPressed: () {
            showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1950, 1),
              lastDate: DateTime(2101),
            );
          },
          child: Row(
            children: [
              Icon(Icons.calendar_today),
              SizedBox(width: Rem.rem1),
              Text(selectedDate.toLocal().toString().split(' ')[0]),
            ],
          ),
        ),

        SizedBox(height: Rem.rem2),

        // Alamat
        Text(
          'Alamat',
          style: TextStyle(fontSize: Rem.rem1, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: Rem.rem1),
        TextField(
          maxLines: 2,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            hintText: 'Masukkan alamat sesuai KTP',
          ),
        ),

        SizedBox(height: Rem.rem2),

        // Nomor HP
        Text(
          'Nomor HP',
          style: TextStyle(fontSize: Rem.rem1, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: Rem.rem1),
        TextField(
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            hintText: 'Masukkan nomor HP',
          ),
        ),

        SizedBox(height: Rem.rem3),

        // Tombol Submit & Reset
        Row(
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: EdgeInsets.symmetric(
                  horizontal: Rem.rem2,
                  vertical: Rem.rem1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Submit',
                style: TextStyle(fontSize: Rem.rem1, color: Colors.white),
              ),
            ),
            SizedBox(width: Rem.rem1),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: Rem.rem2,
                  vertical: Rem.rem1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Reset',
                style: TextStyle(fontSize: Rem.rem1),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

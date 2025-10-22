import 'package:flutter/material.dart';
import 'package:jawara_mobile/constants/colors.dart';
import 'package:jawara_mobile/constants/rem.dart';
import 'package:jawara_mobile/widgets/white_card_page.dart';

class TambahPemasukanScreen extends StatelessWidget {
  final String title = 'Buat Pemasukan Baru';
  final DateTime selectedDate = DateTime.now();

  TambahPemasukanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WhiteCardPage(
      title: title,
      children: [
        Text(
          'Nama Pemasukan',
          style: TextStyle(fontSize: Rem.rem1, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: Rem.rem1),
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            hintText: 'Masukkan nama Pemasukan',
          ),
        ),
        SizedBox(height: Rem.rem2),
        Text(
          'Tanggal Pemasukan',
          style: TextStyle(fontSize: Rem.rem1, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: Rem.rem1),
        OutlinedButton(
          onPressed: () {
            showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2015, 8),
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
        Text(
          'Jenis Pemasukan',
          style: TextStyle(fontSize: Rem.rem1, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: Rem.rem1),
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            hintText: 'Masukkan Jenis Pemasukan',
          ),
        ),
        SizedBox(height: Rem.rem2),
        Text(
          'Nominal Pemasukan',
          style: TextStyle(fontSize: Rem.rem1, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: Rem.rem1),
        TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            hintText: 'Masukkan Nominal Pemasukan',
          ),
        ),
        SizedBox(height: Rem.rem2),
        Text(
          'Bukti Pemasukan',
          style: TextStyle(fontSize: Rem.rem1, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: Rem.rem1),
        Container(
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Container(
              padding: EdgeInsets.all(Rem.rem1),
              child: Text('Klik untuk mengunggah bukti Pemasukan'),
            ),
          ),
        ),
        SizedBox(height: Rem.rem3),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
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
                // backgroundColor: Colors.,
                padding: EdgeInsets.symmetric(
                  horizontal: Rem.rem2,
                  vertical: Rem.rem1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Reset', style: TextStyle(fontSize: Rem.rem1)),
            ),
          ],
        ),
      ],
    );
  }
}
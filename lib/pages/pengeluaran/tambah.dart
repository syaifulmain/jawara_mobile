import 'package:flutter/material.dart';
import 'package:jawara_mobile/constants/colors.dart';
import 'package:jawara_mobile/constants/rem.dart';
import 'package:jawara_mobile/pages/templates/white_card_page.dart';

class Tambah extends StatelessWidget {
  final String title = 'Buat Pengeluaran Baru';
  final DateTime selectedDate = DateTime.now();
  Tambah({super.key});

  @override
  Widget build(BuildContext context) {
    return WhiteCardPage(
      title: title,
      children: [
        Text(
          'Nama Pengeluaran',
          style: TextStyle(fontSize: Rem.rem1, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: Rem.rem1),
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            hintText: 'Masukkan nama pengeluaran',
          ),
        ),
        SizedBox(height: Rem.rem2),
        Text(
          'Tanggal Pengeluaran',
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
          'Kategori Pengeluaran',
          style: TextStyle(fontSize: Rem.rem1, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: Rem.rem1),
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            hintText: 'Masukkan kategori pengeluaran',
          ),
        ),
        SizedBox(height: Rem.rem2),
        Text(
          'Nominal Pengeluaran',
          style: TextStyle(fontSize: Rem.rem1, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: Rem.rem1),
        TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            hintText: 'Masukkan nominal pengeluaran',
          ),
        ),
        SizedBox(height: Rem.rem2),
        Text(
          'Bukti Pengeluaran',
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
            child: Text('Klik untuk mengunggah bukti pengeluaran'),
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
              child: Text('Submit', style: TextStyle(fontSize: Rem.rem1, color: Colors.white)),
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

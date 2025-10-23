import 'package:flutter/material.dart';
import 'package:jawara_mobile/constants/colors.dart';
import 'package:jawara_mobile/widgets/white_card_page.dart';
import 'package:jawara_mobile/constants/rem.dart';

class CetakLaporan extends StatelessWidget {
  final String title = "Cetak Laporan Keuangan";
  final DateTime selectedStartDate = DateTime.now();
  final DateTime selectedEndDate = DateTime.now();

  CetakLaporan({super.key});

  @override
  Widget build(BuildContext context) {
    return WhiteCardPage(
      // title: title,
      children: [
        Text(
          'Tanggal Mulai',
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
              Text(selectedStartDate.toLocal().toString().split(' ')[0]),
            ],
          ),
        ),
        SizedBox(height: Rem.rem2),
        Text(
          'Tanggal Selesai',
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
              Text(selectedEndDate.toLocal().toString().split(' ')[0]),
            ],
          ),
        ),
        SizedBox(height: Rem.rem2),
        Text(
          'Jenis Laporan',
          style: TextStyle(fontSize: Rem.rem1, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: Rem.rem1),
        DropdownButtonFormField(
          items: [
            DropdownMenuItem<String>(value: "Semua", child: Text("Semua"),),
            DropdownMenuItem<String>(value: "Pengeluaran", child: Text("Pengeluaran"),),
            DropdownMenuItem<String>(value: "Pemasukan", child: Text("Pemasukan"),),
          ],
          onChanged: (context) {},
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
                'Cetak',
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

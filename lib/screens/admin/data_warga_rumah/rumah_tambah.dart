import 'package:flutter/material.dart';
import 'package:jawara_mobile/constants/colors.dart';
import 'package:jawara_mobile/constants/rem.dart';
import 'package:jawara_mobile/widgets/white_card_page.dart';

class TambahRumahScreen extends StatelessWidget {
  final String title = "Tambah Data Rumah";

  TambahRumahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WhiteCardPage(
      title: title,
      children: [
        // Nomor Rumah
        Text(
          'Nomor Rumah',
          style: TextStyle(fontSize: Rem.rem1, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: Rem.rem1),
        TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            hintText: "Masukkan nomor rumah",
          ),
        ),
        SizedBox(height: Rem.rem2),

        // Alamat
        Text(
          'Alamat Rumah',
          style: TextStyle(fontSize: Rem.rem1, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: Rem.rem1),
        TextField(
          maxLines: 2,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            hintText: "Masukkan alamat rumah",
          ),
        ),
        SizedBox(height: Rem.rem2),

        // RT / RW
        Text(
          "RT / RW",
          style: TextStyle(fontSize: Rem.rem1, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: Rem.rem1),
        Row(
          children: [
            Expanded(
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  hintText: "RT",
                ),
              ),
            ),
            SizedBox(width: Rem.rem1),
            Expanded(
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  hintText: "RW",
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: Rem.rem2),

        // Status Rumah
        Text(
          "Status Rumah",
          style: TextStyle(fontSize: Rem.rem1, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: Rem.rem1),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              hint: Text("Pilih status rumah"),
              items: const [
                DropdownMenuItem(value: "Milik", child: Text("Milik")),
                DropdownMenuItem(value: "Kontrak", child: Text("Kontrak")),
              ],
              onChanged: (value) {},
            ),
          ),
        ),
        SizedBox(height: Rem.rem2),

        // Jumlah Penghuni
        Text(
          'Jumlah Penghuni',
          style: TextStyle(fontSize: Rem.rem1, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: Rem.rem1),
        TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            hintText: 'Masukkan jumlah penghuni',
          ),
        ),
        SizedBox(height: Rem.rem3),

        // Tombol Submit dan Reset
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
                "Submit",
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
                "Reset",
                style: TextStyle(fontSize: Rem.rem1),
              ),
            ),
          ],
        )
      ],
    );
  }
}

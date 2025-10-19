import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_mobile/constants/colors.dart';
import 'package:jawara_mobile/constants/rem.dart';

class AdminLayoutScreen extends StatefulWidget {
  const AdminLayoutScreen({super.key});

  @override
  State<AdminLayoutScreen> createState() => AdminLayoutScreenState();
}

class AdminLayoutScreenState extends State<AdminLayoutScreen> {
  String selectedMenu = 'Keuangan';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSidebar(context),
      appBar: AppBar(backgroundColor: AppColors.backgroundColor, elevation: 0),
      body: Container(
        color: AppColors.backgroundColor,
        child: Center(
          child: Text(
            'Halaman $selectedMenu',
            style: GoogleFonts.poppins(fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      width: MediaQuery.of(context).size.width * 0.6 > 300
          ? 300
          : MediaQuery.of(context).size.width * 0.6,
      backgroundColor: AppColors.backgroundColor,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Rem.rem1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: Rem.rem0_5),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(Rem.rem0_625),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(Rem.rem0_5),
                      ),
                      child: const Icon(
                        Icons.menu_book_rounded,
                        color: Colors.white,
                        size: Rem.rem1,
                      ),
                    ),

                    const SizedBox(width: Rem.rem0_5),

                    Text(
                      'Jawara Pintar',
                      style: GoogleFonts.figtree(
                        fontSize: Rem.rem1,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Rem.rem0_5),
              Text(
                'Menu',
                style: GoogleFonts.poppins(
                  fontSize: Rem.rem0_75,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: Rem.rem0_5),

              // === Menu Items ===
              Expanded(
                child: ListView(
                  children: [
                    _buildSubMenu(Icons.terminal, 'Dashboard', [
                      'Keuangan',
                      'Kegiatan',
                      'Kependudukan',
                    ]),
                    _buildSubMenu(
                      Icons.people_alt_outlined,
                      'Data Warga & Rumah',
                      [
                        'Warga - Daftar',
                        'Warga - Tambah',
                        'Keluarga',
                        'Rumah - Daftar',
                        'Rumah - Tambah',
                      ],
                    ),
                    _buildSubMenu(Icons.receipt_outlined, 'Pemasukan', [
                      'Daftar',
                      'Tambah',
                    ]),
                    _buildSubMenu(Icons.note_add_outlined, 'Pemasukan', [
                      'Daftar',
                      'Tambah',
                    ]),
                    _buildSubMenu(Icons.receipt_long, 'Laporan Keuangan', [
                      'Semua Pemasukan',
                      'Semua Pengeluaran',
                      'Cetak Laporan',
                    ]),
                    _buildSubMenu(
                      Icons.calendar_month_outlined,
                      'Kegiatan & Broadcast',
                      [
                        'Kegiatan - Daftar',
                        'Kegiatan - Tambah',
                        'Broadcast - Daftar',
                        'Broadcast - Tambah',
                      ],
                    ),
                    _buildSubMenu(Icons.message_outlined, 'Pesan Warga', [
                      'Informasi Aspirasi',
                    ]),
                    _buildSubMenu(Icons.message_outlined, 'Penerimaan Warga', [
                      'Penerimaan Warga',
                    ]),
                    _buildSubMenu(
                      Icons.family_restroom_outlined,
                      'Mutasi Keluarga',
                      ['Daftar', 'Tambah'],
                    ),
                    _buildSubMenu(Icons.history_outlined, 'Log Aktifitas', [
                      'Semua Aktifitas',
                    ]),
                    _buildSubMenu(
                      Icons.manage_accounts_outlined,
                      'Manajemen Pengguna',
                      ['Daftar Pengguna', 'Tambah Pengguna'],
                    ),
                    _buildSubMenu(
                      Icons.credit_card_outlined,
                      'Channel Transfer',
                      ['Daftar Channel', 'Tambah Channel'],
                    ),
                  ],
                ),
              ),

              // === Profile Admin di Bawah ===
              Divider(height: 1, color: Colors.grey[300]),
              Padding(
                padding: EdgeInsets.symmetric(vertical: Rem.rem1),
                child: PopupMenuButton<String>(
                  offset: const Offset(0, -150), // posisi menu di atas avatar
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Rem.rem0_5),
                  ),
                  color: Colors.white,
                  elevation: 2,
                  onSelected: (value) {
                    if (value == 'logout') {
                      context.goNamed('login');
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      enabled: false,
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 16,
                            backgroundColor: AppColors.primaryColor,
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Admin Jawara',
                                style: GoogleFonts.poppins(
                                  fontSize: Rem.rem0_875,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'admin1@gmail.com',
                                style: GoogleFonts.poppins(
                                  fontSize: Rem.rem0_75,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        children: [
                          const Icon(
                            Icons.logout,
                            color: Colors.black87,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Log out',
                            style: GoogleFonts.poppins(fontSize: Rem.rem0_875),
                          ),
                        ],
                      ),
                    ),
                  ],
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.primaryColor,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: Rem.rem0_875),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Admin Jawara',
                              style: GoogleFonts.poppins(
                                fontSize: Rem.rem0_875,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'admin1@gmail.com',
                              style: GoogleFonts.poppins(
                                fontSize: Rem.rem0_75,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down_rounded),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    final bool isSelected = selectedMenu == title;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      // visualDensity: VisualDensity.compact,
      leading: Icon(
        icon,
        color: isSelected ? AppColors.primaryColor : Colors.grey[700],
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          color: isSelected ? AppColors.primaryColor : Colors.black87,
        ),
      ),
      onTap: () {
        setState(() => selectedMenu = title);
        Navigator.pop(context);
      },
    );
  }

  Widget _buildSubMenu(IconData icon, String parent, List<String> items) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        dense: true,
        // visualDensity: VisualDensity.compact,
        initiallyExpanded:
            items.contains(selectedMenu) || selectedMenu == parent,
        title: Text(
          parent,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w400),
        ),
        leading: Icon(icon, color: Colors.grey[700]),
        childrenPadding: EdgeInsets.zero,
        children: items.map((e) {
          final bool isActive = selectedMenu == e;
          return Container(
            margin: const EdgeInsets.only(left: Rem.rem0_625),
            padding: const EdgeInsets.only(left: Rem.rem1_75),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: Colors.grey[300]!, width: 2),
              ),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                e,
                style: GoogleFonts.poppins(
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive ? AppColors.primaryColor : Colors.black87,
                ),
              ),
              onTap: () {
                setState(() => selectedMenu = e);
                Navigator.pop(context);
              },
              dense: true,
              visualDensity: VisualDensity.compact,
            ),
          );
        }).toList(),
      ),
    );
  }
}

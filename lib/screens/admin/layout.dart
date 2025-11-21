import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_mobile/constants/colors.dart';
import 'package:jawara_mobile/constants/rem.dart';

class AdminLayoutScreen extends StatelessWidget {
  final Widget child;

  const AdminLayoutScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSidebar(context),
      appBar: AppBar(backgroundColor: AppColors.backgroundColor, elevation: 0),
      body: child,
    );
  }

  Widget _buildSidebar(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();

    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      width: MediaQuery.of(context).size.width * 0.6 > 300
          ? 300
          : MediaQuery.of(context).size.width * 0.6,
      backgroundColor: AppColors.backgroundColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Rem.rem1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: Rem.rem0_5),
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
                    _buildSubMenu(context, location, Icons.terminal, 'Dashboard', [
                      {'title': 'Keuangan', 'route': '/admin'},
                      {'title': 'Kegiatan', 'route': '/dashboard/kegiatan'},
                      {'title': 'Kependudukan', 'route': '/dashboard/kependudukan'},
                    ]),
                    _buildSubMenu(
                      context,
                      location,
                      Icons.people_alt_outlined,
                      'Data Warga & Rumah',
                      [
                        {'title': 'Warga - Daftar', 'route': '/data_warga_rumah/daftar_warga'},
                        {'title': 'Warga - Tambah', 'route': '/data_warga_rumah/tambah_warga'},
                        {'title': 'Keluarga', 'route': '/data_warga_rumah/keluarga'},
                        {'title': 'Rumah - Daftar', 'route': '/data_warga_rumah/rumah'},
                        {'title': 'Rumah - Tambah', 'route': '/data_warga_rumah/rumah_tambah'},
                      ],
                    ),
                    _buildSubMenu(context, location, Icons.receipt_outlined, 'Pemasukan', [
                      {'title': 'Daftar', 'route': '/pemasukan/daftar'},
                      {'title': 'Tambah', 'route': '/pemasukan/tambah'},
                    ]),
                    _buildSubMenu(context, location, Icons.note_add_outlined, 'Pengeluaran', [
                      {'title': 'Daftar', 'route': '/pengeluaran/daftar'},
                      {'title': 'Tambah', 'route': '/pengeluaran/tambah'},
                    ]),
                    _buildSubMenu(context, location, Icons.receipt_long, 'Laporan Keuangan', [
                      {'title': 'Semua Pemasukan', 'route': '/laporan_keuangan/semua_pemasukan'},
                      {'title': 'Semua Pengeluaran', 'route': '/laporan_keuangan/semua_pengeluaran'},
                      {'title': 'Cetak Laporan', 'route': '/laporan_keuangan/cetak_laporan'},
                    ]),
                    _buildSubMenu(
                      context,
                      location,
                      Icons.calendar_month_outlined,
                      'Kegiatan & Broadcast',
                      [
                        {
                          'title': 'Kegiatan - Daftar',
                          'route': '/kegiatan/daftar'
                        },
                        {'title': 'Kegiatan - Tambah', 'route': '/kegiatan/tambah'},
                        {
                          'title': 'Broadcast - Daftar',
                          'route': '/broadcast/daftar'
                        },
                        {
                          'title': 'Broadcast - Tambah',
                          'route': '/broadcast/tambah'
                        },
                      ],
                    ),
                  ],
                ),
              ),

              // === Profile Admin di Bawah ===
              Divider(height: 1, color: Colors.grey[300]),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: Rem.rem1),
                child: PopupMenuButton<String>(
                  offset: const Offset(0, -150),
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

  Widget _buildSubMenu(BuildContext context, String location, IconData icon,
      String parent, List<Map<String, String>> items) {
    // A sub-menu is expanded if one of its children is the current active route.
    final bool hasSelectedChild = items.any((item) => item['route'] == location);

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        dense: true,
        initiallyExpanded: hasSelectedChild,
        title: Text(
          parent,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w400),
        ),
        leading: Icon(icon, color: Colors.grey[700]),
        childrenPadding: EdgeInsets.zero,
        children: items.map((item) {
          final String title = item['title'] ?? '';
          final String route = item['route'] ?? '/placeholder';
          final bool isActive = location == route;

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
                title,
                style: GoogleFonts.poppins(
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive ? AppColors.primaryColor : Colors.black87,
                ),
              ),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                context.go(route);      // Navigate to the new page
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

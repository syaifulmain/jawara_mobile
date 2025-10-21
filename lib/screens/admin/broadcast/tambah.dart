import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_mobile/constants/colors.dart';
import 'package:jawara_mobile/constants/rem.dart';
import 'package:jawara_mobile/widgets/custom_button.dart';

class BroadcastTambahScreen extends StatefulWidget {
  const BroadcastTambahScreen({super.key});

  @override
  State<BroadcastTambahScreen> createState() => _BroadcastTambahScreenState();
}

class _BroadcastTambahScreenState extends State<BroadcastTambahScreen> {
  String selectedMenu = 'Broadcast - Tambah';
  
  // Form controllers
  final _judulBroadcastController = TextEditingController();
  final _isiBroadcastController = TextEditingController();

  @override
  void dispose() {
    _judulBroadcastController.dispose();
    _isiBroadcastController.dispose();
    super.dispose();
  }

  void _submitForm() {
    // TODO: Implementasi submit form
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Broadcast berhasil dibuat!'),
        backgroundColor: Colors.green,
      ),
    );
    
    // Reset form
    _resetForm();
  }

  void _resetForm() {
    _judulBroadcastController.clear();
    _isiBroadcastController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSidebar(context),
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black87),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          'Broadcast - Tambah',
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Container(
        color: AppColors.backgroundColor,
        child: Card(
          elevation: 2,
          margin: const EdgeInsets.all(Rem.rem1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Rem.rem0_75),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(Rem.rem1_5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'Buat Broadcast Baru',
                  style: GoogleFonts.poppins(
                    fontSize: Rem.rem1_25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: Rem.rem1_5),

                // Form
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Judul Broadcast
                        Text(
                          'Judul Broadcast',
                          style: GoogleFonts.poppins(
                            fontSize: Rem.rem0_875,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: Rem.rem0_5),
                        TextField(
                          controller: _judulBroadcastController,
                          style: GoogleFonts.poppins(),
                          decoration: InputDecoration(
                            hintText: 'Masukkan judul broadcast',
                            hintStyle: GoogleFonts.poppins(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(Rem.rem0_5),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(Rem.rem0_5),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(Rem.rem0_5),
                              borderSide: const BorderSide(color: AppColors.primaryColor),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: Rem.rem0_75,
                              vertical: Rem.rem0_75,
                            ),
                          ),
                        ),
                        const SizedBox(height: Rem.rem1),

                        // Isi Broadcast
                        Text(
                          'Isi Broadcast',
                          style: GoogleFonts.poppins(
                            fontSize: Rem.rem0_875,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: Rem.rem0_5),
                        TextField(
                          controller: _isiBroadcastController,
                          maxLines: 6,
                          style: GoogleFonts.poppins(),
                          decoration: InputDecoration(
                            hintText: 'Tulis isi broadcast di sini...',
                            hintStyle: GoogleFonts.poppins(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(Rem.rem0_5),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(Rem.rem0_5),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(Rem.rem0_5),
                              borderSide: const BorderSide(color: AppColors.primaryColor),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: Rem.rem0_75,
                              vertical: Rem.rem0_75,
                            ),
                          ),
                        ),
                        const SizedBox(height: Rem.rem1_5),

                        // Upload Foto
                        Text(
                          'Foto',
                          style: GoogleFonts.poppins(
                            fontSize: Rem.rem0_875,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: Rem.rem0_25),
                        Text(
                          'Maksimal 10 gambar (.png / .jpg), ukuran maksimal 5MB per gambar.',
                          style: GoogleFonts.poppins(
                            fontSize: Rem.rem0_75,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: Rem.rem0_5),
                        Container(
                          width: double.infinity,
                          height: 120,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.shade300,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(Rem.rem0_5),
                            color: Colors.grey.shade50,
                          ),
                          child: InkWell(
                            onTap: () {
                              // TODO: Implementasi upload foto
                            },
                            borderRadius: BorderRadius.circular(Rem.rem0_5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.cloud_upload_outlined,
                                  size: 32,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(height: Rem.rem0_5),
                                Text(
                                  'Upload foto png/jpg',
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey[600],
                                    fontSize: Rem.rem0_875,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: Rem.rem1_5),

                        // Upload Dokumen
                        Text(
                          'Dokumen',
                          style: GoogleFonts.poppins(
                            fontSize: Rem.rem0_875,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: Rem.rem0_25),
                        Text(
                          'Maksimal 10 file (.pdf), ukuran maksimal 5MB per file.',
                          style: GoogleFonts.poppins(
                            fontSize: Rem.rem0_75,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: Rem.rem0_5),
                        Container(
                          width: double.infinity,
                          height: 120,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.shade300,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(Rem.rem0_5),
                            color: Colors.grey.shade50,
                          ),
                          child: InkWell(
                            onTap: () {
                              // TODO: Implementasi upload dokumen
                            },
                            borderRadius: BorderRadius.circular(Rem.rem0_5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.description_outlined,
                                  size: 32,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(height: Rem.rem0_5),
                                Text(
                                  'Upload dokumen pdf',
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey[600],
                                    fontSize: Rem.rem0_875,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: Rem.rem2),

                        // Buttons
                        Row(
                          children: [
                            Expanded(
                              child: CustomButton(
                                onPressed: _submitForm,
                                child: Text(
                                  'Submit',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: Rem.rem1),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _resetForm,
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: Rem.rem0_875,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      Rem.rem0_5,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'Reset',
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
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
                    _buildSubMenu(Icons.terminal, 'Dashboard', [
                      {'title': 'Keuangan', 'route': '/admin'},
                      {'title': 'Kegiatan', 'route': '/admin'},
                      {'title': 'Kependudukan', 'route': '/admin'},
                    ]),
                    _buildSubMenu(
                      Icons.people_alt_outlined,
                      'Data Warga & Rumah',
                      [
                        {'title': 'Warga - Daftar', 'route': '/placeholder'},
                        {'title': 'Warga - Tambah', 'route': '/placeholder'},
                        {'title': 'Keluarga', 'route': '/placeholder'},
                        {'title': 'Rumah - Daftar', 'route': '/placeholder'},
                        {'title': 'Rumah - Tambah', 'route': '/placeholder'},
                      ],
                    ),
                    _buildSubMenu(Icons.receipt_outlined, 'Pemasukan', [
                      {'title': 'Daftar', 'route': '/placeholder'},
                      {'title': 'Tambah', 'route': '/placeholder'},
                    ]),
                    _buildSubMenu(Icons.note_add_outlined, 'Pengeluaran', [
                      {'title': 'Daftar', 'route': '/placeholder'},
                      {'title': 'Tambah', 'route': '/placeholder'},
                    ]),
                    _buildSubMenu(Icons.receipt_long, 'Laporan Keuangan', [
                      {'title': 'Semua Pemasukan', 'route': '/placeholder'},
                      {'title': 'Semua Pengeluaran', 'route': '/placeholder'},
                      {'title': 'Cetak Laporan', 'route': '/placeholder'},
                    ]),
                    _buildSubMenu(
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
                    _buildSubMenu(Icons.message_outlined, 'Pesan Warga', [
                      {'title': 'Informasi Aspirasi', 'route': '/placeholder'},
                    ]),
                    _buildSubMenu(
                        Icons.person_add_outlined, 'Penerimaan Warga', [
                      {'title': 'Penerimaan Warga', 'route': '/placeholder'},
                    ]),
                    _buildSubMenu(
                      Icons.family_restroom_outlined,
                      'Mutasi Keluarga',
                      [
                        {'title': 'Daftar', 'route': '/placeholder'},
                        {'title': 'Tambah', 'route': '/placeholder'},
                      ],
                    ),
                    _buildSubMenu(Icons.history_outlined, 'Log Aktifitas', [
                      {'title': 'Semua Aktifitas', 'route': '/placeholder'},
                    ]),
                    _buildSubMenu(
                      Icons.manage_accounts_outlined,
                      'Manajemen Pengguna',
                      [
                        {'title': 'Daftar Pengguna', 'route': '/placeholder'},
                        {'title': 'Tambah Pengguna', 'route': '/placeholder'},
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

  Widget _buildSubMenu(
      IconData icon, String parent, List<Map<String, String>> items) {
    final bool hasSelectedChild =
        items.any((item) => item['title'] == selectedMenu);

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        dense: true,
        initiallyExpanded: hasSelectedChild || selectedMenu == parent,
        title: Text(
          parent,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w400),
        ),
        leading: Icon(icon, color: Colors.grey[700]),
        childrenPadding: EdgeInsets.zero,
        children: items.map((item) {
          final String title = item['title'] ?? '';
          final String route = item['route'] ?? '/placeholder';
          final bool isActive = selectedMenu == title;

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
                Navigator.pop(context);
                context.go(route);
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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../constants/color_constant.dart';
import '../../../../constants/rem_constant.dart';
import '../../../../models/address/address_detail_model.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/address_provider.dart';

class HouseDetailScreen extends StatefulWidget {
  final String id;

  const HouseDetailScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<HouseDetailScreen> createState() => _HouseDetailScreenState();
}

class _HouseDetailScreenState extends State<HouseDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDetail();
    });
  }

  void _loadDetail() {
    final authProvider = context.read<AuthProvider>();
    final addressProvider = context.read<AddressProvider>();

    if (authProvider.token != null) {
      addressProvider.fetchAddressDetail(authProvider.token!, widget.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
        title: Text(
          'Detail Rumah',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<AddressProvider>(
        builder: (context, addressProvider, child) {
          if (addressProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (addressProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${addressProvider.errorMessage}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadDetail,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          final house = addressProvider.selectedAddress;
          if (house == null) {
            return const Center(child: Text('Data rumah tidak ditemukan'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(Rem.rem1_5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoCard(house),
                const SizedBox(height: Rem.rem2),
                _buildHistorySection(house),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(AddressDetailModel house) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Rem.rem1_5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Rem.rem0_75),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informasi Alamat',
            style: GoogleFonts.poppins(
              fontSize: Rem.rem1_25,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: Rem.rem1),
          _buildInfoRow('Alamat Lengkap', house.address),
          const SizedBox(height: Rem.rem1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Status',
                style: GoogleFonts.poppins(
                  color: Colors.grey.shade600,
                  fontSize: Rem.rem0_875,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: house.status == 'Ditempati' ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  house.status,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: house.status == 'Ditempati' ? Colors.green : Colors.orange,
                    fontSize: Rem.rem0_875,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.grey.shade600,
            fontSize: Rem.rem0_875,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: Rem.rem1,
          ),
        ),
      ],
    );
  }

  Widget _buildHistorySection(AddressDetailModel house) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Riwayat Penghuni',
          style: GoogleFonts.poppins(
            fontSize: Rem.rem1_25,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        const SizedBox(height: Rem.rem1),
        if (house.history.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(Rem.rem2),
              child: Text(
                'Belum ada riwayat penghuni',
                style: GoogleFonts.poppins(color: Colors.grey),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: house.history.length,
            itemBuilder: (context, index) {
              final history = house.history[index];
              return _buildHistoryCard(history);
            },
          ),
      ],
    );
  }

  Widget _buildHistoryCard(AddressHistoryModel history) {
    return Container(
      margin: const EdgeInsets.only(bottom: Rem.rem1),
      padding: const EdgeInsets.all(Rem.rem1),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Rem.rem0_5),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.family_restroom, color: AppColors.primaryColor, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  history.family ?? 'Keluarga Tanpa Nama',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: Rem.rem1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (history.headResident != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                'Kepala Keluarga: ${history.headResident}',
                style: GoogleFonts.poppins(fontSize: Rem.rem0_875),
              ),
            ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Masuk',
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: Rem.rem0_75,
                    ),
                  ),
                  Text(
                    history.movedInAt ?? '-',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: Rem.rem0_875,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Keluar',
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: Rem.rem0_75,
                    ),
                  ),
                  Text(
                    history.movedOutAt,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      color: history.movedOutAt == 'Masih tinggal' ? Colors.green : Colors.black,
                      fontSize: Rem.rem0_875,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

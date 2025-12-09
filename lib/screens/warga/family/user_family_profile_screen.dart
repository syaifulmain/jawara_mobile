import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../constants/color_constant.dart';
import '../../../../constants/rem_constant.dart';
import '../../../../models/family/family_detail_model.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/user_family_provider.dart';

class UserFamilyProfileScreen extends StatefulWidget {
  const UserFamilyProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserFamilyProfileScreen> createState() =>
      _UserFamilyProfileScreenState();
}

class _UserFamilyProfileScreenState extends State<UserFamilyProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDetail();
    });
  }

  void _loadDetail() {
    final authProvider = context.read<AuthProvider>();
    final userFamilyProvider = context.read<UserFamilyProvider>();

    if (authProvider.token != null) {
      userFamilyProvider.fetchMyFamily(authProvider.token!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
        title: Text(
          'Detail Keluarga',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<UserFamilyProvider>(
        builder: (context, userFamilyProvider, child) {
          if (userFamilyProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (userFamilyProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${userFamilyProvider.errorMessage}',
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

          final family = userFamilyProvider.selectedFamily;
          if (family == null) {
            return const Center(child: Text('Data keluarga tidak ditemukan'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(Rem.rem1_5),
            child: _buildInfoCard(family), // Hanya menampilkan detail keluarga
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(FamilyDetailModel family) {
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
            'Informasi Keluarga',
            style: GoogleFonts.poppins(
              fontSize: Rem.rem1_25,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: Rem.rem1),
          _buildInfoRow('Nama Keluarga', family.familyName),
          const SizedBox(height: Rem.rem1),
          _buildInfoRow('Kepala Keluarga', family.familyHead ?? '-'),
          const SizedBox(height: Rem.rem1),
          _buildInfoRow('Alamat Saat Ini', family.currentAddress ?? '-'),
          const SizedBox(height: Rem.rem1),
          _buildInfoRow('Status Kepemilikan', family.ownershipStatus ?? '-'),
          const SizedBox(height: Rem.rem1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Status Keluarga',
                style: GoogleFonts.poppins(
                  color: Colors.grey.shade600,
                  fontSize: Rem.rem0_875,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: family.familyStatus == 'Aktif'
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  family.familyStatus,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: family.familyStatus == 'Aktif'
                        ? Colors.green
                        : Colors.red,
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
}

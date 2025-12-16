import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jawara_mobile_v2/models/family_relocation/family_relocation_detail_model.dart';
import 'package:jawara_mobile_v2/providers/family_relocation_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../constants/color_constant.dart';
import '../../../../constants/rem_constant.dart';
import '../../../../providers/auth_provider.dart';

class FamilyRelocationDetailScreen extends StatefulWidget {
  final String id;

  const FamilyRelocationDetailScreen({super.key, required this.id});

  @override
  State<FamilyRelocationDetailScreen> createState() =>
      _FamilyRelocationDetailScreenState();
}

class _FamilyRelocationDetailScreenState
    extends State<FamilyRelocationDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDetail();
    });
  }

  void _loadDetail() async {
    final authProvider = context.read<AuthProvider>();
    final familyRelocationProvider = context.read<FamilyRelocationProvider>();

    if (authProvider.token != null) {
      await familyRelocationProvider.fetchFamilyRelocationDetail(
        authProvider.token!,
        widget.id,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      appBar: AppBar(
        title: Text(
          'Detail Pindah Keluarga',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<FamilyRelocationProvider>(
        builder: (context, provider, _) {
          final relocation = provider.selectedFamilyRelocation;

          if (provider.isLoading && relocation == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null && relocation == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${provider.errorMessage}',
                    style: const TextStyle(color: Colors.red),
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

          if (relocation == null) {
            return const Center(
              child: Text('Data tidak ditemukan'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(Rem.rem1_5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Informasi Keluarga'),
                _buildInfoCard([
                  _buildInfoRow('Nama Keluarga', relocation.familyName),
                ]),
                const SizedBox(height: Rem.rem1_5),
                _buildSectionTitle('Informasi Perpindahan'),
                _buildInfoCard([
                  _buildInfoRow(
                    'Tipe Perpindahan',
                    relocation.relocationType.label,
                  ),
                  const Divider(height: Rem.rem1_5),
                  _buildInfoRow(
                    'Tanggal Pindah',
                    DateFormat('dd MMMM yyyy', 'id_ID')
                        .format(relocation.relocationDate),
                  ),
                  const Divider(height: Rem.rem1_5),
                  _buildInfoRow('Alasan', relocation.reason),
                ]),
                const SizedBox(height: Rem.rem1_5),
                _buildSectionTitle('Alamat'),
                _buildInfoCard([
                  _buildInfoRow(
                    'Alamat Lama',
                    relocation.pastAddress,
                    isMultiline: true,
                  ),
                  const Divider(height: Rem.rem1_5),
                  _buildInfoRow(
                    'Alamat Baru',
                    relocation.newAddress,
                    isMultiline: true,
                  ),
                ]),
                const SizedBox(height: Rem.rem1_5),
                _buildSectionTitle('Informasi Tambahan'),
                _buildInfoCard([
                  _buildInfoRow('Dibuat Oleh', relocation.createdBy),
                ]),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Rem.rem1),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: Rem.rem1_25,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
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
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isMultiline = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: Rem.rem0_875,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: Rem.rem0_5),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: Rem.rem1,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
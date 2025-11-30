import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../constants/color_constant.dart';
import '../../../../constants/rem_constant.dart';
import '../../../../models/family/family_detail_model.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/family_provider.dart';

class FamilyDetailScreen extends StatefulWidget {
  final String id;

  const FamilyDetailScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<FamilyDetailScreen> createState() => _FamilyDetailScreenState();
}

class _FamilyDetailScreenState extends State<FamilyDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDetail();
    });
  }

  void _loadDetail() {
    final authProvider = context.read<AuthProvider>();
    final familyProvider = context.read<FamilyProvider>();

    if (authProvider.token != null) {
      familyProvider.fetchFamilyDetail(authProvider.token!, widget.id);
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
      body: Consumer<FamilyProvider>(
        builder: (context, familyProvider, child) {
          if (familyProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (familyProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${familyProvider.errorMessage}',
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

          final family = familyProvider.selectedFamily;
          if (family == null) {
            return const Center(child: Text('Data keluarga tidak ditemukan'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(Rem.rem1_5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoCard(family),
                const SizedBox(height: Rem.rem2),
                _buildMembersSection(family),
              ],
            ),
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: family.familyStatus == 'Aktif' ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  family.familyStatus,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: family.familyStatus == 'Aktif' ? Colors.green : Colors.red,
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

  Widget _buildMembersSection(FamilyDetailModel family) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Anggota Keluarga',
          style: GoogleFonts.poppins(
            fontSize: Rem.rem1_25,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        const SizedBox(height: Rem.rem1),
        if (family.familyMembers.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(Rem.rem2),
              child: Text(
                'Belum ada anggota keluarga',
                style: GoogleFonts.poppins(color: Colors.grey),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: family.familyMembers.length,
            itemBuilder: (context, index) {
              final member = family.familyMembers[index];
              return _buildMemberCard(member);
            },
          ),
      ],
    );
  }

  Widget _buildMemberCard(FamilyMemberModel member) {
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
              Icon(Icons.person, color: AppColors.primaryColor, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.name,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: Rem.rem1,
                      ),
                    ),
                    Text(
                      member.nik,
                      style: GoogleFonts.poppins(
                        color: Colors.grey.shade600,
                        fontSize: Rem.rem0_875,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  member.role,
                  style: GoogleFonts.poppins(
                    fontSize: Rem.rem0_75,
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gender',
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: Rem.rem0_75,
                      ),
                    ),
                    Text(
                      member.gender,
                      style: GoogleFonts.poppins(fontSize: Rem.rem0_875),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tgl Lahir',
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: Rem.rem0_75,
                      ),
                    ),
                    Text(
                      member.birthDate != null 
                        ? DateFormat('dd MMM yyyy').format(DateTime.parse(member.birthDate!))
                        : '-',
                      style: GoogleFonts.poppins(fontSize: Rem.rem0_875),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Status',
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: Rem.rem0_75,
                      ),
                    ),
                    Text(
                      member.status,
                      style: GoogleFonts.poppins(
                        fontSize: Rem.rem0_875,
                        color: member.status == 'Hidup' ? Colors.green : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

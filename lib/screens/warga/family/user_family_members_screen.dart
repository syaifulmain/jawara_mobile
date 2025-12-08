import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../constants/color_constant.dart';
import '../../../../constants/rem_constant.dart';
import '../../../../models/family/family_detail_model.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/user_family_provider.dart';

class UserFamilyMembersScreen extends StatefulWidget {
  const UserFamilyMembersScreen({Key? key}) : super(key: key);

  @override
  State<UserFamilyMembersScreen> createState() =>
      _UserFamilyMembersScreenState();
}

class _UserFamilyMembersScreenState extends State<UserFamilyMembersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFamilyMembers();
    });
  }

  void _loadFamilyMembers() {
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
          'Anggota Keluarga',
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
                    onPressed: _loadFamilyMembers,
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
            child: _buildMembersSection(family),
          );
        },
      ),
    );
  }

  Widget _buildMembersSection(FamilyDetailModel family) {
    final members = family.familyMembers;

    if (members.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(Rem.rem2),
          child: Text(
            'Belum ada anggota keluarga',
            style: GoogleFonts.poppins(color: Colors.grey),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: members.length,
      itemBuilder: (context, index) {
        final member = members[index];
        return _buildMemberCard(member);
      },
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
          // Header: Icon, Name, NIK, Role
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

          // Gender
          _buildInfoColumn('Gender', member.gender),

          const SizedBox(height: 4),

          // Status di bawah Gender
          _buildInfoColumn('Status', member.status),

          const SizedBox(height: 8),

          // Buttons: Detail & Edit (kanan)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  // TODO: navigate to detail screen
                },
                child: Text(
                  'Detail',
                  style: GoogleFonts.poppins(
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  // TODO: navigate to edit screen
                },
                child: Text(
                  'Edit',
                  style: GoogleFonts.poppins(
                    color: Colors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(color: Colors.grey, fontSize: Rem.rem0_75),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: Rem.rem0_875,
            color: (label == 'Status' && value == 'Hidup')
                ? Colors.green
                : null,
          ),
        ),
      ],
    );
  }
}

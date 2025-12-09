import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../models/family/family_detail_model.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/user_family_provider.dart';
import '../../../../widgets/info_banner.dart';

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
      appBar: AppBar(title: const Text('Anggota Keluarga')),
      body: Column(
        children: [
          const InfoBanner(
            message:
                'Daftar anggota keluarga Anda. Klik item untuk melihat detail atau edit data.',
          ),
          Expanded(
            child: Consumer<UserFamilyProvider>(
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
                  return const Center(
                    child: Text('Data keluarga tidak ditemukan'),
                  );
                }

                if (family.familyMembers.isEmpty) {
                  return const Center(
                    child: Text('Belum ada anggota keluarga'),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async => _loadFamilyMembers(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: family.familyMembers.length,
                    itemBuilder: (context, index) {
                      final member = family.familyMembers[index];
                      return _FamilyMemberCard(member: member);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FamilyMemberCard extends StatelessWidget {
  final FamilyMemberModel member;

  const _FamilyMemberCard({required this.member});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          // Navigasi ke detail resident berdasarkan NIK
          context.pushNamed(
            'resident_detail',
            pathParameters: {'id': member.id.toString()},
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                member.name,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('NIK: ${member.nik}'),
              Text('Peran: ${member.role}'),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: member.status == 'Hidup'
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      member.status,
                      style: TextStyle(
                        fontSize: 12,
                        color: member.status == 'Hidup'
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    member.gender,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

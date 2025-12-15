import 'package:flutter/material.dart';
import 'package:jawara_mobile_v2/models/family_relocation/family_relocation_list_model.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/family_relocation_provider.dart';
import '../../../constants/color_constant.dart';
import '../../../widgets/custom_text_form_field.dart';

class FamilyRelocationListScreen extends StatefulWidget {
  const FamilyRelocationListScreen({Key? key}) : super(key: key);

  @override
  State<FamilyRelocationListScreen> createState() =>
      _FamilyRelocationListScreenState();
}

class _FamilyRelocationListScreenState
    extends State<FamilyRelocationListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFamilyRelocations();
    });
  }

  void _loadFamilyRelocations() {
    final authProvider = context.read<AuthProvider>();
    final familyRelocationProvider = context.read<FamilyRelocationProvider>();
    final token = authProvider.token;

    if (token != null) {
      familyRelocationProvider.fetchFamilyRelocations(token);
    }
  }

  void _searchFamilyRelocations(String query) {
    final authProvider = context.read<AuthProvider>();
    final familyRelocationProvider = context.read<FamilyRelocationProvider>();
    final token = authProvider.token;

    if (token != null) {
      if (query.isEmpty) {
        familyRelocationProvider.fetchFamilyRelocations(token);
      } else {
        familyRelocationProvider.searchFamilyRelocations(token, query);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Pindah Keluarga')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomTextFormField(
              controller: _searchController,
              hintText: 'Cari data pindah keluarga...',
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _searchFamilyRelocations('');
                      },
                    )
                  : null,
              prefixIcon: const Icon(Icons.search),
              onChanged: _searchFamilyRelocations,
            ),
          ),
          Expanded(
            child: Consumer<FamilyRelocationProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.errorMessage != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          provider.errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _loadFamilyRelocations(),
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  );
                }

                if (provider.familyRelocations.isEmpty) {
                  return const Center(
                    child: Text('Belum ada data pindah keluarga'),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async => _loadFamilyRelocations(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: provider.familyRelocations.length,
                    itemBuilder: (context, index) {
                      final relocation = provider.familyRelocations[index];
                      return _FamilyRelocationListItemCard(
                        relocation: relocation,
                      );
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class _FamilyRelocationListItemCard extends StatelessWidget {
  final FamilyRelocationListModel relocation;

  const _FamilyRelocationListItemCard({Key? key, required this.relocation})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColors.secondaryColor,
      child: InkWell(
        onTap: () {
          context.pushNamed(
            'family_relocation_detail',
            pathParameters: {'id': relocation.id.toString()},
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: Colors.orange.withOpacity(0.1),
              child: const Icon(Icons.moving, color: Colors.orange),
            ),
            title: Text(
              relocation.familyName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('Tanggal: ${relocation.relocationDate}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

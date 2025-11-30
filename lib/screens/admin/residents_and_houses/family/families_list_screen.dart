import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/family_provider.dart';
import '../../../../models/family/family_list_model.dart';
import '../../../../widgets/custom_text_form_field.dart';

class FamiliesListScreen extends StatefulWidget {
  const FamiliesListScreen({Key? key}) : super(key: key);

  @override
  State<FamiliesListScreen> createState() => _FamiliesListScreenState();
}

class _FamiliesListScreenState extends State<FamiliesListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFamilies();
    });
  }

  void _loadFamilies() {
    final authProvider = context.read<AuthProvider>();
    final familyProvider = context.read<FamilyProvider>();

    if (authProvider.token != null) {
      familyProvider.fetchFamilies(authProvider.token!);
    }
  }

  void _searchFamilies(String query) {
    final authProvider = context.read<AuthProvider>();
    final familyProvider = context.read<FamilyProvider>();

    if (authProvider.token != null) {
      if (query.isEmpty) {
        familyProvider.fetchFamilies(authProvider.token!);
      } else {
        familyProvider.searchFamilies(authProvider.token!, query);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Keluarga')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomTextFormField(
              controller: _searchController,
              hintText: 'Cari keluarga...',
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _searchFamilies('');
                      },
                    )
                  : null,
              prefixIcon: const Icon(Icons.search),
              onChanged: _searchFamilies,
            ),
          ),
          Expanded(
            child: Consumer<FamilyProvider>(
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
                          onPressed: _loadFamilies,
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  );
                }

                if (familyProvider.families.isEmpty) {
                  return const Center(child: Text('Belum ada data keluarga'));
                }

                return RefreshIndicator(
                  onRefresh: () async => _loadFamilies(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: familyProvider.families.length,
                    itemBuilder: (context, index) {
                      final family = familyProvider.families[index];
                      return _FamilyCard(family: family);
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

class _FamilyCard extends StatelessWidget {
  final FamilyListModel family;

  const _FamilyCard({required this.family});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          context.pushNamed(
            'family_detail',
            pathParameters: {'id': family.id.toString()},
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                family.namaKeluarga,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Kepala Keluarga: ${family.kepalaKeluarga}'),
              Text('Alamat: ${family.alamatRumah}'),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: family.status == 'Aktif'
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      family.status,
                      style: TextStyle(
                        fontSize: 12,
                        color: family.status == 'Aktif'
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    family.statusKepemilikan,
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

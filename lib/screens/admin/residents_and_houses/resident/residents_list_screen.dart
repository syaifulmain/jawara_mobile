import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/resident_provider.dart';
import '../../../../models/resident/resident_list_model.dart';
import '../../../../widgets/custom_text_form_field.dart';

class ResidentsListScreen extends StatefulWidget {
  const ResidentsListScreen({Key? key}) : super(key: key);

  @override
  State<ResidentsListScreen> createState() => _ResidentsListScreenState();
}

class _ResidentsListScreenState extends State<ResidentsListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadResidents();
    });
  }

  void _loadResidents() {
    final authProvider = context.read<AuthProvider>();
    final residentProvider = context.read<ResidentProvider>();

    if (authProvider.token != null) {
      residentProvider.fetchResidents(authProvider.token!);
    }
  }

  void _searchResidents(String query) {
    final authProvider = context.read<AuthProvider>();
    final residentProvider = context.read<ResidentProvider>();

    if (authProvider.token != null) {
      if (query.isEmpty) {
        residentProvider.fetchResidents(authProvider.token!);
      } else {
        residentProvider.searchResidents(authProvider.token!, query);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Penduduk')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomTextFormField(
              controller: _searchController,
              hintText: 'Cari penduduk...',
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _searchResidents('');
                      },
                    )
                  : null,
              prefixIcon: const Icon(Icons.search),
              onChanged: _searchResidents,
            ),
          ),
          Expanded(
            child: Consumer<ResidentProvider>(
              builder: (context, residentProvider, child) {
                if (residentProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (residentProvider.errorMessage != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error: ${residentProvider.errorMessage}',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadResidents,
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  );
                }

                if (residentProvider.residents.isEmpty) {
                  return const Center(child: Text('Belum ada data penduduk'));
                }

                return RefreshIndicator(
                  onRefresh: () async => _loadResidents(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: residentProvider.residents.length,
                    itemBuilder: (context, index) {
                      final resident = residentProvider.residents[index];
                      return _ResidentCard(resident: resident);
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

class _ResidentCard extends StatelessWidget {
  final ResidentListModel resident;

  const _ResidentCard({required this.resident});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          context.pushNamed('resident_detail', pathParameters: {'id': resident.id.toString()});
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                resident.nama,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text('NIK: ${resident.nik}'),
              Text('Keluarga: ${resident.keluarga ?? '-'}'),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: resident.isActive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      resident.isActive ? 'Aktif' : 'Tidak Aktif',
                      style: TextStyle(
                        fontSize: 12,
                        color: resident.isActive ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    resident.statusDomisili,
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

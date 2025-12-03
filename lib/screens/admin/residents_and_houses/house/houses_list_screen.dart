import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/address_provider.dart';
import '../../../../models/address/address_list_model.dart';
import '../../../../widgets/custom_text_form_field.dart';
import '../../../../widgets/info_banner.dart';

class HousesListScreen extends StatefulWidget {
  const HousesListScreen({Key? key}) : super(key: key);

  @override
  State<HousesListScreen> createState() => _HousesListScreenState();
}

class _HousesListScreenState extends State<HousesListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadHouses();
    });
  }

  void _loadHouses() {
    final authProvider = context.read<AuthProvider>();
    final addressProvider = context.read<AddressProvider>();

    if (authProvider.token != null) {
      addressProvider.fetchAddresses(authProvider.token!);
    }
  }

  void _searchHouses(String query) {
    final authProvider = context.read<AuthProvider>();
    final addressProvider = context.read<AddressProvider>();

    if (authProvider.token != null) {
      if (query.isEmpty) {
        addressProvider.fetchAddresses(authProvider.token!);
      } else {
        addressProvider.searchAddresses(authProvider.token!, query);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Rumah')),
      body: Column(
        children: [
          const InfoBanner(
            message: 'Daftar rumah/alamat yang terdaftar di sistem. Gunakan pencarian untuk menemukan rumah tertentu. Klik item untuk melihat detail.',
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomTextFormField(
              controller: _searchController,
              hintText: 'Cari rumah...',
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _searchHouses('');
                      },
                    )
                  : null,
              prefixIcon: const Icon(Icons.search),
              onChanged: _searchHouses,
            ),
          ),
          Expanded(
            child: Consumer<AddressProvider>(
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
                          onPressed: _loadHouses,
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  );
                }

                if (addressProvider.addresses.isEmpty) {
                  return const Center(child: Text('Belum ada data rumah'));
                }

                return RefreshIndicator(
                  onRefresh: () async => _loadHouses(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: addressProvider.addresses.length,
                    itemBuilder: (context, index) {
                      final house = addressProvider.addresses[index];
                      return _HouseCard(house: house);
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

class _HouseCard extends StatelessWidget {
  final AddressListModel house;

  const _HouseCard({required this.house});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          context.pushNamed(
            'house_detail',
            pathParameters: {'id': house.id.toString()},
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                house.alamat,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: house.status == 'Ditempati'
                          ? Colors.green.withOpacity(0.1)
                          : Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      house.status,
                      style: TextStyle(
                        fontSize: 12,
                        color: house.status == 'Ditempati'
                            ? Colors.green
                            : Colors.orange,
                      ),
                    ),
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

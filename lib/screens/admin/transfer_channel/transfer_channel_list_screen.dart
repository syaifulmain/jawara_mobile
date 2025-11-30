import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/transfer_channel_provider.dart';
import '../../../constants/color_constant.dart';
import '../../../widgets/custom_text_form_field.dart';

class TransferChannelListScreen extends StatefulWidget {
  const TransferChannelListScreen({Key? key}) : super(key: key);

  @override
  State<TransferChannelListScreen> createState() => _TransferChannelListScreenState();
}

class _TransferChannelListScreenState extends State<TransferChannelListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTransferChannels();
    });
  }

  void _loadTransferChannels() {
    final authProvider = context.read<AuthProvider>();
    final transferChannelProvider = context.read<TransferChannelProvider>();
    final token = authProvider.token;

    if (token != null) {
      transferChannelProvider.fetchTransferChannels(token);
    }
  }

  void _searchTransferChannels(String query) {
    final authProvider = context.read<AuthProvider>();
    final transferChannelProvider = context.read<TransferChannelProvider>();
    final token = authProvider.token;

    if (token != null) {
      if (query.isEmpty) {
        transferChannelProvider.fetchTransferChannels(token);
      } else {
        transferChannelProvider.searchTransferChannels(token, query);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Saluran Transfer')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomTextFormField(
              controller: _searchController,
              hintText: 'Cari saluran transfer...',
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _searchTransferChannels('');
                      },
                    )
                  : null,
              prefixIcon: const Icon(Icons.search),
              onChanged: _searchTransferChannels,
            ),
          ),
          Expanded(
            child: Consumer<TransferChannelProvider>(
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
                          onPressed: () => _loadTransferChannels(),
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  );
                }

                if (provider.transferChannels.isEmpty) {
                  return const Center(child: Text('Belum ada data saluran transfer'));
                }

                return RefreshIndicator(
                  onRefresh: () async => _loadTransferChannels(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: provider.transferChannels.length,
                    itemBuilder: (context, index) {
                      final channel = provider.transferChannels[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                            child: Icon(
                              Icons.account_balance_wallet,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          title: Text(
                            channel.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text('Tipe: ${channel.type}'),
                              Text('Pemilik: ${channel.ownerName}'),
                            ],
                          ),
                        ),
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

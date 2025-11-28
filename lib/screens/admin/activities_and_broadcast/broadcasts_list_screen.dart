import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/broadcast_provider.dart';
import '../../../models/broadcast_model.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_form_field.dart';

class BroadcastsListScreen extends StatefulWidget {
  const BroadcastsListScreen({Key? key}) : super(key: key);

  @override
  State<BroadcastsListScreen> createState() => _BroadcastsListScreenState();
}

class _BroadcastsListScreenState extends State<BroadcastsListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBroadcasts();
    });
  }

  void _loadBroadcasts() {
    final authProvider = context.read<AuthProvider>();
    final broadcastProvider = context.read<BroadcastProvider>();

    if (authProvider.token != null) {
      broadcastProvider.fetchBroadcasts(authProvider.token!);
    }
  }

  void _searchBroadcasts(String query) {
    final authProvider = context.read<AuthProvider>();
    final broadcastProvider = context.read<BroadcastProvider>();

    if (authProvider.token != null) {
      if (query.isEmpty) {
        broadcastProvider.fetchBroadcasts(authProvider.token!);
      } else {
        broadcastProvider.searchBroadcasts(authProvider.token!, query);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Broadcast')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomTextFormField(
              controller: _searchController,
              hintText: 'Cari broadcast...',
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  _searchBroadcasts('');
                },
              )
                  : null,
              prefixIcon: const Icon(Icons.search),
              onChanged: _searchBroadcasts,
            ),
          ),
          Expanded(
            child: Consumer<BroadcastProvider>(
              builder: (context, broadcastProvider, child) {
                if (broadcastProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (broadcastProvider.errorMessage != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error: ${broadcastProvider.errorMessage}',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadBroadcasts,
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  );
                }

                if (broadcastProvider.broadcasts.isEmpty) {
                  return const Center(child: Text('Belum ada broadcast'));
                }

                return RefreshIndicator(
                  onRefresh: () async => _loadBroadcasts(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: broadcastProvider.broadcasts.length,
                    itemBuilder: (context, index) {
                      final broadcast = broadcastProvider.broadcasts[index];
                      return _BroadcastCard(broadcast: broadcast);
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

class _BroadcastCard extends StatelessWidget {
  final Broadcast broadcast;

  const _BroadcastCard({required this.broadcast});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          if (broadcast.id != null) {
            context.pushNamed(
              'broadcast_detail',
              pathParameters: {'id': broadcast.id.toString()},
            );
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                broadcast.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                broadcast.message,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.person, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    broadcast.creatorName ?? 'Unknown',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: 16),
                  if (broadcast.publishedAt != null) ...[
                    const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      dateFormat.format(broadcast.publishedAt!),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
              if (broadcast.photo != null || broadcast.document != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (broadcast.photo != null)
                      const Chip(
                        label: Text('Foto'),
                        avatar: Icon(Icons.image, size: 16),
                      ),
                    if (broadcast.document != null) ...[
                      const SizedBox(width: 8),
                      const Chip(
                        label: Text('Dokumen'),
                        avatar: Icon(Icons.attach_file, size: 16),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

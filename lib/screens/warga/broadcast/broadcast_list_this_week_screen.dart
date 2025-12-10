import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/broadcast_provider.dart';
import '../../../models/broadcast_model.dart';
import '../../../widgets/custom_chip.dart';
import '../../../widgets/info_banner.dart';

class BroadcastListThisWeekScreen extends StatefulWidget {
  const BroadcastListThisWeekScreen({Key? key}) : super(key: key);

  @override
  State<BroadcastListThisWeekScreen> createState() => _BroadcastListThisWeekScreenState();
}

class _BroadcastListThisWeekScreenState extends State<BroadcastListThisWeekScreen> {
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
      broadcastProvider.fetchBroadcastsThisWeek(authProvider.token!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Broadcast Minggu Ini'),
      ),
      body: Column(
        children: [
          const InfoBanner(
            message: 'Daftar broadcast yang diterbitkan minggu ini. Klik item untuk melihat detail broadcast.',
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
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.campaign_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Belum ada broadcast minggu ini',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
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
}

class _BroadcastCard extends StatelessWidget {
  final Broadcast broadcast;

  const _BroadcastCard({required this.broadcast});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');

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
              Row(
                children: [
                  Expanded(
                    child: Text(
                      broadcast.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    dateFormat.format(broadcast.publishedAt ?? DateTime.now()),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              if (broadcast.message.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    broadcast.message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    if (broadcast.id != null) {
                      context.pushNamed(
                        'broadcast_detail',
                        pathParameters: {'id': broadcast.id.toString()},
                      );
                    }
                  },
                  child: const Text('Lihat Detail'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../widgets/menu_list_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.logout();
              if (context.mounted) {
                context.goNamed('login');
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
                      child: Icon(Icons.person, size: 30, color: Theme.of(context).primaryColor),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selamat Datang,',
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.name,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            user.isAdmin ? 'Administrator' : 'User',
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Menu Utama',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            MenuListTile(
              icon: Icons.analytics,
              title: 'Dashboard',
              subtitle: 'Lihat ringkasan data',
              color: Colors.teal,
              onTap: () => context.pushNamed('dashboard_menu')
            ),
            const SizedBox(height: 12),
            MenuListTile(
              icon: Icons.event,
              title: 'Kegiatan dan Broadcast',
              subtitle: 'Kelola kegiatan dan broadcast',
              color: Colors.red,
              onTap: () => context.pushNamed('activities_and_broadcast_menu'),
            ),
            if (user.isAdmin) ...[
              const SizedBox(height: 12),
              MenuListTile(
                icon: Icons.people,
                title: 'Users',
                subtitle: 'Kelola data pengguna',
                color: Colors.green,
                onTap: () => context.pushNamed('users'),
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}

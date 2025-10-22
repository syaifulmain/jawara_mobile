import 'package:go_router/go_router.dart';
import 'package:jawara_mobile/screens/auth/login.dart';
import 'package:jawara_mobile/screens/auth/register.dart';
import 'package:jawara_mobile/screens/dashboard/activity_list_screen.dart';
import 'package:jawara_mobile/screens/dashboard/add_activity_screen.dart';
import 'package:jawara_mobile/screens/placeholder.dart';
import 'package:jawara_mobile/screens/dashboard/broadcast_list_screen.dart';

final router = GoRouter(
  initialLocation: "/login",
  routes: [
    GoRoute(path: '/', redirect: (context, state) => '/login'),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => RegisterScreen(),
    ),
    GoRoute(
      path: '/activities',
      name: 'activities',
      builder: (context, state) => const ActivityListScreen(), // <--- Layar Kegiatan
    ),
    GoRoute(
      path: '/activities/add',
      name: 'add_activity',
      builder: (context, state) => const AddActivityScreen(),
    ),
    GoRoute(
      path: '/broadcast/list',
      name: 'broadcast_list',
      builder: (context, state) => const BroadcastListScreen(),
    ),
    GoRoute(
      path: '/broadcast/add',
      name: 'broadcast_add',
      builder: (context, state) => const PlaceholderScreen(), 
    ),
    GoRoute(
      path: '/placeholder',
      name: 'placeholder',
      builder: (context, state) => const PlaceholderScreen(),
    ),
  ],
);

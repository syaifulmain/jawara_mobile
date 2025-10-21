import 'package:go_router/go_router.dart';
import 'package:jawara_mobile/screens/admin/layout.dart';
import 'package:jawara_mobile/screens/auth/login.dart';
import 'package:jawara_mobile/screens/auth/register.dart';
import 'package:jawara_mobile/screens/placeholder.dart';

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
      path: '/admin',
      name: 'admin',
      builder: (context, state) => const AdminLayoutScreen(),
    ),
    GoRoute(
      path: '/placeholder',
      name: 'placeholder',
      builder: (context, state) => const PlaceholderScreen(),
    ),
  ],
);

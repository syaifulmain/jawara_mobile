import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../routers/routes_config.dart';
import '../screens/auth/login_screen.dart';
import '../providers/auth_provider.dart';
import '../screens/auth/register_screen.dart';

GoRouter createAppRouter(AuthProvider authProvider) {
  return GoRouter(
    refreshListenable: authProvider,
    redirect: (context, state) {
      final isAuthenticated = authProvider.isAuthenticated;
      final isInitialized = authProvider.isInitialized;
      final currentPath = state.matchedLocation;
      final isLoginRoute = currentPath == '/login';
      final isRegisterRoute = currentPath == '/register';

      // Wait for initialization
      if (!isInitialized) {
        return null;
      }

      // Allow access to login and register without authentication
      if (isLoginRoute || isRegisterRoute) {
        if (isAuthenticated) {
          return '/'; // Redirect to home if already logged in
        }
        return null; // Allow access to login/register
      }

      // Redirect to login if not authenticated and not on login/register
      if (!isAuthenticated) {
        return '/login';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      ...RoutesConfig.routes.map((routeItem) {
        return GoRoute(
          path: routeItem.path,
          name: routeItem.name,
          builder: routeItem.builder,
        );
      }).toList(),
    ],
  );
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../routers/routes_config.dart';
import '../screens/auth/login_screen.dart';
import '../providers/auth_provider.dart';
import '../screens/auth/register_screen.dart';
import '../screens/splash_screen.dart'; // <-- 1. Import SplashScreen

GoRouter createAppRouter(AuthProvider authProvider) {
  return GoRouter(
    refreshListenable: authProvider,
    initialLocation: '/splash', // <-- 2. Ubah lokasi awal aplikasi
    redirect: (context, state) {
      final isAuthenticated = authProvider.isAuthenticated;
      final isInitialized = authProvider.isInitialized;
      final currentPath = state.matchedLocation;

      // LOGIKA BARU: Penanganan Splash Screen
      // Jika AuthProvider belum selesai loading awal...
      if (!isInitialized) {
        // ...dan kita belum ada di splash screen, paksa ke splash screen.
        if (currentPath != '/splash') {
          return '/splash';
        }
        // Jika sudah di splash screen, diam di tempat (return null).
        return null;
      }

      // --- Logika di bawah ini berjalan HANYA JIKA isInitialized == true ---

      // Jika init selesai, tapi kita masih di /splash,
      // Tentukan mau ke Home atau Login berdasarkan status auth.
      if (currentPath == '/splash') {
        return isAuthenticated ? '/' : '/login';
      }

      // --- Logika Auth standar (yang lama) ---
      final isLoginRoute = currentPath == '/login';
      final isRegisterRoute = currentPath == '/register';

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

      // If authenticated and trying to access protected route, allow it.
      return null;
    },
    routes: [
      // <-- 3. Daftarkan Route Splash Screen
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
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
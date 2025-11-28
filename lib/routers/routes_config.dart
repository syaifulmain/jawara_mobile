import 'package:flutter/material.dart';
import 'package:jawara_mobile_v2/screens/admin/activities_and_broadcast/activities_and_broadcast_menu_screen.dart';
import 'package:jawara_mobile_v2/screens/admin/activities_and_broadcast/activities_list_screen.dart';
import 'package:jawara_mobile_v2/screens/admin/activities_and_broadcast/add_activity_screen.dart';
import 'package:jawara_mobile_v2/screens/admin/activities_and_broadcast/broadcasts_list_screen.dart';
import 'package:jawara_mobile_v2/screens/admin/activities_and_broadcast/add_broadcast_screen.dart';
import 'package:jawara_mobile_v2/screens/admin/dashboard/population_screen.dart';
import '../screens/admin/activities_and_broadcast/activity_detail_screen.dart';
import '../screens/admin/activities_and_broadcast/broadcast_detail_screen.dart';
import '../screens/admin/dashboard/activities_screen.dart';
import '../screens/admin/dashboard/dashboard_menu_screen.dart';
import '../screens/admin/dashboard/finance_screen.dart';
import 'app_route_item.dart';
import '../screens/home_screen.dart';

class RoutesConfig {
  static final List<AppRouteItem> routes = [
    AppRouteItem(
      path: '/',
      name: 'home',
      label: 'Beranda',
      builder: (context, state) => const HomeScreen(),
    ),
    // ACTIVITIES AND BROADCAST ROUTES
    AppRouteItem(
      path: '/activities-and-broadcast-menu',
      name: 'activities_and_broadcast_menu',
      label: 'Kegiatan & Broadcast',
      builder: (context, state) => const ActivitiesAndBroadcastMenuScreen(),
    ),
    AppRouteItem(
      path: '/activities-list',
      name: 'activities_list',
      label: 'Daftar Kegiatan',
      builder: (context, state) => const ActivitiesListScreen(),
    ),
    AppRouteItem(
      path: '/add-activity',
      name: 'add_activity',
      label: 'Tambah Kegiatan',
      builder: (context, state) => const AddActivityScreen(),
    ),
    AppRouteItem(
      path: '/activities/:id',  // tanpa leading slash jika nested
      name: 'activity_detail',
      label: 'Detail Kegiatan',
      builder: (context, state) {
        final activityId = state.pathParameters['id']!;
        return ActivityDetailScreen(activityId: activityId);
      },
    ),
    AppRouteItem(
      path: '/broadcasts-list',
      name: 'broadcasts_list',
      label: 'Daftar Broadcast',
      builder: (context, state) => const BroadcastsListScreen(),
    ),
    AppRouteItem(
      path: '/add-broadcast',
      name: 'add_broadcast',
      label: 'Tambah Broadcast',
      builder: (context, state) => const AddBroadcastScreen(),
    ),
    AppRouteItem(
      path: '/broadcasts/:id',  // tanpa leading slash jika nested
      name: 'broadcast_detail',
      label: 'Detail Broadcast',
      builder: (context, state) {
        final broadcastId = state.pathParameters['id']!;
        return BroadcastDetailScreen(broadcastId: broadcastId);
      }
    ),
    // DASHBOARD SUB-ROUTES
    AppRouteItem(
      path: '/dashboard-menu',
      name: 'dashboard_menu',
      label: 'Dashboard',
      builder: (context, state) => const DashboardMenuScreen(),
    ),
    AppRouteItem(
      path: '/dashboard-menu/finance',
      name: 'dashboard-finance',
      label: 'Keuangan',
      builder: (context, state) => const FinanceScreen(),
    ),
    AppRouteItem(
      path: '/dashboard-menu/activities',
      name: 'dashboard-activities',
      label: 'Kegiatan',
      builder: (context, state) => const ActivitiesScreen(),
    ),
    AppRouteItem(
      path: '/dashboard-menu/population',
      name: 'dashboard-population',
      label: 'Kependudukan',
      builder: (context, state) => const PopulationScreen(),
    ),
  ];
}

import 'package:flutter/material.dart';
import 'package:jawara_mobile/screens/dashboard/activity_list_screen.dart';
import 'package:jawara_mobile/widgets/layout/custom_sidebar.dart';
import 'package:jawara_mobile/widgets/layout/broadcast_list_table.dart';

class BroadcastListScreen extends StatefulWidget {
  const BroadcastListScreen({super.key});

  @override
  State<BroadcastListScreen> createState() => _BroadcastListScreenState();
}

class _BroadcastListScreenState extends State<BroadcastListScreen> {
  double _sidebarWidth = 280;
  final double _collapsedWidth = 60; 

  void _toggleSidebar() {
    setState(() {
      _sidebarWidth = (_sidebarWidth == 280) ? _collapsedWidth : 280;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // --- 1. Sidebar ---
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: _sidebarWidth, 
            child: CustomSidebar(isCollapsed: _sidebarWidth == _collapsedWidth), 
          ),
          
          // --- 2. Konten Tabel Utama ---
          Expanded(
            child: Column(
              children: <Widget>[
                MinimalHeader(onToggle: _toggleSidebar), 
                
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: BroadcastListTable(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
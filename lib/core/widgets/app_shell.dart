import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/announcements/presentation/providers/announcements_provider.dart';
import '../../features/auth/data/models/app_user.dart';
import '../providers/auth_provider.dart';

class AppShell extends ConsumerWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final unreadCount = ref.watch(unreadCountProvider);
    final items = _navItems(user, unreadCount);

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex(navigationShell.currentIndex, user),
        onDestinationSelected: (i) => _onTap(i, user),
        destinations: items.map((item) => NavigationDestination(
          icon: Badge(
            isLabelVisible: item.badge > 0,
            label: Text('${item.badge}'),
            child: Icon(item.icon),
          ),
          selectedIcon: Icon(item.activeIcon),
          label: item.label,
        )).toList(),
      ),
    );
  }

  List<_NavItem> _navItems(AppUser? user, int unreadCount) {
    final items = [
      _NavItem('Home', Icons.home_outlined, Icons.home, 0),
      _NavItem('Schedule', Icons.calendar_today_outlined, Icons.calendar_today, 0),
      _NavItem('Check In', Icons.qr_code_outlined, Icons.qr_code, 0),
      _NavItem('Library', Icons.library_books_outlined, Icons.library_books, 0),
      _NavItem('News', Icons.campaign_outlined, Icons.campaign, unreadCount),
    ];

    if (user?.isCoachOrOwner ?? false) {
      items.add(_NavItem('Coaches', Icons.sports_outlined, Icons.sports, 0));
    }

    items.add(_NavItem('Compete', Icons.emoji_events_outlined, Icons.emoji_events, 0));

    return items;
  }

  // The shell has fixed branches including the coaches branch (index 5).
  // When the user is a member, we skip that branch index in the visual nav.
  void _onTap(int visualIndex, AppUser? user) {
    final branchIndex = _branchIndex(visualIndex, user);
    navigationShell.goBranch(
      branchIndex,
      initialLocation: branchIndex == navigationShell.currentIndex,
    );
  }

  int _selectedIndex(int branchIndex, AppUser? user) {
    if (user?.isCoachOrOwner ?? false) return branchIndex;
    // Skip branch 5 (coaches) for members
    if (branchIndex >= 5) return branchIndex - 1;
    return branchIndex;
  }

  int _branchIndex(int visualIndex, AppUser? user) {
    if (user?.isCoachOrOwner ?? false) return visualIndex;
    // Members: visual indices 0-4 map to branches 0-4, visual 5 → branch 6
    if (visualIndex >= 5) return visualIndex + 1;
    return visualIndex;
  }
}

class _NavItem {
  _NavItem(this.label, this.icon, this.activeIcon, this.badge);
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final int badge;
}

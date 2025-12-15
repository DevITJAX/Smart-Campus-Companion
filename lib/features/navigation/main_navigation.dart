import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_theme.dart';
import '../../injection_container.dart' as di;
import '../auth/presentation/bloc/auth_bloc.dart';
import '../auth/domain/entities/user_entity.dart';
import '../home/presentation/bloc/home_bloc.dart';
import '../home/presentation/pages/home_page.dart';
import '../schedule/presentation/pages/schedule_page.dart';
import '../rooms/presentation/pages/rooms_page.dart';
import '../services/presentation/pages/services_page.dart';
import '../profile/presentation/pages/profile_page.dart';
import '../admin/presentation/pages/admin_panel_page.dart';

/// Main navigation shell with bottom navigation bar
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  void _navigateToTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  /// Build pages list based on user role
  List<Widget> _buildPages(bool isAdmin) {
    final pages = <Widget>[
      BlocProvider(
        create: (_) => di.sl<HomeBloc>(),
        child: HomePage(onNavigateToTab: _navigateToTab),
      ),
      const SchedulePage(),
      const RoomsPage(),
      const ServicesPage(),
      const ProfilePage(),
    ];

    // Add Admin Panel for admin users
    if (isAdmin) {
      pages.add(const AdminPanelPage());
    }

    return pages;
  }

  /// Build navigation destinations based on user role
  List<NavigationDestination> _buildDestinations(bool isAdmin) {
    final destinations = <NavigationDestination>[
      const NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home),
        label: 'Home',
      ),
      const NavigationDestination(
        icon: Icon(Icons.calendar_today_outlined),
        selectedIcon: Icon(Icons.calendar_today),
        label: 'Schedule',
      ),
      const NavigationDestination(
        icon: Icon(Icons.meeting_room_outlined),
        selectedIcon: Icon(Icons.meeting_room),
        label: 'Rooms',
      ),
      const NavigationDestination(
        icon: Icon(Icons.miscellaneous_services_outlined),
        selectedIcon: Icon(Icons.miscellaneous_services),
        label: 'Services',
      ),
      const NavigationDestination(
        icon: Icon(Icons.person_outlined),
        selectedIcon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];

    // Add Admin tab for admin users
    if (isAdmin) {
      destinations.add(
        const NavigationDestination(
          icon: Icon(Icons.admin_panel_settings_outlined),
          selectedIcon: Icon(Icons.admin_panel_settings),
          label: 'Admin',
        ),
      );
    }

    return destinations;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      },
      builder: (context, state) {
        // Check if user is admin
        final bool isAdmin = state is AuthAuthenticated && state.user.isAdmin;
        
        final pages = _buildPages(isAdmin);
        final destinations = _buildDestinations(isAdmin);
        
        // Reset index if it exceeds available pages (e.g., when role changes)
        final safeIndex = _currentIndex >= pages.length ? 0 : _currentIndex;

        return Scaffold(
          body: IndexedStack(
            index: safeIndex,
            children: pages,
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: safeIndex,
            onDestinationSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            destinations: destinations,
            backgroundColor: Theme.of(context).colorScheme.surface,
            indicatorColor: AppTheme.primaryColor.withValues(alpha: 0.2),
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          ),
        );
      },
    );
  }
}

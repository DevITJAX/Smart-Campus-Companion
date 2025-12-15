import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_theme.dart';
import '../../injection_container.dart' as di;
import '../auth/presentation/bloc/auth_bloc.dart';
import '../home/presentation/bloc/home_bloc.dart';
import '../home/presentation/pages/home_page.dart';
import '../schedule/presentation/pages/schedule_page.dart';
import '../rooms/presentation/pages/rooms_page.dart';
import '../services/presentation/pages/services_page.dart';
import '../profile/presentation/pages/profile_page.dart';

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

  List<Widget> get _pages => [
    BlocProvider(
      create: (_) => di.sl<HomeBloc>(),
      child: HomePage(onNavigateToTab: _navigateToTab),
    ),
    const SchedulePage(),
    const RoomsPage(),
    const ServicesPage(),
    const ProfilePage(),
  ];

  final List<NavigationDestination> _destinations = const [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(Icons.calendar_today_outlined),
      selectedIcon: Icon(Icons.calendar_today),
      label: 'Schedule',
    ),
    NavigationDestination(
      icon: Icon(Icons.meeting_room_outlined),
      selectedIcon: Icon(Icons.meeting_room),
      label: 'Rooms',
    ),
    NavigationDestination(
      icon: Icon(Icons.miscellaneous_services_outlined),
      selectedIcon: Icon(Icons.miscellaneous_services),
      label: 'Services',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outlined),
      selectedIcon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          destinations: _destinations,
          backgroundColor: Theme.of(context).colorScheme.surface,
          indicatorColor: AppTheme.primaryColor.withValues(alpha: 0.2),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/navigation/main_navigation.dart';
import 'features/profile/presentation/bloc/theme_bloc.dart';
import 'features/rest_announcements/presentation/pages/rest_announcements_page.dart';

/// Root widget of the application
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeState.themeMode,
          initialRoute: AppRoutes.login,
          routes: {
            AppRoutes.login: (context) => BlocProvider.value(
                  value: BlocProvider.of<AuthBloc>(context),
                  child: const LoginPage(),
                ),
            AppRoutes.register: (context) => BlocProvider.value(
                  value: BlocProvider.of<AuthBloc>(context),
                  child: const RegisterPage(),
                ),
            AppRoutes.main: (context) => const MainNavigation(),
            AppRoutes.restAnnouncements: (context) => const RestAnnouncementsPage(),
          },
          onGenerateRoute: (settings) {
            // Handle dynamic routes here
            return MaterialPageRoute(
              builder: (context) => const LoginPage(),
            );
          },
        );
      },
    );
  }
}

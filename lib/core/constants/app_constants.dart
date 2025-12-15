/// App-wide constants and configuration values
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Smart Campus Companion';
  static const String appVersion = '1.0.0';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String announcementsCollection = 'announcements';
  static const String schedulesCollection = 'schedules';
  static const String roomsCollection = 'rooms';
  static const String servicesCollection = 'services';

  // Hive Boxes
  static const String announcementsBox = 'announcements_box';
  static const String schedulesBox = 'schedules_box';
  static const String userBox = 'user_box';
  static const String settingsBox = 'settings_box';

  // SharedPreferences Keys
  static const String themeKey = 'theme_mode';
  static const String isFirstLaunchKey = 'is_first_launch';
  static const String authTokenKey = 'auth_token';

  // API URLs
  static const String quotesApiBaseUrl = 'https://zenquotes.io/api';
}

/// Route names for navigation
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String main = '/main';
  static const String schedule = '/schedule';
  static const String rooms = '/rooms';
  static const String roomDetails = '/room-details';
  static const String services = '/services';
  static const String serviceDetails = '/service-details';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String announcements = '/announcements';
  static const String announcementDetails = '/announcement-details';
}

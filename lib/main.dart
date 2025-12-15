import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

import 'app.dart';
import 'firebase_options.dart';
import 'injection_container.dart' as di;
import 'core/utils/firestore_seeder.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/profile/presentation/bloc/theme_bloc.dart';
import 'features/home/data/models/announcement_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Firebase with options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Seed Firestore with test data (only in debug mode, runs once)
  if (kDebugMode) {
    await FirestoreSeeder.seedAll();
  }

  // Initialize Hive
  await Hive.initFlutter();
  
  // Register Hive adapters
  Hive.registerAdapter(AnnouncementModelAdapter());

  // Initialize dependency injection
  await di.init();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<AuthBloc>()..add(AuthCheckRequested()),
        ),
        BlocProvider(
          create: (_) => di.sl<ThemeBloc>()..add(ThemeLoadRequested()),
        ),
      ],
      child: const App(),
    ),
  );
}

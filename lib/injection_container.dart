import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

// Core
import 'core/utils/network_info.dart';

// Auth Feature
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/sign_in_usecase.dart';
import 'features/auth/domain/usecases/sign_up_usecase.dart';
import 'features/auth/domain/usecases/sign_out_usecase.dart';
import 'features/auth/domain/usecases/get_current_user_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

// Home Feature
import 'features/home/data/datasources/announcement_remote_datasource.dart';
import 'features/home/data/datasources/announcement_local_datasource.dart';
import 'features/home/data/repositories/announcement_repository_impl.dart';
import 'features/home/domain/repositories/announcement_repository.dart';
import 'features/home/domain/usecases/get_announcements_usecase.dart';
import 'features/home/presentation/bloc/home_bloc.dart';

// Profile Feature
import 'features/profile/presentation/bloc/theme_bloc.dart';

// Quotes Feature
import 'features/quotes/data/datasources/quote_remote_datasource.dart';
import 'features/quotes/data/datasources/quote_local_datasource.dart';
import 'features/quotes/data/repositories/quote_repository_impl.dart';
import 'features/quotes/domain/repositories/quote_repository.dart';
import 'features/quotes/domain/usecases/get_quote_of_the_day_usecase.dart';
import 'features/quotes/presentation/bloc/quote_bloc.dart';

// Services Feature
import 'features/services/data/datasources/services_remote_datasource.dart';
import 'features/services/data/repositories/services_repository_impl.dart';
import 'features/services/presentation/bloc/services_bloc.dart';

// Rooms Feature
import 'features/rooms/data/datasources/rooms_remote_datasource.dart';
import 'features/rooms/data/repositories/rooms_repository_impl.dart';
import 'features/rooms/presentation/bloc/rooms_bloc.dart';

// Schedule Feature
import 'features/schedule/data/datasources/schedule_remote_datasource.dart';
import 'features/schedule/data/repositories/schedule_repository_impl.dart';
import 'features/schedule/presentation/bloc/schedule_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features

  // Auth
  sl.registerFactory(
    () => AuthBloc(
      signInUseCase: sl(),
      signUpUseCase: sl(),
      signOutUseCase: sl(),
      getCurrentUserUseCase: sl(),
    ),
  );

  // Home
  sl.registerFactory(
    () => HomeBloc(getAnnouncementsUseCase: sl()),
  );

  // Profile (Theme)
  sl.registerFactory(
    () => ThemeBloc(sharedPreferences: sl()),
  );

  // Quotes
  sl.registerFactory(
    () => QuoteBloc(getQuoteOfTheDayUseCase: sl()),
  );

  // Services
  sl.registerFactory(
    () => ServicesBloc(repository: sl()),
  );

  // Rooms
  sl.registerFactory(
    () => RoomsBloc(repository: sl()),
  );

  // Schedule
  sl.registerFactory(
    () => ScheduleBloc(repository: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => GetAnnouncementsUseCase(sl()));
  sl.registerLazySingleton(() => GetQuoteOfTheDayUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<AnnouncementRepository>(
    () => AnnouncementRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<QuoteRepository>(
    () => QuoteRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<ServicesRepository>(
    () => ServicesRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<RoomsRepository>(
    () => RoomsRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ScheduleRepository>(
    () => ScheduleRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl(),
      firestore: sl(),
    ),
  );
  sl.registerLazySingleton<AnnouncementRemoteDataSource>(
    () => AnnouncementRemoteDataSourceImpl(firestore: sl()),
  );
  sl.registerLazySingleton<AnnouncementLocalDataSource>(
    () => AnnouncementLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<QuoteRemoteDataSource>(
    () => QuoteRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<QuoteLocalDataSource>(
    () => QuoteLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<ServicesRemoteDataSource>(
    () => ServicesRemoteDataSourceImpl(firestore: sl()),
  );
  sl.registerLazySingleton<RoomsRemoteDataSource>(
    () => RoomsRemoteDataSourceImpl(firestore: sl()),
  );
  sl.registerLazySingleton<ScheduleRemoteDataSource>(
    () => ScheduleRemoteDataSourceImpl(firestore: sl()),
  );

  //! Core
  sl.registerLazySingleton(() => NetworkInfo(sl()));

  //! External
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => Dio());

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}


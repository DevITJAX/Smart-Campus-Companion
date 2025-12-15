import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';

part 'theme_event.dart';
part 'theme_state.dart';

/// BLoC for theme management
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final SharedPreferences sharedPreferences;

  ThemeBloc({required this.sharedPreferences}) : super(ThemeState.initial()) {
    on<ThemeLoadRequested>(_onLoadRequested);
    on<ThemeToggled>(_onThemeToggled);
  }

  Future<void> _onLoadRequested(
    ThemeLoadRequested event,
    Emitter<ThemeState> emit,
  ) async {
    final isDarkMode = sharedPreferences.getBool(AppConstants.themeKey) ?? false;
    emit(ThemeState(
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
    ));
  }

  Future<void> _onThemeToggled(
    ThemeToggled event,
    Emitter<ThemeState> emit,
  ) async {
    final newMode = state.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    
    await sharedPreferences.setBool(
      AppConstants.themeKey,
      newMode == ThemeMode.dark,
    );
    
    emit(ThemeState(themeMode: newMode));
  }
}

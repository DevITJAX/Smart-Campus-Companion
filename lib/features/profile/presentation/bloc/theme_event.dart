part of 'theme_bloc.dart';

/// Theme events
abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

/// Load theme from storage
class ThemeLoadRequested extends ThemeEvent {}

/// Toggle between light and dark mode
class ThemeToggled extends ThemeEvent {}

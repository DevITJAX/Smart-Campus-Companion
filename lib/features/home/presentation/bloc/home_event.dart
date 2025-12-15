part of 'home_bloc.dart';

/// Base class for home events
abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load announcements
class HomeLoadRequested extends HomeEvent {}

/// Event to refresh announcements
class HomeRefreshRequested extends HomeEvent {}

part of 'home_bloc.dart';

/// Base class for home states
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class HomeInitial extends HomeState {}

/// Loading state
class HomeLoading extends HomeState {}

/// Loaded state with announcements
class HomeLoaded extends HomeState {
  final List<AnnouncementEntity> announcements;

  const HomeLoaded({required this.announcements});

  @override
  List<Object?> get props => [announcements];
}

/// Error state
class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}

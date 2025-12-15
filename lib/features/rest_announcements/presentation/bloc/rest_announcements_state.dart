part of 'rest_announcements_bloc.dart';

/// Base class for REST Announcements states
abstract class RestAnnouncementsState extends Equatable {
  const RestAnnouncementsState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any action is taken
class RestAnnouncementsInitial extends RestAnnouncementsState {}

/// Loading state while fetching announcements
class RestAnnouncementsLoading extends RestAnnouncementsState {}

/// Loaded state with list of announcements
class RestAnnouncementsLoaded extends RestAnnouncementsState {
  final List<RestAnnouncementEntity> announcements;

  const RestAnnouncementsLoaded({required this.announcements});

  @override
  List<Object?> get props => [announcements];
}

/// Error state with user-friendly message
class RestAnnouncementsError extends RestAnnouncementsState {
  final String message;

  const RestAnnouncementsError({required this.message});

  @override
  List<Object?> get props => [message];
}

part of 'rest_announcements_bloc.dart';

/// Base class for REST Announcements events
abstract class RestAnnouncementsEvent extends Equatable {
  const RestAnnouncementsEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load announcements when the page is opened
class LoadRestAnnouncements extends RestAnnouncementsEvent {}

/// Event to retry loading after an error
class RetryLoadRestAnnouncements extends RestAnnouncementsEvent {}

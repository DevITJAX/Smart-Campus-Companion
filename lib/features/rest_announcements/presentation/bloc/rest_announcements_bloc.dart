import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/rest_announcement_entity.dart';
import '../../domain/usecases/get_rest_announcements_usecase.dart';

part 'rest_announcements_event.dart';
part 'rest_announcements_state.dart';

/// BLoC for managing REST Announcements state.
/// 
/// This BLoC handles:
/// - Loading announcements from the REST API
/// - Managing loading, success, and error states
/// - Retry functionality after errors
class RestAnnouncementsBloc
    extends Bloc<RestAnnouncementsEvent, RestAnnouncementsState> {
  final GetRestAnnouncementsUseCase getRestAnnouncementsUseCase;

  RestAnnouncementsBloc({required this.getRestAnnouncementsUseCase})
      : super(RestAnnouncementsInitial()) {
    // Register event handlers
    on<LoadRestAnnouncements>(_onLoadAnnouncements);
    on<RetryLoadRestAnnouncements>(_onRetryLoadAnnouncements);
  }

  /// Handles the initial load of announcements
  Future<void> _onLoadAnnouncements(
    LoadRestAnnouncements event,
    Emitter<RestAnnouncementsState> emit,
  ) async {
    // Emit loading state to show progress indicator
    emit(RestAnnouncementsLoading());

    // Call the use case (which uses async/await)
    final result = await getRestAnnouncementsUseCase();

    // Use dartz's fold to handle Either result
    result.fold(
      // On failure, emit error state with message
      (failure) => emit(RestAnnouncementsError(message: failure.message)),
      // On success, emit loaded state with announcements
      (announcements) =>
          emit(RestAnnouncementsLoaded(announcements: announcements)),
    );
  }

  /// Handles retry after an error (same logic as initial load)
  Future<void> _onRetryLoadAnnouncements(
    RetryLoadRestAnnouncements event,
    Emitter<RestAnnouncementsState> emit,
  ) async {
    emit(RestAnnouncementsLoading());

    final result = await getRestAnnouncementsUseCase();

    result.fold(
      (failure) => emit(RestAnnouncementsError(message: failure.message)),
      (announcements) =>
          emit(RestAnnouncementsLoaded(announcements: announcements)),
    );
  }
}
